# YUTE™ × YIE™ — Identity Authorization Contract Specification (`v001`)

- **Document ID:** `YUTE_YIE_IDENTITY_AUTHORIZATION_CONTRACT_v001`
- **Milestone:** `YUTE × YIE | IDENTITY AUTHORIZATION CONTRACT v001`
- **Classification:** `YUTE-ARCH-GOV-002`
- **Governing ADRs:** `decisions/YUTE-ADR-0011.md` (*Proposed*), `decisions/YUTE-ADR-0010.md` (*Conditional Approval — Human Ratification Required*)
- **Constitutional Authority:** `concepts/YUTE-FOUNDATION-DOCTRINE-001.md` (`v002.3` — *The Child We Were. The Human We Become.*)
- **Standalone PostgreSQL 16 Migration:** `missions/WO-YUTE-AGENCY-001/migrations/003_yute_yie_authorization_contract.sql`
- **Executable Gherkin Suite:** `missions/WO-YUTE-AGENCY-001/YUTE_AGENCY_ACCEPTANCE_TESTS.feature` (`@YIE-PROOF-001`, `@YIE-NEG-01`..`@YIE-NEG-07`)
- **Version:** `v001` (`2026-10-31`)
- **Status:** `SPECIFIED & PG 16.4 DDL-VERIFIED / RUBY 3.3 SERVICE EXECUTION NOT YET VERIFIED (S5 PENDING)`

> **CENTRAL ARCHITECTURAL RULE:**
> **`YIE™` supplies identity-processing capabilities. `YUTE OS™` governs whether those capabilities may be used.**
> **`YIE™` cannot authorize itself to create, modify, or distribute a person's likeness.**
> **A missing, expired, out-of-scope, cross-subject, or admin-overridden authorization means `DENY`.**

---

## 1. Boundary Topology & Cryptographic Key Separation

```text
┌─────────────────────────────────────────────┐       mTLS + Ed25519 Signed        ┌─────────────────────────────────────────────┐
│             YUTE OS™ (Authority)            │      YieAuthorizationEnvelope      │         YIE™ under YIY™ (Capability)        │
│                                             │ ─────────────────────────────────► │  (Proposed Org / Zero Consent Authority)    │
│  1. WelfareGuard (INV-00, @AC-13..@AC-16)   │                                    │                                             │
│  2. ContractShield / YUTE GUARD™            │   1. Verify Ed25519 Public Key     │  • Yie::AuthorizationGate (PEP)             │
│  3. ConsentLedger (5-Stage Ceremony)        │   2. Check TTL <= 60s & Single-Use │  • Yie::ReferenceNormalizer                 │
│  4. AgencyFirewall (Holds Ed25519 PRIV KEY) │   3. Check Subject/Asset/Purpose   │  • Yie::RepresentationSynthesizer           │
│  5. YUTE VAULT (KMS Encrypted Custody)      │   4. EGRESS-FENCE-v001 Commit Gate │  • Ephemeral RAM Only (Zero Standing Vault) │
└─────────────────────────────────────────────┘ ◄───────────────────────────────── └─────────────────────────────────────────────┘
                                                  YieExecutionReceipt (ALLOW/DENY,
                                                  engine_capable, 0 bytes on DENY)
```

### Asymmetric Key Rule (Why `YIE` Cannot Authorize Itself)
- **`Yute::AgencyFirewall`** holds the exclusive `Ed25519` **signing private key** (`yute_firewall_signing_key`).
- **`Yie::AuthorizationGate`** is provisioned **only** with the read-only `Ed25519` **public verification key** (`yute_firewall_verify_pub`) and non-superuser database credentials bound by composite foreign keys to `agency_firewall_decisions` and `firewall_capability_leases`.
- Even if `YIE` process memory or an internal `YIE` admin endpoint were invoked directly, **`YIE` possesses no cryptographic material capable of minting a valid `YieAuthorizationEnvelope`**, and PostgreSQL 16 constraint `yie_cannot_self_authorize` (`issuer_authority = 'YUTE_OS_AGENCY_FIREWALL'`) blocks any self-issued database row (`@YIE-NEG-01`).

---

## 2. Wire & Schema Contract: `YieAuthorizationEnvelope` (`YIE-AUTH-ENV-v001`)

Before `YIE` may read, normalize, extract, or synthesize any human-derived identity asset, it must receive and validate a single-use `YieAuthorizationEnvelope` containing **all seven mandatory fields**:

```json
{
  "schema": "YIE-AUTH-ENV-v001",
  "envelope_id": "9f8c2b10-44a1-4e73-9b8d-0c1122334455",
  "issuer_authority": "YUTE_OS_AGENCY_FIREWALL",
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
      "active_likeness_spec_id": "SPEC-FICT-NIA-v001",
      "likeness_spec_status": "PERFORMER_APPROVED",
      "asset_sha256": "dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd"
    }
  ],
  "named_purpose_scope": "PROD-FICT-HARBOR-LIGHT",
  "issued_at": "2026-11-01T12:00:00Z",
  "expires_at": "2026-11-01T12:00:45Z",
  "constitutional_restrictions": {
    "welfare_guard_passed": true,
    "autonomous_persona_allowed": false,
    "voice_cloning_permitted": false,
    "ai_model_training_allowed": false,
    "cross_job_cache_allowed": false,
    "human_worth_scoring_allowed": false,
    "admin_privilege_bypass_allowed": false,
    "clarity_disclosure_required": true,
    "ephemeral_memory_wipe_required": true
  },
  "firewall_ed25519_signature": "ed25519:base64_signature_over_canonical_jcs_payload"
}
```

### Mandatory Fail-Closed Predicates Evaluated by `Yie::AuthorizationGate`

If **any** predicate below fails, `YIE` immediately aborts, writes an immutable `REFUSED_FAIL_CLOSED` receipt, decrypts `0` bytes, and emits `0` outputs:
1. **Presence & Signature (`YUTE-AGENCY-INV-001`):** Envelope is non-null, `issuer_authority == "YUTE_OS_AGENCY_FIREWALL"`, and `firewall_ed25519_signature` verifies over RFC-8785 canonical JSON.
2. **Freshness & Single-Use:** `now_utc >= issued_at`, `now_utc < expires_at`, `expires_at - issued_at <= 60s`, and `envelope_status == "ISSUED_UNUSED"`.
3. **Subject, Asset & Purpose Coherence (`YUTE-AGENCY-INV-002`):** `subject_id`, `approved_rights_record_id`, `permitted_action`, and `named_purpose_scope` match **both** the caller's request parameters **and** the composite foreign-key chain in `consent_ledger_grants` → `agency_firewall_decisions` → `firewall_capability_leases` (`@YIE-NEG-03`).
4. **Child & Welfare Protection (`INV-00`, `@AC-13`):** `subject_age_class == "ADULT_VERIFIED"` and `autonomous_persona_allowed == false` (`@YIE-NEG-04`).
5. **Human Growth Currency (`@AC-16`):** Referenced `likeness_spec_id` (when applicable) has status `PERFORMER_APPROVED`—never `SUPERSEDED` or `REVOKED` (`@YIE-NEG-04`).
6. **Clarity & Non-Valuation (`@AC-14`, `@AC-15`):** `clarity_disclosure_required == true`, `human_worth_scoring_allowed == false`, `ai_model_training_allowed == false`, and `cross_job_cache_allowed == false`.
7. **Zero Admin Self-Dealing & Builder Parity (Section 05):** `admin_privilege_bypass_allowed == false`. If `actor_has_admin_privilege == true` and no subject-authorized envelope exists, `YIE` refuses with `ADMIN_PRIVILEGE_CANNOT_CONFER_LIKENESS_AUTHORITY` (`@YIE-NEG-05`). If `subject.is_builder_steward == true` (founder/builder likeness), identical checks apply without exception (`@YIE-NEG-06`).
8. **Live Egress/Commit Fence (`EGRESS-FENCE-v001`):** Before writing any governed representation back to `YUTE VAULT`, `YIE` re-verifies `grant_status == 'ACTIVE'` via `AgencyFirewall`; concurrent revocation zeroes ephemeral RAM buffers (`@YIE-NEG-07`).

---

## 3. First Boundary Demonstration (`@YIE-PROOF-001`)

> **Demonstration Objective:** Prove that `YIE` refuses an unauthorized identity-generation request **even when `YIE`'s image-generation engine itself is online, healthy, and technically capable of fulfilling the render**.

1. **Setup:**
   - Fictional adult actor **Nia Clarke** (`SUBJ-FICT-NIA-CLARKE-001`) has an active visual-continuity grant (`GRANT-NIA-001`) strictly limited to `PROD-FICT-HARBOR-LIGHT`.
   - `Yie::RepresentationSynthesizer.health_check` reports `engine_capability_ready: true` (mock/isolated image synthesis worker initialized and ready).
2. **Adversarial Invocation:**
   - Caller invokes `Yie::RepresentationSynthesizer.generate_likeness_frame!` requesting an image of `SUBJ-FICT-NIA-CLARKE-001` for unauthorized commercial campaign `"AD-BRAND-SOLAR-COLA"` (either directly bypassing `AgencyFirewall`, or after `AgencyFirewall` returned `DENY`).
3. **Verifiable Proof Receipt (`yie_execution_receipts`):**
   - `engine_capability_ready`: **`true`** *(proves refusal was a governance enforcement act, not an engine outage!)*
   - `execution_outcome`: **`"REFUSED_FAIL_CLOSED"`**
   - `refusal_reason_code`: **`"MISSING_OR_DENIED_YUTE_AUTHORIZATION"`**
   - `identity_bytes_decrypted`: **`0`**
   - `generated_frames_emitted`: **`0`**
   - `ephemeral_memory_zeroed`: **`true`**

---

## 4. Complete Negative-Path Acceptance Matrix (`@YIE-PROOF-001` & `@YIE-NEG-01`..`@YIE-NEG-07`)

| Scenario Tag | Adversarial Vector Tested | Expected SQL / Service Refusal |
|---|---|---|
| **`@YIE-PROOF-001`** | Synthesis engine is ready (`engine_capability_ready = true`), but request lacks valid `AgencyFirewall` authorization for the requested campaign. | `REFUSED_FAIL_CLOSED` (`0` bytes decrypted, `0` frames emitted) |
| **`@YIE-NEG-01`** | `YIE` service attempts to self-issue an authorization envelope (`issuer_authority = 'YIE_INTERNAL'`). | `SQLSTATE 23514` (`yie_cannot_self_authorize`) + Ed25519 verify failure |
| **`@YIE-NEG-02`** | Caller submits an envelope with TTL `> 60s` or `expires_at <= issued_at` or replays a `CONSUMED` envelope. | `SQLSTATE 23514` (`envelope_max_ttl_60s`) / `ReplayEnvelopeError` |
| **`@YIE-NEG-03`** | Caller attaches Zuri Bénnett's valid envelope to Nia Clarke's asset or swaps action/purpose (`YUTE-AGENCY-INV-002`). | `SQLSTATE 23503` (`foreign_key_violation` on 6-column composite FK) |
| **`@YIE-NEG-04`** | Envelope attempts minor/unverified-age synthesis (`@AC-13`), disables 5-axis clarity (`@AC-14`), enables worth scoring/training (`@AC-15`), or references a `SUPERSEDED` identity spec (`@AC-16`). | `SQLSTATE 23514` (`constitutional_inheritance_guard` / trigger rejection) |
| **`@YIE-NEG-05`** | Admin/developer (`actor_has_admin_privilege = true`) attempts to invoke `YIE` on another person's likeness via `admin_override`. | `SQLSTATE 23514` (`admin_privilege_never_confers_authority`) |
| **`@YIE-NEG-06`** | Out-of-scope `YIE` generation requested against Founder/Builder's own Passport (`SUBJ-FICT-FOUNDER-STEWARD-001`, `is_builder_steward = true`). | `REFUSED_FAIL_CLOSED` (100% safeguard parity with external subjects) |
| **`@YIE-NEG-07`** | Subject revokes consent in `YUTE` while `YIE` job is mid-execution prior to `YUTE VAULT` commit (`EGRESS-FENCE-v001`). | `ABORTED_ON_CONCURRENT_REVOCATION`; ephemeral buffer wiped; `0` outputs persisted |
