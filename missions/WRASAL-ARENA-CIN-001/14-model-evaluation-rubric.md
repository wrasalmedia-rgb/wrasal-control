# 14 — Video Model Evaluation Rubric

Machine-readable: `data/rubric.json`. Score sheet: `templates/evaluation_scoresheet.template.json`.
Purpose: comparable, auditable scoring of generative candidates against the shot DNA; feeds gate G2 (motion tests) and G3 (final shots).

---

## 14.1 Criteria & weights (Σ = 100)

| ID | Criterion | W | What it measures |
|---|---|---|---|
| C1 | Photoreal texture & grain | 15 | pore/fabric/sand detail; grain & halation per `03` §3.1; no smoothing (R-18) |
| C2 | Anatomy & performance truth | 20 | faces, hands, teeth, gaits, micro-beats per `09`; identity vs lock still |
| C3 | Physical plausibility | 15 | gravity, contact, archery/equine/fire/smoke physics per `08` §8.4–8.5, `13` |
| C4 | Lens & camera grammar | 10 | focal/stop feel, DoF, flare character, move per `08` |
| C5 | Light & color continuity | 15 | palette family, ratios, kelvin story, value escalation per `03` |
| C6 | Temporal stability | 10 | no flicker/boil/warp across duration; HOLD elements hold |
| C7 | Motion quality & cadence | 10 | 1/48 s blur feel, 24 fps cadence, amplitude per shot DNA |
| C8 | Prompt / plate adherence | 5 | beats present in order; framing vs plate overlay |

## 14.2 Scale anchors (1–5 per criterion)

- **5 — Theatrical:** indistinguishable from photographed live-action at 100% inspection; zero noted defects.
- **4 — Acceptable:** defects only visible at freeze-frame/zoom, not in real-time viewing; no DNA violation.
- **3 — Remediable:** visible defect in real-time but fixable in post (paint, stabilize, flicker-remove) at bounded cost.
- **2 — Reject-soft:** defect violates a shot-DNA lock or needs unbounded post; candidate rejected.
- **1 — Reject-hard:** hard-stop risk instance (R-01, R-08, R-14, R-15, R-18) or anatomy/physics break.

## 14.3 Scoring math

`weighted = Σ (W_i × score_i) / 5` → 0–100.
**Acceptance (G3):** weighted ≥ 80 **AND** C2 ≥ 4 **AND** C3 ≥ 4 **AND** no criterion ≤ 2 **AND** zero hard-stop risk instances.
**Motion-test acceptance (G2):** weighted ≥ 70 **AND** C6 ≥ 3 **AND** C7 ≥ 3 (physics/texture may still be in remediation at test stage).

## 14.4 Panel & procedure

1. Panel: director, DP, VFX supervisor (3 scorers minimum); scores blind to model/seed where feasible.
2. Viewing: real-time pass → 50% pass → 100% freeze audit at 12-frame intervals → zoom audit on faces/hands/props.
3. Disagreement > 1 point on any criterion ⇒ discussion re-score; persistent split ⇒ director's score governs (human authority).
4. Every score sheet records: candidate id, model+version, seed, params, prompt hash, plate checksum, gate, scorers, date.
5. Score sheets are evidence: store under `evidence/` or mission `data/` per `17` manifest; they never self-promote acceptance (gate sign-off separate).

## 14.5 Model-comparison mode (selection at G2)

Run identical prompt/plate batches across candidate models; compare **mean weighted score per shot** and **hard-stop incidence**; select per-shot winners (models may differ per shot). Record selection rationale in mission changelog with human sign-off. Capability claims used during comparison must be logged to `data/capability_matrix.json` with doc evidence.
