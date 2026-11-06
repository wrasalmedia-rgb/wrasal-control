# 12 — Negative Constraints

Machine-readable: `data/negative_constraints.json`. Blank: `templates/negative_constraints.template.json`.
**Enforcement doctrine:** negative prompts are model-support-dependent (CAP-04, UNVERIFIED). Therefore every constraint below is ALSO a **rejection criterion** in QC (`16`) and in rubric scoring (`14`) — enforcement never relies on prompt support alone.

---

## N-GLOBAL (attach to every generation)

**Anatomy & humans:** extra limbs; extra or missing fingers; fused or melted hands; doubled faces; asymmetric eyes; wrong tooth count or dental arch; neck twist beyond natural range; sexualized or aged-inconsistent minor depiction; corpse-like or waxy skin; artificial skin smoothing, airbrushing, plastic sheen, beauty-filter look.

**Physics & motion:** floating objects without support; contact-shadow missing; gravity reversals; object teleport between frames; limb tangling; gait asymmetry (non-contralateral crawl); hooves sliding without dust; cloth ignoring wind vector; smoke drifting against the 270° wind vector; fire without heat shimmer or smoke source; periodic/looping flicker; time-lapse cloud motion in real-time shots; motion blur inconsistent with 1/48 s; soap-opera cadence (interpolated >24 fps feel); temporal flicker or boiling texture.

**Look & grade:** oversaturated fantasy grading; neon or magic glows; aura effects; anamorphic streak flares (not in look); cold digital blacks (neutral crushed); clean noise-free digital texture; HDR-soap look; vignetting not in look; lens dirt not in look.

**Content & rights:** burned-in subtitles, captions, glyphs, watermarks, logos (reference `가자!` is a source localization placeholder — excluded); modern artifacts (power lines, glass, plastics, zippers, synthetic sheen, signage, vehicles); real-person likeness of any identifiable individual; trademarked franchise designs (the tripod anomaly must remain an original matte three-legged design, not a copyrighted war-machine copy).

**Frame:** aspect drift from 2.39:1; reframing/cropping by model; added letterbox bars inside frame; resolution upsampling artifacts (ringing, shimmer).

## N-A (SHOT-A specific)

bowstring passing through face, neck, or bow arm; arrow floating off the riser; mirrored nock side (arrow right of riser); draw elbow dropped below arrow line; hood slipping or fold pattern morphing; mentor torso entering focus or moving; background structures or vegetation appearing; blink at aim peak; facial expression shifting to anger or fear (register = concentration).

## N-B (SHOT-B specific)

figure standing upright; crawl with homolateral gait; limbs through ground or walls; fire appearing on roof lines; blue moonlight key; tripod slit glowing colored or casting spill on street; tripod walking or changing leg count; cart wheel intact while burning rim; smoke drifting screen-right; embers rising against draft; horizon roll >1°; face of survivor becoming legible/heroic.

## N-C (SHOT-C specific)

any text or glyph anywhere (especially reappearance of removed subtitle); hair strands crossing the face; eyes closed during scream; jaw unhinged or cartoonish mouth; frontal face plane lifting out of near-black (exposure "fix"); sun disc gaining hard edge or streak flare; haze field banding; profile rotating toward camera; pauldron switching shoulders.

## N-D (SHOT-D specific)

readable detail on rider or horse (silhouette breach); glow fringe around silhouette; fifth leg or merged legs; cape merging with horse body or growing from saddle; horse rearing on forelegs; hooves sliding on crest; cloud boil exceeding 2% frame/s; sun disc appearing; horizon tilt; crest line warping; plume drifting screen-right.

---

## 12.5 Prompt-injection format per model class (fill after CAP-04 verification)

| Model class | Negative delivery | Fallback if unsupported |
|---|---|---|
| native negative-prompt field | paste shot list verbatim | n/a |
| no negative support | — | rejection sampling (n≥ batch size in `10` §10.5) + QC-1xx/2xx gates + prompt hardening (move critical locks into positive text) |
| mask/region control | apply N-C text rule as region mask on subtitle zone | inpaint-clean plate (already mandatory) |
