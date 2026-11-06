# SANDBOX-DEPLOY-001 — Production Sandbox Build, Test, Verify, Deploy

- **Authority:** WRASAL sandbox-to-deployment directive (2026-11-06), P0.
- **App:** `missions/WRASAL-ARENA-CIN-001/app/` — "Cinematic Production Console" v0.1.0-rc1 (zero-dependency Node 22 HTTP server + single-file dashboard).
- **Control records:** `work_orders/WRASAL-0013.json` (build/deploy, passed), `work_orders/WRASAL-0014.json` (AI generation, blocked).
- **Rule compliance:** no new framework/control plane (Rule 1); no fabricated execution — every job record references real bytes (Rule 2); approvals stay separate (Rule 3); deployment = running process + smoke evidence, not a build log (Rule 4); every blocker carries an exit path (Rule 5).

---

## 1. Phase status (honest, evidence-linked)

| # | Phase | Status | Evidence |
|---|---|---|---|
| 01 | Repository verification | **COMPLETE** | commits `e472655…b4ea023`; `npm test` PASS; deps pinned (`js-yaml 4.3.2`) |
| 02 | Sandbox setup | **COMPLETE** | `scripts/setup-encoder.sh` (PyAV 18.1.0/libx264 → `tools/pylibs`, git-ignored, idempotent); console server boots on `0.0.0.0:8787` |
| 03 | Asset preparation | **COMPLETE with rights caveat** | plates + clean derivative checksum-verified in-app (`/api/workspace` live sha256); clearance = **REF-ONLY**, commercial clearance PENDING at G4/QC-111 — not misrepresented as cleared |
| 04 | Generation: SHOT-C 5 s video | **PARTIAL** — real playable 5.0 s/120 fr H.264 MP4 exists via `plate-render-techviz-v1` (tech-viz camera test, explicitly NOT AI generation); **AI generation BLOCKED** (no provider credentials, no Arena video connector) | job `job-mw4psw1m-702f7f`, 7,729,366 bytes; `.runtime/jobs/<id>/metadata.json`; blocker: WRASAL-0014 |
| 05 | Evaluation / QC report | **STATION BUILT; human review PENDING** | review station (side-by-side vs plate, rubric C1–C8 weighted, QC subset, hard-stop attestation, disposition); QC recorded via API in smoke; creative acceptance remains human gate |
| 06 | Production pipeline | **COMPLETE** | automated ingest → validate → encode → monitor → review → export; smoke 19/19 (`.runtime/smoke-report.json`) |
| 07 | Interface | **COMPLETE** | five functions: workspace, generate, jobs monitor, review, export — all against real job state |
| 08 | Deployment (staging) | **COMPLETE in-sandbox** | live process bound `0.0.0.0:8787`; Arena live-preview proxy serves it; Vercel not authenticated in this session — path documented §5 |
| 09 | Acceptance demonstration | **PIPELINE PROVEN; release approval PENDING** | smoke PASS 19/19 incl. failure handling + source integrity; human release approval not yet given (Rule 3) |
| 10 | Release candidate | **CANDIDATE v0.1.0-rc1 recorded** | `app/VERSION.json`; rollback §6; approval pending |

## 2. Architecture

```
browser dashboard (app/ui/index.html)
   │  relative URLs only (/api/…, /media via /api/jobs/:id/media)
   ▼
node:http server (app/server.mjs, zero deps, 0.0.0.0:8787)
   ├── /api/workspace   mission DNA, palette, plates+live checksums, providers, capability matrix, gates
   ├── /api/jobs        create/list/inspect (job.json per job in .runtime/jobs/<id>/)
   ├── /api/jobs/:id/media|metadata|qc|manifest
   └── job runner
        ├── plate-render-techviz-v1 → tools/render_plate_test.py (ImageMagick frames → PyAV/libx264 MP4)
        └── external-provider       → async HTTP contract (§4), credential-gated
runtime state: .runtime/jobs/<id>/{job.json,out.mp4,metadata.json,qc.json}  (git-ignored)
```

Failure semantics: `queued → running → succeeded | failed | blocked`. Blocked/failed always carry `error.code`, `error.exit` (Rule 5), and `source_preserved: true`; plates are read-only inputs, never mutated.

## 3. Runbook

```sh
sh scripts/setup-encoder.sh                     # idempotent encoder provisioning
node missions/WRASAL-ARENA-CIN-001/app/server.mjs   # PORT env optional (default 8787)
node scripts/smoke-app.mjs                      # SMOKE_BASE env optional; writes .runtime/smoke-report.json
```

## 3b. Security gate (production hardening, 2026-11-06)

Mutations (`POST /api/jobs`, `/api/jobs/ingest`, `/api/jobs/:id/qc`, `/metadata-amend`) require `Authorization: Bearer $ARENA_CIN_AUTH_TOKEN` when set; **without a token, mutations are loopback-only** — a publicly exposed instance is read-only until configured. Ingest is a **binary contract**: raw MP4 body streamed to disk under `ARENA_CIN_MAX_UPLOAD_BYTES` (default 64 MB), metadata base64 in `x-arena-cin-meta` (≤64 KB, write-once, amendments logged), deep validation via `tools/validate_media.py` (codec/dimension/duration policy + head/tail decode), rejects quarantined in `.runtime/ingest-rejects/`, per-IP rate limit (429) and storage quota (507), per-job tamper-evident evidence chain with `GET /api/jobs/:id/verify`. Env summary in `app/server.mjs` header comment.

## 4. External provider HTTP contract (for authorized AI generation)

- `POST $ARENA_CIN_PROVIDER_URL` body `{model, prompt, image (data-url PNG), duration_s, fps, aspect}` → `200 {job_id}`
- `GET $ARENA_CIN_PROVIDER_URL/jobs/<job_id>` → `{status: queued|running|succeeded|failed, video_url?, error?}` (polled 5 s, 600 s cap)
- `video_url` fetched server-side into the job dir; metadata records provider job id, plate sha, prompt hash.
- Auth: `Authorization: Bearer $ARENA_CIN_PROVIDER_KEY` when set. Secrets live in the deployment environment only — never in repo or chat.

## 5. Deployment targets

- **Current (authenticated):** Arena sandbox live preview of port 8787 (`https://8787-<sandbox-id>.e2b.app`). This is the only deployment target with credentials present in this session.
- **Vercel (recommended by reviewer, NOT authenticated here):** feasible for the stateless interface + API, but serverless functions cannot host the in-process job runner. Two compliant options: (a) keep jobs provider-side async (contract §4) and make the console stateless with an external job store (DB/object storage) — then Vercel works; (b) run the console as-is on a container/VM host (Fly/Railway/EC2) with `PORT` + env secrets. Exact unblock action: a human with Vercel org auth runs `vercel link` in `missions/WRASAL-ARENA-CIN-001/app/`, sets env secrets, and chooses (a) or (b). Recorded per Rule 5; not performed here because no Vercel credentials exist in this session.
- **AI generation unblock (WRASAL-0014):** set `ARENA_CIN_PROVIDER_URL/KEY/MODEL` in the deployment env per §4, or connect an Arena video connector. Probe log: `runway`, `sora`, `openai`, `luma` → all `unsupported` (2026-11-06, in `data/capability_matrix.json` evidence_log).

## 6. Rollback procedure

1. Identify previous release commit (recorded in `app/VERSION.json` at approval time; current candidate built on commit see WRASAL-0013 references).
2. `git checkout <prev-sha> -- missions/WRASAL-ARENA-CIN-001/app tools scripts` and restart the process (or redeploy previous commit on the target host).
3. `.runtime/` job store is independent of app code — jobs and evidence survive rollback; no migrations exist.
4. Re-run `node scripts/smoke-app.mjs`; require 19/19 before re-exposing the preview.

## 7. What this deployment is NOT

- Not AI-generated footage (tech-viz adapter is labeled as such in UI, metadata, manifests).
- Not creative acceptance (G0 formal acceptance pending; G1/G2 human reviews pending).
- Not rights clearance (REF-ONLY stands; G4/QC-111 pending).
- Not a Vercel production deployment (no authenticated target in session; path documented).
