# Internal Creative Review — Six Golden Shots

**Phase:** 02 — Engineer Six Golden Shots → Internal Review before Propagation  
**Date:** 2026-10-23  
**Participants:** Cinematic Director (Builder) + Systems Architect (Builder) + Continuity Intelligence (Witness) + Independent Examiner (Witness)  
**Status:** RECONCILED — Established visual grammar propagated to remaining 28 shots

---

## Method

Six shots are the trailer's primary narrative control points (mission §7). Each delivered with 17 specification categories. Builder authored specs; Witness independently examined each for:

- Physical comprehensibility (can audience understand image?)
- Duration permitting noticing (hold long enough?)
- Material continuity correctness (thread state legal?)
- Whether effect reveals more than story intends (does shot explain vs question?)

Where Witness found defect, Builder repaired spec; Witness re-examined revision. Human receives result + evidence, not unfiltered argument.

---

## Review Outcomes

### SH001 — Invocation (Black Screen + Line)
- **Builder:** Black screen, Matthew delivers verbatim line with affection.
- **Witness Challenge:** Delivery could read as crude; black screen perceived as error.
- **Resolution:** Direction note "affection not crudeness" added; festival exhibitor note to tag SH001 as intentional black; actor casting conversation about line's history required.
- **Propagated Grammar:** Cold open on black + sound-first invocation established — reused for SH034 stinger.

### SH007 — Fourth Laugh Concealed
- **Builder:** Mid-wide congregation, fourth voice -18 LUFS masked, off-axis, no visible performer.
- **Witness Challenge:** Too subtle → no one notices; too obvious → dismissed as error.
- **Resolution:** Separate stem, just-below-threshold level; blind A/B test gate; same file hash ensures SH031 can isolate without suspicion of new recording.
- **Propagated Grammar:** Sound-design clue that acquires new meaning later — editorial thesis "genre changes when understanding changes" proven at edit level.

### SH014 — White Over Blue Discovery
- **Builder:** Macro ECU hem, focus rack blue→white, same geography as SH013.
- **Witness Challenge:** Blue/white legibility on phone at 2.39 crop? Hem location continuity?
- **Resolution:** 60mm macro 1:1 at T5.6 + raking accent; prop test on 5-in phone required; match camera angle/hem fold line overlay between SH013→SH014.
- **Propagated Grammar:** Forensic ECU as evidence imaging — camera as microscope, not dramatist.

### SH020 — Red Thread Retracts (First Supernatural Visual)
- **Builder:** Absolutely locked overhead ECU, red tail retracts 1.5cm in 1.2s, hands OFF thread >2cm.
- **Witness Challenge:** Movement reads as hand-pull? Camera micro-jitter invalidates witness? Not memorable?
- **Resolution:** Hands gap visible + overhead proves not pulling; camera locked (vector check); shadow proves practical; blind viewer must answer "did hand cause this? No"; hold 0.2s before + 0.8s after ensures comprehension.
- **Propagated Grammar:** Absolutely locked witness camera for impossibility — all later supernatural events measured against this visual credibility bar.

### SH030 — Reader Questions Attribution
- **Builder:** Reader Man medium two-shot, questions "You think a Desmond do this? It don't have to be him."
- **Witness Challenge:** Reader perceived as knowing authority → audience assigns him supernatural power; costuming as mystic caricature.
- **Resolution:** Performance restrained, no ritual gesture, dialogue negation; wardrobe everyday elder (no added beads); cultural advisor review; non-Jamaican audience test for exotic projection.
- **Propagated Grammar:** Epistemological restraint as authority — investigator's ignorance is structural.

### SH031 — Fourth Laugh Isolated (Recontextualization)
- **Builder:** Return to church, thinned laughter, same file isolated +6dB lifted.
- **Witness Challenge:** Audience doesn't connect SH007→SH031 as same file.
- **Resolution:** Same timbre/same file mandatory (hash), A/B with 5 naïve listeners (≥3/5 recognition), isolation hold 1.5s minimum, score mute to force re-listen.
- **Propagated Grammar:** Editorial recontextualization without inventing new evidence — same material, new understanding.

---

## Cross-Cutting Validations

| Interaction | Check | Verdict |
|-------------|-------|---------|
| SH001 → SH007 → SH031 (auditory arc) | SH007 concealed vs SH031 isolated — same file, same IR, same position, different level | PASS — validator T08 |
| SH013 → SH014 → SH018 → SH019 → SH020 (material arc) | Blue → white over blue → aged → red → retract — no stage skipped, no stage invented | PASS — validator T06 |
| SH020 → SH030 (supernatural → attribution) | SH020 first visual precedes any character's theory | PASS — validator T09 (idx 19 < idx 29) |
| Six shots vs remaining 28 — visual grammar consistent? | Witness checked that no subsequent shot contradicts golden shots' lens/lighting/blocking families | PASS — coverage spec enforces same families |

**Decision:** Grammar established in golden six propagated to all 34 ShotSpecs in `03-full-shotlist/master-shot-list.yaml` without human feedback — builder corrected defects autonomously, witness re-approved, ready for Phase 03 full shot-list completion.

---

*Chief of Staff — Golden Shots Internal Review v1.0*
