# 03 — Scene DNA Specification

Machine-readable twin: `data/scene_dna.json` (schema `wrasal-scene-dna/v1`). Reusable blank: `templates/scene_dna.template.json`.

**Scene ID:** `SCN-ARENA-CIN-001` — working title *"The Crimson Oath"* (four-tableau desert-war sequence).
**Status:** `DRAFT — pending G0`.

---

## 3.1 Technical envelope

| Parameter | Value |
|---|---|
| Aspect | 2.39:1 (extraction from 16:9 sensor safe-area; protect 90% title-safe) |
| Frame rate | 24 fps true (no speed ramps; shutter 180° = 1/48 s) |
| Finish | 4K: 3996×1668 (DCI) primary; 3840×1608 UHD-safe alternate |
| Color | Rec.709 display render with filmic tone map (print-film emulation); ACEScg working space if pipeline supports (verify) |
| Grain | 35 mm-equivalent fine grain, luminance-coupled, strength 2/5, static pattern per shot (no crawling) |
| Halation | Red-edge halation around practicals/sun only, radius ≤ 1.5% frame height |
| Gate weave | ≤ 0.05% frame height (near-zero) |
| Subtitles | None burned in; `가자!` in reference = source localization placeholder, excluded |

## 3.2 Palette doctrine (sampled — see `01` §1.2)

- **Family 1 — Sand & cream (A):** P-01…P-04. Warm desaturated beige field; costume one notch lighter than background; mentor neutral near-black as value anchor.
- **Family 2 — Fire & dusk (B):** P-05…P-09. Two-temperature: flame 1900–2200 K vs sky 9000 K; adobe carries the orange (P-06); the only cool accent is ANOM-01's slit (P-09).
- **Family 3 — Haze pink (C):** P-10…P-12 + frontal black P-17 `#100C09`. One luminance field + silhouette profile + rim.
- **Family 4 — Crimson storm (D):** P-13…P-16. Monochrome red ramp; subject value ≤ P-16.
- **Rule:** cross-shot grading may shift warmth but never hue-family; a shot outside its family fails QC-201.

## 3.3 Tone & contrast doctrine

| Shot | Key:fill | Black point | Highlight policy |
|---|---|---|---|
| A | 2.5:1 | warm lift (+2 IRE warm-tinted) | no clips |
| B | 6:1 in fire pools | deep but textured | fire cores may clip ≤ 0.5% px |
| C | 5:1 (backlit) | frontal profile near-black legal | sun disc clips (only legal full clip) |
| D | n/a (silhouette) | subject −6…−8 stops vs sky | sky shoulder soft; glow zone ≤ 5% px near-clip |

## 3.4 Light doctrine

1. Every photon motivated: sun state, fire, or sun-through-dust. No sourceless fill.
2. Color temperature is narrative: soft neutral-warm (A) → fire-vs-dusk split (B) → low gold (C) → dust-red diffuse (D).
3. Flicker is physical: fire flicker 6–9 Hz natural variance; never periodic.
4. Backlight hierarchy: A none → B rim-from-fire → C sun rim → D total silhouette. Escalation is deliberate.

## 3.5 Wind & atmosphere doctrine

| Shot | Wind (Beaufort) | Screen vector | Carriers |
|---|---|---|---|
| A | 1–2 | 270° | hood edge flutter, dust motes |
| B | 2–3 + fire draft | 270° | smoke drift, ember travel |
| C | 5–6 gusting | 270° | hair, cloak, haze streaks |
| D | 6–7 | 270° | cape, crest dust plume, cloud shear |

**Single-vector rule:** all wind-born elements move screen-left (270°) in every shot. Any rightward drift fails QC-203.

## 3.6 Composition doctrine

- Faces on thirds intersect; gaze/wind leads into empty space (negative space ≥ 30% of frame in gaze direction).
- Horizon: high in B (oppression), low in D (myth), absent in A/C (intimacy).
- Silhouette punctuation only at mythic beats; partial silhouette at emotional beats.
- Anomaly (ANOM-01) never centered, never largest value contrast; dread by placement.

## 3.7 Texture & realism doctrine (hard restrictions)

- Natural human anatomy; pore-level skin with dust/sweat; **no artificial smoothing** (fails QC-108).
- Physical plausibility: gravity, mass, contact shadows, correct archery/equine mechanics.
- No exaggerated fantasy rendering: no glow auras, no saturated magic FX, no stylized physics.
- Fabric: linen/wool/leather weave visible; no synthetic sheen.

## 3.8 Continuity vectors (cross-shot locks)

| Vector | Lock |
|---|---|
| CH-01 wardrobe | cream hooded linen robe, hood UP, bow: wood recurve, no ornament |
| CH-03 wardrobe | dark leather pauldron left shoulder, charcoal cloak, hair unbound |
| Wind vector | 270° all shots |
| Grain/halation | single package-wide recipe (§3.1) |
| Value grammar | escalation ladder A→B→C→D per `02` |

## 3.9 Governance block

- All tool-capability dependencies: `data/capability_matrix.json` (UNVERIFIED until documented).
- Creative state: DRAFT. Promotion only via gates G0–G4 with named human sign-off.
- Assumptions register: `05` §5.3 (story links), `13` (physics assumptions), capability matrix (tool claims).
