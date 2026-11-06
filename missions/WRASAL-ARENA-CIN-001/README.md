# WRASAL-ARENA-CIN-001 — AI-Assisted Cinematic Reproduction Package

- **Mission ID:** `WRASAL-ARENA-CIN-001`
- **Recorded:** `2026-11-06`
- **Role frame:** senior cinematographer / film director / VFX supervisor / AI video production architect
- **Visual standard:** photorealistic live-action cinema
- **Finish target:** `2.39:1` · `24 fps` · `4K` (`3996×1668` DCI crop; `3840×1608` UHD-safe alternate)
- **Source reference:** `reference/source/image-1.png` (four-frame grid, 1920×824, sha256 `bea6ed1c…cc20`)
- **Control record:** `work_orders/WRASAL-0011.json` (this repo root)

---

## 0. Standing interpretation rules

1. **The four frames are a visual reference, not proof of narrative continuity.** They are treated as four independent look-dev plates (`SHOT-A…SHOT-D`) that share a candidate visual grammar. Any story linkage (e.g. "the rider in SHOT-D is the woman in SHOT-C") is an **assumption** flagged `ASSUMED` and requires human ratification at gate `G0`.
2. **The reference contains a burned-in Korean subtitle (`가자!`) in SHOT-C.** It is treated as a *localization placeholder of the source*, never as part of the recreation. All plates derived from SHOT-C must be inpainted clean before use as first frames.
3. **Verified vs. assumed is a first-class distinction.** Every capability claim about external tooling lives in `data/capability_matrix.json` with status `UNVERIFIED` until a human attaches vendor documentation (URL + access date). No deliverable in this package asserts a model feature as fact.
4. **Human creative approval governs all final decisions.** Gates `G0–G4` (below) are blocking. Executor pass ≠ canonical acceptance (per `work_orders/status-vocabulary.json`).
5. **Restrictions are hard constraints:** natural human anatomy; physical plausibility; no exaggerated fantasy rendering; no artificial skin smoothing.
6. **Reference asset rights:** `reference/source/image-1.png` and all derived plates are **REF-ONLY** research/look-dev assets. Repository inclusion establishes **no license** to redistribute, publish, or commercially reproduce the source frames or closely traceable derivatives. Final deliverables must be synthesized original footage; any use traceable to source frames requires rights clearance at G4 (QC-111 / CLEAR-G4).
7. **G0-REC-001 working interpretation (2026-11-06, conditional):** the four plates are **independent cinematic test cases** under one unified evaluation methodology; no presumed shared character identity or fictional universe; the shared visual grammar is a **proposed direction for creator consideration**, not a ratified story fact; character continuity applies only where a character is explicitly established as recurring (currently: none). Formal G0 acceptance remains **PENDING** until exact assumption definitions and approval authority are reconciled.

---

## 1. Deliverable map (17 items → files)

| # | Deliverable | File |
|---|---|---|
| 1 | Visual reference analysis | `01-visual-reference-analysis.md` |
| 2 | Four-shot cinematic breakdown | `02-shot-breakdown.md` |
| 3 | Scene DNA specification | `03-scene-dna.md` + `data/scene_dna.json` |
| 4 | Shot DNA specifications | `04-shot-dna.md` + `data/shot_dna.json` |
| 5 | Character continuity requirements | `05-character-continuity.md` |
| 6 | Environment specifications | `06-environment-specs.md` |
| 7 | Lighting diagrams (text) | `07-lighting-diagrams.md` |
| 8 | Camera & lens specifications | `08-camera-lens-specs.md` |
| 9 | Actor performance directions | `09-performance-direction.md` |
| 10 | Text-to-video prompts | `10-text-to-video-prompts.md` + `data/prompts.json` |
| 11 | Image-to-video prompts | `11-image-to-video-prompts.md` + `data/prompts.json` |
| 12 | Negative constraints | `12-negative-constraints.md` + `data/negative_constraints.json` |
| 13 | Motion & physics risk assessment | `13-motion-physics-risk.md` + `data/risk_register.json` |
| 14 | Video model evaluation rubric | `14-model-evaluation-rubric.md` + `data/rubric.json` |
| 15 | Postproduction workflow | `15-postproduction-workflow.md` |
| 16 | Quality-control checklist | `16-qc-checklist.md` + `templates/qc_checklist.template.json` |
| 17 | Production asset manifest | `17-asset-manifest.md` + `data/manifest.json` |

Reusable templates (not one-off prompts): `templates/` — scene DNA, shot DNA, T2V prompt, I2V prompt, negative constraints, QC checklist, evaluation score sheet, plus `templates/PROMPT-AUTHORING-TEMPLATE.md`.

Reference assets: `reference/source/image-1.png` (authoritative plate) and `reference/plates/shot-{A,B,C,D}.png` (960×412 quadrant crops, reproducible via `reference/make-plates.sh`).

---

## 2. Approval gates (blocking, human-only)

| Gate | Decision | Required sign-offs | Input |
|---|---|---|---|
| `G0` | Concept & continuity lock: confirm/refute assumed story links, lock palette & doctrine | Director + DP | `01`, `02`, `03`, `05` |
| `G1` | Look-dev lock: approve still-frame tests per shot DNA (framing, light, texture) | Director + DP + VFX sup | `04`, `06`, `07`, `08` |
| `G2` | Motion-test lock: approve 2–5 s motion tests per shot (physics, shutter feel, temporal stability) | Director + VFX sup | `10`, `11`, `12`, `13` |
| `G3` | Shot approval: each final shot scores ≥ acceptance threshold on the rubric | Director + DP + VFX sup | `14`, `16` |
| `G4` | Master approval: conform, color, audio, 4K master release | Director + Producer | `15`, `16` |

**Rule of non-implication:** passing QC checks or rubric thresholds establishes technical conformity only; it does not constitute creative acceptance. Only a named human sign-off at a gate promotes state.

---

## 3. Governance registers

- `data/capability_matrix.json` — every external-tool capability claim used anywhere in this package, status `UNVERIFIED` by default, with `evidence_required` and `fallback` fields. Fill before relying on any claim.
- `data/risk_register.json` — motion/physics/AI-failure risks with mitigations and QC gates.
- `work_orders/WRASAL-0011.json` — S2/S3 control record for this mission (execution vs. canonical acceptance separated per repo vocabulary).

---

## 4. Package usage (short loop)

1. Read `03` (scene DNA) → instantiate `templates/scene_dna.template.json` for a new sequence.
2. Per shot: copy `templates/shot_dna.template.json` → fill from `04`; derive prompts from `templates/prompt.t2v.template.json` / `prompt.i2v.template.json`; attach `templates/negative_constraints.template.json`.
3. Generate candidates → score with `templates/evaluation_scoresheet.template.json` against `data/rubric.json` → reject or forward.
4. Run `templates/qc_checklist.template.json` per shot and per master; record gate sign-offs in the mission README changelog.

## 5. Changelog

| Date | Change | Authority |
|---|---|---|
| 2026-11-06 | Package v1 drafted (deliverables 1–17, templates, registers) | Arena external execution worker; **all creative states DRAFT pending G0** |
| 2026-11-06 | G0-REC-001 recorded: conditional approval of four-independent-test strategy; assumptions ASM-01…05 stay UNRATIFIED pending exact-definition review; SHOT-D rider = CH-04 until evidence; reference rights note added (§0 rule 6). Formal G0 acceptance PENDING | Reviewer directive (human); recorded by Arena worker — **not a ratification** |
| 2026-11-06 | SHOT-C LOOKDEV-001 stage 1 complete: plates/manifest verified, subtitle-free derivative with QC-002 confinement evidence, spec reference, 5 s test run sheet staged. Stage 2 (I2V comparison) BLOCKED — no i2v tooling in Arena session (probes `runway`, `sora` unsupported) | `lookdev/SHOT-C-LOOKDEV-001/`; `work_orders/WRASAL-0012.json` |
| 2026-11-06 | Production sandbox deployed: Cinematic Production Console v0.1.0-rc1 (workspace/generate/jobs/review/export) on `0.0.0.0:8787`; real 5 s/120 fr MP4 tech-viz job + smoke 19/19; AI generation blocked (WRASAL-0014); Vercel path + rollback documented | `deployment/SANDBOX-DEPLOY-001.md`; `work_orders/WRASAL-0013.json`; release approval PENDING |
| 2026-11-06 | RELEASE-AUTH recorded: v0.1.0-rc1 **SANDBOX CONDITIONALLY_ACCEPTED / PRODUCTION NOT_AUTHORIZED**; tech-viz≠AI distinction surfaced in dashboard, release notes, evidence; external-ingest adapter + CLI for footage from other environments; production architecture audit (serverless-inappropriate confirmed) + incremental Vercel/worker/storage plan; smoke extended 22/22 | reviewer directive 2026-11-06; `deployment/RELEASE-NOTES-v0.1.0-rc1.md`, `deployment/PRODUCTION-ARCH-001.md`; `work_orders/WRASAL-0015.json` |
| 2026-11-06 | Production security gate implemented on ingest (bearer auth / loopback-default, streamed capped uploads, deep media validation w/ decode, isolated storage + reject quarantine, immutable metadata + amendment log, rate limit + quota, evidence hash chain + /verify); SHOT-C-I2V-001 test kit with plate authorization scope + return-metadata schema; smoke 34/34 | reviewer directive §02–§05; `work_orders/WRASAL-0016.json` |
| 2026-11-06 | Security review response: fail-closed production auth mode + read authz on footage/manifest/evidence (session login), chain-head anchoring into git-tracked evidence + optional external anchor, **HOLD-CIN-PLATE-001** (reference plates NO-GO for external generation until rights evidence or G1-approved synthetic substitute), synthetic substitute candidate generated; smoke 42/42 | reviewer directive (security review); `work_orders/WRASAL-0017.json` |
