# 10 — Text-to-Video Prompts

Machine-readable: `data/prompts.json` → `t2v[]`. Blank: `templates/prompt.t2v.template.json`.
**Assembly order (template grammar):** `[STYLE] → [FRAME/LENS] → [SUBJECT+WARDROBE] → [BEAT VERBS] → [ENVIRONMENT] → [LIGHT] → [CAMERA MOVE] → [TEXTURE/GRAIN] → [PHYSICS LOCKS]`. Negatives attached from `12` per shot.
**Status:** templates + instantiated drafts. Model parameters (duration, fps, resolution, camera params) are **UNVERIFIED per model** — fill from `data/capability_matrix.json` before execution; where a model lacks a parameter, encode it in prompt text (`08` §8.6).

---

## T2V-A — The Young Archer's Oath

> Photorealistic live-action cinema, 2.39:1, 24 fps, 1/48 s motion blur. Medium close-up at eye level, 85 mm lens at T2.8, focus locked on the near eye of a child archer aged ten to twelve in a cream linen hooded robe, hood up. She holds a full recurve-bow draw: bow arm extended off-frame left, string anchored at the corner of her mouth passing beside her nose, one eye squinted in aim, breath held, a slight tremor in the drawing elbow, then resolve as her chin lifts one degree. Soft shadowless daylight at 5200 K from camera-left, gentle 2.5:1 fall-off, warm sand bounce from below. Background: wind-rippled dune sand twelve meters back, melted into creamy round bokeh, one stop under. Frame-right edge: out-of-focus charcoal-robed adult torso, completely still. Camera locked with organic micro-breath only. Natural pore-level skin with dust, no smoothing; fine 35 mm film grain; subtle warm halation. Physics: bowstring never intersects face or neck; arrow nocked left of riser; hood folds static.

*Params:* dur 4 s · fps 24 · aspect 2.39:1 · motion LOW · camera static-breathe. *Negatives:* N-GLOBAL + N-A.

## T2V-B — The Village Burns

> Photorealistic live-action cinema, 2.39:1, 24 fps, 1/48 s motion blur. Wide shot, low angle half a meter off the ground, 32 mm lens at T4, deep focus. A straight street of mud-brick adobe buildings at night, civil-dusk teal sky above. Two ground fires burn: a firewood pool foreground-left and a wooden cart with a spoked wheel mid-right, flames 1900–2200 K with natural non-periodic flicker, smoke layers backlit orange. A person in a soiled white wool robe crawls fast and low toward camera-left, hand slips on sand, hip drops, instant recovery without standing, then glances up in terror while moving. At the street end, sixty meters out, a tall matte-dark tripod machine straddles the wall line, ovoid head bearing a single vertical cool-white slit, swaying less than half a degree, no spill light on the street. Reactive handheld: eight-degree pan-left over two seconds then settle, horizon off-axis under one degree. Firelight ratio six-to-one in the pools; deep textured blacks; fine 35 mm grain; ember and smoke drift screen-left. Physics: contralateral crawl gait; wheel burns rim-inward; no flames on roofs.

*Params:* dur 6 s · fps 24 · aspect 2.39:1 · motion HIGH-subject/LOW-camera-settle. *Negatives:* N-GLOBAL + N-B.

## T2V-C — The Call

> Photorealistic live-action cinema, 2.39:1, 24 fps, 1/48 s motion blur. Medium close-up in hard profile at eye level, 85 mm lens at T4, sun disc in frame. A warrior woman of twenty-five to thirty-five, long black hair unbound, dark leather pauldron on her left shoulder, charcoal cloak, screams a command into the wind: inhale against the gust, then jaw drops wide with teeth and tongue anatomically correct, eyes open and fixed off-frame right, neck cords engaged, sustain, then mouth snaps shut into a locked glare. Hard backlight from a low soft-edged sun at eight degrees elevation through thick pink dust haze; sky-bounce fill only, five-to-one; warm rim on hair and jaw; her profile frontal plane stays near-black. Hair streams screen-left in a constant vector. Camera: handheld breathe with a two percent push-in over three and a half seconds. Gentle red-edge halation around the sun, no streak flares; haze field uniform; fine 35 mm grain. No text, no captions, no watermark anywhere in frame. Physics: hair never crosses the face; jaw hinge natural.

*Params:* dur 3.5 s · fps 24 · aspect 2.39:1 · motion MED. *Negatives:* N-GLOBAL + N-C.

## T2V-D — Rider on the Crimson Storm

> Photorealistic live-action cinema, 2.39:1, 24 fps, 1/48 s motion blur. Extreme wide tableau, low angle from the dune base, 90 mm lens at T8, locked-off camera. A knife-edge dune crest across the lower third; on it a rider on a rearing horse in pure silhouette, exposed six to eight stops under the sky: hind hooves planted, hocks flexed, forelegs tucked asymmetric, neck arched, rider's seat deep with level shoulders, cape from the shoulders fully extended screen-left. Behind: towering boiling crimson dust-storm cumulus filling the upper two thirds, slow cloud motion under two percent of frame per second, luminance ramp from a bright dust glow at lower-left horizon to deep red mass upper-right; sun hidden, no disc. Crest dust plume drifts screen-left. No detail readable on rider or horse — clean silhouette edges; no glow fringe. Fine 35 mm grain; warm-tinted blacks. Physics: center of mass over hindquarters; four correct legs; cape never merges with horse body.

*Params:* dur 5 s · fps 24 · aspect 2.39:1 · motion MED-LOW · camera locked. *Negatives:* N-GLOBAL + N-D.

---

## 10.5 Usage notes

1. Run each prompt as a **candidate batch** (n ≥ 6 per shot at G2; n ≥ 12 at G3) and score with `14`.
2. Keep a **package style prefix** identical across all four prompts (first sentence) to bind grain/cadence/photorealism.
3. If the model accepts negative prompts (verify CAP-04), attach `12` lists; if not, enforce via rejection sampling + QC.
4. Log every run: model, version, seed, params, prompt hash → `17` manifest (reproducibility).
