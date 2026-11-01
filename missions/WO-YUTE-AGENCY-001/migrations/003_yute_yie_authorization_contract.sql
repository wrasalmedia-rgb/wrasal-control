-- =============================================================================
-- Migration: 003_yute_yie_authorization_contract.sql
-- Program:   WRASAL(TM) | YUTE OS x YIE(TM) (under YIY(TM) Proposed Ecosystem)
-- Milestone: YUTE x YIE | IDENTITY AUTHORIZATION CONTRACT v001
-- Authority: decisions/YUTE-ADR-0011.md (YUTE-ARCH-GOV-002)
-- Target DB: PostgreSQL 16+
-- Purpose:   Enforces the non-delegable authority boundary between YUTE OS
--            (human agency & authorization) and YIE (identity-processing
--            capabilities). YIE cannot authorize itself, inherit cross-subject
--            permissions (YUTE-AGENCY-INV-002), bypass child/clarity/worth/
--            growth rules (@AC-13..@AC-16), or accept admin privilege overrides.
-- =============================================================================

BEGIN;

-- Add composite uniqueness on firewall_capability_leases so YIE envelopes bind 7-way
ALTER TABLE firewall_capability_leases
  ADD CONSTRAINT uq_lease_full_authority_chain
  UNIQUE (lease_id, decision_id, grant_id, subject_id, target_rights_record_id, permitted_action, named_target_scope);

-- 1. YUTE -> YIE OPERATION-SPECIFIC AUTHORIZATION ENVELOPES (YIE-AUTH-ENV-v001)
CREATE TABLE yie_authorization_envelopes (
  envelope_id                     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  issuer_authority                TEXT NOT NULL DEFAULT 'YUTE_OS_AGENCY_FIREWALL'
    CHECK (issuer_authority = 'YUTE_OS_AGENCY_FIREWALL'),
  lease_id                        UUID NOT NULL,
  decision_id                     UUID NOT NULL,
  grant_id                        UUID NOT NULL,
  subject_id                      TEXT NOT NULL,
  subject_age_class               TEXT NOT NULL CHECK (subject_age_class = 'ADULT_VERIFIED'),
  is_builder_steward_subject      BOOLEAN NOT NULL DEFAULT FALSE,
  approved_rights_record_id       TEXT NOT NULL,
  active_likeness_spec_id         TEXT,
  permitted_yute_action           TEXT NOT NULL CHECK (length(trim(permitted_yute_action)) > 0),
  requested_yie_operation         TEXT NOT NULL CHECK (requested_yie_operation IN (
    'YIE_NORMALIZE_REFERENCE',
    'YIE_EXTRACT_IDENTITY_LOCK',
    'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION',
    'YIE_PACKAGE_CLARITY_PROVENANCE'
  )),
  named_purpose_scope             TEXT NOT NULL CHECK (length(trim(named_purpose_scope)) > 0),
  -- Constitutional Inheritance Hard Guards (INV-00, @AC-13, @AC-14, @AC-15, Section 05):
  welfare_guard_passed            BOOLEAN NOT NULL DEFAULT TRUE CHECK (welfare_guard_passed = TRUE),
  autonomous_persona_allowed      BOOLEAN NOT NULL DEFAULT FALSE CHECK (autonomous_persona_allowed = FALSE),
  ai_model_training_allowed       BOOLEAN NOT NULL DEFAULT FALSE CHECK (ai_model_training_allowed = FALSE),
  cross_job_cache_allowed         BOOLEAN NOT NULL DEFAULT FALSE CHECK (cross_job_cache_allowed = FALSE),
  human_worth_scoring_allowed     BOOLEAN NOT NULL DEFAULT FALSE CHECK (human_worth_scoring_allowed = FALSE),
  admin_privilege_bypass_allowed  BOOLEAN NOT NULL DEFAULT FALSE CHECK (admin_privilege_bypass_allowed = FALSE),
  clarity_disclosure_required     BOOLEAN NOT NULL DEFAULT TRUE CHECK (clarity_disclosure_required = TRUE),
  ephemeral_memory_wipe_required  BOOLEAN NOT NULL DEFAULT TRUE CHECK (ephemeral_memory_wipe_required = TRUE),
  firewall_ed25519_signature      TEXT NOT NULL CHECK (length(trim(firewall_ed25519_signature)) > 0),
  envelope_status                 TEXT NOT NULL DEFAULT 'ISSUED_UNUSED' CHECK (envelope_status IN (
    'ISSUED_UNUSED', 'CONSUMED_SINGLE_USE', 'EXPIRED', 'REVOKED_ABORTED'
  )),
  issued_at                       TIMESTAMPTZ NOT NULL,
  expires_at                      TIMESTAMPTZ NOT NULL,
  UNIQUE (envelope_id, subject_id, approved_rights_record_id, requested_yie_operation, named_purpose_scope),
  -- YUTE-AGENCY-INV-002: 7-column composite FK guarantees YIE envelope matches exact YUTE lease chain!
  FOREIGN KEY (lease_id, decision_id, grant_id, subject_id, approved_rights_record_id, permitted_yute_action, named_purpose_scope)
    REFERENCES firewall_capability_leases(lease_id, decision_id, grant_id, subject_id, target_rights_record_id, permitted_action, named_target_scope),
  -- Optional likeness_spec_id must also belong to the exact same human subject!
  FOREIGN KEY (active_likeness_spec_id)
    REFERENCES likeness_specifications(likeness_spec_id),
  CONSTRAINT yie_envelope_max_ttl_60s CHECK (
    expires_at > issued_at
    AND expires_at <= issued_at + INTERVAL '60 seconds'
  )
);

-- @AC-16 Human Growth & Cross-Subject Spec Integrity Trigger:
-- Ensures any referenced likeness_spec_id belongs to NEW.subject_id and is PERFORMER_APPROVED (never SUPERSEDED or REVOKED)
CREATE OR REPLACE FUNCTION yute_verify_yie_likeness_spec_currency()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_spec_subject TEXT;
  v_spec_status  TEXT;
BEGIN
  IF NEW.active_likeness_spec_id IS NOT NULL THEN
    SELECT subject_id, status INTO v_spec_subject, v_spec_status
    FROM likeness_specifications
    WHERE likeness_spec_id = NEW.active_likeness_spec_id;

    IF v_spec_subject IS DISTINCT FROM NEW.subject_id THEN
      RAISE EXCEPTION 'YUTE_INV_002_SPEC_SUBJECT_MISMATCH: spec % belongs to %, not %',
        NEW.active_likeness_spec_id, v_spec_subject, NEW.subject_id
        USING ERRCODE = '23503';
    END IF;

    IF v_spec_status IS DISTINCT FROM 'PERFORMER_APPROVED' THEN
      RAISE EXCEPTION 'YUTE_AC16_GROWTH_VIOLATION: spec % has status=% (must be PERFORMER_APPROVED, never SUPERSEDED/REVOKED)',
        NEW.active_likeness_spec_id, v_spec_status
        USING ERRCODE = '23514';
    END IF;
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_yie_likeness_spec_currency
AFTER INSERT OR UPDATE ON yie_authorization_envelopes
FOR EACH ROW EXECUTE FUNCTION yute_verify_yie_likeness_spec_currency();

-- 2. YIE EXECUTION & REFUSAL RECEIPTS (PROVES CAPABILITY READY + AUTHORITY ABSENT -> REFUSED)
CREATE TABLE yie_execution_receipts (
  yie_receipt_id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id                      TEXT NOT NULL REFERENCES human_subjects(subject_id),
  is_builder_steward_subject      BOOLEAN NOT NULL DEFAULT FALSE,
  requested_rights_record_id      TEXT NOT NULL,
  requested_yie_operation         TEXT NOT NULL CHECK (length(trim(requested_yie_operation)) > 0),
  requested_purpose_scope         TEXT NOT NULL CHECK (length(trim(requested_purpose_scope)) > 0),
  invoked_by_actor                TEXT NOT NULL CHECK (length(trim(invoked_by_actor)) > 0),
  actor_has_admin_privilege       BOOLEAN NOT NULL DEFAULT FALSE,
  admin_override_attempted        BOOLEAN NOT NULL DEFAULT FALSE,
  -- Records whether YIE synthesis/processing engine was online & technically capable:
  engine_capability_ready         BOOLEAN NOT NULL,
  envelope_id                     UUID,
  execution_outcome               TEXT NOT NULL CHECK (execution_outcome IN (
    'EXECUTED_EPHEMERAL_GOVERNED',
    'REFUSED_FAIL_CLOSED',
    'ABORTED_ON_CONCURRENT_REVOCATION'
  )),
  refusal_reason_code             TEXT,
  identity_bytes_decrypted        BIGINT NOT NULL DEFAULT 0 CHECK (identity_bytes_decrypted >= 0),
  generated_frames_emitted        INTEGER NOT NULL DEFAULT 0 CHECK (generated_frames_emitted >= 0),
  ephemeral_memory_zeroed         BOOLEAN NOT NULL DEFAULT TRUE CHECK (ephemeral_memory_zeroed = TRUE),
  clarity_manifest_id             UUID REFERENCES clarity_disclosure_manifests(disclosure_id),
  receipt_sha256                  TEXT NOT NULL UNIQUE CHECK (receipt_sha256 ~ '^[0-9a-f]{64}$'),
  recorded_at                     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  FOREIGN KEY (requested_rights_record_id, subject_id)
    REFERENCES digital_rights_records(rights_record_id, subject_id),
  -- YUTE-AGENCY-INV-002: EXECUTED_EPHEMERAL_GOVERNED requires valid composite match to envelope!
  FOREIGN KEY (envelope_id, subject_id, requested_rights_record_id, requested_yie_operation, requested_purpose_scope)
    REFERENCES yie_authorization_envelopes(envelope_id, subject_id, approved_rights_record_id, requested_yie_operation, named_purpose_scope),
  -- Core YUTE x YIE Boundary Law:
  -- 1. Missing envelope -> MUST be REFUSED_FAIL_CLOSED with 0 bytes & 0 frames.
  -- 2. Admin override attempt -> MUST be REFUSED_FAIL_CLOSED with 0 bytes & 0 frames (Section 05).
  -- 3. Refusal or revocation abort -> MUST decrypt/emit 0 frames.
  CONSTRAINT yie_boundary_fail_closed_law CHECK (
    (
      execution_outcome = 'EXECUTED_EPHEMERAL_GOVERNED'
      AND envelope_id IS NOT NULL
      AND admin_override_attempted = FALSE
      AND refusal_reason_code IS NULL
    )
    OR (
      execution_outcome IN ('REFUSED_FAIL_CLOSED', 'ABORTED_ON_CONCURRENT_REVOCATION')
      AND refusal_reason_code IS NOT NULL
      AND generated_frames_emitted = 0
      AND (execution_outcome <> 'REFUSED_FAIL_CLOSED' OR identity_bytes_decrypted = 0)
    )
  )
);

CREATE TRIGGER trg_immutable_yie_execution_receipts
BEFORE UPDATE OR DELETE ON yie_execution_receipts
FOR EACH ROW EXECUTE FUNCTION yute_prevent_audit_mutation();

ALTER TABLE yie_authorization_envelopes ENABLE ROW LEVEL SECURITY;
ALTER TABLE yie_execution_receipts ENABLE ROW LEVEL SECURITY;

COMMIT;
