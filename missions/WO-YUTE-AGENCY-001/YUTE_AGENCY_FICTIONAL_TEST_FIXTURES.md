# YUTE™ OS — Fictional & Synthetic Test Fixtures (`WO-YUTE-AGENCY-001`)

- **Document ID:** `YUTE_AGENCY_FICTIONAL_TEST_FIXTURES`
- **Work Order:** `WO-YUTE-AGENCY-001`
- **Version:** `v001`
- **Creation Date:** `2026-10-31`
- **Data Governance Rule:** **100% Fictional Personas & Synthetic Contract Texts.** Zero real individuals, zero scraped copyrighted works, and zero dependency on `WO-YUTE-LUTA-DARRON-001` (`HOLD-RIGHTS-001`). Safe for immediate `v003`/`v004` CI execution in `wrasalmedia-rgb/yute`.

---

## Fixture 1: `AGR-FICT-HARBOR-LIGHT-001` (Drives Constitutional Test `YUTE-AGENCY-INV-001`)

- **Fictional Subject:** `SUBJ-FICT-NIA-CLARKE-001` (*Nia Clarke*, adult screen actor, `ADULT_VERIFIED`)
- **Counterparty:** * Meridian Harbor Pictures LLC (Fictional)*
- **Verbatim Synthetic Agreement Text (for deterministic SHA-256 & byte-offset testing):**

```text
PERFORMER DIGITAL VISUAL REFERENCE SCHEDULE (FICTIONAL TEST INSTRUMENT)
Section 1. Named Production Grant. Performer grants Producer a non-exclusive, limited permission to use approved studio reference stills of Performer solely for visual continuity within the single dramatic motion picture tentatively titled "PROD-FICT-HARBOR-LIGHT" for a term of twenty-four (24) months from 2026-11-01 to 2028-11-01.
Section 2. Express Reservations & Prohibitions. This Schedule does NOT grant any right to synthesize, clone, or simulate Performer's voice ("VOICE_CLONING"), does NOT authorize use of Performer's likeness or voice in commercial product advertising ("ADVERTISING"), and may NOT be sublicensed or transferred to any third party ("SUBLICENSING").
Section 3. Zero Model Training. Producer shall not use Performer's reference materials to train or fine-tune general-purpose machine-learning models.
```

- **Expected `YUTE-AGENCY-INV-001` Outcome:**
  - `VISUAL_LIKENESS_NAMED_PRODUCTION` for `PROD-FICT-HARBOR-LIGHT` → `ALLOW` (issues 60s `FirewallCapabilityLease`).
  - `GENERATE_SYNTHETIC_VOICE_AD` for `AD-BRAND-SOLAR-COLA` → `DENY` (`OUT_OF_AUTHORIZED_SCOPE`; missing permissions: `VOICE_CLONING_NOT_AUTHORIZED`, `ADVERTISING_USE_NOT_AUTHORIZED`, `PRODUCTION_OUTSIDE_NAMED_SCOPE:PROD-FICT-HARBOR-LIGHT`; `identity_assets_transmitted = false`).

---

## Fixture 2: `AGR-FICT-LABEL-DEAL-001` (Musician Non-Avatar `Contract Shield` Test)

- **Fictional Subject:** `SUBJ-FICT-MARCUS-VALE-001` (*Marcus Vale*, independent vocalist/producer — never creates an avatar)
- **Verbatim Synthetic Clauses Flagged by `Contract Shield`:**
  - `Clause 4.2` (`VOICE_CLONING_GRANT` + `PERPETUAL_DURATION`): *"Artist irrevocably grants Company the perpetual, universe-wide right to generate synthetic vocal performances in Artist's vocal timbre across all media now known or hereafter devised."*
  - `Clause 7.4` (`AI_TRAINING_CAPTURE` + `UNRESTRICTED_SUBLICENSING`): *"Company and its third-party technology sublicensees may ingest isolated vocal stems into proprietary acoustic foundation datasets without additional royalty accounting."*

---

## Fixture 3: `DRP-FICT-COASTAL-SERIES-001` (Photographer Non-Avatar `Digital Rights Passport` Test)

- **Fictional Subject:** `SUBJ-FICT-DEVON-REID-001` (*Devon Reid*, documentary photographer)
- **Expected Posture Separation:**
  - Master RAW series `DRP-FICT-COASTAL-SERIES-001`: `OWNED_BY_SUBJECT` (`VERIFIED_EVIDENCE`).
  - Editorial print/web license `AGR-FICT-MAGAZINE-001`: `LICENSED_OUT_SCOPED` (`ai_model_training_allowed = FALSE`).
  - Legacy unarchived 2019 social upload `DRP-FICT-SOCIAL-UPLOAD-002`: `UNKNOWN` (`CLAIMED_UNVERIFIED`).

---

## Fixture 4: `SUBJ-FICT-KAI-001` (Minor Protection & Three-Tier Adulthood Transition Test)

- **Fictional Subject:** `SUBJ-FICT-KAI-001` (`MINOR_PROTECTED` at intake → transitions to adulthood in simulated clock test `@FORENSIC-B`)
- **Tests:**
  1. Guardian attempt to enable `voice_cloning_permitted = TRUE` or `advertising_permitted = TRUE` → rejected by PostgreSQL `minor_cannot_grant_commercial_or_synthetic` constraint.
  2. Simulated 18th-birthday transition → `reauthorization_state = 'PENDING_ADULT_DECISION'`, `processing_restricted = TRUE`, eligible media deleted upon request, and simulated statutory accounting hold `HOLD-TAX-001` disclosed transparently in `retention_disclosure_json`.
