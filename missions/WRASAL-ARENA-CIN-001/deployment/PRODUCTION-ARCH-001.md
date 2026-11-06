# PRODUCTION-ARCH-001 — Dependency Audit & Vercel/Worker/Storage Target Architecture

Reviewer instruction: *before deploying to Vercel, verify whether the current application depends on persistent local files, in-process encoding, or long-running jobs; if so, conventional serverless deployment of the whole app is inappropriate.* Verified below by code audit of `app/server.mjs`, `tools/render_plate_test.py`.

## 1. Dependency audit (verified, 2026-11-06)

| Dependency | Present? | Evidence |
|---|---|---|
| Persistent local files | **YES** | job state + media + QC in `.runtime/jobs/<id>/`; encoder in `tools/pylibs/`; plates in mission dir. Serverless FS is ephemeral → state lost between invocations |
| In-process encoding | **YES** | server spawns `python3 tools/render_plate_test.py`; encode runs seconds-to-minutes inside the request-originated process |
| Long-running jobs | **YES** | external-provider poll loop up to 600 s; tech-viz encode ~10-20 s; both exceed typical serverless limits and die with the invocation |
| Secrets | env-only | `ARENA_CIN_PROVIDER_*`, `PORT` — no secrets in repo (compliant) |
| Build step | none | plain Node 22 + static HTML (Vercel-friendly for the stateless parts) |

**Conclusion:** deploying the entire application as one conventional serverless function is **inappropriate**. The reviewer's preferred split is confirmed.

## 2. Target architecture

```
[Vercel]  dashboard (app/ui) + stateless API gateway
             │  job store driver (env-configured)
             ▼
[Durable storage]  job records, media objects, manifests, QC records
                   (S3-compatible bucket or managed DB; checksums preserved)
             ▲
             │ queue (store-backed)
[Persistent worker]  same Node codebase in worker mode:
                   encode orchestration, provider polling, ingest validation
```

- **Vercel** serves UI + gateway: workspace reads, job create/list, QC record, manifest export — all stateless against the store.
- **Worker** (container/VM: Fly/Railway/EC2 or the Arena sandbox) executes jobs exactly as today; unchanged job semantics.
- **Durable storage** replaces `.runtime/` when cross-host; local driver remains for sandbox/staging.

## 3. Incremental migration (no discard of existing Node app)

1. **Store driver seam (small):** wrap job/media/QC reads-writes behind `store.mjs` with two implementations: `local` (current `.runtime/`) and `s3` (later). All existing endpoints keep behavior; driver chosen by env `ARENA_CIN_STORE=local|s3`.
2. **Worker split:** add `--worker` mode: server boots without HTTP listener, polls the store queue; API mode enqueues instead of `setImmediate(runJob)`. File-queue suffices single-host; store-backed queue for cross-host.
3. **Vercel deploy of api+ui:** `vercel link` in `app/`, node22, env: store credentials + `ARENA_CIN_STORE=s3`; no encoder needed on Vercel (worker owns encode).
4. **Worker host deploy:** same commit, `--worker`, env: store + provider secrets.
5. **Ingest path unchanged:** external footage (e.g. reviewer-environment Runway test) enters via `POST /api/jobs/ingest` regardless of topology.
6. **Smoke per topology:** `scripts/smoke-app.mjs` extended per deployment (local now; gateway+worker pair later).

Each step is independently shippable; staging sandbox keeps working throughout.

## 4. Non-goals / invariants

- No second provider framework (Rule: reuse implemented adapters).
- Job semantics, QC/export formats, governance records unchanged by topology.
- Tech-viz vs AI-generation labeling survives every migration step (release notes standing distinction).
- Human gates unaffected: production deploy of any topology requires explicit authorization (currently NOT_AUTHORIZED).
