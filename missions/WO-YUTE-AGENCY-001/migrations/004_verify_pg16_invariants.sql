-- =============================================================================
-- Verification Suite: 004_verify_pg16_invariants.sql
-- Program:            WRASAL(TM) | YUTE OS x YIE(TM)
-- Work Order:         WO-YUTE-AGENCY-001 (YUTE-PR8-REVIEW-001 + YUTE-ARCH-GOV-002)
-- Target DB:          PostgreSQL 16+
-- Purpose:            Executes 17 adversarial SQL invariant checks across
--                     migrations 001, 002, and 003 (including @YIE-PROOF-001,
--                     @YIE-NEG-01..06, TEST-01..06, 5-stage consent, EGRESS-FENCE,
--                     and Founder/Builder protection parity). Rolls back cleanly.
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
  v_nia_ceremony_id UUID;
  v_founder_ceremony_id UUID;
  v_declined_ceremony_id UUID;
  v_zuri_grant_id UUID;
  v_nia_grant_id UUID;
  v_founder_grant_id UUID;
  v_allow_decision_id UUID;
  v_nia_allow_decision_id UUID;
  v_deny_decision_id UUID;
  v_zuri_lease_id UUID;
  v_nia_lease_id UUID;
  v_nia_passport_id UUID;
  v_revocation_id UUID;
  v_sqlstate TEXT;
BEGIN
  -- Seed fictional subjects: Zuri Bennett, Nia Clarke, and Founder/Builder Steward
  INSERT INTO human_subjects (subject_id, legal_or_stage_name, jurisdiction_country, age_protection_class, is_builder_steward, status)
  VALUES
    ('SUBJ-FICT-ZURI-BENNETT-001',    'Zuri Bennett (Fictional)',    'JM', 'ADULT_VERIFIED', FALSE, 'CONSENTED_ACTIVE'),
    ('SUBJ-FICT-NIA-CLARKE-001',      'Nia Clarke (Fictional)',      'US', 'ADULT_VERIFIED', FALSE, 'CONSENTED_ACTIVE'),
    ('SUBJ-FICT-FOUNDER-STEWARD-001', 'Founder Steward (Fictional)', 'JM', 'ADULT_VERIFIED', TRUE,  'CONSENTED_ACTIVE');

  -- Seed fictional agreements
  INSERT INTO agreement_documents (
    agreement_id, subject_id, counterparty_name, document_title,
    original_upload_sha256, canonical_text_utf8, canonical_text_sha256
  ) VALUES
    (
      'AGR-FICT-SINGLE-DIST-001', 'SUBJ-FICT-ZURI-BENNETT-001',
      'SoundBridge Digital Distribution Ltd. (Fictional)',
      'Single Recording Distribution Schedule - Kingston Rain',
      repeat('a', 64), 'Clause 1.1 Single Track Distribution Only.', repeat('b', 64)
    ),
    (
      'AGR-FICT-HARBOR-LIGHT-001', 'SUBJ-FICT-NIA-CLARKE-001',
      'Meridian Harbor Pictures LLC (Fictional)',
      'Performer Visual Reference Schedule',
      repeat('c', 64), 'Section 1. Named Production Grant for PROD-FICT-HARBOR-LIGHT only.', repeat('d', 64)
    ),
    (
      'AGR-FICT-FOUNDER-KEYNOTE-001', 'SUBJ-FICT-FOUNDER-STEWARD-001',
      'WRASAL Studio Archive (Fictional)',
      'Founder Self-Sovereign Keynote Likeness Schedule',
      repeat('e', 64), 'Section 1. Keynote Archival Frame Only.', repeat('f', 64)
    );

  -- Seed Digital Rights Passport records
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
    ),
    (
      'DRP-FICT-FOUNDER-PORTRAIT-001', 'SUBJ-FICT-FOUNDER-STEWARD-001',
      'VISUAL_LIKENESS', 'YUTE Vault Custody',
      'OWNED_BY_SUBJECT', 'AGR-FICT-FOUNDER-KEYNOTE-001', 'VERIFIED_EVIDENCE'
    );

  -- Seed 5-stage ceremonies (PRESENTED -> ACKNOWLEDGED -> EXPLAINED -> DECIDED -> AUTHORIZED)
  INSERT INTO authorization_ceremonies (
    subject_id, agreement_id, canonical_text_sha256, guard_analysis_snapshot_sha256,
    verified_signer_actor_id, signer_authority_basis, signer_verification_method,
    signer_subject_match_verified, presented_at, acknowledged_at, explained_at,
    counsel_referral_offered, decided_at, decision_outcome, authorized_at,
    record_preservation_permitted, ceremony_receipt_sha256
  ) VALUES (
    'SUBJ-FICT-ZURI-BENNETT-001', 'AGR-FICT-SINGLE-DIST-001', repeat('b', 64), repeat('1', 64),
    'actor:zuri_bennett_fict', 'SELF_ADULT_SUBJECT', 'PASSKEY_WEBAUTHN_ATTESTED',
    TRUE, '2026-10-31T12:00:00Z', '2026-10-31T12:02:00Z', '2026-10-31T12:05:00Z',
    TRUE, '2026-10-31T12:08:00Z', 'DECIDED_TO_AUTHORIZE', '2026-10-31T12:09:00Z',
    TRUE, repeat('1', 64)
  ) RETURNING ceremony_id INTO v_zuri_ceremony_id;

  INSERT INTO authorization_ceremonies (
    subject_id, agreement_id, canonical_text_sha256, guard_analysis_snapshot_sha256,
    verified_signer_actor_id, signer_authority_basis, signer_verification_method,
    signer_subject_match_verified, presented_at, acknowledged_at, explained_at,
    counsel_referral_offered, decided_at, decision_outcome, authorized_at,
    record_preservation_permitted, ceremony_receipt_sha256
  ) VALUES (
    'SUBJ-FICT-NIA-CLARKE-001', 'AGR-FICT-HARBOR-LIGHT-001', repeat('d', 64), repeat('2', 64),
    'actor:nia_clarke_fict', 'SELF_ADULT_SUBJECT', 'PASSKEY_WEBAUTHN_ATTESTED',
    TRUE, '2026-10-31T12:10:00Z', '2026-10-31T12:12:00Z', '2026-10-31T12:15:00Z',
    TRUE, '2026-10-31T12:18:00Z', 'DECIDED_TO_AUTHORIZE', '2026-10-31T12:19:00Z',
    TRUE, repeat('2', 64)
  ) RETURNING ceremony_id INTO v_nia_ceremony_id;

  -- Seed valid grants for Zuri & Nia
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

  INSERT INTO consent_ledger_grants (
    subject_id, agreement_id, ceremony_id, scoped_rights_record_id,
    subject_age_class, permitted_action, named_target_scope, authorized_territory,
    contractual_scope_json, voice_cloning_permitted, valid_from, valid_until
  ) VALUES (
    'SUBJ-FICT-NIA-CLARKE-001', 'AGR-FICT-HARBOR-LIGHT-001', v_nia_ceremony_id,
    'DRP-FICT-NIA-STILLS-001', 'ADULT_VERIFIED',
    'VISUAL_LIKENESS_NAMED_PRODUCTION', 'PROD-FICT-HARBOR-LIGHT', 'WORLDWIDE',
    '{"named_film_only": true}'::jsonb, FALSE,
    '2026-11-01T00:00:00Z', '2028-11-01T00:00:00Z'
  ) RETURNING grant_id INTO v_nia_grant_id;

  -- Record DENY decision for Zuri producer synthetic-voice request (YUTE-OS-v003)
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
    FALSE, repeat('3', 64)
  ) RETURNING decision_id INTO v_deny_decision_id;

  INSERT INTO pg16_invariant_results VALUES (
    '01-PG16-BASELINE-V003', 'YUTE-OS-v003',
    'Valid Zuri ceremony, single-track grant, and fail-closed synthetic-voice DENY receipt persist cleanly',
    'COMMITTED', 'COMMITTED', TRUE
  );

  -- =========================================================================
  -- CHECKS 02-04: TEST-06 / YUTE-AGENCY-INV-002 CROSS-SUBJECT & PURPOSE SPLICES
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
    '02-TEST-06-CROSS-SUBJECT-CEREMONY', 'YUTE-AGENCY-INV-002',
    'Reject attaching Subject A ceremony_id to Subject B consent_ledger_grants row',
    '23503', v_sqlstate, v_sqlstate = '23503'
  );

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
      v_zuri_grant_id, 'ALLOW', repeat('4', 64)
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    '03-TEST-06B-CROSS-PURPOSE-ALLOW', 'YUTE-AGENCY-INV-002',
    'Reject ALLOW firewall decision whose action differs from matched grant permitted_action',
    '23503', v_sqlstate, v_sqlstate = '23503'
  );

  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO agency_firewall_decisions (
      subject_id, requested_rights_record_id, requested_by_actor, execution_boundary,
      requested_action, requested_target_scope, matched_grant_id, outcome, audit_receipt_sha256
    ) VALUES (
      'SUBJ-FICT-ZURI-BENNETT-001', 'DRP-FICT-NIA-STILLS-001',
      'actor:rogue_worker', 'BACKGROUND_WORKER',
      'PERFORMANCE_DISTRIBUTION_NAMED_TRACK', 'TRACK-FICT-KINGSTON-RAIN-001',
      v_zuri_grant_id, 'ALLOW', repeat('5', 64)
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    '04-TEST-06C-CROSS-ASSET-SUBJECT', 'YUTE-AGENCY-INV-002',
    'Reject firewall decision associating Subject B asset with Subject A identity/grant',
    '23503', v_sqlstate, v_sqlstate = '23503'
  );

  -- =========================================================================
  -- CHECKS 05-10: 5-STAGE CONSENT, NULL BYPASS, IMMUTABILITY, EGRESS, 4-AXIS, QUORUM
  -- =========================================================================
  INSERT INTO authorization_ceremonies (
    subject_id, agreement_id, canonical_text_sha256, guard_analysis_snapshot_sha256,
    verified_signer_actor_id, signer_authority_basis, signer_verification_method,
    signer_subject_match_verified, presented_at, acknowledged_at, explained_at,
    counsel_referral_offered, decided_at, decision_outcome, authorized_at,
    record_preservation_permitted, ceremony_receipt_sha256
  ) VALUES (
    'SUBJ-FICT-NIA-CLARKE-001', 'AGR-FICT-HARBOR-LIGHT-001', repeat('d', 64), repeat('6', 64),
    'actor:nia_clarke_fict', 'SELF_ADULT_SUBJECT', 'PASSKEY_WEBAUTHN_ATTESTED',
    TRUE, '2026-10-31T13:00:00Z', '2026-10-31T13:01:00Z', '2026-10-31T13:04:00Z',
    TRUE, '2026-10-31T13:06:00Z', 'DECLINED', NULL,
    TRUE, repeat('6', 64)
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
    '05-CONSENT-DECLINED-BLOCKS-GRANT', 'SECTION-03-5-STAGE',
    'Reject ConsentLedger grant backed by a ceremony whose human decision_outcome was DECLINED',
    '23514', v_sqlstate, v_sqlstate = '23514'
  );

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
    '06-TEST-01-NULL-CHECK-BYPASS', 'FORENSIC-A',
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
    '07-TEST-04-IMMUTABLE-AUDIT-TRIGGER', 'TEST-04',
    'Block DELETE on append-only agency_firewall_decisions ledger',
    'P0001', v_sqlstate, v_sqlstate = 'P0001'
  );

  -- Create valid ALLOW + Capability Lease for Nia's authorized production PROD-FICT-HARBOR-LIGHT
  INSERT INTO agency_firewall_decisions (
    subject_id, requested_rights_record_id, requested_by_actor, execution_boundary,
    requested_action, requested_target_scope, matched_grant_id, outcome, audit_receipt_sha256
  ) VALUES (
    'SUBJ-FICT-NIA-CLARKE-001', 'DRP-FICT-NIA-STILLS-001',
    'actor:harbor_light_vfx', 'RENDER_ADAPTER',
    'VISUAL_LIKENESS_NAMED_PRODUCTION', 'PROD-FICT-HARBOR-LIGHT',
    v_nia_grant_id, 'ALLOW', repeat('7', 64)
  ) RETURNING decision_id INTO v_nia_allow_decision_id;

  INSERT INTO firewall_capability_leases (
    decision_id, grant_id, subject_id, target_rights_record_id,
    permitted_action, named_target_scope, lease_token_sha256,
    lease_state, expires_at
  ) VALUES (
    v_nia_allow_decision_id, v_nia_grant_id, 'SUBJ-FICT-NIA-CLARKE-001',
    'DRP-FICT-NIA-STILLS-001', 'VISUAL_LIKENESS_NAMED_PRODUCTION',
    'PROD-FICT-HARBOR-LIGHT', repeat('8', 64),
    'ISSUED', '2026-11-01T12:00:45Z'
  ) RETURNING lease_id INTO v_nia_lease_id;

  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO firewall_capability_leases (
      decision_id, grant_id, subject_id, target_rights_record_id,
      permitted_action, named_target_scope, lease_token_sha256,
      lease_state, first_payload_byte_flushed_at, expires_at
    ) VALUES (
      v_nia_allow_decision_id, v_nia_grant_id, 'SUBJ-FICT-NIA-CLARKE-001',
      'DRP-FICT-NIA-STILLS-001', 'VISUAL_LIKENESS_NAMED_PRODUCTION',
      'PROD-FICT-HARBOR-LIGHT', repeat('9', 64),
      'COMMITTED_EXTERNAL_EGRESS', NULL, '2026-11-01T12:00:45Z'
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    '08-FINDING-03-EGRESS-TIMESTAMP', 'EGRESS-FENCE-v001',
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
    '09-REFINEMENT-3B-NO-FAKE-DELETION', 'REFINEMENT-3B',
    'Reject claiming EXTERNAL_DELETION_CONFIRMED_WITH_RECEIPT without acknowledged receipt',
    '23514', v_sqlstate, v_sqlstate = '23514'
  );

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
    '10-TEST-04-TWO-STEWARD-QUORUM', 'FORENSIC-E',
    'Reject legal retention hold signed twice by the same steward',
    '23514', v_sqlstate, v_sqlstate = '23514'
  );

  -- =========================================================================
  -- CHECKS 11-17: YUTE x YIE IDENTITY AUTHORIZATION CONTRACT v001 (ADR-0011)
  -- =========================================================================

  -- Check 11 (@YIE-PROOF-001): Engine is capable (engine_capability_ready=TRUE),
  -- but request lacks envelope -> YIE cannot execute and MUST record REFUSED_FAIL_CLOSED!
  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO yie_execution_receipts (
      subject_id, requested_rights_record_id, requested_yie_operation,
      requested_purpose_scope, invoked_by_actor, engine_capability_ready,
      envelope_id, execution_outcome, identity_bytes_decrypted,
      generated_frames_emitted, receipt_sha256
    ) VALUES (
      'SUBJ-FICT-NIA-CLARKE-001', 'DRP-FICT-NIA-STILLS-001',
      'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION', 'AD-BRAND-SOLAR-COLA',
      'actor:ad_campaign_producer', TRUE,
      NULL, 'EXECUTED_EPHEMERAL_GOVERNED', 1024, 1, repeat('a', 64)
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;

  -- Also verify the valid fail-closed refusal receipt persists cleanly with engine_capability_ready=TRUE!
  INSERT INTO yie_execution_receipts (
    subject_id, requested_rights_record_id, requested_yie_operation,
    requested_purpose_scope, invoked_by_actor, engine_capability_ready,
    envelope_id, execution_outcome, refusal_reason_code,
    identity_bytes_decrypted, generated_frames_emitted, receipt_sha256
  ) VALUES (
    'SUBJ-FICT-NIA-CLARKE-001', 'DRP-FICT-NIA-STILLS-001',
    'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION', 'AD-BRAND-SOLAR-COLA',
    'actor:ad_campaign_producer', TRUE,
    NULL, 'REFUSED_FAIL_CLOSED', 'MISSING_OR_DENIED_YUTE_AUTHORIZATION',
    0, 0, repeat('b', 64)
  );
  INSERT INTO pg16_invariant_results VALUES (
    '11-YIE-PROOF-001-CAPABLE-BUT-REFUSED', 'YUTE-ADR-0011',
    'YIE refuses unauthorized synthesis even when engine_capability_ready=TRUE (0 bytes, 0 frames)',
    '23514', v_sqlstate, v_sqlstate = '23514'
  );

  -- Check 12 (@YIE-NEG-01): YIE attempts to self-authorize (issuer_authority = YIE_INTERNAL)
  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO yie_authorization_envelopes (
      issuer_authority, lease_id, decision_id, grant_id, subject_id, subject_age_class,
      approved_rights_record_id, permitted_yute_action, requested_yie_operation,
      named_purpose_scope, firewall_ed25519_signature, issued_at, expires_at
    ) VALUES (
      'YIE_INTERNAL_SELF_AUTH', v_nia_lease_id, v_nia_allow_decision_id, v_nia_grant_id,
      'SUBJ-FICT-NIA-CLARKE-001', 'ADULT_VERIFIED', 'DRP-FICT-NIA-STILLS-001',
      'VISUAL_LIKENESS_NAMED_PRODUCTION', 'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION',
      'PROD-FICT-HARBOR-LIGHT', 'sig:forged', '2026-11-01T12:00:00Z', '2026-11-01T12:00:45Z'
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    '12-YIE-NEG-01-NO-SELF-AUTHORIZATION', 'YUTE-ADR-0011',
    'Reject YIE envelope where issuer_authority is anything other than YUTE_OS_AGENCY_FIREWALL',
    '23514', v_sqlstate, v_sqlstate = '23514'
  );

  -- Check 13 (@YIE-NEG-02): Envelope TTL exceeds 60 seconds
  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO yie_authorization_envelopes (
      lease_id, decision_id, grant_id, subject_id, subject_age_class,
      approved_rights_record_id, permitted_yute_action, requested_yie_operation,
      named_purpose_scope, firewall_ed25519_signature, issued_at, expires_at
    ) VALUES (
      v_nia_lease_id, v_nia_allow_decision_id, v_nia_grant_id,
      'SUBJ-FICT-NIA-CLARKE-001', 'ADULT_VERIFIED', 'DRP-FICT-NIA-STILLS-001',
      'VISUAL_LIKENESS_NAMED_PRODUCTION', 'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION',
      'PROD-FICT-HARBOR-LIGHT', 'sig:valid_fmt', '2026-11-01T12:00:00Z', '2026-11-01T12:05:00Z'
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    '13-YIE-NEG-02-MAX-60S-TTL', 'YUTE-ADR-0011',
    'Reject YIE authorization envelope with TTL exceeding 60 seconds',
    '23514', v_sqlstate, v_sqlstate = '23514'
  );

  -- Check 14 (@YIE-NEG-03): Cross-subject YIE envelope splice (Nia lease -> Zuri subject/asset)
  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO yie_authorization_envelopes (
      lease_id, decision_id, grant_id, subject_id, subject_age_class,
      approved_rights_record_id, permitted_yute_action, requested_yie_operation,
      named_purpose_scope, firewall_ed25519_signature, issued_at, expires_at
    ) VALUES (
      v_nia_lease_id, v_nia_allow_decision_id, v_nia_grant_id,
      'SUBJ-FICT-ZURI-BENNETT-001', 'ADULT_VERIFIED', 'DRP-FICT-ZURI-VOCAL-MASTER-001',
      'VISUAL_LIKENESS_NAMED_PRODUCTION', 'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION',
      'PROD-FICT-HARBOR-LIGHT', 'sig:valid_fmt', '2026-11-01T12:00:00Z', '2026-11-01T12:00:45Z'
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    '14-YIE-NEG-03-CROSS-SUBJECT-ENVELOPE', 'YUTE-AGENCY-INV-002',
    'Reject YIE envelope attempting to use Subject B lease to process Subject A identity',
    '23503', v_sqlstate, v_sqlstate = '23503'
  );

  -- Check 15 (@YIE-NEG-04 / @AC-16): Reject YIE envelope referencing a SUPERSEDED likeness_specification
  INSERT INTO identity_passports (
    subject_id, subject_age_class_snapshot, consent_version, consent_status,
    revocation_procedure, human_approver_name, signed_document_sha256, valid_until
  ) VALUES (
    'SUBJ-FICT-NIA-CLARKE-001', 'ADULT_VERIFIED', 'v001', 'GRANTED_SCOPED',
    'RPP-v001', 'Nia Clarke (Fictional)', repeat('d', 64), '2028-11-01T00:00:00Z'
  ) RETURNING passport_id INTO v_nia_passport_id;

  INSERT INTO likeness_specifications (
    likeness_spec_id, subject_id, passport_id, spec_version,
    identity_lock_payload, expression_map_payload, manifest_sha256, status
  ) VALUES (
    'SPEC-FICT-NIA-OLD-v000', 'SUBJ-FICT-NIA-CLARKE-001', v_nia_passport_id, 'v000',
    '{}'::jsonb, '{}'::jsonb, repeat('e', 64), 'SUPERSEDED'
  );

  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO yie_authorization_envelopes (
      lease_id, decision_id, grant_id, subject_id, subject_age_class,
      approved_rights_record_id, active_likeness_spec_id, permitted_yute_action,
      requested_yie_operation, named_purpose_scope, firewall_ed25519_signature,
      issued_at, expires_at
    ) VALUES (
      v_nia_lease_id, v_nia_allow_decision_id, v_nia_grant_id,
      'SUBJ-FICT-NIA-CLARKE-001', 'ADULT_VERIFIED', 'DRP-FICT-NIA-STILLS-001',
      'SPEC-FICT-NIA-OLD-v000', 'VISUAL_LIKENESS_NAMED_PRODUCTION',
      'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION', 'PROD-FICT-HARBOR-LIGHT',
      'sig:valid_fmt', '2026-11-01T12:00:00Z', '2026-11-01T12:00:45Z'
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    '15-YIE-NEG-04-SUPERSEDED-SPEC-AC16', 'AC-16-HUMAN-GROWTH',
    'Reject YIE envelope referencing a SUPERSEDED likeness specification',
    '23514', v_sqlstate, v_sqlstate = '23514'
  );

  -- Check 16 (@YIE-NEG-05): Reject admin_override_attempted=TRUE execution in YIE
  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO yie_execution_receipts (
      subject_id, requested_rights_record_id, requested_yie_operation,
      requested_purpose_scope, invoked_by_actor, actor_has_admin_privilege,
      admin_override_attempted, engine_capability_ready, envelope_id,
      execution_outcome, receipt_sha256
    ) VALUES (
      'SUBJ-FICT-NIA-CLARKE-001', 'DRP-FICT-NIA-STILLS-001',
      'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION', 'PROD-FICT-HARBOR-LIGHT',
      'actor:root_admin_engineer', TRUE, TRUE, TRUE, NULL,
      'EXECUTED_EPHEMERAL_GOVERNED', repeat('c', 64)
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    '16-YIE-NEG-05-NO-ADMIN-OVERRIDE', 'SECTION-05-BUILDER',
    'Reject admin_override_attempted=TRUE from executing likeness processing in YIE',
    '23514', v_sqlstate, v_sqlstate = '23514'
  );

  -- Check 17 (@YIE-NEG-06): Founder/Builder own likeness receives identical fail-closed protection
  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO yie_execution_receipts (
      subject_id, is_builder_steward_subject, requested_rights_record_id,
      requested_yie_operation, requested_purpose_scope, invoked_by_actor,
      engine_capability_ready, envelope_id, execution_outcome, receipt_sha256
    ) VALUES (
      'SUBJ-FICT-FOUNDER-STEWARD-001', TRUE, 'DRP-FICT-FOUNDER-PORTRAIT-001',
      'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION', 'UNAPPROVED-PROMO-AD',
      'actor:internal_marketing', TRUE, NULL,
      'EXECUTED_EPHEMERAL_GOVERNED', repeat('f', 64)
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    '17-YIE-NEG-06-FOUNDER-LIKENESS-PARITY', 'SECTION-05-BUILDER',
    'Enforce identical fail-closed YIE protection on Founder/Builder own AI likeness',
    '23514', v_sqlstate, v_sqlstate = '23514'
  );
END;
$$;

SELECT * FROM pg16_invariant_results ORDER BY test_id;

ROLLBACK;
