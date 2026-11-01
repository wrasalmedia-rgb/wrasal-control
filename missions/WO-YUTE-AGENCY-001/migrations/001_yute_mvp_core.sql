-- =============================================================================
-- Migration: 001_yute_mvp_core.sql
-- Program:   WRASAL(TM) | YUTE OS
-- Work Order: WO-YUTE-AGENCY-001 / WO-YUTE-LUTA-DARRON-001 (HOLD-RIGHTS-001)
-- Target DB: PostgreSQL 16+
-- Purpose:   Core human subject registry, child-protection shield, append-only
--            immutability triggers, and composite subject-integrity keys
--            enforcing YUTE-AGENCY-INV-002 across core tables.
-- =============================================================================

BEGIN;

-- Note: PostgreSQL 16 provides pg_catalog.gen_random_uuid() and pg_catalog.sha256()
-- natively in core without requiring superuser extension installation.

-- Immutability trigger function blocking UPDATE and DELETE on append-only audit tables
CREATE OR REPLACE FUNCTION yute_prevent_audit_mutation()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  RAISE EXCEPTION 'YUTE_IMMUTABLE_LEDGER_VIOLATION: % on % is prohibited', TG_OP, TG_TABLE_NAME
    USING ERRCODE = 'P0001';
END;
$$;

-- 1. HUMAN SUBJECTS, CHARACTERS & COSTUMES (STRICT SEPARATION + COMPOSITE KEYS)
CREATE TABLE human_subjects (
  subject_id                TEXT PRIMARY KEY CHECK (subject_id ~ '^SUBJ-[A-Z0-9-]+$'),
  legal_or_stage_name       TEXT NOT NULL CHECK (length(trim(legal_or_stage_name)) > 0),
  jurisdiction_country      TEXT NOT NULL CHECK (length(trim(jurisdiction_country)) > 0),
  age_protection_class      TEXT NOT NULL DEFAULT 'UNVERIFIED_AGE_HOLD'
    CHECK (age_protection_class IN (
      'UNVERIFIED_AGE_HOLD',
      'MINOR_PROTECTED',
      'VULNERABLE_PROTECTED',
      'ADULT_VERIFIED'
    )),
  is_builder_steward        BOOLEAN NOT NULL DEFAULT FALSE,
  dignity_protection_tier   TEXT NOT NULL DEFAULT 'UNIVERSAL_MAXIMUM'
    CHECK (dignity_protection_tier = 'UNIVERSAL_MAXIMUM'),
  status                    TEXT NOT NULL DEFAULT 'DISCOVERY_HOLD'
    CHECK (status IN (
      'DISCOVERY_HOLD',
      'CONSENTED_ACTIVE',
      'MINOR_ARCHIVAL_CUSTODY_ONLY',
      'REVOKED_HALTED',
      'DECEASED_ESTATE_STEWARDSHIP'
    )),
  created_at                TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE subject_context_corrections (
  correction_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id                TEXT NOT NULL REFERENCES human_subjects(subject_id),
  target_record_type        TEXT NOT NULL CHECK (length(trim(target_record_type)) > 0),
  target_record_id          TEXT NOT NULL CHECK (length(trim(target_record_id)) > 0),
  correction_statement      TEXT NOT NULL CHECK (length(trim(correction_statement)) > 0),
  supersedes_version        TEXT,
  submitted_by              TEXT NOT NULL CHECK (length(trim(submitted_by)) > 0),
  recorded_at               TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE character_identities (
  character_id              TEXT PRIMARY KEY CHECK (character_id ~ '^CHAR-[A-Z0-9-]+$'),
  creative_property         TEXT NOT NULL CHECK (length(trim(creative_property)) > 0),
  character_name            TEXT NOT NULL CHECK (length(trim(character_name)) > 0),
  canon_version             TEXT NOT NULL CHECK (length(trim(canon_version)) > 0),
  ip_owner                  TEXT NOT NULL DEFAULT 'WRASAL Media' CHECK (length(trim(ip_owner)) > 0),
  created_at                TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE costume_identities (
  costume_id                TEXT PRIMARY KEY CHECK (costume_id ~ '^COSTUME-[A-Z0-9-]+$'),
  character_id              TEXT NOT NULL REFERENCES character_identities(character_id),
  costume_version           TEXT NOT NULL CHECK (length(trim(costume_version)) > 0),
  mandatory_elements        JSONB NOT NULL,
  prohibited_elements       JSONB NOT NULL,
  UNIQUE (costume_id, character_id),
  UNIQUE (costume_id, costume_version)
);

-- 2. IDENTITY PASSPORTS (WITH COMPOSITE SUBJECT KEY FOR YUTE-AGENCY-INV-002)
CREATE TABLE identity_passports (
  passport_id                       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id                        TEXT NOT NULL REFERENCES human_subjects(subject_id),
  subject_age_class_snapshot        TEXT NOT NULL
    CHECK (subject_age_class_snapshot IN ('UNVERIFIED_AGE_HOLD', 'MINOR_PROTECTED', 'VULNERABLE_PROTECTED', 'ADULT_VERIFIED')),
  consent_version                   TEXT NOT NULL CHECK (length(trim(consent_version)) > 0),
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
  autonomous_persona_allowed        BOOLEAN NOT NULL DEFAULT FALSE CHECK (autonomous_persona_allowed = FALSE),
  majority_ratification_required    BOOLEAN NOT NULL DEFAULT FALSE,
  authorized_uses                   JSONB NOT NULL DEFAULT '[]'::jsonb,
  prohibited_uses                   JSONB NOT NULL DEFAULT '[]'::jsonb,
  authorized_territories            JSONB NOT NULL DEFAULT '[]'::jsonb,
  valid_from                        TIMESTAMPTZ,
  valid_until                       TIMESTAMPTZ,
  compensation_terms_ref            TEXT,
  revocation_procedure              TEXT NOT NULL CHECK (length(trim(revocation_procedure)) > 0),
  human_approver_name               TEXT,
  signed_document_sha256            TEXT,
  revoked_at                        TIMESTAMPTZ,
  created_at                        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (passport_id, subject_id),
  CONSTRAINT active_requires_signature CHECK (
    consent_status <> 'GRANTED_SCOPED'
    OR (signed_document_sha256 IS NOT NULL AND human_approver_name IS NOT NULL AND valid_until IS NOT NULL)
  ),
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

-- 3. SOURCE ASSET VAULT & IMMUTABLE ACCESS LOGS
CREATE TABLE source_assets (
  source_id                 TEXT PRIMARY KEY CHECK (source_id ~ '^(SRC|CAP)-[A-Z0-9-]+$'),
  subject_id                TEXT NOT NULL REFERENCES human_subjects(subject_id),
  source_url_or_origin      TEXT NOT NULL CHECK (length(trim(source_url_or_origin)) > 0),
  asset_type                TEXT NOT NULL CHECK (length(trim(asset_type)) > 0),
  epistemic_origin          TEXT NOT NULL DEFAULT 'ARCHIVAL_MEMORY'
    CHECK (epistemic_origin IN ('ARCHIVAL_MEMORY', 'CALIBRATED_STUDIO_CAPTURE')),
  creator_credit            TEXT NOT NULL CHECK (length(trim(creator_credit)) > 0),
  copyright_holder          TEXT NOT NULL CHECK (length(trim(copyright_holder)) > 0),
  rights_status             TEXT NOT NULL DEFAULT 'UNVERIFIED_PUBLIC_PORTFOLIO'
    CHECK (rights_status IN (
      'UNVERIFIED_PUBLIC_PORTFOLIO', 'THIRD_PARTY_COPYRIGHT_UNLICENSED',
      'RESTRICTED_PRIVATE', 'DUAL_CLEARED_FIRST_PARTY', 'DUAL_CLEARED_LICENSED'
    )),
  likeness_consent_cleared  BOOLEAN NOT NULL DEFAULT FALSE,
  copyright_license_cleared BOOLEAN NOT NULL DEFAULT FALSE,
  dataset_eligible          BOOLEAN NOT NULL DEFAULT FALSE,
  contamination_flags       JSONB NOT NULL DEFAULT '[]'::jsonb,
  encrypted_object_uri      TEXT,
  plaintext_sha256          TEXT,
  UNIQUE (source_id, subject_id),
  CONSTRAINT dataset_requires_dual_clearance CHECK (
    dataset_eligible = FALSE
    OR (
      likeness_consent_cleared = TRUE
      AND copyright_license_cleared = TRUE
      AND encrypted_object_uri IS NOT NULL
      AND plaintext_sha256 IS NOT NULL
    )
  )
);

CREATE TABLE vault_access_audit_logs (
  audit_id        BIGSERIAL PRIMARY KEY,
  source_id       TEXT NOT NULL,
  subject_id      TEXT NOT NULL,
  actor_identity  TEXT NOT NULL CHECK (length(trim(actor_identity)) > 0),
  action          TEXT NOT NULL CHECK (action IN ('CATALOG', 'INGEST', 'DECRYPT_READ', 'VALIDATE_HASH', 'PURGE')),
  purpose_token   TEXT NOT NULL CHECK (length(trim(purpose_token)) > 0),
  occurred_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  FOREIGN KEY (source_id, subject_id) REFERENCES source_assets(source_id, subject_id)
);

CREATE TRIGGER trg_immutable_vault_access_audit_logs
BEFORE UPDATE OR DELETE ON vault_access_audit_logs
FOR EACH ROW EXECUTE FUNCTION yute_prevent_audit_mutation();

-- 4. LIKENESS SPECIFICATIONS & CHARACTER BINDINGS (COMPOSITE SUBJECT/PASSPORT INTEGRITY)
CREATE TABLE likeness_specifications (
  likeness_spec_id          TEXT PRIMARY KEY,
  subject_id                TEXT NOT NULL,
  passport_id               UUID NOT NULL,
  spec_version              TEXT NOT NULL CHECK (length(trim(spec_version)) > 0),
  supersedes_spec_id        TEXT REFERENCES likeness_specifications(likeness_spec_id),
  identity_lock_payload     JSONB NOT NULL,
  expression_map_payload    JSONB NOT NULL,
  body_lock_payload         JSONB,
  body_measurement_source   TEXT NOT NULL DEFAULT 'UNMEASURED'
    CHECK (body_measurement_source IN ('UNMEASURED', 'VERIFIED_DIRECT_CAPTURE')),
  manifest_sha256           TEXT NOT NULL CHECK (manifest_sha256 ~ '^[0-9a-f]{64}$'),
  status                    TEXT NOT NULL DEFAULT 'PROPOSED'
    CHECK (status IN ('PROPOSED', 'VALIDATED', 'PERFORMER_APPROVED', 'SUPERSEDED', 'REVOKED')),
  created_at                TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (likeness_spec_id, subject_id, passport_id),
  FOREIGN KEY (passport_id, subject_id) REFERENCES identity_passports(passport_id, subject_id)
);

CREATE TABLE character_casting_bindings (
  binding_id                TEXT PRIMARY KEY,
  subject_id                TEXT NOT NULL,
  likeness_spec_id          TEXT NOT NULL,
  passport_id               UUID NOT NULL,
  character_id              TEXT NOT NULL REFERENCES character_identities(character_id),
  costume_id                TEXT NOT NULL,
  performance_state_version TEXT NOT NULL CHECK (length(trim(performance_state_version)) > 0),
  character_state           TEXT NOT NULL CHECK (character_state IN ('STATE_A_HUMAN', 'STATE_B_UNDERTAKER', 'STATE_C_REVEALED_KING')),
  mask_personal_tattoos     BOOLEAN NOT NULL DEFAULT TRUE,
  license_status            TEXT NOT NULL DEFAULT 'PROPOSED'
    CHECK (license_status IN ('PROPOSED', 'ACTIVE', 'SUSPENDED_REVOKED', 'EXPIRED')),
  created_at                TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  FOREIGN KEY (likeness_spec_id, subject_id, passport_id)
    REFERENCES likeness_specifications(likeness_spec_id, subject_id, passport_id),
  FOREIGN KEY (costume_id, character_id)
    REFERENCES costume_identities(costume_id, character_id)
);

CREATE TABLE clarity_disclosure_manifests (
  disclosure_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  binding_id                TEXT NOT NULL REFERENCES character_casting_bindings(binding_id),
  asset_sha256              TEXT NOT NULL UNIQUE CHECK (asset_sha256 ~ '^[0-9a-f]{64}$'),
  reality_axis              TEXT NOT NULL CHECK (reality_axis IN ('REAL_CAPTURE', 'SYNTHETIC_RECONSTRUCTION')),
  authority_axis            TEXT NOT NULL CHECK (authority_axis IN ('AUTHORIZED_DUAL_CLEARED', 'UNVERIFIED_QUARANTINED')),
  memory_axis               TEXT NOT NULL CHECK (memory_axis IN ('ARCHIVAL_MEMORY', 'RECONSTRUCTED_REPRESENTATION')),
  verification_axis         TEXT NOT NULL CHECK (verification_axis IN ('VERIFIED_EVIDENCE', 'CLAIMED_UNVERIFIED')),
  welfare_axis              TEXT NOT NULL CHECK (welfare_axis IN ('PASSED_WELFARE_GUARD')),
  not_real_human_act_notice TEXT NOT NULL CHECK (length(trim(not_real_human_act_notice)) > 0),
  c2pa_manifest_sha256      TEXT,
  created_at                TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE validation_runs (
  validation_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  binding_id                TEXT NOT NULL REFERENCES character_casting_bindings(binding_id),
  candidate_output_sha256   TEXT NOT NULL CHECK (candidate_output_sha256 ~ '^[0-9a-f]{64}$'),
  welfare_guard_result      TEXT NOT NULL CHECK (welfare_guard_result IN ('PASS', 'FAIL')),
  technical_quality_result  TEXT NOT NULL CHECK (technical_quality_result IN ('PASS', 'FAIL')),
  costume_authority_result  TEXT NOT NULL CHECK (costume_authority_result IN ('PASS', 'FAIL')),
  clarity_disclosure_id     UUID NOT NULL REFERENCES clarity_disclosure_manifests(disclosure_id),
  evaluated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE approval_ledger_entries (
  entry_seq                 BIGSERIAL PRIMARY KEY,
  subject_id                TEXT NOT NULL REFERENCES human_subjects(subject_id),
  target_entity_type        TEXT NOT NULL CHECK (length(trim(target_entity_type)) > 0),
  target_entity_id          TEXT NOT NULL CHECK (length(trim(target_entity_id)) > 0),
  target_sha256             TEXT NOT NULL CHECK (target_sha256 ~ '^[0-9a-f]{64}$'),
  approver_role             TEXT NOT NULL
    CHECK (approver_role IN ('PERFORMER', 'PHOTOGRAPHER', 'WRASAL_CREATIVE', 'WRASAL_LEGAL', 'DESIGNATED_CO_STEWARD')),
  approver_identity         TEXT NOT NULL CHECK (length(trim(approver_identity)) > 0),
  decision                  TEXT NOT NULL CHECK (decision IN ('APPROVED', 'REVISION_REQUESTED', 'REJECTED', 'REVOKED')),
  signature_digest          TEXT NOT NULL CHECK (length(trim(signature_digest)) > 0),
  prev_entry_hash           TEXT NOT NULL CHECK (length(trim(prev_entry_hash)) > 0),
  entry_hash                TEXT NOT NULL UNIQUE CHECK (entry_hash ~ '^[0-9a-f]{64}$'),
  recorded_at               TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trg_immutable_approval_ledger_entries
BEFORE UPDATE OR DELETE ON approval_ledger_entries
FOR EACH ROW EXECUTE FUNCTION yute_prevent_audit_mutation();

CREATE TABLE revocation_events (
  revocation_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id                TEXT NOT NULL REFERENCES human_subjects(subject_id),
  passport_id               UUID,
  initiated_by              TEXT NOT NULL CHECK (length(trim(initiated_by)) > 0),
  revocation_basis          TEXT NOT NULL
    CHECK (revocation_basis IN ('SUBJECT_WITHDRAWAL', 'ADULTHOOD_REAUTHORIZATION_DECLINED', 'WELFARE_BREACH_HALT', 'ESTATE_FIDUCIARY_DIRECTIVE')),
  reason                    TEXT NOT NULL CHECK (length(trim(reason)) > 0),
  new_generation_blocked_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  vault_disposition         TEXT NOT NULL CHECK (vault_disposition IN ('ELIGIBLE_DATA_CRYPTO_SHRED', 'LEGAL_RETENTION_HOLD_RESTRICTED')),
  existing_uses_review_state TEXT NOT NULL DEFAULT 'PROPAGATION_IN_PROGRESS'
    CHECK (existing_uses_review_state IN ('PROPAGATION_IN_PROGRESS', 'REVIEW_REQUIRED', 'UNDER_LEGAL_REVIEW', 'RESOLVED')),
  UNIQUE (revocation_id, subject_id),
  FOREIGN KEY (passport_id, subject_id) REFERENCES identity_passports(passport_id, subject_id)
);

COMMIT;
