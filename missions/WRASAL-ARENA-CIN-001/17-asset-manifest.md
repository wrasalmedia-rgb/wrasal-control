# 17 — Production Asset Manifest

Machine-readable: `data/manifest.json`. Status vocabulary: `EXISTING | TO_CREATE | EXTERNAL | DERIVED`.
Clearance column: `REF-ONLY` = reference use only, no redistribution claims about source; `ORIGINAL` = created by this production; `CLEAR-G4` = requires legal scan at G4.

---

## 17.1 Reference & plates

| Asset | Path | Type | Status | Checksum (sha256, prefix) | Clearance |
|---|---|---|---|---|---|
| Source grid | `reference/source/image-1.png` | PNG 1920×824 | EXISTING | `bea6ed1c…cc20` | REF-ONLY |
| Plate A | `reference/plates/shot-A.png` | PNG 960×412 | DERIVED | `2d05dbf7…d158` | REF-ONLY |
| Plate B | `reference/plates/shot-B.png` | PNG 960×412 | DERIVED | `a32dc734…342a` | REF-ONLY |
| Plate C | `reference/plates/shot-C.png` | PNG 960×412 | DERIVED | `065a8e42…3a1f` | REF-ONLY |
| Plate D | `reference/plates/shot-D.png` | PNG 960×412 | DERIVED | `d8a7d0b1…b8bc` | REF-ONLY |
| Plate C clean | `reference/plates/prep/shot-C-clean.png` | PNG 960×412 | TO_CREATE (P0.3) | — | ORIGINAL |
| Crop script | `reference/make-plates.sh` | sh | EXISTING | — | ORIGINAL |

## 17.2 Specs & registers (this package)

| Asset | Path | Status |
|---|---|---|
| Mission index + gates | `README.md` | EXISTING |
| Deliverables 01–16 | `01-*.md` … `16-*.md` | EXISTING |
| Scene DNA | `data/scene_dna.json` | EXISTING |
| Shot DNA ×4 | `data/shot_dna.json` | EXISTING |
| Prompts (T2V+I2V) | `data/prompts.json` | EXISTING |
| Negatives | `data/negative_constraints.json` | EXISTING |
| Risk register | `data/risk_register.json` | EXISTING |
| Rubric | `data/rubric.json` | EXISTING |
| Capability matrix | `data/capability_matrix.json` | EXISTING |
| Manifest (machine) | `data/manifest.json` | EXISTING |

## 17.3 Templates (reusable)

| Asset | Path |
|---|---|
| Scene DNA blank | `templates/scene_dna.template.json` |
| Shot DNA blank | `templates/shot_dna.template.json` |
| T2V prompt blank | `templates/prompt.t2v.template.json` |
| I2V prompt blank | `templates/prompt.i2v.template.json` |
| Negatives blank | `templates/negative_constraints.template.json` |
| QC checklist blank | `templates/qc_checklist.template.json` |
| Score sheet blank | `templates/evaluation_scoresheet.template.json` |
| Prompt authoring guide | `templates/PROMPT-AUTHORING-TEMPLATE.md` |

## 17.4 Production assets to create (pipeline outputs)

| Asset | Stage | Owner | Notes |
|---|---|---|---|
| Look-dev stills ×4 | P0/G1 | DP | face/wardrobe locks source |
| Show LUT | P0/G1 | colorist | `03` §3.1–3.3 recipe |
| Candidate batches (video) | P1 | gen operator | logs per candidate mandatory |
| Score sheets | P1/P5 | panel | `templates/evaluation_scoresheet.template.json` |
| QC sheets | P1–P8 | QC lead | `templates/qc_checklist.template.json` |
| 4K masters + alternates | P8 | post sup | checksums → manifest |
| Audio stems + M&E | P7 | sound sup | -24 LKFS anchor |
| Run logs (model/seed/params) | P1 | gen operator | reproducibility evidence |

## 17.5 External dependencies (verify before use)

| Class | Candidate examples (non-endorsing) | Capability claims | Status |
|---|---|---|---|
| T2V model | per G2 comparison | see CAP-01…CAP-09 | UNVERIFIED |
| I2V model | per G2 comparison | CAP-03, CAP-06 | UNVERIFIED |
| Supervised upscaler | per G3 test | CAP-02 | UNVERIFIED |
| Inpaint tool | P0.3 | CAP-10 | UNVERIFIED |
| Color system | P5 | ACES support CAP-11 | UNVERIFIED |
| Flicker/stabilize tools | P4 | CAP-12 | UNVERIFIED |

## 17.6 Storage & retention

- Mission package lives in-repo (control + specs + templates + reference).
- Large media (candidates, masters) stored OUT of git per repo convention; referenced by checksum + external location recorded in `data/manifest.json` → `external_media` field when created.
- Retention: keep winning candidates + logs ≥ life of mission; rejected batches purge-optional after G3.
