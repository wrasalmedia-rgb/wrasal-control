# 01 — Visual Reference Analysis

**Source:** `reference/source/image-1.png` — 1920×824 sRGB PNG, 2×2 grid of four cinematic frames (each quadrant 960×412 ≈ 2.33:1, i.e. widescreen crops near the 2.39:1 target).
**Method:** frame-by-frame read of composition, light, color, texture, motion cues; palette values **sampled from the file** with ImageMagick (coordinates in `data/scene_dna.json` → `palette[].sampled_at`).

---

## 1.1 Frame inventory (no continuity assumed)

| Plate | Quadrant | One-line read | Dominant light | Dominant scale |
|---|---|---|---|---|
| `SHOT-A` | top-left | Child archer at full draw, mentor's dark robe clipping frame right | Soft diffused daylight, warm sand bounce | intimate (MCU) |
| `SHOT-B` | top-right | Adobe village street burning at night; robed figure crawling; tall tripod anomaly with a single lit slit behind | Practical fire vs. cold dusk sky | epic (wide) |
| `SHOT-C` | bottom-left | Woman in profile screaming into wind, low sun disc in haze; burned-in Korean subtitle `가자!` | Hard low backlight through dust | intimate (MCU profile) |
| `SHOT-D` | bottom-right | Rider on rearing horse, crest of dune, pure silhouette against boiling crimson storm | Sun hidden behind dust wall; expose-for-sky | mythic (EW silhouette) |

**Continuity verdict:** the four plates share palette family, desert geography, costume language and wind motif, but differ in time-of-day, location and subject. Treated as **one candidate visual grammar across four independent tableaux**. Linkage hypotheses are logged in `05-character-continuity.md` as `ASSUMED`.

## 1.2 Sampled palette (evidence-based)

| ID | Name | sRGB | Hex | Role |
|---|---|---|---|---|
| P-01 | dune sand (soft day) | (180,141,102) | `#B48D66` | SHOT-A background field |
| P-02 | hood cream (shadow side) | (166,136,110) | `#A6886E` | CH-01 costume base |
| P-03 | skin, soft key | (157,120,93) | `#9D785D` | CH-01 face |
| P-04 | mentor charcoal | (10,10,10) | `#0A0A0A` | CH-02 robe, near-black neutral |
| P-05 | night sky (dusk blue-teal) | (15,32,39) | `#0F2027` | SHOT-B ambient top |
| P-06 | adobe in firelight | (133,61,15) | `#853D0F` | SHOT-B architecture key side |
| P-07 | fire core (white-hot) | (250,250,248) | `#FAFAF8` | practical source peak |
| P-08 | flame body | (171,102,47) | `#AB662F` | fire mid-tone |
| P-09 | anomaly slit (cool white) | (237,241,252) | `#EDF1FC` | ANOM-01 single light |
| P-10 | sunset haze pink | (249,204,185) | `#F9CCB9` | SHOT-C sky field |
| P-11 | sun disc (clipped) | (254,254,254) | `#FEFEFE` | SHOT-C backlight source |
| P-12 | hair rim (backlit brown) | (134,82,71) | `#865247` | CH-03 hair edge |
| P-13 | storm crimson mid | (190,44,39) | `#BE2C27` | SHOT-D cloud body |
| P-14 | storm deep red | (57,0,9) | `#390009` | SHOT-D cloud shadow mass |
| P-15 | horizon glow (dust-lit) | (229,185,160) | `#E5B9A0` | SHOT-D lower-left luminance anchor |
| P-16 | silhouette black-red | (27,11,12) | `#1B0B0C` | SHOT-D subject value |

## 1.3 Visual grammar extracted (the reusable part)

1. **Escalation ladder of scale:** intimate → chaotic-wide → intimate-emotional → mythic-silhouette. The sequence breathes by alternating face and landscape; never two intimate shots in a row.
2. **Motivated-source lighting only:** sun (soft or hard-low), fire, or sun-through-dust. No unmotivated fill; shadows carry the frame.
3. **Two-temperature contrast:** SHOT-B pairs ~1900–2200 K fire with ~9000 K dusk; the rest of the package stays in a warm monochrome family (sand → pink → crimson).
4. **Silhouette as punctuation:** fully exposed-for-sky subjects appear only at mythic beats (SHOT-D); partial silhouette (rim-lit profile) at emotional beats (SHOT-C).
5. **Wind is a character:** constant screen-left vector (hair in C, cape and crest dust in D, smoke drift in B). Wind speed escalates A→D.
6. **Long-lens intimacy / wide-lens chaos:** faces shot compressed (≈85 mm) with creamy bokeh; destruction shot wide (≈32 mm) with deep-ish focus and handheld reactivity.
7. **Texture doctrine:** visible skin pore/detail, fabric weave, dust in air, fine film grain, gentle halation around sun and fire; **no** beauty smoothing, **no** clean digital look.
8. **Restraint on the anomalous:** the tripod machine (SHOT-B) is matte, dark, single-light, background-scaled; it never glows colorfully or dominates composition. SF element as dread, not spectacle.
9. **Frame discipline:** subjects anchored to thirds; horizon low in D, high in B; negative space left in the direction of gaze/wind.
10. **Value control:** blacks are warm-tinted, never crushed to neutral; highlights roll (sun disc is the only legal clip).

## 1.4 Cues read from the frames (motion & optics inference)

- `SHOT-A`: motion blur absent on face, slight softness on bow tip → near-locked camera, subject micro-motion only. Bokeh circles round → spherical lens, uncoated-warm flare character.
- `SHOT-B`: directional blur on crawling figure and flame smear → 1/48 s shutter with fast subject motion; handheld micro-shake implied by off-axis horizon (~0.6°).
- `SHOT-C`: hair streaks show 1–2 frame motion smear at tips → gusting wind, handheld breathe; sun disc soft-edged → haze diffusion, no anamorphic streak.
- `SHOT-D`: zero camera-motion cues; cloud edges crisp → locked-off tripod, long lens compression of storm front.

## 1.5 What the reference does NOT prove

- No proof of shared story, cast identity across plates, or chronological order.
- No proof of capture format (film vs. digital), true focal lengths, or VFX methodology.
- The Korean burn-in proves only that *some* localized master of the source exists; it carries no authority over this recreation.
