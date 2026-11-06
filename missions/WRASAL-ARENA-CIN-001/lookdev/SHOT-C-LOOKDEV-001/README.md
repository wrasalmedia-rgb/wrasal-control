# SHOT-C / LOOKDEV-001 — Five-Second Cinematic Performance Test (Run Sheet)

- **Authority:** G0-REC-001 reviewer directive (2026-11-06): conditional approval of the four-independent-test strategy; SHOT-C first.
- **Control record:** `work_orders/WRASAL-0012.json` (stage 1). Stage 2 queued as next candidate work order.
- **Objective (per directive):** produce one technically controlled, five-second cinematic performance test of SHOT-C.
- **Definition of done (per directive):** a playable five-second shot, its source assets, reproducibility records, and a completed QC report.
- **Current status:** **stage 1 of 2 complete. Stage 2 BLOCKED — no image-to-video tooling exists in this Arena session** (evidence below). Nothing in this record claims footage exists.

---

## Execution sequence and status

| # | Step (per directive) | Status | Evidence |
|---|---|---|---|
| 1 | Verify committed source plate and manifest | **DONE** | sha256 of `reference/source/image-1.png` + 4 plates re-computed 2026-11-06, all match `data/manifest.json` (`bea6ed1c…`, `2d05dbf7…`, `a32dc734…`, `065a8e42…`, `d8a7d0b1…`) |
| 2 | Prepare subtitle-free derivative reference | **DONE** | `reference/plates/prep/shot-C-clean.png` (sha `d39a1cb3…`); QC-002 confinement evidence in `qc-002-evidence.json`; original preserved for provenance at `reference/plates/shot-C.png` |
| 3 | Establish approved character & exposure specifications | **DONE as spec record; approval pending G1** | DNA-C (`04-shot-dna.md`, `data/shot_dna.json`): 85 mm T4 profile, sun disc in frame, frontal plane P-17 `#100C09`, rim P-12/P-18, haze field P-10, ratio 5:1, halation policy; performance beats `09` §9.4; negatives N-GLOBAL+N-C |
| 4 | Run documented Arena image-to-video comparison | **BLOCKED** | No i2v tool in session toolset; Arena connector probes `runway` and `sora` both returned `unsupported` (2026-11-06). Comparison design below for external/human execution |
| 5 | Preserve original outputs and model metadata | **PENDING** (log table ready, §Metadata log) | — |
| 6 | Evaluate against existing QC rubric | **PENDING** | instantiate `templates/evaluation_scoresheet.template.json` + `qc_checklist.template.json` per candidate |
| 7 | Present results for human creative approval | **PENDING** | G1 (look-dev) then G2 (motion test) sign-offs |

## Test parameters (directive override recorded)

- **Duration:** 5.0 s / 120 fr (directive) — extends DNA-C's 3.5 s cut length; beat extension = sustain/glare-hold tail: inhale 0–0.8 s, onset 0.8–2.0 s, sustain 2.0–3.5 s, glare hold 3.5–5.0 s. DNA-C cut duration unchanged pending G1.
- **Conditioning plate:** `reference/plates/prep/shot-C-clean.png` (sha `d39a1cb3…`).
- **Prompt:** I2V-C (`data/prompts.json`) with `test_override.duration_s = 5.0`.
- **Negatives:** N-GLOBAL + N-C; ABSOLUTE text ban active (R-14).
- **Acceptance:** rubric G2 thresholds (`14`): weighted ≥70, C6 ≥3, C7 ≥3; hard-stop risks R-08/R-14/R-15/R-18 zero-instance.

## Comparison design (step 4, when tooling exists)

1. Candidates: ≥2 video models if available; identical plate, identical prompt hash, identical parameters; batch n ≥ 6 per model.
2. Log per candidate: model, version, seed, all parameters, prompt hash, plate sha, operator, date (§Metadata log).
3. Auto-reject: any glyph/text in any frame; aspect drift; hair crossing face; frontal-plane exposure lift.
4. Panel-score survivors (director/DP/VFX sup) per `14`; complete QC sheet per `16`.
5. Preserve originals unmodified (no re-encodes); mezzanine copies for review only.

## Metadata log (populate at execution)

| candidate_id | model | version | seed | parameters | prompt_hash | plate_sha | operator | date | weighted | disposition |
|---|---|---|---|---|---|---|---|---|---|---|
| — | — | — | — | — | — | d39a1cb3… | — | — | — | — |

## What unblocks step 4

- (a) an Arena connector exposing image-to-video generation (none as of 2026-11-06; probes evidenced), or
- (b) a human-executed batch on an external model using this run sheet, returning outputs + full metadata to external storage with checksums recorded here and in `data/manifest.json` → `external_media`.

## Governance notes

- Executor completion of stage 1 ≠ creative acceptance; G0 formal acceptance remains PENDING per G0-REC-001.
- CAP-10 (inpaint) remains UNVERIFIED pending vendor docs; internal P0 test logged in `data/capability_matrix.json` evidence_log.
- Reference assets are REF-ONLY: repository inclusion establishes no license to reproduce the source frames commercially (see mission README §0 rule 6; clearance at G4, QC-111).
