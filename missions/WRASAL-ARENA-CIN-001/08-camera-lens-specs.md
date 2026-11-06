# 08 — Camera & Lens Specifications

## 8.1 Capture format doctrine (live-action equivalent)

| Item | Spec |
|---|---|
| Sensor class | Large-format digital (≥36 mm width) or 35 mm film emulation; full-frame equivalent field of view |
| Recording | 4K ≥ 24 fps true; 180° shutter (1/48 s); no speed ramps |
| Lens mount philosophy | Spherical primes only (round bokeh per `01` §1.4); no anamorphic streaks |
| Filtration | IRND as needed; SHOT-C: 1/4 black-diffusion class for halation control; others: none or 1/8 max |
| ISO / EI | 800 equivalent baseline; SHOT-D exposes for sky (subject −6…−8 stops) |
| Finish | 2.39:1 extract; 4K 3996×1668 primary, 3840×1608 alternate |

## 8.2 Lens set & per-shot assignment

| Shot | Focal | T-stop | Focus | DoF intent | Flare character |
|---|---|---|---|---|---|
| A | 85 mm | T2.8 | near eye (≈1.6 m) | bg ≥12 m → cream bokeh | warm uncoated-soft, no streak |
| B | 32 mm | T4 | 2.5 m → ∞ soft | deep-ish, chaos legible | fire halation small |
| C | 85 mm | T4 | cheek rim (≈1.8 m) | haze field melts | soft disc + red-edge halation |
| D | 75–100 mm | T5.6–T8 | ∞ | storm compression | none (no source in frame) |

Bokeh translation for generative prompts: A/C = "creamy round out-of-focus highlights, no onion rings"; B = "slightly soft deep focus"; D = "everything sharp, value-separated".

## 8.3 Camera movement grammar

| Shot | Move | Amplitude | Frequency/feel |
|---|---|---|---|
| A | locked + micro-breath | ≤0.3° | 0.15 Hz organic |
| B | handheld reactive pan-left | 8° over 2 s then settle | operator startled-then-steady |
| C | handheld breathe + push | 2% in over 3.5 s | slow assertive |
| D | locked-off (optional 1.5% push) | — | monumental stillness |

Rule: camera energy inverse to subject myth (intimate = breathe; mythic = locked). Horizon roll ≤1° only in B.

## 8.4 Prop geometry lock — archery (SHOT-A)

```
        bow hand extended @270 deg, grip at throat of riser
        arrow shaft parallel to sight line, nock LEFT of riser
        string: 3-point contact (index+middle below? -> MED 3-finger draw),
                path passes BESIDE nose (2-4 cm), never through face/neck
        draw hand anchor: corner of mouth; elbow in line with arrow axis
        fletching clears riser at full draw (no clipping)
```
Common AI failure modes this lock prevents: string-through-head, arrow floating, mirrored nock side, elbow drop. (See R-01…R-03.)

## 8.5 Equine geometry lock (SHOT-D)

Rear (levade-adjacent, natural 2-beat): hind hooves planted ≥ hip-width; hocks flexed; CoM over hindquarters; forelegs folded/tucked asymmetric (natural); neck arched, head ≥ 45° above horizontal; tail down-sweep counterbalance; rider seat deep, legs forward-guarded. Cape pivot at shoulders only. (R-10, R-11.)

## 8.6 Generative-translation table (cinema term → prompt language)

| Cinema term | Prompt phrasing |
|---|---|
| 85 mm T2.8 | "long lens compression, very shallow depth of field, creamy bokeh" |
| 32 mm T4 handheld | "wide lens, deep focus, reactive handheld micro-shake" |
| 180° shutter | "natural 1/48 s motion blur, filmic 24 fps cadence" |
| expose for sky | "subject in pure silhouette, sky correctly exposed" |
| 2.5:1 soft key | "soft directional daylight, gentle shadow fall-off" |
| halation | "subtle red-edge halation around bright practicals" |
| grain 2/5 | "fine 35 mm film grain, organic texture" |

## 8.7 Verification note

Focal-length/stop values are **creative specifications for the recreation**, not measurements of the source. Generative model support for explicit lens/camera parameters is model-specific — see `data/capability_matrix.json` CAP-07 (camera control) before relying on parameterized camera moves; otherwise encode camera grammar in prompt text (§8.6) and verify in motion tests (G2).
