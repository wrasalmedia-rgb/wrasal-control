# WRASAL Image-Prompt Audit 001 — Positive-Only Lock, Corrected

Registry ID: WRASAL-IMAGE-PROMPT-AUDIT-001
Version: 1.1.0
Lifecycle status: PROPOSED / PENDING REVIEW
Date: 2026-10-26

## Purpose

Audit a pasted prompt-critique draft against the image actually supplied with it
(`IMG_6329.webp`, 1536 × 1536, inspected directly), separate intended
specification from observed fact, and replace both the draft's diagnosis and its
"fixed" prompt where the image contradicts them — following the governing rule
in `WRASAL-CAMPAIGN-EXEC-METHOD-001.md`: *no evidence → no authority*, and
observed facts, source claims, and assumptions must never be silently merged.

This document is a documentation/provenance artifact. It does not validate,
approve, or canonically accept any image or prompt.

## 1. What the supplied image actually shows (observed)

- Close-up, chest-up portrait; direct eye contact, one eye lit, one in shadow.
- **Black ribbed beanie** covering the hair; dark curls escaping at the sides.
- **Bare shoulders and bare upper chest**; a **thin fine chain** on the collarbone
  (its metal colour is not reliably readable — red-lit on one side, dark on the other).
- Strong **red/orange firelight** from the subject's left; warm lens flares;
  cyan appears only as faint flare fringing, not as a designed gel.
- **Burning volcanic landscape** behind him: lava flows, smoke, haze, embers.
- Hands: none visible. Text/watermark/logo: none visible anywhere in the frame.
- Ethnicity/identity: **not determinable from pixels** and therefore not asserted here.

## 2. Claim-by-claim verdict on the pasted draft

| # | Draft claim ("asked → got") | Verdict against the actual file |
|---|---|---|
| 1 | Eyes down → direct eye contact | **Supported.** Gaze is into the lens. |
| 2 | 85% red / 15% cyan → warm golden halo | **Partly supported.** Red-orange firelight dominates, cyan gel is absent; "golden backlight halo outlining head and ears" is not what is shown — the glow is an environmental fire scene plus lens flare. |
| 3 | Shirtless + gold chain → black crewneck sweater + silver watch, no chain | **Fabricated.** He is shirtless; a thin chain is present; no sweater and no watch exist in the frame. |
| 4 | No hand → prominent hand at chin | **Fabricated.** No hand is visible. |
| 5 | Pure black void → smoke/haze | **Supported, and understated.** The background is a full burning volcanic landscape, not mere haze. |
| 6 | No watermark → `CapCut AI` burned in top-left | **Fabricated for this file.** No text of any kind is visible. (A watermark added at *export* would be a post-generation step no prompt can affect — that narrower point is valid in principle, unproven here.) |
| 7 | Headline says "ignored it in 7 different ways"; only 6 are listed | **The missing 7th is real and the draft missed it: headwear/hair.** The intended short curly afro is entirely replaced by a black beanie — arguably the largest single deviation in the frame. |

**Consequence:** the draft's "recreate the uploaded image" reverse prompt is a
description of an image that was never supplied (fade haircut, hand at chin,
black crewneck sweater, silver watch, halo backlight). Do not use it.

### Accurate reverse prompt for the supplied image

```text
intense close-up chest-up portrait of a shirtless man wearing a black ribbed
beanie with dark curls escaping at the sides, light stubble, thin fine chain on
his collarbone, direct eye contact with one eye in deep shadow, dramatic red
and orange firelight raking across one side of his face neck and bare chest,
burning volcanic landscape with lava flows smoke and embers behind him, warm
lens flares, ultra-detailed skin with visible pores, cinematic high contrast,
photorealistic, square format
```

(Identity/ethnicity deliberately unspecified: it cannot be read off the image.)

## 3. Where the draft's theory overreached

1. **"Generators don't understand negatives" is too broad.** In a single-string
   text encoder (CapCut, DALL·E-style), `no hand` does raise the salience of
   "hand". But platforms with a *separate* negative channel — SDXL's negative
   prompt field, Midjourney's `--no`, Flux guidance variants — do apply
   suppression; there the correct move is positive phrasing in the main prompt
   **plus** exclusions in the dedicated channel, not deleting exclusions everywhere.
2. **The draft's own "fixed" prompt repeats the fault it diagnoses:** it contains
   `no smoke no haze` and `clean image with empty background` inside a prompt it
   labels "Positive-Only". A lock that smuggles its negative block back in is
   not a lock.
3. **Numbers are not locks.** `85% red`, `RGB 0,0,0`, `15 degrees`, `85mm f2.8`
   are read as vibes, not measured parameters. Ratios are better carried by
   dominance language ("overwhelming", "hairline trace") and verified by eye
   per generation — see §5, where exactly this failure occurred and was fixed.
4. **Watermark claims need the export file, not the preview.** Absence/presence
   must be checked on the final exported pixels; see verdict 6.

## 4. Corrected prompts

### 4a. Positive-only lock (CapCut / DALL·E / Flux — single-string models)

Every exclusion is achieved by describing the thing that *is* there and by the
crop. The words for hands, clothing, smoke, and text never appear.

```text
premium studio portrait, chest-up framing ending at mid-chest, of a solitary
adult Black Caribbean man with a short tight curly afro, head tilted downward,
gaze directed downward, moody introspective expression, closed lips, bare
shoulders and bare upper chest, a thin delicate gold chain resting on his
collarbone, deep crimson-red gel light rising from front and below and wrapping
his face neck shoulders and chest as the overwhelming illumination, electric
cyan-teal light tracing a hairline edge along one side of his jaw neck and
shoulder, solid matte black studio backdrop filling the entire background,
ultra-detailed skin with visible pores and natural grain, soft highlight
rolloff, 85mm lens, shallow depth of field, cinematic high contrast, pristine
commercial retouch, photorealistic
```

(The subject description above is carried over from the user's *intended*
specification. It is a brief to generate from, not a claim about the supplied
photograph.)

### 4b. Midjourney / SDXL (dedicated negative channel)

Use 4a as the main prompt, then — Midjourney:

```text
--ar 4:5 --style raw --v 6.1 --no hands, phone, watch, clothing, shirt, sweater, beanie, hat, smoke, haze, landscape, text, logo, watermark, glasses, blur, cartoon, illustration
```

— or place the same exclusion list in SDXL's **negative prompt field**. Never
paste that list into the main prompt of a single-string model: there it is a
menu, not a ban. Note `beanie, hat` were added: per §2 verdict 7, headwear was
the largest observed deviation and the draft's `--no` list omitted it.

## 5. Verification generations (this session, evidence — not approval)

Two generations were run from prompt 4a in this sandbox:

- `images/wrasal-positive-lock-test-001.jpg` — gaze, afro, bare chest, gold
  chain, black backdrop, and crop all landed; **the lighting ratio inverted**
  (cyan dominant, red absent). Positive-only phrasing constrains content
  reliably; it does not enforce a gel ratio in one pass.
- `images/wrasal-positive-lock-test-002.jpg` — a relight pass over test 001
  ("deep crimson-red … overwhelming illumination; cyan … hairline-thin edge")
  landed the intended dominant-red / trace-cyan balance, retaining gaze,
  chain, backdrop, and crop. Residual deviation: the cyan edge is broader than
  a hairline on the jaw.

Recorded honestly per the method: iteration was required, and test 002 remains
a **proposal artifact, PROPOSED / PENDING REVIEW** — not a validated result.

## 6. Operating rule (the actual takeaway)

1. Describe the frame that exists; let the crop do the excluding.
2. Exclusions belong only in a platform's dedicated negative channel.
3. Treat ratios/numbers as intent, verify per generation, relight by edit pass.
4. Diagnose from the exported pixels in front of you — never from the prompt's
   memory of what it asked for. Three of the draft's six "failures" were
   failures of the diagnosis, not of the generation.

## 7. Addendum (2026-10-26): two further user-supplied generations + two prompt blocks

Two more images were supplied with two unattributed prompt fragments. Archived
byte-identical in this repo (SHA-256 recorded at inspection):

- `images/user-supplied-865358043.webp` — 1600 × 1600, JPEG-encoded despite the
  `.webp` name; sha256 `dc9e279355b1464ee818555905cf15e2f390aa0d156ef905699b30aedc3dc920`.
  Three-quarter view, head bowed, gaze down-right.
- `images/user-supplied-IMG_6331.webp` — 1024 × 1024 WebP;
  sha256 `2c2a357560eaa846c886c1539fbc19478c14bffed9043c4767e3f18f34f314c7`.
  Frontal view, head bowed, gaze down.

**Provenance is unresolved:** no platform, job ID, seed, or file↔prompt mapping
was supplied, so it is *not* recorded as fact that either fragment produced
either image. The audit below is therefore fragment-vs-pixels, not a generation log.

### 7.1 Observed in both images

Athletic shirtless man, voluminous tight curly afro, thin gold chain, solid
black background, deep shadows, dominant red light with cyan edge light,
tactile skin texture. No hands, text, watermark, smoke, clothing, or props.

### 7.2 Fragment A (style string ending `--style raw`) vs pixels

- Palette `#0E0E10 #1C1C1E #8B1E1E #E6491D` is broadly honoured (blacks, deep
  and hot reds); **`#EAEAEA` (near-white) appears nowhere** — an unused token.
- `stone, fabric` name materials that appear nowhere; in a single-string model
  they are invitations, not decoration, and fight the shirtless/void spec.
- `no gloss, no retouching` repeats the negative-in-main-prompt fault from §3,
  and sits unresolved against the fairly polished skin actually delivered.
- It contains **no subject, pose, gaze, or lighting direction at all** — it is a
  suffix, not a prompt, and cannot by itself reproduce these images.

### 7.3 Fragment B (half-body, `--ar 4:5`) vs pixels

| Fragment B asks | Both images show | Verdict |
|---|---|---|
| Looking directly at camera, neutral intense expression | Head bowed, gaze down, introspective | **Contradicted** — and it also contradicts the locked gaze-down spec in §4a. One of the two specs is stale; they cannot be merged as written. |
| Dark blue and black background | Uniform black, no blue field | Contradicted (minor). |
| Warm orange fiery lens flares / prism refractions across chest | Red/cyan gel lighting; no flares, no prism streaks | Contradicted. Notably the *orange-flare* look belongs to the earlier volcanic image (IMG_6329), suggesting this fragment describes that generation, not these. |
| Centered half-body, shirtless, thin gold chain, deep shadows, raw skin texture | All present | Supported. |
| `--ar 4:5` | Both files are 1:1 (1600², 1024²) | Contradicted at export, or the parameter was never used. Parameter claims must be checked against file dimensions, as in §3.4. |

### 7.4 Cross-cutting findings

1. **The red/cyan gel scheme appears in neither fragment** (A lists reds only;
   B says orange), yet dominates both images. The images match the §4a locked
   prompt far better than either supplied fragment — another reason the
   file↔prompt mapping stays unresolved rather than assumed.
2. **Identity is not locked between the two frames:** hair volume and facial
   structure differ noticeably. Same archetype, not a demonstrably same person.
   A repeatable face needs a platform identity mechanism (e.g. Midjourney
   `--cref`, SDXL reference/IP-Adapter, or a fixed seed + reference image);
   adjectives alone will keep re-casting the role.
3. These two frames otherwise **confirm the §4 lock holds** when it is actually
   used: gaze down, afro (no beanie), chain, black void, crop-excluded hands.

### 7.5 Corrected fusion (subject first; style as servant, not substitute)

Gaze-down version (matches §4a and both new images):

```text
premium studio portrait, centered half-body of a solitary athletic adult Black
Caribbean man with a voluminous tight curly afro, head bowed, gaze directed
downward, introspective intense expression, closed lips, bare shoulders chest
and upper arms, thin delicate gold chain on his collarbone, deep crimson-red
gel light wrapping his face neck chest and arms as the overwhelming
illumination, electric cyan-teal light tracing the edges of his hair jaw
shoulders and arms, solid matte black studio backdrop filling the entire
background, powerful raw authentic presence, real tactile skin texture with
visible pores, deep shadows, high contrast, timeless cinematic still,
photorealistic --ar 4:5 --style raw --no hands, phone, watch, clothing, shirt,
beanie, hat, smoke, haze, landscape, stone, fabric, props, text, logo,
watermark, glasses, lens flare, prism, gloss, blur, cartoon, illustration
```

Rules applied: the mood adjectives from Fragment A are kept but demoted behind
an explicit subject/pose/lighting spec; `stone, fabric, #EAEAEA` are dropped
from the positive string (they describe things that should not be in frame);
every exclusion — including the style-level `gloss` — lives only in `--no`;
gaze direction is stated once and consistently. If direct eye contact is ever
the intent, change only `head bowed, gaze directed downward` →
`head level, eyes locked into the lens` and keep everything else; do not run
both sentences in one prompt.

## Publication and audit fields

- Repository: wrasalmedia-rgb/wrasal-control
- Branch (working): arena/9ac81b8d-wrasal-control
- File path: concepts/WRASAL-IMAGE-PROMPT-AUDIT-001.md
- Source artifact: user-supplied `IMG_6329.webp` (1536 × 1536), inspected 2026-10-26
- Evidence: `images/wrasal-positive-lock-test-001.jpg`,
  `images/wrasal-positive-lock-test-002.jpg` (this repository, same commit);
  addendum: `images/user-supplied-865358043.webp`,
  `images/user-supplied-IMG_6331.webp` (byte-identical archives of the
  user-supplied files, SHA-256 in §7)
- Review status: PROPOSED / PENDING REVIEW
