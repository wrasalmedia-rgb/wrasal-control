#!/usr/bin/env node
/**
 * Deployment smoke test for the WRASAL-ARENA-CIN-001 production console.
 * Exercises the real pipeline end-to-end: workspace -> submit -> encode ->
 * monitor -> media bytes -> metadata -> QC record -> export manifest ->
 * blocked-provider failure handling -> source integrity.
 * No simulated success: every assertion reads real server state/bytes.
 */
import fs from 'node:fs';
import path from 'node:path';
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

  const qcRes = await fetch(`${BASE}/api/jobs/${job.id}/qc`, {
    method: 'POST', headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ scores: { C1: 4, C2: 4, C3: 4, C4: 4, C5: 4, C6: 4, C7: 4, C8: 4 }, weighted: 80, checks: [{ id: 'QC-002', pass: true }], hard_stop_zero: true, disposition: 'advance', candidate_class: 'tech-viz camera test (NOT AI generation)' }),
  });
  ok('qc.recorded', qcRes.ok);

  const man = await (await fetch(`${BASE}/api/jobs/${job.id}/manifest`)).json();
  ok('manifest.outputs', man.outputs.some((o) => o.file === 'out.mp4' && o.sha256.length === 64));
  ok('manifest.rights_note', String(man.rights).includes('REF-ONLY'));

  const ing = await fetch(`${BASE}/api/jobs/ingest`, {
    method: 'POST', headers: { 'content-type': 'application/json' },
    body: JSON.stringify({
      shot_id: 'SHOT-C', source: 'smoke-fixture', video_base64: buf.toString('base64'),
      metadata: { provider: 'smoke-external-fixture', model: 'none', prompt: 'smoke ingest fixture reusing tech-viz bytes; NOT an AI generation claim', params: { duration_s: 5, fps: 24 } },
    }),
  });
  const ingJob = await ing.json();
  ok('ingest.accepted', ing.ok && Boolean(ingJob.id), `status=${ing.status}`);
  let ig = ingJob;
  for (let i = 0; i < 5 && ig.status !== 'succeeded'; i += 1) { await sleep(500); ig = await (await fetch(`${BASE}/api/jobs/${ingJob.id}`)).json(); }
  ok('ingest.job_succeeded', ig.status === 'succeeded' && ig.provider_id === 'external-ingest');
  const im = await fetch(`${BASE}/api/jobs/${ingJob.id}/media`);
  const ibuf = Buffer.from(await im.arrayBuffer());
  ok('ingest.media_magic', ibuf.toString('latin1', 4, 8) === 'ftyp' && ibuf.length === buf.length);

  const bj = await (await fetch(`${BASE}/api/jobs`, {
    method: 'POST', headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ shot_id: 'SHOT-C', provider_id: 'external-provider' }),
  })).json();
  let b = bj;
  for (let i = 0; i < 5 && b.status !== 'blocked'; i += 1) { await sleep(1000); b = await (await fetch(`${BASE}/api/jobs/${bj.id}`)).json(); }
  ok('blocked.provider_unconfigured', b.status === 'blocked' && b.error?.code === 'PROVIDER_UNCONFIGURED', `status=${b.status}`);
  ok('blocked.exit_path', String(b.error?.exit || '').length > 20);
  ok('blocked.source_preserved', b.error?.source_preserved === true);

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
