# RELEASE NOTES — WRASAL-ARENA-CIN-001 v0.1.0-rc1

- **Recorded:** 2026-11-06
- **Authorization record:** reviewer directive "DEPLOYMENT CONTROL" (2026-11-06); executor record `work_orders/WRASAL-0015.json`
- **Applies to:** commit range `e472655…` (package) → current head; app `missions/WRASAL-ARENA-CIN-001/app/`

## Authorization block (verbatim, human decision)

```
RELEASE: WRASAL-ARENA-CIN-001
VERSION: v0.1.0-rc1
SANDBOX_STATUS: CONDITIONALLY_ACCEPTED
TECHNICAL_PIPELINE: DEMONSTRATED
AI_GENERATION: BLOCKED
CREATIVE_ACCEPTANCE: PENDING
PRODUCTION_DEPLOYMENT: NOT_AUTHORIZED
NEXT_GATE: AI_PROVIDER_INTEGRATION
```

**v0.1.0-rc1 is NOT promoted to production.** Staging acceptance is conditional; production authorization is withheld pending the next gate.

## Standing distinction (must remain visible in dashboard, release notes, evidence)

> The encoded five-second video demonstrates that the application can process and deliver video. It does **not** demonstrate that the AI generation adapter works.

- `plate-render-techviz-v1` outputs are **technical visualizations** (camera-move plate tests). Every job record, metadata file, export manifest, and UI surface labels them `NOT AI generation`.
- AI generation remains **BLOCKED** (`WRASAL-0014`): no provider credentials in the deployment environment; Arena connector probes `runway`, `sora`, `openai`, `luma` all `unsupported` (2026-11-06, re-probed `runway` again this turn — still unsupported in this sandbox).
- Environment note (reviewer): a Runway integration is discoverable in a **different execution environment** (their ChatGPT session). Sandboxes are not shared. The compliant path is: generate there, then **ingest** the resulting video + reported metadata into this console via `POST /api/jobs/ingest` (existing adapter extended, no new framework), or set `ARENA_CIN_PROVIDER_*` env here.

## Component assessment (reviewer findings, provisionally accepted)

| Component | Reported result | Decision |
|---|---|---|
| Repository validation | 936/936 PASS | accept provisionally |
| Deployment smoke tests | 19/19 PASS (now extended, see WRASAL-0015) | accept provisionally |
| Production console | running port 8787 | staging candidate |
| Video encoding | 120-frame H.264 MP4 | technical pipeline demonstrated |
| Shot submission / QC interface / evidence export / provider error handling | operational | pass (human review pending) |
| AI video generation | blocked | **P0 outstanding** |
| External production deployment | not completed | pending |
| Creative approval | not granted | pending |

## What rc1 contains

- Production package (17 deliverables, templates, registers), LOOKDEV-001 stage 1, G0-REC-001 dispositions.
- Cinematic Production Console: workspace, generate, jobs monitor, review station, export; zero-dependency Node 22.
- Tech-viz render adapter (PyAV/libx264) + reproducible encoder provisioning (`scripts/setup-encoder.sh`).
- External-provider adapter (async HTTP contract) + **external ingest endpoint** for footage produced in other environments.
- Deployment smoke suite (extended with ingest round-trip), deployment + rollback + production-architecture records.

## Addendum 2 — post-authorization hardening (2026-11-06, same day)

Second reviewer directive recorded: sandbox acceptance maintained; **production security gate** required before external exposure; NEXT_EXECUTION `SHOT-C-I2V-001`.

```
RELEASE: v0.1.0-rc1
SANDBOX: CONDITIONALLY_ACCEPTED
EXTERNAL_INGEST: IMPLEMENTED / SMOKE_TESTED
AI_GENERATION: BLOCKED
PRODUCTION_SECURITY: SANDBOX_HARDENED (token auth available; external exposure requires token + rc2 topology)
PRODUCTION_DEPLOYMENT: NOT_AUTHORIZED
NEXT_EXECUTION: SHOT-C-I2V-001
```

### Security gate implementation map (directive §02 → implementation → smoke evidence)

| Requirement | Implementation | Smoke check |
|---|---|---|
| Authentication + project-scoped authorization | `ARENA_CIN_AUTH_TOKEN` bearer required for all mutations when set; without token mutations are loopback-only (public = read-only); deployment instance = project scope | `auth.mutation_requires_token`, `auth.token_accepted`, `auth.ingest_requires_token` |
| Upload size limits + streaming control | request streamed to disk (`upload.part`), byte cap env-tunable (default 64 MB), 413 + reject record on overflow | `security.upload_cap_413` (isolated instance, 100 KB cap) |
| Media validation beyond signature | `tools/validate_media.py`: single video stream, codec allowlist (h264/vp9/av1), dimension/duration policy, **head+tail frame decode**; rejects quarantined in `.runtime/ingest-rejects/` with reasons | `ingest.media_deep_validation`, `ingest.rejects_invalid_media` (422) |
| Safe filenames + isolated storage | server-generated job ids; fixed filenames only; per-job isolated dirs; client metadata never used in filesystem paths; reject quarantine separate | by construction + `ingest.binary_accepted` |
| Protection against unauthorized metadata changes | reported blob write-once (`immutable: true`); changes only via authenticated append-only `amendments.json`; QC decisions append-only `qc-history.json` | `ingest.metadata_immutable_flag`, `qc.history_append_only` |
| Rate limits + storage quotas | per-IP ingest window (default 5/600 s → 429); jobs-dir quota (default 2 GB → 507) | `security.rate_limit_429`; quota path implemented, not smoke-exercised (would require filling quota) |
| Evidence integrity | per-job tamper-evident hash chain (`evidence-chain.json`), `/api/jobs/:id/verify`, chain embedded in export manifest; verify checks link integrity + latest-state content | `evidence.chain_verified`, `manifest.chain_included` |

Smoke suite now **34 checks** (`.runtime/smoke-report.json`).

### rc2 scope (directive §04, confirmed)

1. Secure external ingestion — **done in rc1 hardening** (above).
2. Durable job/asset storage — store-driver seam (`PRODUCTION-ARCH-001` step 1).
3. Separately executable worker — `--worker` mode (step 2).
4. Stateless dashboard + API gateway on Vercel (step 3).
5. End-to-end smoke against deployed topology (step 6).

No new dashboard, workflow engine, or database abstraction beyond what the existing implementation demonstrably requires.

## Addendum 3 — security review response (2026-11-06, same day)

Third reviewer directive recorded:

```
SANDBOX: CONDITIONALLY_ACCEPTED
SECURITY_IMPLEMENTATION: REPORTED_COMPLETE
SECURITY_VERIFICATION: PARTIAL
AI_GENERATION: BLOCKED
PRODUCTION_DEPLOYMENT: NOT_AUTHORIZED
NEXT_GATE: SHOT-C-I2V-001
```

Responses implemented in this revision:

1. **Fail-closed production auth.** `ARENA_CIN_AUTH_MODE=production` rejects every mutation when no token is configured (no loopback escape); sandbox loopback convenience remains dev-only and logs a warning. Smoke: `authprod.fail_closed_mutation`, `authprod.fail_closed_read`.
2. **Read authorization on sensitive endpoints.** In production mode, footage (`/media`), manifests, metadata, QC and verify endpoints require bearer or an HttpOnly session cookie obtained via `POST /api/auth/login`; dashboard shows a login gate. Smoke: `authprod.read_requires_auth`, `authprod.login_invalid_401`, `authprod.login_ok`, `authprod.session_read_jobs`, `authprod.session_read_media`, `authprod.media_without_session_401`.
3. **Chain anchoring outside app storage.** Reviewer note accepted verbatim: a hash chain detects change but proves neither authorship nor resistance to an attacker with filesystem access. `scripts/anchor-evidence.mjs` pins chain heads into git-tracked `evidence/arena-cin-chain-anchors.json` (immutable history outside `.runtime/`) and optionally posts to `ARENA_CIN_ANCHOR_URL` (WORM/timestamp/ledger) for production.
4. **Rights hold.** `HOLD-CIN-PLATE-001`: reference-derived plates are NO-GO for external generation until rights-holder evidence is committed or the synthetic substitute plate is G1-approved. Test kit updated; WRASAL-0014 cannot leave `blocked` without one of these.
5. **No specification expansion.** This revision adds only controls that unblock the two named outcomes (real footage, independently verified deployment); rc2 sequence unchanged per directive §04.

## Addendum 4 — Milestone 004 response: Track B deployment evidence (2026-11-06)

Governance block recorded:

```
SANDBOX: CONDITIONALLY_ACCEPTED
SECURITY: HARDENED / INDEPENDENT REVIEW PENDING
REFERENCE_PLATE: RIGHTS_HOLD_ACTIVE
SYNTHETIC_SUBSTITUTE: G1_APPROVAL_PENDING
AI_GENERATION: BLOCKED
PRODUCTION_DEPLOYMENT: PENDING
NEXT_ACCEPTANCE_EVIDENCE: REAL_AI_FOOTAGE_OR_VERIFIED_DEPLOYMENT
```

### Track B evidence (topology smoke 13/13, `.runtime/topology-smoke-report.json`)

| Required evidence | Result | Check |
|---|---|---|
| Durable storage: assets survive restart + worker replacement | shared-volume store; media served 200 after gateway restart; jobs continued after worker swap | `topo.durable_across_gateway_restart`, `topo.worker_replacement` |
| Worker separation: jobs execute independently of dashboard process | `ARENA_CIN_MODE=worker` polls the store; metadata carries `worker.id/mode`; gateway never executes inline | `topo.worker_executed`, `topo.gateway_stateless` |
| Stateless gateway: API without local persistent execution | gateway mode defers execution; serves from store only | `topo.gateway_stateless` |
| Production auth fails closed | unauthenticated reads/mutations 401 on production gateway (topology + live staging) | `topo.public_fail_closed`, curl evidence below |
| Publicly reachable authenticated staging URL | live gateway `0.0.0.0:8820` (production mode, token set at launch — value not committed; rotate before production) + worker `staging-w1`, behind the Arena preview proxy; loopback curl: jobs 401 / workspace 200 / mutation 401 / login 200 | this addendum + process records |
| Topology smoke: real upload, execution, review, export | binary ingest 201 → QC recorded → manifest with verified chain | `topo.real_upload_ingest`, `topo.review_qc_recorded`, `topo.export_manifest` |
| Rollback: previous release restorable | drill boots `2d8b995` from git history via worktree, serves workspace, fails closed; removed cleanly | `topo.rollback_previous_release_boots`, `topo.rollback_fail_closed` |

Honest scope note: durable storage is demonstrated on a **shared-volume store** (single host). The `s3`/cross-host driver from `PRODUCTION-ARCH-001` step 1 remains the production-cloud increment; worker/gateway modes and session persistence (file-backed sessions) are implemented now. Main single-mode suite remains green (42/42) — no regression, no second dashboard, no new framework.

### Track A status

Synthetic substitute provenance recorded (`lookdev/SHOT-C-I2V-001/substitute-provenance.json`: sha `b309d05d…`, tool, verbatim prompt, zero source-image inputs). Status **G1_APPROVAL_PENDING** — reviewer inspection required; recommendation is not authorization. HOLD-CIN-PLATE-001 unchanged.

## Known limitations (rc1)

1. Job store is local filesystem (`.runtime/`) — single-host only; see `PRODUCTION-ARCH-001.md`.
2. In-process encode + long polls — incompatible with plain serverless; worker split planned.
3. Ingested external metadata is **as-reported**: provider claims require documentation before VERIFIED status (QC-900, capability matrix).
4. Rights: REF-ONLY conditioning assets; commercial clearance pending G4/QC-111.
5. Creative acceptance pending G0 formal + G1/G2 human reviews.
