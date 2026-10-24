# White-Shirt Material-State Graph — Brothers of the Blood Cloth: The Invocation

**Project:** BROTHERS OF THE BLOOD CLOTH  
**Object:** P_WHITE_SHIRT_HERO (Desmond's white dress shirt)  
**Hero Props:** P_WHITE_SHIRT_HERO_1980S (clean/new), P_WHITE_SHIRT_HERO_2026_AGED (aged 40y)  
**Mission:** WO-WRASAL-BOTBC-GM-001  
**Date:** 2026-10-23  
**Status:** COMPLETE — Physical Construction Specification  
**Governing Warning:** Red-thread mechanism is FICTIONAL storyworld invention — not historical Jamaican folklore.

---

## 1. Graph Overview (State Machine)

```
STATE 0 — ORIGINAL GARMENT (1980s, new)
  Desmond's white cotton poplin dress shirt
  ├─ Fabric: White cotton poplin, 120gsm, period-appropriate (no poly sheen)
  ├─ Fit: Regular, long-sleeve, point collar (1980s Jamaican menswear)
  ├─ Color: Optic white (new)
  └─ Condition: New, pressed, no repairs
         │
         │  Ione hand-repairs hem tear/damage (SH013)
         ▼
STATE 1 — BLUE REPAIR (Ione, 1980s, SH013)
  └─ Thread: P_BLUE_THREAD — dull cotton, slightly irregular hand stitch
     ├─ Geometry: 12cm straight hem, running stitch, 3mm spacing, uneven tension
     ├─ Color: Muted blue (Jamaican haberdashery stock, 1980s)
     ├─ Texture: Matte, slightly fuzzy (cotton)
     └─ Visibility: ECU macro — irregularity reads as handmade, caring
         │
         │  Another person repairs same hem over Ione's work (SH014)
         │  Time delta: weeks–months later (same shirt returned differently)
         ▼
STATE 2 — WHITE OVER BLUE (Unknown second hand, 1980s, SH014)
  └─ Thread: P_WHITE_THREAD — brighter polyester, tighter, straighter
     ├─ Geometry: Same 12cm hem, 2.5mm spacing, uniform tension, slightly overlapping blue out-of-alignment (+1mm offset)
     ├─ Color: Bright white (newer spool, distinct from fabric white)
     ├─ Texture: Smooth, slight sheen (polyester vs cotton)
     └─ Visibility: ECU macro — regularity reads as different hand (not Ione's)
     └─ Narrative: Evidence that arouses suspicion — not proof of infidelity
         │
         │  Decades of storage, wear, aging (1980s → 2026: 40 years)
         │  Shirt stored folded (family house)
         ▼
STATE 3 — AGED (2026, SH018)
  └─ Shirt: P_WHITE_SHIRT_HERO_2026_AGED (physically aged version)
     ├─ Fabric: Yellowed at collar/cuffs (sweat/oxidation), overall cream shift (Delta E ~8)
     ├─ Folds: Pressed fold lines (long storage), softened drape
     ├─ Threads: Blue dimmed and slightly frayed (cotton degraded); White still bright (polyester stable)
     └─ Visibility: Medium + macro — aging tells time without dialogue
         │
         │  Red revealed beneath older repairs (SH019)
         ▼
STATE 4 — RED REVEALED (2026, SH019 — visual anomaly, not yet movement)
  └─ Thread: P_RED_THREAD — waxed linen, blood-red, vivid
     ├─ Geometry: Underlying running stitch, 3mm spacing, emerging from beneath blue/white at hem edge
     ├─ Color: Fil au Chinois waxed linen #1143 or equivalent — blood/red ceremonial (not orange)
     ├─ Texture: Waxed, slight thickness (+0.3mm vs cotton), catches specular
     ├─ Visibility: ECU macro — wax specular proves physical presence (shadow on fabric)
     └─ Origin: Unverified — before 1980s? during? after? — NOT claimed as folklore; FICTIONAL invention
         │
         │  Red retracts impossibly (SH020 — first supernatural visual)
         ▼
STATE 5 — RED RETRACTED (2026, SH020, 3s)
  └─ Thread: Tail visible 2cm → retracts 1.5cm in 1.2s without visible pull
     ├─ Motion: Smooth, organic curve, slight hesitation 0.3s before move, fabric dimple after disappearance
     ├─ Hands: Yvonne holds hem taut, fingers >2cm OFF thread (prove not pulling)
     ├─ Shadow: Thread casts physically correct tiny shadow before move (proves practical)
     └─ After: Empty stitch hole 0.8s hold — blue/white inert, only red moved
         │
         │  Subsequent examination (SH021–030)
         ▼
STATE 6 — QUESTIONED (2026, SH021–030)
  └─ Shirt examined collectively (women) + by Reader Man — attribution questioned
     └─ No new material change; shirt's evidence is already complete
```

---

## 2. Stitch Geometry Specification (For Prop Master)

### 2.1 Measurement Reference

| Parameter | Blue (STATE 1) | White (STATE 2) | Red (STATE 4) |
|-----------|----------------|-----------------|---------------|
| **Hap** | Hem, 12cm straight section, 6cm from side seam | Same hem, overlapping blue | Same hem, underlying beneath both |
| **Stitch length** | 3.0mm ±0.5mm irregular | 2.5mm ±0.2mm regular | 3.0mm exact (uncanny precision) |
| **Thread** | Cotton, dull, fuzzy | Polyester, bright, smooth | Waxed linen, blood-red, thick |
| **Tension** | Moderate, slight pucker (hand variance) | High, flat (tighter) | Moderate, waxed friction |
| **Alignment** | Baseline hem | Over blue +1mm offset (proves over-sewing) | Under blue/white, emergin at edge |
| **Visible length** | 12cm | 12cm (covers blue) | 12cm + 2cm tail at reveal (pre-retraction) |
| **Color (LAB under D55)** | L90 a-5 b-10 (muted blue) | L96 a0 b2 (bright white) | L42 a48 b22 (blood red) |

### 2.2 Fabric Aging (STATE 3)

| Area | 1980s (new) | 2026 (aged 40y) | Treatment |
|------|-------------|-----------------|-----------|
| **Body fabric** | Optic white L96 | Cream L88 (yellowing) Delta E 8 | Tea bath + 40h UV exposure test — validate |
| **Collar/cuffs** | Optic white | Yellowed L84 + faint ring (sweat) | Localized tea + thin acrylic patina |
| **Blue thread** | Muted blue matte | Faded L92, slightly frayed tips | Light sandpaper + diluted bleach |
| **White thread** | Bright white shiny | Still bright white (polyester stable) | No aging — contrast tells material difference |
| **Red thread** | N/A (not yet revealed) | Vivid, waxed, unaffected by age | Wax protects — deliberately uncanny preservation |
| **Folds** | Pressed crisp | Softened, permanent crease lines | Store folded weighted 2 weeks before shoot |

---

## 3. Shot Visibility Matrix

| Shot | Period | State Visible | Threads Visible | Visibility Detail |
|------|--------|---------------|-----------------|-------------------|
| SH009 | 1980s | STATE 0 | None (new) | Shirt as garment, not evidence — wide |
| SH010 | 1980s | STATE 0 | None | Pockets examined, shirt in background |
| SH011–012 | 1980s | STATE 0/1 | Not yet | Photograph era — shirt worn naturally |
| **SH013** | 1980s | **STATE 1** | **Blue ECU** | **Macro — irregular blue stitching, care** |
| **SH014** | 1980s | **STATE 2** | **White over Blue ECU** | **Macro rack blue→white; white proves second hand** |
| SH015–017 | 1980s | STATE 2 | Blue/White (medium) | Medium shots — shirt held as evidence of suspicion |
| **SH018** | 2026 | **STATE 3** | **Blue/White aged** | **ECU — yellowed fabric, contrast blue faded/white bright** |
| **SH019** | 2026 | **STATE 4** | **Red revealed beneath** | **ECU — red emerges, wax specular, shadow** |
| **SH020** | 2026 | **STATE 5** | **Red retracts** | **ECU overhead locked — only red moves** |
| SH021 | 2026 | STATE 5 | Red gone (hole) | Reaction — empty stitch hole 0.8s |
| SH025–027, SH030 | 2026 | STATE 6 | Blue/White/Red (if still visible) | Collective examination — shirt as questioned object |
| SH034 | 2026 | STATE 6 | — | Black screen voice — shirt acoustic memory |

**Validation Rule:** No shot shows red before SH019. No shot shows white before SH014. No shot shows thread movement except SH020. Enforced by validator `T06`.

---

## 4. Physical Construction Method (Prop Master Instructions)

### 4.1 Hero Shirt Build

**Base:** Source 3x identical white cotton poplin dress shirts (1980s pattern — regular point collar, long sleeve, 15.5–16.5 neck to fit actors). Label:
- Hero A — SH013 (blue only)
- Hero B — SH014–017 (blue + white)
- Hero C — SH018–030 (aged + red) — with swappable hem pieces for SH019–020 retraction rig

**Aging:** Hero C undergoes aging treatment (see §2.2) — tea bath, UV, collar patina, fold set.

### 4.2 Thread Procurement

| Thread | Sourcing | Spec | Qty |
|--------|----------|------|-----|
| Blue cotton | Jamaican haberdashery vintage stock or Gutermann Cotton #1040 denim blue (dull) | 30wt cotton, matte | 1 spool (50m) |
| White polyester | Gutermann Sew-All #800 white | 28wt polyester, bright/smooth | 1 spool |
| Red waxed | Fil au Chinois waxed linen #1143 sanguine (blood-red) or Atelier Sajou waxed linen rouge | Waxed, thick | 2 spools (one for hero, one for tests) |

**Constraint:** Red thread must not be sourceable in 1980s Jamaican haberdashery — this is intentional uncanny detail (red's vividness/preservation argues it doesn't belong to period).

### 4.3 Stitching Execution

- **SH013 Hero A:** Hand-stitch blue 12cm hem by Ione actress (or hand double trained) with irregular spacing — preserve video of stitching as provenance that blue is Ione's hand.
- **SH014 Hero B:** Starting from completed Hero A stitch, a second sewer (different hand) stitches white over blue with tighter tension +1mm offset — document second hand difference on macro photo.
- **SH019–020 Hero C:** Build swappable hem cassette — 5 spare hem inserts with pre-stitched blue/white + red tail with monofilament pull-through (for SH020 practical retraction). Spare cassettes allow multiple takes.

### 4.4 Retraction Rig (SH020)

- Monofilament 0.1mm attached to red tail tip beneath fabric through stitch hole, routed under table to technician pull.
- Shirt held taut over false table edge (rigged surface) so no visible pull; monofil invisible at T5.6.
- Rehearsal: technician times 1.2s smooth pull; thread path curves slightly (organic).

---

## 5. QC & Verification

| Check | Method | Expected |
|-------|--------|----------|
| **Legibility at phone size** | Photograph hem macro, display on 5-inch phone at 2.39 crop, 1080p | Blue vs white distinct; red vivid; thread counts readable |
| **Same hem geography** | Overlay SH013 vs SH014 macro (same camera angle) — hem fold line aligns | Alignment within 2mm after perspective correction |
| **Blue/white hand difference** | Measure stitch spacing variance: blue σ≥0.4mm, white σ≤0.2mm | Confirms different hands |
| **Red not folklore** | All artifacts label red as FICTIONAL storyworld invention | Text search: no artifact claims folklore without fiction tag |
| **Only SH020 movement** | Review all shot specs — only SH020 lists movement | Validator T06 checks |

---

## 6. Unresolved / Provisional

| Item | Status | Next Step |
|------|--------|-----------|
| 1980s haberdashery thread stock verification | UNVERIFIED | Jamaican textile consultant confirm blue/white period stock |
| Red waxed thread sourcing (Fil au Chinois vs local) | PROPOSED | Prop test: source locally if available; otherwise import and note |
| Hem vs collar as repair site | PROPOSED hem (most plausible) | Director may elect collar — but hem preserves continuity with SH019–020 macro logic |
| Number of hero shirts needed | PROPOSED 3 heroes + 5 spare cassettes | Confirm with costumer budget |

---

*Continuity Intelligence — Material Graph v1.0*  
*Prop Master: Build per this spec; preserve macro provenance photos pre-shoot*
