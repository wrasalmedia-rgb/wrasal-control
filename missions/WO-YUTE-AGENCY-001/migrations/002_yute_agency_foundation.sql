-- =============================================================================
-- Migration: 002_yute_agency_foundation.sql
-- Program:   WRASAL(TM) | YUTE OS (YUTE GUARD | AGENCY FIREWALL | EVIDENCE VAULT)
-- Work Order: WO-YUTE-AGENCY-001 (Governed by YUTE-ADR-0010 & YUTE-PR8-REVIEW-001)
-- Target DB: PostgreSQL 16+
-- Invariants Enforced:
--   * YUTE-AGENCY-INV-001: Fail-closed scope evaluation across all boundaries.
--   * YUTE-AGENCY-INV-002: Composite FK authority chain preventing cross-subject,
--     cross-asset, or cross-purpose authorization transfer via DB association.
--   * Consent Process Evidence (5-Stage): PRESENTED -> ACKNOWLEDGED -> EXPLAINED
--     -> DECIDED -> AUTHORIZED (preserving process evidence without fabricating
--     certainty of internal mental comprehension).
--   * Egress Fence Ordering (EGRESS-FENCE-v001): Defines Point of Irrevocable
--     Egress and links post-flush concurrent revocations to 4-axis accounting.
-- =============================================================================

BEGIN;

-- 1. AGREEMENTS & UNICODE-CANONICALIZED CONTRACT SHIELD CITATIONS (TEST-03)
CREATE TABLE agreement_documents (
  agreement_id              TEXT PRIMARY KEY CHECK (agreement_id ~ '^AGR-[A-Z0-9-]+$'),
  subject_id                TEXT NOT NULL REFERENCES human_subjects(subject_id),
  counterparty_name         TEXT NOT NULL CHECK (length(trim(counterparty_name)) > 0),
  document_title            TEXT NOT NULL CHECK (length(trim(document_title)) > 0),
  is_yute_platform_terms    BOOLEAN NOT NULL DEFAULT FALSE,
  original_upload_sha256    TEXT NOT NULL CHECK (original_upload_sha256 ~ '^[0-9a-f]{64}$'),
  canonical_normalization   TEXT NOT NULL DEFAULT 'UNICODE_NFC_LF'
    CHECK (canonical_normalization = 'UNICODE_NFC_LF'),
  canonical_text_utf8       TEXT NOT NULL CHECK (length(canonical_text_utf8) > 0),
  canonical_text_sha256     TEXT NOT NULL CHECK (canonical_text_sha256 ~ '^[0-9a-f]{64}$'),
  ingested_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (agreement_id, subject_id),
  UNIQUE (agreement_id, canonical_text_sha256),
  UNIQUE (agreement_id, subject_id, canonical_text_sha256)
);

CREATE TABLE contract_shield_findings (
  finding_id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  agreement_id              TEXT NOT NULL,
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
  created_at                TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  FOREIGN KEY (agreement_id, canonical_text_sha256)
    REFERENCES agreement_documents(agreement_id, canonical_text_sha256)
);

-- 2. FIVE-STAGE CONSENT PROCESS CEREMONIES (PRESENTED -> ACKNOWLEDGED -> EXPLAINED -> DECIDED -> AUTHORIZED)
-- Preserves verifiable process evidence without manufacturing claims of internal comprehension.
CREATE TABLE authorization_ceremonies (
  ceremony_id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id                     TEXT NOT NULL,
  agreement_id                   TEXT NOT NULL,
  canonical_text_sha256          TEXT NOT NULL CHECK (canonical_text_sha256 ~ '^[0-9a-f]{64}$'),
  guard_analysis_snapshot_sha256 TEXT NOT NULL CHECK (guard_analysis_snapshot_sha256 ~ '^[0-9a-f]{64}$'),
  verified_signer_actor_id       TEXT NOT NULL CHECK (length(trim(verified_signer_actor_id)) > 0),
  signer_authority_basis         TEXT NOT NULL CHECK (signer_authority_basis IN (
    'SELF_ADULT_SUBJECT', 'VERIFIED_FIDUCIARY_REPRESENTATIVE'
  )),
  signer_verification_method     TEXT NOT NULL CHECK (signer_verification_method IN (
    'PASSKEY_WEBAUTHN_ATTESTED', 'QUALIFIED_ESIGN_PROVIDER', 'COUNSEL_WITNESSED_ATTESTATION'
  )),
  signer_subject_match_verified  BOOLEAN NOT NULL CHECK (signer_subject_match_verified = TRUE),
  -- Five distinct process events (Section 03):
  presented_at                   TIMESTAMPTZ NOT NULL,
  acknowledged_at                TIMESTAMPTZ NOT NULL,
  explained_at                   TIMESTAMPTZ NOT NULL,
  counsel_referral_offered       BOOLEAN NOT NULL CHECK (counsel_referral_offered = TRUE),
  clarification_requests_json    JSONB NOT NULL DEFAULT '[]'::jsonb,
  decided_at                     TIMESTAMPTZ NOT NULL,
  decision_outcome               TEXT NOT NULL CHECK (decision_outcome IN (
    'DECLINED', 'DEFERRED_FOR_COUNSEL', 'DECIDED_TO_AUTHORIZE'
  )),
  authorized_at                  TIMESTAMPTZ,
  record_preservation_permitted  BOOLEAN NOT NULL CHECK (record_preservation_permitted = TRUE),
  comprehension_epistemic_status TEXT NOT NULL DEFAULT 'PROCESS_EVIDENCE_ONLY_NOT_MIND_PROOF'
    CHECK (comprehension_epistemic_status = 'PROCESS_EVIDENCE_ONLY_NOT_MIND_PROOF'),
  ceremony_receipt_sha256        TEXT NOT NULL UNIQUE CHECK (ceremony_receipt_sha256 ~ '^[0-9a-f]{64}$'),
  -- YUTE-AGENCY-INV-002 composite key & FK binding ceremony strictly to (agreement_id, subject_id, hash)
  UNIQUE (ceremony_id, subject_id, agreement_id),
  FOREIGN KEY (agreement_id, subject_id, canonical_text_sha256)
    REFERENCES agreement_documents(agreement_id, subject_id, canonical_text_sha256),
  CONSTRAINT five_stage_consent_process_order CHECK (
    presented_at <= acknowledged_at
    AND acknowledged_at <= explained_at
    AND explained_at <= decided_at
    AND (
      (decision_outcome = 'DECIDED_TO_AUTHORIZE' AND authorized_at IS NOT NULL AND decided_at <= authorized_at)
      OR (decision_outcome <> 'DECIDED_TO_AUTHORIZE' AND authorized_at IS NULL)
    )
  )
);

CREATE TRIGGER trg_immutable_authorization_ceremonies
BEFORE UPDATE OR DELETE ON authorization_ceremonies
FOR EACH ROW EXECUTE FUNCTION yute_prevent_audit_mutation();

-- 3. DIGITAL RIGHTS PASSPORT ASSET & PERMISSION REGISTRY (COMPOSITE SUBJECT BINDING)
CREATE TABLE digital_rights_records (
  rights_record_id          TEXT PRIMARY KEY CHECK (rights_record_id ~ '^DRP-[A-Z0-9-]+$'),
  subject_id                TEXT NOT NULL REFERENCES human_subjects(subject_id),
  asset_or_data_category    TEXT NOT NULL CHECK (asset_or_data_category IN (
    'VISUAL_LIKENESS', 'VOICE_IDENTITY', 'PHOTOGRAPHIC_WORK',
    'MUSICAL_PERFORMANCE_MASTER', 'DRAMATIC_PERFORMANCE', 'PLATFORM_PERSONAL_DATA'
  )),
  external_platform_or_holder TEXT NOT NULL CHECK (length(trim(external_platform_or_holder)) > 0),
  rights_posture            TEXT NOT NULL CHECK (rights_posture IN (
    'OWNED_BY_SUBJECT', 'CO_OWNED', 'LICENSED_IN_SCOPED',
    'LICENSED_OUT_SCOPED', 'RESTRICTED_HOLD', 'UNKNOWN'
  )),
  evidence_agreement_id     TEXT,
  evidence_status           TEXT NOT NULL DEFAULT 'CLAIMED_UNVERIFIED'
    CHECK (evidence_status IN ('VERIFIED_EVIDENCE', 'CLAIMED_UNVERIFIED', 'UNKNOWN')),
  processing_restricted     BOOLEAN NOT NULL DEFAULT FALSE,
  recorded_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (rights_record_id, subject_id),
  FOREIGN KEY (evidence_agreement_id, subject_id)
    REFERENCES agreement_documents(agreement_id, subject_id),
  CONSTRAINT verified_posture_requires_agreement CHECK (
    evidence_status <> 'VERIFIED_EVIDENCE' OR evidence_agreement_id IS NOT NULL
  )
);

-- 4. CONSENT LEDGER SCOPED GRANTS (YUTE-AGENCY-INV-002: COMPOSITE SUBJECT + ASSET + PURPOSE LOCK)
CREATE TABLE consent_ledger_grants (
  grant_id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id                 TEXT NOT NULL,
  agreement_id               TEXT NOT NULL,
  ceremony_id                UUID NOT NULL,
  scoped_rights_record_id    TEXT NOT NULL,
  subject_age_class          TEXT NOT NULL CHECK (subject_age_class IN (
    'UNVERIFIED_AGE_HOLD', 'MINOR_PROTECTED', 'VULNERABLE_PROTECTED', 'ADULT_VERIFIED'
  )),
  permitted_action           TEXT NOT NULL CHECK (permitted_action IN (
    'CONTRACT_ANALYSIS_ONLY', 'VAULT_ARCHIVAL_CUSTODY',
    'PERFORMANCE_DISTRIBUTION_NAMED_TRACK',
    'VISUAL_LIKENESS_NAMED_PRODUCTION', 'PHOTO_CAMPAIGN_DISPLAY'
  )),
  named_target_scope         TEXT NOT NULL CHECK (length(trim(named_target_scope)) > 0),
  authorized_territory       TEXT NOT NULL CHECK (length(trim(authorized_territory)) > 0),
  contractual_scope_json     JSONB NOT NULL,
  voice_cloning_permitted    BOOLEAN NOT NULL DEFAULT FALSE,
  advertising_permitted      BOOLEAN NOT NULL DEFAULT FALSE,
  sublicensing_permitted     BOOLEAN NOT NULL DEFAULT FALSE,
  ai_model_training_allowed  BOOLEAN NOT NULL DEFAULT FALSE,
  autonomous_persona_allowed BOOLEAN NOT NULL DEFAULT FALSE CHECK (autonomous_persona_allowed = FALSE),
  grant_status               TEXT NOT NULL DEFAULT 'ACTIVE' CHECK (grant_status IN (
    'ACTIVE', 'AWAITING_ADULT_REAUTHORIZATION', 'EXPIRED', 'REVOKED'
  )),
  valid_from                 TIMESTAMPTZ NOT NULL,
  valid_until                TIMESTAMPTZ NOT NULL CHECK (valid_until > valid_from),
  created_at                 TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  -- Composite uniqueness supporting downstream YUTE-AGENCY-INV-002 foreign keys
  UNIQUE (grant_id, subject_id),
  UNIQUE (grant_id, subject_id, scoped_rights_record_id, permitted_action, named_target_scope),
  -- Finding 02 / TEST-06: Rejects attaching Subject A's ceremony or agreement to Subject B's grant!
  FOREIGN KEY (ceremony_id, subject_id, agreement_id)
    REFERENCES authorization_ceremonies(ceremony_id, subject_id, agreement_id),
  -- YUTE-AGENCY-INV-002: Rejects attaching Subject A's asset to Subject B's grant!
  FOREIGN KEY (scoped_rights_record_id, subject_id)
    REFERENCES digital_rights_records(rights_record_id, subject_id),
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

-- Additional trigger ensuring only ceremonies with decision_outcome = 'DECIDED_TO_AUTHORIZE' can back a grant
CREATE OR REPLACE FUNCTION yute_enforce_authorized_ceremony_on_grant()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_outcome TEXT;
BEGIN
  SELECT decision_outcome INTO v_outcome
  FROM authorization_ceremonies
  WHERE ceremony_id = NEW.ceremony_id
    AND subject_id = NEW.subject_id
    AND agreement_id = NEW.agreement_id;

  IF FOUND AND v_outcome IS DISTINCT FROM 'DECIDED_TO_AUTHORIZE' THEN
    RAISE EXCEPTION 'YUTE_CEREMONY_NOT_AUTHORIZED: ceremony % has decision_outcome=%', NEW.ceremony_id, v_outcome
      USING ERRCODE = '23514';
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_grant_requires_decided_to_authorize
AFTER INSERT OR UPDATE ON consent_ledger_grants
FOR EACH ROW EXECUTE FUNCTION yute_enforce_authorized_ceremony_on_grant();

-- 5. AGENCY FIREWALL DECISIONS, CAPABILITY LEASES & TRANSACTIONAL EGRESS FENCES (FINDINGS 02 & 03)
CREATE TABLE agency_firewall_decisions (
  decision_id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id                 TEXT NOT NULL REFERENCES human_subjects(subject_id),
  requested_rights_record_id TEXT NOT NULL,
  requested_by_actor         TEXT NOT NULL CHECK (length(trim(requested_by_actor)) > 0),
  execution_boundary         TEXT NOT NULL CHECK (execution_boundary IN (
    'HTTP_API', 'BACKGROUND_WORKER', 'CLI_COMMAND', 'ADMIN_OPERATION', 'RENDER_ADAPTER'
  )),
  requested_action           TEXT NOT NULL CHECK (length(trim(requested_action)) > 0),
  requested_target_scope     TEXT NOT NULL CHECK (length(trim(requested_target_scope)) > 0),
  requires_voice_synthesis   BOOLEAN NOT NULL DEFAULT FALSE,
  requires_advertising_use   BOOLEAN NOT NULL DEFAULT FALSE,
  requires_sublicensing      BOOLEAN NOT NULL DEFAULT FALSE,
  matched_grant_id           UUID,
  outcome                    TEXT NOT NULL CHECK (outcome IN ('ALLOW', 'DENY')),
  denial_reason_code         TEXT,
  missing_permissions        JSONB NOT NULL DEFAULT '[]'::jsonb,
  protected_assets_released  BOOLEAN NOT NULL DEFAULT FALSE,
  audit_receipt_sha256       TEXT NOT NULL UNIQUE CHECK (audit_receipt_sha256 ~ '^[0-9a-f]{64}$'),
  decided_at                 TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (decision_id, matched_grant_id, subject_id, requested_rights_record_id, requested_action, requested_target_scope),
  FOREIGN KEY (requested_rights_record_id, subject_id)
    REFERENCES digital_rights_records(rights_record_id, subject_id),
  -- YUTE-AGENCY-INV-002: When matched_grant_id is bound, PostgreSQL verifies exact match of
  -- (subject_id, asset rights_record_id, permitted_action, named_target_scope)!
  FOREIGN KEY (matched_grant_id, subject_id, requested_rights_record_id, requested_action, requested_target_scope)
    REFERENCES consent_ledger_grants(grant_id, subject_id, scoped_rights_record_id, permitted_action, named_target_scope),
  CONSTRAINT allow_requires_matched_grant_and_deny_releases_zero CHECK (
    (outcome = 'ALLOW' AND matched_grant_id IS NOT NULL AND denial_reason_code IS NULL)
    OR (
      outcome = 'DENY'
      AND matched_grant_id IS NULL
      AND protected_assets_released = FALSE
      AND denial_reason_code IS NOT NULL
      AND jsonb_array_length(missing_permissions) > 0
    )
  )
);

CREATE TRIGGER trg_immutable_agency_firewall_decisions
BEFORE UPDATE OR DELETE ON agency_firewall_decisions
FOR EACH ROW EXECUTE FUNCTION yute_prevent_audit_mutation();

CREATE TABLE firewall_capability_leases (
  lease_id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  decision_id                UUID NOT NULL,
  grant_id                   UUID NOT NULL,
  subject_id                 TEXT NOT NULL,
  target_rights_record_id    TEXT NOT NULL,
  permitted_action           TEXT NOT NULL CHECK (length(trim(permitted_action)) > 0),
  named_target_scope         TEXT NOT NULL CHECK (length(trim(named_target_scope)) > 0),
  lease_token_sha256         TEXT NOT NULL UNIQUE CHECK (lease_token_sha256 ~ '^[0-9a-f]{64}$'),
  lease_state                TEXT NOT NULL DEFAULT 'ISSUED' CHECK (lease_state IN (
    'ISSUED',
    'EGRESS_CLAIMED_PRE_SOCKET',
    'COMMITTED_INTERNAL',
    'COMMITTED_EXTERNAL_EGRESS',
    'ABORTED_PRE_SOCKET_ZERO_BYTES',
    'INVALIDATED_ON_REVOCATION',
    'INVALIDATED_AT_COMMIT_BOUNDARY',
    'REVOKED_POST_IRREVOCABLE_EGRESS',
    'EXPIRED'
  )),
  claim_deadline_at          TIMESTAMPTZ,
  first_payload_byte_flushed_at TIMESTAMPTZ,
  expires_at                 TIMESTAMPTZ NOT NULL,
  created_at                 TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  -- YUTE-AGENCY-INV-002: Capability lease cannot alter subject, asset, action, or purpose!
  FOREIGN KEY (decision_id, grant_id, subject_id, target_rights_record_id, permitted_action, named_target_scope)
    REFERENCES agency_firewall_decisions(decision_id, matched_grant_id, subject_id, requested_rights_record_id, requested_action, requested_target_scope),
  -- Finding 03 (Point of Irrevocable Egress):
  CONSTRAINT irrevocable_egress_timestamp_integrity CHECK (
    (lease_state IN ('COMMITTED_EXTERNAL_EGRESS', 'REVOKED_POST_IRREVOCABLE_EGRESS') AND first_payload_byte_flushed_at IS NOT NULL)
    OR (lease_state NOT IN ('COMMITTED_EXTERNAL_EGRESS', 'REVOKED_POST_IRREVOCABLE_EGRESS') AND first_payload_byte_flushed_at IS NULL)
  )
);

-- 6. THREE-TIER ADULTHOOD TRANSITION & TWO-STEWARD LAWFUL RETENTION HOLDS (TEST-04)
CREATE TABLE legal_retention_holds (
  hold_id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id                TEXT NOT NULL REFERENCES human_subjects(subject_id),
  target_record_ref         TEXT NOT NULL CHECK (length(trim(target_record_ref)) > 0),
  hold_category             TEXT NOT NULL CHECK (hold_category IN (
    'STATUTORY_TAX_ACCOUNTING', 'ACTIVE_LITIGATION_HOLD',
    'SECURITY_INCIDENT_INVESTIGATION', 'TAMPER_EVIDENT_AUDIT_HASH_ONLY'
  )),
  legal_citation_basis      TEXT NOT NULL CHECK (length(trim(legal_citation_basis)) > 0),
  approved_by_steward_a     TEXT NOT NULL CHECK (length(trim(approved_by_steward_a)) > 0),
  approved_by_steward_b     TEXT NOT NULL CHECK (length(trim(approved_by_steward_b)) > 0),
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

-- 7. FOUR-AXIS REVOCATION ACCOUNTING (COMPOSITE SUBJECT BINDING + EGRESS HONESTY)
CREATE TABLE revocation_status_ledgers (
  revocation_ledger_id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  revocation_id                        UUID NOT NULL,
  grant_id                             UUID NOT NULL,
  subject_id                           TEXT NOT NULL,
  had_prior_external_distribution      BOOLEAN NOT NULL DEFAULT FALSE,
  authorization_termination_status     TEXT NOT NULL DEFAULT 'TERMINATED_PROSPECTIVELY'
    CHECK (authorization_termination_status IN ('TERMINATED_PROSPECTIVELY', 'DISPUTED_UNDER_REVIEW')),
  internal_processing_cessation_status TEXT NOT NULL DEFAULT 'HALTING_IN_PROGRESS'
    CHECK (internal_processing_cessation_status IN ('HALTING_IN_PROGRESS', 'CONFIRMED_INTERNAL_HALTED')),
  downstream_notification_status       TEXT NOT NULL DEFAULT 'PENDING_DISPATCH'
    CHECK (downstream_notification_status IN (
      'NOT_APPLICABLE_NO_PRIOR_RELEASE', 'PENDING_DISPATCH',
      'DISPATCHED_UNCONFIRMED', 'RECEIPT_ACKNOWLEDGED', 'UNACKNOWLEDGED_ESCALATED'
    )),
  confirmed_deletion_status            TEXT NOT NULL DEFAULT 'EXTERNAL_DELETION_UNCONFIRMED'
    CHECK (confirmed_deletion_status IN (
      'INTERNAL_ELIGIBLE_DELETED_ONLY', 'INTERNAL_RETENTION_HOLD_DECLARED',
      'EXTERNAL_DELETION_UNCONFIRMED', 'EXTERNAL_DELETION_CONFIRMED_WITH_RECEIPT'
    )),
  external_deletion_receipt_sha256     TEXT CHECK (
    external_deletion_receipt_sha256 IS NULL OR external_deletion_receipt_sha256 ~ '^[0-9a-f]{64}$'
  ),
  updated_at                           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  FOREIGN KEY (revocation_id, subject_id) REFERENCES revocation_events(revocation_id, subject_id),
  FOREIGN KEY (grant_id, subject_id) REFERENCES consent_ledger_grants(grant_id, subject_id),
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

-- Enable Row-Level Security on core agency tables (defense-in-depth for non-superuser service roles)
ALTER TABLE agreement_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE authorization_ceremonies ENABLE ROW LEVEL SECURITY;
ALTER TABLE digital_rights_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE consent_ledger_grants ENABLE ROW LEVEL SECURITY;
ALTER TABLE agency_firewall_decisions ENABLE ROW LEVEL SECURITY;
ALTER TABLE firewall_capability_leases ENABLE ROW LEVEL SECURITY;
ALTER TABLE revocation_status_ledgers ENABLE ROW LEVEL SECURITY;

COMMIT;
