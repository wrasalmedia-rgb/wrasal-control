-- =============================================================================
-- Verification Suite: 003_verify_pg16_invariants.sql
-- Program:            WRASAL(TM) | YUTE OS
-- Work Order:         WO-YUTE-AGENCY-001 (YUTE-PR8-REVIEW-001 Remediation)
-- Target DB:          PostgreSQL 16+
-- Purpose:            Adversarial SQL invariant suite verifying positive fictional
--                     Zuri Bennett flow and fail-closed rejection of TEST-01,
--                     TEST-04, TEST-05, TEST-06 (YUTE-AGENCY-INV-002), 5-stage
--                     consent ordering, and 4-axis revocation constraints.
--                     Rolls back test rows cleanly at completion.
-- =============================================================================

BEGIN;

CREATE TEMP TABLE pg16_invariant_results (
  test_id        TEXT PRIMARY KEY,
  invariant_ref  TEXT NOT NULL,
  description    TEXT NOT NULL,
  expected_state TEXT NOT NULL,
  observed_state TEXT NOT NULL,
  passed         BOOLEAN NOT NULL
);

DO $$
DECLARE
  v_zuri_ceremony_id UUID;
  v_declined_ceremony_id UUID;
  v_zuri_grant_id UUID;
  v_allow_decision_id UUID;
  v_deny_decision_id UUID;
  v_revocation_id UUID;
  v_sqlstate TEXT;
BEGIN
  -- Seed fictional subjects A (Zuri Bennett) and B (Nia Clarke)
  INSERT INTO human_subjects (subject_id, legal_or_stage_name, jurisdiction_country, age_protection_class, status)
  VALUES
    ('SUBJ-FICT-ZURI-BENNETT-001', 'Zuri Bennett (Fictional)', 'JM', 'ADULT_VERIFIED', 'CONSENTED_ACTIVE'),
    ('SUBJ-FICT-NIA-CLARKE-001',   'Nia Clarke (Fictional)',   'US', 'ADULT_VERIFIED', 'CONSENTED_ACTIVE');

  -- Seed fictional agreements for Subject A and Subject B
  INSERT INTO agreement_documents (
    agreement_id, subject_id, counterparty_name, document_title,
    original_upload_sha256, canonical_text_utf8, canonical_text_sha256
  ) VALUES
    (
      'AGR-FICT-SINGLE-DIST-001', 'SUBJ-FICT-ZURI-BENNETT-001',
      'SoundBridge Digital Distribution Ltd. (Fictional)',
      'Single Recording Distribution Schedule - Kingston Rain',
      repeat('a', 64),
      'Clause 1.1 - Scoped Single-Performance Distribution. Clause 2.2 - Reserved Vocal Rights.',
      repeat('b', 64)
    ),
    (
      'AGR-FICT-HARBOR-LIGHT-001', 'SUBJ-FICT-NIA-CLARKE-001',
      'Meridian Harbor Pictures LLC (Fictional)',
      'Performer Visual Reference Schedule',
      repeat('c', 64),
      'Section 1. Named Production Grant for PROD-FICT-HARBOR-LIGHT only.',
      repeat('d', 64)
    );

  -- Seed fictional Digital Rights Passport assets
  INSERT INTO digital_rights_records (
    rights_record_id, subject_id, asset_or_data_category,
    external_platform_or_holder, rights_posture, evidence_agreement_id, evidence_status
  ) VALUES
    (
      'DRP-FICT-ZURI-VOCAL-MASTER-001', 'SUBJ-FICT-ZURI-BENNETT-001',
      'MUSICAL_PERFORMANCE_MASTER', 'SoundBridge Digital (Fictional)',
      'LICENSED_OUT_SCOPED', 'AGR-FICT-SINGLE-DIST-001', 'VERIFIED_EVIDENCE'
    ),
    (
      'DRP-FICT-NIA-STILLS-001', 'SUBJ-FICT-NIA-CLARKE-001',
      'VISUAL_LIKENESS', 'Meridian Harbor Pictures (Fictional)',
      'LICENSED_OUT_SCOPED', 'AGR-FICT-HARBOR-LIGHT-001', 'VERIFIED_EVIDENCE'
    );

  -- Seed valid 5-stage ceremony for Subject A (Zuri): PRESENTED -> ACKNOWLEDGED -> EXPLAINED -> DECIDED -> AUTHORIZED
  INSERT INTO authorization_ceremonies (
    subject_id, agreement_id, canonical_text_sha256, guard_analysis_snapshot_sha256,
    verified_signer_actor_id, signer_authority_basis, signer_verification_method,
    signer_subject_match_verified, presented_at, acknowledged_at, explained_at,
    counsel_referral_offered, decided_at, decision_outcome, authorized_at,
    record_preservation_permitted, ceremony_receipt_sha256
  ) VALUES (
    'SUBJ-FICT-ZURI-BENNETT-001', 'AGR-FICT-SINGLE-DIST-001', repeat('b', 64), repeat('e', 64),
    'actor:zuri_bennett_fict', 'SELF_ADULT_SUBJECT', 'PASSKEY_WEBAUTHN_ATTESTED',
    TRUE,
    '2026-10-31T12:00:00Z', '2026-10-31T12:02:00Z', '2026-10-31T12:05:00Z',
    TRUE, '2026-10-31T12:08:00Z', 'DECIDED_TO_AUTHORIZE', '2026-10-31T12:09:00Z',
    TRUE, repeat('1', 64)
  ) RETURNING ceremony_id INTO v_zuri_ceremony_id;

  -- Seed valid grant for Subject A (Zuri)
  INSERT INTO consent_ledger_grants (
    subject_id, agreement_id, ceremony_id, scoped_rights_record_id,
    subject_age_class, permitted_action, named_target_scope, authorized_territory,
    contractual_scope_json, voice_cloning_permitted, valid_from, valid_until
  ) VALUES (
    'SUBJ-FICT-ZURI-BENNETT-001', 'AGR-FICT-SINGLE-DIST-001', v_zuri_ceremony_id,
    'DRP-FICT-ZURI-VOCAL-MASTER-001', 'ADULT_VERIFIED',
    'PERFORMANCE_DISTRIBUTION_NAMED_TRACK', 'TRACK-FICT-KINGSTON-RAIN-001', 'WORLDWIDE_STREAMING',
    '{"single_track_only": true, "synthetic_voice": false}'::jsonb, FALSE,
    '2026-11-01T00:00:00Z', '2028-05-01T00:00:00Z'
  ) RETURNING grant_id INTO v_zuri_grant_id;

  -- Record DENY decision for producer synthetic voice request (YUTE-OS-v003 Proof)
  INSERT INTO agency_firewall_decisions (
    subject_id, requested_rights_record_id, requested_by_actor, execution_boundary,
    requested_action, requested_target_scope, requires_voice_synthesis,
    matched_grant_id, outcome, denial_reason_code, missing_permissions,
    protected_assets_released, audit_receipt_sha256
  ) VALUES (
    'SUBJ-FICT-ZURI-BENNETT-001', 'DRP-FICT-ZURI-VOCAL-MASTER-001',
    'actor:producer_vance_keller', 'HTTP_API',
    'GENERATE_SYNTHETIC_VOICE_PERFORMANCE', 'TRACK-FICT-NEON-REMIX-999', TRUE,
    NULL, 'DENY', 'VOICE_SYNTHESIS_AND_TARGET_OUT_OF_SCOPE',
    '["VOICE_CLONING_NOT_AUTHORIZED", "TARGET_OUTSIDE_NAMED_SCOPE:TRACK-FICT-KINGSTON-RAIN-001"]'::jsonb,
    FALSE, repeat('2', 64)
  ) RETURNING decision_id INTO v_deny_decision_id;

  INSERT INTO pg16_invariant_results VALUES (
    'PG16-BASELINE-V003', 'YUTE-OS-v003',
    'Valid Zuri ceremony, single-track grant, and fail-closed synthetic-voice DENY receipt persist cleanly',
    'COMMITTED', 'COMMITTED', TRUE
  );

  -- =========================================================================
  -- ADVERSARIAL CHECK 1 (TEST-06 / YUTE-AGENCY-INV-002):
  -- Attempt to attach Subject A (Zuri) valid ceremony to Subject B (Nia) grant!
  -- =========================================================================
  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO consent_ledger_grants (
      subject_id, agreement_id, ceremony_id, scoped_rights_record_id,
      subject_age_class, permitted_action, named_target_scope, authorized_territory,
      contractual_scope_json, valid_from, valid_until
    ) VALUES (
      'SUBJ-FICT-NIA-CLARKE-001', 'AGR-FICT-HARBOR-LIGHT-001', v_zuri_ceremony_id,
      'DRP-FICT-NIA-STILLS-001', 'ADULT_VERIFIED',
      'VISUAL_LIKENESS_NAMED_PRODUCTION', 'PROD-FICT-HARBOR-LIGHT', 'WORLDWIDE',
      '{}'::jsonb, '2026-11-01T00:00:00Z', '2028-11-01T00:00:00Z'
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    'PG16-TEST-06-CROSS-SUBJECT-CEREMONY', 'YUTE-AGENCY-INV-002',
    'Reject attaching Subject A ceremony_id to Subject B consent_ledger_grants row',
    '23503', v_sqlstate, v_sqlstate = '23503'
  );

  -- =========================================================================
  -- ADVERSARIAL CHECK 2 (YUTE-AGENCY-INV-002 CROSS-PURPOSE FIREWALL ALLOW):
  -- Attempt to record an ALLOW firewall decision binding Zuri distribution grant
  -- to an unauthorized GENERATE_SYNTHETIC_VOICE_PERFORMANCE action!
  -- =========================================================================
  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO agency_firewall_decisions (
      subject_id, requested_rights_record_id, requested_by_actor, execution_boundary,
      requested_action, requested_target_scope, requires_voice_synthesis,
      matched_grant_id, outcome, audit_receipt_sha256
    ) VALUES (
      'SUBJ-FICT-ZURI-BENNETT-001', 'DRP-FICT-ZURI-VOCAL-MASTER-001',
      'actor:producer_vance_keller', 'RENDER_ADAPTER',
      'GENERATE_SYNTHETIC_VOICE_PERFORMANCE', 'TRACK-FICT-KINGSTON-RAIN-001', TRUE,
      v_zuri_grant_id, 'ALLOW', repeat('3', 64)
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    'PG16-TEST-06B-CROSS-PURPOSE-ALLOW', 'YUTE-AGENCY-INV-002',
    'Reject ALLOW firewall decision whose action differs from matched grant permitted_action',
    '23503', v_sqlstate, v_sqlstate = '23503'
  );

  -- =========================================================================
  -- ADVERSARIAL CHECK 3 (YUTE-AGENCY-INV-002 CROSS-SUBJECT ASSET LEASE):
  -- Attempt to associate Subject B asset with Subject A firewall decision!
  -- =========================================================================
  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO agency_firewall_decisions (
      subject_id, requested_rights_record_id, requested_by_actor, execution_boundary,
      requested_action, requested_target_scope, matched_grant_id, outcome, audit_receipt_sha256
    ) VALUES (
      'SUBJ-FICT-ZURI-BENNETT-001', 'DRP-FICT-NIA-STILLS-001',
      'actor:rogue_worker', 'BACKGROUND_WORKER',
      'PERFORMANCE_DISTRIBUTION_NAMED_TRACK', 'TRACK-FICT-KINGSTON-RAIN-001',
      v_zuri_grant_id, 'ALLOW', repeat('4', 64)
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    'PG16-TEST-06C-CROSS-ASSET-SUBJECT', 'YUTE-AGENCY-INV-002',
    'Reject firewall decision associating Subject B asset with Subject A identity/grant',
    '23503', v_sqlstate, v_sqlstate = '23503'
  );

  -- =========================================================================
  -- ADVERSARIAL CHECK 4 (SECTION 03: FIVE-STAGE CONSENT ORDER & DECLINED CHOICE):
  -- Ensure DECLINED ceremony is valid on its own, but CANNOT back a grant!
  -- =========================================================================
  INSERT INTO authorization_ceremonies (
    subject_id, agreement_id, canonical_text_sha256, guard_analysis_snapshot_sha256,
    verified_signer_actor_id, signer_authority_basis, signer_verification_method,
    signer_subject_match_verified, presented_at, acknowledged_at, explained_at,
    counsel_referral_offered, decided_at, decision_outcome, authorized_at,
    record_preservation_permitted, ceremony_receipt_sha256
  ) VALUES (
    'SUBJ-FICT-NIA-CLARKE-001', 'AGR-FICT-HARBOR-LIGHT-001', repeat('d', 64), repeat('f', 64),
    'actor:nia_clarke_fict', 'SELF_ADULT_SUBJECT', 'PASSKEY_WEBAUTHN_ATTESTED',
    TRUE,
    '2026-10-31T13:00:00Z', '2026-10-31T13:01:00Z', '2026-10-31T13:04:00Z',
    TRUE, '2026-10-31T13:06:00Z', 'DECLINED', NULL,
    TRUE, repeat('5', 64)
  ) RETURNING ceremony_id INTO v_declined_ceremony_id;

  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO consent_ledger_grants (
      subject_id, agreement_id, ceremony_id, scoped_rights_record_id,
      subject_age_class, permitted_action, named_target_scope, authorized_territory,
      contractual_scope_json, valid_from, valid_until
    ) VALUES (
      'SUBJ-FICT-NIA-CLARKE-001', 'AGR-FICT-HARBOR-LIGHT-001', v_declined_ceremony_id,
      'DRP-FICT-NIA-STILLS-001', 'ADULT_VERIFIED',
      'VISUAL_LIKENESS_NAMED_PRODUCTION', 'PROD-FICT-HARBOR-LIGHT', 'WORLDWIDE',
      '{}'::jsonb, '2026-11-01T00:00:00Z', '2028-11-01T00:00:00Z'
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    'PG16-CONSENT-DECLINED-BLOCKS-GRANT', 'SECTION-03-5-STAGE',
    'Reject ConsentLedger grant backed by a ceremony whose human decision_outcome was DECLINED',
    '23514', v_sqlstate, v_sqlstate = '23514'
  );

  -- =========================================================================
  -- ADVERSARIAL CHECK 5 (TEST-01: NULL BYPASS & IMMUTABILITY TRIGGER):
  -- =========================================================================
  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO consent_ledger_grants (
      subject_id, agreement_id, ceremony_id, scoped_rights_record_id,
      subject_age_class, permitted_action, named_target_scope, authorized_territory,
      contractual_scope_json, autonomous_persona_allowed, valid_from, valid_until
    ) VALUES (
      'SUBJ-FICT-ZURI-BENNETT-001', 'AGR-FICT-SINGLE-DIST-001', v_zuri_ceremony_id,
      'DRP-FICT-ZURI-VOCAL-MASTER-001', 'ADULT_VERIFIED',
      'PERFORMANCE_DISTRIBUTION_NAMED_TRACK', 'TRACK-2', 'WORLDWIDE',
      '{}'::jsonb, NULL, '2026-11-01T00:00:00Z', '2028-05-01T00:00:00Z'
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    'PG16-TEST-01-NULL-CHECK-BYPASS', 'FORENSIC-A',
    'Reject NULL insertion into CHECK-constrained autonomous_persona_allowed column',
    '23502', v_sqlstate, v_sqlstate = '23502'
  );

  v_sqlstate := 'NO_ERROR';
  BEGIN
    DELETE FROM agency_firewall_decisions WHERE decision_id = v_deny_decision_id;
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    'PG16-TEST-04-IMMUTABLE-AUDIT-TRIGGER', 'TEST-04',
    'Block DELETE on append-only agency_firewall_decisions ledger',
    'P0001', v_sqlstate, v_sqlstate = 'P0001'
  );

  -- =========================================================================
  -- ADVERSARIAL CHECK 6 (FINDING 03 & REFINEMENT 3.B: EGRESS & 4-AXIS REVOCATION):
  -- =========================================================================
  INSERT INTO agency_firewall_decisions (
    subject_id, requested_rights_record_id, requested_by_actor, execution_boundary,
    requested_action, requested_target_scope, matched_grant_id, outcome, audit_receipt_sha256
  ) VALUES (
    'SUBJ-FICT-ZURI-BENNETT-001', 'DRP-FICT-ZURI-VOCAL-MASTER-001',
    'actor:distributor_worker', 'RENDER_ADAPTER',
    'PERFORMANCE_DISTRIBUTION_NAMED_TRACK', 'TRACK-FICT-KINGSTON-RAIN-001',
    v_zuri_grant_id, 'ALLOW', repeat('6', 64)
  ) RETURNING decision_id INTO v_allow_decision_id;

  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO firewall_capability_leases (
      decision_id, grant_id, subject_id, target_rights_record_id,
      permitted_action, named_target_scope, lease_token_sha256,
      lease_state, first_payload_byte_flushed_at, expires_at
    ) VALUES (
      v_allow_decision_id, v_zuri_grant_id, 'SUBJ-FICT-ZURI-BENNETT-001',
      'DRP-FICT-ZURI-VOCAL-MASTER-001', 'PERFORMANCE_DISTRIBUTION_NAMED_TRACK',
      'TRACK-FICT-KINGSTON-RAIN-001', repeat('7', 64),
      'COMMITTED_EXTERNAL_EGRESS', NULL, '2026-10-31T12:15:00Z'
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    'PG16-FINDING-03-EGRESS-TIMESTAMP', 'EGRESS-FENCE-v001',
    'Reject COMMITTED_EXTERNAL_EGRESS state lacking Point-of-Irrevocable-Egress timestamp',
    '23514', v_sqlstate, v_sqlstate = '23514'
  );

  INSERT INTO revocation_events (
    subject_id, initiated_by, revocation_basis, reason, vault_disposition
  ) VALUES (
    'SUBJ-FICT-ZURI-BENNETT-001', 'actor:zuri_bennett_fict',
    'SUBJECT_WITHDRAWAL', 'Fictional revocation drill', 'ELIGIBLE_DATA_CRYPTO_SHRED'
  ) RETURNING revocation_id INTO v_revocation_id;

  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO revocation_status_ledgers (
      revocation_id, grant_id, subject_id, had_prior_external_distribution,
      downstream_notification_status, confirmed_deletion_status, external_deletion_receipt_sha256
    ) VALUES (
      v_revocation_id, v_zuri_grant_id, 'SUBJ-FICT-ZURI-BENNETT-001', TRUE,
      'DISPATCHED_UNCONFIRMED', 'EXTERNAL_DELETION_CONFIRMED_WITH_RECEIPT', NULL
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    'PG16-REFINEMENT-3B-NO-FAKE-DELETION', 'REFINEMENT-3B',
    'Reject claiming EXTERNAL_DELETION_CONFIRMED_WITH_RECEIPT without acknowledged receipt',
    '23514', v_sqlstate, v_sqlstate = '23514'
  );

  -- =========================================================================
  -- ADVERSARIAL CHECK 7 (TEST-04: TWO-STEWARD HOLD QUORUM):
  -- =========================================================================
  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO legal_retention_holds (
      subject_id, target_record_ref, hold_category, legal_citation_basis,
      approved_by_steward_a, approved_by_steward_b, expires_or_reviews_at
    ) VALUES (
      'SUBJ-FICT-ZURI-BENNETT-001', 'ACCOUNTING-001', 'STATUTORY_TAX_ACCOUNTING',
      'Statutory 7-year accounting receipt rule',
      'steward:same_person', 'steward:same_person', '2033-10-31T00:00:00Z'
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    'PG16-TEST-04-TWO-STEWARD-QUORUM', 'FORENSIC-E',
    'Reject legal retention hold signed twice by the same steward',
    '23514', v_sqlstate, v_sqlstate = '23514'
  );
END;
$$;

SELECT * FROM pg16_invariant_results ORDER BY test_id;

ROLLBACK;
