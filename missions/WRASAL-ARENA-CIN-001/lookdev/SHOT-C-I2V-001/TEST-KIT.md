# SHOT-C-I2V-001 — Test Kit for External AI Generation (Runway route)

- **Authority:** reviewer directive 2026-11-06 §03 (NEXT_EXECUTION: SHOT-C-I2V-001); WRASAL-0014 holds the gate.
- **Purpose:** one actual AI-assisted SHOT-C clip, generated in the reviewer's Runway environment, ingested → reviewed → QC → exported here with verifiable provenance.
- **No new framework:** ingest uses the existing `external-ingest` adapter (binary contract, security gate).

## 1. Plate card (the conditioning asset)

| Field | Value |
|---|---|
| Plate | `reference/plates/prep/shot-C-clean.png` (960×412) |
| sha256 | `d39a1cb306a4cccddfdc58ea14fd725b6ead71cf6d45fbcdc39b491984cb3d53` |
| Derivation | confined-patch subtitle removal from `reference/plates/shot-C.png` (sha `065a8e42…`); diff confined to `72×41+444+359`; evidence `../SHOT-C-LOOKDEV-001/qc-002-evidence.json` |
| Source | `reference/source/image-1.png` sha `bea6ed1c…` (REF-ONLY) |

**Authorization status: 🔴 HOLD-CIN-PLATE-001 ACTIVE (2026-11-06).** The scope below is an internal proposal only — *recording a permission scope is not proof of authorization* (reviewer directive §03). Generation against reference-derived plates is **NO-GO** until either (1) rights-holder clearance evidence is committed, or (2) the original synthetic substitute `reference/plates/alt/shot-C-synthetic-candidate.png` (text-derived from DNA-C, no source derivation) is approved at G1. See `PLATE-RIGHTS-HOLD.md`.

Proposed scope once released: private conditioning input for the named technical test in one selected Runway workspace. Not authorized: public distribution or commercial use of outputs traceable to the source frames; any use beyond SHOT-C-I2V-001. Formal rights clearance remains a human decision at G4/QC-111.

## 2. Generation spec

- **Prompt:** I2V-C from `data/prompts.json` with the recorded 5.0 s test override (beats: inhale 0–0.8 s, onset 0.8–2.0 s, sustain 2.0–3.5 s, glare hold 3.5–5.0 s).
- **Params:** first frame = plate above; duration 5.0 s; 24 fps; 2.39:1; motion MED.
- **Negatives (attach if the provider supports; else enforce in review):** N-GLOBAL + N-C; ABSOLUTE: no text/caption/glyph/watermark in any frame (subtitle reappearance = automatic fail, R-14).
- **Hard stops:** R-08 (scream anatomy), R-14 (text), R-15 (identity drift vs plate), R-18 (skin smoothing).

## 3. Required sequence and evidence binding

Every artifact carries `generation_id` + `shot_id=SHOT-C` + `test_id=SHOT-C-I2V-001`:

1. **Generate** in the selected Runway workspace; record provider job id, model, seed, params.
2. **Download** the raw file; compute sha256 locally; do not re-encode.
3. **Verify** locally (optional): container opens, ~5 s, 24 fps feel; note observations.
4. **Ingest** into the console (server re-validates deeply: codec/dimensions/duration + head/tail decode):
   ```bash
   node scripts/ingest-external.mjs --file shot-c-gen1.mp4 --shot SHOT-C \
        --meta return-metadata.json --source runway-<workspace> \
        --url https://8787-<sandbox-id>.e2b.app [--token $ARENA_CIN_AUTH_TOKEN]
   ```
5. **Review** in the dashboard (side-by-side vs plate; candidate class shows as-reported).
6. **QC** rubric C1–C8 (G2 thresholds: weighted ≥70, C6≥3, C7≥3) + QC-002/106/107/205/206/108 + hard-stop attestation.
7. **Export** manifest (includes evidence chain, plate sha, prompt hash, media validation, QC).

## 4. Return metadata

Fill `return-metadata.template.json` in the generating environment and ship it with the file (`--meta`). `plate_sha256` must equal the card value or the ingest provenance check fails review. Incomplete metadata does not block ingest but blocks G2 acceptance (evidence binding rule).

## 5. Definition of done (this test)

Playable ingested clip + complete return metadata + recorded QC + exported manifest, all sharing one `generation_id`; human review at G2; zero hard-stop instances. Only then does WRASAL-0014 move off `blocked`.
