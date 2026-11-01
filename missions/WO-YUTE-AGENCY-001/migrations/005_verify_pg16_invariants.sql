-- =============================================================================
-- Verification Suite: 005_verify_pg16_invariants.sql
-- Program:            WRASAL(TM) | YUTE OS x YIE(TM)
-- Milestone:          YUTE-OS-v003 | THE AUTHORITY PROOF (YUTE-ARCH-GOV-003)
-- Target DB:          PostgreSQL 16+
-- Purpose:            Executes 27 adversarial & positive authority-proof checks
--                     across migrations 001..004, including:
--                       * Checks 01..10: YUTE-PR8-REVIEW-001 (TEST-01..06, EGRESS-FENCE)
--                       * Checks 11..17: YUTE-ARCH-GOV-002 (@YIE-PROOF-001, @YIE-NEG-01..06)
--                       * Checks 18..27: YUTE-ARCH-GOV-003 (Audit 002 Findings A, B, C, D,
--                         Section 04 Least-Privilege DB Roles + FORCE RLS Subject Isolation,
--                         and Section 05 Authorized Fictional Execution + Replay/Revocation)
--                     Rolls back cleanly after emitting verification table.
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
  v_zuri_ceremony_id     UUID;
  v_nia_ceremony_id      UUID;
  v_founder_ceremony_id  UUID;
  v_declined_ceremony_id UUID;
  v_zuri_grant_id        UUID;
  v_nia_grant_id         UUID;
  v_nia_grant_rev_id     UUID;
  v_nia_allow_decision_id UUID;
  v_nia_allow_dec_2_id   UUID;
  v_nia_allow_dec_3_id   UUID;
  v_deny_decision_id     UUID;
  v_nia_lease_id         UUID;
  v_nia_lease_2_id       UUID;
  v_nia_lease_3_id       UUID;
  v_nia_passport_id      UUID;
  v_revocation_id        UUID;
  v_nia_revocation_id    UUID;
  v_valid_env_id         UUID := '11111111-2222-4333-8444-555555555501';
  v_supersede_env_id     UUID := '11111111-2222-4333-8444-555555555502';
  v_revoke_env_id        UUID := '11111111-2222-4333-8444-555555555503';
  v_test_env_id          UUID := '11111111-2222-4333-8444-555555555599';
  v_preimage_sha         TEXT;
  v_claim_token_1        UUID;
  v_claim_token_rev      UUID;
  v_visible_nia_rows     INTEGER;
  v_visible_own_rows     INTEGER;
  v_sqlstate             TEXT;
BEGIN
  -- Seed YUTE Firewall Ed25519 verify-only public key (Finding A)
  INSERT INTO yute_firewall_signing_keys (signing_key_id, ed25519_public_key_hex, key_status)
  VALUES ('YUTE-FW-ED25519-PRIMARY-001', repeat('9', 64), 'ACTIVE');

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

  -- Seed 5-stage ceremonies
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
  -- CHECKS 02-10: YUTE-PR8-REVIEW-001 INVARIANTS
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
    'ISSUED', '2026-11-01T12:00:55Z'
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

  -- Check 12 (@YIE-NEG-01): YIE attempts to self-authorize
  v_preimage_sha := yute_canonical_envelope_signing_sha256(
    v_test_env_id, 'YIE_INTERNAL_SELF_AUTH', 'YUTE-FW-ED25519-PRIMARY-001',
    v_nia_lease_id, v_nia_allow_decision_id, v_nia_grant_id,
    'SUBJ-FICT-NIA-CLARKE-001', 'DRP-FICT-NIA-STILLS-001', NULL,
    'VISUAL_LIKENESS_NAMED_PRODUCTION', 'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION',
    'PROD-FICT-HARBOR-LIGHT', '2026-11-01T12:00:00Z', '2026-11-01T12:00:45Z'
  );
  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO yie_authorization_envelopes (
      envelope_id, issuer_authority, signing_key_id, canonical_signing_payload_sha256,
      lease_id, decision_id, grant_id, subject_id, subject_age_class,
      approved_rights_record_id, permitted_yute_action, requested_yie_operation,
      named_purpose_scope, firewall_ed25519_signature, issued_at, expires_at
    ) VALUES (
      v_test_env_id, 'YIE_INTERNAL_SELF_AUTH', 'YUTE-FW-ED25519-PRIMARY-001', v_preimage_sha,
      v_nia_lease_id, v_nia_allow_decision_id, v_nia_grant_id,
      'SUBJ-FICT-NIA-CLARKE-001', 'ADULT_VERIFIED', 'DRP-FICT-NIA-STILLS-001',
      'VISUAL_LIKENESS_NAMED_PRODUCTION', 'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION',
      'PROD-FICT-HARBOR-LIGHT', repeat('a', 128), '2026-11-01T12:00:00Z', '2026-11-01T12:00:45Z'
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
  v_preimage_sha := yute_canonical_envelope_signing_sha256(
    v_test_env_id, 'YUTE_OS_AGENCY_FIREWALL', 'YUTE-FW-ED25519-PRIMARY-001',
    v_nia_lease_id, v_nia_allow_decision_id, v_nia_grant_id,
    'SUBJ-FICT-NIA-CLARKE-001', 'DRP-FICT-NIA-STILLS-001', NULL,
    'VISUAL_LIKENESS_NAMED_PRODUCTION', 'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION',
    'PROD-FICT-HARBOR-LIGHT', '2026-11-01T12:00:00Z', '2026-11-01T12:05:00Z'
  );
  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO yie_authorization_envelopes (
      envelope_id, signing_key_id, canonical_signing_payload_sha256,
      lease_id, decision_id, grant_id, subject_id, subject_age_class,
      approved_rights_record_id, permitted_yute_action, requested_yie_operation,
      named_purpose_scope, firewall_ed25519_signature, issued_at, expires_at
    ) VALUES (
      v_test_env_id, 'YUTE-FW-ED25519-PRIMARY-001', v_preimage_sha,
      v_nia_lease_id, v_nia_allow_decision_id, v_nia_grant_id,
      'SUBJ-FICT-NIA-CLARKE-001', 'ADULT_VERIFIED', 'DRP-FICT-NIA-STILLS-001',
      'VISUAL_LIKENESS_NAMED_PRODUCTION', 'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION',
      'PROD-FICT-HARBOR-LIGHT', repeat('a', 128), '2026-11-01T12:00:00Z', '2026-11-01T12:05:00Z'
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    '13-YIE-NEG-02-MAX-60S-TTL', 'YUTE-ADR-0011',
    'Reject YIE authorization envelope with TTL exceeding 60 seconds',
    '23514', v_sqlstate, v_sqlstate = '23514'
  );

  -- Check 14 (@YIE-NEG-03): Cross-subject YIE envelope splice
  v_preimage_sha := yute_canonical_envelope_signing_sha256(
    v_test_env_id, 'YUTE_OS_AGENCY_FIREWALL', 'YUTE-FW-ED25519-PRIMARY-001',
    v_nia_lease_id, v_nia_allow_decision_id, v_nia_grant_id,
    'SUBJ-FICT-ZURI-BENNETT-001', 'DRP-FICT-ZURI-VOCAL-MASTER-001', NULL,
    'VISUAL_LIKENESS_NAMED_PRODUCTION', 'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION',
    'PROD-FICT-HARBOR-LIGHT', '2026-11-01T12:00:00Z', '2026-11-01T12:00:45Z'
  );
  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO yie_authorization_envelopes (
      envelope_id, signing_key_id, canonical_signing_payload_sha256,
      lease_id, decision_id, grant_id, subject_id, subject_age_class,
      approved_rights_record_id, permitted_yute_action, requested_yie_operation,
      named_purpose_scope, firewall_ed25519_signature, issued_at, expires_at
    ) VALUES (
      v_test_env_id, 'YUTE-FW-ED25519-PRIMARY-001', v_preimage_sha,
      v_nia_lease_id, v_nia_allow_decision_id, v_nia_grant_id,
      'SUBJ-FICT-ZURI-BENNETT-001', 'ADULT_VERIFIED', 'DRP-FICT-ZURI-VOCAL-MASTER-001',
      'VISUAL_LIKENESS_NAMED_PRODUCTION', 'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION',
      'PROD-FICT-HARBOR-LIGHT', repeat('a', 128), '2026-11-01T12:00:00Z', '2026-11-01T12:00:45Z'
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    '14-YIE-NEG-03-CROSS-SUBJECT-ENVELOPE', 'YUTE-AGENCY-INV-002',
    'Reject YIE envelope attempting to use Subject B lease to process Subject A identity',
    '23503', v_sqlstate, v_sqlstate = '23503'
  );

  -- Seed Nia passport + both SUPERSEDED and PERFORMER_APPROVED likeness specs
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
  ) VALUES
    ('SPEC-FICT-NIA-OLD-v000',    'SUBJ-FICT-NIA-CLARKE-001', v_nia_passport_id, 'v000', '{}'::jsonb, '{}'::jsonb, repeat('e', 64), 'SUPERSEDED'),
    ('SPEC-FICT-NIA-ACTIVE-v001', 'SUBJ-FICT-NIA-CLARKE-001', v_nia_passport_id, 'v001', '{}'::jsonb, '{}'::jsonb, repeat('1', 64), 'PERFORMER_APPROVED'),
    ('SPEC-FICT-NIA-MUTABLE-v002','SUBJ-FICT-NIA-CLARKE-001', v_nia_passport_id, 'v002', '{}'::jsonb, '{}'::jsonb, repeat('2', 64), 'PERFORMER_APPROVED');

  -- Check 15 (@YIE-NEG-04 / @AC-16): Reject YIE envelope referencing a SUPERSEDED likeness_specification at issuance
  v_preimage_sha := yute_canonical_envelope_signing_sha256(
    v_test_env_id, 'YUTE_OS_AGENCY_FIREWALL', 'YUTE-FW-ED25519-PRIMARY-001',
    v_nia_lease_id, v_nia_allow_decision_id, v_nia_grant_id,
    'SUBJ-FICT-NIA-CLARKE-001', 'DRP-FICT-NIA-STILLS-001', 'SPEC-FICT-NIA-OLD-v000',
    'VISUAL_LIKENESS_NAMED_PRODUCTION', 'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION',
    'PROD-FICT-HARBOR-LIGHT', '2026-11-01T12:00:00Z', '2026-11-01T12:00:45Z'
  );
  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO yie_authorization_envelopes (
      envelope_id, signing_key_id, canonical_signing_payload_sha256,
      lease_id, decision_id, grant_id, subject_id, subject_age_class,
      approved_rights_record_id, active_likeness_spec_id, permitted_yute_action,
      requested_yie_operation, named_purpose_scope, firewall_ed25519_signature,
      issued_at, expires_at
    ) VALUES (
      v_test_env_id, 'YUTE-FW-ED25519-PRIMARY-001', v_preimage_sha,
      v_nia_lease_id, v_nia_allow_decision_id, v_nia_grant_id,
      'SUBJ-FICT-NIA-CLARKE-001', 'ADULT_VERIFIED', 'DRP-FICT-NIA-STILLS-001',
      'SPEC-FICT-NIA-OLD-v000', 'VISUAL_LIKENESS_NAMED_PRODUCTION',
      'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION', 'PROD-FICT-HARBOR-LIGHT',
      repeat('a', 128), '2026-11-01T12:00:00Z', '2026-11-01T12:00:45Z'
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

  -- =========================================================================
  -- CHECKS 18-27: YUTE-ARCH-GOV-003 (AUDIT 002 AUTHORITY PROOF HARDENING)
  -- =========================================================================

  -- Check 18 (@AUTH-PROOF-10): Valid signed fictional envelope claimed atomically & executed once
  v_preimage_sha := yute_canonical_envelope_signing_sha256(
    v_valid_env_id, 'YUTE_OS_AGENCY_FIREWALL', 'YUTE-FW-ED25519-PRIMARY-001',
    v_nia_lease_id, v_nia_allow_decision_id, v_nia_grant_id,
    'SUBJ-FICT-NIA-CLARKE-001', 'DRP-FICT-NIA-STILLS-001', 'SPEC-FICT-NIA-ACTIVE-v001',
    'VISUAL_LIKENESS_NAMED_PRODUCTION', 'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION',
    'PROD-FICT-HARBOR-LIGHT', '2026-11-01T12:00:00Z', '2026-11-01T12:00:45Z'
  );

  INSERT INTO yie_authorization_envelopes (
    envelope_id, signing_key_id, canonical_signing_payload_sha256,
    lease_id, decision_id, grant_id, subject_id, subject_age_class,
    approved_rights_record_id, active_likeness_spec_id, permitted_yute_action,
    requested_yie_operation, named_purpose_scope, firewall_ed25519_signature,
    issued_at, expires_at
  ) VALUES (
    v_valid_env_id, 'YUTE-FW-ED25519-PRIMARY-001', v_preimage_sha,
    v_nia_lease_id, v_nia_allow_decision_id, v_nia_grant_id,
    'SUBJ-FICT-NIA-CLARKE-001', 'ADULT_VERIFIED', 'DRP-FICT-NIA-STILLS-001',
    'SPEC-FICT-NIA-ACTIVE-v001', 'VISUAL_LIKENESS_NAMED_PRODUCTION',
    'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION', 'PROD-FICT-HARBOR-LIGHT',
    repeat('b', 128), '2026-11-01T12:00:00Z', '2026-11-01T12:00:45Z'
  );

  v_claim_token_1 := yie_claim_single_use_envelope(
    v_valid_env_id, 'yie-worker-ephemeral-01', '2026-11-01T12:00:10Z'
  );

  INSERT INTO yie_execution_receipts (
    subject_id, requested_rights_record_id, requested_yie_operation,
    requested_purpose_scope, invoked_by_actor, engine_capability_ready,
    envelope_id, consumed_claim_token, signature_verification_status,
    verified_signing_key_id, execution_outcome, identity_bytes_decrypted,
    generated_frames_emitted, worker_isolation_mode, buffer_disposal_method,
    isolated_worker_terminated, receipt_sha256, recorded_at
  ) VALUES (
    'SUBJ-FICT-NIA-CLARKE-001', 'DRP-FICT-NIA-STILLS-001',
    'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION', 'PROD-FICT-HARBOR-LIGHT',
    'actor:harbor_light_vfx', TRUE,
    v_valid_env_id, v_claim_token_1, 'VERIFIED_ED25519_OK',
    'YUTE-FW-ED25519-PRIMARY-001', 'EXECUTED_EPHEMERAL_GOVERNED', 4096,
    1, 'ONE_SHOT_SUBPROCESS_ISOLATED', 'SODIUM_MEMZERO_BEST_EFFORT_PLUS_PROCESS_EXIT',
    TRUE, repeat('0', 64), '2026-11-01T12:00:12Z'
  );

  INSERT INTO pg16_invariant_results VALUES (
    '18-AUTH-PROOF-10-AUTHORIZED-EXECUTION', 'YUTE-ARCH-GOV-003',
    'Valid signed fictional envelope is claimed once, verified live, and transitions to CONSUMED_SINGLE_USE',
    'CONSUMED_SINGLE_USE',
    (SELECT envelope_status FROM yie_authorization_envelopes WHERE envelope_id = v_valid_env_id),
    (SELECT envelope_status = 'CONSUMED_SINGLE_USE' FROM yie_authorization_envelopes WHERE envelope_id = v_valid_env_id)
  );

  -- Check 19 (Finding A): Tampered signing preimage digest or non-64-byte signature fails closed
  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO yie_authorization_envelopes (
      envelope_id, signing_key_id, canonical_signing_payload_sha256,
      lease_id, decision_id, grant_id, subject_id, subject_age_class,
      approved_rights_record_id, permitted_yute_action, requested_yie_operation,
      named_purpose_scope, firewall_ed25519_signature, issued_at, expires_at
    ) VALUES (
      v_test_env_id, 'YUTE-FW-ED25519-PRIMARY-001', repeat('0', 64),
      v_nia_lease_id, v_nia_allow_decision_id, v_nia_grant_id,
      'SUBJ-FICT-NIA-CLARKE-001', 'ADULT_VERIFIED', 'DRP-FICT-NIA-STILLS-001',
      'VISUAL_LIKENESS_NAMED_PRODUCTION', 'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION',
      'PROD-FICT-HARBOR-LIGHT', repeat('a', 128), '2026-11-01T12:00:00Z', '2026-11-01T12:00:45Z'
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    '19-FINDING-A-SIGNING-PREIMAGE-TAMPER', 'AUDIT-002-FINDING-A',
    'Reject envelope whose canonical_signing_payload_sha256 does not match deterministic preimage',
    '23514', v_sqlstate, v_sqlstate = '23514'
  );

  -- Check 20 (Finding A / @AUTH-PROOF-03): Forged signature status cannot execute
  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO yie_execution_receipts (
      subject_id, requested_rights_record_id, requested_yie_operation,
      requested_purpose_scope, invoked_by_actor, engine_capability_ready,
      envelope_id, consumed_claim_token, signature_verification_status,
      verified_signing_key_id, execution_outcome, identity_bytes_decrypted,
      generated_frames_emitted, worker_isolation_mode, buffer_disposal_method,
      isolated_worker_terminated, receipt_sha256
    ) VALUES (
      'SUBJ-FICT-NIA-CLARKE-001', 'DRP-FICT-NIA-STILLS-001',
      'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION', 'PROD-FICT-HARBOR-LIGHT',
      'actor:forged_caller', TRUE,
      v_valid_env_id, gen_random_uuid(), 'FAILED_FORGED_SIGNATURE',
      'YUTE-FW-ED25519-PRIMARY-001', 'EXECUTED_EPHEMERAL_GOVERNED', 512,
      1, 'ONE_SHOT_SUBPROCESS_ISOLATED', 'SODIUM_MEMZERO_BEST_EFFORT_PLUS_PROCESS_EXIT',
      TRUE, repeat('d', 64)
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    '20-FINDING-A-FORGED-SIG-BLOCKS-EXEC', 'AUDIT-002-FINDING-A',
    'Reject EXECUTED_EPHEMERAL_GOVERNED when signature_verification_status is FAILED_FORGED_SIGNATURE',
    '23514', v_sqlstate, v_sqlstate = '23514'
  );

  -- Check 21 (Finding B / @AUTH-PROOF-05): Atomic single-use claim blocks second worker / replay
  v_sqlstate := 'NO_ERROR';
  BEGIN
    PERFORM yie_claim_single_use_envelope(
      v_valid_env_id, 'yie-worker-concurrent-02', '2026-11-01T12:00:15Z'
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    '21-FINDING-B-SINGLE-USE-REPLAY-BLOCK', 'AUDIT-002-FINDING-B',
    'Block second worker from claiming an already claimed/consumed single-use envelope',
    '23505', v_sqlstate, v_sqlstate = '23505'
  );

  -- Check 22 (Finding C / @AUTH-PROOF-07): Envelope issued while spec PERFORMER_APPROVED,
  -- then spec transitions to SUPERSEDED before claim -> rejected at live execution gate!
  INSERT INTO agency_firewall_decisions (
    subject_id, requested_rights_record_id, requested_by_actor, execution_boundary,
    requested_action, requested_target_scope, matched_grant_id, outcome, audit_receipt_sha256
  ) VALUES (
    'SUBJ-FICT-NIA-CLARKE-001', 'DRP-FICT-NIA-STILLS-001',
    'actor:harbor_light_vfx', 'RENDER_ADAPTER',
    'VISUAL_LIKENESS_NAMED_PRODUCTION', 'PROD-FICT-HARBOR-LIGHT',
    v_nia_grant_id, 'ALLOW', md5('dec2') || md5('dec2b')
  ) RETURNING decision_id INTO v_nia_allow_dec_2_id;

  INSERT INTO firewall_capability_leases (
    decision_id, grant_id, subject_id, target_rights_record_id,
    permitted_action, named_target_scope, lease_token_sha256,
    lease_state, expires_at
  ) VALUES (
    v_nia_allow_dec_2_id, v_nia_grant_id, 'SUBJ-FICT-NIA-CLARKE-001',
    'DRP-FICT-NIA-STILLS-001', 'VISUAL_LIKENESS_NAMED_PRODUCTION',
    'PROD-FICT-HARBOR-LIGHT', md5('lease2') || md5('lease2b'),
    'ISSUED', '2026-11-01T12:00:55Z'
  ) RETURNING lease_id INTO v_nia_lease_2_id;

  v_preimage_sha := yute_canonical_envelope_signing_sha256(
    v_supersede_env_id, 'YUTE_OS_AGENCY_FIREWALL', 'YUTE-FW-ED25519-PRIMARY-001',
    v_nia_lease_2_id, v_nia_allow_dec_2_id, v_nia_grant_id,
    'SUBJ-FICT-NIA-CLARKE-001', 'DRP-FICT-NIA-STILLS-001', 'SPEC-FICT-NIA-MUTABLE-v002',
    'VISUAL_LIKENESS_NAMED_PRODUCTION', 'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION',
    'PROD-FICT-HARBOR-LIGHT', '2026-11-01T12:00:00Z', '2026-11-01T12:00:45Z'
  );

  INSERT INTO yie_authorization_envelopes (
    envelope_id, signing_key_id, canonical_signing_payload_sha256,
    lease_id, decision_id, grant_id, subject_id, subject_age_class,
    approved_rights_record_id, active_likeness_spec_id, permitted_yute_action,
    requested_yie_operation, named_purpose_scope, firewall_ed25519_signature,
    issued_at, expires_at
  ) VALUES (
    v_supersede_env_id, 'YUTE-FW-ED25519-PRIMARY-001', v_preimage_sha,
    v_nia_lease_2_id, v_nia_allow_dec_2_id, v_nia_grant_id,
    'SUBJ-FICT-NIA-CLARKE-001', 'ADULT_VERIFIED', 'DRP-FICT-NIA-STILLS-001',
    'SPEC-FICT-NIA-MUTABLE-v002', 'VISUAL_LIKENESS_NAMED_PRODUCTION',
    'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION', 'PROD-FICT-HARBOR-LIGHT',
    repeat('c', 128), '2026-11-01T12:00:00Z', '2026-11-01T12:00:45Z'
  );

  -- Post-issuance mutation: performer supersedes SPEC-FICT-NIA-MUTABLE-v002!
  UPDATE likeness_specifications
  SET status = 'SUPERSEDED'
  WHERE likeness_spec_id = 'SPEC-FICT-NIA-MUTABLE-v002';

  v_sqlstate := 'NO_ERROR';
  BEGIN
    PERFORM yie_claim_single_use_envelope(
      v_supersede_env_id, 'yie-worker-03', '2026-11-01T12:00:20Z'
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    '22-FINDING-C-POST-ISSUE-SPEC-SUPERSEDED', 'AUDIT-002-FINDING-C',
    'Reject previously valid envelope when likeness spec becomes SUPERSEDED before execution',
    '23514', v_sqlstate, v_sqlstate = '23514'
  );

  -- Check 23 (Finding C / @AUTH-PROOF-08): Envelope claimed while grant ACTIVE, then grant
  -- is REVOKED mid-flight -> receipt finalization boundary rejects commit fail-closed!
  INSERT INTO consent_ledger_grants (
    subject_id, agreement_id, ceremony_id, scoped_rights_record_id,
    subject_age_class, permitted_action, named_target_scope, authorized_territory,
    contractual_scope_json, voice_cloning_permitted, valid_from, valid_until
  ) VALUES (
    'SUBJ-FICT-NIA-CLARKE-001', 'AGR-FICT-HARBOR-LIGHT-001', v_nia_ceremony_id,
    'DRP-FICT-NIA-STILLS-001', 'ADULT_VERIFIED',
    'PHOTO_CAMPAIGN_DISPLAY', 'CAMPAIGN-HARBOR-POSTER', 'WORLDWIDE',
    '{"poster_only": true}'::jsonb, FALSE,
    '2026-11-01T00:00:00Z', '2028-11-01T00:00:00Z'
  ) RETURNING grant_id INTO v_nia_grant_rev_id;

  INSERT INTO agency_firewall_decisions (
    subject_id, requested_rights_record_id, requested_by_actor, execution_boundary,
    requested_action, requested_target_scope, matched_grant_id, outcome, audit_receipt_sha256
  ) VALUES (
    'SUBJ-FICT-NIA-CLARKE-001', 'DRP-FICT-NIA-STILLS-001',
    'actor:harbor_light_vfx', 'RENDER_ADAPTER',
    'PHOTO_CAMPAIGN_DISPLAY', 'CAMPAIGN-HARBOR-POSTER',
    v_nia_grant_rev_id, 'ALLOW', md5('dec3') || md5('dec3b')
  ) RETURNING decision_id INTO v_nia_allow_dec_3_id;

  INSERT INTO firewall_capability_leases (
    decision_id, grant_id, subject_id, target_rights_record_id,
    permitted_action, named_target_scope, lease_token_sha256,
    lease_state, expires_at
  ) VALUES (
    v_nia_allow_dec_3_id, v_nia_grant_rev_id, 'SUBJ-FICT-NIA-CLARKE-001',
    'DRP-FICT-NIA-STILLS-001', 'PHOTO_CAMPAIGN_DISPLAY',
    'CAMPAIGN-HARBOR-POSTER', md5('lease3') || md5('lease3b'),
    'ISSUED', '2026-11-01T12:00:55Z'
  ) RETURNING lease_id INTO v_nia_lease_3_id;

  v_preimage_sha := yute_canonical_envelope_signing_sha256(
    v_revoke_env_id, 'YUTE_OS_AGENCY_FIREWALL', 'YUTE-FW-ED25519-PRIMARY-001',
    v_nia_lease_3_id, v_nia_allow_dec_3_id, v_nia_grant_rev_id,
    'SUBJ-FICT-NIA-CLARKE-001', 'DRP-FICT-NIA-STILLS-001', 'SPEC-FICT-NIA-ACTIVE-v001',
    'PHOTO_CAMPAIGN_DISPLAY', 'YIE_PACKAGE_CLARITY_PROVENANCE',
    'CAMPAIGN-HARBOR-POSTER', '2026-11-01T12:00:00Z', '2026-11-01T12:00:45Z'
  );

  INSERT INTO yie_authorization_envelopes (
    envelope_id, signing_key_id, canonical_signing_payload_sha256,
    lease_id, decision_id, grant_id, subject_id, subject_age_class,
    approved_rights_record_id, active_likeness_spec_id, permitted_yute_action,
    requested_yie_operation, named_purpose_scope, firewall_ed25519_signature,
    issued_at, expires_at
  ) VALUES (
    v_revoke_env_id, 'YUTE-FW-ED25519-PRIMARY-001', v_preimage_sha,
    v_nia_lease_3_id, v_nia_allow_dec_3_id, v_nia_grant_rev_id,
    'SUBJ-FICT-NIA-CLARKE-001', 'ADULT_VERIFIED', 'DRP-FICT-NIA-STILLS-001',
    'SPEC-FICT-NIA-ACTIVE-v001', 'PHOTO_CAMPAIGN_DISPLAY',
    'YIE_PACKAGE_CLARITY_PROVENANCE', 'CAMPAIGN-HARBOR-POSTER',
    repeat('d', 128), '2026-11-01T12:00:00Z', '2026-11-01T12:00:45Z'
  );

  -- Claim succeeds at T=10s while grant is still ACTIVE:
  v_claim_token_rev := yie_claim_single_use_envelope(
    v_revoke_env_id, 'yie-worker-04', '2026-11-01T12:00:10Z'
  );

  -- At T=18s, Nia revokes the grant BEFORE worker finalizes execution receipt!
  UPDATE consent_ledger_grants SET grant_status = 'REVOKED' WHERE grant_id = v_nia_grant_rev_id;

  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO yie_execution_receipts (
      subject_id, requested_rights_record_id, requested_yie_operation,
      requested_purpose_scope, invoked_by_actor, engine_capability_ready,
      envelope_id, consumed_claim_token, signature_verification_status,
      verified_signing_key_id, execution_outcome, identity_bytes_decrypted,
      generated_frames_emitted, worker_isolation_mode, buffer_disposal_method,
      isolated_worker_terminated, receipt_sha256, recorded_at
    ) VALUES (
      'SUBJ-FICT-NIA-CLARKE-001', 'DRP-FICT-NIA-STILLS-001',
      'YIE_PACKAGE_CLARITY_PROVENANCE', 'CAMPAIGN-HARBOR-POSTER',
      'actor:harbor_light_vfx', TRUE,
      v_revoke_env_id, v_claim_token_rev, 'VERIFIED_ED25519_OK',
      'YUTE-FW-ED25519-PRIMARY-001', 'EXECUTED_EPHEMERAL_GOVERNED', 1024,
      1, 'ONE_SHOT_SUBPROCESS_ISOLATED', 'SODIUM_MEMZERO_BEST_EFFORT_PLUS_PROCESS_EXIT',
      TRUE, md5('rec_rev') || md5('rec_rev_b'), '2026-11-01T12:00:20Z'
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    '23-FINDING-C-FINALIZATION-REVOKED-GRANT', 'AUDIT-002-FINDING-C',
    'Reject receipt finalization when upstream grant was revoked after claim',
    '23514', v_sqlstate, v_sqlstate = '23514'
  );

  -- Check 24 (Finding D): Reject execution receipt lacking isolated one-shot worker termination
  v_sqlstate := 'NO_ERROR';
  BEGIN
    INSERT INTO yie_execution_receipts (
      subject_id, requested_rights_record_id, requested_yie_operation,
      requested_purpose_scope, invoked_by_actor, engine_capability_ready,
      envelope_id, consumed_claim_token, signature_verification_status,
      verified_signing_key_id, execution_outcome, identity_bytes_decrypted,
      generated_frames_emitted, worker_isolation_mode, buffer_disposal_method,
      isolated_worker_terminated, receipt_sha256, recorded_at
    ) VALUES (
      'SUBJ-FICT-NIA-CLARKE-001', 'DRP-FICT-NIA-STILLS-001',
      'YIE_PACKAGE_CLARITY_PROVENANCE', 'CAMPAIGN-HARBOR-POSTER',
      'actor:harbor_light_vfx', TRUE,
      v_revoke_env_id, v_claim_token_rev, 'VERIFIED_ED25519_OK',
      'YUTE-FW-ED25519-PRIMARY-001', 'EXECUTED_EPHEMERAL_GOVERNED', 1024,
      1, 'ONE_SHOT_SUBPROCESS_ISOLATED', 'SODIUM_MEMZERO_BEST_EFFORT_PLUS_PROCESS_EXIT',
      FALSE, md5('rec_iso') || md5('rec_iso_b'), '2026-11-01T12:00:20Z'
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  INSERT INTO pg16_invariant_results VALUES (
    '24-FINDING-D-WORKER-ISOLATION-REQUIRED', 'AUDIT-002-FINDING-D',
    'Reject execution receipt when isolated one-shot worker termination is FALSE',
    '23514', v_sqlstate, v_sqlstate = '23514'
  );

  -- Check 25 (Section 04 DB Role ACL): yie_capability_service CANNOT INSERT envelopes (42501)
  v_sqlstate := 'NO_ERROR';
  BEGIN
    SET LOCAL ROLE yie_capability_service;
    INSERT INTO yie_authorization_envelopes (
      envelope_id, signing_key_id, canonical_signing_payload_sha256,
      lease_id, decision_id, grant_id, subject_id, subject_age_class,
      approved_rights_record_id, permitted_yute_action, requested_yie_operation,
      named_purpose_scope, firewall_ed25519_signature, issued_at, expires_at
    ) VALUES (
      v_test_env_id, 'YUTE-FW-ED25519-PRIMARY-001', v_preimage_sha,
      v_nia_lease_id, v_nia_allow_decision_id, v_nia_grant_id,
      'SUBJ-FICT-NIA-CLARKE-001', 'ADULT_VERIFIED', 'DRP-FICT-NIA-STILLS-001',
      'VISUAL_LIKENESS_NAMED_PRODUCTION', 'YIE_SYNTHESIZE_GOVERNED_REPRESENTATION',
      'PROD-FICT-HARBOR-LIGHT', repeat('a', 128), '2026-11-01T12:00:00Z', '2026-11-01T12:00:45Z'
    );
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  RESET ROLE;
  INSERT INTO pg16_invariant_results VALUES (
    '25-SEC04-YIE-ROLE-CANNOT-MINT-ENVELOPE', 'AUDIT-002-SEC-04',
    'Deny yie_capability_service DB role INSERT privilege on yie_authorization_envelopes',
    '42501', v_sqlstate, v_sqlstate = '42501'
  );

  -- Check 26 (Section 04 DB Role Vault Fence): yie_capability_service has ZERO access to source_assets
  v_sqlstate := 'NO_ERROR';
  BEGIN
    SET LOCAL ROLE yie_capability_service;
    PERFORM count(*) FROM source_assets;
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE;
  END;
  RESET ROLE;
  INSERT INTO pg16_invariant_results VALUES (
    '26-SEC04-YIE-ROLE-ZERO-VAULT-ACCESS', 'AUDIT-002-SEC-04',
    'Deny yie_capability_service DB role SELECT privilege on YUTE Vault source_assets',
    '42501', v_sqlstate, v_sqlstate = '42501'
  );

  -- Check 27 (Section 04 RLS Subject Isolation): yie_capability_service bound to Zuri sees 0 Nia rows
  PERFORM set_config('app.current_subject_id', 'SUBJ-FICT-ZURI-BENNETT-001', true);
  SET LOCAL ROLE yie_capability_service;
  SELECT count(*) INTO v_visible_nia_rows
  FROM yie_authorization_envelopes
  WHERE subject_id = 'SUBJ-FICT-NIA-CLARKE-001';
  RESET ROLE;

  PERFORM set_config('app.current_subject_id', 'SUBJ-FICT-NIA-CLARKE-001', true);
  SET LOCAL ROLE yie_capability_service;
  SELECT count(*) INTO v_visible_own_rows
  FROM yie_authorization_envelopes
  WHERE subject_id = 'SUBJ-FICT-NIA-CLARKE-001';
  RESET ROLE;

  INSERT INTO pg16_invariant_results VALUES (
    '27-SEC04-YIE-RLS-SUBJECT-ISOLATION', 'AUDIT-002-SEC-04',
    'Enforce RLS subject isolation for yie_capability_service (0 cross-subject rows visible)',
    '0_CROSS_3_OWN',
    v_visible_nia_rows::text || '_CROSS_' || v_visible_own_rows::text || '_OWN',
    (v_visible_nia_rows = 0 AND v_visible_own_rows = 3)
  );
END;
$$;

SELECT * FROM pg16_invariant_results ORDER BY test_id;

ROLLBACK;
