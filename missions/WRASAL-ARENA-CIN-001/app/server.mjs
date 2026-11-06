#!/usr/bin/env node
/**
 * WRASAL-ARENA-CIN-001 — Cinematic Production Console (sandbox deployment).
 * Zero-dependency Node HTTP server: workspace browser, generation jobs,
 * monitoring, review station, export. Real jobs only — no simulated success.
 *
 * SECURITY GATE (production hardening, reviewer directive 2026-11-06 §02):
 *  - Auth: mutations (POST) require Bearer $ARENA_CIN_AUTH_TOKEN when set;
 *    without a token, mutations are loopback-only (public exposure = read-only).
 *  - Uploads: streamed to disk with byte cap (413 on overflow); binary contract.
 *  - Media validation: container+codec+dimension+duration policy AND head/tail
 *    frame decode via tools/validate_media.py (ftyp signature alone insufficient).
 *  - Storage: server-generated job ids; fixed filenames; isolated job dirs;
 *    client metadata never used in filesystem paths.
 *  - Metadata immutability: reported blob write-once; changes only via
 *    authenticated amendment log (append-only). QC decisions keep history.
 *  - Rate limit (per-IP ingest window) and storage quota (429 / 507).
 *  - Evidence integrity: tamper-evident hash chain per job + /verify endpoint.
 *
 * Env:
 *   PORT                          listen port (default 8787)
 *   ARENA_CIN_AUTH_TOKEN          bearer token required for mutations when set
 *   ARENA_CIN_RUNTIME             runtime dir override (default <repo>/.runtime)
 *   ARENA_CIN_MAX_UPLOAD_BYTES    ingest cap (default 67108864)
 *   ARENA_CIN_QUOTA_BYTES         jobs storage quota (default 2000000000)
 *   ARENA_CIN_RATE_LIMIT          ingest requests per window per IP (default 5)
 *   ARENA_CIN_RATE_WINDOW_S       window seconds (default 600)
 *   ARENA_CIN_PROVIDER_URL/KEY/MODEL  external provider contract (see deployment doc)
 */
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
import { spawn } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const APP = path.dirname(fileURLToPath(import.meta.url));
const MISSION = path.resolve(APP, '..');
const REPO = path.resolve(MISSION, '..', '..');
const RUNTIME = process.env.ARENA_CIN_RUNTIME ? path.resolve(process.env.ARENA_CIN_RUNTIME) : path.join(REPO, '.runtime');
const JOBS = path.join(RUNTIME, 'jobs');
const REJECTS = path.join(RUNTIME, 'ingest-rejects');
const RENDER = path.join(REPO, 'tools', 'render_plate_test.py');
const VALIDATE = path.join(REPO, 'tools', 'validate_media.py');
const ENCODER_DIR = path.join(REPO, 'tools', 'pylibs', 'av');
const UI = path.join(APP, 'ui', 'index.html');
const PORT = Number(process.env.PORT || 8787);
const TOKEN = process.env.ARENA_CIN_AUTH_TOKEN || null;
const AUTH_MODE = process.env.ARENA_CIN_AUTH_MODE || 'sandbox'; // 'sandbox' | 'production'
const SESSIONS = new Map();
const SESSION_TTL_MS = 8 * 3600 * 1000;
const SENSITIVE_SUB = new Set(['', '/media', '/metadata', '/manifest', '/qc', '/qc-history', '/verify']);
const MAX_UPLOAD = Number(process.env.ARENA_CIN_MAX_UPLOAD_BYTES || 64 * 1024 * 1024);
const QUOTA = Number(process.env.ARENA_CIN_QUOTA_BYTES || 2_000_000_000);
const RATE_LIMIT = Number(process.env.ARENA_CIN_RATE_LIMIT || 5);
const RATE_WINDOW = Number(process.env.ARENA_CIN_RATE_WINDOW_S || 600);
const LOOPBACK = new Set(['127.0.0.1', '::1', '::ffff:127.0.0.1']);

fs.mkdirSync(JOBS, { recursive: true });
fs.mkdirSync(REJECTS, { recursive: true });

const readJson = (p) => JSON.parse(fs.readFileSync(p, 'utf8'));
const sha256File = (p) => new Promise((res, rej) => {
  const h = crypto.createHash('sha256');
  fs.createReadStream(p).on('data', (d) => h.update(d)).on('end', () => res(h.digest('hex'))).on('error', rej);
});
const sha256Text = (t) => crypto.createHash('sha256').update(t).digest('hex');

function safeJoin(base, rel) {
  const p = path.normalize(path.join(base, rel));
  if (!p.startsWith(base + path.sep) && p !== base) return null;
  return p;
}

function dirSize(p) {
  let total = 0;
  const walk = (d) => {
    for (const e of fs.readdirSync(d, { withFileTypes: true })) {
      const f = path.join(d, e.name);
      if (e.isDirectory()) walk(f);
      else total += fs.statSync(f).size;
    }
  };
  if (fs.existsSync(p)) walk(p);
  return total;
}

const rateMap = new Map();
function rateOk(ip) {
  const now = Date.now();
  const arr = (rateMap.get(ip) || []).filter((t) => now - t < RATE_WINDOW * 1000);
  if (arr.length >= RATE_LIMIT) { rateMap.set(ip, arr); return false; }
  arr.push(now); rateMap.set(ip, arr); return true;
}

async function appendChain(dir, event, files) {
  const cp = path.join(dir, 'evidence-chain.json');
  const chain = fs.existsSync(cp) ? readJson(cp) : { job_id: path.basename(dir), entries: [] };
  const shas = {};
  for (const f of files) {
    const fp = path.join(dir, f);
    if (fs.existsSync(fp)) shas[f] = await sha256File(fp);
  }
  const prev = chain.entries.length ? chain.entries[chain.entries.length - 1].hash : null;
  const entry = { seq: chain.entries.length, at: new Date().toISOString(), event, files: shas, prev };
  entry.hash = sha256Text(JSON.stringify({ seq: entry.seq, event, files: shas, prev }));
  chain.entries.push(entry);
  fs.writeFileSync(cp, JSON.stringify(chain, null, 2));
  return chain;
}

async function verifyChain(dir) {
  const cp = path.join(dir, 'evidence-chain.json');
  if (!fs.existsSync(cp)) return { ok: false, reasons: ['no evidence chain'] };
  const chain = readJson(cp);
  const reasons = [];
  let prev = null;
  const lastSeen = {};
  for (const e of chain.entries) {
    if (e.prev !== prev) reasons.push(`seq ${e.seq}: prev hash mismatch`);
    const expect = sha256Text(JSON.stringify({ seq: e.seq, event: e.event, files: e.files, prev: e.prev }));
    if (expect !== e.hash) reasons.push(`seq ${e.seq}: entry hash mismatch`);
    for (const [f, sha] of Object.entries(e.files)) lastSeen[f] = { sha, seq: e.seq };
    prev = e.hash;
  }
  // content integrity is asserted against the LATEST chained state of each file;
  // earlier entries are historical snapshots and are expected to differ after later events
  for (const [f, { sha, seq }] of Object.entries(lastSeen)) {
    const fp = path.join(dir, f);
    if (!fs.existsSync(fp)) reasons.push(`seq ${seq}: file ${f} missing`);
    else if ((await sha256File(fp)) !== sha) reasons.push(`seq ${seq}: file ${f} content changed since last chaining`);
  }
  return { ok: reasons.length === 0, reasons, entries: chain.entries.length };
}

function authOk(req) {
  // production mode FAILS CLOSED: no token configured => every mutation rejected
  if (AUTH_MODE === 'production') {
    return Boolean(TOKEN) && (req.headers.authorization || '') === `Bearer ${TOKEN}`;
  }
  if (TOKEN) return (req.headers.authorization || '') === `Bearer ${TOKEN}`;
  return LOOPBACK.has(req.socket.remoteAddress || ''); // sandbox dev convenience only
}

function mutAuthFail(res) {
  return send(res, 401, {
    error: AUTH_MODE === 'production' && !TOKEN ? 'auth not configured (production mode fails closed)' : 'unauthorized: bearer token required',
    code: TOKEN ? 'AUTH_REQUIRED' : (AUTH_MODE === 'production' ? 'AUTH_NOT_CONFIGURED' : 'LOOPBACK_ONLY'),
  });
}

function readOk(req) {
  // sensitive reads (footage, manifests, evidence) are gated in production mode
  if (AUTH_MODE !== 'production') return true;
  if (TOKEN && (req.headers.authorization || '') === `Bearer ${TOKEN}`) return true;
  const m = String(req.headers.cookie || '').match(/acin_session=([a-f0-9]{32})/);
  if (m && SESSIONS.has(m[1]) && SESSIONS.get(m[1]) > Date.now()) return true;
  return false;
}

function providers() {
  const encoderOk = fs.existsSync(ENCODER_DIR);
  return [
    { id: 'plate-render-techviz-v1', klass: 'tech-viz camera test (NOT AI generation)', configured: encoderOk, exit_if_missing: 'run: sh scripts/setup-encoder.sh (provisions PyAV/libx264 into tools/pylibs)' },
    { id: 'external-provider', klass: 'authorized external video provider (async HTTP contract)', configured: Boolean(process.env.ARENA_CIN_PROVIDER_URL), exit_if_missing: 'set ARENA_CIN_PROVIDER_URL and ARENA_CIN_PROVIDER_KEY in the deployment environment, or connect an Arena video connector; probes runway/sora/openai/luma all returned unsupported on 2026-11-06 (runway re-probed same date: unsupported)' },
    { id: 'external-ingest', klass: 'ingest of footage generated in another environment + as-reported metadata (binary contract, validated, chained)', configured: true, exit_if_missing: '' },
  ];
}

function plateForShot(shotId) {
  const clean = path.join(MISSION, 'reference', 'plates', 'prep', 'shot-C-clean.png');
  if (shotId === 'SHOT-C' && fs.existsSync(clean)) return clean;
  return path.join(MISSION, 'reference', 'plates', `shot-${shotId.slice(-1)}.png`);
}

function updateJob(job, patch) {
  Object.assign(job, patch);
  fs.writeFileSync(path.join(JOBS, job.id, 'job.json'), JSON.stringify(job, null, 2));
  return job;
}

async function runJob(job) {
  updateJob(job, { status: 'running', started_at: new Date().toISOString() });
  const dir = path.join(JOBS, job.id);
  const out = path.join(dir, 'out.mp4');
  const plate = plateForShot(job.shot_id);

  if (job.provider_id === 'plate-render-techviz-v1') {
    if (!fs.existsSync(ENCODER_DIR)) {
      updateJob(job, { status: 'blocked', error: { code: 'ENCODER_MISSING', exit: providers()[0].exit_if_missing, source_preserved: true }, finished_at: new Date().toISOString() });
      return;
    }
    const args = [RENDER, '--plate', plate, '--out', out,
      '--duration', String(job.params.duration_s), '--fps', String(job.params.fps),
      '--zoom', String(job.params.zoom), '--grain', String(job.params.grain)];
    const child = spawn('python3', args, { cwd: REPO });
    let err = '';
    child.stderr.on('data', (d) => { err = (err + d).slice(-2000); });
    child.on('close', async (code) => {
      const okRun = code === 0 && fs.existsSync(out) && fs.statSync(out).size > 20000;
      if (okRun) {
        const metadata = {
          adapter: 'plate-render-techviz-v1',
          class: 'tech-viz camera test (NOT AI generation)',
          encoder: 'PyAV 18.1.0 / libx264, crf 18, yuv420p',
          frames: Math.round(job.params.duration_s * job.params.fps),
          resolution: '960x412', fps: job.params.fps,
          camera_move: 'push-in per shot DNA amplitude', zoom: job.params.zoom, grain: job.params.grain,
          plate_sha256: await sha256File(plate),
          prompt_hash: job.prompt_hash,
          command: ['python3', ...args],
          finished_at: new Date().toISOString(),
        };
        fs.writeFileSync(path.join(dir, 'metadata.json'), JSON.stringify(metadata, null, 2));
        await appendChain(dir, 'job-completed', ['out.mp4', 'metadata.json']);
        updateJob(job, { status: 'succeeded', finished_at: metadata.finished_at });
      } else {
        updateJob(job, { status: 'failed', error: { code: 'RENDER_FAILED', exit_code: code, stderr_tail: err, source_preserved: true }, finished_at: new Date().toISOString() });
      }
    });
    return;
  }

  if (job.provider_id === 'external-provider') {
    const base = process.env.ARENA_CIN_PROVIDER_URL;
    if (!base) {
      updateJob(job, { status: 'blocked', error: { code: 'PROVIDER_UNCONFIGURED', exit: providers()[1].exit_if_missing, source_preserved: true }, finished_at: new Date().toISOString() });
      return;
    }
    try {
      const image = `data:image/png;base64,${fs.readFileSync(plate).toString('base64')}`;
      const sub = await fetch(base, {
        method: 'POST',
        headers: { 'content-type': 'application/json', ...(process.env.ARENA_CIN_PROVIDER_KEY ? { authorization: `Bearer ${process.env.ARENA_CIN_PROVIDER_KEY}` } : {}) },
        body: JSON.stringify({ model: process.env.ARENA_CIN_PROVIDER_MODEL || 'default', prompt: job.prompt_text, image, duration_s: job.params.duration_s, fps: job.params.fps, aspect: '2.39:1' }),
      });
      if (!sub.ok) throw new Error(`submit http ${sub.status}`);
      const sj = await sub.json();
      const jid = sj.job_id || sj.id;
      if (!jid) throw new Error('submit response missing job_id');
      updateJob(job, { provider_job_id: jid });
      const deadline = Date.now() + 600000;
      let videoUrl = null;
      while (Date.now() < deadline) {
        await new Promise((r) => setTimeout(r, 5000));
        const st = await fetch(`${base.replace(/\/$/, '')}/jobs/${jid}`, { headers: process.env.ARENA_CIN_PROVIDER_KEY ? { authorization: `Bearer ${process.env.ARENA_CIN_PROVIDER_KEY}` } : {} });
        const stj = await st.json();
        if (stj.status === 'succeeded' || stj.status === 'success') { videoUrl = stj.video_url || stj.output_url; break; }
        if (stj.status === 'failed' || stj.status === 'error') throw new Error(`provider job failed: ${stj.error || 'unknown'}`);
      }
      if (!videoUrl) throw new Error('provider poll timeout (600s)');
      const vid = await fetch(videoUrl);
      if (!vid.ok) throw new Error(`video download http ${vid.status}`);
      fs.writeFileSync(out, Buffer.from(await vid.arrayBuffer()));
      const metadata = { adapter: 'external-provider', provider_job_id: jid, video_url: videoUrl, plate_sha256: await sha256File(plate), prompt_hash: job.prompt_hash, finished_at: new Date().toISOString() };
      fs.writeFileSync(path.join(dir, 'metadata.json'), JSON.stringify(metadata, null, 2));
      await appendChain(dir, 'job-completed', ['out.mp4', 'metadata.json']);
      updateJob(job, { status: 'succeeded', finished_at: metadata.finished_at });
    } catch (e) {
      updateJob(job, { status: 'failed', error: { code: 'PROVIDER_ERROR', message: String(e.message || e), source_preserved: true }, finished_at: new Date().toISOString() });
    }
  }
}

function send(res, code, obj, type = 'application/json') {
  const body = type === 'application/json' ? JSON.stringify(obj) : obj;
  res.writeHead(code, { 'content-type': type, 'cache-control': 'no-store' });
  res.end(body);
}

async function workspace() {
  const scene = readJson(path.join(MISSION, 'data', 'scene_dna.json'));
  const shots = readJson(path.join(MISSION, 'data', 'shot_dna.json')).shots;
  const prompts = readJson(path.join(MISSION, 'data', 'prompts.json'));
  const caps = readJson(path.join(MISSION, 'data', 'capability_matrix.json'));
  const manifest = readJson(path.join(MISSION, 'data', 'manifest.json'));
  const plates = [];
  for (const entry of manifest.reference_and_plates) {
    const abs = path.join(MISSION, entry.path);
    plates.push({ ...entry, exists: fs.existsSync(abs), sha256_live: fs.existsSync(abs) ? await sha256File(abs) : null });
  }
  return {
    mission_id: 'WRASAL-ARENA-CIN-001',
    gates: scene.governance.gates,
    g0_status: scene.governance.g0_status,
    test_strategy: scene.governance.test_strategy,
    reference_rights: scene.governance.reference_rights,
    technical_envelope: scene.technical_envelope,
    palette: scene.palette,
    shots, prompts, capabilities: caps.capabilities, capability_evidence_log: caps.evidence_log,
    plates, providers: providers(),
    security: {
      auth_mode: AUTH_MODE === 'production'
        ? (TOKEN ? 'production: bearer token or session required for mutations AND sensitive reads (footage/manifests/evidence)' : 'production: FAIL-CLOSED, no token configured - all mutations and sensitive reads rejected')
        : (TOKEN ? 'sandbox: bearer-token required for mutations' : 'sandbox: no token configured, mutations loopback-only (dev convenience; never a production default)'),
      auth_mode_id: AUTH_MODE,
      fail_closed: AUTH_MODE === 'production' && !TOKEN,
      read_auth_required: AUTH_MODE === 'production',
      max_upload_bytes: MAX_UPLOAD, quota_bytes: QUOTA, rate_limit: `${RATE_LIMIT} ingest / ${RATE_WINDOW}s / ip`,
      media_validation: 'container+codec+dimensions+duration policy and head/tail decode (tools/validate_media.py)',
      evidence_chain: 'tamper-evident per-job hash chain; GET /api/jobs/:id/verify',
    },
    version: readJson(path.join(APP, 'VERSION.json')),
  };
}

const server = http.createServer(async (req, res) => {
  const url = new URL(req.url, `http://${req.headers.host || 'localhost'}`);
  const p = url.pathname;
  const ip = req.socket.remoteAddress || '?';
  try {
    if (req.method === 'GET' && (p === '/' || p === '/index.html')) {
      return send(res, 200, fs.readFileSync(UI, 'utf8'), 'text/html; charset=utf-8');
    }
    if (req.method === 'GET' && p === '/api/workspace') return send(res, 200, await workspace());
    if (req.method === 'GET' && p.startsWith('/api/plates/')) {
      const abs = safeJoin(path.join(MISSION, 'reference'), p.slice('/api/plates/'.length));
      if (!abs || !fs.existsSync(abs)) return send(res, 404, { error: 'not found' });
      res.writeHead(200, { 'content-type': 'image/png', 'cache-control': 'no-store' });
      return fs.createReadStream(abs).pipe(res);
    }
    if (req.method === 'POST' && p === '/api/auth/login') {
      let body = '';
      for await (const chunk of req) body += chunk;
      let t = null;
      try { t = JSON.parse(body || '{}').token; } catch { /* invalid */ }
      if (TOKEN && t === TOKEN) {
        const sid = crypto.randomBytes(16).toString('hex');
        SESSIONS.set(sid, Date.now() + SESSION_TTL_MS);
        res.writeHead(200, { 'set-cookie': `acin_session=${sid}; HttpOnly; Path=/; SameSite=Strict`, 'content-type': 'application/json', 'cache-control': 'no-store' });
        return res.end(JSON.stringify({ ok: true, mode: AUTH_MODE }));
      }
      return send(res, 401, { error: 'invalid token' });
    }
    if (req.method === 'GET' && p === '/api/jobs') {
      if (!readOk(req)) return send(res, 401, { error: TOKEN ? 'authentication required (production mode)' : 'auth not configured (production mode fails closed)', code: TOKEN ? 'AUTH_REQUIRED' : 'AUTH_NOT_CONFIGURED' });
      const ids = fs.readdirSync(JOBS).filter((d) => fs.existsSync(path.join(JOBS, d, 'job.json')));
      const jobs = ids.map((id) => readJson(path.join(JOBS, id, 'job.json')))
        .sort((a, b) => (a.created_at < b.created_at ? 1 : -1))
        .map((j) => ({ ...j, has_media: fs.existsSync(path.join(JOBS, j.id, 'out.mp4')) }));
      return send(res, 200, jobs);
    }

    if (req.method === 'POST' && p === '/api/jobs/ingest') {
      if (!authOk(req)) return mutAuthFail(res);
      if (!rateOk(ip)) return send(res, 429, { error: 'ingest rate limit exceeded', retry_after_s: RATE_WINDOW });
      if (dirSize(JOBS) > QUOTA) return send(res, 507, { error: 'storage quota exceeded', quota_bytes: QUOTA });
      const shotId = url.searchParams.get('shot');
      if (!/^SHOT-[A-D]$/.test(shotId || '')) return send(res, 400, { error: 'query param shot must be SHOT-A..SHOT-D' });
      const metaHeader = req.headers['x-arena-cin-meta'];
      let reported = {};
      if (metaHeader) {
        if (String(metaHeader).length > 65536) return send(res, 400, { error: 'x-arena-cin-meta too large (64 KB cap)' });
        try { reported = JSON.parse(Buffer.from(String(metaHeader), 'base64').toString('utf8')); } catch { return send(res, 400, { error: 'x-arena-cin-meta must be base64 JSON' }); }
      }
      const id = `job-ingest-${Date.now().toString(36)}-${crypto.randomBytes(3).toString('hex')}`;
      const dir = path.join(JOBS, id);
      fs.mkdirSync(dir, { recursive: true });
      const tmp = path.join(dir, 'upload.part');
      await new Promise((resolve, reject) => {
        let bytes = 0;
        let exceeded = false;
        const ws = fs.createWriteStream(tmp);
        req.on('data', (d) => {
          bytes += d.length;
          if (!exceeded && bytes > MAX_UPLOAD) {
            exceeded = true;
            req.unpipe(ws);
            ws.destroy();
            reject(Object.assign(new Error('upload exceeds cap'), { code: 413 }));
          }
        });
        req.pipe(ws);
        ws.on('finish', () => resolve(bytes));
        ws.on('error', (e) => { if (!exceeded) reject(e); });
      }).catch(async (e) => {
        fs.rmSync(tmp, { force: true });
        const rej = { at: new Date().toISOString(), shot: shotId, ip, reason: e.code === 413 ? 'upload exceeds cap' : String(e.message), bytes_seen: null };
        fs.writeFileSync(path.join(REJECTS, `${id}.json`), JSON.stringify(rej, null, 2));
        send(res, e.code === 413 ? 413 : 400, { error: rej.reason });
        setImmediate(() => { try { req.socket.destroy(); } catch { /* already gone */ } });
        return;
      });
      if (!fs.existsSync(tmp)) return;
      fs.renameSync(tmp, path.join(dir, 'out.mp4'));
      const val = spawn('python3', [VALIDATE, path.join(dir, 'out.mp4')]);
      let vout = '';
      val.stdout.on('data', (d) => { vout += d; });
      const vcode = await new Promise((r) => val.on('close', r));
      let vjson = { ok: false, reasons: ['validator produced no output'] };
      try { vjson = JSON.parse(vout); } catch { /* keep default */ }
      fs.writeFileSync(path.join(dir, 'media_validation.json'), JSON.stringify(vjson, null, 2));
      if (vcode !== 0 || !vjson.ok) {
        fs.mkdirSync(REJECTS, { recursive: true });
        fs.renameSync(path.join(dir, 'out.mp4'), path.join(REJECTS, `${id}.mp4`));
        fs.writeFileSync(path.join(REJECTS, `${id}.json`), JSON.stringify({ at: new Date().toISOString(), shot: shotId, ip, reasons: vjson.reasons, validation: vjson }, null, 2));
        fs.rmSync(dir, { recursive: true, force: true });
        return send(res, 422, { error: 'media validation failed', reasons: vjson.reasons, reject_record: `${id}.json` });
      }
      const plate = plateForShot(shotId);
      const metadata = {
        adapter: 'external-ingest',
        class: 'externally generated video ingested with as-reported metadata (provider claims require documentation before VERIFIED status per QC-900)',
        reported,
        ingest_source: url.searchParams.get('source') || 'external',
        plate_sha256: await sha256File(plate),
        prompt_hash: sha256Text(String(reported.prompt || '')),
        media_validation: vjson,
        ingested_at: new Date().toISOString(),
        immutable: true,
      };
      fs.writeFileSync(path.join(dir, 'metadata.json'), JSON.stringify(metadata, null, 2));
      const job = {
        id, shot_id: shotId, provider_id: 'external-ingest', status: 'succeeded',
        created_at: metadata.ingested_at, finished_at: metadata.ingested_at,
        params: reported.params || {}, prompt_text: String(reported.prompt || ''),
        prompt_hash: metadata.prompt_hash, plate: path.relative(REPO, plate),
        review: null, error: null,
        ingest: { source: metadata.ingest_source, reported_model: reported.model || null, reported_provider: reported.provider || null, generation_id: reported.generation_id || null },
      };
      fs.writeFileSync(path.join(dir, 'job.json'), JSON.stringify(job, null, 2));
      await appendChain(dir, 'ingest-written', ['out.mp4', 'metadata.json', 'media_validation.json']);
      return send(res, 201, job);
    }

    const jobMatch = p.match(/^\/api\/jobs\/(?!ingest(?:\/|$))([\w-]+)(\/.*)?$/);
    if (jobMatch) {
      const id = jobMatch[1];
      const dir = path.join(JOBS, id);
      const jf = path.join(dir, 'job.json');
      if (!fs.existsSync(jf)) return send(res, 404, { error: 'unknown job' });
      const sub = jobMatch[2] || '';
      const job = readJson(jf);
      if (req.method === 'GET' && SENSITIVE_SUB.has(sub) && !readOk(req)) {
        return send(res, 401, { error: TOKEN ? 'authentication required (production mode)' : 'auth not configured (production mode fails closed)', code: TOKEN ? 'AUTH_REQUIRED' : 'AUTH_NOT_CONFIGURED' });
      }
      if (req.method === 'GET' && sub === '') return send(res, 200, { ...job, has_media: fs.existsSync(path.join(dir, 'out.mp4')) });
      if (req.method === 'GET' && sub === '/media') {
        const mp = path.join(dir, 'out.mp4');
        if (!fs.existsSync(mp)) return send(res, 404, { error: 'no media yet' });
        res.writeHead(200, { 'content-type': 'video/mp4', 'cache-control': 'no-store' });
        return fs.createReadStream(mp).pipe(res);
      }
      if (req.method === 'GET' && sub === '/metadata') {
        const mp = path.join(dir, 'metadata.json');
        if (!fs.existsSync(mp)) return send(res, 404, { error: 'no metadata yet' });
        const meta = readJson(mp);
        const ap = path.join(dir, 'amendments.json');
        return send(res, 200, { ...meta, amendments: fs.existsSync(ap) ? readJson(ap) : [] });
      }
      if (req.method === 'POST' && sub === '/metadata-amend') {
        if (!authOk(req)) return mutAuthFail(res);
        let body = '';
        for await (const chunk of req) body += chunk;
        const amend = JSON.parse(body || '{}');
        const ap = path.join(dir, 'amendments.json');
        const log = fs.existsSync(ap) ? readJson(ap) : [];
        log.push({ seq: log.length, at: new Date().toISOString(), actor: amend.actor || 'authenticated-user', note: amend.note || '', fields: amend.fields || {} });
        fs.writeFileSync(ap, JSON.stringify(log, null, 2));
        await appendChain(dir, 'metadata-amended', ['amendments.json']);
        return send(res, 200, { amended: true, entries: log.length });
      }
      if (req.method === 'POST' && sub === '/qc') {
        if (!authOk(req)) return mutAuthFail(res);
        let body = '';
        for await (const chunk of req) body += chunk;
        const qc = JSON.parse(body);
        qc.recorded_at = new Date().toISOString();
        qc.recorded_by = qc.recorded_by || 'dashboard-user';
        fs.writeFileSync(path.join(dir, 'qc.json'), JSON.stringify(qc, null, 2));
        const hp = path.join(dir, 'qc-history.json');
        const hist = fs.existsSync(hp) ? readJson(hp) : [];
        hist.push(qc);
        fs.writeFileSync(hp, JSON.stringify(hist, null, 2));
        await appendChain(dir, 'qc-recorded', ['qc.json', 'qc-history.json', 'job.json']);
        updateJob(job, { review: 'recorded' });
        return send(res, 200, { saved: true, qc });
      }
      if (req.method === 'GET' && sub === '/qc') {
        const qp = path.join(dir, 'qc.json');
        if (!fs.existsSync(qp)) return send(res, 404, { error: 'no qc recorded yet' });
        return send(res, 200, readJson(qp));
      }
      if (req.method === 'GET' && sub === '/qc-history') {
        const hp = path.join(dir, 'qc-history.json');
        if (!fs.existsSync(hp)) return send(res, 404, { error: 'no qc history yet' });
        return send(res, 200, readJson(hp));
      }
      if (req.method === 'GET' && sub === '/verify') {
        return send(res, 200, await verifyChain(dir));
      }
      if (req.method === 'GET' && sub === '/manifest') {
        const outputs = [];
        for (const f of ['out.mp4', 'metadata.json', 'qc.json', 'media_validation.json', 'evidence-chain.json']) {
          const fp = path.join(dir, f);
          if (fs.existsSync(fp)) outputs.push({ file: f, bytes: fs.statSync(fp).size, sha256: await sha256File(fp) });
        }
        const plate = plateForShot(job.shot_id);
        return send(res, 200, {
          manifest_id: `export-${job.id}`,
          generated_at: new Date().toISOString(),
          mission: 'WRASAL-ARENA-CIN-001',
          branch: 'arena/abe9e5ac-wrasal-control',
          job, metadata: fs.existsSync(path.join(dir, 'metadata.json')) ? readJson(path.join(dir, 'metadata.json')) : null,
          qc: fs.existsSync(path.join(dir, 'qc.json')) ? readJson(path.join(dir, 'qc.json')) : null,
          evidence_chain: fs.existsSync(path.join(dir, 'evidence-chain.json')) ? readJson(path.join(dir, 'evidence-chain.json')) : null,
          chain_verification: await verifyChain(dir),
          plate: { path: path.relative(REPO, plate), sha256: await sha256File(plate) },
          outputs,
          rights: 'REF-ONLY conditioning asset; export of tech-viz material carries no commercial clearance (G4/QC-111 pending)',
        });
      }
    }

    if (req.method === 'POST' && p === '/api/jobs') {
      if (!authOk(req)) return mutAuthFail(res);
      let body = '';
      for await (const chunk of req) body += chunk;
      if (body.length > 1_000_000) return send(res, 413, { error: 'body too large' });
      const reqBody = JSON.parse(body || '{}');
      const shotId = reqBody.shot_id;
      const providerId = reqBody.provider_id;
      if (!/^SHOT-[A-D]$/.test(shotId || '')) return send(res, 400, { error: 'shot_id must be SHOT-A..SHOT-D' });
      if (!providers().some((pr) => pr.id === providerId)) return send(res, 400, { error: 'unknown provider' });
      const prompts = readJson(path.join(MISSION, 'data', 'prompts.json'));
      const defaultPrompt = (prompts.i2v.find((x) => x.shot_id === shotId) || prompts.t2v.find((x) => x.shot_id === shotId) || {}).prompt_text || '';
      const promptText = reqBody.prompt_text || defaultPrompt;
      const id = `job-${Date.now().toString(36)}-${crypto.randomBytes(3).toString('hex')}`;
      fs.mkdirSync(path.join(JOBS, id), { recursive: true });
      const job = {
        id, shot_id: shotId, provider_id: providerId, status: 'queued',
        created_at: new Date().toISOString(),
        params: { duration_s: reqBody.duration_s || 5.0, fps: reqBody.fps || 24, zoom: reqBody.zoom ?? 0.02, grain: reqBody.grain ?? 0.35 },
        prompt_text: promptText, prompt_hash: sha256Text(promptText),
        plate: path.relative(REPO, plateForShot(shotId)),
        review: null, error: null,
      };
      fs.writeFileSync(path.join(JOBS, id, 'job.json'), JSON.stringify(job, null, 2));
      setImmediate(() => runJob(job));
      return send(res, 201, job);
    }
    return send(res, 404, { error: 'not found' });
  } catch (e) {
    return send(res, e.code === 413 ? 413 : 500, { error: String(e.message || e) });
  }
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`WRASAL-ARENA-CIN-001 production console listening on 0.0.0.0:${PORT} (auth mode: ${AUTH_MODE}${TOKEN ? ', token configured' : ', NO TOKEN'}${AUTH_MODE === 'production' && !TOKEN ? ' => FAIL-CLOSED' : ''})`);
  if (AUTH_MODE !== 'production') console.log('WARNING: sandbox auth mode - loopback mutations allowed without token. Set ARENA_CIN_AUTH_MODE=production and ARENA_CIN_AUTH_TOKEN for any external exposure.');
});
