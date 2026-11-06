#!/usr/bin/env node
/**
 * WRASAL-ARENA-CIN-001 — Cinematic Production Console (sandbox deployment).
 * Zero-dependency Node HTTP server: workspace browser, generation jobs,
 * monitoring, review station, export. Real jobs only — no simulated success.
 *
 * Env (optional):
 *   PORT                        listen port (default 8787)
 *   ARENA_CIN_PROVIDER_URL      external video provider submit endpoint (http contract in deployment doc)
 *   ARENA_CIN_PROVIDER_KEY      bearer key for the above
 *   ARENA_CIN_PROVIDER_MODEL    model id passed through to the provider
 */
import http from 'node:http';
import fs from 'node:fs';
import fsp from 'node:fs/promises';
import path from 'node:path';
import crypto from 'node:crypto';
import { spawn } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const APP = path.dirname(fileURLToPath(import.meta.url));
const MISSION = path.resolve(APP, '..');
const REPO = path.resolve(MISSION, '..', '..');
const RUNTIME = path.join(REPO, '.runtime');
const JOBS = path.join(RUNTIME, 'jobs');
const RENDER = path.join(REPO, 'tools', 'render_plate_test.py');
const ENCODER_DIR = path.join(REPO, 'tools', 'pylibs', 'av');
const UI = path.join(APP, 'ui', 'index.html');
const PORT = Number(process.env.PORT || 8787);

fs.mkdirSync(JOBS, { recursive: true });

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

function providers() {
  const encoderOk = fs.existsSync(ENCODER_DIR);
  return [
    {
      id: 'plate-render-techviz-v1',
      klass: 'tech-viz camera test (NOT AI generation)',
      configured: encoderOk,
      exit_if_missing: 'run: sh scripts/setup-encoder.sh (provisions PyAV/libx264 into tools/pylibs)',
    },
    {
      id: 'external-provider',
      klass: 'authorized external video provider (async HTTP contract)',
      configured: Boolean(process.env.ARENA_CIN_PROVIDER_URL),
      exit_if_missing: 'set ARENA_CIN_PROVIDER_URL and ARENA_CIN_PROVIDER_KEY in the deployment environment, or connect an Arena video connector; probes runway/sora/openai/luma all returned unsupported on 2026-11-06 (runway re-probed same date: unsupported)',
    },
    {
      id: 'external-ingest',
      klass: 'ingest of footage generated in another environment + as-reported metadata (existing adapter, not a new framework)',
      configured: true,
      exit_if_missing: '',
    },
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
      updateJob(job, {
        status: 'blocked',
        error: { code: 'ENCODER_MISSING', exit: providers()[0].exit_if_missing, source_preserved: true },
        finished_at: new Date().toISOString(),
      });
      return;
    }
    const args = [RENDER, '--plate', plate, '--out', out,
      '--duration', String(job.params.duration_s), '--fps', String(job.params.fps),
      '--zoom', String(job.params.zoom), '--grain', String(job.params.grain)];
    const child = spawn('python3', args, { cwd: REPO });
    let err = '';
    child.stderr.on('data', (d) => { err = (err + d).slice(-2000); });
    child.on('close', async (code) => {
      const ok = code === 0 && fs.existsSync(out) && fs.statSync(out).size > 20000;
      if (ok) {
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
      updateJob(job, {
        status: 'blocked',
        error: { code: 'PROVIDER_UNCONFIGURED', exit: providers()[1].exit_if_missing, source_preserved: true },
        finished_at: new Date().toISOString(),
      });
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
    version: readJson(path.join(APP, 'VERSION.json')),
  };
}

const server = http.createServer(async (req, res) => {
  const url = new URL(req.url, `http://${req.headers.host || 'localhost'}`);
  const p = url.pathname;
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
    if (req.method === 'GET' && p === '/api/jobs') {
      const ids = fs.readdirSync(JOBS).filter((d) => fs.existsSync(path.join(JOBS, d, 'job.json')));
      const jobs = ids.map((id) => readJson(path.join(JOBS, id, 'job.json')))
        .sort((a, b) => (a.created_at < b.created_at ? 1 : -1))
        .map((j) => ({ ...j, has_media: fs.existsSync(path.join(JOBS, j.id, 'out.mp4')) }));
      return send(res, 200, jobs);
    }
    const jobMatch = p.match(/^\/api\/jobs\/(?!ingest(?:\/|$))([\w-]+)(\/.*)?$/);
    if (jobMatch) {
      const id = jobMatch[1];
      const dir = path.join(JOBS, id);
      const jf = path.join(dir, 'job.json');
      if (!fs.existsSync(jf)) return send(res, 404, { error: 'unknown job' });
      const sub = jobMatch[2] || '';
      const job = readJson(jf);
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
        return send(res, 200, readJson(mp));
      }
      if (req.method === 'POST' && sub === '/qc') {
        let body = '';
        for await (const chunk of req) body += chunk;
        const qc = JSON.parse(body);
        qc.recorded_at = new Date().toISOString();
        qc.recorded_by = qc.recorded_by || 'dashboard-user';
        fs.writeFileSync(path.join(dir, 'qc.json'), JSON.stringify(qc, null, 2));
        updateJob(job, { review: 'recorded' });
        return send(res, 200, { saved: true, qc });
      }
      if (req.method === 'GET' && sub === '/qc') {
        const qp = path.join(dir, 'qc.json');
        if (!fs.existsSync(qp)) return send(res, 404, { error: 'no qc recorded yet' });
        return send(res, 200, readJson(qp));
      }
      if (req.method === 'GET' && sub === '/manifest') {
        const outputs = [];
        for (const f of ['out.mp4', 'metadata.json', 'qc.json']) {
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
          plate: { path: path.relative(REPO, plate), sha256: await sha256File(plate) },
          outputs,
          rights: 'REF-ONLY conditioning asset; export of tech-viz material carries no commercial clearance (G4/QC-111 pending)',
        });
      }
    }
    if (req.method === 'POST' && p === '/api/jobs/ingest') {
      let body = '';
      for await (const chunk of req) body += chunk;
      if (body.length > 150_000_000) return send(res, 413, { error: 'body too large (150 MB cap)' });
      const b = JSON.parse(body || '{}');
      const shotId = b.shot_id;
      if (!/^SHOT-[A-D]$/.test(shotId || '')) return send(res, 400, { error: 'shot_id must be SHOT-A..SHOT-D' });
      if (typeof b.video_base64 !== 'string') return send(res, 400, { error: 'video_base64 required' });
      const buf = Buffer.from(b.video_base64, 'base64');
      if (buf.length < 20000 || buf.toString('latin1', 4, 8) !== 'ftyp') return send(res, 400, { error: 'video_base64 is not a real MP4 (ftyp magic missing or too small)' });
      const id = `job-ingest-${Date.now().toString(36)}-${crypto.randomBytes(3).toString('hex')}`;
      const dir = path.join(JOBS, id);
      fs.mkdirSync(dir, { recursive: true });
      fs.writeFileSync(path.join(dir, 'out.mp4'), buf);
      const reported = b.metadata || {};
      const plate = plateForShot(shotId);
      const metadata = {
        adapter: 'external-ingest',
        class: 'externally generated video ingested with as-reported metadata (provider claims require documentation before VERIFIED status per QC-900)',
        reported,
        ingest_source: b.source || 'external',
        plate_sha256: await sha256File(plate),
        prompt_hash: sha256Text(String(reported.prompt || '')),
        ingested_at: new Date().toISOString(),
      };
      fs.writeFileSync(path.join(dir, 'metadata.json'), JSON.stringify(metadata, null, 2));
      const job = {
        id, shot_id: shotId, provider_id: 'external-ingest', status: 'succeeded',
        created_at: metadata.ingested_at, finished_at: metadata.ingested_at,
        params: reported.params || {}, prompt_text: String(reported.prompt || ''),
        prompt_hash: metadata.prompt_hash, plate: path.relative(REPO, plate),
        review: null, error: null,
        ingest: { source: metadata.ingest_source, reported_model: reported.model || null, reported_provider: reported.provider || null },
      };
      fs.writeFileSync(path.join(dir, 'job.json'), JSON.stringify(job, null, 2));
      return send(res, 201, job);
    }
    if (req.method === 'POST' && p === '/api/jobs') {
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
    return send(res, 500, { error: String(e.message || e) });
  }
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`WRASAL-ARENA-CIN-001 production console listening on 0.0.0.0:${PORT}`);
});
