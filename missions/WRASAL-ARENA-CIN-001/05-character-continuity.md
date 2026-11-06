# 05 — Character Continuity Requirements

Identity strategy for AI-assisted production: **plate-locked identity**. Each character's face/costume is frozen from an approved still (the reference plate or a G1 look-dev still). Video generation conditions on that still (I2V) or on a reference set (if the chosen model supports references — **UNVERIFIED**, see `data/capability_matrix.json` CAP-05). No prompt-only faces for named characters.

---

## 5.1 Character records

### CH-01 — The Young Archer (SHOT-A)
- **Apparent age/sex:** child, 9–12 y, female-presenting, East Asian features.
- **Face lock:** `plates/shot-A.png` region (hood frames face; hood shadow pattern part of identity).
- **Wardrobe:** cream linen hooded robe (P-02), hood UP; coarse weave; dust at shoulders; no ornament, no jewelry.
- **Hair:** hidden under hood (continuity simplification — keep hidden in all A material).
- **Props:** wood recurve bow (unstrung-limb curve consistent), arrow nocked **left of riser**, fletching at draw hand.
- **State map:** clean-start; sweat sheen at brow by beat 4; dust on hood right side.
- **Performance range:** silent concentration only (no dialogue in A).
- **Compliance:** minor performer rules apply if a live actor is ever used; for synthetic generation keep apparent age consistent and non-sexualized, non-violent context only (archery sport/defense tableau).

### CH-02 — The Mentor (SHOT-A, frame-right torso)
- **Face:** never revealed in reference → **look-dev decision at G1** (human approves a face or keeps unrevealed).
- **Wardrobe:** charcoal wool robe (P-04), matte, heavy fold pattern; rope belt implied below frame.
- **Blocking lock:** torso-only, OOF, frame-right edge, 1.2 m; never enters focus in A.

### CH-03 — The Woman Warrior (SHOT-C; candidate rider in D)
- **Apparent age/sex:** 25–35 y, female, East Asian features.
- **Face lock:** `plates/shot-C.png` profile (frontal value near-black P-17 + rim P-12 is part of the look; do NOT "fix" exposure on her face).
- **Wardrobe:** dark leather pauldron **left** shoulder, charcoal cloak, matte; hair unbound, black-brown (P-12 rim), length to mid-back.
- **State map:** dust film on cheekbone; wind-torn hair strands (3 hero strands tracked for continuity).
- **Performance range:** command scream (C); if rider in D, physicality only.

### CH-04 — The Rider (SHOT-D) — identity pending G0
- **Silhouette-only record:** cape from shoulders to withers; seated seat; one-handed rein hold implied.
- **G0 decision options:** (a) CH-04 = CH-03 (same performer, mythic echo); (b) CH-04 = new character; (c) CH-04 = CH-01 grown (time-jump reading). All `ASSUMED` until ratified.

### CH-05 — Village Survivor (SHOT-B)
- **Extra-class:** face not legible in reference; keep illegible (motion + smoke) — no identity lock needed beyond robe.
- **Wardrobe:** white wool robe, soiled hem (P-08 tint in firelight), hood down.

### ANOM-01 — The Tripod Anomaly (SHOT-B, non-character)
- **Design language:** matte dark metal (P-09-adjacent body value #1A1F23), three slender legs, ovoid head, **single vertical cool-white slit** (P-09); height 8–10 m; no weapons, no glow bleed, no color lights.
- **Behavior lock:** slow sway (≤0.5°/s), legs static in B; never walks in B (gait = separate look-dev if ever needed).
- **Restraint rule:** background-scaled; value contrast vs sky ≤ 15%; dread by placement, not spectacle.

## 5.2 Continuity mechanics (production)

| Mechanism | Requirement | QC gate |
|---|---|---|
| Face lock still | approved still per character before any video gen | G1, QC-010 |
| Reference set | ≥3 angles per named character if model supports refs (verify CAP-05) | G1 |
| Wardrobe bible | this file §5.1 + look-dev photos at G1 | QC-011 |
| State map | dirt/sweat/wind state per beat; changes only via documented beats | QC-012 |
| Prop lock | bow/arrow config diagram in `08` §8.4; cart/wheel burn state in B | QC-013 |
| Hair strands | 3 hero strands on CH-03 tracked C→(D if same performer) | QC-014 |
| Identity drift test | side-by-side frame stack per shot vs lock still; drift score ≤ rubric C2 tolerance | QC-015, G3 |

## 5.3 Assumptions register (requires G0 ratification)

| ID | Assumption | Status |
|---|---|---|
| ASM-01 | Four plates share one story world | UNRATIFIED (G0-REC-001: inspect exact definitions before any ratification; working disposition: independent test cases) |
| ASM-02 | Rider (D) = CH-03 | UNRATIFIED — **not used as working assumption**; rider carried as CH-04 (distinct) until evidence identifies otherwise |
| ASM-03 | CH-02 is CH-01's guardian/mentor | UNRATIFIED (working disposition: relationship undefined; CH-02 = frame-right torso only) |
| ASM-04 | ANOM-01 is hostile force behind B's burning | UNRATIFIED (working disposition: threat reading optional per test) |
| ASM-05 | Chronology A→B→C→D | UNRATIFIED (working disposition: edit grammar option only, not story fact) |

## 5.4 G0-REC-001 working dispositions (conditional, not acceptance)

Recorded from the 2026-11-06 reviewer directive; formal G0 acceptance **PENDING** until exact assumption definitions and approval authority are reconciled.

1. **Four independent cinematic test cases**, one unified evaluation methodology; no presumed shared character identity or fictional universe.
2. **Shared visual language** (documented lighting, palette, camera, film-response specs) approved as a *proposed direction for creator consideration*.
3. **Character continuity applies only where a character is explicitly established as recurring.** As of this record: no character is established as recurring; CH-01…CH-05 and ANOM-01 are per-shot records.
4. **SHOT-D rider = CH-04** (distinct silhouette record) until evidence identifies otherwise.
5. Human performance truth and physical plausibility remain the governing standards for every test.
