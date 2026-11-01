# YUTE™ OS — Consolidated Agency Foundation Specification (`YUTE-OS-AGENCY-FOUNDATION-v001`)

- **Document ID:** `YUTE_OS_AGENCY_FOUNDATION_v001`
- **Work Order:** `WO-YUTE-AGENCY-001` (*YUTE Guard™ / Contract Shield + Digital Rights Passport*)
- **Governance Disposition:** `decisions/YUTE-ADR-0010.md` (*Conditional Approval — Fictional-Data Engineering Only; Human Ratification Required*)
- **Priority:** `P0` *(Controlled Exception to Oct 20 Portfolio Freeze — Independent of `WO-YUTE-LUTA-DARRON-001` / `HOLD-RIGHTS-001`)*
- **Constitutional Authority:** `concepts/YUTE-FOUNDATION-DOCTRINE-001.md` (`v002`)
- **Spec Revision:** `v001.1` (`2026-10-31` — Incorporates `YUTE-ADR-0010`, `YUTE GUARD™` Product Zero UX, Signer-Attribution Ceremony `3.A`, & 4-Axis Revocation Accounting `3.B`)
- **Target Runtime Repository:** `wrasalmedia-rgb/yute` *(Private Isolated Dev Repo — Ruby 3.3+ / PostgreSQL 16+; zero Python, Express, or Next.js)*
- **Current Classification:** `ARCHITECTURAL FOUNDATION ESTABLISHED IN SPECIFICATION. RUNTIME ASSURANCE NOT YET VERIFIED.`
- **Canonical Acceptance:** `pending`

> **THE CONSTITUTION IS THE CONSTRAINT. THE HUMAN IS THE AUTHORITY.**
> **MY AGENCY IS NON-NEGOTIABLE.**
> **YUTE™ | Human Agency by Design.**

---

## 1. Product Zero Experience: `YUTE GUARD™` (*Know Before You Agree*)

### 1.1 Preventing Governance Bloat — Keep the Entry Experience Human & Simple
Constitutional infrastructure must never turn into an intimidating bureaucracy without a usable product. **Product Zero** is **`YUTE GUARD™`** (**`KNOW BEFORE YOU AGREE.`**):

1. **Open & Upload:** A person opens `YUTE GUARD™` and uploads an agreement (zero avatar creation, zero biometric photos, and zero complex ledger configuration required).
2. **Highlight Consequential Clauses:** `Yute::ContractShield` extracts and cites the exact clauses affecting voice, likeness, copyright, AI/ML training, exclusivity, duration, territory, or sublicensing.
3. **Plain-Language Meaning:** Explains what each flagged clause may authorize in clear, non-jargon language.
4. **Surface Uncertainties & Questions:** Explicitly flags ambiguous wording, missing protections, and concrete questions worth raising with the counterparty or legal counsel before signing.
5. **Human Authority Decides:** The person makes their own decision—decline, negotiate, or authorize.
6. **Preserve With Permission:** Only when the user explicitly opts in does YUTE record the verified authorization ceremony and artifacts into `Consent Ledger`, `Digital Rights Passport`, and `Evidence Vault` behind the scenes.

### 1.2 Standalone Value for People Who Never Create an Avatar

| User Persona | Real-World Vulnerability | How `YUTE GUARD™` + Agency Infrastructure Serves Them |
|---|---|---|
| **Young Recording Artist / Musician** | Single-track distribution or label deal hides synthetic vocal-generation, stem-training, or perpetual sublicensing clauses. | **`YUTE GUARD™`** flags exact clauses & missing vocal-AI exclusions; **`Consent Ledger`** records verified authorization for *one musical performance only*; **`Agency Firewall`** denies unauthorized synthetic-voice requests (`YUTE-OS-v003`). |
| **Young Performer & Family** | Modeling or talent release seeks perpetual digital-double or commercial syndication rights over a minor. | **`YUTE GUARD™`** highlights juvenile encumbrance risks; **`WelfareGuard`** blocks minor commercial/synthetic grants even with guardian signature; **`Adulthood Transition`** enforces reauthorization, processing restriction, and eligible deletion at majority. |
| **Photographer / Visual Creator** | Clients or platforms ingest copyrighted shoots into generative training sets beyond campaign license terms. | **`Digital Rights Passport`** distinguishes `OWNED_BY_SUBJECT` vs. `LICENSED_OUT_SCOPED` vs. `AI_TRAINING_PROHIBITED`; **`Evidence Vault`** anchors SHA-256 master provenance. |
| **Everyday Individual** | Unclear which platforms or counterparties hold permissions over personal media or creative uploads. | **`Digital Rights Passport`** maintains an honest inventory distinguishing verified permissions from `UNKNOWN` historical terms without fabricating certainty. |

---

## 2. The Four Executable Foundations & Five Core Components

```text
   [ USER EXPERIENCE: YUTE GUARD™ — "KNOW BEFORE YOU AGREE." ]
   Upload Agreement -> Cited Clause Risks & Questions -> Human Decision -> Preserve With Permission
             │
             ▼
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ 1. CONTRACT COMPREHENSION│───►│   2. INFORMED CONSENT    │───►│   3. RIGHTS GOVERNANCE   │───►│   4. AUTHORIZED ACTION   │
│   Yute::ContractShield   │    │   Yute::ConsentLedger    │    │Yute::DigitalRightsPassprt│    │   Yute::AgencyFirewall   │
└────────────┬─────────────┘    └────────────┬─────────────┘    └────────────┬─────────────┘    └────────────┬─────────────┘
             │                               │                               │                               │
             └───────────────────────────────┴───────────────┬───────────────┴───────────────────────────────┘
                                                             ▼
                                            ┌──────────────────────────────────┐
                                            │       Yute::EvidenceVault        │
                                            │ (Immutable Versions, Ceremonies, │
                                            │  4-Axis Revocation & Audit Logs) │
                                            └────────────────┬─────────────────┘
                                                             │
                         ┌───────────────────────────────────┼───────────────────────────────────┐
                         ▼                                   ▼                                   ▼
           [YUTE GUARD™ User Exports]         [YUTE Digital Human Engine]        [Downstream Notification / CRL]
                                              (Consumes AgencyFirewall —          (Never Reports External Deletion
                                               Zero Private Consent Logic)         Complete Without Confirmation)
```

1. **`Yute::ContractShield` (*Contract Comprehension — Powers `YUTE GUARD™`*):** Normalizes ingested text to canonical **`Unicode NFC` + `LF` (`\n`)** while preserving the original upload's raw bytes and SHA-256. Every finding must pass `Yute::ContractShield::CitationVerifier` against both UTF-8 byte offsets and Unicode codepoint spans (`TEST-03`), surface plain-language consequences + open questions, and carry a clear non-legal-advice disclosure.
2. **`Yute::ConsentLedger` (*Informed Consent — Verified Attribution & Ceremony*):** Records machine-evaluatable grants **only** when backed by verified signer attribution, `YUTE GUARD™` comprehension-ceremony evidence (`clauses_presented_at <= signed_at`), explicit contractual scope, and valid effective dates (Forensic Refinement `3.A`).
3. **`Yute::DigitalRightsPassport` (*Rights Governance*):** Strictly separates `OWNED_BY_SUBJECT`, `CO_OWNED`, `LICENSED_IN_SCOPED`, `LICENSED_OUT_SCOPED`, `RESTRICTED_HOLD`, and `UNKNOWN`.
4. **`Yute::AgencyFirewall` (*Authorized Action — Unified PDP/PEP*):** Single fail-closed enforcement point across API, CLI, background workers, admin tools, and rendering/synthesis adapters (`TEST-01`, `TEST-02`, `TEST-05`). Issues single-use, short-TTL (`<= 60s`) `FirewallCapabilityLease` tokens and re-verifies active authorization at the **final commit/egress boundary**.
5. **`Yute::EvidenceVault` (*Provenance & Audit Integrity*):** Append-only custody of canonical/raw agreements, authorization ceremonies, firewall allow/deny receipts, legal retention holds (`TEST-04`), and 4-axis revocation ledgers (Forensic Refinement `3.B`).

---

## 3. Forensic Engineering Remediations (Findings A–E + `YUTE-ADR-0010` Refinements `3.A` & `3.B`)

### 3.1 Remediation A — SQL Nullability, Multi-Boundary Leases & Off-Platform Honesty (`TEST-01`)
- **Zero Nullable `CHECK` Loopholes:** Every column participating in a PostgreSQL `CHECK` constraint in `001_yute_mvp_core.sql` and `002_yute_agency_foundation.sql` is explicitly `NOT NULL`.
- **Every Execution Boundary Enforced:** `Yute::SourceAssetVault#open_plaintext_stream` and all synthesis/render adapters require a cryptographically signed `FirewallCapabilityLease` verified against live `ConsentLedger` state—blocking direct background-worker, CLI, or admin bypasses.
- **Honest Authority Boundary:** YUTE enforces hard technical prevention over assets and adapters within its custody, while using `C2PA` provenance and `EvidenceVault` audit proofs to support legal enforcement externally.

### 3.2 Refinement `3.A` — An Agreement Hash Is Not Proof of Consent (`Yute::ConsentLedger`)
A `SHA-256` digest proves only that specific bytes existed—it does **not** prove who signed, whether they saw the consequential terms, or whether they had authority to grant the permission. `002_yute_agency_foundation.sql` therefore separates `agreement_documents` from `authorization_ceremonies` and `consent_ledger_grants`:
1. **Verified Signer Attribution:** Records `verified_signer_actor_id`, `signer_authority_basis` (`SELF_ADULT_SUBJECT` vs. `VERIFIED_FIDUCIARY_REPRESENTATIVE`), `signer_verification_method` (`PASSKEY_WEBAUTHN_ATTESTED`, `QUALIFIED_ESIGN_PROVIDER`, `COUNSEL_WITNESSED_ATTESTATION`), and enforces `signer_subject_match_verified = TRUE`.
2. **Evidence of the Authorization Process:** Requires a linked `authorization_ceremonies` record proving `YUTE GUARD™` presented the cited clause analysis (`analysis_snapshot_sha256`) **before** execution (`clauses_presented_at <= signed_at`) and that uncertainties/questions were surfaced (`uncertainties_presented = TRUE`).
3. **Explicit Contractual Scope & Applicable Dates:** Binds `permitted_action`, `named_target_scope` (e.g., one named track or production), `authorized_territory`, `valid_from`, `valid_until`, and explicit boolean prohibitions (`voice_cloning_permitted = FALSE`, `advertising_permitted = FALSE`, `sublicensing_permitted = FALSE`).

### 3.3 Refinement `3.B` & Remediation C — Revocation Races & Non-Universal Erasure (`TEST-02`)
1. **Concurrent Revocation Race Protection at Final Commit Boundary (`TEST-02`):** Issuing a capability lease at job start is insufficient if the subject revokes consent 200ms before the worker finishes. Both `AgencyFirewall.commit_authorized_action!` and `EvidenceVault` acquire a row-level lock (`SELECT grant_status FROM consent_ledger_grants WHERE grant_id = $1 FOR SHARE`) inside the final commit transaction: if the grant was revoked concurrently, the lease is marked `INVALIDATED_AT_COMMIT_BOUNDARY`, in-memory outputs are zeroed/discarded, and zero bytes are released.
2. **Four Separate Revocation Statuses (Never Falsely Claiming Universal Erasure):**
   Revoking YUTE access does **not** magically erase files already distributed to third parties or external backups. `revocation_status_ledgers` tracks four distinct axes:
   - **`authorization_termination_status`:** `TERMINATED_PROSPECTIVELY` (permission ended in `ConsentLedger`).
   - **`internal_processing_cessation_status`:** `HALTING_IN_PROGRESS` → `CONFIRMED_INTERNAL_HALTED` (all YUTE leases invalidated, concurrent workers killed at commit boundary, subject KMS DEK disabled).
   - **`downstream_notification_status`:** `NOT_APPLICABLE_NO_PRIOR_RELEASE` | `PENDING_DISPATCH` | `DISPATCHED_UNCONFIRMED` | `RECEIPT_ACKNOWLEDGED` | `UNACKNOWLEDGED_ESCALATED`.
   - **`confirmed_deletion_status`:** `INTERNAL_ELIGIBLE_DELETED_ONLY` | `INTERNAL_RETENTION_HOLD_DECLARED` | `EXTERNAL_DELETION_UNCONFIRMED` | `EXTERNAL_DELETION_CONFIRMED_WITH_RECEIPT`.
   - **Hard Rule:** PostgreSQL `CHECK` constraint `never_claim_unconfirmed_external_deletion` makes it structurally impossible to record `EXTERNAL_DELETION_CONFIRMED_WITH_RECEIPT` without both `downstream_notification_status = 'RECEIPT_ACKNOWLEDGED'` and a non-null `external_deletion_receipt_sha256`.

### 3.4 Remediation B — Three-Tier Adulthood Transition & Retention Integrity (`TEST-04`)
Separates **`ADULTHOOD_REAUTHORIZATION`**, unconditional **`PROCESSING_RESTRICTION`** (`processing_restricted = TRUE`), and **`ELIGIBLE_DATA_DELETION`** checked against `legal_retention_holds` (`STATUTORY_TAX_ACCOUNTING`, `ACTIVE_LITIGATION_HOLD`, `SECURITY_INCIDENT_INVESTIGATION`, `TAMPER_EVIDENT_AUDIT_HASH_ONLY`) with full user disclosure.

### 3.5 Remediations D, E & Self-Sovereignty
- **Indirect Valuation Ban:** `Yute::TelemetrySanitizer` blocks direct and proxy human-worth metrics across DBs, logs, prompts/models, and webhooks.
- **Co-Steward Integrity:** Two distinct human stewards (`STEWARD_PRIMARY != STEWARD_CO_CUSTODIAN`) required for sensitive hold changes; 15-minute escalation SLA; Founder Passport inclusion.
- **Platform Self-Sovereignty:** YUTE's own user terms (`is_yute_platform_terms = TRUE`) must pass `Contract Shield` with zero AI-training capture, unrestricted sublicensing, or perpetual license-backs (`@SELF-GOV-01`).

---

## 4. Hardened PostgreSQL 16 Schema (`db/migrations/002_yute_agency_foundation.sql`)

Every `CHECK`-constrained column is declared `NOT NULL`:

```sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 1. AGREEMENTS & UNICODE-CANONICALIZED CONTRACT SHIELD CITATIONS (TEST-03)
CREATE TABLE agreement_documents (
  agreement_id              TEXT PRIMARY KEY CHECK (agreement_id ~ '^AGR-[A-Z0-9-]+$'),
  subject_id                TEXT NOT NULL REFERENCES human_subjects(subject_id),
  counterparty_name         TEXT NOT NULL,
  document_title            TEXT NOT NULL,
  is_yute_platform_terms    BOOLEAN NOT NULL DEFAULT FALSE,
  original_upload_sha256    TEXT NOT NULL CHECK (original_upload_sha256 ~ '^[0-9a-f]{64}$'),
  canonical_normalization   TEXT NOT NULL DEFAULT 'UNICODE_NFC_LF'
    CHECK (canonical_normalization = 'UNICODE_NFC_LF'),
  canonical_text_utf8       TEXT NOT NULL CHECK (length(canonical_text_utf8) > 0),
  canonical_text_sha256     TEXT NOT NULL CHECK (canonical_text_sha256 ~ '^[0-9a-f]{64}$'),
  ingested_at               TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE contract_shield_findings (
  finding_id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  agreement_id              TEXT NOT NULL REFERENCES agreement_documents(agreement_id),
  canonical_text_sha256     TEXT NOT NULL CHECK (canonical_text_sha256 ~ '^[0-9a-f]{64}$'),
  clause_reference          TEXT NOT NULL CHECK (length(trim(clause_reference)) > 0),
  utf8_byte_start           INTEGER NOT NULL CHECK (utf8_byte_start >= 0),
  utf8_byte_end             INTEGER NOT NULL CHECK (utf8_byte_end > utf8_byte_start),
  codepoint_start           INTEGER NOT NULL CHECK (codepoint_start >= 0),
  codepoint_end             INTEGER NOT NULL CHECK (codepoint_end > codepoint_start),
  verbatim_excerpt_nfc      TEXT NOT NULL CHECK (length(trim(verbatim_excerpt_nfc)) > 0),
  consequence_category      TEXT NOT NULL CHECK (consequence_category IN (
    'PERFORMANCE_DISTRIBUTION_SCOPE', 'SYNTHETIC_LIKENESS_GRANT', 'VOICE_CLONING_GRANT',
    'AI_TRAINING_CAPTURE', 'PERPETUAL_DURATION', 'UNRESTRICTED_SUBLICENSING',
    'MORAL_RIGHTS_WAIVER', 'MINOR_FUTURE_ENCUMBRANCE', 'UNCOMPENSATED_DERIVATIVES',
    'OMITTED_SYNTHETIC_VOICE_EXCLUSION', 'AMBIGUOUS_SCOPE_COUNSEL_NEEDED'
  )),
  plain_language_explanation TEXT NOT NULL CHECK (length(trim(plain_language_explanation)) > 0),
  questions_worth_raising   JSONB NOT NULL DEFAULT '[]'::jsonb,
  counsel_review_recommended BOOLEAN NOT NULL DEFAULT TRUE,
  created_at                TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. VERIFIED SIGNER ATTRIBUTION & COMPREHENSION CEREMONY (REFINEMENT 3.A: HASH != CONSENT)
CREATE TABLE authorization_ceremonies (
  ceremony_id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id                    TEXT NOT NULL REFERENCES human_subjects(subject_id),
  agreement_id                  TEXT NOT NULL REFERENCES agreement_documents(agreement_id),
  canonical_text_sha256         TEXT NOT NULL CHECK (canonical_text_sha256 ~ '^[0-9a-f]{64}$'),
  guard_analysis_snapshot_sha256 TEXT NOT NULL CHECK (guard_analysis_snapshot_sha256 ~ '^[0-9a-f]{64}$'),
  verified_signer_actor_id      TEXT NOT NULL CHECK (length(trim(verified_signer_actor_id)) > 0),
  signer_authority_basis        TEXT NOT NULL CHECK (signer_authority_basis IN (
    'SELF_ADULT_SUBJECT', 'VERIFIED_FIDUCIARY_REPRESENTATIVE'
  )),
  signer_verification_method    TEXT NOT NULL CHECK (signer_verification_method IN (
    'PASSKEY_WEBAUTHN_ATTESTED', 'QUALIFIED_ESIGN_PROVIDER', 'COUNSEL_WITNESSED_ATTESTATION'
  )),
  signer_subject_match_verified BOOLEAN NOT NULL CHECK (signer_subject_match_verified = TRUE),
  uncertainties_presented       BOOLEAN NOT NULL CHECK (uncertainties_presented = TRUE),
  record_preservation_permitted BOOLEAN NOT NULL CHECK (record_preservation_permitted = TRUE),
  clauses_presented_at          TIMESTAMPTZ NOT NULL,
  signed_at                     TIMESTAMPTZ NOT NULL,
  ceremony_receipt_sha256       TEXT NOT NULL UNIQUE CHECK (ceremony_receipt_sha256 ~ '^[0-9a-f]{64}$'),
  CONSTRAINT comprehension_must_precede_signature CHECK (signed_at >= clauses_presented_at)
);

-- 3. DIGITAL RIGHTS PASSPORT ASSET & PERMISSION REGISTRY
CREATE TABLE digital_rights_records (
  rights_record_id          TEXT PRIMARY KEY CHECK (rights_record_id ~ '^DRP-[A-Z0-9-]+$'),
  subject_id                TEXT NOT NULL REFERENCES human_subjects(subject_id),
  asset_or_data_category    TEXT NOT NULL CHECK (asset_or_data_category IN (
    'VISUAL_LIKENESS', 'VOICE_IDENTITY', 'PHOTOGRAPHIC_WORK',
    'MUSICAL_PERFORMANCE_MASTER', 'DRAMATIC_PERFORMANCE', 'PLATFORM_PERSONAL_DATA'
  )),
  external_platform_or_holder TEXT NOT NULL,
  rights_posture            TEXT NOT NULL CHECK (rights_posture IN (
    'OWNED_BY_SUBJECT', 'CO_OWNED', 'LICENSED_IN_SCOPED',
    'LICENSED_OUT_SCOPED', 'RESTRICTED_HOLD', 'UNKNOWN'
  )),
  evidence_agreement_id     TEXT REFERENCES agreement_documents(agreement_id),
  evidence_status           TEXT NOT NULL DEFAULT 'CLAIMED_UNVERIFIED'
    CHECK (evidence_status IN ('VERIFIED_EVIDENCE', 'CLAIMED_UNVERIFIED', 'UNKNOWN')),
  processing_restricted     BOOLEAN NOT NULL DEFAULT FALSE,
  recorded_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT verified_posture_requires_agreement CHECK (
    evidence_status <> 'VERIFIED_EVIDENCE' OR evidence_agreement_id IS NOT NULL
  )
);

-- 4. CONSENT LEDGER SCOPED GRANTS (REQUIRES VERIFIED CEREMONY + SCOPE + DATES)
CREATE TABLE consent_ledger_grants (
  grant_id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id                TEXT NOT NULL REFERENCES human_subjects(subject_id),
  agreement_id              TEXT NOT NULL REFERENCES agreement_documents(agreement_id),
  ceremony_id               UUID NOT NULL REFERENCES authorization_ceremonies(ceremony_id),
  subject_age_class         TEXT NOT NULL CHECK (subject_age_class IN (
    'UNVERIFIED_AGE_HOLD', 'MINOR_PROTECTED', 'VULNERABLE_PROTECTED', 'ADULT_VERIFIED'
  )),
  permitted_action          TEXT NOT NULL CHECK (permitted_action IN (
    'CONTRACT_ANALYSIS_ONLY', 'VAULT_ARCHIVAL_CUSTODY',
    'PERFORMANCE_DISTRIBUTION_NAMED_TRACK',
    'VISUAL_LIKENESS_NAMED_PRODUCTION', 'PHOTO_CAMPAIGN_DISPLAY'
  )),
  named_target_scope        TEXT NOT NULL CHECK (length(trim(named_target_scope)) > 0),
  authorized_territory      TEXT NOT NULL CHECK (length(trim(authorized_territory)) > 0),
  contractual_scope_json    JSONB NOT NULL,
  voice_cloning_permitted   BOOLEAN NOT NULL DEFAULT FALSE,
  advertising_permitted     BOOLEAN NOT NULL DEFAULT FALSE,
  sublicensing_permitted    BOOLEAN NOT NULL DEFAULT FALSE,
  ai_model_training_allowed BOOLEAN NOT NULL DEFAULT FALSE,
  autonomous_persona_allowed BOOLEAN NOT NULL DEFAULT FALSE CHECK (autonomous_persona_allowed = FALSE),
  grant_status              TEXT NOT NULL DEFAULT 'ACTIVE' CHECK (grant_status IN (
    'ACTIVE', 'AWAITING_ADULT_REAUTHORIZATION', 'EXPIRED', 'REVOKED'
  )),
  valid_from                TIMESTAMPTZ NOT NULL,
  valid_until               TIMESTAMPTZ NOT NULL CHECK (valid_until > valid_from),
  created_at                TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT minor_cannot_grant_commercial_or_synthetic CHECK (
    subject_age_class = 'ADULT_VERIFIED' OR (
      permitted_action IN ('CONTRACT_ANALYSIS_ONLY', 'VAULT_ARCHIVAL_CUSTODY')
      AND voice_cloning_permitted = FALSE
      AND advertising_permitted = FALSE
      AND sublicensing_permitted = FALSE
      AND ai_model_training_allowed = FALSE
    )
  )
);

-- 5. AGENCY FIREWALL EVALUATION LOG & SHORT-TTL CAPABILITY LEASES (TEST-01, TEST-02, TEST-05)
CREATE TABLE agency_firewall_decisions (
  decision_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id                TEXT NOT NULL REFERENCES human_subjects(subject_id),
  requested_by_actor        TEXT NOT NULL,
  execution_boundary        TEXT NOT NULL CHECK (execution_boundary IN (
    'HTTP_API', 'BACKGROUND_WORKER', 'CLI_COMMAND', 'ADMIN_OPERATION', 'RENDER_ADAPTER'
  )),
  requested_action          TEXT NOT NULL,
  requested_target_scope    TEXT NOT NULL,
  requires_voice_synthesis  BOOLEAN NOT NULL DEFAULT FALSE,
  requires_advertising_use  BOOLEAN NOT NULL DEFAULT FALSE,
  requires_sublicensing     BOOLEAN NOT NULL DEFAULT FALSE,
  matched_grant_id          UUID REFERENCES consent_ledger_grants(grant_id),
  outcome                   TEXT NOT NULL CHECK (outcome IN ('ALLOW', 'DENY')),
  denial_reason_code        TEXT,
  missing_permissions       JSONB NOT NULL DEFAULT '[]'::jsonb,
  protected_assets_released BOOLEAN NOT NULL DEFAULT FALSE,
  audit_receipt_sha256      TEXT NOT NULL UNIQUE CHECK (audit_receipt_sha256 ~ '^[0-9a-f]{64}$'),
  decided_at                TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT deny_releases_zero_assets CHECK (
    outcome = 'ALLOW' OR (
      protected_assets_released = FALSE
      AND denial_reason_code IS NOT NULL
      AND jsonb_array_length(missing_permissions) > 0
    )
  )
);

CREATE TABLE firewall_capability_leases (
  lease_id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  decision_id               UUID NOT NULL REFERENCES agency_firewall_decisions(decision_id),
  grant_id                  UUID NOT NULL REFERENCES consent_ledger_grants(grant_id),
  lease_token_sha256        TEXT NOT NULL UNIQUE CHECK (lease_token_sha256 ~ '^[0-9a-f]{64}$'),
  lease_state               TEXT NOT NULL DEFAULT 'ISSUED' CHECK (lease_state IN (
    'ISSUED', 'COMMITTED', 'INVALIDATED_ON_REVOCATION',
    'INVALIDATED_AT_COMMIT_BOUNDARY', 'EXPIRED'
  )),
  expires_at                TIMESTAMPTZ NOT NULL,
  created_at                TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 6. THREE-TIER ADULTHOOD TRANSITION & LAWFUL RETENTION HOLDS (TEST-04)
CREATE TABLE legal_retention_holds (
  hold_id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id                TEXT NOT NULL REFERENCES human_subjects(subject_id),
  target_record_ref         TEXT NOT NULL,
  hold_category             TEXT NOT NULL CHECK (hold_category IN (
    'STATUTORY_TAX_ACCOUNTING', 'ACTIVE_LITIGATION_HOLD',
    'SECURITY_INCIDENT_INVESTIGATION', 'TAMPER_EVIDENT_AUDIT_HASH_ONLY'
  )),
  legal_citation_basis      TEXT NOT NULL,
  approved_by_steward_a     TEXT NOT NULL,
  approved_by_steward_b     TEXT NOT NULL,
  expires_or_reviews_at     TIMESTAMPTZ NOT NULL,
  active                    BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT two_steward_integrity_on_holds CHECK (approved_by_steward_a <> approved_by_steward_b)
);

CREATE TABLE adulthood_transitions (
  transition_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id                TEXT NOT NULL REFERENCES human_subjects(subject_id),
  reauthorization_state     TEXT NOT NULL DEFAULT 'PENDING_ADULT_DECISION'
    CHECK (reauthorization_state IN ('PENDING_ADULT_DECISION', 'REAUTHORIZED_SCOPED', 'DECLINED_TERMINATED')),
  processing_restricted     BOOLEAN NOT NULL DEFAULT TRUE,
  deletion_request_state    TEXT NOT NULL DEFAULT 'NOT_REQUESTED'
    CHECK (deletion_request_state IN (
      'NOT_REQUESTED', 'ELIGIBLE_DATA_DELETED',
      'PARTIAL_DELETED_WITH_DECLARED_LEGAL_HOLD'
    )),
  retention_disclosure_json JSONB NOT NULL DEFAULT '[]'::jsonb,
  transitioned_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 7. FOUR-AXIS REVOCATION ACCOUNTING (REFINEMENT 3.B: REVOCATION != UNIVERSAL ERASURE)
CREATE TABLE revocation_status_ledgers (
  revocation_ledger_id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  revocation_id                        UUID NOT NULL REFERENCES revocation_events(revocation_id),
  grant_id                             UUID NOT NULL REFERENCES consent_ledger_grants(grant_id),
  had_prior_external_distribution      BOOLEAN NOT NULL DEFAULT FALSE,
  -- Axis 1: Authorization Termination
  authorization_termination_status     TEXT NOT NULL DEFAULT 'TERMINATED_PROSPECTIVELY'
    CHECK (authorization_termination_status IN ('TERMINATED_PROSPECTIVELY', 'DISPUTED_UNDER_REVIEW')),
  -- Axis 2: Internal Processing Cessation (YUTE Custody)
  internal_processing_cessation_status TEXT NOT NULL DEFAULT 'HALTING_IN_PROGRESS'
    CHECK (internal_processing_cessation_status IN ('HALTING_IN_PROGRESS', 'CONFIRMED_INTERNAL_HALTED')),
  -- Axis 3: Downstream Notification (Third-Party Recipients)
  downstream_notification_status       TEXT NOT NULL DEFAULT 'PENDING_DISPATCH'
    CHECK (downstream_notification_status IN (
      'NOT_APPLICABLE_NO_PRIOR_RELEASE', 'PENDING_DISPATCH',
      'DISPATCHED_UNCONFIRMED', 'RECEIPT_ACKNOWLEDGED', 'UNACKNOWLEDGED_ESCALATED'
    )),
  -- Axis 4: Confirmed Deletion (Never Claim External Deletion Without Confirmation)
  confirmed_deletion_status            TEXT NOT NULL DEFAULT 'EXTERNAL_DELETION_UNCONFIRMED'
    CHECK (confirmed_deletion_status IN (
      'INTERNAL_ELIGIBLE_DELETED_ONLY', 'INTERNAL_RETENTION_HOLD_DECLARED',
      'EXTERNAL_DELETION_UNCONFIRMED', 'EXTERNAL_DELETION_CONFIRMED_WITH_RECEIPT'
    )),
  external_deletion_receipt_sha256     TEXT CHECK (
    external_deletion_receipt_sha256 IS NULL OR external_deletion_receipt_sha256 ~ '^[0-9a-f]{64}$'
  ),
  updated_at                           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT never_claim_unconfirmed_external_deletion CHECK (
    confirmed_deletion_status <> 'EXTERNAL_DELETION_CONFIRMED_WITH_RECEIPT'
    OR (
      downstream_notification_status = 'RECEIPT_ACKNOWLEDGED'
      AND external_deletion_receipt_sha256 IS NOT NULL
    )
  ),
  CONSTRAINT prior_external_distribution_forbids_na_notice CHECK (
    had_prior_external_distribution = FALSE
    OR downstream_notification_status <> 'NOT_APPLICABLE_NO_PRIOR_RELEASE'
  )
);
```
