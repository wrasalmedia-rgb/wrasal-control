# YUTE™ Digital Human Preservation Specification — Identity Lock (`v001`)

- **Document ID:** `YUTE_DARRON_IDENTITY_LOCK_SPEC`
- **Phase 04 Deliverable Alias:** `YUTE_DARRON_IDENTITY_LOCK_SPEC_v001.md`
- **Version:** `v001`
- **Creation Date:** `2026-11-01`
- **Work Order:** `WO-YUTE-LUTA-DARRON-001`
- **Protocol:** `YUTE-DHPE-001`
- **System:** YUTE Identity Engine (`YUTE LIKENESS SPECIFICATION`)
- **Subject (Human Person):** Darron-Ray Donaldson (`SUBJ-DARRON-RAY-DONALDSON`)
- **Lifecycle Status:** `PROPOSED SPECIFICATION — CONTINGENT ON PERFORMER AUTHORIZATION`

---

## 1. Architectural Principle: Immutable Identity vs. Editable Presentation

To prevent generative drift, beauty-bias homogenization, or conflation of the actor with the role, YUTE partitions all digital-human attributes into **two strictly segregated layers**:

| Layer | Mutability Rule | Governing Authority | Contained Attributes |
|---|---|---|---|
| **Layer 1: `IDENTITY_LOCK` (Endogenous Human Anchors)** | **IMMUTABLE** within a signed specification version (`v001`); changes require new calibrated reference + Performer re-approval. | Darron-Ray Donaldson (`HUMAN_APPROVER`) | Craniofacial skeletal proportions, nasal/orbital/malar contours, natural bilateral asymmetry, baseline melanin spectral reflectance, dermal pore/micro-relief topology, follicular curl geometry, verified anthropometrics, personal tattoo map (stored for human accuracy; masked per character policy). |
| **Layer 2: `PRESENTATION_AND_PERFORMANCE` (Exogenous / Controllable State)** | **EDITABLE** per scene/shot within authorized `CONSENT_SCOPE` without mutating Layer 1. | Creative Director × YUTE Character Engine (bounded by Passport terms) | FACS facial expression weights (`EXPRESSION_MAP`), approved haircut/beard length state (`GROOMING_STATE`), character wardrobe/mask (`COSTUME_IDENTITY`), editorial/ceremonial makeup (`MAKEUP_OVERLAY`), virtual camera focal length & exposure (`LENS_BEHAVIOR`), environmental lighting. |

---

## 2. Core Preservation Domains

### 2.1 `IDENTITY LOCK` (Facial & Anatomical Invariants)
Once authorized and populated from calibrated studio references, `IDENTITY_LOCK` enforces preservation of:
- **Craniofacial Proportions:** True orthographic ratios across trichion–glabella, glabella–subnasale, and subnasale–menton, plus bizygomatic-to-bigonial width ratio (captured without wide-angle lens distortion).
- **Recognizable Facial Contours:** Supraorbital brow ridge fullness, straight nasal dorsum and medium-broad alar geometry, prominent zygomatic highlight planes, full vermilion lip architecture and Cupid's bow, and oval pinna helix/antihelix/lobule morphology.
- **Natural Bilateral Asymmetry:** Explicit preservation of subtle left/right human differences (e.g., resting periocular and brow tension variance observed in `SRC-010`). **Prohibition:** Automated symmetry-mirroring or "beautification" filters are strictly banned.
- **Endogenous Complexion vs. Transient Makeup:** Locks natural warm medium-deep brown melanin reflectance and undertones while explicitly stripping transient artifacts (such as the white midline forehead/beard editorial paint documented in `SRC-009`–`SRC-011`).
- **Hair & Facial-Hair Characteristics:** Preserves Type-4 tight coil geometry, high crown density, crisp fronto-temporal line-up geometry, and full terminal cheek/jaw/chin beard growth pattern while allowing selection between authorized grooming presets (`Style A: Short Buzzed Crop` vs. `Style B: Tapered Textured Coil Top`).
- **Personal Body Markings Registry:** Records presence of personal body markings (`SRC-016`, granular motif/location withheld in public repo) as protected `HUMAN_IDENTITY` attributes, accompanied by a mandatory **Character Occlusion/Clean-Skin Toggle** (`mask_personal_tattoos: true` for LUTA).

### 2.2 `EXPRESSION MAP` (Identity-Invariant Performance Control)
- Parameterizes facial motion using **FACS (Facial Action Coding System) Action Units (`AU1`–`AU28`, `AU43`, `AU45`)** orthogonal to resting craniofacial identity.
- **Zero-Drift Constraint:** Activating brow lowerer (`AU4`), cheek raiser (`AU6`), lip corner puller (`AU12`), or jaw drop (`AU26`) may deform soft tissue and dynamic skin creases (forehead, glabella, nasolabial folds as observed in `SRC-016`), but **must not** alter interpupillary distance, nasal bridge bony profile, cranial vault shape, or baseline skin pigmentation.
- **Required Expression Calibration States:**
  1. `EXP-00`: Calibrated anatomical neutral (closed relaxed lips, horizon gaze).
  2. `EXP-01`: Regal composed authority (micro-engaged lower lid, grounded gaze — LUTA State A/C anchor).
  3. `EXP-02`–`EXP-12`: Core FACS basis (natural closed-lip smile, Duchenne smile `AU6+AU12`, brow furrow `AU4`, brow raise `AU1+AU2`, eyes closed `AU43`, contemplative downward gaze, jaw drop `AU26`, lip funnel `AU22`, lip pressor `AU24`, sneer/nasolabial lift `AU9`/`AU10`, high-exertion shout).

### 2.3 `BODY LOCK` (Verified Anthropometrics Only)
- **Hard Epistemic Rule:** `BODY_LOCK` fields remain `NULL / UNVERIFIED` until supplied directly by Darron-Ray Donaldson or captured via physical tape/caliper/photogrammetric studio session with a calibrated scale bar.
- **Prohibited Practice:** Estimating exact height (`cm`), weight (`kg`), or garment sizing from perspective portfolio photographs (`SRC-009`–`SRC-011`) is forbidden.
- **Required Measurements at Authorized Onboarding:** Standing height, sitting height, biacromial shoulder breadth, chest circumference, natural waist circumference, hip circumference, neck circumference, head circumference, interpupillary distance (`mm`), arm span/sleeve length, and hand length/breadth (for ceremonial mask and mantle fit).

### 2.4 `PHYSICAL TRUTH`
- Enforces anatomical conservation of mass and volume: sternocleidomastoid engagement during head rotation (`SRC-011`), clavicular and deltoid skin sliding, realistic subcutaneous tissue softness over zygomatic and submental zones, gravitational hang of heavy multi-layered garments, and physically grounded foot/seated contact (`SRC-009`–`SRC-011`).

### 2.5 `LENS BEHAVIOR` (Calibrated Reference Capture Standard)
- **Mandatory Focal-Length Window for Portrait Calibration:** `85mm` to `105mm` full-frame equivalent prime lenses at `2.5m–3.0m` subject-to-sensor distance (eliminating `<50mm` perspective nasal enlargement and ear recession).
- **Full-Body Reference Window:** `50mm` to `70mm` full-frame equivalent at `4.5m–6.0m`, sensor leveled at mid-sternum height (`0°` pitch).
- **Geometric & Color Targets in Every Setup:** X-Rite / Calibrite ColorChecker Passport Photo 2, 18% neutral grey sphere, chrome specular probe sphere, and metric scale ruler captured on Slate Frame `#001` of each lighting setup.

### 2.6 `EXPOSURE AND FILM RESPONSE`
- **Melanin-Accurate Exposure Discipline:** Expose to preserve complete shadow separation in deep espresso beard/hair volumes (`IRE 10–18` toe protection) **and** smooth specular highlight roll-off across forehead, nasal bridge, and malar prominences without clipping (`< IRE 90` in linear-to-log ACEScct / ARRI LogC4 working space).
- **Prohibited Grading Artifacts:** No ashy/cyan shadow lift, no orange/magenta clipping on warm brown skin, no frequency-blurring "plastic skin" beauty retouching, and no synthetic HDR haloing.

### 2.7 `MATERIAL RESPONSE`
- **Dermal BRDF / Subsurface Scattering:** Dual-lobe specular micro-roughness capturing natural satin skin sheen (`SRC-010`, `SRC-011`) paired with warm red-amber deep dermis scattering; zero waxy or metallic sheen.
- **Hair & Beard Fiber Scattering:** High-absorption anisotropic fiber model for tight Type-4 coils and coarse terminal beard hair so directional backlight/firelight produces authentic micro-rim scattering rather than solid black helmet geometry.
- **Costume Interaction:** Physically plausible contact shadowing, ambient occlusion, and cloth friction where LUTA's charcoal woven neck scarf, heavy black underlayers, botanical leaf-feather mantle, and weathered bird mask meet human skin and beard volume.

### 2.8 `SEQUENCE CONTINUITY`
- Identity invariants must hold across:
  - Camera azimuth `0°` (frontal), `±30°`, `±45°` (three-quarter), `±90°` (profile), and pitch `±25°`.
  - Lighting shifts from neutral `5600K` studio key to dark dream-realm chiaroscuro, warm firelight, or cold overcast moonlight.
  - Transition shots between **LUTA State B (Masked)** and **LUTA State C (Unmasked Revealed King)** with zero craniofacial scale pop or skin-tone jump across cuts.

---

## 3. Minimum Photographic Reference Set (`MCPRS-v001`)

To distinguish **Source-Media Archiving** (preserving licensed artistic photographs in the Vault as cultural/provenance records) from **Synthetic Identity Specification** (constructing a geometrically and colorimetrically reliable digital likeness), YUTE defines `MCPRS-v001` (**32 calibrated first-party RAW frames**):

| Capture Block | Frame Count | Specification | Purpose |
|---|---|---|---|
| **Block A — Slate & Colorimetric Calibration** | 2 frames | ColorChecker Passport + 18% grey + chrome ball (cross-polarized + unpolarized) | Linear ACEScg color matrix & specular separation |
| **Block B — Eye-Level Neutral Turntable** | 8 frames | `0°`, `±22.5°`, `±45°`, `±67.5°`, `±90°` (plus `180°` occipital/nape hairline), `85mm`, neutral `EXP-00` | Craniofacial contour, nose/brow/jaw/beard & hairline geometry |
| **Block C — Pitch & Close-Up Anatomical Anchors** | 6 frames | `+25°` high-angle, `-25°` low-angle, macro left/right ear, macro eyes/irides, dorsal/palmar hands | Eliminates occluded under-chin, ear-helix, iris, and hand guesswork |
| **Block D — Core FACS Expression Basis** | 12 frames | `EXP-01` through `EXP-12` at `85mm` frontal/three-quarter | Orthogonal expression mapping without identity drift |
| **Block E — Full-Body Orthographic & Lighting Check** | 4 frames | Standing A-pose/relaxed neutral (`0°`, `90°`, `180°`) + directional key-light skin-response check | Verified body/wardrobe proportions & melanin specular validation |

---

## 4. Version-Controlled Identity Manifest & Cryptographic Integrity Schema

Every authorized reference file and compiled identity specification is bound into an immutable, cryptographically verifiable manifest (`yute_identity_manifest.json`):

```json
{
  "manifest_id": "YUTE-IDLOCK-DARRON-v001",
  "schema_version": "1.0.0",
  "created_date": "2026-11-01",
  "work_order_id": "WO-YUTE-LUTA-DARRON-001",
  "subject_id": "SUBJ-DARRON-RAY-DONALDSON",
  "passport_consent_ref": "YUTE-PASSPORT-SPEC-v001-DRAFT",
  "lifecycle_state": "PROPOSED_UNPOPULATED_HOLD",
  "separation_assertions": {
    "human_identity_owner": "SUBJ-DARRON-RAY-DONALDSON",
    "archival_media_separated_from_training_set": true,
    "perspective_biometric_fabrication_prohibited": true
  },
  "source_asset_digests": [],
  "hash_algorithm": "SHA-256",
  "manifest_merkle_root": null,
  "human_signatures": {
    "performer_ed25519_signature": null,
    "wrasal_custodian_ed25519_signature": null,
    "signed_at_utc": null
  }
}
```
