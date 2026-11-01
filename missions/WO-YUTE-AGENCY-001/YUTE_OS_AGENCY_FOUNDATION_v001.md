# YUTE™ OS — Consolidated Agency Foundation Specification (`YUTE-OS-AGENCY-FOUNDATION-v001`)

- **Document ID:** `YUTE_OS_AGENCY_FOUNDATION_v001`
- **Work Order:** `WO-YUTE-AGENCY-001` (*YUTE Contract Shield + Digital Rights Passport*)
- **Priority:** `P0` *(General YUTE OS Foundation — Independent of `WO-YUTE-LUTA-DARRON-001` / `HOLD-RIGHTS-001`)*
- **Constitutional Authority:** `concepts/YUTE-FOUNDATION-DOCTRINE-001.md` (`v002`)
- **Version:** `v001`
- **Creation Date:** `2026-10-31`
- **Target Runtime Repository:** `wrasalmedia-rgb/yute` *(Proposed — Ruby 3.3+ / PostgreSQL 16+; zero Python, Express, or Next.js)*
- **Current Classification:** `ARCHITECTURAL FOUNDATION ESTABLISHED IN SPECIFICATION. RUNTIME ASSURANCE NOT YET VERIFIED.`
- **Canonical Acceptance:** `pending`

> **CENTRAL OPERATIONAL PROMISE:**
> **YOUR IDENTITY IS YOURS TO REPRESENT.**
> **YOUR AGREEMENTS SHOULD BE YOURS TO UNDERSTAND.**
> **YOUR DIGITAL FUTURE SHOULD NOT BE DECIDED WITHOUT YOU.**
> **YUTE™ | Human Agency by Design.**

---

## 1. Strategic & Architectural Repositioning

### 1.1 Informed Consent & Agency Infrastructure as Product Zero
`WO-YUTE-LUTA-DARRON-001` explored digital-human reconstruction under strict hold gates. Mission Control review (`v002`) establishes a more fundamental architectural truth:

**YUTE's first commercial and civic responsibility is informed-consent, contract-comprehension, and digital-rights infrastructure—not avatar generation.**

Digital-human reconstruction (`Yute::ReconstructionAdapter`) becomes **one downstream client** of the **YUTE Agency Firewall** (`Yute::AgencyFirewall`), rather than defining separate, competing consent logic.

### 1.2 Standalone Value for People Who Never Create an Avatar

| User Persona | Real-World Vulnerability | How `YUTE-OS-AGENCY-FOUNDATION-v001` Serves Them (Zero Avatar Required) |
|---|---|---|
| **Musician / Recording Artist** | Label or distribution contract buries broad vocal-cloning, stem-training, or perpetual Master/Name-and-Likeness sublicensing clauses in boilerplate. | **Contract Shield** flags exact clauses with verbatim section/span citations; **Consent Ledger** records narrow approved studio uses; **Agency Firewall** blocks unconsented vocal-AI or ad requests (`YUTE-AGENCY-INV-001`). |
| **Young Performer & Family** | Modeling or talent release seeks perpetual, irrevocable digital-double or social-syndication rights over a minor before they can choose their own future. | **Contract Shield** highlights juvenile perpetuity/sublicensing risks; **WelfareGuard** blocks commercial synthetic likeness grants even with guardian consent; **Adulthood Transition** preserves reauthorization, processing restriction, and eligible deletion at majority. |
| **Photographer / Visual Creator** | Clients or platforms ingest copyrighted shoots into generative training sets or strip creator attribution beyond the licensed campaign scope. | **Digital Rights Passport** distinguishes `COPYRIGHT_OWNED` vs. `CAMPAIGN_LICENSED_OUT` vs. `AI_TRAINING_PROHIBITED`; **Evidence Vault** anchors SHA-256 master provenance and license terms. |
| **Everyday Individual** | Unclear which platforms, apps, or employers hold permissions over personal photos, voice recordings, or creative uploads. | **Digital Rights Passport** maintains an honest ledger distinguishing `KNOWN_GRANTED`, `REVOKED_NOTICE_SENT`, and `UNKNOWN` external platform permissions without fabricating certainty. |

---

## 2. The Four Executable Foundations & Five Core Components

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ 1. CONTRACT COMPREHENSION│───►│   2. INFORMED CONSENT    │───►│   3. RIGHTS GOVERNANCE   │───►│   4. AUTHORIZED ACTION   │
│   Yute::ContractShield   │    │   Yute::ConsentLedger    │    │Yute::DigitalRightsPassprt│    │   Yute::AgencyFirewall   │
└────────────┬─────────────┘    └────────────┬─────────────┘    └────────────┬─────────────┘    └────────────┬─────────────┘
             │                               │                               │                               │
             └───────────────────────────────┴───────────────┬───────────────┴───────────────────────────────┘
                                                             ▼
                                            ┌──────────────────────────────────┐
                                            │       Yute::EvidenceVault        │
                                            │ (Immutable Versions, SHA-256,    │
                                            │  Audit Chain & Propagation Logs) │
                                            └────────────────┬─────────────────┘
                                                             │
                         ┌───────────────────────────────────┼───────────────────────────────────┐
                         ▼                                   ▼                                   ▼
           [Non-Avatar Contract & Asset APIs]   [YUTE Digital Human Engine]        [External Licensee Webhooks / CRL]
                                                (Consumes AgencyFirewall —
                                                 Zero Private Consent Logic)
```

### Component 1: `Yute::ContractShield` (*Contract Comprehension*)
- **Responsibility:** Ingest agreement text/PDFs (`EvidenceVault` versioned), parse clause structure, and surface consequential terms affecting likeness, voice, AI/ML training, copyright assignment, moral rights, exclusivity, territory, duration, juvenile/guardian scope, compensation, and sublicensing.
- **Primary Acceptance Condition (Strict Anti-Hallucination Rule):** **Every finding must cite the exact `agreement_document_id`, `version_sha256`, `clause_identifier`, character byte/line span (`start_offset..end_offset`), and `verbatim_excerpt`.** Findings lacking a verified substring match against the stored agreement text are hard-rejected by `Yute::ContractShield::CitationVerifier`.
- **Risk & Clarity Boundary:** Outputs carry an explicit notice that `Contract Shield` provides structured contractual comprehension and risk highlighting—**not** legal representation—and flags ambiguous language as `REQUIRES_HUMAN_COUNSEL_REVIEW` rather than guessing legal enforceability.

### Component 2: `Yute::ConsentLedger` (*Informed Consent*)
- **Responsibility:** Translates reviewed, countersigned authorizations into structured, machine-evaluatable `PermissionGrant` and `ExplicitProhibition` records scoped by `subject_id`, `action_code`, `asset_scope`, `named_production_or_purpose`, `territory`, `valid_from..valid_until`, and `sublicensable: false`.
- **Primary Acceptance Condition:** **Every active grant links via `NOT NULL` foreign key to a verifiable authorization artifact in `EvidenceVault` (`signed_artifact_id` + `sha256`).** Unlinked or implied permissions cannot exist.

### Component 3: `Yute::DigitalRightsPassport` (*Rights Governance*)
- **Responsibility:** Subject-owned registry of personal identity references, creative works (photographs, audio masters, scripts, performances), outbound/inbound licenses, and known external platform data relationships.
- **Primary Acceptance Condition:** **Strictly distinguishes `OWNED_BY_SUBJECT`, `CO_OWNED`, `LICENSED_IN`, `LICENSED_OUT_SCOPED`, `RESTRICTED_HOLD`, and `UNKNOWN`.** Absence of evidence is always recorded as `UNKNOWN`, never silently upgraded to `CLEARED`.

### Component 4: `Yute::AgencyFirewall` (*Authorized Action — Unified PDP/PEP*)
- **Responsibility:** Single mandatory policy-decision and enforcement engine (`evaluate_and_lease!`) sitting in front of **all** operations touching protected identity records, creative assets, or synthetic representations.
- **Primary Acceptance Condition (`YUTE-AGENCY-INV-001`):** **Unauthorized, out-of-scope, expired, revoked, or welfare-violating operations fail closed before a single asset byte or identity embedding is decrypted or transmitted.** Returns structured `FirewallDenialReceipt` enumerating exact missing permissions and writes an immutable audit row to `EvidenceVault`.
- **Elimination of Competing Consent Engines:** `Yute::ConsentAuthority` and `Yute::LicenseManager` from the Darron pilot (`WO-YUTE-LUTA-DARRON-001`) are unified beneath `Yute::AgencyFirewall` + `Yute::ConsentLedger`, ensuring the Digital Human Engine and non-avatar workflows evaluate the **exact same authorization truth**.

### Component 5: `Yute::EvidenceVault` (*Provenance & Audit Integrity*)
- **Responsibility:** Append-only, hash-chained custody of agreement versions, clause-citation snapshots, signed consent instruments, firewall allow/deny receipts, and revocation-propagation status records.
- **Primary Acceptance Condition:** Significant records carry verified `SHA-256` digests, `NOT NULL` attribution metadata, and PostgreSQL immutability triggers blocking `UPDATE`/`DELETE`.

---

## 3. Forensic Engineering Remediations (Closing Findings A–E)

### 3.1 Remediation A — SQL Nullability Hardening, Multi-Boundary Enforcement & Honest Scope Limits
1. **Zero Nullable `CHECK` Loopholes:** In PostgreSQL, `CHECK (col = FALSE)` evaluates to `UNKNOWN` (and therefore **passes**!) if `col` is `NULL`. In `002_yute_agency_foundation.sql` (Section 4 below), **every single boolean, enum, and invariant column carrying a `CHECK` constraint is declared `NOT NULL`** (also remediating `likeness_specifications.body_measurement_source` to `TEXT NOT NULL DEFAULT 'UNMEASURED'`).
2. **Enforcement Across Every Execution Boundary (Not Just UI/HTTP):**
   - **HTTP / Roda API Boundary:** Middleware requires a scoped request context evaluated by `Yute::AgencyFirewall`.
   - **Vault Decryption Boundary (`Yute::SourceAssetVault#open_plaintext_stream`):** Cannot be called with a bare `source_id`; its Ruby method signature **requires an unforgeable, short-TTL (`<= 60s`), single-use `FirewallCapabilityLease` signed by `AgencyFirewall`** whose HMAC/Ed25519 payload binds `(lease_id, subject_id, asset_id, action_code, target_production_id, expires_at)`. Thus a rogue background job, CLI script, or admin console command bypassing HTTP **still fails closed at decryption and adapter egress**!
   - **Database Boundary:** PostgreSQL Row-Level Security (`RLS`) policies restrict table reads/writes by session role (`yute_api_role`, `yute_worker_role`, `yute_auditor_role`).
3. **Honest Technical Boundary Statement:** Prohibiting `autonomous_persona_allowed` and blocking unauthorized Vault egress prevents impersonation **from any system or asset under YUTE custody**. It cannot physically stop an external bad actor from misusing publicly scraped web images outside YUTE; for external environments, YUTE provides cryptographic `C2PA` positive provenance (proving whether an asset actually came from an authorized YUTE workflow) and `EvidenceVault` legal proof.

### 3.2 Remediation B — Three-Tier Adulthood Transition (`INNOCENCE` Refined)
Replaces an oversimplified "unconditional purge" promise with three legally accurate, enforceable states when a `MINOR_PROTECTED` subject reaches majority (or exercises mature minor rights where applicable):

| Mechanism | Operational Effect in YUTE OS | Lawful Exception Handling |
|---|---|---|
| **1. `ADULTHOOD_REAUTHORIZATION`** | Guardian-granted archival records transition automatically to `AWAITING_ADULT_REAUTHORIZATION` on the maturity date; guardian authority terminates prospectively. | Zero silent rollover of childhood permissions into adult commercial life. |
| **2. `PROCESSING_RESTRICTION`** | `processing_restricted = TRUE NOT NULL` immediately blocks all reads, exports, or downstream leases in `AgencyFirewall`. | Applies **100% unconditionally** to all operational/commercial processing—even if a record is subject to a legal hold! |
| **3. `ELIGIBLE_DATA_DELETION`** | Deletes/crypto-shreds all eligible personal media, vaults, and metadata upon request. | Checks `legal_retention_holds` (`STATUTORY_TAX_ACCOUNTING`, `ACTIVE_LITIGATION_HOLD`, `SECURITY_INCIDENT_EVIDENCE`, `MINIMAL_HASH_RECEIPT`). Any retained non-biometric record remains frozen under `PROCESSING_RESTRICTION` and produces a transparent `RetentionExceptionDisclosure` stating exact legal basis and expiry date. |

### 3.3 Remediation C — End-to-End Revocation Propagation Policy (`RPP-v001`)
A database `COMMIT` setting `consent_status = 'REVOKED'` is **Step 1 of 5**, never the end of revocation verification:

```text
[Revocation Triggered]
   ├──► Layer 1 (Sync ACID <50ms): ConsentLedger grant -> REVOKED; active CapabilityLeases invalidated
   ├──► Layer 2 (In-Flight Jobs): Cancellation signal sent + MANDATORY Pre-Commit Lease Re-Check kills output write
   ├──► Layer 3 (Caches & Keys): Ephemeral worker cache purge + Subject KMS DEK key-version rotation/disable
   ├──► Layer 4 (Internal Exports): Unreleased staging assets -> QUARANTINED; released masters -> CONTRACT_REVIEW
   └──► Layer 5 (Downstream Licensees): Signed revocation webhook + CRL status endpoint -> tracks ACK / ESCALATION
```

- **Crucial Guarantee Against Mid-Flight Races (Layer 2):** Even if an isolated rendering worker was 95% finished when revocation committed, `EvidenceVault` and staging storage require **a second synchronous `AgencyFirewall.verify_lease_still_active!(lease_id)` check at output-write time**. Revoked mid-flight outputs are discarded in memory and never persisted or exported.
- **Honest Downstream Tracking (Layer 5):** External third-party licensees are tracked in `revocation_propagation_targets` with explicit states (`DISPATCHED_WEBHOOK`, `ACKNOWLEDGED_HALTED`, `RETRYING_UNCONFIRMED`, `CONTRACTUAL_CURE_WINDOW`, `ESCALATED_NONCOMPLIANT`). YUTE never reports downstream revocation as `COMPLETE` until target acknowledgments or cure dispositions are evidenced.

### 3.4 Remediation D — Direct & Indirect Human Valuation Ban
`Yute::TelemetrySanitizer` enforces `NO_HUMAN_VALUATION_SCORING` across four surfaces beyond SQL columns:
1. **Database Schemas:** Zero columns for attractiveness, commercial worth, clout, or profitability scoring of persons.
2. **Structured Application Logs & Analytics:** Redacts/rejects prohibited ranking/scoring keys before log emission.
3. **Internal AI / Prompt / Classifier Outputs:** Prohibits running aesthetic-beauty scorers, "castability" rankers, or engagement-worth predictors on `HumanSubject` assets.
4. **External Integrations:** Outbound webhooks and API responses expose binary/scoped authorization states (`ALLOW` / `DENY`), never comparative human-value metrics.

### 3.5 Remediation E — Operationalizing Builder Protection & Escalation (*"Pastor pickney christen fuss"*)
1. **Enforceable RBAC Separation:**
   - `SUBJECT_OWNER` (the human represented—including founders/builders registered under `is_builder_steward = TRUE`)
   - `STEWARD_PRIMARY` & `STEWARD_CO_CUSTODIAN` (interchangeable operational stewards; rotation schedule prevents 24/7 single-person duty)
   - `LEGAL_COUNSEL_REVIEWER` (approves contract templates & statutory retention holds)
   - `SECURITY_AUDITOR` (read-only audit verification; zero Vault plaintext decrypt right)
2. **Two-Person Integrity & Escalation:** High-impact actions (releasing a legal hold, rotating root KMS policy, onboarding a production adapter) require **two distinct human stewards** (`approver_a != approver_b`), and unacknowledged high-priority revocations automatically escalate from `STEWARD_PRIMARY` to `STEWARD_CO_CUSTODIAN` after `15 minutes`.

---

## 4. Hardened PostgreSQL 16 Schema (`db/migrations/002_yute_agency_foundation.sql`)

All columns referenced in `CHECK` constraints carry explicit `NOT NULL` constraints (closing Forensic Finding A):

```sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 1. AGREEMENTS & CONTRACT SHIELD CLAUSE CITATIONS (ZERO UNCITED FINDINGS)
CREATE TABLE agreement_documents (
  agreement_id              TEXT PRIMARY KEY CHECK (agreement_id ~ '^AGR-[A-Z0-9-]+$'),
  subject_id                TEXT NOT NULL REFERENCES human_subjects(subject_id),
  counterparty_name         TEXT NOT NULL,
  document_title            TEXT NOT NULL,
  is_yute_platform_terms    BOOLEAN NOT NULL DEFAULT FALSE, -- Self-sovereignty audit flag
  raw_text_utf8             TEXT NOT NULL CHECK (length(raw_text_utf8) > 0),
  document_sha256           TEXT NOT NULL CHECK (document_sha256 ~ '^[0-9a-f]{64}$'),
  ingested_at               TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE contract_shield_findings (
  finding_id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  agreement_id              TEXT NOT NULL REFERENCES agreement_documents(agreement_id),
  agreement_sha256          TEXT NOT NULL CHECK (agreement_sha256 ~ '^[0-9a-f]{64}$'),
  clause_reference          TEXT NOT NULL CHECK (length(trim(clause_reference)) > 0),
  char_start_offset         INTEGER NOT NULL CHECK (char_start_offset >= 0),
  char_end_offset           INTEGER NOT NULL CHECK (char_end_offset > char_start_offset),
  verbatim_excerpt          TEXT NOT NULL CHECK (length(trim(verbatim_excerpt)) > 0),
  consequence_category      TEXT NOT NULL CHECK (consequence_category IN (
    'SYNTHETIC_LIKENESS_GRANT', 'VOICE_CLONING_GRANT', 'AI_TRAINING_CAPTURE',
    'PERPETUAL_DURATION', 'UNRESTRICTED_SUBLICENSING', 'MORAL_RIGHTS_WAIVER',
    'MINOR_FUTURE_ENCUMBRANCE', 'UNCOMPENSATED_DERIVATIVES', 'AMBIGUOUS_SCOPE_COUNSEL_NEEDED'
  )),
  plain_language_summary    TEXT NOT NULL CHECK (length(trim(plain_language_summary)) > 0),
  counsel_review_recommended BOOLEAN NOT NULL DEFAULT TRUE,
  created_at                TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. DIGITAL RIGHTS PASSPORT ASSET & PERMISSION REGISTRY (NON-AVATAR + AVATAR UNIFIED)
CREATE TABLE digital_rights_records (
  rights_record_id          TEXT PRIMARY KEY CHECK (rights_record_id ~ '^DRP-[A-Z0-9-]+$'),
  subject_id                TEXT NOT NULL REFERENCES human_subjects(subject_id),
  asset_or_data_category    TEXT NOT NULL CHECK (asset_or_data_category IN (
    'VISUAL_LIKENESS', 'VOICE_IDENTITY', 'PHOTOGRAPHIC_WORK',
    'MUSICAL_RECORDING', 'DRAMATIC_PERFORMANCE', 'PLATFORM_PERSONAL_DATA'
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

-- 3. CONSENT LEDGER SCOPED GRANTS (EVERY GRANT LINKED TO VERIFIED AUTHORIZATION)
CREATE TABLE consent_ledger_grants (
  grant_id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id                TEXT NOT NULL REFERENCES human_subjects(subject_id),
  agreement_id              TEXT NOT NULL REFERENCES agreement_documents(agreement_id),
  signed_artifact_sha256    TEXT NOT NULL CHECK (signed_artifact_sha256 ~ '^[0-9a-f]{64}$'),
  subject_age_class         TEXT NOT NULL CHECK (subject_age_class IN (
    'UNVERIFIED_AGE_HOLD', 'MINOR_PROTECTED', 'VULNERABLE_PROTECTED', 'ADULT_VERIFIED'
  )),
  permitted_action          TEXT NOT NULL CHECK (permitted_action IN (
    'CONTRACT_ANALYSIS_ONLY', 'VAULT_ARCHIVAL_CUSTODY',
    'VISUAL_LIKENESS_NAMED_PRODUCTION', 'PHOTO_CAMPAIGN_DISPLAY'
  )),
  named_production_scope    TEXT NOT NULL CHECK (length(trim(named_production_scope)) > 0),
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

-- 4. AGENCY FIREWALL EVALUATION LOG & SHORT-TTL CAPABILITY LEASES
CREATE TABLE agency_firewall_decisions (
  decision_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id                TEXT NOT NULL REFERENCES human_subjects(subject_id),
  requested_by_actor        TEXT NOT NULL,
  execution_boundary        TEXT NOT NULL CHECK (execution_boundary IN (
    'HTTP_API', 'BACKGROUND_WORKER', 'CLI_COMMAND', 'ADMIN_OPERATION', 'RENDER_ADAPTER'
  )),
  requested_action          TEXT NOT NULL,
  requested_production      TEXT NOT NULL,
  requires_voice_synthesis  BOOLEAN NOT NULL DEFAULT FALSE,
  requires_advertising_use  BOOLEAN NOT NULL DEFAULT FALSE,
  requires_sublicensing     BOOLEAN NOT NULL DEFAULT FALSE,
  matched_grant_id          UUID REFERENCES consent_ledger_grants(grant_id),
  outcome                   TEXT NOT NULL CHECK (outcome IN ('ALLOW', 'DENY')),
  denial_reason_code        TEXT,
  missing_permissions       JSONB NOT NULL DEFAULT '[]'::jsonb,
  identity_assets_transmitted BOOLEAN NOT NULL DEFAULT FALSE,
  decided_at                TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT deny_transmits_zero_assets CHECK (
    outcome = 'ALLOW' OR (
      identity_assets_transmitted = FALSE
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
  lease_state               TEXT NOT NULL DEFAULT 'ISSUED'
    CHECK (lease_state IN ('ISSUED', 'CONSUMED', 'INVALIDATED_ON_REVOCATION', 'EXPIRED')),
  expires_at                TIMESTAMPTZ NOT NULL,
  created_at                TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 5. THREE-TIER ADULTHOOD TRANSITION & LAWFUL RETENTION HOLDS (FINDING B)
CREATE TABLE legal_retention_holds (
  hold_id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id                TEXT NOT NULL REFERENCES human_subjects(subject_id),
  target_record_ref         TEXT NOT NULL,
  hold_category             TEXT NOT NULL CHECK (hold_category IN (
    'STATUTORY_TAX_ACCOUNTING', 'ACTIVE_LITIGATION_HOLD',
    'SECURITY_INCIDENT_INVESTIGATION', 'TAMPER_EVIDENT_AUDIT_HASH_ONLY'
  )),
  legal_citation_basis      TEXT NOT NULL,
  approved_by_counsel       TEXT NOT NULL,
  expires_or_reviews_at     TIMESTAMPTZ NOT NULL,
  active                    BOOLEAN NOT NULL DEFAULT TRUE
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

-- 6. END-TO-END REVOCATION PROPAGATION TRACKING BEYOND THE DATABASE (FINDING C)
CREATE TABLE revocation_propagation_targets (
  propagation_target_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  revocation_id             UUID NOT NULL REFERENCES revocation_events(revocation_id),
  target_layer              TEXT NOT NULL CHECK (target_layer IN (
    'IN_FLIGHT_WORKER_LEASE', 'EPHEMERAL_CACHE_PURGE',
    'KMS_SUBJECT_DEK_DISABLE', 'STAGING_EXPORT_QUARANTINE',
    'EXTERNAL_LICENSEE_WEBHOOK'
  )),
  target_identifier         TEXT NOT NULL,
  propagation_status        TEXT NOT NULL DEFAULT 'PENDING_DISPATCH' CHECK (propagation_status IN (
    'PENDING_DISPATCH', 'DISPATCHED_AWAITING_ACK',
    'CONFIRMED_HALTED', 'CONTRACTUAL_CURE_WINDOW', 'ESCALATED_NONCOMPLIANT'
  )),
  acknowledged_at           TIMESTAMPTZ,
  evidence_receipt_sha256   TEXT
);
```

---

## 5. Platform Self-Sovereignty Controls (`YUTE_SELF_GOVERNANCE`)

To enforce Section 06 of Mission Control's review (*"The protector must be subject to the same principles it claims to uphold"*):
1. **Mandatory Self-Dogfooding Gate:** YUTE's own user terms (`is_yute_platform_terms = TRUE` in `agreement_documents`) must run through `Yute::ContractShield` in CI. If `Contract Shield` detects any `AI_TRAINING_CAPTURE`, `UNRESTRICTED_SUBLICENSING`, `MORAL_RIGHTS_WAIVER`, or `PERPETUAL_DURATION` license-back in YUTE's own terms, CI **fails the release build** (`@SELF-GOV-01`).
2. **Tier-Proportional Data Minimization:** Using `Contract Shield` or `Digital Rights Passport` requires **zero** biometric photographs, voice samples, or government ID uploads.
3. **Complete Subject Portability (`Yute::EvidenceVault.export_subject_bundle`):** Any user can export a deterministic, SHA-256-signed archive of every contract finding, consent grant, firewall allow/deny log, and retention record YUTE holds for them.
