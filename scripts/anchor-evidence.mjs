#!/usr/bin/env node
/**
 * Anchor job evidence-chain heads OUTSIDE application-controlled storage.
 * A hash chain detects change but cannot prove authorship nor stop an attacker
 * with filesystem access from rewriting the whole chain — so heads are pinned
 * into git-tracked evidence (immutable history) and optionally posted to an
 * external anchor endpoint (WORM bucket / timestamp service / ledger).
 *
 * Usage: node scripts/anchor-evidence.mjs   [ARENA_CIN_ANCHOR_URL optional]
 */
import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';

const sha = (p) => crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex');
const JOBS = path.join('.runtime', 'jobs');
const OUT = path.join('evidence', 'arena-cin-chain-anchors.json');

const anchors = fs.existsSync(OUT) ? JSON.parse(fs.readFileSync(OUT, 'utf8')) : { schema: 'wrasal-chain-anchors/v1', anchors: {} };
let added = 0;
if (fs.existsSync(JOBS)) {
  for (const id of fs.readdirSync(JOBS)) {
    const cp = path.join(JOBS, id, 'evidence-chain.json');
    if (!fs.existsSync(cp)) continue;
    const chain = JSON.parse(fs.readFileSync(cp, 'utf8'));
    if (!chain.entries?.length) continue;
    const head = chain.entries[chain.entries.length - 1];
    const prev = anchors.anchors[id];
    if (prev && prev.head_hash === head.hash) continue;
    anchors.anchors[id] = {
      job_id: id, head_seq: head.seq, head_hash: head.hash,
      chain_file_sha256: sha(cp), anchored_at: new Date().toISOString(),
    };
    added += 1;
  }
}
anchors.last_anchored_at = new Date().toISOString();
fs.mkdirSync('evidence', { recursive: true });
fs.writeFileSync(OUT, JSON.stringify(anchors, null, 2));
console.log(`anchored ${added} chain head(s) into ${OUT} (git-tracked)`);

const url = process.env.ARENA_CIN_ANCHOR_URL;
if (url) {
  const r = await fetch(url, { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify(anchors) });
  console.log(`external anchor ${url} -> http ${r.status}`);
} else {
  console.log('no ARENA_CIN_ANCHOR_URL set; commit the anchors file to pin heads in git history');
}
