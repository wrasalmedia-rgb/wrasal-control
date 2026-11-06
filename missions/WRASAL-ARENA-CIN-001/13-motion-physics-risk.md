# 13 — Motion & Physics Risk Assessment

Machine-readable: `data/risk_register.json`. Scoring: likelihood × impact (1–5 each); ≥15 = red (blocking at G2), 8–14 = amber (QC-monitored), ≤7 = green.

| ID | Risk | Shots | L | I | Score | Mitigation | QC gate |
|---|---|---|---|---|---|---|---|
| R-01 | Bowstring intersects face/neck/arm during draw | A | 4 | 4 | 16 | geometry lock `08` §8.4 in prompt + N-A; frame-by-frame string-path check | QC-101 |
| R-02 | Arrow nock side flips or arrow floats off riser | A | 3 | 4 | 12 | N-A; prop lock diagram; still-frame audit at 12 fr intervals | QC-102 |
| R-03 | Draw-hand anchor drifts (string creeps off cheek) | A | 3 | 3 | 9 | HOLD list in I2V-A; tremor amplitude capped | QC-103 |
| R-04 | Fire flicker aliases at 24 fps (strobe/periodicity) | B | 3 | 4 | 12 | natural non-periodic flicker spec; temporal flicker QC on 144 fr | QC-204 |
| R-05 | Smoke/ember wind vector contradicts 270° rule | B,C,D | 3 | 3 | 9 | vector rule in prompt + N lists; vector audit per 24 fr | QC-203 |
| R-06 | Tripod gait/leg-count errors or slit color drift | B | 3 | 4 | 12 | ANOM-01 static-sway lock; VFX fallback pass (CG replacement) | QC-104 |
| R-07 | Crawling figure limb tangle / ground penetration | B | 4 | 3 | 12 | contralateral gait spec; N-B; stumble beat bounded | QC-105 |
| R-08 | Scream face collapse (teeth, tongue, jaw) | C | 4 | 4 | 16 | anatomy verbs `09` §9.4; N-C; close-up audit at 84 fr | QC-106 |
| R-09 | Hair wind loop / strands crossing face | C | 3 | 3 | 9 | 3 hero strands continuity; gust variance spec | QC-107 |
| R-10 | Horse rear imbalance (CoM off hocks, hoof slide) | D | 3 | 5 | 15 | equine lock `08` §8.5; N-D; frame audit at rear-hold | QC-108a |
| R-11 | Cape merges with horse body or wrong pivot | D | 3 | 3 | 9 | pivot-at-shoulders lock; silhouette outline class check | QC-109 |
| R-12 | Cloud boil reads as time-lapse | D | 3 | 3 | 9 | ≤2% frame/s spec; cadence check vs 24 fps feel | QC-201 |
| R-13 | Silhouette edge melt / glow fringe / detail leak | D | 3 | 4 | 12 | expose-for-sky lock; edge crispness audit | QC-202 |
| R-14 | Subtitle `가자!` bleeds back from plate C | C | 4 | 4 | 16 | mandatory clean-plate prep; ABSOLUTE text ban in I2V-C; per-frame OCR-style visual scan | QC-002 |
| R-15 | Identity drift CH-01/CH-03 across candidates & shots | A,C,(D) | 4 | 4 | 16 | plate-locked I2V; drift stack test vs lock still; reference sets if CAP-05 verified | QC-015 |
| R-16 | Upscale shimmer / grain loss at 4K finish | all | 3 | 3 | 9 | supervised upscale (CAP-02); grain re-application post-upscale per `03` §3.1 | QC-301 |
| R-17 | Frame-rate conform judder (23.976/30 sources) | all | 3 | 3 | 9 | true-24 sourcing or documented conform; judder scan | QC-302 |
| R-18 | Uncanny skin smoothing from model prior | A,C | 4 | 4 | 16 | texture doctrine; N-GLOBAL; pore-level audit at 100% zoom | QC-110 |
| R-19 | Aspect/framing drift by model (crop, reframe) | all | 2 | 4 | 8 | 2.39:1 param + frame-edge audit vs plate overlay | QC-303 |
| R-20 | Rights/clearance: source-frame likeness or franchise design leakage | all | 2 | 5 | 10 | original-design rule for ANOM-01; synthetic identities only; legal review at G4 | QC-111 |

## 13.5 Assumptions embedded in this register

- AS-P1: generative candidates will exhibit the listed failure modes at non-trivial rates (observed industry-wide; not measured for the selected model until G2 batches exist).
- AS-P2: 24 fps 180° shutter feel is achievable either natively or via rejection (CAP-08 UNVERIFIED).
- AS-P3: silhouette shots (D) are lower identity-risk but higher physics-risk than face shots (A/C inverse).
- Measurement plan: at G2, record observed failure rates per risk from batch results; update L scores with evidence (register is living).

## 13.6 Blocking rules

- Any red risk (≥15) observed in a candidate ⇒ candidate rejected regardless of rubric score.
- R-01, R-08, R-14, R-15, R-18 are **hard-stop** risks: a single confirmed instance rejects the candidate and triggers prompt/plate remediation before the next batch.
