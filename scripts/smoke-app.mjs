#!/usr/bin/env node
/**
 * Deployment smoke test — WRASAL-ARENA-CIN-001 production console.
 * Real pipeline end-to-end plus the production security gate:
 * workspace -> submit -> encode -> monitor -> media bytes -> metadata ->
 * QC record (+history) -> evidence chain verify -> export manifest ->
 * binary ingest with deep media validation -> blocked-provider handling ->
 * auth token enforcement on a second isolated instance -> rate limit -> source integrity.
 */
import fs from 'node:fs';
import path from 'node:path';
import { spawn } from 'node:child_process';
import process from 'node:process';

const BASE = process.env.SMOKE_BASE || 'http://127.0.0.1:8787';
const EXPECT = {
  source: 'bea6ed1c68c92e86ad3359c2c53ad518303f3da33b13bf6c57e7df7ef292cc20',
  cleanC: 'd39a1cb306a4cccddfdc58ea14fd725b6ead71cf6d45fbcdc39b491984cb3d53',
};
const checks = [];
const ok = (name, cond, detail = '') => checks.push({ name, result: cond ? 'pass' : 'fail', detail });
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

async function main() {
  const ws = await (await fetch(`${BASE}/api/workspace`)).json();
  ok('workspace.mission', ws.mission_id === 'WRASAL-ARENA-CIN-001');
  ok('workspace.plates_exist', ws.plates.every((p) => p.exists));
  ok('workspace.source_sha', ws.plates.find((p) => p.path.endsWith('source/image-1.png'))?.sha256_live === EXPECT.source);
  ok('workspace.cleanC_sha', ws.plates.find((p) => p.path.endsWith('shot-C-clean.png'))?.sha256_live === EXPECT.cleanC);
  ok('workspace.techviz_configured', ws.providers.find((p) => p.id === 'plate-render-techviz-v1')?.configured === true);
  ok('workspace.security_surface', Boolean(ws.security?.media_validation) && Boolean(ws.security?.evidence_chain));

  const job = await (await fetch(`${BASE}/api/jobs`, {
    method: 'POST', headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ shot_id: 'SHOT-C', provider_id: 'plate-render-techviz-v1', duration_s: 5, fps: 24 }),
  })).json();
  ok('submit.created', Boolean(job.id), job.id);

  let j = job;
  for (let i = 0; i < 90 && !['succeeded', 'failed', 'blocked'].includes(j.status); i += 1) {
    await sleep(2000);
    j = await (await fetch(`${BASE}/api/jobs/${job.id}`)).json();
  }
  ok('job.succeeded', j.status === 'succeeded', `status=${j.status} err=${JSON.stringify(j.error || '')}`);

  const media = await fetch(`${BASE}/api/jobs/${job.id}/media`);
  const buf = Buffer.from(await media.arrayBuffer());
  ok('media.mp4_magic', buf.length > 20000 && buf.toString('latin1', 4, 8) === 'ftyp', `bytes=${buf.length}`);

  const meta = await (await fetch(`${BASE}/api/jobs/${job.id}/metadata`)).json();
  ok('metadata.adapter', meta.adapter === 'plate-render-techviz-v1');
  ok('metadata.not_ai_label', String(meta.class).includes('NOT AI generation'));
  ok('metadata.plate_sha', meta.plate_sha256 === EXPECT.cleanC);
  ok('metadata.frames_120', meta.frames === 120, `frames=${meta.frames}`);

  await fetch(`${BASE}/api/jobs/${job.id}/qc`, { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ scores: { C1: 4, C2: 4, C3: 4, C4: 4, C5: 4, C6: 4, C7: 4, C8: 4 }, weighted: 80, checks: [{ id: 'QC-002', pass: true }], hard_stop_zero: true, disposition: 'advance', candidate_class: 'tech-viz camera test (NOT AI generation)' }) });
  const qc2 = await fetch(`${BASE}/api/jobs/${job.id}/qc`, { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ scores: { C1: 4, C2: 4, C3: 4, C4: 4, C5: 4, C6: 4, C7: 4, C8: 5 }, weighted: 81, checks: [], hard_stop_zero: true, disposition: 'advance', note: 'second entry tests history' }) });
  ok('qc.recorded', qc2.ok);
  const qh = await (await fetch(`${BASE}/api/jobs/${job.id}/qc-history`)).json();
  ok('qc.history_append_only', Array.isArray(qh) && qh.length === 2, `entries=${qh?.length}`);

  const ver = await (await fetch(`${BASE}/api/jobs/${job.id}/verify`)).json();
  ok('evidence.chain_verified', ver.ok === true, JSON.stringify(ver.reasons || []));

  const man = await (await fetch(`${BASE}/api/jobs/${job.id}/manifest`)).json();
  ok('manifest.outputs', man.outputs.some((o) => o.file === 'out.mp4' && o.sha256.length === 64));
  ok('manifest.chain_included', Boolean(man.evidence_chain) && man.chain_verification?.ok === true);
  ok('manifest.rights_note', String(man.rights).includes('REF-ONLY'));

  const metaB64 = Buffer.from(JSON.stringify({ provider: 'smoke-external-fixture', model: 'none', generation_id: 'smoke-gen-1', prompt: 'smoke ingest fixture reusing tech-viz bytes; NOT an AI generation claim', params: { duration_s: 5, fps: 24 } })).toString('base64');
  const ing = await fetch(`${BASE}/api/jobs/ingest?shot=SHOT-C&source=smoke-fixture`, {
    method: 'POST', headers: { 'content-type': 'application/octet-stream', 'x-arena-cin-meta': metaB64 }, body: buf,
  });
  const ingJob = await ing.json();
  ok('ingest.binary_accepted', ing.status === 201 && Boolean(ingJob.id), `status=${ing.status}`);
  const imeta = await (await fetch(`${BASE}/api/jobs/${ingJob.id}/metadata`)).json();
  ok('ingest.media_deep_validation', imeta.media_validation?.ok === true && imeta.media_validation?.frames_decoded_head >= 24, `codec=${imeta.media_validation?.codec}`);
  ok('ingest.metadata_immutable_flag', imeta.immutable === true);
  const im = await fetch(`${BASE}/api/jobs/${ingJob.id}/media`);
  const ibuf = Buffer.from(await im.arrayBuffer());
  ok('ingest.media_roundtrip', ibuf.toString('latin1', 4, 8) === 'ftyp' && ibuf.length === buf.length);
  const badIng = await fetch(`${BASE}/api/jobs/ingest?shot=SHOT-C&source=smoke-bad`, { method: 'POST', headers: { 'content-type': 'application/octet-stream' }, body: Buffer.concat([Buffer.from('000000186674797069736f6d', 'hex'), Buffer.alloc(40000, 7)]) });
  ok('ingest.rejects_invalid_media', badIng.status === 422, `status=${badIng.status}`);

  const bj = await (await fetch(`${BASE}/api/jobs`, {
    method: 'POST', headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ shot_id: 'SHOT-C', provider_id: 'external-provider' }),
  })).json();
  let b = bj;
  for (let i = 0; i < 5 && b.status !== 'blocked'; i += 1) { await sleep(1000); b = await (await fetch(`${BASE}/api/jobs/${bj.id}`)).json(); }
  ok('blocked.provider_unconfigured', b.status === 'blocked' && b.error?.code === 'PROVIDER_UNCONFIGURED', `status=${b.status}`);
  ok('blocked.exit_path', String(b.error?.exit || '').length > 20);
  ok('blocked.source_preserved', b.error?.source_preserved === true);

  // --- isolated second instance with bearer token: auth + rate limit ---
  const PORT2 = 8799;
  const RT2 = '.runtime-smoke2';
  fs.rmSync(RT2, { recursive: true, force: true });
  const child = spawn('node', ['missions/WRASAL-ARENA-CIN-001/app/server.mjs'], {
    cwd: process.cwd(), env: { ...process.env, PORT: String(PORT2), ARENA_CIN_AUTH_TOKEN: 'smoke-token', ARENA_CIN_RUNTIME: RT2, ARENA_CIN_MAX_UPLOAD_BYTES: '100000' },
  });
  const B2 = `http://127.0.0.1:${PORT2}`;
  let up = false;
  for (let i = 0; i < 20 && !up; i += 1) {
    await sleep(500);
    up = await fetch(`${B2}/api/workspace`).then((r) => r.ok).catch(() => false);
  }
  ok('auth.instance_up', up);
  if (up) {
    const noAuth = await fetch(`${B2}/api/jobs`, { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ shot_id: 'SHOT-C', provider_id: 'plate-render-techviz-v1' }) });
    ok('auth.mutation_requires_token', noAuth.status === 401, `status=${noAuth.status}`);
    const withAuth = await fetch(`${B2}/api/jobs`, { method: 'POST', headers: { 'content-type': 'application/json', authorization: 'Bearer smoke-token' }, body: JSON.stringify({ shot_id: 'SHOT-C', provider_id: 'plate-render-techviz-v1', duration_s: 1, fps: 24 }) });
    ok('auth.token_accepted', withAuth.status === 201, `status=${withAuth.status}`);
    const noAuthIng = await fetch(`${B2}/api/jobs/ingest?shot=SHOT-C`, { method: 'POST', body: buf });
    ok('auth.ingest_requires_token', noAuthIng.status === 401, `status=${noAuthIng.status}`);
    let capResult = 'conn-cut';
    try { capResult = String((await fetch(`${B2}/api/jobs/ingest?shot=SHOT-C&source=cap`, { method: 'POST', headers: { authorization: 'Bearer smoke-token', 'content-type': 'application/octet-stream' }, body: buf })).status); } catch { /* server cut the socket: enforcement observed */ }
    ok('security.upload_cap_enforced', capResult === '413' || capResult === 'conn-cut', `result=${capResult}`);
    let last = 0;
    for (let i = 0; i < 6; i += 1) {
      const r = await fetch(`${B2}/api/jobs/ingest?shot=SHOT-C&source=rate`, { method: 'POST', headers: { authorization: 'Bearer smoke-token', 'content-type': 'application/octet-stream' }, body: Buffer.alloc(30000, 3) });
      last = r.status;
    }
    ok('security.rate_limit_429', last === 429, `last=${last}`);
  }
  child.kill('SIGTERM');
  fs.rmSync(RT2, { recursive: true, force: true });

  const ws2 = await (await fetch(`${BASE}/api/workspace`)).json();
  ok('source.integrity_after_jobs', ws2.plates.find((p) => p.path.endsWith('source/image-1.png'))?.sha256_live === EXPECT.source);

  const failed = checks.filter((c) => c.result === 'fail');
  const report = { smoke: 'wrasal-arena-cin-001-console', base: BASE, at: new Date().toISOString(), summary: { checks: checks.length, passed: checks.length - failed.length, failed: failed.length }, checks };
  fs.mkdirSync('.runtime', { recursive: true });
  fs.writeFileSync(path.join('.runtime', 'smoke-report.json'), JSON.stringify(report, null, 2));
  for (const c of checks) console.log(`${c.result === 'pass' ? 'PASS' : 'FAIL'} ${c.name}${c.detail ? ` (${c.detail})` : ''}`);
  console.log(failed.length === 0 ? `SMOKE PASS (${checks.length} checks)` : `SMOKE FAIL (${failed.length} failed)`);
  process.exit(failed.length === 0 ? 0 : 1);
}

main().catch((e) => { console.error('SMOKE ERROR', e); process.exit(2); });
