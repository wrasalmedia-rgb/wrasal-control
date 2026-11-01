# YUTE™ OS Digital Human Preservation Platform — Ruby / PostgreSQL MVP Technical Architecture

- **Document ID:** `YUTE_MVP_ARCHITECTURE`
- **Phase 07 Deliverable Alias:** `YUTE_DIGITAL_HUMAN_MVP_ARCHITECTURE.md`
- **Version:** `v002` *(Updated to incorporate `YUTE-FOUNDATION-DOCTRINE-001` — Upstream `HUMAN WELFARE` Gate, Prime Directive `INV-00`, Five Protections, Child Protection, Light Principle, Non-Valuation, and Builder Protection Parity)*
- **Creation Date:** `2026-10-31` *(v001 baseline: `2026-10-31` / `2026-11-01Z`)*
- **Work Order:** `WO-YUTE-LUTA-DARRON-001`
- **Protocol:** `YUTE-DHPE-001`
- **Constitutional Doctrine:** `concepts/YUTE-FOUNDATION-DOCTRINE-001.md`
- **Target Repository:** `wrasalmedia-rgb/yute` *(Proposed — verified not yet provisioned)*
- **Control-Plane Coordination Repository:** `wrasalmedia-rgb/wrasal-control` (`main` @ `af529b54e14974eec42e1f4dd200f06c61175f15`)
- **Lifecycle Status:** `PROPOSED ARCHITECTURE — EXECUTION FROZEN PENDING AUTHORIZATION`

---

## 0. Constitutional Governing Law (`YUTE-FOUNDATION-DOCTRINE-001`)

> **YUTE PRIME DIRECTIVE (`INV-00`):**
> **NO HUMAN BEING SHALL BE REDUCED TO THE DIGITAL REPRESENTATION CREATED FROM THEM.**
>
> *LET THE CHILD LIVE. LET THE HUMAN BECOME. LET TECHNOLOGY SERVE THEM BOTH.*

In `v002`, YUTE OS places **`HUMAN WELFARE`** upstream of `IDENTITY` as Gate `00` of the system architecture:

```text
HUMAN WELFARE → IDENTITY → CONSENT → PROVENANCE → REPRESENTATION → VALIDATION → HUMAN APPROVAL → PRESERVATION
```

Every technical contract below is subordinate to the **Five Protections** (`INNOCENCE`, `IDENTITY`, `MEMORY`, `AUTONOMY`, `INHERITANCE`), the **Child Protection Principle**, the **Light Principle** (five-axis epistemic clarity), the **Non-Valuation Principle** (zero algorithmic scoring of human worth), and **Builder Protection Parity** (*"Pastor pickney christen fuss"*).

---

## 1. Verified WRASAL Baseline vs. Unimplemented Services

Per WRASAL governing rules (*No evidence → no authority; do not assume unimplemented services are operational*), this architecture starts from an audited inventory of `wrasalmedia-rgb`:

| Component / Repository | Verified Status | Evidence Source | Architectural Implication for YUTE MVP |
|---|---|---|---|
| `wrasalmedia-rgb/wrasal-control` | **OPERATIONAL (S2/S3 Control Plane)** | Merged `main` @ `af529b5`; `scripts/validate-control-plane.mjs` passes 567 checks | Provides canonical work-order status vocabulary (`execution_status`, `implementation_result`, `verification_result`, `canonical_acceptance: pending \| accepted`) and evidence-entry schema. |
| `projects.yml` (`yute` entry) | **RECORDED FACT ONLY** | `wrasal-control/projects.yml` (`state: active`, `organization: Wrasal Media`, `repo: yute`) | Declares `yute` in portfolio registry; contains **zero** runtime code. |
| `concepts/WRASAL-CAMPAIGN-EXEC-METHOD-001.md` | **MERGED CONCEPT RECORD** | `wrasal-control` PR #3 (`af529b5`) | Defines 9-stage governance discipline and human-approval boundaries. |
| `concepts/YUTE-FOUNDATION-DOCTRINE-001.md` | **PROPOSED DOCTRINE RECORD** | Working branch `arena/732271e1-wrasal-control` | Establishes `INV-00` Prime Directive, upstream `HUMAN WELFARE` gate, Five Protections, and Child Protection constraints. |
| Ruby S2 Work-Order Projector (`PR #4`) | **PROPOSED / UNMERGED** | Open PR #4 (`scripts/project_work_order.rb`) | Demonstrates idiomatic `# frozen_string_literal: true` pure-Ruby fail-closed validation style; **not** assumed operational on `main`. |
| `wrasalmedia-rgb/image-prompt-presets` | **SCAFFOLD README ONLY** | GitHub tree (`README.md`, `.gitignore` only) | Not yet implemented; YUTE must not depend on it as an operational gem. |
| `wrasalmedia-rgb/yute` | **NOT YET CREATED** | `gh api user/repos` audit | All YUTE OS modules below are **proposed greenfield Ruby/PostgreSQL modules** to be initialized only upon human authorization. |

---

## 2. Stack Constraints & System Topology

### 2.1 Mandatory Execution Stack Constraints
- **Application & Domain Orchestration:** **Ruby 3.3+** (`# frozen_string_literal: true`, `Zeitwerk` module loader, `Sequel` ORM/query builder with PostgreSQL native constraints, `Roda` JSON/HTML administrative control endpoints, `Data.define` immutable value objects, `RSpec` + `Cucumber` Ruby test runner for `.feature` acceptance specs).
- **Persistence & Audit Authority:** **PostgreSQL 16+** (`pgcrypto`, Row-Level Security `RLS`, append-only hash-chained ledger triggers, `TIMESTAMPTZ`, strict `FOREIGN KEY` and `CHECK` constraints).
- **Binary Object Custody:** Encrypted object store (`S3-compatible` private bucket with SSE-KMS + application-layer `AES-256-GCM` per-subject envelope encryption via Ruby `OpenSSL::Cipher`), never stored in Git or PostgreSQL `bytea`.
- **Explicit Architectural Exclusions:** **NO Python, NO Express.js, and NO Next.js** in YUTE's orchestration, API, database, or governance execution architecture.

### 2.2 Mapping the YUTE OS Systems to Logical Ruby Modules (`v002`)

| Core YUTE OS Layer | System Responsibility | Logical Ruby Modules | Doctrine Protection Anchors |
|---|---|---|---|
| **0. YUTE Welfare & Dignity Shield** *(Added in `v002`)* | Enforce Prime Directive `INV-00`, Child Protection, Non-Valuation, and Builder Parity before identity ingestion | `Yute::WelfareGuard` *(Upstream Gate 00)* | `INNOCENCE` · `AUTONOMY` · *Psalm 23 Non-Valuation* · *Pastor Pickney Parity* |
| **1. YUTE Identity Passport™** | Establish human identity records, contextual history/correction rights, and granular consent permissions | `Yute::IdentityRegistry`<br>`Yute::ConsentAuthority` | `IDENTITY` · `MEMORY` · `AUTONOMY` |
| **2. YUTE Reference Vault** | Preserve licensed source materials with encrypted custody, provenance, and memory-vs-reconstruction clarity | `Yute::SourceAssetVault` | `MEMORY` · *Light Principle* |
| **3. YUTE Identity Engine** | Define and evaluate consistent, non-drifting digital representations without beauty-bias erasure | `Yute::LikenessSpecification`<br>`Yute::ReconstructionAdapter`<br>`Yute::ValidationService` | `IDENTITY` · *Light Principle* |
| **4. YUTE Character Engine** | Connect authorized adult digital identities to fictional characters (`LUTA`) under strict scope locks | `Yute::LicenseManager` | `IDENTITY` · `AUTONOMY` |
| **5. YUTE Legacy Engine** | Govern human sign-off, immutable version history, contextual supersession, inheritance, and revocation | `Yute::ApprovalLedger`<br>`Yute::RevocationControl` | `AUTONOMY` · `MEMORY` · `INHERITANCE` |

---

## 3. Logical Modules: Responsibilities, Ruby Interfaces & Dependencies (`v002`)

```text
                        ┌────────────────────────────────────┐
                        │     00. Yute::WelfareGuard         │
                        │ (Prime Directive + Child Shield +  │
                        │  Zero Human-Worth Scoring + Parity)│
                        └─────────────────┬──────────────────┘
                                          ▼
                        ┌────────────────────────────────────┐
                        │     01. Yute::IdentityRegistry     │
                        │ (Human ≠ Likeness ≠ Character IP + │
                        │  Contextual Memory Correction)     │
                        └─────────────────┬──────────────────┘
                                          │
              ┌───────────────────────────┼───────────────────────────┐
              ▼                           ▼                           ▼
┌───────────────────────────┐   ┌────────────────────┐   ┌─────────────────────────┐
│02. Yute::ConsentAuthority │   │08. LicenseManager  │   │03. SourceAssetVault     │
│(Passport Grants & Scope)  │   │(LUTA Casting +     │   │(Dual-Cleared Encrypted +│
└─────────────┬─────────────┘   │ 5-Axis Clarity)    │   │ Memory vs Reconstructed)│
              │                 └─────────┬──────────┘   └────────────┬────────────┘
              └───────────────────────────┼───────────────────────────┘
                                          ▼
                        ┌────────────────────────────────────┐
                        │  04. Yute::LikenessSpecification   │
                        │  (Immutable Lock + FACS Map)       │
                        └─────────────────┬──────────────────┘
                                          ▼
                        ┌────────────────────────────────────┐
                        │  05. Yute::ReconstructionAdapter   │◄─── HARD KILL-SWITCH
                        │  (Fails Closed on Welfare & Consent│     ┌─────────────────────────┐
                        └─────────────────┬──────────────────┘     │09. RevocationControl    │
                                          ▼                        │(+ Majority Reclamation) │
                        ┌────────────────────────────────────┐     └────────────┬────────────┘
                        │    06. Yute::ValidationService     │                  │
                        │  (Tech Quality ≠ Human Approval)   │                  │
                        └─────────────────┬──────────────────┘                  │
                                          ▼                                     ▼
                        ┌─────────────────────────────────────────────────────────┐
                        │                07. Yute::ApprovalLedger                 │
                        │ (Append-Only Hash Chain + Delegable Shared Stewardship) │
                        └─────────────────────────────────────────────────────────┘
```

### Module Specifications

0. **`Yute::WelfareGuard` (`lib/yute/welfare_guard.rb` — Upstream Gate `00`, Added in `v002`)**
   - *Responsibility:* Enforces `YUTE-FOUNDATION-DOCTRINE-001` before any subject onboarding, Vault ingestion, or reconstruction call can proceed:
     1. **Child & Vulnerable Protection (`INNOCENCE`):** Checks `age_protection_class`. Raises `Yute::ChildProtectionViolationError` if any service requests synthetic likeness training/generation, commercial character casting, public exposure, or irrevocable guardian licensing for a `MINOR_PROTECTED` or `UNVERIFIED_AGE_HOLD` person—**even when a parent/guardian consent token is supplied**.
     2. **Anti-Valuation Guard (`NO_HUMAN_VALUATION_SCORING`):** Rejects any payload or metadata envelope containing banned valuation keys (`attractiveness_score`, `commercial_worth`, `influence_rank`, `marketability_tier`, `profitability_score`) with `Yute::HumanValuationProhibitedError`, and guarantees identical security/encryption/revocation SLAs across all subjects.
     3. **Autonomous-Avatar Prohibition (`INV-00`):** Blocks any unscripted, open-ended, or self-directing agentic persona execution purporting to act *as* the living human being.
     4. **Shared Stewardship Check (*"Pastor pickney christen fuss"*):** Ensures founder/builder subjects (`is_builder_steward = true`) receive full Identity Passport™ protections and verifies at least two authorized human-steward roles are configured in production so operational safety never rests on one solitary person's unshared burden.
   - *Key Ruby Interface:*
     `enforce_welfare_preconditions!(subject:, requested_operation:, metadata: {})` → returns frozen `WelfareClearanceReceipt` or raises fail-closed `Yute::WelfareViolationError`.

1. **`Yute::IdentityRegistry` (`lib/yute/identity_registry.rb`)**
   - *Responsibility:* Registers `HumanSubject`, `CharacterIdentity`, and `CostumeIdentity` in separate tables (`SUBJ-*`, `CHAR-*`, `COSTUME-*`), and manages **`MEMORY` Contextual Corrections** (`append_context_correction!`) so a person can annotate, correct, or supersede historical snapshots as they grow without falsifying audit trails.

2. **`Yute::ConsentAuthority` (`lib/yute/consent_authority.rb`)**
   - *Responsibility:* Manages `YUTE Identity Passport™` grants, enforces standalone informed consent, defaults `voice_synthesis_allowed = false`, blocks blanket/perpetual waivers, and triggers automatic `RATIFICATION_REQUIRED_AT_MAJORITY` holds when any non-commercial minor archival record reaches adulthood.

3. **`Yute::SourceAssetVault` (`lib/yute/source_asset_vault.rb`)**
   - *Responsibility:* Separates `METADATA_ONLY` discovery from `VAULT_ENCRYPTED` custody; enforces dual clearance (`Performer + Copyright Owner`), flags contamination (`has_cosubjects`, `has_watermark`, `has_editorial_makeup`, `has_personal_tattoos`), tags `epistemic_origin = 'ARCHIVAL_MEMORY'` vs. `'CALIBRATED_REFERENCE'`, encrypts with `AES-256-GCM`, and logs every access.

4. **`Yute::LikenessSpecification` (`lib/yute/likeness_specification.rb`)**
   - *Responsibility:* Compiles versioned `IdentityLockManifest` (`IDENTITY_LOCK` immutable anchors, `EXPRESSION_MAP` FACS descriptors, verified `BODY_LOCK` anthropometrics, and `mask_personal_tattoos` policy), prohibiting perspective-derived biometric guesses and beauty-bias homogenization.

5. **`Yute::ReconstructionAdapter` (`lib/yute/reconstruction_adapter.rb`)**
   - *Responsibility:* Pure-Ruby fail-closed gateway delegating all permission checks to **`Yute::AgencyFirewall#evaluate_and_lease!` (`WO-YUTE-AGENCY-001`)**—preventing competing consent engines—and requiring a short-TTL (`<=60s`) `FirewallCapabilityLease` both before dispatch and at pre-commit output persistence (`RPP-v001` mid-flight revocation safety).

6. **`Yute::ValidationService` (`lib/yute/validation_service.rb`)**
   - *Responsibility:* Evaluates candidate outputs across technical consistency, melanin/coil fidelity, `COSTUME-LUTA-CANON-v001` rules, and the **5 Light Principle Clarity Checks**. Can set `technical_status = 'VALIDATED'`, **never** `release_status = 'APPROVED'`.

7. **`Yute::ApprovalLedger` (`lib/yute/approval_ledger.rb`)**
   - *Responsibility:* Append-only, SHA-256 hash-chained ledger of human decisions (`PERFORMER`, `PHOTOGRAPHER`, `WRASAL_CREATIVE`, `WRASAL_LEGAL`, `DESIGNATED_CO_STEWARD`), supporting delegated backup stewards so human review remains sustainable.

8. **`Yute::LicenseManager` (`lib/yute/license_manager.rb`)**
   - *Responsibility:* Binds `HUMAN_IDENTITY`, `CHARACTER_IDENTITY` (`LUTA`), `COSTUME_IDENTITY`, and `PERFORMANCE_STATE`, and embeds a signed **5-Axis Light Principle Clarity Manifest** (`C2PA` + `YUTE JSON`) distinguishing real vs. synthetic, authorized vs. unlicensed, remembered vs. reconstructed, verified vs. claimed, and welfare-attested scope.

9. **`Yute::RevocationControl` (`lib/yute/revocation_control.rb`)**
   - *Responsibility:* Single-transaction prospective kill-switch (`REVOKED`), KMS crypto-shred or escrow disposition, downstream deliverable review trigger, and unconditional **Age-of-Majority Reclamation & Purge** execution (`INNOCENCE` + `AUTONOMY` + `INHERITANCE`).

---

## 4. Core PostgreSQL Data Schema (`db/migrations/001_yute_mvp_core.sql` — `v002`)

```sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 1. HUMAN SUBJECTS WITH UPSTREAM WELFARE, CHILD PROTECTION & BUILDER PARITY GATES
--    NOTE (INV-NO-VALUATION): Columns scoring human attractiveness, commercial worth,
--    influence, or profitability are CONSTITUTIONALLY PROHIBITED in this schema.
CREATE TABLE human_subjects (
  subject_id                TEXT PRIMARY KEY CHECK (subject_id ~ '^SUBJ-[A-Z0-9-]+$'),
  display_name              TEXT NOT NULL,
  primary_contact           TEXT,
  age_protection_class      TEXT NOT NULL DEFAULT 'UNVERIFIED_AGE_HOLD'
    CHECK (age_protection_class IN (
      'UNVERIFIED_AGE_HOLD',
      'MINOR_PROTECTED',
      'VULNERABLE_PROTECTED',
      'ADULT_VERIFIED'
    )),
  is_builder_steward        BOOLEAN NOT NULL DEFAULT FALSE, -- "Pastor pickney christen fuss" parity flag
  successor_fiduciary_ref   TEXT,                           -- INHERITANCE: designated estate/legacy steward
  verification_status       TEXT NOT NULL DEFAULT 'UNVERIFIED_DISCOVERY_ONLY'
    CHECK (verification_status IN (
      'UNVERIFIED_DISCOVERY_ONLY', 'DIRECT_CONTACT_CONFIRMED',
      'LEGAL_IDENTITY_ATTESTED', 'REVOKED'
    )),
  created_at                TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- MEMORY PROTECTION: Right of Contextual Correction, Growth & Supersession
CREATE TABLE subject_context_corrections (
  correction_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id                TEXT NOT NULL REFERENCES human_subjects(subject_id),
  target_record_type        TEXT NOT NULL,
  target_record_id          TEXT NOT NULL,
  correction_statement      TEXT NOT NULL,
  supersedes_version        TEXT,
  submitted_by              TEXT NOT NULL,
  recorded_at               TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE character_identities (
  character_id              TEXT PRIMARY KEY CHECK (character_id ~ '^CHAR-[A-Z0-9-]+$'),
  creative_property         TEXT NOT NULL,
  character_name            TEXT NOT NULL,
  canon_version             TEXT NOT NULL,
  ip_owner                  TEXT NOT NULL DEFAULT 'WRASAL Media',
  created_at                TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE costume_identities (
  costume_id                TEXT PRIMARY KEY CHECK (costume_id ~ '^COSTUME-[A-Z0-9-]+$'),
  character_id              TEXT NOT NULL REFERENCES character_identities(character_id),
  costume_version           TEXT NOT NULL,
  mandatory_elements        JSONB NOT NULL,
  prohibited_elements       JSONB NOT NULL,
  UNIQUE (costume_id, costume_version)
);

-- 2. YUTE IDENTITY PASSPORT™ (WITH MINORITY PROTECTION & MAJORITY RATIFICATION)
CREATE TABLE identity_passports (
  passport_id                       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id                        TEXT NOT NULL REFERENCES human_subjects(subject_id),
  subject_age_class_snapshot        TEXT NOT NULL
    CHECK (subject_age_class_snapshot IN ('UNVERIFIED_AGE_HOLD', 'MINOR_PROTECTED', 'VULNERABLE_PROTECTED', 'ADULT_VERIFIED')),
  consent_version                   TEXT NOT NULL,
  consent_status                    TEXT NOT NULL DEFAULT 'PENDING_INITIAL_OUTREACH'
    CHECK (consent_status IN (
      'PENDING_INITIAL_OUTREACH', 'UNDER_NEGOTIATION',
      'GRANTED_SCOPED', 'RATIFICATION_REQUIRED_AT_MAJORITY',
      'EXPIRED', 'REVOKED', 'DENIED'
    )),
  synthetic_likeness_allowed        BOOLEAN NOT NULL DEFAULT FALSE,
  commercial_exploitation_allowed   BOOLEAN NOT NULL DEFAULT FALSE,
  public_exposure_allowed           BOOLEAN NOT NULL DEFAULT FALSE,
  voice_synthesis_allowed           BOOLEAN NOT NULL DEFAULT FALSE,
  autonomous_persona_allowed        BOOLEAN NOT NULL DEFAULT FALSE CHECK (autonomous_persona_allowed = FALSE), -- INV-00 Prime Directive
  majority_ratification_required    BOOLEAN NOT NULL DEFAULT FALSE,
  authorized_uses                   JSONB NOT NULL DEFAULT '[]'::jsonb,
  prohibited_uses                   JSONB NOT NULL DEFAULT '[]'::jsonb,
  authorized_territories            JSONB NOT NULL DEFAULT '[]'::jsonb,
  valid_from                        TIMESTAMPTZ,
  valid_until                       TIMESTAMPTZ,
  compensation_terms_ref            TEXT,
  revocation_procedure              TEXT NOT NULL,
  human_approver_name               TEXT,
  signed_document_sha256            TEXT,
  revoked_at                        TIMESTAMPTZ,
  created_at                        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT active_requires_signature CHECK (
    consent_status <> 'GRANTED_SCOPED'
    OR (signed_document_sha256 IS NOT NULL AND human_approver_name IS NOT NULL AND valid_until IS NOT NULL)
  ),
  -- CHILD PROTECTION PRINCIPLE: Even guardian consent CANNOT authorize synthetic likeness,
  -- commercial exploitation, or public exposure for a minor or age-unverified subject.
  CONSTRAINT child_protection_hard_shield CHECK (
    subject_age_class_snapshot = 'ADULT_VERIFIED' OR (
      synthetic_likeness_allowed = FALSE
      AND commercial_exploitation_allowed = FALSE
      AND public_exposure_allowed = FALSE
      AND voice_synthesis_allowed = FALSE
      AND majority_ratification_required = TRUE
    )
  )
);

-- 3. SOURCE ASSET VAULT (PROVENANCE + MEMORY VS RECONSTRUCTION CLARITY)
CREATE TABLE source_assets (
  source_id                 TEXT PRIMARY KEY CHECK (source_id ~ '^(SRC|CAP)-[A-Z0-9-]+$'),
  subject_id                TEXT NOT NULL REFERENCES human_subjects(subject_id),
  source_url_or_origin      TEXT NOT NULL,
  asset_type                TEXT NOT NULL,
  epistemic_origin          TEXT NOT NULL DEFAULT 'ARCHIVAL_MEMORY'
    CHECK (epistemic_origin IN ('ARCHIVAL_MEMORY', 'CALIBRATED_STUDIO_CAPTURE')),
  creator_credit            TEXT NOT NULL,
  custody_state             TEXT NOT NULL DEFAULT 'METADATA_ONLY'
    CHECK (custody_state IN ('METADATA_ONLY', 'VAULT_ENCRYPTED', 'PURGED_ON_REVOCATION')),
  performer_passport_id     UUID REFERENCES identity_passports(passport_id),
  copyright_clearance_state TEXT NOT NULL DEFAULT 'UNLICENSED'
    CHECK (copyright_clearance_state IN ('UNLICENSED', 'FIRST_PARTY_OWNED', 'THIRD_PARTY_LICENSED', 'RESTRICTED_PROHIBITED')),
  copyright_license_sha256  TEXT,
  encrypted_object_uri      TEXT,
  kms_key_id                TEXT,
  plaintext_sha256          TEXT,
  has_cosubjects            BOOLEAN NOT NULL DEFAULT FALSE,
  has_watermark             BOOLEAN NOT NULL DEFAULT FALSE,
  has_editorial_makeup      BOOLEAN NOT NULL DEFAULT FALSE,
  has_personal_tattoos      BOOLEAN NOT NULL DEFAULT FALSE,
  eligible_for_identity_ext BOOLEAN NOT NULL DEFAULT FALSE,
  retention_expires_at      TIMESTAMPTZ,
  observed_on               DATE NOT NULL,
  CONSTRAINT vault_requires_dual_clearance CHECK (
    custody_state <> 'VAULT_ENCRYPTED' OR (
      performer_passport_id IS NOT NULL
      AND copyright_clearance_state IN ('FIRST_PARTY_OWNED', 'THIRD_PARTY_LICENSED')
      AND plaintext_sha256 IS NOT NULL
      AND retention_expires_at IS NOT NULL
    )
  ),
  CONSTRAINT extraction_blocks_contaminated_assets CHECK (
    eligible_for_identity_ext = FALSE OR (
      custody_state = 'VAULT_ENCRYPTED'
      AND has_cosubjects = FALSE
      AND has_watermark = FALSE
    )
  )
);

CREATE TABLE vault_access_audit_logs (
  audit_id        BIGSERIAL PRIMARY KEY,
  source_id       TEXT NOT NULL REFERENCES source_assets(source_id),
  actor_identity  TEXT NOT NULL,
  action          TEXT NOT NULL CHECK (action IN ('CATALOG', 'INGEST', 'DECRYPT_READ', 'VALIDATE_HASH', 'PURGE')),
  purpose_token   TEXT NOT NULL,
  occurred_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 4. LIKENESS SPECIFICATION (IMMUTABLE LOCK VS EDITABLE MAPS; SUPERSEDABLE FOR GROWTH)
CREATE TABLE likeness_specifications (
  likeness_spec_id          TEXT PRIMARY KEY,
  subject_id                TEXT NOT NULL REFERENCES human_subjects(subject_id),
  passport_id               UUID NOT NULL REFERENCES identity_passports(passport_id),
  spec_version              TEXT NOT NULL,
  supersedes_spec_id        TEXT REFERENCES likeness_specifications(likeness_spec_id),
  identity_lock_payload     JSONB NOT NULL,
  expression_map_payload    JSONB NOT NULL,
  body_lock_payload         JSONB,
  body_measurement_source   TEXT NOT NULL DEFAULT 'UNMEASURED'
    CHECK (body_measurement_source IN ('UNMEASURED', 'VERIFIED_DIRECT_CAPTURE')),
  manifest_sha256           TEXT NOT NULL,
  status                    TEXT NOT NULL DEFAULT 'PROPOSED'
    CHECK (status IN ('PROPOSED', 'VALIDATED', 'PERFORMER_APPROVED', 'SUPERSEDED', 'REVOKED')),
  created_at                TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 5. CHARACTER CASTING BINDINGS & 5-AXIS LIGHT PRINCIPLE CLARITY MANIFESTS
CREATE TABLE character_casting_bindings (
  binding_id                TEXT PRIMARY KEY,
  subject_id                TEXT NOT NULL REFERENCES human_subjects(subject_id),
  likeness_spec_id          TEXT NOT NULL REFERENCES likeness_specifications(likeness_spec_id),
  passport_id               UUID NOT NULL REFERENCES identity_passports(passport_id),
  character_id              TEXT NOT NULL REFERENCES character_identities(character_id),
  costume_id                TEXT NOT NULL REFERENCES costume_identities(costume_id),
  performance_state_version TEXT NOT NULL,
  character_state           TEXT NOT NULL CHECK (character_state IN ('STATE_A_HUMAN', 'STATE_B_UNDERTAKER', 'STATE_C_REVEALED_KING')),
  mask_personal_tattoos     BOOLEAN NOT NULL DEFAULT TRUE,
  license_status            TEXT NOT NULL DEFAULT 'PROPOSED'
    CHECK (license_status IN ('PROPOSED', 'ACTIVE', 'SUSPENDED_REVOKED', 'EXPIRED')),
  created_at                TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- THE LIGHT PRINCIPLE: Explicit 5-Axis Clarity Record Required on Every Candidate/Export
CREATE TABLE clarity_disclosure_manifests (
  disclosure_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  binding_id                TEXT NOT NULL REFERENCES character_casting_bindings(binding_id),
  asset_sha256              TEXT NOT NULL UNIQUE,
  reality_axis              TEXT NOT NULL CHECK (reality_axis IN ('REAL_CAPTURE', 'SYNTHETIC_RECONSTRUCTION')),
  authority_axis            TEXT NOT NULL CHECK (authority_axis IN ('AUTHORIZED_DUAL_CLEARED', 'UNVERIFIED_QUARANTINED')),
  memory_axis               TEXT NOT NULL CHECK (memory_axis IN ('ARCHIVAL_MEMORY', 'RECONSTRUCTED_REPRESENTATION')),
  verification_axis         TEXT NOT NULL CHECK (verification_axis IN ('VERIFIED_EVIDENCE', 'CLAIMED_UNVERIFIED')),
  welfare_axis              TEXT NOT NULL CHECK (welfare_axis IN ('PASSED_WELFARE_GUARD')),
  not_real_human_act_notice TEXT NOT NULL, -- INV-00: Explicitly states synthetic render != actual human act
  c2pa_manifest_sha256      TEXT,
  created_at                TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 6. VALIDATION RUNS, APPEND-ONLY HUMAN APPROVAL LEDGER & REVOCATION EVENTS
CREATE TABLE validation_runs (
  validation_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  binding_id                TEXT NOT NULL REFERENCES character_casting_bindings(binding_id),
  candidate_output_sha256   TEXT NOT NULL,
  welfare_guard_result      TEXT NOT NULL CHECK (welfare_guard_result IN ('PASS', 'FAIL')),
  technical_quality_result  TEXT NOT NULL CHECK (technical_quality_result IN ('PASS', 'FAIL')),
  costume_authority_result  TEXT NOT NULL CHECK (costume_authority_result IN ('PASS', 'FAIL')),
  clarity_disclosure_id     UUID NOT NULL REFERENCES clarity_disclosure_manifests(disclosure_id),
  evaluated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE approval_ledger_entries (
  entry_seq                 BIGSERIAL PRIMARY KEY,
  subject_id                TEXT NOT NULL REFERENCES human_subjects(subject_id),
  target_entity_type        TEXT NOT NULL,
  target_entity_id          TEXT NOT NULL,
  target_sha256             TEXT NOT NULL,
  approver_role             TEXT NOT NULL
    CHECK (approver_role IN ('PERFORMER', 'PHOTOGRAPHER', 'WRASAL_CREATIVE', 'WRASAL_LEGAL', 'DESIGNATED_CO_STEWARD')),
  approver_identity         TEXT NOT NULL,
  decision                  TEXT NOT NULL CHECK (decision IN ('APPROVED', 'REVISION_REQUESTED', 'REJECTED', 'REVOKED')),
  signature_digest          TEXT NOT NULL,
  prev_entry_hash           TEXT NOT NULL,
  entry_hash                TEXT NOT NULL UNIQUE,
  recorded_at               TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE revocation_events (
  revocation_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  passport_id               UUID NOT NULL REFERENCES identity_passports(passport_id),
  initiated_by              TEXT NOT NULL,
  revocation_basis          TEXT NOT NULL
    CHECK (revocation_basis IN ('SUBJECT_WITHDRAWAL', 'ADULTHOOD_REAUTHORIZATION_DECLINED', 'WELFARE_BREACH_HALT', 'ESTATE_FIDUCIARY_DIRECTIVE')),
  reason                    TEXT NOT NULL,
  new_generation_blocked_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  vault_disposition         TEXT NOT NULL CHECK (vault_disposition IN ('ELIGIBLE_DATA_CRYPTO_SHRED', 'LEGAL_RETENTION_HOLD_RESTRICTED')),
  existing_uses_review_state TEXT NOT NULL DEFAULT 'PROPAGATION_IN_PROGRESS'
    CHECK (existing_uses_review_state IN ('PROPAGATION_IN_PROGRESS', 'REVIEW_REQUIRED', 'UNDER_LEGAL_REVIEW', 'RESOLVED'))
); -- Linked to revocation_propagation_targets & adulthood_transitions in 002_yute_agency_foundation.sql (WO-YUTE-AGENCY-001)
```

---

## 5. Security, Dignity Parity, Retention & Shared-Stewardship Controls

1. **Universal Dignity Parity (`NO_HUMAN_VALUATION_SCORING`):** Every human subject receives identical `AES-256-GCM` per-subject DEK/KEK KMS envelope encryption, identical audit immutability, and identical `<1` transaction revocation latency regardless of commercial profile.
2. **Child Protection Hard Shield (`child_protection_hard_shield`):** Database-level `CHECK` constraint makes it structurally impossible to insert an `identity_passports` row permitting synthetic likeness generation, commercial exploitation, voice synthesis, or public exposure unless `subject_age_class_snapshot = 'ADULT_VERIFIED'`.
3. **Builder Inclusion & Shared Stewardship (*"Pastor pickney christen fuss"*):**
   - Founders and builders (`is_builder_steward = TRUE`) can register their own identities under `YUTE Identity Passport™` protection with zero self-exclusion.
   - `approval_ledger_entries` includes `DESIGNATED_CO_STEWARD` and `REVISION_REQUESTED` states so workflows allow graceful iteration, human mistakes without catastrophic lockouts, and shared custodial responsibility.
4. **Tamper-Evident Audit Chain + Right of Growth:** `vault_access_audit_logs` and `approval_ledger_entries` prohibit `UPDATE`/`DELETE`, while `subject_context_corrections` and `likeness_specifications.supersedes_spec_id` ensure preservation never freezes a living human in the past.

---

## 6. Implementation Priorities & Unresolved Engineering Decisions (`v002`)

### 6.1 Implementation Priority Tiers
- **Priority P0 (`YUTE-PILOT-001A` — Welfare & Governance Spine, Synthetic Fixtures Only):** `Yute::WelfareGuard` (Gate 00), `IdentityRegistry` (incl. `subject_context_corrections`), `ConsentAuthority` (incl. `child_protection_hard_shield`), `SourceAssetVault`, `ApprovalLedger`, `RevocationControl`, and Cucumber `@AC-00`..`@AC-04`, `@AC-09`..`@AC-16` test harness in `wrasalmedia-rgb/yute`.
- **Priority P1 (`YUTE-PILOT-001B` — Post-Consent Onboarding + Founder Passport Parity):** KMS/S3 encrypted binary vault storage, Founder/Builder Passport registration option, `LikenessSpecification` manifest signer (`Ed25519`), `LicenseManager` + `clarity_disclosure_manifests` (`C2PA`).
- **Priority P2 (`YUTE-PILOT-002` — Post-Capture Reconstruction):** `ValidationService` automated image checks and `ReconstructionAdapter` bridge to isolated still-image worker.

### 6.2 Unresolved Engineering Decisions (`UED` Register)

| ID | Unresolved Engineering Decision | Options Under Consideration | Owner | Blocking Milestone |
|---|---|---|---|---|
| **UED-001** | Ruby repository bootstrap & web/CLI boundary in `wrasalmedia-rgb/yute` | (A) Lightweight `Sequel` + `Roda` + `Thor` CLI service; (B) Rails 8 `--api` | WRASAL Lead Architect | `YUTE-PILOT-001A` |
| **UED-002** | PostgreSQL hosting topology (`PG 16+` with `pgcrypto` + RLS) | Dedicated WRASAL PostgreSQL instance vs. managed PG with KMS integration | Infrastructure Lead | `YUTE-PILOT-001A` |
| **UED-003** | Cryptographic human signature & age-attestation workflow | Counsel-attested adult signatory verification + qualified e-signature SHA-256 anchored in `ApprovalLedger` (zero raw gov-ID retention in DB) | Legal Counsel × Product Lead | `HOLD-RIGHTS-001` |
| **UED-004** | KMS & encrypted object-storage provider for Vault binaries | AWS S3 + AWS KMS vs. Cloudflare R2 + Vault Transit Engine | Security Lead | `YUTE-PILOT-001B` |
| **UED-005** | Isolated Track A 2D reconstruction engine selection | Self-hosted isolated weights on ephemeral dedicated GPU vs. enterprise zero-retention API | Cinematic Tech Lead | `YUTE-PILOT-002` |
| **UED-006** | C2PA Content Credentials signing certificate for Light Principle manifests | Obtain WRASAL Media organizational X.509 C2PA signing certificate | Security / Legal Lead | `YUTE-PILOT-002` |
| **UED-007** | Revocation wind-down window on locked linear cuts of *THE UNDERTAKERS* | Immediate halt on new renders + negotiated wind-down vs. master cut escrow provisions | WRASAL Legal × Performer Counsel | `HOLD-RIGHTS-001` |
| **UED-008** | Ruby runtime provisioning in CI / verification sandboxes | Pin Ruby `3.3.x` via `.ruby-version` + GitHub Actions `ruby/setup-ruby` | DevEx Lead | `YUTE-PILOT-001A` |
| **UED-009** | Multi-custodian co-steward rotation policy (*"Pastor pickney christen fuss"*) | Designate primary + backup WRASAL governance stewards so no single founder bears 24/7 unshared review duty | WRASAL Operations & Founder | `YUTE-PILOT-001A` |
