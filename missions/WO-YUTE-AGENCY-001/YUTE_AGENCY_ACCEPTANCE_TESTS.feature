# Deliverable: YUTE_AGENCY_ACCEPTANCE_TESTS.feature
# Work Order: WO-YUTE-AGENCY-001 (YUTE Guard + Agency Firewall + Evidence Vault)
# Governing ADR & Review: decisions/YUTE-ADR-0010.md & YUTE-PR8-REVIEW-001
# Milestone: YUTE-OS-v003 | AGENCY FIREWALL PROOF
# Constitutional Doctrine: concepts/YUTE-FOUNDATION-DOCTRINE-001.md (v002.2)
# Standalone Migrations: missions/WO-YUTE-AGENCY-001/migrations/001..003_*.sql
# Version: v001.2
# Created: 2026-10-31
# Target Runner: Cucumber-Ruby (cucumber >= 9.0) against YUTE OS Ruby 3.3 / PostgreSQL 16 (v003)
# Data Policy: Uses 100% fictional test agreements & synthetic subjects (Zero real personal data)
# Status: PG 16.4 DDL & SQL INVARIANTS VERIFIED / RUBY 3.3 RUNTIME PENDING YUTE-ADR-0010 RATIFICATION

Feature: YUTE Guard, Five-Stage Consent Process, Cross-Subject Integrity & Agency Firewall Proof
  As a human being using YUTE ("KNOW BEFORE YOU AGREE. CONTROL WHAT YOU AUTHORIZE. PRESERVE THE EVIDENCE.")
  I need verified clause citations, honest 5-stage consent process evidence, composite cross-subject integrity, and fail-closed authorization
  So that my agency remains non-negotiable wherever YUTE has technical and legal authority.

  Background:
    Given YUTE OS enforces constitutional invariants "YUTE-AGENCY-INV-001" and "YUTE-AGENCY-INV-002"
    And standalone migrations "001_yute_mvp_core.sql" and "002_yute_agency_foundation.sql" are applied on PostgreSQL 16
    And test scenarios use strictly fictional agreements and synthetic subjects

  # ============================================================================
  # FIRST RUNTIME DEMONSTRATION: YUTE-OS-v003 | AGENCY FIREWALL PROOF (TEST-05)
  # ============================================================================
  @YUTE-OS-v003-PROOF @TEST-05 @p0 @agency-firewall
  Scenario: Young recording artist authorizes single performance distribution and Agency Firewall denies synthetic voice generation with five proof artifacts
    Given fictional emerging recording artist "SUBJ-FICT-ZURI-BENNETT-001" uploads agreement "AGR-FICT-SINGLE-DIST-001" to "YUTE GUARD"
    When "Yute::ContractShield" analyzes "AGR-FICT-SINGLE-DIST-001"
    Then "01_contract_analysis.json" cites Clause "1.1" authorizing distribution of single track "TRACK-FICT-KINGSTON-RAIN-001" and Clause "2.2" reserving synthetic voice rights
    When "SUBJ-FICT-ZURI-BENNETT-001" completes the five-stage ceremony "CEREMONY-ZURI-001" in order "PRESENTED -> ACKNOWLEDGED -> EXPLAINED -> DECIDED -> AUTHORIZED"
    Then "Yute::ConsentLedger" registers "GRANT-ZURI-001" and emits "02_consent_record.json" with "voice_cloning_permitted" set to "false" and "comprehension_epistemic_status" set to "PROCESS_EVIDENCE_ONLY_NOT_MIND_PROOF"
    When fictional producer "actor:producer_vance_keller" submits "03_generation_request.json" ("REQ-SYNTH-VOICE-001") requesting "GENERATE_SYNTHETIC_VOICE_PERFORMANCE"
    Then "Yute::AgencyFirewall" denies the operation and emits "04_firewall_decision.json" with outcome "DENY" and missing permission "VOICE_CLONING_NOT_AUTHORIZED"
    And "Yute::EvidenceVault" emits "05_audit_receipt.json" recording "protected_assets_released: false" and "vault_bytes_decrypted: 0"

  # ============================================================================
  # CONSTITUTIONAL INVARIANT TEST: YUTE-AGENCY-INV-001 (TEST-05)
  # ============================================================================
  @YUTE-AGENCY-INV-001 @TEST-05 @p0 @constitutional
  Scenario: Deny synthetic-voice advertisement when performer contract authorizes only visual likeness in one named production
    Given fictional adult performer "SUBJ-FICT-NIA-CLARKE-001" completes five-stage ceremony "CEREMONY-NIA-001" for "AGR-FICT-HARBOR-LIGHT-001"
    And "Yute::ConsentLedger" records grant "GRANT-NIA-001" for asset "DRP-FICT-NIA-STILLS-001" with:
      | permitted_action          | VISUAL_LIKENESS_NAMED_PRODUCTION |
      | named_target_scope        | PROD-FICT-HARBOR-LIGHT           |
      | voice_cloning_permitted   | false                            |
      | advertising_permitted     | false                            |
      | sublicensing_permitted    | false                            |
    When production user "actor:ad_campaign_producer" requests action "GENERATE_SYNTHETIC_VOICE_AD" for "SUBJ-FICT-NIA-CLARKE-001" under campaign "AD-BRAND-SOLAR-COLA"
    Then "Yute::AgencyFirewall" returns outcome "DENY" with reason code "OUT_OF_AUTHORIZED_SCOPE"
    And the denial receipt enumerates missing permissions:
      | missing_permission                                      |
      | VOICE_CLONING_NOT_AUTHORIZED                            |
      | ADVERTISING_USE_NOT_AUTHORIZED                          |
      | TARGET_OUTSIDE_NAMED_SCOPE:PROD-FICT-HARBOR-LIGHT       |
    And "Yute::EvidenceVault" records "protected_assets_released" as "false"
    And zero identity, audio, or visual assets reach any rendering provider

  # ============================================================================
  # TEST-06 & YUTE-AGENCY-INV-002: CROSS-SUBJECT & CROSS-PURPOSE AUTHORITY CHAIN
  # ============================================================================
  @TEST-06 @YUTE-AGENCY-INV-002 @p0 @cross-subject-integrity
  Scenario Outline: Reject transferring ceremonies, agreements, assets, or grants across subjects or purposes via DB association
    Given valid five-stage ceremony "CEREMONY-ZURI-001" and grant "GRANT-ZURI-001" exist for Subject A "SUBJ-FICT-ZURI-BENNETT-001"
    And valid agreement "AGR-FICT-HARBOR-LIGHT-001" and asset "DRP-FICT-NIA-STILLS-001" exist for Subject B "SUBJ-FICT-NIA-CLARKE-001"
    When a caller attempts "<cross_association_attempt>"
    Then both "Yute::AgencyFirewall" and PostgreSQL 16 reject the operation fail-closed with "<expected_rejection>"
    And no cross-subject or cross-purpose permission or capability lease is created

    Examples:
      | cross_association_attempt                                                             | expected_rejection                        |
      | attach Subject A ceremony CEREMONY-ZURI-001 to Subject B grant on Nia Clarke          | DENY / PG::ForeignKeyViolation (23503)    |
      | attach Subject B asset DRP-FICT-NIA-STILLS-001 to Subject A firewall ALLOW decision   | DENY / PG::ForeignKeyViolation (23503)    |
      | bind Zuri track-distribution grant to a synthetic-voice ALLOW firewall decision       | DENY / PG::ForeignKeyViolation (23503)    |

  # ============================================================================
  # TEST-01 & FORENSIC-A: AUTHORIZATION BYPASS ACROSS ALL BOUNDARIES
  # ============================================================================
  @TEST-01 @FORENSIC-A @boundary-enforcement
  Scenario Outline: Block NULL SQL bypasses and block API, CLI, worker, and adapter access without a valid capability lease
    Given protected vocal master "DRP-FICT-ZURI-VOCAL-MASTER-001" is stored in encrypted custody
    When an operation at boundary "<boundary>" attempts to "<attempt>" without a valid active "FirewallCapabilityLease"
    Then the operation fails closed with "<expected_error>"
    And zero plaintext bytes leave custody

    Examples:
      | boundary          | attempt                                                      | expected_error                      |
      | DATABASE_SQL      | INSERT NULL into autonomous_persona_allowed                  | PG::NotNullViolation (23502)        |
      | HTTP_API          | fetch protected master stream without capability lease       | Yute::MissingCapabilityLeaseError   |
      | CLI_COMMAND       | export asset via CLI bypassing HTTP middleware               | Yute::MissingCapabilityLeaseError   |
      | BACKGROUND_WORKER | call SourceAssetVault#open_plaintext_stream directly         | Yute::MissingCapabilityLeaseError   |
      | RENDER_ADAPTER    | dispatch external synthesis call with expired or forged lease | Yute::InvalidOrExpiredLeaseError   |

  # ============================================================================
  # SECTION 03 & REFINEMENT 3.A: FIVE-STAGE CONSENT PROCESS (HASH != CONSENT)
  # ============================================================================
  @REFINEMENT-3A @SECTION-03 @consent-process
  Scenario: Enforce PRESENTED -> ACKNOWLEDGED -> EXPLAINED -> DECIDED -> AUTHORIZED order and block grants from DECLINED ceremonies
    Given agreement "AGR-FICT-HARBOR-LIGHT-001" is presented to "SUBJ-FICT-NIA-CLARKE-001"
    When "SUBJ-FICT-NIA-CLARKE-001" completes presentation, acknowledgment, and explanation and chooses "DECLINED"
    Then the "DECLINED" ceremony receipt is preserved with "authorized_at" as null
    And attempting to register a "ConsentLedger" grant from that "DECLINED" ceremony fails closed with SQLSTATE "23514"
    And the system records "comprehension_epistemic_status" strictly as "PROCESS_EVIDENCE_ONLY_NOT_MIND_PROOF"

  # ============================================================================
  # TEST-02, FINDING 03 & REFINEMENT 3.B: EGRESS ORDERING & 4-AXIS REVOCATION
  # ============================================================================
  @TEST-02 @EGRESS-FENCE-v001 @REFINEMENT-3B @FORENSIC-C @revocation-race
  Scenario: Enforce Point of Irrevocable Egress ordering under concurrent revocation and forbid unconfirmed external deletion claims
    Given worker thread A holds lease "LEASE-RACE-01" on "GRANT-ZURI-001" and approaches "T2_CLAIM" ("SELECT ... FOR UPDATE") before socket flush
    When concurrent thread B commits a signed revocation from "SUBJ-FICT-ZURI-BENNETT-001" prior to "first_payload_byte_flushed_at"
    Then "T2_CLAIM" or pre-socket abort marks "LEASE-RACE-01" as "INVALIDATED_AT_COMMIT_BOUNDARY" or "ABORTED_PRE_SOCKET_ZERO_BYTES" and transmits zero bytes
    And if a separate prior transmission had already passed "first_payload_byte_flushed_at", YUTE settles it truthfully as "REVOKED_POST_IRREVOCABLE_EGRESS" with:
      | axis                                 | expected_status               |
      | authorization_termination_status     | TERMINATED_PROSPECTIVELY      |
      | internal_processing_cessation_status | CONFIRMED_INTERNAL_HALTED     |
      | downstream_notification_status       | DISPATCHED_UNCONFIRMED        |
      | confirmed_deletion_status            | EXTERNAL_DELETION_UNCONFIRMED |
    And attempting to set "confirmed_deletion_status" to "EXTERNAL_DELETION_CONFIRMED_WITH_RECEIPT" without an acknowledged receipt fails PostgreSQL constraint "never_claim_unconfirmed_external_deletion"

  # ============================================================================
  # TEST-03 & SHIELD-01: CONTRACT CITATION INTEGRITY & UNICODE NORMALIZATION
  # ============================================================================
  @TEST-03 @SHIELD-01 @contract-shield @unicode-integrity
  Scenario: Verify exact clause quotations across NFD/NFC accents, curly quotes, and CRLF line endings while rejecting altered quotes
    Given "AGR-FICT-SINGLE-DIST-001" is uploaded with Windows CRLF line endings, decomposed UTF-8 "B\u0065\u0301nnett", and curly quotes
    When "Yute::ContractShield" normalizes the text to "UNICODE_NFC_LF" and extracts findings
    Then every finding's "utf8_byte_start..utf8_byte_end" and "codepoint_start..codepoint_end" match "verbatim_excerpt_nfc" identically
    And injecting a 1-character mutated quotation raises "Yute::UncitedFindingError"

  # ============================================================================
  # TEST-04, FORENSIC-B & PASSPORT-01: PRESERVATION, DELETION, HOLDS & POSTURES
  # ============================================================================
  @TEST-04 @FORENSIC-B @PASSPORT-01 @evidence-retention
  Scenario: Preserve audit immutability while executing eligible deletion, enforcing two-steward statutory holds, and preserving UNKNOWN rights posture
    Given fictional minor subject "SUBJ-FICT-KAI-001" reaches adulthood with a two-steward statutory tax hold "HOLD-TAX-001" ("steward_a" != "steward_b") on a non-biometric receipt
    And fictional photographer "SUBJ-FICT-DEVON-REID-001" holds owned master "DRP-FICT-COASTAL-SERIES-001" and unarchived upload "DRP-FICT-SOCIAL-UPLOAD-002"
    When "SUBJ-FICT-KAI-001" requests processing restriction and data deletion and an operator attempts to mutate prior audit rows
    Then PostgreSQL blocks any UPDATE or DELETE on immutable audit logs with SQLSTATE "P0001"
    And "SUBJ-FICT-KAI-001" personal media is deleted, "processing_restricted" is "true", and "HOLD-TAX-001" is disclosed with legal citation and expiry
    And "DRP-FICT-SOCIAL-UPLOAD-002" remains strictly "UNKNOWN" without fabricating clearance

  # ============================================================================
  # FORENSIC-D, FORENSIC-E & SELF-GOV-01: NON-VALUATION & SELF-SOVEREIGNTY
  # ============================================================================
  @FORENSIC-D @FORENSIC-E @SELF-GOV-01 @self-sovereignty
  Scenario: Block indirect human-worth proxy scores and audit YUTE's own platform terms through Contract Shield
    When an analytics logger or classifier emits human-worth proxy metric "castability_index"
    Then "Yute::TelemetrySanitizer" raises "Yute::IndirectValuationProxyError"
    And YUTE draft platform terms "AGR-YUTE-PLATFORM-TOS-v001" fail CI if any "AI_TRAINING_CAPTURE", "UNRESTRICTED_SUBLICENSING", or "PERPETUAL_DURATION" license-back clause exists

  # ============================================================================
  # YIE-PROOF-001: CAPABLE IMAGE ENGINE REFUSES UNAUTHORIZED IDENTITY GENERATION
  # ============================================================================
  @YIE-PROOF-001 @YUTE-ADR-0011 @yie-authorization-contract @fail-closed
  Scenario: YIE refuses an unauthorized identity-generation request even when the image-generation engine is capable of fulfilling it
    Given YIE image-generation engine health is "ENGINE_CAPABILITY_READY = TRUE"
    And fictional performer "SUBJ-FICT-ZURI-BENNETT-001" has encrypted reference asset "DRP-FICT-ZURI-STILL-001" in "YUTE Vault"
    When a caller submits "GENERATE_IDENTITY_FRAME" to "YIE" for "SUBJ-FICT-ZURI-BENNETT-001" without a valid "YieAuthorizationEnvelope" from "Yute::AgencyFirewall"
    Then "YIE" returns "REFUSED_FAIL_CLOSED" with reason "MISSING_OR_DENIED_YUTE_AUTHORIZATION"
    And "identity_bytes_decrypted" is "0" and "generated_frames_emitted" is "0"
    And attempting to record "EXECUTED_WITHIN_ENVELOPE" with "envelope_id = NULL" fails PostgreSQL constraint "yie_execution_requires_valid_envelope"

  # ============================================================================
  # YIE-NEG-01..04: NO SELF-AUTH, <=60s TTL, CROSS-SUBJECT & @AC-16 SPEC CURRENCY
  # ============================================================================
  @YIE-NEG-01 @YIE-NEG-02 @YIE-NEG-03 @YIE-NEG-04 @YUTE-AGENCY-INV-002 @AC-16
  Scenario: Reject YIE self-authorization, expired >60s envelopes, cross-subject lease splices, and superseded likeness specifications
    Given "SUBJ-FICT-ZURI-BENNETT-001" and "SUBJ-FICT-MARCUS-VALE-001" are distinct subjects and Zuri's prior spec "SPEC-ZURI-v001" is "SUPERSEDED" by "SPEC-ZURI-v002"
    When adversarial envelopes are evaluated at the "Yute::AgencyFirewall" to "YIE" boundary
    Then an envelope with "issuer_authority = YIE_INTERNAL_SELF_AUTH" fails "issuer_must_be_yute_firewall" with SQLSTATE "23514"
    And an envelope with TTL exceeding 60 seconds fails "yie_envelope_max_ttl_60s" with SQLSTATE "23514"
    And splicing "SUBJ-FICT-MARCUS-VALE-001" lease onto "SUBJ-FICT-ZURI-BENNETT-001" envelope fails composite FK "fk_yie_envelope_lease_scope" with SQLSTATE "23503"
    And referencing superseded spec "SPEC-ZURI-v001" fails trigger "trg_yie_likeness_spec_currency" with SQLSTATE "23514"

  # ============================================================================
  # YIE-NEG-05..07: ADMIN-OVERRIDE BAN, FOUNDER PARITY & SINGLE-USE REPLAY BLOCK
  # ============================================================================
  @YIE-NEG-05 @YIE-NEG-06 @YIE-NEG-07 @founder-builder-parity @no-admin-bypass
  Scenario: Enforce admin-override prohibition, identical safeguards for Founder/Builder likenesses, and single-use envelope non-replay
    Given fictional founder/builder steward "SUBJ-FICT-FOUNDER-STEWARD-001" ("is_builder_steward = TRUE") holds scoped keynote likeness spec "SPEC-FOUNDER-KEYNOTE-v001"
    When a privileged platform administrator ("admin_override_attempted = TRUE") requests unauthorized likeness generation for either "SUBJ-FICT-ZURI-BENNETT-001" or "SUBJ-FICT-FOUNDER-STEWARD-001"
    Then "YIE" refuses both requests identically with "ADMIN_PRIVILEGE_CANNOT_AUTHORIZE_LIKENESS" and SQLSTATE "23514"
    And replaying an already-consumed "YieAuthorizationEnvelope" fails single-use nonce consumption with "ENVELOPE_REPLAY_DETECTED"

