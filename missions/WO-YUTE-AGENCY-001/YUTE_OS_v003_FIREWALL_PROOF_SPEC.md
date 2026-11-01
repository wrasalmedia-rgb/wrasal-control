# YUTE-OS-v003 | AGENCY FIREWALL PROOF & Five Adversarial Runtime Tests Specification

- **Document ID:** `YUTE_OS_v003_FIREWALL_PROOF_SPEC`
- **Milestone:** `YUTE-OS-v003 | AGENCY FIREWALL PROOF`
- **Governing ADR:** `decisions/YUTE-ADR-0010.md` (*Conditional Approval — Fictional-Data Engineering Only; Human Ratification Required*)
- **Work Order:** `WO-YUTE-AGENCY-001`
- **Target Runtime Environment:** Private isolated repository `wrasalmedia-rgb/yute` (Ruby `3.3+`, PostgreSQL `16+`)
- **Current Execution Status:** `SPECIFIED FOR v003 RUNTIME HARNESS — NOT YET EXECUTED AGAINST LIVE RUBY/PG16`

> **MILESTONE ACCEPTANCE CONDITION (`YUTE-ADR-0010`):**
> **A working YUTE service demonstrably prevents an unauthorized digital-representation operation while preserving the evidence explaining its decision.**

---

## 1. End-to-End Runtime Proof Scenario (`@YUTE-OS-v003-PROOF`)

1. **Subject:** Fictional emerging recording artist **Zuri Bénnett** (`SUBJ-FICT-ZURI-BENNETT-001`, adult independent vocalist, `ADULT_VERIFIED`).
2. **Agreement Ingested via `YUTE GUARD™` (*Know Before You Agree*):** `AGR-FICT-SINGLE-DIST-001` (*Single Recording Distribution Schedule — “Kingston Rain (Live Session)”*).
   - Authorizes digital streaming distribution of **one recorded musical performance** (`TRACK-FICT-KINGSTON-RAIN-001`) for 18 months.
   - Does **not** authorize synthetic voice generation, vocal cloning, or AI stem training.
3. **Human Review & Verified Ceremony (`Refinement 3.A`):**
   - `YUTE GUARD™` highlights Clause 1.1 (single-track distribution scope) and Clause 2.2 / Missing-Scope Notice (no synthetic voice rights granted) with exact UTF-8 byte & Unicode codepoint spans.
   - Zuri reviews the findings (`clauses_presented_at`), opts in to record preservation, and executes verified ceremony `CEREMONY-ZURI-001` (`signed_at > clauses_presented_at`), registering `GRANT-ZURI-001` in `Yute::ConsentLedger`.
4. **Adversarial Producer Request:**
   - Fictional producer `actor:producer_vance_keller` submits generation request `REQ-SYNTH-VOICE-001` seeking `GENERATE_SYNTHETIC_VOICE_PERFORMANCE` using Zuri's archived vocal master (`DRP-FICT-ZURI-VOCAL-MASTER-001`) for track `"TRACK-FICT-NEON-REMIX-999"`.
5. **Required System Behavior:**
   - **`Yute::AgencyFirewall` denies the operation fail-closed (`OUTCOME: DENY`)** before `SourceAssetVault` decrypts or transmits a single byte to any synthesis adapter, and emits **five independently inspectable JSON artifacts**.

---

## 2. The Five Independently Inspectable Proof Artifacts

When `bundle exec rake yute:proof:v003` executes in `wrasalmedia-rgb/yute`, it must write five deterministic, SHA-256-verifiable artifacts:

| # | Artifact Filename | Purpose | Required Verifiable Fields |
|---|---|---|---|
| **1** | `01_contract_analysis.json` | Shows exact relevant clauses surfaced by `YUTE GUARD™` (`Contract Shield`). | `agreement_id`, `original_upload_sha256`, `canonical_text_sha256` (`UNICODE_NFC_LF`), `findings[]` with `clause_reference`, `utf8_byte_start..end`, `codepoint_start..end`, `verbatim_excerpt_nfc`, `plain_language_explanation`, `questions_worth_raising[]`, `non_legal_advice_notice`. |
| **2** | `02_consent_record.json` | Establishes verified signer attribution, ceremony evidence, dates, and authorized scope (`Refinement 3.A`). | `grant_id`, `ceremony_id`, `verified_signer_actor_id`, `signer_authority_basis` (`SELF_ADULT_SUBJECT`), `signer_verification_method`, `guard_analysis_snapshot_sha256`, `clauses_presented_at`, `signed_at`, `permitted_action` (`PERFORMANCE_DISTRIBUTION_NAMED_TRACK`), `named_target_scope` (`TRACK-FICT-KINGSTON-RAIN-001`), `voice_cloning_permitted: false`, `valid_from`, `valid_until`. |
| **3** | `03_generation_request.json` | Documents the producer's requested synthetic-voice operation. | `request_id` (`REQ-SYNTH-VOICE-001`), `requested_by_actor` (`actor:producer_vance_keller`), `execution_boundary`, `subject_id`, `target_asset_id` (`DRP-FICT-ZURI-VOCAL-MASTER-001`), `requested_action` (`GENERATE_SYNTHETIC_VOICE_PERFORMANCE`), `requested_target_scope` (`TRACK-FICT-NEON-REMIX-999`), `requires_voice_synthesis: true`. |
| **4** | `04_firewall_decision.json` | Explains why authorization was denied. | `decision_id`, `request_id`, `evaluated_grant_id` (`GRANT-ZURI-001`), `outcome: "DENY"`, `denial_reason_code: "VOICE_SYNTHESIS_AND_TARGET_OUT_OF_SCOPE"`, `missing_permissions: ["VOICE_CLONING_NOT_AUTHORIZED", "ACTION_NOT_PERMITTED:GENERATE_SYNTHETIC_VOICE_PERFORMANCE", "TARGET_OUTSIDE_NAMED_SCOPE:TRACK-FICT-KINGSTON-RAIN-001"]`, `capability_lease_issued: null`. |
| **5** | `05_audit_receipt.json` | Preserves tamper-evident proof that protected assets were never released. | `audit_receipt_id`, `decision_id`, `protected_assets_released: false`, `vault_bytes_decrypted: 0`, `adapter_network_calls_made: 0`, `prev_ledger_hash`, `audit_receipt_sha256`. |

---

## 3. The Five Adversarial Runtime Tests That Matter Most (`v003` Gate)

Runtime engineering in `wrasalmedia-rgb/yute` must prioritize these five adversarial verification suites ahead of any UI polish or secondary features:

### `TEST-01` — Authorization Bypass Across Execution Boundaries
- **Adversarial Vector:** Attempt to read or decrypt `DRP-FICT-ZURI-VOCAL-MASTER-001` via (a) HTTP API without lease, (b) CLI runner bypassing HTTP, (c) background worker calling `SourceAssetVault#open_plaintext_stream` directly, (d) rendering adapter with a tampered HMAC/Ed25519 lease, and (e) expired (`> 60s`) or already-consumed single-use lease.
- **Pass Evidence:** 100% raise fail-closed domain exceptions (`MissingCapabilityLeaseError`, `InvalidLeaseSignatureError`, `ExpiredCapabilityLeaseError`); PostgreSQL `vault_access_audit_logs` records `0` `DECRYPT_READ` completions.

### `TEST-02` — Concurrent Consent Revocation Race at Final Commit Boundary
- **Adversarial Vector:** Worker Thread A acquires a valid `FirewallCapabilityLease` (`LEASE-RACE-01`) for an authorized track distribution export and pauses at a synchronization barrier right before `commit_authorized_action!`. Concurrently, Thread B commits a signed revocation from Zuri (`grant_status -> 'REVOKED'`). Thread A resumes and attempts to finalize output write.
- **Pass Evidence:** Final-boundary `SELECT ... FOR SHARE` re-check detects `REVOKED`, transitions lease to `INVALIDATED_AT_COMMIT_BOUNDARY`, discards in-memory buffer (`0` bytes written), and updates `revocation_status_ledgers` with `internal_processing_cessation_status = 'CONFIRMED_INTERNAL_HALTED'` while keeping `confirmed_deletion_status` distinct from unconfirmed external copies (`Refinement 3.B`).

### `TEST-03` — Contract Citation Integrity Under Unicode & Normalization Stress
- **Adversarial Vector:** Ingest `AGR-FICT-SINGLE-DIST-001` containing decomposed UTF-8 (`B` + `e\u0301` vs. precomposed `é`), curly quotes (`“Kingston Rain”`), em-dashes (`—`), Windows `\r\n` line endings, and multi-byte symbols; also inject a mutated finding with a 1-character altered quote or shifted offset.
- **Pass Evidence:** Canonical `UNICODE_NFC_LF` normalization maps both `utf8_byte_start..end` and `codepoint_start..end` losslessly back to the exact clause substring; the 1-character mutated quote fails closed with `Yute::UncitedFindingError`.

### `TEST-04` — Evidence Preservation vs. Eligible Deletion & Lawful Retention Holds
- **Adversarial Vector:** Attempt `UPDATE` / `DELETE` on `approval_ledger_entries` and `agency_firewall_decisions` (blocked by PostgreSQL immutability trigger); then execute a subject deletion request where one non-biometric accounting record carries a two-steward statutory hold (`HOLD-TAX-001`) while vocal/media vault records have no hold.
- **Pass Evidence:** Immutable audit hashes remain intact; all eligible personal media/vault objects are crypto-shredded; `processing_restricted = TRUE` blocks all operational access; retained statutory hold is explicitly disclosed with expiry date and two-steward signatures (`approved_by_steward_a != approved_by_steward_b`).

### `TEST-05` — Synthetic Identity Misuse Prevention (`@YUTE-OS-v003-PROOF` & `@YUTE-AGENCY-INV-001`)
- **Adversarial Vector:** Submit unauthorized synthetic-voice performance request (`REQ-SYNTH-VOICE-001` on Zuri's single-track distribution deal) and unauthorized synthetic-voice ad request (`AD-BRAND-SOLAR-COLA` on Nia Clarke's single-film visual deal) against an instrumented mock rendering/synthesis provider spy.
- **Pass Evidence:** Both requests return `DENY` prior to asset lookup; mock rendering provider spy asserts `received_requests.count == 0` and `received_bytes == 0`; all 5 proof artifacts validate against JSON schema.
