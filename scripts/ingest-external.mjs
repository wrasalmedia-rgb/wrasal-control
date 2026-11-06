#!/usr/bin/env node
/**
 * Ingest externally generated video (e.g. from a Runway session in another
 * environment) into the existing WRASAL-ARENA-CIN-001 console.
 * Binary upload contract (security gate): raw MP4 body, metadata in header.
 *
 * Usage:
 *   node scripts/ingest-external.mjs --file out.mp4 --shot SHOT-C \
 *        [--url http://127.0.0.1:8787] [--meta metadata.json] [--source runway-session] \
 *        [--token $ARENA_CIN_AUTH_TOKEN]
 *
 * metadata.json (as-reported; claims require docs before VERIFIED per QC-900):
 *   {"provider":"runway","model":"gen-4","generation_id":"...","seed":"...",
 *    "prompt":"...","params":{...},"provider_job_id":"..."}
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
const token = arg('token', process.env.ARENA_CIN_AUTH_TOKEN || null);

if (!file || !fs.existsSync(file)) {
  console.error('usage: node scripts/ingest-external.mjs --file out.mp4 --shot SHOT-C [--url BASE] [--meta meta.json] [--source LABEL] [--token TOK]');
  process.exit(2);
}

const meta = metaPath ? JSON.parse(fs.readFileSync(metaPath, 'utf8')) : {};
const headers = { 'content-type': 'application/octet-stream', 'x-arena-cin-meta': Buffer.from(JSON.stringify(meta)).toString('base64') };
if (token) headers.authorization = `Bearer ${token}`;

const res = await fetch(`${base}/api/jobs/ingest?shot=${encodeURIComponent(shot)}&source=${encodeURIComponent(source)}`, {
  method: 'POST',
  headers,
  body: fs.readFileSync(file),
});
const job = await res.json();
if (!res.ok) {
  console.error('INGEST FAILED', res.status, JSON.stringify(job));
  process.exit(1);
}
console.log(`INGESTED ${job.id} (shot ${shot}, provider_id ${job.provider_id})`);
console.log(`media validation: ${job.status === 'succeeded' ? 'passed server-side (container+codec+decode)' : job.status}`);
console.log(`review: ${base}/  -> Jobs -> review ${job.id}`);
console.log('note: metadata is as-reported and immutable; amendments are logged, not overwritten (QC-900 applies to provider claims).');
