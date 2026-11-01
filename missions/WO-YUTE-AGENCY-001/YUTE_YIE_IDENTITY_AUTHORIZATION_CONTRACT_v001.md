# YUTE™ × YIE™ — Identity Authorization Contract & Authority Proof Specification (`v001.1`)

- **Document ID:** `YUTE_YIE_IDENTITY_AUTHORIZATION_CONTRACT_v001`
- **Contract Version:** `v001.1` (`2026-11-01` — Incorporates `YUTE-ARCH-GOV-003` / Mission Control Engineering Audit 002)
- **Next Runtime Milestone:** **`YUTE-OS-v003 | THE AUTHORITY PROOF`**
- **Review Classification:** `SPECIFICATION VERIFIED IN PART (PG 16.4 WASM ENGINE 27/27 PASS; NETWORKED PG 16 & RUBY 3.3 RUNTIME NOT YET VERIFIED)`
- **Governing ADRs:** `decisions/YUTE-ADR-0010.md` & `decisions/YUTE-ADR-0011.md` (*Recommended Disposition: Conditional Engineering Go, Not Production Approval — Human Ratification Required; No Human Approval Implied by Audit 002*)
- **Constitutional Authority:** `concepts/YUTE-FOUNDATION-DOCTRINE-001.md` (`v002.4` — *The Child We Were. The Human We Become.*)
- **Standalone PostgreSQL 16 Migrations:** `missions/WO-YUTE-AGENCY-001/migrations/003_yute_yie_authorization_contract.sql`, `004_yute_authority_proof_hardening.sql`, `005_verify_pg16_invariants.sql`
- **Executable Gherkin Suite:** `missions/WO-YUTE-AGENCY-001/YUTE_AGENCY_ACCEPTANCE_TESTS.feature` (`@YIE-PROOF-001`, `@AUTH-PROOF-01`..`@AUTH-PROOF-10`, `@YIE-NEG-01`..`@YIE-NEG-07`)
- **Production Status:** `🔴 NO GO` (`S5 canonical_acceptance: pending`; `HOLD-RIGHTS-001: ACTIVE`)

> **WRASAL™ | YUTE CONSTITUTION**
> **THE HUMAN IS THE AUTHORITY.**
> **THE CONTRACT DEFINES THE PERMISSION.**
> **YUTE VERIFIES THE AUTHORIZATION.**
> **YIE EXECUTES ONLY WHAT IS PERMITTED.**
> **MY AGENCY IS NON-NEGOTIABLE.**

---

## 1. Authority Separation & Trust Topology (`YUTE OS™` vs. `YIE™`)

**`YIE™` cannot be its own source of authority.** `YUTE OS™` is the authority; `YIE™` is the capability provider; `YUTE VAULT™` holds authorized asset custody and provenance.

```text
                 HUMAN SUBJECT
                       │
                       ▼
                   YUTE OS™
                       │
                 WELFARE GUARD
                       │
                CONSENT AUTHORITY
                       │
                 AGENCY FIREWALL (Holds Ed25519 Signing Private Key)
                       │
                       ▼
              SIGNED AUTHORIZATION (YieAuthorizationEnvelope, <= 60s, Single-Use)
                       │
                       ▼
                  YIE™ ENGINE (Holds Verify-Only Public Key + Restricted DB Role)
                       │
             VERIFY AUTHORIZATION (Signature + Atomic Claim + Live Upstream State)
                       │
                ┌──────┴──────┐
                ▼             ▼
              ALLOW          DENY
                │             │
                ▼             ▼
          AUTHORIZED       0 ASSETS
          OPERATION        RELEASED
```

---

## 2. Wire & Database Contract: `YieAuthorizationEnvelope` (`YIE-AUTH-ENV-v001`)

```json
{
  "schema": "YIE-AUTH-ENV-v001",
  "envelope_id": "11111111-2222-4333-8444-555555555501",
  "issuer_authority": "YUTE_OS_AGENCY_FIREWALL",
  "signing_key_id": "YUTE-FW-ED25519-PRIMARY-001",
  "canonical_signing_payload_sha256": "64-hex-sha256-of-deterministic-preimage",
  "lease_id": "3a71c9e2-9102-4c11-8e77-556677889900",
  "decision_id": "1b22d8f4-8812-4a09-9d66-112233445566",
  "grant_id": "7c99e1a0-5521-4f88-b123-998877665544",
  "subject": {
    "subject_id": "SUBJ-FICT-NIA-CLARKE-001",
    "subject_age_class": "ADULT_VERIFIED",
    "is_builder_steward": false
  },
  "requested_yie_operation": "YIE_SYNTHESIZE_GOVERNED_REPRESENTATION",
  "approved_assets": [
    {
      "rights_record_id": "DRP-FICT-NIA-STILLS-001",
      "active_likeness_spec_id": "SPEC-FICT-NIA-ACTIVE-v001",
      "likeness_spec_status_at_issue": "PERFORMER_APPROVED"
    }
  ],
  "named_purpose_scope": "PROD-FICT-HARBOR-LIGHT",
  "issued_at": "2026-11-01T12:00:00.000000Z",
  "expires_at": "2026-11-01T12:00:45.000000Z",
  "constitutional_restrictions": {
    "welfare_guard_passed": true,
    "autonomous_persona_allowed": false,
    "ai_model_training_allowed": false,
    "cross_job_cache_allowed": false,
    "human_worth_scoring_allowed": false,
    "admin_privilege_bypass_allowed": false,
    "clarity_disclosure_required": true,
    "ephemeral_worker_isolation_required": true
  },
  "firewall_ed25519_signature": "128-lowercase-hex-chars-encoding-64-byte-raw-ed25519-signature"
}
```

### Canonical Signing Preimage (`yute_canonical_envelope_signing_preimage`)
To prevent canonicalization drift between `Yute::AgencyFirewall` (signer) and `Yie::AuthorizationGate` (verifier), both services serialize the exact pipe-delimited UTF-8 preimage defined in `004_yute_authority_proof_hardening.sql`:
```text
YIE-AUTH-ENV-v001|{envelope_id}|{issuer_authority}|{signing_key_id}|{lease_id}|{decision_id}|{grant_id}|{subject_id}|{approved_rights_record_id}|{active_likeness_spec_id_or_NONE}|{permitted_yute_action}|{requested_yie_operation}|{named_purpose_scope}|{issued_at_utc_micros}|{expires_at_utc_micros}
```

---

## 3. Remediation of Engineering Audit 002 (`YUTE-ARCH-GOV-003`) Runtime Assurance Obligations

Audit 002 identified four runtime assurance obligations (`Findings A..D`) plus database role/RLS isolation (`Section 04`). Below is the exact boundary between what **is now enforced & verified in PostgreSQL 16.4 (`004_yute_authority_proof_hardening.sql` + `005_verify_pg16_invariants.sql`)** and what **remains a mandatory Ruby 3.3 + networked PostgreSQL 16 runtime obligation** for `YUTE-OS-v003 | THE AUTHORITY PROOF`:

### 3.1 🔴 P0 Finding A — Cryptographic Signature Verification
- **Database Layer (`004`, Verified on PG 16.4):**
  - `yute_firewall_signing_keys` registers `ACTIVE | ROTATED_VERIFY_ONLY | REVOKED_COMPROMISED` 32-byte `Ed25519` public keys (`^[0-9a-f]{64}$`).
  - `trg_yie_envelope_key_and_preimage` verifies the signing key is `ACTIVE` at issuance and recomputes `canonical_signing_payload_sha256` in SQL (`Check 19`, `SQLSTATE 23514`).
  - `yie_signature_hex_64bytes` enforces 64-byte hex encoding (`^[0-9a-f]{128}$`), and `yie_boundary_fail_closed_law` blocks `EXECUTED_EPHEMERAL_GOVERNED` unless `signature_verification_status = 'VERIFIED_ED25519_OK'` (`Check 20`, `SQLSTATE 23514`).
- **Remaining Ruby 3.3 Runtime Obligation (`Yie::AuthorizationGate` — NOT YET VERIFIED):**
  - PostgreSQL does **not** perform elliptic-curve `Ed25519.verify` math. `Yie::AuthorizationGate` (using pinned `rbnacl` / OpenSSL `Ed25519` verify-only public key) **must** cryptographically verify `firewall_ed25519_signature` over the canonical preimage *before* calling `yie_claim_single_use_envelope(...)` or requesting any asset slice.
  - **Required Runtime Test (`@AUTH-PROOF-03`):** Submit a structurally valid envelope with a 1-bit flipped / forged 128-hex signature → `Yie::AuthorizationGate` rejects before any vault decryption (`FAILED_FORGED_SIGNATURE`, `0` bytes decrypted).

### 3.2 🔴 P0 Finding B — Atomic Single-Use Enforcement Under Concurrency
- **Database Layer (`004`, Verified on PG 16.4):**
  - `yie_claim_single_use_envelope(envelope_id, worker_id, eval_ts)` acquires an exclusive row lock (`SELECT ... FOR UPDATE`), verifies `envelope_status = 'ISSUED_UNUSED'` and `single_use_claim_token IS NULL`, transitions to `CLAIMED_IN_FLIGHT`, and returns a one-time `UUID` claim token (`Check 21`, `SQLSTATE 23505` on second claim).
  - Unique partial index `uq_yie_single_execution_per_envelope` makes two `EXECUTED_EPHEMERAL_GOVERNED` receipts for the same `envelope_id` structurally impossible (`23505`).
- **Remaining Networked PG 16 + Ruby Concurrency Obligation (`NOT YET VERIFIED`):**
  - Because `PGlite` runs PostgreSQL 16.4 in a single WASM process, **true multi-socket lock contention** across two parallel Ruby worker processes hitting a networked PostgreSQL 16 server simultaneously with a barrier synchronization point must be demonstrated in `wrasalmedia-rgb/yute` CI (`@AUTH-PROOF-05`).

### 3.3 🔴 P0 Finding C — Live Current-State Authorization Checks (Pre-Processing & Finalization)
- **Database Layer (`004`, Verified on PG 16.4):**
  - `yie_assert_live_authority_currency(envelope_id, eval_ts)` locks (`FOR KEY SHARE`) and re-evaluates **live** upstream state across six tables:
    1. `yute_firewall_signing_keys` (`key_status <> 'REVOKED_COMPROMISED'`)
    2. `human_subjects` (`status = 'CONSENTED_ACTIVE'`, `age_protection_class = 'ADULT_VERIFIED'`, and zero `adulthood_transitions.processing_restricted = TRUE`)
    3. `digital_rights_records` (`rights_posture NOT IN ('RESTRICTED_HOLD', 'UNKNOWN')` and `processing_restricted = FALSE`)
    4. `consent_ledger_grants` (`grant_status = 'ACTIVE'`, within `valid_from..valid_until`, and zero `revocation_events` / `revocation_status_ledgers` terminations)
    5. `firewall_capability_leases` (unexpired and non-invalidated)
    6. `likeness_specifications` (`status = 'PERFORMER_APPROVED'` — blocking post-issuance `SUPERSEDED` or `REVOKED` transitions!)
  - Evaluated automatically at **both** boundaries: (1) inside `yie_claim_single_use_envelope(...)` prior to asset access (`Check 22`, `23514`), and (2) inside `AFTER INSERT` trigger `trg_yie_finalize_execution_receipt_gate` prior to committing any execution receipt (`Check 23`, `23514`).

### 3.4 🟠 P1 Finding D — Observable Execution Isolation & Honest Memory Epistemics
- **Epistemic Correction:** A database boolean (`ephemeral_memory_zeroed`) is an application assertion—**never** proof that a managed runtime (such as Ruby MRI with generational GC compaction, copy-on-write `String` slices, and C allocator arenas) has wiped every residual plaintext byte from physical RAM.
- **Safer Architectural Design & Telemetry (`004`):**
  1. **Minimize Decrypted Exposure:** `YIE` never receives whole-vault access; only the single operation-approved slice streams over `mTLS` into a dedicated one-shot worker.
  2. **Explicit Native Buffer Zeroing Where Feasible:** Temporary symmetric keys and C-allocated buffers use `RbNaCl::Util.zero` / `sodium_memzero` rather than long-lived Ruby `String` globals.
  3. **Mandatory One-Shot Worker Termination:** Each identity-processing job executes inside an isolated one-shot subprocess (`ONE_SHOT_SUBPROCESS_ISOLATED`) or ephemeral microVM (`EPHEMERAL_MICROVM_ISOLATED`) that **terminates immediately upon job completion or revocation abort**, returning OS pages to the kernel (`isolated_worker_terminated = TRUE`, `Check 24`).
  4. **Explicit Epistemic Labeling:** `yie_execution_receipts.memory_assurance_epistemic_scope` is hard-constrained to `'PROCESS_ISOLATION_TELEMETRY_ONLY_NOT_RAM_PROOF'`. YUTE never promises absolute RAM zeroization beyond verified OS/runtime isolation boundaries.

### 3.5 Section 04 — Non-Superuser Database Roles & `FORCE ROW LEVEL SECURITY`
- **Database Layer (`004`, Verified on PG 16.4 in `Checks 25..27`):**
  - Three `NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOBYPASSRLS` service roles: `yute_firewall_service`, `yie_capability_service`, and `yute_auditor_readonly`.
  - `REVOKE ALL` from `PUBLIC`; **`FORCE ROW LEVEL SECURITY`** enabled on all `16` core subject, vault, passport, ceremony, grant, decision, lease, signing-key, envelope, and receipt tables (`relforcerowsecurity = TRUE`), ensuring even non-superuser table owners cannot bypass RLS.
  - **`yie_capability_service` Restrictions:**
    - **`0` privileges on `source_assets`** (`YUTE Vault` raw records — `Check 26`, `SQLSTATE 42501`).
    - **`0` `INSERT`/`UPDATE`/`DELETE` privileges on `yie_authorization_envelopes` authority columns or any `YUTE` consent/grant/lease table** (`Check 25`, `SQLSTATE 42501` — `YIE` cannot mint envelopes at the PostgreSQL ACL layer).
    - **Subject-Scoped RLS Policies (`rls_yie_*`):** `yie_capability_service` can only `SELECT` or claim rows where `subject_id = current_setting('app.current_subject_id', true)` (`Check 27`: `0` cross-subject rows visible).

---

## 4. Next Milestone Matrix: `YUTE-OS-v003 | THE AUTHORITY PROOF`

Upon human ratification of `YUTE-ADR-0010` and `YUTE-ADR-0011`, the `wrasalmedia-rgb/yute` Ruby 3.3 + networked PostgreSQL 16 runtime must demonstrate all **10 Authority Proof outcomes** using 100% fictional test fixtures:

| Tag | Authority Proof Scenario | Expected Runtime Result | PG 16.4 SQL Gate (`005`) | Ruby 3.3 + Networked PG 16 Service |
|---|---|---|---|---|
| **`@AUTH-PROOF-01`** | **Valid signed authorization** | Proceeds **only** within approved asset, action, and named purpose scope | **VERIFIED (`Check 18`)** | `PENDING RATIFICATION` |
| **`@AUTH-PROOF-02`** | **Missing signature / missing envelope** | **`DENY`** (`0` bytes decrypted, `0` frames emitted, even when `engine_capability_ready = TRUE`) | **VERIFIED (`Check 11`)** | `PENDING RATIFICATION` |
| **`@AUTH-PROOF-03`** | **Forged `Ed25519` signature** | **`DENY`** at `Yie::AuthorizationGate` before claim/decryption (`FAILED_FORGED_SIGNATURE`) | **VERIFIED (`Checks 19, 20`)** | `PENDING RATIFICATION` *(Ed25519 math)* |
| **`@AUTH-PROOF-04`** | **Expired authorization (`> 60s` or past `expires_at`)** | **`DENY`** (`YIE_ENVELOPE_EXPIRED`) | **VERIFIED (`Check 13`)** | `PENDING RATIFICATION` |
| **`@AUTH-PROOF-05`** | **Replayed / concurrent single-use authorization** | **`DENY`** (`SQLSTATE 23505`; under 2 parallel workers, at most 1 claims) | **VERIFIED (`Check 21`)** | `PENDING RATIFICATION` *(Multi-socket race)* |
| **`@AUTH-PROOF-06`** | **Cross-subject authorization (`YUTE-AGENCY-INV-002`)** | **`DENY`** (`SQLSTATE 23503` composite FK + `0` cross-subject RLS visibility) | **VERIFIED (`Checks 14, 27`)** | `PENDING RATIFICATION` |
| **`@AUTH-PROOF-07`** | **Superseded identity specification (`@AC-16`)** | **`DENY`** both at issuance **and** if superseded after envelope issuance (`Finding C`) | **VERIFIED (`Checks 15, 22`)** | `PENDING RATIFICATION` |
| **`@AUTH-PROOF-08`** | **Revoked permission (pre-claim or mid-flight)** | **`DENY` / `ABORT`** at live authority gate (`Finding C` + `EGRESS-FENCE-v001`) | **VERIFIED (`Check 23`)** | `PENDING RATIFICATION` |
| **`@AUTH-PROOF-09`** | **Administrative override without permission** | **`DENY`** (`admin_override_attempted = TRUE` blocked; Founder/Builder parity enforced) | **VERIFIED (`Checks 16, 17`)** | `PENDING RATIFICATION` |
| **`@AUTH-PROOF-10`** | **Authorized fictional test request** | **Execute** in isolated one-shot worker & emit all **7 inspectable evidence artifacts** | **VERIFIED (`Check 18`)** | `PENDING RATIFICATION` |

### Extended Seven-Artifact Evidence Package (`01`..`07`)
`YUTE-OS-v003 | THE AUTHORITY PROOF` extends the 5-artifact firewall bundle with two dedicated `YUTE × YIE` cryptographic & consumption receipts:
1. `01_contract_analysis.json` — `YUTE GUARD™` NFC-verified clause citations & plain-language risk explanations.
2. `02_consent_record.json` — 5-stage consent process evidence (`PRESENTED → ACKNOWLEDGED → EXPLAINED → DECIDED → AUTHORIZED`).
3. `03_generation_request.json` — Caller's requested identity/voice operation & target scope.
4. `04_firewall_decision.json` — `Yute::AgencyFirewall` `ALLOW` (with signed `YieAuthorizationEnvelope`) or `DENY`.
5. `05_audit_receipt.json` — Firewall-side tamper-evident hash chain receipt.
6. **`06_signature_verification_receipt.json`** *(Added per Audit 002 Section 05)* — `Yie::AuthorizationGate` receipt recording `signing_key_id`, `ed25519_public_key_hex`, `canonical_signing_payload_sha256`, `signature_verification_status` (`VERIFIED_ED25519_OK` or `FAILED_FORGED_SIGNATURE`), and timestamp prior to vault access.
7. **`07_authorization_consumption_receipt.json`** *(Added per Audit 002 Section 05)* — Atomic single-use claim & live-state execution receipt recording `consumed_claim_token`, `envelope_status` transition (`ISSUED_UNUSED → CLAIMED_IN_FLIGHT → CONSUMED_SINGLE_USE`), live upstream check statuses at claim & finalization, `worker_isolation_mode`, `isolated_worker_terminated`, `memory_assurance_epistemic_scope` (`PROCESS_ISOLATION_TELEMETRY_ONLY_NOT_RAM_PROOF`), `identity_bytes_decrypted`, and `generated_frames_emitted`.
