# Deliverable: YUTE_AGENCY_ACCEPTANCE_TESTS.feature
# Work Order: WO-YUTE-AGENCY-001 (YUTE Guard / Contract Shield + Digital Rights Passport)
# Governing ADR: decisions/YUTE-ADR-0010.md (Conditional Approval — Fictional-Data Engineering Only)
# Milestone: YUTE-OS-v003 | AGENCY FIREWALL PROOF
# Constitutional Doctrine: concepts/YUTE-FOUNDATION-DOCTRINE-001.md (v002)
# Version: v001.1
# Created: 2026-10-31
# Target Runner: Cucumber-Ruby (cucumber >= 9.0) against YUTE OS Ruby 3.3 / PostgreSQL 16 (v003)
# Data Policy: Uses 100% fictional test agreements & synthetic subjects (Zero real personal data)
# Status: SPECIFICATION ESTABLISHED / RUNTIME EXECUTION PENDING HUMAN RATIFICATION OF YUTE-ADR-0010

Feature: YUTE Guard, Consent Attribution, Four-Axis Revocation & Agency Firewall Proof
  As a human being using YUTE GUARD ("KNOW BEFORE YOU AGREE.")
  I need verified clause citations, signer-attributed consent ceremonies, honest revocation accounting, and fail-closed authorization
  So that my agency remains non-negotiable wherever YUTE has technical and legal authority.

  Background:
    Given YUTE OS enforces constitutional invariant "YUTE-AGENCY-INV-001" under "YUTE-ADR-0010"
    And all evaluation paths traverse "Yute::WelfareGuard" and "Yute::AgencyFirewall" before any asset decryption or egress
    And test scenarios use strictly fictional agreements and synthetic subjects

  # ============================================================================
  # FIRST RUNTIME DEMONSTRATION: YUTE-OS-v003 | AGENCY FIREWALL PROOF (TEST-05)
  # ============================================================================
  @YUTE-OS-v003-PROOF @TEST-05 @p0 @agency-firewall
  Scenario: Young recording artist authorizes single performance distribution and Agency Firewall denies synthetic voice generation with five proof artifacts
    Given fictional emerging recording artist "SUBJ-FICT-ZURI-BENNETT-001" uploads agreement "AGR-FICT-SINGLE-DIST-001" to "YUTE GUARD"
    When "Yute::ContractShield" analyzes "AGR-FICT-SINGLE-DIST-001"
    Then "01_contract_analysis.json" cites Clause "1.1" authorizing distribution of single track "TRACK-FICT-KINGSTON-RAIN-001" and Clause "2.2" reserving synthetic voice rights
    When "SUBJ-FICT-ZURI-BENNETT-001" reviews the analysis and completes verified ceremony "CEREMONY-ZURI-001" with "clauses_presented_at" preceding "signed_at"
    Then "Yute::ConsentLedger" registers "GRANT-ZURI-001" and emits "02_consent_record.json" with "voice_cloning_permitted" set to "false"
    When fictional producer "actor:producer_vance_keller" submits "03_generation_request.json" ("REQ-SYNTH-VOICE-001") requesting "GENERATE_SYNTHETIC_VOICE_PERFORMANCE"
    Then "Yute::AgencyFirewall" denies the operation and emits "04_firewall_decision.json" with outcome "DENY" and missing permission "VOICE_CLONING_NOT_AUTHORIZED"
    And "Yute::EvidenceVault" emits "05_audit_receipt.json" recording "protected_assets_released: false" and "vault_bytes_decrypted: 0"

  # ============================================================================
  # CONSTITUTIONAL INVARIANT TEST: YUTE-AGENCY-INV-001 (TEST-05)
  # ============================================================================
  @YUTE-AGENCY-INV-001 @TEST-05 @p0 @constitutional
  Scenario: Deny synthetic-voice advertisement when performer contract authorizes only visual likeness in one named production
    Given fictional adult performer "SUBJ-FICT-NIA-CLARKE-001" completes verified ceremony "CEREMONY-NIA-001" for "AGR-FICT-HARBOR-LIGHT-001"
    And "Yute::ConsentLedger" records grant "GRANT-NIA-001" with:
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
      | DATABASE_SQL      | INSERT NULL into autonomous_persona_allowed                  | PG::NotNullViolation                |
      | HTTP_API          | fetch protected master stream without capability lease       | Yute::MissingCapabilityLeaseError   |
      | CLI_COMMAND       | export asset via CLI bypassing HTTP middleware               | Yute::MissingCapabilityLeaseError   |
      | BACKGROUND_WORKER | call SourceAssetVault#open_plaintext_stream directly         | Yute::MissingCapabilityLeaseError   |
      | RENDER_ADAPTER    | dispatch external synthesis call with expired or forged lease | Yute::InvalidOrExpiredLeaseError   |

  # ============================================================================
  # REFINEMENT 3.A: AN AGREEMENT HASH IS NOT PROOF OF CONSENT
  # ============================================================================
  @REFINEMENT-3A @consent-attribution
  Scenario: Reject ConsentLedger grant registration backed only by a document SHA-256 without verified signer attribution and comprehension ceremony
    Given agreement "AGR-FICT-SINGLE-DIST-001" is stored with valid SHA-256 digest
    When a caller attempts to register a "ConsentLedger" grant using only "canonical_text_sha256" without a verified "authorization_ceremonies" record or where "signed_at" precedes "clauses_presented_at"
    Then registration fails closed and no active permission grant is created

  # ============================================================================
  # TEST-02, REFINEMENT 3.B & FORENSIC-C: CONCURRENT REVOCATION RACE & 4-AXIS STATUS
  # ============================================================================
  @TEST-02 @REFINEMENT-3B @FORENSIC-C @revocation-race
  Scenario: Prevent concurrent commit after mid-flight revocation and never claim universal external deletion without confirmation
    Given worker thread A holds valid lease "LEASE-RACE-01" on "GRANT-ZURI-001" and pauses immediately before the final commit boundary
    And "GRANT-ZURI-001" had a prior external streaming copy distributed to "LICENSEE-STREAMING-PARTNER"
    When concurrent thread B commits a signed revocation from "SUBJ-FICT-ZURI-BENNETT-001"
    And worker thread A resumes and attempts to commit or release output at the final boundary
    Then the final commit re-check rejects thread A, marks "LEASE-RACE-01" as "INVALIDATED_AT_COMMIT_BOUNDARY", and releases zero bytes
    And "revocation_status_ledgers" records four separate axes:
      | axis                                 | expected_status            |
      | authorization_termination_status     | TERMINATED_PROSPECTIVELY   |
      | internal_processing_cessation_status | CONFIRMED_INTERNAL_HALTED  |
      | downstream_notification_status       | DISPATCHED_UNCONFIRMED     |
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
    Then PostgreSQL blocks any UPDATE or DELETE on immutable audit logs
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
