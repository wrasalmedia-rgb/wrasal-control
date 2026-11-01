# Deliverable: YUTE_AGENCY_ACCEPTANCE_TESTS.feature
# Work Order: WO-YUTE-AGENCY-001 (YUTE Contract Shield + Digital Rights Passport)
# Milestone: YUTE-OS-AGENCY-FOUNDATION-v001
# Constitutional Doctrine: concepts/YUTE-FOUNDATION-DOCTRINE-001.md (v002)
# Version: v001
# Created: 2026-10-31
# Target Runner: Cucumber-Ruby (cucumber >= 9.0) against YUTE OS Ruby Services (v003/v004)
# Data Policy: Uses 100% fictional test agreements & synthetic subjects (Zero real personal data)
# Status: SPECIFICATION ESTABLISHED / RUNTIME EXECUTION PENDING (v003)

Feature: YUTE Agency Foundation — Contract Shield, Digital Rights Passport & Agency Firewall
  As a human being using YUTE OS to understand agreements and govern my digital rights
  I need enforceable contract comprehension, scoped consent recording, and fail-closed authorization across every execution boundary
  So that my identity, creative work, and digital future are never processed beyond my established permissions.

  Background:
    Given YUTE OS enforces constitutional invariant "YUTE-AGENCY-INV-001"
    And all evaluation paths traverse "Yute::WelfareGuard" and "Yute::AgencyFirewall" before any asset decryption or egress
    And test scenarios use strictly fictional agreements and synthetic subjects

  # ============================================================================
  # CONSTITUTIONAL ACCEPTANCE TEST: YUTE-AGENCY-INV-001
  # ============================================================================
  @YUTE-AGENCY-INV-001 @p0 @agency-firewall @constitutional
  Scenario: Deny synthetic-voice advertisement when performer contract authorizes only visual likeness in one named production
    Given fictional adult performer "SUBJ-FICT-NIA-CLARKE-001" signs agreement "AGR-FICT-HARBOR-LIGHT-001"
    And "AGR-FICT-HARBOR-LIGHT-001" authorizes "VISUAL_LIKENESS_NAMED_PRODUCTION" solely for named production "PROD-FICT-HARBOR-LIGHT"
    And "AGR-FICT-HARBOR-LIGHT-001" does not authorize voice cloning, commercial advertising, or sublicensing
    And "Yute::ConsentLedger" records grant "GRANT-NIA-001" linked to "AGR-FICT-HARBOR-LIGHT-001" SHA-256 with:
      | permitted_action                 | VISUAL_LIKENESS_NAMED_PRODUCTION |
      | named_production_scope           | PROD-FICT-HARBOR-LIGHT           |
      | voice_cloning_permitted          | false                            |
      | advertising_permitted            | false                            |
      | sublicensing_permitted           | false                            |
    When production user "actor:ad_campaign_producer" requests action "GENERATE_SYNTHETIC_VOICE_AD" for "SUBJ-FICT-NIA-CLARKE-001" under campaign "AD-BRAND-SOLAR-COLA"
    Then "Yute::AgencyFirewall" returns outcome "DENY" with reason code "OUT_OF_AUTHORIZED_SCOPE"
    And the denial receipt enumerates missing permissions:
      | missing_permission                                |
      | VOICE_CLONING_NOT_AUTHORIZED                      |
      | ADVERTISING_USE_NOT_AUTHORIZED                    |
      | PRODUCTION_OUTSIDE_NAMED_SCOPE:PROD-FICT-HARBOR-LIGHT |
    And "Yute::EvidenceVault" records "identity_assets_transmitted" as "false"
    And zero identity, audio, or visual assets are decrypted or transmitted to any rendering or synthesis provider

  # ============================================================================
  # COMPONENT 1: CONTRACT SHIELD (CLAUSE-CITED COMPREHENSION FOR NON-AVATAR USERS)
  # ============================================================================
  @SHIELD-01 @contract-shield @non-avatar
  Scenario: Musician contract review cites exact agreement sections and rejects uncited findings
    Given fictional musician "SUBJ-FICT-MARCUS-VALE-001" uploads recording agreement "AGR-FICT-LABEL-DEAL-001" without uploading any biometric photos
    When "Yute::ContractShield" analyzes "AGR-FICT-LABEL-DEAL-001"
    Then consequential clauses for "VOICE_CLONING_GRANT", "AI_TRAINING_CAPTURE", and "PERPETUAL_DURATION" are flagged
    And every finding contains non-null "agreement_sha256", "clause_reference", "char_start_offset", "char_end_offset", and a "verbatim_excerpt" matching the exact substring in "AGR-FICT-LABEL-DEAL-001"
    And any candidate finding whose excerpt does not match the stored agreement text is rejected with "Yute::UncitedFindingError"
    And the output displays an explicit notice that findings provide contractual comprehension and recommend human legal counsel where scope is ambiguous

  # ============================================================================
  # COMPONENT 3: DIGITAL RIGHTS PASSPORT (OWNERSHIP VS LICENSE VS UNKNOWN)
  # ============================================================================
  @PASSPORT-01 @digital-rights-passport @non-avatar
  Scenario: Photographer and individual records strictly distinguish ownership, scoped license, and UNKNOWN platform rights
    Given fictional photographer "SUBJ-FICT-DEVON-REID-001" registers portrait series "DRP-FICT-COASTAL-SERIES-001"
    And registers a 12-month editorial display license "AGR-FICT-MAGAZINE-001" prohibiting AI dataset training
    And registers an external social platform upload "DRP-FICT-SOCIAL-UPLOAD-002" whose historic terms were not archived
    When "Yute::DigitalRightsPassport" compiles the subject's rights summary
    Then "DRP-FICT-COASTAL-SERIES-001" displays rights_posture "OWNED_BY_SUBJECT" and "LICENSED_OUT_SCOPED" with AI training marked prohibited
    And "DRP-FICT-SOCIAL-UPLOAD-002" displays evidence_status "UNKNOWN" without assuming permission or erasure

  # ============================================================================
  # FORENSIC FINDING A: SQL NULLABILITY & MULTI-BOUNDARY ENFORCEMENT
  # ============================================================================
  @FORENSIC-A @sql-nullability @boundary-enforcement
  Scenario Outline: Block NULL constraint bypasses and block non-HTTP worker/CLI/admin bypasses lacking a CapabilityLease
    Given protected asset "CAP-FICT-NIA-001" is stored in encrypted custody
    When an operation at boundary "<boundary>" attempts to "<attempt>" without a valid active "FirewallCapabilityLease"
    Then the operation fails closed with "<expected_error>"
    And zero plaintext bytes leave custody

    Examples:
      | boundary          | attempt                                                     | expected_error                      |
      | DATABASE_SQL      | INSERT NULL into autonomous_persona_allowed                 | PG::NotNullViolation                |
      | BACKGROUND_WORKER | open_plaintext_stream directly from background job          | Yute::MissingCapabilityLeaseError   |
      | CLI_COMMAND       | export asset via administrative CLI without Firewall lease  | Yute::MissingCapabilityLeaseError   |
      | RENDER_ADAPTER    | dispatch external synthesis call with expired 60s lease     | Yute::ExpiredCapabilityLeaseError   |

  # ============================================================================
  # FORENSIC FINDING B: THREE-TIER ADULTHOOD TRANSITION & LAWFUL RETENTION HOLDS
  # ============================================================================
  @FORENSIC-B @adulthood-transition @child-protection
  Scenario: Enforce Adulthood Reauthorization, Processing Restriction, and Honest Retention-Hold Accounting
    Given fictional minor subject "SUBJ-FICT-KAI-001" had non-commercial archival record "DRP-FICT-KAI-ARCHIVE-001"
    And counsel-approved statutory tax record "HOLD-TAX-001" applies solely to a non-biometric payment ledger receipt
    When "SUBJ-FICT-KAI-001" reaches legal adulthood and requests processing restriction and data deletion without reauthorizing
    Then guardian-era permissions transition to "DECLINED_TERMINATED"
    And "processing_restricted" is set to "true" blocking 100 percent of operational reads and leases
    And all eligible personal media and vault objects are cryptographically deleted
    And "adulthood_transitions" records "PARTIAL_DELETED_WITH_DECLARED_LEGAL_HOLD" disclosing the exact statutory basis and expiration date of "HOLD-TAX-001"

  # ============================================================================
  # FORENSIC FINDING C: REVOCATION PROPAGATION BEYOND THE DATABASE
  # ============================================================================
  @FORENSIC-C @revocation-propagation
  Scenario: Propagate revocation across in-flight rendering jobs, KMS caches, staging exports, and external licensees
    Given grant "GRANT-NIA-001" has an in-flight authorized background job "JOB-INFLIGHT-099" holding lease "LEASE-099"
    And external licensee "LICENSEE-STREAMING-PARTNER" holds a registered webhook endpoint
    When "SUBJ-FICT-NIA-CLARKE-001" submits a signed revocation notice
    Then "GRANT-NIA-001" transitions to "REVOKED" and "LEASE-099" transitions to "INVALIDATED_ON_REVOCATION"
    When "JOB-INFLIGHT-099" finishes computing and attempts to persist or export its output
    Then the pre-commit lease re-check rejects the write and discards the in-flight output in memory
    And "revocation_propagation_targets" tracks separate verification states for "IN_FLIGHT_WORKER_LEASE", "EPHEMERAL_CACHE_PURGE", "KMS_SUBJECT_DEK_DISABLE", "STAGING_EXPORT_QUARANTINE", and "EXTERNAL_LICENSEE_WEBHOOK"
    And overall revocation propagation is not marked globally complete while "EXTERNAL_LICENSEE_WEBHOOK" remains "DISPATCHED_AWAITING_ACK"

  # ============================================================================
  # FORENSIC FINDING D: DIRECT & INDIRECT HUMAN VALUATION PROHIBITION
  # ============================================================================
  @FORENSIC-D @non-valuation @telemetry
  Scenario: Block indirect human-worth proxy scores across logs, model outputs, and external integrations
    When an internal classifier, analytics logger, or webhook serializer emits proxy metric "castability_index" or "engagement_worth_percentile" for a human subject
    Then "Yute::TelemetrySanitizer" blocks emission and raises "Yute::IndirectValuationProxyError"

  # ============================================================================
  # FORENSIC FINDING E & SECTION 06: BUILDER CO-STEWARD ESCALATION & SELF-SOVEREIGNTY
  # ============================================================================
  @FORENSIC-E @SELF-GOV-01 @self-sovereignty @builder-stewardship
  Scenario: Audit YUTE's own platform terms through Contract Shield and require two-steward integrity on sensitive holds
    Given YUTE OS draft platform terms "AGR-YUTE-PLATFORM-TOS-v001" are marked "is_yute_platform_terms = true"
    When "Yute::ContractShield" audits "AGR-YUTE-PLATFORM-TOS-v001" during release verification
    Then zero clauses of type "AI_TRAINING_CAPTURE", "UNRESTRICTED_SUBLICENSING", or "PERPETUAL_DURATION" license-back are permitted
    And releasing any legal hold requires two distinct human stewards ("STEWARD_PRIMARY" != "STEWARD_CO_CUSTODIAN")
