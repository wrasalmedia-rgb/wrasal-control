# YUTE-OS-v003 | AGENCY FIREWALL PROOF & Six Adversarial Runtime Tests Specification

- **Document ID:** `YUTE_OS_v003_FIREWALL_PROOF_SPEC`
- **Milestone:** `YUTE-OS-v003 | AGENCY FIREWALL PROOF`
- **Governing ADRs & Review:** `decisions/YUTE-ADR-0010.md`, `decisions/YUTE-ADR-0011.md`, & `YUTE-ARCH-GOV-002` (*Conditional Approval — Fictional-Data Engineering Only; Human Ratification Required*)
- **Work Order:** `WO-YUTE-AGENCY-001`
- **YUTE × YIE Contract Spec:** `missions/WO-YUTE-AGENCY-001/YUTE_YIE_IDENTITY_AUTHORIZATION_CONTRACT_v001.md`
- **Standalone PG 16 Migrations Verified:** `missions/WO-YUTE-AGENCY-001/migrations/001_yute_mvp_core.sql`, `002_yute_agency_foundation.sql`, `003_yute_yie_authorization_contract.sql`, `004_verify_pg16_invariants.sql` (`evidence/WO-YUTE-AGENCY-001-pg16-schema-verification.json`)
- **Target Runtime Environment:** Private isolated repository `wrasalmedia-rgb/yute` (Ruby `3.3+`, native multi-connection PostgreSQL `16+`)
- **Current Execution Status:** `PG 16.4 DDL & SQL INVARIANTS VERIFIED (17/17 PASS); RUBY 3.3 SERVICE & YIE RUNTIME EXECUTION PENDING YUTE-ADR-0010 & YUTE-ADR-0011 RATIFICATION`

> **MILESTONE ACCEPTANCE CONDITION (`YUTE-ADR-0010`):**
> **A working YUTE service demonstrably prevents an unauthorized digital-representation operation while preserving the evidence explaining its decision.**

---

## 1. End-to-End Runtime Proof Scenario (`@YUTE-OS-v003-PROOF`)

1. **Subject:** Fictional emerging recording artist **Zuri Bénnett** (`SUBJ-FICT-ZURI-BENNETT-001`, adult independent vocalist, `ADULT_VERIFIED`).
2. **Agreement Ingested via `YUTE GUARD™` (*Know Before You Agree*):** `AGR-FICT-SINGLE-DIST-001` (*Single Recording Distribution Schedule — “Kingston Rain (Live Session)”*), authorizing streaming distribution of **one named musical performance** (`TRACK-FICT-KINGSTON-RAIN-001`) while reserving all synthetic voice rights.
3. **Five-Stage Consent Process (`PRESENTED → ACKNOWLEDGED → EXPLAINED → DECIDED → AUTHORIZED`):**
   - `YUTE GUARD™` presents cited clauses (`presented_at`), records receipt acknowledgment (`acknowledged_at`), surfaces plain-language explanations, uncertainties, and counsel referral (`explained_at`), records Zuri's autonomous choice (`decided_at`, `DECIDED_TO_AUTHORIZE`), and binds signature (`authorized_at`), tagging `comprehension_epistemic_status = "PROCESS_EVIDENCE_ONLY_NOT_MIND_PROOF"`.
4. **Adversarial Producer Request:** Fictional producer `actor:producer_vance_keller` submits `REQ-SYNTH-VOICE-001` requesting `GENERATE_SYNTHETIC_VOICE_PERFORMANCE` against `DRP-FICT-ZURI-VOCAL-MASTER-001`.
5. **Required Outcome:** **`Yute::AgencyFirewall` returns `DENY`**, issues **no** capability lease, decrypts `0` bytes, makes `0` synthesis provider calls, and emits **five independently inspectable JSON artifacts**.

---

## 2. The Five Independently Inspectable Proof Artifacts

| # | Artifact Filename | Purpose | Required Verifiable Fields |
|---|---|---|---|
| **1** | `01_contract_analysis.json` | Exact clauses surfaced by `YUTE GUARD™`. | `agreement_id`, `original_upload_sha256`, `canonical_text_sha256` (`UNICODE_NFC_LF`), `findings[]` (`clause_reference`, `utf8_byte_start..end`, `codepoint_start..end`, `verbatim_excerpt_nfc`, `plain_language_explanation`, `questions_worth_raising[]`), `non_legal_advice_notice`. |
| **2** | `02_consent_record.json` | 5-stage consent process evidence & scoped grant (`Refinement 3.A` + `YUTE-AGENCY-INV-002`). | `grant_id`, `ceremony_id`, `subject_id`, `scoped_rights_record_id`, `verified_signer_actor_id`, `presented_at`, `acknowledged_at`, `explained_at`, `decided_at`, `decision_outcome` (`DECIDED_TO_AUTHORIZE`), `authorized_at`, `comprehension_epistemic_status` (`PROCESS_EVIDENCE_ONLY_NOT_MIND_PROOF`), `permitted_action` (`PERFORMANCE_DISTRIBUTION_NAMED_TRACK`), `named_target_scope` (`TRACK-FICT-KINGSTON-RAIN-001`), `voice_cloning_permitted: false`, `valid_from`, `valid_until`. |
| **3** | `03_generation_request.json` | Producer's requested synthetic-voice operation. | `request_id` (`REQ-SYNTH-VOICE-001`), `requested_by_actor`, `execution_boundary`, `subject_id`, `requested_rights_record_id` (`DRP-FICT-ZURI-VOCAL-MASTER-001`), `requested_action` (`GENERATE_SYNTHETIC_VOICE_PERFORMANCE`), `requested_target_scope`, `requires_voice_synthesis: true`. |
| **4** | `04_firewall_decision.json` | Structured denial & missing permissions. | `decision_id`, `request_id`, `matched_grant_id: null`, `outcome: "DENY"`, `denial_reason_code: "VOICE_SYNTHESIS_AND_TARGET_OUT_OF_SCOPE"`, `missing_permissions[]`, `capability_lease_issued: null`. |
| **5** | `05_audit_receipt.json` | Tamper-evident proof of zero asset release. | `audit_receipt_id`, `decision_id`, `protected_assets_released: false`, `vault_bytes_decrypted: 0`, `adapter_network_calls_made: 0`, `prev_ledger_hash`, `audit_receipt_sha256`. |

---

## 3. Six Mandatory Adversarial Acceptance Targets (`TEST-01`..`TEST-06`)

| Test ID | Target | Required Runtime Outcome | PG 16.4 SQL Layer Status (`004_verify_pg16_invariants.sql`) | Ruby 3.3 Service Layer Status (`wrasalmedia-rgb/yute`) |
|---|---|---|---|---|
| **`TEST-01`** | **Authorization Bypass** | No unauthorized access across HTTP API, CLI, background workers, admin tools, or rendering adapters without a valid single-use `<=60s` `FirewallCapabilityLease`. | **VERIFIED (`23502` NULL check blocked)** | `PENDING YUTE-ADR-0010 RATIFICATION` |
| **`TEST-02`** | **Concurrent Revocation & Egress Ordering (`EGRESS-FENCE-v001`)** | Pre-`T2_CLAIM` revocations block 100% via `SELECT ... FOR UPDATE` (`INVALIDATED_AT_COMMIT_BOUNDARY`, `0` bytes); pre-flush aborts settle as `ABORTED_PRE_SOCKET_ZERO_BYTES`; post-`first_payload_byte_flushed_at` revocations settle truthfully as `REVOKED_POST_IRREVOCABLE_EGRESS` triggering 4-axis downstream notification without fake deletion claims. | **VERIFIED (`23514` egress timestamp & fake-deletion constraints)** | `PENDING YUTE-ADR-0010 RATIFICATION` *(Requires multi-connection PG 16 socket barrier)* |
| **`TEST-03`** | **Contract Citation Integrity** | Extracted quotations retain exact source integrity across NFD/NFC accents (`Bénnett`), curly quotes, em-dashes, and CRLF/LF normalization; 1-char mutations raise `UncitedFindingError`. | **VERIFIED (Fixture NFC byte/codepoint math)** | `PENDING YUTE-ADR-0010 RATIFICATION` |
| **`TEST-04`** | **Preservation, Deletion & Retention Controls** | Immutable ledgers block `UPDATE`/`DELETE` (`P0001`); eligible personal media deletes cleanly while two-steward statutory holds (`steward_a != steward_b`) remain frozen under `processing_restricted = TRUE` and transparently disclosed. | **VERIFIED (`P0001` trigger & `23514` two-steward quorum)** | `PENDING YUTE-ADR-0010 RATIFICATION` |
| **`TEST-05`** | **Synthetic Identity Misuse (`YUTE-AGENCY-INV-001`)** | Unauthorized synthetic voice/likeness request is denied before any protected asset reaches a synthesis/rendering provider (`0` bytes transmitted; 5 proof artifacts emitted). | **VERIFIED (`DENY` decision constraint & baseline)** | `PENDING YUTE-ADR-0010 RATIFICATION` |
| **`TEST-06`** | **Cross-Subject & Cross-Purpose Authorization Integrity (`YUTE-AGENCY-INV-002`)** | Attempting to attach a valid consent ceremony, agreement, asset, grant, or `YIE` lease from Subject A (Zuri Bénnett) to Subject B (Nia Clarke)—or splicing a distribution grant onto a voice-synthesis `ALLOW` decision—fails closed (`DENY` / `SQLSTATE 23503`), even when every referenced record exists independently. | **VERIFIED (`23503` across ceremony, asset, purpose, and `YIE` lease splices)** | `PENDING YUTE-ADR-0010 & YUTE-ADR-0011 RATIFICATION` |
| **`@YIE-PROOF-001` & `@YIE-NEG-01..07`** | **Capable `YIE` Refuses Unauthorized Identity Request (`YUTE × YIE v001`)** | Even when `engine_capability_ready = TRUE`, `YIE` refuses unauthorized, self-authorized, `>60s` expired, superseded-spec (`@AC-16`), admin-override, or unconsented Founder/Builder likeness requests (`0` bytes decrypted, `0` frames emitted). | **VERIFIED (`23514` / `23503` across `11-YIE-PROOF-001`..`17-YIE-NEG-06`)** | `PENDING YUTE-ADR-0010 & YUTE-ADR-0011 RATIFICATION` |
