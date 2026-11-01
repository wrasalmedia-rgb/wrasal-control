# WRASAL™ × YUTE™ — LUTA Digital Casting & Character Integration Specification

- **Document ID:** `LUTA_CHARACTER_INTEGRATION`
- **Phase 06 Deliverable Alias:** `LUTA_DIGITAL_CASTING_INTEGRATION_SPEC_v001.md`
- **Version:** `v001`
- **Creation Date:** `2026-11-01`
- **Work Order:** `WO-YUTE-LUTA-DARRON-001`
- **Protocol:** `YUTE-DHPE-001`
- **System:** YUTE Character Engine (`YUTE LICENSE MANAGER` × `YUTE LIKENESS SPECIFICATION`)
- **Creative Property:** *WRASAL | THE UNDERTAKERS*
- **Character Identity:** LUTA, King of the Dream Realm (`CHAR-UNDERTAKERS-LUTA`)
- **Proposed Human Performer:** Darron-Ray Donaldson (`SUBJ-DARRON-RAY-DONALDSON`)
- **Lifecycle Status:** `PROPOSED CASTING SPECIFICATION — PRODUCTION AUTHORIZATION PENDING`

---

## 1. Tripartite Ontological Separation (Non-Interchangeability Rule)

A core architectural invariant of YUTE and WRASAL is that **the human person, the digital representation, and the fictional character are three distinct legal and database entities**:

| Entity Class | Canonical Identifier | Sovereign Rights / IP Holder | Lifecycle Persistence |
|---|---|---|---|
| **1. Real Human Person (`HUMAN_IDENTITY`)** | `SUBJ-DARRON-RAY-DONALDSON` | **Darron-Ray Donaldson** | Permanent sovereign personhood; never owned by WRASAL or YUTE. |
| **2. Authorized Digital Likeness (`LIKENESS_REPRESENTATION`)** | `REP-YUTE-DARRON-v001` *(Proposed)* | Governed by **YUTE Identity Passport™** under Darron-Ray Donaldson's revocable consent | Exists only upon explicit performer authorization; revocable via `Yute::RevocationControl`. |
| **3. Fictional Character (`CHARACTER_IDENTITY`)** | `CHAR-UNDERTAKERS-LUTA` (*LUTA, King of the Dream Realm*) | **WRASAL Media** (*THE UNDERTAKERS*) | Persistent WRASAL narrative IP; exists independently of any single casting agreement. |

**Mandatory Anti-Conflation Rules:**
1. Authorization for `REP-YUTE-DARRON-v001` to portray `CHAR-UNDERTAKERS-LUTA` in *THE UNDERTAKERS* **must never** be interpreted as blanket permission for other WRASAL characters, unrelated commercial campaigns, interactive AI chatbots, or third-party productions.
2. Conversely, Darron-Ray Donaldson's personal biography, commercial endorsements, and real-world identity remain entirely separate from LUTA's fictional narrative actions.

---

## 2. Canonical Three-State Character Specification

LUTA requires seamless visual and narrative continuity across **three strictly defined character states**:

### `STATE A: LUTA / HUMAN`
- **Narrative / Visual Role:** LUTA in unmasked human form, grounding the sovereign ruler of the Dream Realm in authentic human presence.
- **Human Identity Visibility:** **100% Visible (Unmasked).** Full craniofacial architecture, warm medium-deep brown skin tone, natural dermal texture, Type-4 coil hair crop/taper, and full sculpted beard of `REP-YUTE-DARRON-v001` are clearly visible.
- **Normalization Constraints:**
  - Exclude all portfolio editorial artifacts (no white midline forehead/beard paint from `SRC-009`–`SRC-011`).
  - Mask personal personal upper-body tattoos (anatomical detail minimized in public repo) (`SRC-016`) whenever shoulders/back are exposed unless separately cleared and canonically approved.
- **Expression & Performance Envelope:** Grounded stillness, contemplative gravitas, controlled micro-expression authority (`EXP-00`, `EXP-01`, `EXP-08`).
- **Wardrobe Coupling:** Paired with authorized State A human-realm / Dream-Realm underlayer attire (heavy black woven underlayers and charcoal neck scarf where specified by scene continuity).

### `STATE B: LUTA / UNDERTAKER`
- **Narrative / Visual Role:** Ceremonial concealed Undertaker form in full Dream-Realm regalia.
- **Human Identity Visibility:** **0% Facial Visibility (Concealed).** The human face is completely concealed beneath LUTA's established **elongated, weathered birdlike ceremonial mask** with **deep recessed eye openings**.
- **Identity & Body Continuity Under Concealment:**
  - Head scale, neck column, biacromial shoulder breadth, and grounded posture remain driven by verified `BODY_LOCK` proportions so that cuts between State B and State C match anatomically to the millimeter.
  - Deep recessed eye openings remain shadowed per ceremonial mask design; any subtle eye/periocular glint visible inside recessed apertures must respect `YUTE Identity Passport™` tracking if derived from `REP-YUTE-DARRON-v001`.
- **Wardrobe Coupling:** Full canonical `COSTUME-LUTA-CANON-v001` ensemble (mask worn).

### `STATE C: LUTA / REVEALED KING`
- **Narrative / Visual Role:** The pivotal royal revelation—the ceremonial bird mask is removed, uniting the human face of Darron-Ray Donaldson (`REP-YUTE-DARRON-v001`) with the full Undertaker royal costume (`COSTUME-LUTA-CANON-v001`).
- **Human Identity Visibility:** **100% Facial Visibility + Full Royal Undertaker Regalia.**
- **Critical Transition & Contact Continuity:**
  - Cranial volume, beard projection under the jaw, and neck circumference must fit physically inside the interior volume of the removed elongated birdlike mask (proving physical plausibility of mask removal rather than impossible geometry).
  - Natural contact interaction between the lower beard/submental contour and the **charcoal woven neck scarf** and **dark botanical leaf-feather mantle** collar—preserving realistic ambient occlusion and fabric compression without clipping beard fibers.
  - Zero shift in skin tone, facial bone structure, or hairline geometry between State A and State C.

---

## 3. LUTA Costume Authority (`COSTUME-LUTA-CANON-v001`)

The established LUTA costume reference holds **absolute canonical priority** over generic fantasy, medieval, or sci-fi royal tropes.

### 3.1 Mandatory Preserved Elements (Positive Lock)
Every State B and State C visual specification, asset manifest, and validation check **must preserve**:
1. **Elongated, weathered birdlike mask** *(worn on face in State B; removed from face—either absent from frame or held off-face per shot blocking—in State C; absent in State A)*.
2. **Deep recessed eye openings** *(integral structural feature of the ceremonial birdlike mask)*.
3. **Dark botanical leaf-feather mantle** *(layered organic dark foliage-and-plumage texture across shoulders and upper chest)*.
4. **Expansive, grounded shoulder silhouette** *(broad, weighty horizontal-to-sloped architectural massing anchored to natural gravity—not floating or spiky)*.
5. **Charcoal woven neck scarf** *(coarse tactile weave wrapping neck/collar transition beneath chin/mask base)*.
6. **Antique bronze and oxidized silver beadwork** *(aged, matte-patinated metallic ceremonial accents—never mirror-polished chrome or bright yellow gold)*.
7. **Heavy black underlayers** *(dense, matte, multi-layered dark woven/draped textiles absorbing stray light)*.
8. **Full-length cascading cloak** *(heavy floor-draping dark cloak obeying realistic cloth mass and wind inertia)*.

### 3.2 Strictly Prohibited Costume Alterations (Hard Rejection Gate)
The YUTE Validation Service and human continuity reviewers **must automatically reject** any prompt, concept, 3D asset, or render that introduces:
- Crowns, tiaras, diadems, halos, or gilded royal circlets.
- Plate armor, chainmail, tactical pauldrons, or sci-fi exoskeletal plating.
- Swords, daggers, spears, firearms, staffs, scepters, or other weapons.
- Extraneous capes, bright saturation accents, gemstones, tribal face-paint stripes (including the portfolio's white stripe from `SRC-009`–`SRC-011`), or unauthorized decorative embellishments altering `COSTUME-LUTA-CANON-v001`.

---

## 4. Four Independent Semantic Version Histories

To ensure clean governance, recasting resilience, costume iteration, and shot-level performance approval without corrupting upstream records, YUTE maintains **four decoupled version graphs** linked only via an explicit, immutable `CastingBindingManifest`:

```yaml
casting_binding_manifest:
  binding_id: "CAST-BIND-UNDERTAKERS-LUTA-001"
  schema_version: "v001"
  created_date: "2026-11-01"
  status: "PROPOSED_PENDING_AUTHORIZATION"

  independent_version_axes:
    HUMAN_IDENTITY:
      id: "SUBJ-DARRON-RAY-DONALDSON"
      likeness_spec_version: "YUTE-IDLOCK-DARRON-v001"
      passport_consent_version: "YUTE-PASSPORT-SPEC-v001-DRAFT"
      change_trigger: "Updated only upon new performer capture or performer-approved likeness revision."

    CHARACTER_IDENTITY:
      id: "CHAR-UNDERTAKERS-LUTA"
      character_canon_version: "LUTA-CANON-v001"
      creative_property: "WRASAL | THE UNDERTAKERS"
      change_trigger: "Updated only by WRASAL Narrative/World Canon authority."

    COSTUME_IDENTITY:
      id: "COSTUME-LUTA-CANON"
      costume_spec_version: "COSTUME-LUTA-CANON-v001"
      states_defined: ["STATE_A_HUMAN", "STATE_B_UNDERTAKER", "STATE_C_REVEALED_KING"]
      change_trigger: "Updated only by WRASAL Costume/Visual Authority; never mutates HUMAN_IDENTITY."

    PERFORMANCE_STATE:
      id: "PERF-LUTA-PILOT-GOLDEN-STILLS"
      performance_version: "PERF-STATE-v001"
      active_character_state: "STATE_A | STATE_B | STATE_C"
      expression_preset_ref: "EXP-01"
      change_trigger: "Shot-by-shot expression, pose, and camera state; each render requires scope check against passport_consent_version."
```
