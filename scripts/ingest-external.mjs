#!/usr/bin/env node
/**
 * Ingest externally generated video (e.g. from a Runway session in another
 * environment) into the existing WRASAL-ARENA-CIN-001 console.
 * Uses the implemented external-ingest adapter — no new provider framework.
 *
 * Usage:
 *   node scripts/ingest-external.mjs --file out.mp4 --shot SHOT-C \
 *        [--url http://127.0.0.1:8787] [--meta metadata.json] [--source runway-session]
 *
 * metadata.json (as-reported fields; claims require docs before VERIFIED):
 *   {"provider":"runway","model":"gen-4","seed":"...","prompt":"...","params":{...},"provider_job_id":"..."}
 */
import fs from 'node:fs';

const arg = (name, dflt = null) => {
  const i = process.argv.indexOf(`--${name}`);
  return i >= 0 ? process.argv[i + 1] : dflt;
};

const file = arg('file');
const shot = arg('shot', 'SHOT-C');
const base = arg('url', 'http://127.0.0.1:8787');
const metaPath = arg('meta');
const source = arg('source', 'external');

if (!file || !fs.existsSync(file)) {
  console.error('usage: node scripts/ingest-external.mjs --file out.mp4 --shot SHOT-C [--url BASE] [--meta meta.json] [--source LABEL]');
  process.exit(2);
}

const payload = {
  shot_id: shot,
  source,
  video_base64: fs.readFileSync(file).toString('base64'),
  metadata: metaPath ? JSON.parse(fs.readFileSync(metaPath, 'utf8')) : {},
};

const res = await fetch(`${base}/api/jobs/ingest`, {
  method: 'POST',
  headers: { 'content-type': 'application/json' },
  body: JSON.stringify(payload),
});
const job = await res.json();
if (!res.ok) {
  console.error('INGEST FAILED', res.status, JSON.stringify(job));
  process.exit(1);
}
console.log(`INGESTED ${job.id} (shot ${shot}, provider_id ${job.provider_id})`);
console.log(`review: ${base}/  -> Jobs -> review ${job.id}`);
console.log('note: metadata is as-reported; provider claims require documentation before VERIFIED status (QC-900).');
