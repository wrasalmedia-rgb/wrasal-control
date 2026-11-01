-- =============================================================================
-- Migration: 004_yute_authority_proof_hardening.sql
-- Program:   WRASAL(TM) | YUTE OS x YIE(TM)
-- Milestone: YUTE-OS-v003 | THE AUTHORITY PROOF
-- Authority: YUTE-ARCH-GOV-003 (Mission Control Engineering Audit 002),
--            decisions/YUTE-ADR-0010.md, decisions/YUTE-ADR-0011.md
-- Target DB: PostgreSQL 16+
-- Purpose:   Remediates Audit 002 (YUTE-ARCH-GOV-003) schema & DB-security
--            obligations across five fronts:
--            1. Finding A (Signature Preimage & Key Registry): Registers
--               Ed25519 verify-only public keys, enforces canonical signing
--               preimage SHA-256 + 64-byte hex format, and gates execution
--               receipts on explicit signature_verification_status. (Note:
--               actual Ed25519 curve verification remains a mandatory Ruby 3.3
--               Yie::AuthorizationGate runtime obligation.)
--            2. Finding B (Atomic Single-Use Claim): Adds row-locking
--               yie_claim_single_use_envelope(), one-time claim tokens, and a
--               unique partial index blocking duplicate execution receipts.
--            3. Finding C (Live Current-State Authority Gate): Re-evaluates
--               live upstream statuses (likeness spec PERFORMER_APPROVED,
--               unrevoked grant, unheld asset, unrestricted subject, active
--               lease, uncompromised signing key) at BOTH claim time and
--               receipt finalization time.
--            4. Finding D (Observable Worker Isolation & Memory Epistemics):
--               Replaces overbroad RAM-erasure assumptions with observable
--               one-shot isolated worker termination & sodium_memzero telemetry
--               explicitly scoped as PROCESS_ISOLATION_TELEMETRY_ONLY_NOT_RAM_PROOF.
--            5. Section 04 (Least-Privilege DB Roles & FORCE RLS): Creates
--               non-superuser NOBYPASSRLS roles (yute_firewall_service,
--               yie_capability_service, yute_auditor_readonly), revokes PUBLIC
--               access, denies YIE INSERT/ownership on authority & vault tables,
--               and enables FORCE ROW LEVEL SECURITY + subject-scoped policies.
-- =============================================================================

BEGIN;

-- =============================================================================
-- 1. FINDING A: YUTE FIREWALL ED25519 VERIFY-ONLY KEY REGISTRY & PREIMAGE LOCK
-- =============================================================================

CREATE TABLE yute_firewall_signing_keys (
  signing_key_id          TEXT PRIMARY KEY CHECK (signing_key_id ~ '^YUTE-FW-ED25519-[A-Z0-9-]+$'),
  ed25519_public_key_hex  TEXT NOT NULL UNIQUE CHECK (ed25519_public_key_hex ~ '^[0-9a-f]{64}$'),
  key_status              TEXT NOT NULL DEFAULT 'ACTIVE'
    CHECK (key_status IN ('ACTIVE', 'ROTATED_VERIFY_ONLY', 'REVOKED_COMPROMISED')),
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  revoked_at              TIMESTAMPTZ,
  CONSTRAINT revoked_key_requires_timestamp CHECK (
    (key_status = 'REVOKED_COMPROMISED' AND revoked_at IS NOT NULL)
    OR (key_status <> 'REVOKED_COMPROMISED' AND revoked_at IS NULL)
  )
);

-- Deterministic canonical signing preimage for YUTE -> YIE Ed25519 signatures.
-- Both Yute::AgencyFirewall (signer) and Yie::AuthorizationGate (verifier) MUST
-- serialize these exact fields in this exact order before Ed25519 sign/verify.
CREATE OR REPLACE FUNCTION yute_canonical_envelope_signing_preimage(
  p_envelope_id               UUID,
  p_issuer_authority          TEXT,
  p_signing_key_id            TEXT,
  p_lease_id                  UUID,
  p_decision_id               UUID,
  p_grant_id                  UUID,
  p_subject_id                TEXT,
  p_approved_rights_record_id TEXT,
  p_active_likeness_spec_id   TEXT,
  p_permitted_yute_action     TEXT,
  p_requested_yie_operation   TEXT,
  p_named_purpose_scope       TEXT,
  p_issued_at                 TIMESTAMPTZ,
  p_expires_at                TIMESTAMPTZ
)
RETURNS TEXT
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT concat_ws(
    '|',
    'YIE-AUTH-ENV-v001',
    coalesce(p_envelope_id::text, ''),
    coalesce(p_issuer_authority, ''),
    coalesce(p_signing_key_id, ''),
    coalesce(p_lease_id::text, ''),
    coalesce(p_decision_id::text, ''),
    coalesce(p_grant_id::text, ''),
    coalesce(p_subject_id, ''),
    coalesce(p_approved_rights_record_id, ''),
    coalesce(p_active_likeness_spec_id, 'NONE'),
    coalesce(p_permitted_yute_action, ''),
    coalesce(p_requested_yie_operation, ''),
    coalesce(p_named_purpose_scope, ''),
    to_char(p_issued_at AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"'),
    to_char(p_expires_at AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"')
  );
$$;

CREATE OR REPLACE FUNCTION yute_canonical_envelope_signing_sha256(
  p_envelope_id               UUID,
  p_issuer_authority          TEXT,
  p_signing_key_id            TEXT,
  p_lease_id                  UUID,
  p_decision_id               UUID,
  p_grant_id                  UUID,
  p_subject_id                TEXT,
  p_approved_rights_record_id TEXT,
  p_active_likeness_spec_id   TEXT,
  p_permitted_yute_action     TEXT,
  p_requested_yie_operation   TEXT,
  p_named_purpose_scope       TEXT,
  p_issued_at                 TIMESTAMPTZ,
  p_expires_at                TIMESTAMPTZ
)
RETURNS TEXT
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT encode(
    pg_catalog.sha256(
      convert_to(
        yute_canonical_envelope_signing_preimage(
          p_envelope_id, p_issuer_authority, p_signing_key_id,
          p_lease_id, p_decision_id, p_grant_id, p_subject_id,
          p_approved_rights_record_id, p_active_likeness_spec_id,
          p_permitted_yute_action, p_requested_yie_operation,
          p_named_purpose_scope, p_issued_at, p_expires_at
        ),
        'UTF8'
      )
    ),
    'hex'
  );
$$;

-- =============================================================================
-- 2. HARDEN yie_authorization_envelopes (FINDINGS A, B & C)
-- =============================================================================

ALTER TABLE yie_authorization_envelopes
  DROP CONSTRAINT yie_authorization_envelopes_envelope_status_check;

ALTER TABLE yie_authorization_envelopes
  ADD COLUMN signing_key_id                   TEXT REFERENCES yute_firewall_signing_keys(signing_key_id),
  ADD COLUMN canonical_signing_payload_sha256 TEXT CHECK (canonical_signing_payload_sha256 ~ '^[0-9a-f]{64}$'),
  ADD COLUMN claimed_at                       TIMESTAMPTZ,
  ADD COLUMN claimed_by_worker_id             TEXT,
  ADD COLUMN single_use_claim_token           UUID UNIQUE,
  ADD COLUMN consumed_at                      TIMESTAMPTZ;

ALTER TABLE yie_authorization_envelopes
  ALTER COLUMN signing_key_id SET NOT NULL,
  ALTER COLUMN canonical_signing_payload_sha256 SET NOT NULL,
  ADD CONSTRAINT yie_authorization_envelopes_envelope_status_check CHECK (
    envelope_status IN (
      'ISSUED_UNUSED',
      'CLAIMED_IN_FLIGHT',
      'CONSUMED_SINGLE_USE',
      'EXPIRED',
      'REVOKED_ABORTED'
    )
  ),
  -- Strict 64-byte raw Ed25519 signature encoded as 128 lowercase hex chars.
  -- (Cryptographic curve verification is enforced in Yie::AuthorizationGate runtime.)
  ADD CONSTRAINT yie_signature_hex_64bytes CHECK (
    firewall_ed25519_signature ~ '^[0-9a-f]{128}$'
  ),
  ADD CONSTRAINT yie_single_use_claim_state_integrity CHECK (
    (
      envelope_status = 'ISSUED_UNUSED'
      AND claimed_at IS NULL
      AND claimed_by_worker_id IS NULL
      AND single_use_claim_token IS NULL
      AND consumed_at IS NULL
    )
    OR (
      envelope_status = 'CLAIMED_IN_FLIGHT'
      AND claimed_at IS NOT NULL
      AND claimed_by_worker_id IS NOT NULL
      AND length(trim(claimed_by_worker_id)) > 0
      AND single_use_claim_token IS NOT NULL
      AND consumed_at IS NULL
    )
    OR (
      envelope_status = 'CONSUMED_SINGLE_USE'
      AND claimed_at IS NOT NULL
      AND claimed_by_worker_id IS NOT NULL
      AND single_use_claim_token IS NOT NULL
      AND consumed_at IS NOT NULL
      AND consumed_at >= claimed_at
    )
    OR (
      envelope_status IN ('EXPIRED', 'REVOKED_ABORTED')
      AND consumed_at IS NULL
    )
  );

-- Verify signing key is ACTIVE on insert and auto-verify canonical signing digest
CREATE OR REPLACE FUNCTION yute_enforce_envelope_key_and_preimage()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_key_status   TEXT;
  v_expected_sha TEXT;
BEGIN
  IF TG_OP = 'INSERT' THEN
    SELECT key_status INTO v_key_status
    FROM yute_firewall_signing_keys
    WHERE signing_key_id = NEW.signing_key_id;

    IF v_key_status IS DISTINCT FROM 'ACTIVE' THEN
      RAISE EXCEPTION 'YUTE_SIGNING_KEY_NOT_ACTIVE: signing_key_id % has status=%',
        NEW.signing_key_id, v_key_status
        USING ERRCODE = '23514';
    END IF;
  END IF;

  v_expected_sha := yute_canonical_envelope_signing_sha256(
    NEW.envelope_id, NEW.issuer_authority, NEW.signing_key_id,
    NEW.lease_id, NEW.decision_id, NEW.grant_id, NEW.subject_id,
    NEW.approved_rights_record_id, NEW.active_likeness_spec_id,
    NEW.permitted_yute_action, NEW.requested_yie_operation,
    NEW.named_purpose_scope, NEW.issued_at, NEW.expires_at
  );

  IF NEW.canonical_signing_payload_sha256 IS DISTINCT FROM v_expected_sha THEN
    RAISE EXCEPTION 'YUTE_SIGNING_PREIMAGE_MISMATCH: expected %, got %',
      v_expected_sha, NEW.canonical_signing_payload_sha256
      USING ERRCODE = '23514';
  END IF;

  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_yie_envelope_key_and_preimage
AFTER INSERT OR UPDATE ON yie_authorization_envelopes
FOR EACH ROW EXECUTE FUNCTION yute_enforce_envelope_key_and_preimage();

-- Prevent mutation of immutable authority columns on yie_authorization_envelopes;
-- only single-use lifecycle status/claim columns may transition monotonically.
CREATE OR REPLACE FUNCTION yute_guard_envelope_authority_immutability()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    RAISE EXCEPTION 'YUTE_IMMUTABLE_LEDGER_VIOLATION: DELETE on yie_authorization_envelopes is prohibited'
      USING ERRCODE = 'P0001';
  END IF;

  IF NEW.envelope_id IS DISTINCT FROM OLD.envelope_id
     OR NEW.issuer_authority IS DISTINCT FROM OLD.issuer_authority
     OR NEW.signing_key_id IS DISTINCT FROM OLD.signing_key_id
     OR NEW.canonical_signing_payload_sha256 IS DISTINCT FROM OLD.canonical_signing_payload_sha256
     OR NEW.lease_id IS DISTINCT FROM OLD.lease_id
     OR NEW.decision_id IS DISTINCT FROM OLD.decision_id
     OR NEW.grant_id IS DISTINCT FROM OLD.grant_id
     OR NEW.subject_id IS DISTINCT FROM OLD.subject_id
     OR NEW.approved_rights_record_id IS DISTINCT FROM OLD.approved_rights_record_id
     OR NEW.active_likeness_spec_id IS DISTINCT FROM OLD.active_likeness_spec_id
     OR NEW.permitted_yute_action IS DISTINCT FROM OLD.permitted_yute_action
     OR NEW.requested_yie_operation IS DISTINCT FROM OLD.requested_yie_operation
     OR NEW.named_purpose_scope IS DISTINCT FROM OLD.named_purpose_scope
     OR NEW.firewall_ed25519_signature IS DISTINCT FROM OLD.firewall_ed25519_signature
     OR NEW.issued_at IS DISTINCT FROM OLD.issued_at
     OR NEW.expires_at IS DISTINCT FROM OLD.expires_at THEN
    RAISE EXCEPTION 'YUTE_ENVELOPE_AUTHORITY_IMMUTABLE: authority fields on yie_authorization_envelopes cannot be mutated'
      USING ERRCODE = 'P0001';
  END IF;

  IF OLD.envelope_status = 'CONSUMED_SINGLE_USE' THEN
    RAISE EXCEPTION 'YUTE_SINGLE_USE_FINALIZED: consumed envelope % cannot transition again', OLD.envelope_id
      USING ERRCODE = '23505';
  END IF;

  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_yie_envelope_authority_immutability
BEFORE UPDATE OR DELETE ON yie_authorization_envelopes
FOR EACH ROW EXECUTE FUNCTION yute_guard_envelope_authority_immutability();

-- =============================================================================
-- 3. FINDING C & B: LIVE CURRENT-STATE AUTHORITY GATE & ATOMIC SINGLE-USE CLAIM
-- =============================================================================

-- Re-evaluates ALL upstream YUTE authority records at execution/finalization time
-- so an envelope invalidated AFTER issuance (superseded spec, revoked grant,
-- restricted subject/asset, invalidated lease, or compromised key) FAILS CLOSED!
CREATE OR REPLACE FUNCTION yie_assert_live_authority_currency(
  p_envelope_id UUID,
  p_eval_ts     TIMESTAMPTZ DEFAULT NOW()
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
  v_env            yie_authorization_envelopes%ROWTYPE;
  v_key_status     TEXT;
  v_subj_status    TEXT;
  v_subj_age       TEXT;
  v_rights_posture TEXT;
  v_rights_restr   BOOLEAN;
  v_grant_status   TEXT;
  v_grant_from     TIMESTAMPTZ;
  v_grant_until    TIMESTAMPTZ;
  v_lease_state    TEXT;
  v_lease_exp      TIMESTAMPTZ;
  v_spec_status    TEXT;
BEGIN
  SELECT * INTO v_env
  FROM yie_authorization_envelopes
  WHERE envelope_id = p_envelope_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'YIE_ENVELOPE_NOT_FOUND: %', p_envelope_id USING ERRCODE = '23503';
  END IF;

  IF p_eval_ts < v_env.issued_at OR p_eval_ts > v_env.expires_at THEN
    RAISE EXCEPTION 'YIE_ENVELOPE_EXPIRED: eval_ts=% outside [% .. %]',
      p_eval_ts, v_env.issued_at, v_env.expires_at
      USING ERRCODE = '23514';
  END IF;

  -- 1. Signing key must not have been revoked for compromise
  SELECT key_status INTO v_key_status
  FROM yute_firewall_signing_keys
  WHERE signing_key_id = v_env.signing_key_id
  FOR KEY SHARE;

  IF v_key_status = 'REVOKED_COMPROMISED' OR v_key_status IS NULL THEN
    RAISE EXCEPTION 'YIE_SIGNING_KEY_COMPROMISED_OR_MISSING: %', v_env.signing_key_id
      USING ERRCODE = '23514';
  END IF;

  -- 2. Human subject must remain CONSENTED_ACTIVE & ADULT_VERIFIED without adulthood restriction
  SELECT status, age_protection_class INTO v_subj_status, v_subj_age
  FROM human_subjects
  WHERE subject_id = v_env.subject_id
  FOR KEY SHARE;

  IF v_subj_status IS DISTINCT FROM 'CONSENTED_ACTIVE' OR v_subj_age IS DISTINCT FROM 'ADULT_VERIFIED' THEN
    RAISE EXCEPTION 'YIE_LIVE_SUBJECT_HALTED: subject % status=% age=%',
      v_env.subject_id, v_subj_status, v_subj_age
      USING ERRCODE = '23514';
  END IF;

  IF EXISTS (
    SELECT 1 FROM adulthood_transitions at
    WHERE at.subject_id = v_env.subject_id AND at.processing_restricted = TRUE
  ) THEN
    RAISE EXCEPTION 'YIE_LIVE_ADULTHOOD_PROCESSING_RESTRICTED: subject %', v_env.subject_id
      USING ERRCODE = '23514';
  END IF;

  -- 3. Digital Rights Passport record must not be RESTRICTED_HOLD, UNKNOWN, or restricted
  SELECT rights_posture, processing_restricted INTO v_rights_posture, v_rights_restr
  FROM digital_rights_records
  WHERE rights_record_id = v_env.approved_rights_record_id
    AND subject_id = v_env.subject_id
  FOR KEY SHARE;

  IF v_rights_posture IN ('RESTRICTED_HOLD', 'UNKNOWN') OR v_rights_restr = TRUE THEN
    RAISE EXCEPTION 'YIE_LIVE_ASSET_RESTRICTED: asset % posture=% restricted=%',
      v_env.approved_rights_record_id, v_rights_posture, v_rights_restr
      USING ERRCODE = '23514';
  END IF;

  -- 4. Consent Ledger grant must still be ACTIVE, within window, and free of revocation events
  SELECT grant_status, valid_from, valid_until
    INTO v_grant_status, v_grant_from, v_grant_until
  FROM consent_ledger_grants
  WHERE grant_id = v_env.grant_id
    AND subject_id = v_env.subject_id
  FOR KEY SHARE;

  IF v_grant_status IS DISTINCT FROM 'ACTIVE' OR p_eval_ts < v_grant_from OR p_eval_ts > v_grant_until THEN
    RAISE EXCEPTION 'YIE_LIVE_GRANT_INACTIVE: grant % status=% at %',
      v_env.grant_id, v_grant_status, p_eval_ts
      USING ERRCODE = '23514';
  END IF;

  IF EXISTS (
    SELECT 1 FROM revocation_status_ledgers rsl
    WHERE rsl.grant_id = v_env.grant_id
      AND rsl.subject_id = v_env.subject_id
      AND rsl.authorization_termination_status = 'TERMINATED_PROSPECTIVELY'
  ) OR EXISTS (
    SELECT 1 FROM revocation_events re
    WHERE re.subject_id = v_env.subject_id
      AND re.new_generation_blocked_at <= p_eval_ts
  ) THEN
    RAISE EXCEPTION 'YIE_LIVE_CONSENT_REVOKED: grant % or subject % revoked prior to execution',
      v_env.grant_id, v_env.subject_id
      USING ERRCODE = '23514';
  END IF;

  -- 5. Firewall capability lease must remain valid and non-aborted
  SELECT lease_state, expires_at INTO v_lease_state, v_lease_exp
  FROM firewall_capability_leases
  WHERE lease_id = v_env.lease_id
    AND subject_id = v_env.subject_id
  FOR KEY SHARE;

  IF v_lease_state IN (
    'ABORTED_PRE_SOCKET_ZERO_BYTES',
    'INVALIDATED_ON_REVOCATION',
    'INVALIDATED_AT_COMMIT_BOUNDARY',
    'REVOKED_POST_IRREVOCABLE_EGRESS',
    'EXPIRED'
  ) OR p_eval_ts > v_lease_exp THEN
    RAISE EXCEPTION 'YIE_LIVE_LEASE_INVALIDATED: lease % state=%',
      v_env.lease_id, v_lease_state
      USING ERRCODE = '23514';
  END IF;

  -- 6. Finding C / @AC-16: Referenced likeness specification must STILL be PERFORMER_APPROVED!
  IF v_env.active_likeness_spec_id IS NOT NULL THEN
    SELECT status INTO v_spec_status
    FROM likeness_specifications
    WHERE likeness_spec_id = v_env.active_likeness_spec_id
      AND subject_id = v_env.subject_id
    FOR KEY SHARE;

    IF v_spec_status IS DISTINCT FROM 'PERFORMER_APPROVED' THEN
      RAISE EXCEPTION 'YIE_LIVE_SPEC_SUPERSEDED_OR_REVOKED: spec % now has status=%',
        v_env.active_likeness_spec_id, v_spec_status
        USING ERRCODE = '23514';
    END IF;
  END IF;
END;
$$;

-- Atomic single-use claim function (Finding B):
-- Acquires row lock FOR UPDATE on yie_authorization_envelopes, blocks concurrent
-- double-consumption or replay (23505), verifies live upstream currency (23514),
-- and returns a one-time claim_token required to record EXECUTED_EPHEMERAL_GOVERNED.
CREATE OR REPLACE FUNCTION yie_claim_single_use_envelope(
  p_envelope_id UUID,
  p_worker_id   TEXT,
  p_eval_ts     TIMESTAMPTZ DEFAULT NOW()
)
RETURNS UUID
LANGUAGE plpgsql
AS $$
DECLARE
  v_env         yie_authorization_envelopes%ROWTYPE;
  v_claim_token UUID;
BEGIN
  SELECT * INTO v_env
  FROM yie_authorization_envelopes
  WHERE envelope_id = p_envelope_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'YIE_ENVELOPE_NOT_FOUND: %', p_envelope_id
      USING ERRCODE = '23503';
  END IF;

  IF v_env.envelope_status <> 'ISSUED_UNUSED' OR v_env.single_use_claim_token IS NOT NULL THEN
    RAISE EXCEPTION 'YIE_SINGLE_USE_REPLAY_DETECTED: envelope % already in state %',
      p_envelope_id, v_env.envelope_status
      USING ERRCODE = '23505';
  END IF;

  -- Evaluate live upstream authority currency BEFORE granting claim!
  PERFORM yie_assert_live_authority_currency(p_envelope_id, p_eval_ts);

  v_claim_token := gen_random_uuid();

  UPDATE yie_authorization_envelopes
  SET envelope_status        = 'CLAIMED_IN_FLIGHT',
      claimed_at             = p_eval_ts,
      claimed_by_worker_id   = p_worker_id,
      single_use_claim_token = v_claim_token
  WHERE envelope_id = p_envelope_id;

  RETURN v_claim_token;
END;
$$;

-- =============================================================================
-- 4. HARDEN yie_execution_receipts (FINDINGS A, B, C & D)
-- =============================================================================

ALTER TABLE yie_execution_receipts
  DROP CONSTRAINT yie_execution_receipts_ephemeral_memory_zeroed_check,
  DROP CONSTRAINT yie_boundary_fail_closed_law;

ALTER TABLE yie_execution_receipts
  ALTER COLUMN ephemeral_memory_zeroed SET DEFAULT FALSE,
  ADD COLUMN signature_verification_status TEXT NOT NULL DEFAULT 'NOT_EVALUATED_NO_ENVELOPE'
    CHECK (signature_verification_status IN (
      'NOT_EVALUATED_NO_ENVELOPE',
      'VERIFIED_ED25519_OK',
      'FAILED_MISSING_SIGNATURE',
      'FAILED_FORGED_SIGNATURE',
      'FAILED_KEY_REVOKED_OR_UNKNOWN',
      'FAILED_PREIMAGE_MISMATCH'
    )),
  ADD COLUMN verified_signing_key_id TEXT REFERENCES yute_firewall_signing_keys(signing_key_id),
  ADD COLUMN consumed_claim_token    UUID,
  -- Finding D: Observable worker isolation & buffer disposal telemetry
  -- (never overclaiming absolute managed-heap RAM erasure from a DB boolean)
  ADD COLUMN worker_isolation_mode   TEXT NOT NULL DEFAULT 'NONE_PRE_EXECUTION_REFUSAL'
    CHECK (worker_isolation_mode IN (
      'NONE_PRE_EXECUTION_REFUSAL',
      'ONE_SHOT_SUBPROCESS_ISOLATED',
      'EPHEMERAL_MICROVM_ISOLATED'
    )),
  ADD COLUMN buffer_disposal_method  TEXT NOT NULL DEFAULT 'NO_PLAINTEXT_ALLOCATED'
    CHECK (buffer_disposal_method IN (
      'NO_PLAINTEXT_ALLOCATED',
      'SODIUM_MEMZERO_BEST_EFFORT_PLUS_PROCESS_EXIT'
    )),
  ADD COLUMN isolated_worker_terminated BOOLEAN NOT NULL DEFAULT FALSE,
  ADD COLUMN memory_assurance_epistemic_scope TEXT NOT NULL
    DEFAULT 'PROCESS_ISOLATION_TELEMETRY_ONLY_NOT_RAM_PROOF'
    CHECK (memory_assurance_epistemic_scope = 'PROCESS_ISOLATION_TELEMETRY_ONLY_NOT_RAM_PROOF'),
  ADD CONSTRAINT yie_boundary_fail_closed_law CHECK (
    (
      execution_outcome = 'EXECUTED_EPHEMERAL_GOVERNED'
      AND envelope_id IS NOT NULL
      AND consumed_claim_token IS NOT NULL
      AND signature_verification_status = 'VERIFIED_ED25519_OK'
      AND verified_signing_key_id IS NOT NULL
      AND admin_override_attempted = FALSE
      AND refusal_reason_code IS NULL
      AND worker_isolation_mode IN ('ONE_SHOT_SUBPROCESS_ISOLATED', 'EPHEMERAL_MICROVM_ISOLATED')
      AND buffer_disposal_method = 'SODIUM_MEMZERO_BEST_EFFORT_PLUS_PROCESS_EXIT'
      AND isolated_worker_terminated = TRUE
    )
    OR (
      execution_outcome = 'REFUSED_FAIL_CLOSED'
      AND refusal_reason_code IS NOT NULL
      AND identity_bytes_decrypted = 0
      AND generated_frames_emitted = 0
      AND consumed_claim_token IS NULL
      AND buffer_disposal_method = 'NO_PLAINTEXT_ALLOCATED'
    )
    OR (
      execution_outcome = 'ABORTED_ON_CONCURRENT_REVOCATION'
      AND refusal_reason_code IS NOT NULL
      AND generated_frames_emitted = 0
      AND isolated_worker_terminated = TRUE
    )
  );

-- Finding B: At most ONE executed receipt can ever exist per envelope_id!
CREATE UNIQUE INDEX uq_yie_single_execution_per_envelope
  ON yie_execution_receipts (envelope_id)
  WHERE execution_outcome = 'EXECUTED_EPHEMERAL_GOVERNED';

-- Finding B & C Finalization Trigger:
-- Verifies valid atomic claim_token, signing_key match, AND live upstream authority
-- currency at receipt finalization before marking envelope CONSUMED_SINGLE_USE!
CREATE OR REPLACE FUNCTION yie_finalize_execution_receipt_gate()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_env yie_authorization_envelopes%ROWTYPE;
BEGIN
  IF NEW.execution_outcome = 'EXECUTED_EPHEMERAL_GOVERNED' THEN
    SELECT * INTO v_env
    FROM yie_authorization_envelopes
    WHERE envelope_id = NEW.envelope_id
    FOR UPDATE;

    IF v_env.envelope_status <> 'CLAIMED_IN_FLIGHT' THEN
      RAISE EXCEPTION 'YIE_EXECUTION_WITHOUT_ATOMIC_CLAIM: envelope % has status=% (must be CLAIMED_IN_FLIGHT via yie_claim_single_use_envelope)',
        NEW.envelope_id, v_env.envelope_status
        USING ERRCODE = '23514';
    END IF;

    IF v_env.single_use_claim_token IS DISTINCT FROM NEW.consumed_claim_token THEN
      RAISE EXCEPTION 'YIE_CLAIM_TOKEN_MISMATCH: invalid claim token for envelope %',
        NEW.envelope_id
        USING ERRCODE = '23505';
    END IF;

    IF v_env.signing_key_id IS DISTINCT FROM NEW.verified_signing_key_id THEN
      RAISE EXCEPTION 'YIE_SIGNING_KEY_MISMATCH: envelope key % != receipt verified key %',
        v_env.signing_key_id, NEW.verified_signing_key_id
        USING ERRCODE = '23514';
    END IF;

    -- Finding C: Re-verify live upstream currency at the finalization boundary!
    PERFORM yie_assert_live_authority_currency(NEW.envelope_id, NEW.recorded_at);

    UPDATE yie_authorization_envelopes
    SET envelope_status = 'CONSUMED_SINGLE_USE',
        consumed_at     = NEW.recorded_at
    WHERE envelope_id = NEW.envelope_id;
  END IF;

  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_yie_finalize_execution_receipt_gate
AFTER INSERT ON yie_execution_receipts
FOR EACH ROW EXECUTE FUNCTION yie_finalize_execution_receipt_gate();

-- =============================================================================
-- 5. SECTION 04: LEAST-PRIVILEGE SERVICE ROLES, REVOKE PUBLIC & FORCE RLS
-- =============================================================================

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'yute_firewall_service') THEN
    CREATE ROLE yute_firewall_service NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOBYPASSRLS;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'yie_capability_service') THEN
    CREATE ROLE yie_capability_service NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOBYPASSRLS;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'yute_auditor_readonly') THEN
    CREATE ROLE yute_auditor_readonly NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOBYPASSRLS;
  END IF;
END;
$$;

-- Strip default PUBLIC table/function access in public schema
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO yute_firewall_service, yie_capability_service, yute_auditor_readonly;

-- YIE CAPABILITY SERVICE GRANTS (STRICT LEAST PRIVILEGE):
-- * ZERO access to source_assets (raw vault ciphertexts/keys stay in YUTE Vault!)
-- * ZERO INSERT/UPDATE/DELETE on YUTE consent, ceremony, decision, lease, or key tables!
-- * ZERO INSERT on yie_authorization_envelopes (YIE cannot mint its own envelopes!)
GRANT SELECT ON
  human_subjects,
  digital_rights_records,
  consent_ledger_grants,
  revocation_events,
  revocation_status_ledgers,
  adulthood_transitions,
  firewall_capability_leases,
  likeness_specifications,
  yute_firewall_signing_keys,
  clarity_disclosure_manifests,
  yie_authorization_envelopes
TO yie_capability_service;

GRANT UPDATE (envelope_status, claimed_at, claimed_by_worker_id, single_use_claim_token, consumed_at)
  ON yie_authorization_envelopes TO yie_capability_service;

GRANT SELECT, INSERT ON yie_execution_receipts TO yie_capability_service;

GRANT EXECUTE ON FUNCTION
  yie_assert_live_authority_currency(UUID, TIMESTAMPTZ),
  yie_claim_single_use_envelope(UUID, TEXT, TIMESTAMPTZ),
  yute_canonical_envelope_signing_preimage(UUID, TEXT, TEXT, UUID, UUID, UUID, TEXT, TEXT, TEXT, TEXT, TEXT, TEXT, TIMESTAMPTZ, TIMESTAMPTZ),
  yute_canonical_envelope_signing_sha256(UUID, TEXT, TEXT, UUID, UUID, UUID, TEXT, TEXT, TEXT, TEXT, TEXT, TEXT, TIMESTAMPTZ, TIMESTAMPTZ)
TO yie_capability_service, yute_firewall_service;

-- YUTE FIREWALL SERVICE GRANTS:
GRANT SELECT ON
  human_subjects,
  identity_passports,
  likeness_specifications,
  agreement_documents,
  contract_shield_findings,
  authorization_ceremonies,
  digital_rights_records,
  consent_ledger_grants,
  revocation_events,
  revocation_status_ledgers,
  adulthood_transitions,
  yute_firewall_signing_keys,
  yie_execution_receipts
TO yute_firewall_service;

GRANT SELECT, INSERT ON
  agency_firewall_decisions,
  firewall_capability_leases,
  yie_authorization_envelopes
TO yute_firewall_service;

GRANT UPDATE (lease_state, claim_deadline_at, first_payload_byte_flushed_at)
  ON firewall_capability_leases TO yute_firewall_service;

-- YUTE AUDITOR READONLY GRANTS (0 access to source_assets):
GRANT SELECT ON
  human_subjects,
  agreement_documents,
  contract_shield_findings,
  authorization_ceremonies,
  digital_rights_records,
  consent_ledger_grants,
  agency_firewall_decisions,
  firewall_capability_leases,
  revocation_events,
  revocation_status_ledgers,
  legal_retention_holds,
  adulthood_transitions,
  approval_ledger_entries,
  yute_firewall_signing_keys,
  yie_authorization_envelopes,
  yie_execution_receipts
TO yute_auditor_readonly;

-- Enable & FORCE Row-Level Security across all 16 sensitive authority/vault/YIE tables
-- (FORCE RLS ensures even a non-superuser table owner cannot bypass RLS policies!)
ALTER TABLE human_subjects              ENABLE ROW LEVEL SECURITY;
ALTER TABLE human_subjects              FORCE ROW LEVEL SECURITY;
ALTER TABLE identity_passports          ENABLE ROW LEVEL SECURITY;
ALTER TABLE identity_passports          FORCE ROW LEVEL SECURITY;
ALTER TABLE source_assets               ENABLE ROW LEVEL SECURITY;
ALTER TABLE source_assets               FORCE ROW LEVEL SECURITY;
ALTER TABLE likeness_specifications     ENABLE ROW LEVEL SECURITY;
ALTER TABLE likeness_specifications     FORCE ROW LEVEL SECURITY;
ALTER TABLE agreement_documents         ENABLE ROW LEVEL SECURITY;
ALTER TABLE agreement_documents         FORCE ROW LEVEL SECURITY;
ALTER TABLE authorization_ceremonies    ENABLE ROW LEVEL SECURITY;
ALTER TABLE authorization_ceremonies    FORCE ROW LEVEL SECURITY;
ALTER TABLE digital_rights_records      ENABLE ROW LEVEL SECURITY;
ALTER TABLE digital_rights_records      FORCE ROW LEVEL SECURITY;
ALTER TABLE consent_ledger_grants       ENABLE ROW LEVEL SECURITY;
ALTER TABLE consent_ledger_grants       FORCE ROW LEVEL SECURITY;
ALTER TABLE agency_firewall_decisions   ENABLE ROW LEVEL SECURITY;
ALTER TABLE agency_firewall_decisions   FORCE ROW LEVEL SECURITY;
ALTER TABLE firewall_capability_leases  ENABLE ROW LEVEL SECURITY;
ALTER TABLE firewall_capability_leases  FORCE ROW LEVEL SECURITY;
ALTER TABLE revocation_events           ENABLE ROW LEVEL SECURITY;
ALTER TABLE revocation_events           FORCE ROW LEVEL SECURITY;
ALTER TABLE revocation_status_ledgers   ENABLE ROW LEVEL SECURITY;
ALTER TABLE revocation_status_ledgers   FORCE ROW LEVEL SECURITY;
ALTER TABLE adulthood_transitions       ENABLE ROW LEVEL SECURITY;
ALTER TABLE adulthood_transitions       FORCE ROW LEVEL SECURITY;
ALTER TABLE yute_firewall_signing_keys  ENABLE ROW LEVEL SECURITY;
ALTER TABLE yute_firewall_signing_keys  FORCE ROW LEVEL SECURITY;
ALTER TABLE yie_authorization_envelopes ENABLE ROW LEVEL SECURITY;
ALTER TABLE yie_authorization_envelopes FORCE ROW LEVEL SECURITY;
ALTER TABLE yie_execution_receipts      ENABLE ROW LEVEL SECURITY;
ALTER TABLE yie_execution_receipts      FORCE ROW LEVEL SECURITY;

-- Subject-isolation RLS policies for yie_capability_service:
-- A YIE worker may ONLY read or record rows matching app.current_subject_id!
CREATE POLICY rls_yie_subject_scope_subjects ON human_subjects
  FOR SELECT TO yie_capability_service
  USING (subject_id = current_setting('app.current_subject_id', true));

CREATE POLICY rls_yie_subject_scope_rights ON digital_rights_records
  FOR SELECT TO yie_capability_service
  USING (subject_id = current_setting('app.current_subject_id', true));

CREATE POLICY rls_yie_subject_scope_grants ON consent_ledger_grants
  FOR SELECT TO yie_capability_service
  USING (subject_id = current_setting('app.current_subject_id', true));

CREATE POLICY rls_yie_subject_scope_rev_events ON revocation_events
  FOR SELECT TO yie_capability_service
  USING (subject_id = current_setting('app.current_subject_id', true));

CREATE POLICY rls_yie_subject_scope_rev_ledgers ON revocation_status_ledgers
  FOR SELECT TO yie_capability_service
  USING (subject_id = current_setting('app.current_subject_id', true));

CREATE POLICY rls_yie_subject_scope_adulthood ON adulthood_transitions
  FOR SELECT TO yie_capability_service
  USING (subject_id = current_setting('app.current_subject_id', true));

CREATE POLICY rls_yie_subject_scope_leases ON firewall_capability_leases
  FOR SELECT TO yie_capability_service
  USING (subject_id = current_setting('app.current_subject_id', true));

CREATE POLICY rls_yie_subject_scope_specs ON likeness_specifications
  FOR SELECT TO yie_capability_service
  USING (subject_id = current_setting('app.current_subject_id', true));

CREATE POLICY rls_yie_keys_read ON yute_firewall_signing_keys
  FOR SELECT TO yie_capability_service, yute_firewall_service, yute_auditor_readonly
  USING (true);

CREATE POLICY rls_yie_envelopes_select ON yie_authorization_envelopes
  FOR SELECT TO yie_capability_service
  USING (subject_id = current_setting('app.current_subject_id', true));

CREATE POLICY rls_yie_envelopes_claim_update ON yie_authorization_envelopes
  FOR UPDATE TO yie_capability_service
  USING (subject_id = current_setting('app.current_subject_id', true))
  WITH CHECK (subject_id = current_setting('app.current_subject_id', true));

CREATE POLICY rls_yie_receipts_select ON yie_execution_receipts
  FOR SELECT TO yie_capability_service
  USING (subject_id = current_setting('app.current_subject_id', true));

CREATE POLICY rls_yie_receipts_insert ON yie_execution_receipts
  FOR INSERT TO yie_capability_service
  WITH CHECK (subject_id = current_setting('app.current_subject_id', true));

-- Firewall & Auditor policies (scoped by subject context on firewall writes; read-all audit on auditor)
CREATE POLICY rls_firewall_envelopes_all ON yie_authorization_envelopes
  FOR ALL TO yute_firewall_service
  USING (subject_id = current_setting('app.current_subject_id', true))
  WITH CHECK (subject_id = current_setting('app.current_subject_id', true));

CREATE POLICY rls_auditor_envelopes_read ON yie_authorization_envelopes
  FOR SELECT TO yute_auditor_readonly
  USING (true);

CREATE POLICY rls_auditor_receipts_read ON yie_execution_receipts
  FOR SELECT TO yute_auditor_readonly
  USING (true);

COMMIT;
