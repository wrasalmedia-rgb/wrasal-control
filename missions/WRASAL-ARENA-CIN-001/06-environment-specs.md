# 06 — Environment Specifications

Four environments, one per plate. Each spec is buildable as (a) location scout brief, (b) set-build brief, or (c) generative environment prompt block. Values cross-linked to `data/scene_dna.json`.

---

## ENV-01 — Dune Sea, Soft Day (SHOT-A background)

- **Geography:** open erg; wind-shaped barchan dunes; no vegetation, no rocks, no horizon structures.
- **Surface:** fine sand, ripple wavelength 8–15 cm; albedo warm (P-01); footprints forbidden in frame.
- **Sky/atmos:** high thin overcast or dust-veiled sun → shadowless soft key; visibility > 5 km; air clean with sparse motes.
- **Sun state:** elevation ≈ 35°, azimuth camera-left 45°, diffused (disc not visible).
- **Wind:** Beaufort 1–2, vector 270°.
- **Sound bed:** low wind hiss, cloth.
- **Gen prompt block:** `endless wind-rippled sand dunes, soft shadowless daylight, warm beige air, shallow depth melt, no vegetation, no structures, no footprints`.

## ENV-02 — Adobe Village Street, Burning Night (SHOT-B)

- **Geography:** single straight street 6–8 m wide, one-storey mud-brick (adobe) buildings both sides, flat roofs, external stair right side (per plate), doorway recesses left.
- **Materials:** sun-dried brick + mud plaster, straw-tempered; walls scarred, soot streaks above fire zones; ground packed earth + sand.
- **Destruction state:** mid-raid — two fire pools (left foreground firewood pile; right cart with spoked wheel), scattered debris, no corpses, no visible flames on roofs (roof line dark).
- **Sky/atmos:** civil dusk → night; deep blue-teal (P-05) zenith; smoke layers 2–4 m altitude backlit by fire.
- **Sun state:** below horizon; ambient = sky only (≈9000 K equivalent).
- **Wind:** Beaufort 2–3 + fire-induced draft; smoke vector 270°.
- **Anomaly placement:** ANOM-01 at street end, 60–80 m out, legs straddling wall line, head above roof line; slit facing camera.
- **Sound bed:** fire roar, structural creaks, distant groan.
- **Gen prompt block:** `night raid on mud-brick desert village, straight street, adobe walls lit orange by ground fires, burning wooden cart with spoked wheel, smoke layers backlit by flame, deep teal dusk sky, tall dark tripod silhouette with one cold white slit at street end`.

## ENV-03 — Desert Plain, Dust Sunset (SHOT-C)

- **Geography:** flat plain to horizon; horizon line at lower third; no dunes in frame (flat melt).
- **Surface:** hardpan + sand sheet; invisible under haze.
- **Sky/atmos:** uniform dust haze, visibility ≈ 300 m; sun disc visible but soft-edged (P-11), elevation ≈ 8°; field pink (P-10).
- **Sun state:** 3200 K effective through dust; hard backlight, long shadows toward camera (hidden by frame).
- **Wind:** Beaufort 5–6 gusting; vector 270°; haze streaks occasional.
- **Sound bed:** wind slap, grit tick.
- **Gen prompt block:** `flat desert plain at sunset through thick dust haze, soft white sun disc low in pink sky, uniform luminance field, no landmarks, wind-streaked air`.

## ENV-04 — Dune Crest vs. Storm Front (SHOT-D)

- **Geography:** single sharp dune crest running 270°→90° across lower third; slip face toward camera in shadow (P-16-adjacent #3C050B).
- **Surface:** crest knife-edge with dust plume bleeding 270°; slip face smooth, no tracks.
- **Sky/atmos:** towering dust-storm cumulus filling upper two-thirds; boil structure slow (≤2% frame/s); luminance ramp: glow lower-left (P-15) → deep red upper-right (P-14); sun fully hidden.
- **Wind:** Beaufort 6–7; vector 270°; cape/plume/cloud shear aligned.
- **Sound bed:** wind roar, sub-bass.
- **Gen prompt block:** `knife-edge dune crest against towering crimson dust-storm clouds, sun hidden behind the storm, bright dust glow at lower left horizon, deep red cloud mass upper right, slow boiling cloud motion, crest dust plume drifting left`.

---

## 6.5 Cross-environment continuity

1. Same desert world: sand hue family constant (P-01 ↔ P-06 tint ↔ P-15 glow share warm axis).
2. Wind vector 270° in all four (QC-203).
3. Time-of-day progression is **grammatical, not factual** (ASM-05): soft day → night → sunset → storm; do not "correct" the order.
4. No modern traces: no power lines, glass, plastics, refined timber, signage (QC-110).
5. Scale cues: human-scaled architecture in ENV-02; ANOM-01 the only non-human scale.
