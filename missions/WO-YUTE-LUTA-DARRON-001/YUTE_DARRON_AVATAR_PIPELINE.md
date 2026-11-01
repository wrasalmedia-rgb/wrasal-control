# YUTE™ Digital Human Preservation Engine — Conditional Avatar Development Pipeline

- **Document ID:** `YUTE_DARRON_AVATAR_PIPELINE`
- **Phase 05 Deliverable Alias:** `YUTE_DARRON_DIGITAL_HUMAN_PIPELINE.md`
- **Version:** `v001`
- **Creation Date:** `2026-11-01`
- **Work Order:** `WO-YUTE-LUTA-DARRON-001`
- **Protocol:** `YUTE-DHPE-001`
- **Pilot Subject:** Darron-Ray Donaldson (`SUBJ-DARRON-RAY-DONALDSON`)
- **Execution Gate:** **CONDITIONAL — BLOCKED ON `HOLD-RIGHTS-001` CLEARANCE**
- **Lifecycle Status:** `DISCOVERY COMPLETE / PRODUCTION AUTHORIZATION PENDING`

---

## 1. Pipeline Design Philosophy: Smallest Verifiable Proof First

In alignment with `YUTE-PILOT-001`, this pipeline **rejects** premature construction of a full real-time rigged 3D digital double before foundational governance, consent enforcement, and still-frame identity consistency are proven.

### Phased Capability Ladder
1. **Stage Gate 0 (Current — `WO-YUTE-LUTA-DARRON-001`):** Read-only discovery, provenance manifest, rights matrix, and Ruby/PostgreSQL control specification. *(Zero likeness synthesis.)*
2. **Pilot Milestone M1 (Post-Authorization Still-Frame Consistency Proof):** Ingest cleared `MCPRS-v001` studio stills (plus any dual-licensed archival headshots such as `SRC-018`) into the encrypted **YUTE Source Asset Vault** and validate a **6-to-12 frame high-resolution still-image consistency proof** across LUTA States A, B, and C under strict Performer sign-off.
3. **Production Milestone M2 (Future Optional 3D / Sequence Asset Pipeline):** Only if Milestone M1 is approved by Darron-Ray Donaldson and required by *THE UNDERTAKERS* shot list, advance to calibrated 3D head/body asset generation (`OpenUSD` / `GLB` / `FBX`).

---

## 2. Seven-Stage Controlled Production Pipeline

```text
[Cleared Sources]
       │
       ▼
(01) REFERENCE INGESTION ──► [YUTE Source Asset Vault: SHA-256 + AES-256-GCM + License Check]
       │
       ▼
(02) IDENTITY EXTRACTION ──► [YUTE Likeness Specification: Immutable Anchors vs. Editable State]
       │
       ▼
(03) REFERENCE NORMALIZATION ► [Linear ACEScg Color + Masking of Makeup/Tattoos/Background]
       │
       ▼
(04) CONTROLLED RECONSTRUCTION ► [Isolated Adapter: M1 Still Proof → M2 Optional 3D Mesh/Rig]
       │
       ▼
(05) CONSISTENCY VALIDATION ─► [Multi-Angle / Skin / Costume Checks — Technical Gate Only]
       │
       ▼
(06) HUMAN REVIEW ───────────► [Darron-Ray Donaldson + Creative Director Sign-Off Gate]
       │
       ▼
(07) VERSIONED PRESERVATION ─► [YUTE Legacy Engine: Signed Manifests + Revocation Hook]
```

### Stage 01 — `REFERENCE INGESTION`
- **Entry Precondition:** `Yute::ConsentAuthority.active_passport?(subject_id)` **AND** `Yute::SourceAssetVault.copyright_cleared?(asset_id)` both evaluate to `true`. Any asset lacking dual clearance (Performer + Photographer/Creator) is hard-rejected at ingestion.
- **Contamination Quarantine Rules (Derived from Phase 01–02 Findings):**
  - Reject multi-subject frames (`SRC-002`, `SRC-016`) and watermarked frames (`SRC-002`).
  - Reject altered/retouched web exports (`SRC-004`) from anatomical calibration.
  - Flag transient makeup (`SRC-009`–`SRC-011` white forehead/beard stripe) as `ARCHIVE_CONTEXT_ONLY — EXCLUDE_FROM_SKIN_EXTRACTION`.
  - Reject all third-party YouTube music videos and showreel compilations (`SRC-020`–`SRC-025`).
- **Vault Operations:** Compute SHA-256 digest on raw bytes, extract camera EXIF/ICC color profile, encrypt binary payload with AES-256-GCM per-subject key, and write immutable provenance row to PostgreSQL.

### Stage 02 — `IDENTITY EXTRACTION`
- Compiles authorized `MCPRS-v001` references into a structured `YUTE LIKENESS SPECIFICATION` (`YUTE-IDLOCK-DARRON-v001`).
- Separates craniofacial landmarks, hairline/beard boundaries, natural dermal reflectance swatches, and verified anthropometric measurements (`BODY_LOCK`) from scene lighting and wardrobe.
- **Isolation Guarantee:** Extraction runs strictly inside an isolated, tenant-scoped environment with **zero telemetry or training write-back** to external commercial foundation models.

### Stage 03 — `REFERENCE NORMALIZATION`
- **Colorimetric Alignment:** Uses Slate Frame `#001` (`ColorChecker Passport Photo 2`) to transform RAW captures into scene-referred linear `ACEScg` (`AP1`), neutralizing mixed ambient color casts (`3200K` tungsten vs. `5600K` tropical daylight) without altering melanin luminance or undertone ratios.
- **Camera & Perspective Tagging:** Annotates lens focal length, sensor size, and subject distance so focal-perspective differences are compensated mathematically rather than misread as facial-shape changes.
- **Non-Destructive Segmentation:** Generates alpha mattes isolating studio backgrounds, wardrobe edges, and—where character state requires—personal body markings (`SRC-016`), while strictly forbidding dermal smoothing, pore erasure, or craniofacial warping.

### Stage 04 — `CONTROLLED DIGITAL RECONSTRUCTION`
Evaluates two candidate technical tracks, prioritizing Track A for `YUTE-PILOT-001`:

| Track | Scope | Technical Method | Pros / Cons for Pilot |
|---|---|---|---|
| **Track A (Recommended Pilot M1): Reference-Conditioned 2D Still Reconstruction** | High-resolution key-art & golden-shot stills for LUTA States A, B, C | Isolated, non-retaining reference-conditioned diffusion / multi-view portrait conditioning locked to `MCPRS-v001` + `COSTUME-LUTA-CANON-v001` control maps | Lowest cost, fastest verification of governance & identity consistency, zero premature 3D rigging overhead. |
| **Track B (Deferred Milestone M2): Calibrated Photogrammetric / Neutral-Mesh 3D Digital Human** | Turntable & animated shot production | Multi-view photogrammetry / cross-polarized scan → neutral topology head mesh + 4K/8K albedo/roughness/normal/displacement maps + FACS blendshape rig + groomed curve hair/beard | Highest physical continuity across motion/camera moves; requires dedicated scan rig and higher budget post-M1 validation. |

### Stage 05 — `CONSISTENCY VALIDATION`
Executes `Yute::ValidationService` automated and specialist technical checks against `YUTE_DARRON_IDENTITY_LOCK_SPEC.md`:
1. **Multi-View Craniofacial Consistency:** Verifies consistent facial proportions, hairline geometry, nasal profile, and full beard silhouette across `0°`, `30°`, `45°`, and `90°` renders.
2. **Melanin & Material Fidelity Check:** Confirms natural warm medium-deep brown skin response, preserved pore texture, absence of plastic gloss, and absence of transient portfolio artifacts (zero white forehead/beard paint leakage).
3. **LUTA Costume Compliance Check:** Confirms strict adherence to `COSTUME-LUTA-CANON-v001` (birdlike mask in State B; unmasked human face + preserved botanical leaf-feather mantle, charcoal scarf, bronze/silver beadwork, black underlayers, cascading cloak in State C; zero crowns, armor, or weapons).
4. **Governance Rule:** Passing Stage 05 sets `technical_validation_status = VALIDATED`, while `authorization_release_status` remains `BLOCKED_PENDING_PERFORMER_APPROVAL`.

### Stage 06 — `HUMAN REVIEW`
- **Dual Mandatory Sign-Off:**
  1. **Performer Approval (`Darron-Ray Donaldson`):** Reviews normalized reference sheet, technical validation side-by-sides, and candidate LUTA State A/B/C stills via authenticated review package; grants, requests revisions to, or withholds approval per asset.
  2. **Creative & Continuity Approval (`WRASAL Creative Director`):** Confirms dramatic and costume fidelity to *THE UNDERTAKERS*.
- Every approval decision is recorded in `Yute::ApprovalLedger` with approver identity, UTC timestamp, asset SHA-256 hash, and scope boundaries.

### Stage 07 — `VERSIONED PRESERVATION`
- Packages approved specifications, outputs, C2PA/YUTE synthetic-media provenance manifests, license terms, and approval signatures into the **YUTE Legacy Engine**.
- **Supported Interchange & Preservation Formats:**
  - **Pilot M1 (Required Initial Support):**
    - `16-bit Uncompressed TIFF / PNG` (master still references and approved renders in `ACEScg` / `Display P3` / `sRGB`).
    - `JSON` & `YAML` versioned asset, identity-lock, consent, and provenance manifests (`SHA-256` content-addressed).
  - **Future M2+ (Forward-Compatible Schema Support — Not Required for Initial Pilot):**
    - `OpenUSD (.usd / .usda / .usdc / .usdz)` for persistent cinematic world assembly in WRASAL / WRAYVE.
    - `GLB / glTF 2.0` for lightweight web/Passport inspection previews.
    - `FBX` for legacy DCC animation/rigging interoperability.
