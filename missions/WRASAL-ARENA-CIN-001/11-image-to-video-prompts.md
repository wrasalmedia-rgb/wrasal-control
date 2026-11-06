# 11 — Image-to-Video Prompts

Machine-readable: `data/prompts.json` → `i2v[]`. Blank: `templates/prompt.i2v.template.json`.
**Preferred mode for this package:** I2V conditioning on approved plates locks composition, palette and identity far better than T2V; T2V (`10`) remains the fallback and the stress-test arm.

**Plate prep is mandatory before conditioning:**
- `plates/shot-C.png` **must** be inpainted to remove the burned-in Korean subtitle `가자!` (source localization placeholder) → `plates/prep/shot-C-clean.png` (QC-002, R-14).
- All plates: upscale to working res with supervised upscaler (verify CAP-02); do not alter values/palette.
- Plate checksums recorded in `data/manifest.json` before and after prep.

**Motion-spec grammar:** `MOVE:` what animates · `HOLD:` what must stay frozen · `CAM:` camera move · `AMP:` amplitude · `PHYS:` physics locks.

---

## I2V-A — plate `plates/shot-A.png`

> Animate this exact frame as photorealistic live-action cinema, 24 fps, 1/48 s motion blur, 2.39:1 preserved. MOVE: the child archer's draw-arm micro-tremor (1–2 mm), a single suppressed breath in the chest, hood edge flutter, dust motes in the key light; blink suppression (eyes stay as framed). HOLD: bow geometry and string path beside the nose, arrow nock, hood fold pattern, mentor torso position and defocus, background bokeh field, framing. CAM: locked with organic micro-breath ≤0.3°, no pan. AMP: LOW. PHYS: string never intersects face; no arrow drift; no head turn. Texture: preserve pore-level skin and linen weave; add fine 35 mm grain; no smoothing, no warping of the face.

*Params:* dur 4 s · first-frame = plate · motion strength LOW (verify CAP-03).

## I2V-B — plate `plates/shot-B.png`

> Animate this exact frame as photorealistic live-action cinema, 24 fps, 1/48 s motion blur, 2.39:1 preserved. MOVE: crawling figure's contralateral crawl toward screen-left with a hand-slip stumble and recovery at mid-duration, then an upward glance; fire flicker natural 6–9 Hz non-periodic in both pools; cart-wheel flames licking rim-inward; smoke and embers drifting screen-left; tripod anomaly sway ≤0.5°/s with slit steady. HOLD: adobe architecture layout, cart and wheel position, fire pool positions, sky value, slit color and shape, horizon angle. CAM: handheld reactive pan-left 8° over 2 s then settle; horizon roll ≤1°. AMP: HIGH subject / LOW camera after settle. PHYS: limbs never tangle; robe hem drags; dust kicks at knees; no flames appear on roofs. Texture: keep soot and sand detail; fine 35 mm grain.

*Params:* dur 6 s · first-frame = plate · motion strength MED-HIGH.

## I2V-C — plate `plates/prep/shot-C-clean.png` (subtitle removed)

> Animate this exact frame as photorealistic live-action cinema, 24 fps, 1/48 s motion blur, 2.39:1 preserved. MOVE: scream performance — jaw opens wider on onset with correct teeth and tongue, eyes stay open and fixed off-frame right, neck cords engage, sustain, then mouth closes into a glare; hair streams screen-left in gusts with three hero strands leading; cloak shoulder flutter. HOLD: sun disc position and soft edge, haze density and pink field value, profile near-black frontal plane, warm rim on hair and jaw, pauldron shape, framing. CAM: handheld breathe + 2% push-in. AMP: MED. PHYS: hair never crosses the face; jaw hinge natural; no head rotation out of profile. ABSOLUTE: no text, caption, glyph or watermark may appear at any frame (the source plate's burned-in subtitle was removed in prep; its reappearance is an automatic fail). Texture: preserve backlit skin translucency; fine 35 mm grain; gentle halation only.

*Params:* dur 3.5 s · first-frame = clean plate · motion strength MED.

## I2V-D — plate `plates/shot-D.png`

> Animate this exact frame as photorealistic live-action cinema, 24 fps, 1/48 s motion blur, 2.39:1 preserved. MOVE: horse completes its rise into the rear and holds it — hind hooves planted, two small hip pulses, tail sweep, forelegs tuck asymmetric; cape extends fully screen-left and ripples; crest dust plume bleeds screen-left; storm clouds boil slowly (≤2% frame/s). HOLD: silhouette value (no readable detail on rider or horse), silhouette outline class, crest line, luminance ramp (glow lower-left → deep red upper-right), framing. CAM: locked-off; optional 1.5% push. AMP: MED-LOW. PHYS: center of mass over hindquarters at all times; four correct legs; cape pivot at shoulders only, never merging with horse; no hoof slide on crest. Texture: crisp silhouette edges, no glow fringe; fine 35 mm grain.

*Params:* dur 5 s · first-frame = plate · motion strength LOW-MED.

---

## 11.5 Start/end-frame variant (optional, verify CAP-06)

If the chosen model supports first+last frame conditioning: use `plates/shot-D.png` as first frame and a G1-approved "rear-held" key pose still (look-dev render with cape at full extension) as last frame to guarantee the punctuation pose. Record support status in `data/capability_matrix.json` CAP-06 before use.

## 11.6 Identity-lock rule

Named characters (CH-01, CH-03) may only be animated from their locked plate or G1 look-dev still — never from a generated still that has not passed QC-015 drift test against the lock.
