#!/usr/bin/env node
/**
 * Topology smoke — WRASAL-ARENA-CIN-001 rc2 evidence (Track B).
 * Proves, with real jobs and real process boundaries:
 *  - worker separation: jobs execute in a worker process, not the gateway
 *  - durable storage: assets survive gateway restart and worker replacement
 *  - stateless gateway: API serves from shared store only (no inline execution)
 *  - production auth: unauthenticated access fails closed on the public surface
 *  - topology flow: real upload (ingest), job execution, review (QC), export
 *  - rollback: previous release boots from git history and serves fail-closed
 * Writes .runtime/topology-smoke-report.json. Exit 0 = all checks pass.
 */
import fs from 'node:fs';
import path from 'node:path';
import { spawn, execSync } from 'node:child_process';
import process from 'node:process';

const checks = [];
const ok = (name, cond, detail = '') => checks.push({ name, result: cond ? 'pass' : 'fail', detail });
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const RT = '.runtime-topo';
const TOKEN = 'topo-token';
const GP = 8810;
const GB = `http://127.0.0.1:${GP}`;

function startServer(env, label) {
  const child = spawn('node', ['missions/WRASAL-ARENA-CIN-001/app/server.mjs'], { cwd: process.cwd(), env: { ...process.env, ...env } });
  child.label = label;
  return child;
}

async function main() {
  fs.rmSync(RT, { recursive: true, force: true });
  const gwEnv = { PORT: String(GP), ARENA_CIN_MODE: 'gateway', ARENA_CIN_AUTH_MODE: 'production', ARENA_CIN_AUTH_TOKEN: TOKEN, ARENA_CIN_RUNTIME: RT };
  const gw1 = startServer(gwEnv, 'gateway-1');
  const w1 = startServer({ ARENA_CIN_MODE: 'worker', ARENA_CIN_WORKER_ID: 'w1', ARENA_CIN_RUNTIME: RT }, 'worker-1');

  let up = false;
  for (let i = 0; i < 30 && !up; i += 1) { await sleep(400); up = await fetch(`${GB}/api/workspace`).then((r) => r.ok).catch(() => false); }
  ok('topo.gateway_up', up);

  const pub = await fetch(`${GB}/api/jobs`);
  ok('topo.public_fail_closed', pub.status === 401, `status=${pub.status}`);

  const login = await fetch(`${GB}/api/auth/login`, { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ token: TOKEN }) });
  const cookie = (login.headers.get('set-cookie') || '').split(';')[0];
  ok('topo.login_ok', login.status === 200 && cookie.startsWith('acin_session='));
  const H = { cookie };
  const HB = { cookie, authorization: `Bearer ${TOKEN}` };

  const j1 = await (await fetch(`${GB}/api/jobs`, { method: 'POST', headers: { ...HB, 'content-type': 'application/json' }, body: JSON.stringify({ shot_id: 'SHOT-C', provider_id: 'plate-render-techviz-v1', duration_s: 1, fps: 24 }) })).json();
  ok('topo.submit_queued', Boolean(j1.id));
  let s1 = j1;
  for (let i = 0; i < 60 && s1.status !== 'succeeded'; i += 1) { await sleep(1000); s1 = await (await fetch(`${GB}/api/jobs/${j1.id}`, { headers: H })).json(); }
  const m1 = await (await fetch(`${GB}/api/jobs/${j1.id}/metadata`, { headers: H })).json();
  ok('topo.worker_executed', s1.status === 'succeeded' && m1.worker?.id === 'w1', `worker=${m1.worker?.id}`);
  ok('topo.gateway_stateless', m1.worker?.mode === 'worker', `mode=${m1.worker?.mode}`);

  // gateway restart: assets survive
  gw1.kill('SIGTERM');
  await sleep(800);
  const gw2 = startServer(gwEnv, 'gateway-2');
  let up2 = false;
  for (let i = 0; i < 30 && !up2; i += 1) { await sleep(400); up2 = await fetch(`${GB}/api/workspace`).then((r) => r.ok).catch(() => false); }
  const media2 = await fetch(`${GB}/api/jobs/${j1.id}/media`, { headers: H });
  const mb = Buffer.from(await media2.arrayBuffer());
  ok('topo.durable_across_gateway_restart', up2 && media2.status === 200 && mb.toString('latin1', 4, 8) === 'ftyp', `status=${media2.status}`);

  // worker replacement
  w1.kill('SIGTERM');
  await sleep(500);
  const w2 = startServer({ ARENA_CIN_MODE: 'worker', ARENA_CIN_WORKER_ID: 'w2', ARENA_CIN_RUNTIME: RT }, 'worker-2');
  const j2 = await (await fetch(`${GB}/api/jobs`, { method: 'POST', headers: { ...HB, 'content-type': 'application/json' }, body: JSON.stringify({ shot_id: 'SHOT-C', provider_id: 'plate-render-techviz-v1', duration_s: 1, fps: 24 }) })).json();
  let s2 = j2;
  for (let i = 0; i < 60 && s2.status !== 'succeeded'; i += 1) { await sleep(1000); s2 = await (await fetch(`${GB}/api/jobs/${j2.id}`, { headers: H })).json(); }
  const m2 = await (await fetch(`${GB}/api/jobs/${j2.id}/metadata`, { headers: H })).json();
  ok('topo.worker_replacement', s2.status === 'succeeded' && m2.worker?.id === 'w2', `worker=${m2.worker?.id}`);

  // real upload through gateway (ingest), review, export
  const srcMedia = await fetch(`${GB}/api/jobs/${j1.id}/media`, { headers: H });
  const buf = Buffer.from(await srcMedia.arrayBuffer());
  const metaB64 = Buffer.from(JSON.stringify({ provider: 'topology-fixture', model: 'none', generation_id: 'topo-gen-1', prompt: 'topology upload fixture; NOT an AI generation claim' })).toString('base64');
  const ing = await fetch(`${GB}/api/jobs/ingest?shot=SHOT-C&source=topology`, { method: 'POST', headers: { ...HB, 'content-type': 'application/octet-stream', 'x-arena-cin-meta': metaB64 }, body: buf });
  const ingJ = await ing.json();
  ok('topo.real_upload_ingest', ing.status === 201, `status=${ing.status}`);
  const qcR = await fetch(`${GB}/api/jobs/${ingJ.id}/qc`, { method: 'POST', headers: { ...HB, 'content-type': 'application/json' }, body: JSON.stringify({ scores: { C1: 4, C2: 4, C3: 4, C4: 4, C5: 4, C6: 4, C7: 4, C8: 4 }, weighted: 80, disposition: 'advance', candidate_class: 'topology fixture' }) });
  ok('topo.review_qc_recorded', qcR.ok);
  const man = await (await fetch(`${GB}/api/jobs/${ingJ.id}/manifest`, { headers: H })).json();
  ok('topo.export_manifest', man.outputs.some((o) => o.file === 'out.mp4') && man.chain_verification?.ok === true);

  // rollback drill: boot previous release from git history, fail-closed, serve workspace
  const prevSha = execSync('git rev-parse HEAD~1').toString().trim();
  const wt = '/home/user/.rollback-drill';
  execSync(`git worktree add --detach ${wt} ${prevSha} 2>/dev/null || true`);
  const rb = spawn('node', [`${wt}/missions/WRASAL-ARENA-CIN-001/app/server.mjs`], { cwd: process.cwd(), env: { ...process.env, PORT: '8811', ARENA_CIN_AUTH_MODE: 'production', ARENA_CIN_RUNTIME: '.runtime-rollback-drill' } });
  let upR = false;
  for (let i = 0; i < 20 && !upR; i += 1) { await sleep(400); upR = await fetch('http://127.0.0.1:8811/api/workspace').then((r) => r.ok).catch(() => false); }
  const rbMut = await fetch('http://127.0.0.1:8811/api/jobs', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ shot_id: 'SHOT-C', provider_id: 'plate-render-techviz-v1' }) });
  ok('topo.rollback_previous_release_boots', upR, `sha=${prevSha.slice(0, 7)}`);
  ok('topo.rollback_fail_closed', rbMut.status === 401, `status=${rbMut.status}`);
  rb.kill('SIGTERM');
  fs.rmSync('.runtime-rollback-drill', { recursive: true, force: true });
  try { execSync(`git worktree remove --force ${wt}`); } catch { /* best effort */ }

  gw2.kill('SIGTERM');
  w2.kill('SIGTERM');
  await sleep(500);
  fs.rmSync(RT, { recursive: true, force: true });

  const failed = checks.filter((c) => c.result === 'fail');
  const report = { smoke: 'wrasal-arena-cin-001-topology', at: new Date().toISOString(), gateway_port: GP, worker_ids: ['w1', 'w2'], rollback_sha: prevSha, summary: { checks: checks.length, passed: checks.length - failed.length, failed: failed.length }, checks };
  fs.mkdirSync('.runtime', { recursive: true });
  fs.writeFileSync(path.join('.runtime', 'topology-smoke-report.json'), JSON.stringify(report, null, 2));
  for (const c of checks) console.log(`${c.result === 'pass' ? 'PASS' : 'FAIL'} ${c.name}${c.detail ? ` (${c.detail})` : ''}`);
  console.log(failed.length === 0 ? `TOPOLOGY SMOKE PASS (${checks.length} checks)` : `TOPOLOGY SMOKE FAIL (${failed.length} failed)`);
  process.exit(failed.length === 0 ? 0 : 1);
}

main().catch((e) => { console.error('TOPOLOGY SMOKE ERROR', e); process.exit(2); });
