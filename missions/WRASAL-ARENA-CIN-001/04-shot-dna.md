# 04 — Shot DNA Specifications

Machine-readable twin: `data/shot_dna.json` (schema `wrasal-shot-dna/v1`, array of 4). Blank: `templates/shot_dna.template.json`.
Each shot DNA is the single source of truth from which prompts (`10`, `11`), negatives (`12`), risks (`13`) and QC (`16`) derive.

Common fields abbreviated here; full values in JSON.

---

## SHOT-A · DNA-A "The Young Archer's Oath"

- **Function:** intimacy / vow. **Plate:** `plates/shot-A.png`. **Gen mode:** I2V preferred (plate clean), T2V fallback.
- **Frame:** MCU, eye-level 1.35 m, 85 mm T2.8, focus near-eye, background bokeh ≥ +12 m.
- **Move:** locked + micro-breath ≤0.3°, 0.15 Hz. **Dur:** 4.0 s / 96 fr.
- **Light:** key soft 5200 K 45° cam-left (1.2 m source), fill sand-bounce + 1/4 card cam-right, 2.5:1, bg −1 stop. Kelvin span 5000–5400.
- **Atmos:** clean air, sparse dust motes in key.
- **Subjects:** CH-01 (draw hold), CH-02 torso OOF frame-right.
- **Wardrobe/props:** cream hooded linen (hood up); wood recurve bow + arrow nocked left of riser.
- **Beats:** settle → squint-aim → breath-hold → tremor → hold.
- **Physics:** string beside nose; draw elbow in arrow line; hood static except tremor; no arrow float.
- **VFX:** none required (practical look); grain/halation in post.
- **Audio:** cloth creak, limb tick, breath, wind bed.
- **Links:** CH-01/CH-02 identity lock `05`; palette family 1 `03` §3.2.
- **AI notes:** motion amplitude LOW; locked elements: hood folds, bow geometry, mentor position; risk refs R-01…R-03.

## SHOT-B · DNA-B "The Village Burns"

- **Function:** chaos / threat reveal. **Plate:** `plates/shot-B.png`. **Gen mode:** I2V preferred; ANOM-01 may need VFX pass.
- **Frame:** wide, low −12°, 0.6 m, 32 mm T4, focus 2.5 m→∞.
- **Move:** handheld reactive pan-left 8°/2 s then settle; horizon ≤1° off. **Dur:** 6.0 s / 144 fr.
- **Light:** fire pools ×2 (1900–2200 K, 6–9 Hz natural flicker), dusk sky 9000 K top fill, 6:1 pools; ANOM-01 slit cool white P-09, no street spill.
- **Atmos:** backlit smoke layers, ground dust at CH-05.
- **Subjects:** CH-05 crawl-stumble-recover-glance; ANOM-01 static-sway background.
- **Wardrobe/props:** CH-05 white wool robe soiled; burning cart (spoked wood wheel), firewood pool.
- **Beats:** crawl-push → hand-slip stumble → recover → eyeline up 25° at ANOM-01.
- **Physics:** smoke/embers drift 270°; contralateral crawl; wheel burns rim-inward; fire lean with draft.
- **VFX:** ANOM-01 CG (matte dark metal, 3 legs, single slit, 8–10 m); heat shimmer over fire.
- **Audio:** fire roar, wood pops, cloth drag, mechanical groan.
- **Links:** palette family 2; wind vector `03` §3.5.
- **AI notes:** motion amplitude HIGH (subject) / LOW (camera settle); locked: architecture layout, cart position; risk refs R-04…R-07.

## SHOT-C · DNA-C "The Call"

- **Function:** voice / turn. **Plate:** `plates/shot-C.png` **after subtitle inpaint** (QC-002). **Gen mode:** I2V preferred.
- **Frame:** MCU profile, eye-level 1.55 m, 85 mm T4, sun in frame, focus cheek rim.
- **Move:** handheld breathe + 2% push / 3.5 s. **Dur:** 3.5 s / 84 fr.
- **Light:** hard backlight sun 3200 K @ ≈8° elevation through haze; fill sky-bounce only 5:1; rim hair/jaw P-12; frontal value ≈ P-17; halation gentle, no streaks.
- **Atmos:** uniform dust haze, visibility ≈300 m, pink field P-10.
- **Subjects:** CH-03 profile scream-command.
- **Wardrobe/props:** leather pauldron left, charcoal cloak; hair unbound streaming 270°.
- **Beats:** inhale vs wind → scream onset (jaw wide, eyes open) → sustain → glare hold.
- **Physics:** hair vector constant 270°; no hair-through-face; jaw/teeth anatomy correct; **no burned-in text**.
- **VFX:** subtitle-region clean plate prep (pre-gen); optional breath vapor.
- **Audio:** wind slap, hair whip, scream, drum swell.
- **Links:** CH-03 identity lock `05`; palette family 3.
- **AI notes:** motion amplitude MED (hair/cloth) / face performance-critical; locked: sun position, haze density; risk refs R-08, R-09, R-14.

## SHOT-D · DNA-D "Rider on the Crimson Storm"

- **Function:** myth / punctuation. **Plate:** `plates/shot-D.png`. **Gen mode:** I2V preferred (silhouette protects identity).
- **Frame:** EW, low −8°, 75–100 mm T5.6–T8, focus ∞, expose for sky (subject −6…−8 stops).
- **Move:** locked-off; optional 1.5% push / 5 s. **Dur:** 5.0 s / 120 fr.
- **Light:** sun hidden behind dust wall; luminance ramp P-15 (lower-left) → P-14 (upper-right); no visible source.
- **Atmos:** boiling dust cumulus (slow), crest plume 270°.
- **Subjects:** rider (CH-04 or CH-03-rider, G0 decision) + horse, rear-hold.
- **Wardrobe/props:** cape from shoulders (length to horse's withers), silhouette-readable tack.
- **Beats:** rise to rear (2-beat) → hold 1.5 s micro-adjust → cape full extension → hold.
- **Physics:** hind hooves planted; CoM over hocks; cape never merges with horse; cloud boil ≤2% frame/s; 4 legs visible & correct.
- **VFX:** none required; cloud sim continuity if extended duration.
- **Audio:** wind roar, horse breath, hoof scrape, cape snap, sub swell.
- **Links:** palette family 4; wind vector; silhouette doctrine `03` §3.4.
- **AI notes:** motion amplitude MED-LOW; locked: silhouette outline class, horizon line, glow zone; risk refs R-10…R-13.

---

## Cross-shot DNA invariants

1. 24 fps / 180° shutter feel in all four (motion blur amount consistent with 1/48 s).
2. Grain + halation recipe identical (`03` §3.1).
3. Wind 270° in all four.
4. Value escalation ladder respected in edit order.
5. No shot introduces a hue family outside `03` §3.2.
