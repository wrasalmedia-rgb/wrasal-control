# WRASAL Image-Prompt Audit 001 — Positive-Only Lock, Corrected

Registry ID: WRASAL-IMAGE-PROMPT-AUDIT-001
Version: 1.0.0
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

## Publication and audit fields

- Repository: wrasalmedia-rgb/wrasal-control
- Branch (working): arena/9ac81b8d-wrasal-control
- File path: concepts/WRASAL-IMAGE-PROMPT-AUDIT-001.md
- Source artifact: user-supplied `IMG_6329.webp` (1536 × 1536), inspected 2026-10-26
- Evidence: `images/wrasal-positive-lock-test-001.jpg`,
  `images/wrasal-positive-lock-test-002.jpg` (this repository, same commit)
- Review status: PROPOSED / PENDING REVIEW
