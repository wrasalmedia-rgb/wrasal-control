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

## Known limitations (rc1)

1. Job store is local filesystem (`.runtime/`) — single-host only; see `PRODUCTION-ARCH-001.md`.
2. In-process encode + long polls — incompatible with plain serverless; worker split planned.
3. Ingested external metadata is **as-reported**: provider claims require documentation before VERIFIED status (QC-900, capability matrix).
4. Rights: REF-ONLY conditioning assets; commercial clearance pending G4/QC-111.
5. Creative acceptance pending G0 formal + G1/G2 human reviews.
