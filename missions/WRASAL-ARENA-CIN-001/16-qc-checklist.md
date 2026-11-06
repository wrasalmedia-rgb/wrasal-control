# 16 — Quality-Control Checklist

Machine template: `templates/qc_checklist.template.json`. Result vocabulary: `pass | fail | na`; every `fail` requires disposition (fix / reject / waive-with-human-signoff). Checks run per candidate (1xx/2xx) and per master (3xx/0xx).

---

## 0xx — Plate & prep (P0)

- [ ] QC-001 source plate sha256 matches manifest (`bea6ed1c…cc20`).
- [ ] QC-002 `plates/prep/shot-C-clean.png`: no glyph/subtitle anywhere; diff vs original confined to subtitle bbox.
- [ ] QC-003 plate crops geometrically exact (960×412 quadrants, no resample).
- [ ] QC-004 look-dev stills approved at G1 for all four shots.
- [ ] QC-005 face/wardrobe lock stills registered per named character.

## 1xx — Candidate anatomy/physics/per-shot locks

- [ ] QC-101 (A) string path beside nose at every frame; no intersection with face/neck/arm.
- [ ] QC-102 (A) arrow nock left of riser, shaft parallel to sight line, no float.
- [ ] QC-103 (A) draw-hand anchor static; tremor ≤2 mm; hood folds unchanged.
- [ ] QC-104 (B) ANOM-01: 3 legs, single cool slit, sway ≤0.5°/s, no spill, no walk.
- [ ] QC-105 (B) crawl contralateral; no limb tangle/ground penetration; stumble beat present.
- [ ] QC-106 (C) scream anatomy: teeth/tongue/jaw correct at 100% zoom across 84 fr.
- [ ] QC-107 (C) hair vector 270° constant; no strand crosses face; 3 hero strands continuous.
- [ ] QC-108 (all) skin pore-level texture present; no smoothing/plastic sheen (R-18).
- [ ] QC-108a (D) equine rear: CoM over hocks; hind hooves planted; no slide.
- [ ] QC-109 (D) cape pivot shoulders; no merge with horse; outline class constant.
- [ ] QC-110 (all) no modern artifacts; materials read linen/wool/leather/wood/mud.
- [ ] QC-111 (all) no identifiable real-person likeness; ANOM-01 original design (legal scan).

## 2xx — Light/color/motion grammar

- [ ] QC-201 palette family per shot (`03` §3.2); cloud boil ≤2% frame/s (D).
- [ ] QC-202 silhouette integrity (D): no readable detail, no glow fringe, crisp crest line.
- [ ] QC-203 wind vector 270° on all carriers (smoke, embers, hair, cape, plume).
- [ ] QC-204 fire flicker non-periodic; no strobe alias at 24 fps (B).
- [ ] QC-205 flare policy (C): halation only; no streaks/ghost rings.
- [ ] QC-206 no unauthorized fill on D subject; C frontal plane stays near-black.
- [ ] QC-207 practical interaction present: fire→smoke glow, sun→hair rim, glow→plume.
- [ ] QC-208 sequence playback: value escalation ladder reads A→B→C→D.

## 3xx — Conform/finish/master

- [ ] QC-301 upscale: no shimmer/ringing at 100%; grain sits post-upscale per recipe.
- [ ] QC-302 true 24 fps; no judder; no undocumented interpolation.
- [ ] QC-303 2.39:1 exact (3996×1668 / 3840×1608); edges match plate overlay intent.
- [ ] QC-304 audio loudness -24 LKFS anchor; wind bridge continuous; stems present.
- [ ] QC-305 master free of text/watermarks; subtitle layer separate (not burned).
- [ ] QC-306 checksums recorded for all masters; manifest updated.

## Governance checks (run at every gate)

- [ ] QC-900 every capability claim relied upon has doc evidence in `data/capability_matrix.json`.
- [ ] QC-901 score sheets complete (scorers, seeds, params, hashes) for the decision set.
- [ ] QC-902 gate sign-offs named and dated; no self-promotion of acceptance.
- [ ] QC-903 hard-stop risks (R-01, R-08, R-14, R-15, R-18) zero-instance attested.
- [ ] QC-904 assumptions register reviewed; new assumptions logged with status ASSUMED.
