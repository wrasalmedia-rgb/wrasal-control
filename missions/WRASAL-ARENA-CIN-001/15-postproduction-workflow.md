# 15 — Postproduction Workflow

Pipeline P0→P9 with gates. Tool names are **class-level** (e.g. "supervised AI upscaler"); specific products selected at G2/G4 after `data/capability_matrix.json` verification. No stage promotes acceptance; gates G1–G4 do.

---

## P0 — Plate prep & look-dev (pre-generation)

1. Ingest `reference/source/image-1.png`; verify sha256 vs `data/manifest.json`.
2. Crop plates (`reference/make-plates.sh`); verify plate checksums.
3. **Subtitle removal:** inpaint `가자!` region on `plates/shot-C.png` → `plates/prep/shot-C-clean.png`; QC-002 (visual scan + diff outside region = 0).
4. Look-dev stills per shot DNA (G1): framing, palette, texture targets; approve face/wardrobe locks and CH-02 face decision, CH-04 identity decision carried from G0.
5. Build show LUT: filmic tone map + warm black lift + palette family trims (`03` §3.2–3.3).

## P1 — Generation & selection

1. Batch per shot: I2V primary (`11`), T2V fallback/stress (`10`); negatives per `12`; log model/seed/params/prompt-hash/plate-checksum per candidate.
2. Auto-reject: hard-stop risks (`13` §13.6), aspect drift, text appearance.
3. Panel-score survivors (`14`); shortlist per gate threshold.
4. G2 sign-off on motion tests before any full-quality renders.

## P2 — Conform

1. Cut selected takes per `02` sequence grammar (18.5 s / 444 fr reference edit).
2. True 24 fps conform: reject 23.976/30-native takes unless documented conform plan (QC-302); **no blind frame interpolation** — optical-flow retiming only where a take is otherwise perfect and approved by VFX sup.
3. 2.39:1 extraction; edge audit vs plate overlay (QC-303).

## P3 — 4K finish

1. Supervised upscale to 3996×1668 (CAP-02 verify); per-shot upscale test at G3.
2. Detail recovery pass conservative: no invented texture on faces (R-18 adjacency).
3. Grain & halation application per `03` §3.1 **after** upscale (grain must sit on top of upscaled image).

## P4 — Cleanup & stabilization

1. Temporal flicker removal (fire shots first), texture boil suppression.
2. Warp/paint fixes bounded per rubric C3=3 remediable class; log every paint fix in shot's QC sheet.
3. Micro-stabilization only where handheld grammar exceeded DNA amplitudes (`08` §8.3).

## P5 — Color

1. Show LUT + per-shot trims to palette families; vectorscope targets: A warm-beige axis, B orange/teal split, C pink field + legal near-black profile, D red ramp.
2. Match passes: value escalation ladder check in sequence playback (QC-208).
3. Highlight policy audit per `03` §3.3 (only legal clips: C sun disc, B fire cores ≤0.5% px).

## P6 — VFX integration

1. ANOM-01: if generative tripod fails QC-104 in best take → CG replacement pass (matte dark metal, slit P-09, sway lock `05`).
2. Dust/plume continuity extensions if durations grow; cloud boil rate audit (QC-201).
3. Subtitle/localization pass: **clean by default**; target-language subtitles as separate deliverable layer, never burned into master.

## P7 — Audio

1. Beds & FX per shot DNA audio intent (`04`): wind ladder A→D, fire roar, crawl cloth, scream (performance-recorded or licensed library — no synthetic-voice likeness of real persons), equine breath, sub swell.
2. Mix: -24 LKFS dialogue-anchored reference; wind as continuous bridge element; dynamic escalation matching picture ladder.
3. M&E + stems for localization.

## P8 — Master & QC

1. Masters: 4K 3996×1668 24 fps Rec.709 video-only + joined audio; UHD-safe 3840×1608 alternate; ProRes-class mezzanine + H.264 review proxy.
2. Full QC run (`16`) on master; fix loop bounded to 2 iterations, then gate review.
3. G4 sign-off: director + producer; legal/clearance check (QC-111) included.

## P9 — Archive & evidence

1. Freeze package: prompts+params logs, score sheets, QC sheets, plate checksums, master checksums → `data/manifest.json`.
2. Record mission control update (`work_orders/WRASAL-0011.json` evidence append or successor WO) — execution results only; canonical acceptance stays human.

---

## 15.10 Gate placement map

| Gate | After stage | Blocking deliverables |
|---|---|---|
| G0 | P0.0 | `01`,`02`,`03`,`05` assumptions ratified |
| G1 | P0.5 | look-dev stills, locks, LUT |
| G2 | P1.4 | motion tests, model selection |
| G3 | P5.2 | final shots scored ≥ acceptance |
| G4 | P8.3 | master release |
