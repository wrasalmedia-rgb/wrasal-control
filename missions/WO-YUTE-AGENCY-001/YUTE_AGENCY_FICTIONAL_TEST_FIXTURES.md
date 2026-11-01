# YUTE™ OS — Fictional & Synthetic Test Fixtures (`WO-YUTE-AGENCY-001` / `YUTE-OS-v003`)

- **Document ID:** `YUTE_AGENCY_FICTIONAL_TEST_FIXTURES`
- **Work Order:** `WO-YUTE-AGENCY-001`
- **Governing ADR:** `decisions/YUTE-ADR-0010.md` (*Fictional-Data Engineering Only*)
- **Version:** `v001.1` (`2026-10-31`)
- **Data Governance Rule:** **100% Fictional Personas & Synthetic Contract Texts.** Zero real individuals, zero scraped copyrighted works, and zero dependency on `WO-YUTE-LUTA-DARRON-001` (`HOLD-RIGHTS-001`).

---

## Fixture 0: `AGR-FICT-SINGLE-DIST-001` (Drives `YUTE-OS-v003 | AGENCY FIREWALL PROOF` & `TEST-03` Unicode Stress)

- **Fictional Subject:** `SUBJ-FICT-ZURI-BENNETT-001` (*Zuri Bénnett*, 19-year-old independent recording artist, `ADULT_VERIFIED`)
- **Counterparty:** *SoundBridge Digital Distribution Ltd. (Fictional)*
- **Protected Vault Asset:** `DRP-FICT-ZURI-VOCAL-MASTER-001` (synthetic test WAV buffer)
- **Unicode & Normalization Stress Cases Embedded (`TEST-03`):** Accented Latin character (`Bénnett` ingested in both NFD `e\u0301` and NFC `é`), typographic curly quotes (`“Kingston Rain (Live Session)”`), em-dash (`—`), and CRLF (`\r\n`) input normalized to `UNICODE_NFC_LF`.
- **Verbatim Synthetic Agreement Text (`UNICODE_NFC_LF`):**

```text
SINGLE RECORDING DISTRIBUTION SCHEDULE (FICTIONAL TEST INSTRUMENT)
Clause 1.1 — Scoped Single-Performance Distribution. Artist Zuri Bénnett (“Artist”) authorizes Distributor to distribute the single recorded musical performance titled “Kingston Rain (Live Session)” (Track ID: TRACK-FICT-KINGSTON-RAIN-001) on digital audio streaming services for eighteen (18) months from 2026-11-01 to 2028-05-01.
Clause 2.2 — Reserved Vocal & Generative Rights. All rights not expressly granted remain with Artist. Nothing in this Schedule authorizes synthetic voice generation, vocal cloning, stem-based AI model training, or the creation of new simulated vocal performances.
```

- **Expected `YUTE-OS-v003` Proof Outcome:**
  - Verified ceremony `CEREMONY-ZURI-001` (`clauses_presented_at < signed_at`) registers `GRANT-ZURI-001` (`PERFORMANCE_DISTRIBUTION_NAMED_TRACK` for `TRACK-FICT-KINGSTON-RAIN-001`, `voice_cloning_permitted: false`).
  - Fictional producer `actor:producer_vance_keller` requests `GENERATE_SYNTHETIC_VOICE_PERFORMANCE` (`REQ-SYNTH-VOICE-001`).
  - **`Yute::AgencyFirewall` returns `DENY`**, releases `0` bytes, and emits `01_contract_analysis.json`, `02_consent_record.json`, `03_generation_request.json`, `04_firewall_decision.json`, and `05_audit_receipt.json`.

---

## Fixture 1: `AGR-FICT-HARBOR-LIGHT-001` (Drives Constitutional Test `YUTE-AGENCY-INV-001` & `TEST-05`)

- **Fictional Subject:** `SUBJ-FICT-NIA-CLARKE-001` (*Nia Clarke*, adult screen actor, `ADULT_VERIFIED`)
- **Counterparty:** *Meridian Harbor Pictures LLC (Fictional)*
- **Verbatim Synthetic Agreement Text:**

```text
PERFORMER DIGITAL VISUAL REFERENCE SCHEDULE (FICTIONAL TEST INSTRUMENT)
Section 1. Named Production Grant. Performer grants Producer a non-exclusive, limited permission to use approved studio reference stills of Performer solely for visual continuity within the single dramatic motion picture tentatively titled "PROD-FICT-HARBOR-LIGHT" for a term of twenty-four (24) months from 2026-11-01 to 2028-11-01.
Section 2. Express Reservations & Prohibitions. This Schedule does NOT grant any right to synthesize, clone, or simulate Performer's voice ("VOICE_CLONING"), does NOT authorize use of Performer's likeness or voice in commercial product advertising ("ADVERTISING"), and may NOT be sublicensed or transferred to any third party ("SUBLICENSING").
Section 3. Zero Model Training. Producer shall not use Performer's reference materials to train or fine-tune general-purpose machine-learning models.
```

---

## Fixture 2: `AGR-FICT-LABEL-DEAL-001` (`YUTE GUARD™` Predatory Clause Detection Test)

- **Fictional Subject:** `SUBJ-FICT-MARCUS-VALE-001` (*Marcus Vale*, independent vocalist/producer — never creates an avatar)
- **Verbatim Synthetic Clauses Flagged by `YUTE GUARD™` (`Contract Shield`):**
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

## Fixture 4: `SUBJ-FICT-KAI-001` (Minor Protection, 3-Tier Adulthood Transition & `TEST-04` Retention Hold)

- **Fictional Subject:** `SUBJ-FICT-KAI-001` (`MINOR_PROTECTED` at intake → transitions to adulthood in simulated clock test)
- **Tests:**
  1. Guardian attempt to enable `voice_cloning_permitted = TRUE` or `advertising_permitted = TRUE` → rejected by PostgreSQL `minor_cannot_grant_commercial_or_synthetic`.
  2. Simulated 18th-birthday transition with two-steward statutory hold `HOLD-TAX-001` → `processing_restricted = TRUE` blocks 100% of operational access, eligible media is crypto-shredded, and `HOLD-TAX-001` is transparently disclosed (`PARTIAL_DELETED_WITH_DECLARED_LEGAL_HOLD`).

---

## Fixture 5: `SUBJ-FICT-FOUNDER-STEWARD-001` (Founder / Builder Inclusion & Admin-Override Prohibition Test — `YUTE-ARCH-GOV-002`)

- **Fictional Subject:** `SUBJ-FICT-FOUNDER-STEWARD-001` (*Avery Clarke*, fictional platform founder/steward, `is_builder_steward = TRUE`)
- **Synthetic Agreement (`AGR-FICT-FOUNDER-KEYNOTE-001`):** Scoped single-event product-keynote demonstration grant (`KEYNOTE-DEMO-2026`), expressly excluding commercial advertising (`ADVERTISING`), autonomous persona agents, and model training.
- **Two-Way Symmetry Tests (`@YIE-NEG-05`, `@YIE-NEG-06`):**
  1. **No Admin Privilege Over Others:** `SUBJ-FICT-FOUNDER-STEWARD-001` (or a system root operator) sets `admin_override_attempted = TRUE` to process `SUBJ-FICT-ZURI-BENNETT-001`'s likeness without Zuri's `YieAuthorizationEnvelope` → rejected fail-closed (`SQLSTATE 23514`, `ADMIN_PRIVILEGE_CANNOT_AUTHORIZE_LIKENESS`, `0` bytes decrypted).
  2. **Equal Protection for the Builder:** An internal workflow attempts to generate `SUBJ-FICT-FOUNDER-STEWARD-001`'s own likeness for an unauthorized commercial ad outside `KEYNOTE-DEMO-2026` → `Yute::AgencyFirewall` and `YIE` refuse identically (`SQLSTATE 23514`, `MISSING_OR_DENIED_YUTE_AUTHORIZATION`, `0` frames emitted).

