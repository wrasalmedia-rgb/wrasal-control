# Deliverable: YUTE_ACCEPTANCE_TESTS.feature
# Phase 08 Alias: YUTE_DARRON_ACCEPTANCE_TESTS.feature
# Constitutional Doctrine: concepts/YUTE-FOUNDATION-DOCTRINE-001.md
# Version: v002
# Created: 2026-10-31
# Work Order: WO-YUTE-LUTA-DARRON-001
# Protocol: YUTE-DHPE-001
# Target Runner: Cucumber-Ruby (cucumber >= 9.0) against YUTE OS Ruby Domain Services
# Status: SPECIFICATION COMPLETE / RUNTIME EXECUTION PENDING YUTE REPO BOOTSTRAP

Feature: YUTE OS Human-First Digital Identity Preservation & LUTA Governance Acceptance Suite
  As the YUTE Welfare Guard, Consent Authority, and WRASAL S3 Control Plane
  I must place Human Welfare before Identity, enforce the YUTE Prime Directive and Five Protections, and govern LUTA character portrayal
  So that no human being is ever reduced to a digital representation and every subject retains dignity, clarity, agency, and future choice.

  Background:
    Given YUTE OS operates in fail-closed governance mode under "YUTE-FOUNDATION-DOCTRINE-001"
    And the YUTE Prime Directive states "NO HUMAN BEING SHALL BE REDUCED TO THE DIGITAL REPRESENTATION CREATED FROM THEM"
    And the governing chain begins with "HUMAN WELFARE" upstream of "IDENTITY"
    And human subject "SUBJ-DARRON-RAY-DONALDSON" ("Darron-Ray Donaldson") is distinct from character "CHAR-UNDERTAKERS-LUTA" ("LUTA, King of the Dream Realm")
    And character costume authority "COSTUME-LUTA-CANON-v001" is registered as canonical for "CHAR-UNDERTAKERS-LUTA"

  # 00. Upstream Human Welfare Gate & YUTE Prime Directive (YUTE-FOUNDATION-DOCTRINE-001)
  @AC-00 @human-welfare @prime-directive
  Scenario: Enforce upstream Human Welfare check and block autonomous avatar impersonation
    Given "Yute::WelfareGuard" stands upstream of "Yute::IdentityRegistry" and "Yute::ReconstructionAdapter"
    When a service attempts to configure "autonomous_persona_allowed" as "true" or treat a synthetic render as factual proof that the real human performed the act
    Then "Yute::WelfareGuard" rejects the operation with "Yute::PrimeDirectiveViolationError"
    And every synthetic output carries an immutable notice stating a synthetic performance is not evidence that the human subject performed it

  # 1. Correct professional-source identification
  @AC-01 @source-identification @discovery
  Scenario: Confirm professional portfolio represents intended human subject without collecting government IDs
    Given public discovery inspects "https://darronray.com/"
    When the source discovery record "SRC-001" is evaluated
    Then the subject is identified as "Darron-Ray Donaldson", a Jamaica-based Actor, Model, and Talent
    And the official direct contact channel "[PUBLISHED_BOOKING_EMAIL_ON_SRC_001_REDACTED_FOR_PUBLIC_REPO]" is recorded
    And subject verification_status is set to "UNVERIFIED_DISCOVERY_ONLY"
    And zero government identity documents or biometric face vectors are stored

  # 2. Source provenance completeness
  @AC-02 @provenance @discovery
  Scenario: Require explicit provenance fields and preserve UNKNOWN where authorship or resolution cannot be established
    Given the source manifest "YUTE_DARRON_SOURCE_MANIFEST.csv" is loaded
    When every cataloged entry is validated against the YUTE provenance schema
    Then every record contains non-empty "SOURCE_ID", "SOURCE_URL", "ASSET_TYPE", "OBSERVED_DATE", "ACCESS_STATUS", and "RIGHTS_STATUS"
    And uncredited gallery or lookbook photographs explicitly record "UNKNOWN" for photographer identity rather than inventing credits
    And restricted external video "SRC-022" ("https://www.youtube.com/watch?v=_1NO8C-K3uE") is recorded with access_status "RESTRICTED_PRIVATE_YOUTUBE" without bypass

  # 3. Appropriate rights and consent verification
  @AC-03 @rights-consent @hold-gate
  Scenario: Block likeness reconstruction when performer consent, adult attestation, or photographer license is missing
    Given identity passport "YUTE-PASSPORT-SPEC-v002-DRAFT" has consent_status "PENDING_INITIAL_OUTREACH"
    And portfolio headshot "SRC-018" ("Britney Holung Photography") has copyright_clearance_state "UNLICENSED"
    When "Yute::ReconstructionAdapter" requests a likeness reconstruction job for "SUBJ-DARRON-RAY-DONALDSON"
    Then the request is rejected with error "Yute::HoldGateActiveError"
    And no model weights, embeddings, or synthetic images are generated

  @AC-03 @rights-consent @voice-separation
  Scenario: Enforce separate authorization requirement for voice synthesis
    Given identity passport for "SUBJ-DARRON-RAY-DONALDSON" has consent_status "GRANTED_SCOPED" for visual portrayal of "CHAR-UNDERTAKERS-LUTA"
    And voice_synthesis_allowed on the passport is "false"
    When a service requests vocal cloning or synthetic speech generation for "SUBJ-DARRON-RAY-DONALDSON"
    Then "Yute::ConsentAuthority" rejects the operation with "Yute::UnauthorizedVoiceUseError"

  # 4. Authorized dataset membership
  @AC-04 @dataset-membership @contamination-quarantine
  Scenario Outline: Reject contaminated, multi-subject, watermarked, or unlicensed third-party media from identity extraction
    Given source asset "<source_id>" has performer consent "<performer_cleared>" and copyright status "<copyright_state>"
    And asset flags are cosubjects="<cosubjects>", watermark="<watermark>", editorial_makeup="<makeup>"
    When "Yute::SourceAssetVault" evaluates "<source_id>" for identity extraction dataset membership
    Then dataset membership eligibility must be "<eligible>"
    And disposition note must record "<reason>"

    Examples:
      | source_id       | performer_cleared | copyright_state       | cosubjects | watermark | makeup | eligible | reason                                               |
      | SRC-002         | true              | THIRD_PARTY_LICENSED  | true       | true      | false  | false    | Quarantine: co-subject and @lexonart watermark       |
      | SRC-009         | true              | UNLICENSED            | false      | false     | true   | false    | Reject: uncredited photographer and white face paint |
      | SRC-016         | true              | UNLICENSED            | true       | false     | false  | false    | Reject: two co-subjects and uncredited photographer  |
      | SRC-021         | true              | UNLICENSED            | true       | false     | false  | false    | Reject: third-party commercial music video           |
      | CAP-DARRON-0001 | true              | FIRST_PARTY_OWNED     | false      | false     | false  | true     | Cleared: first-party calibrated studio capture       |

  # 5. Facial identity consistency
  @AC-05 @facial-consistency @post-authorization
  Scenario: Verify craniofacial, hairline, beard, and asymmetry consistency across camera angles and expressions
    Given an active, performer-signed likeness specification "YUTE-IDLOCK-DARRON-v001"
    And calibrated reference set "MCPRS-v001" is stored in "Yute::SourceAssetVault"
    When candidate still renders are evaluated across 0-degree frontal, 45-degree three-quarter, and 90-degree profile angles under expressions "EXP-00" and "EXP-01"
    Then craniofacial proportions, fronto-temporal hairline geometry, nasal dorsum profile, and full sculpted beard distribution match "YUTE-IDLOCK-DARRON-v001"
    And natural bilateral facial asymmetry is preserved without artificial symmetry mirroring
    And zero midline white editorial forehead or chin-beard paint artifacts from "SRC-009".."SRC-011" appear in the output

  # 6. Natural anatomical proportions
  @AC-06 @anatomical-proportions
  Scenario: Prohibit perspective-derived biometric fabrication and require verified direct measurements for Body Lock
    Given portfolio photographs "SRC-009", "SRC-010", and "SRC-011" were captured without a calibrated metric scale bar
    When an operator attempts to populate "BODY_LOCK" exact height or chest circumference from perspective photo estimation
    Then "Yute::LikenessSpecification" rejects the update with "Yute::UnverifiedBiometricSourceError"
    And "BODY_LOCK" accepts exact dimensions only when body_measurement_source equals "VERIFIED_DIRECT_CAPTURE"

  # 7. Skin and material realism
  @AC-07 @skin-material @post-authorization
  Scenario: Preserve authentic melanin reflectance, dermal micro-texture, and Type-4 coil fiber response across lighting setups
    Given candidate renders for "SUBJ-DARRON-RAY-DONALDSON" are evaluated by "Yute::ValidationService"
    When inspected under both neutral 5600K studio light and low-key Dream-Realm chiaroscuro
    Then warm medium-deep brown skin undertones, shadow separation, and satin dermal pore texture are preserved without clipped highlights or ashy shadow desaturation
    And plastic beauty-smoothing gloss and waxy subsurface artifacts are absent
    And Type-4 coil hair and coarse terminal beard fibers exhibit physically plausible light absorption and rim scattering

  # 8. Costume continuity
  @AC-08 @costume-continuity @luta
  Scenario: Enforce canonical three-state LUTA visual rules and reject prohibited fantasy alterations
    Given character casting binding "CAST-BIND-UNDERTAKERS-LUTA-001" links "REP-YUTE-DARRON-v001" to "CHAR-UNDERTAKERS-LUTA"
    When candidate renders for "STATE_A_HUMAN", "STATE_B_UNDERTAKER", and "STATE_C_REVEALED_KING" are validated against "COSTUME-LUTA-CANON-v001"
    Then "STATE_A_HUMAN" displays the approved unmasked human face with personal body markings masked
    And "STATE_B_UNDERTAKER" completely conceals the human face beneath the elongated weathered birdlike mask with deep recessed eye openings
    And "STATE_C_REVEALED_KING" removes the birdlike mask to reveal the approved human face while preserving the dark botanical leaf-feather mantle, expansive grounded shoulder silhouette, charcoal woven neck scarf, antique bronze and oxidized silver beadwork, heavy black underlayers, and full-length cascading cloak
    And any candidate containing a crown, armor, or weapon fails validation immediately

  # 9. Human approval (Technical quality != Authorization)
  @AC-09 @human-approval @critical-boundary
  Scenario: Visually convincing and technically passing output remains unauthorized without explicit performer approval
    Given candidate render "RENDER-LUTA-STATE-C-001" passes 100 percent of automated technical checks in "Yute::ValidationService"
    And no "APPROVED" entry signed by "Darron-Ray Donaldson" exists for "RENDER-LUTA-STATE-C-001" in "Yute::ApprovalLedger"
    When a user or pipeline attempts to export, certify identity on, or publish "RENDER-LUTA-STATE-C-001"
    Then the export is blocked with status "TECHNICAL_PASS_AWAITING_PERFORMER_APPROVAL"
    And the system explicitly refuses to certify human identity based solely on visual resemblance

  # 10. License enforcement and revocation
  @AC-10 @license-revocation
  Scenario: Block out-of-scope character use and halt new generation immediately upon performer revocation
    Given an active casting license permitting "REP-YUTE-DARRON-v001" solely for "CHAR-UNDERTAKERS-LUTA" in "WRASAL | THE UNDERTAKERS"
    When a pipeline attempts to cast "REP-YUTE-DARRON-v001" as a different character "CHAR-OTHER-001"
    Then "Yute::LicenseManager" rejects the job with "Yute::CharacterScopeViolationError"
    When "Darron-Ray Donaldson" submits a signed revocation notice to "Yute::RevocationControl"
    Then identity passport consent_status transitions immediately to "REVOKED"
    And all subsequent "Yute::ReconstructionAdapter" jobs for "SUBJ-DARRON-RAY-DONALDSON" are blocked
    And a mandatory review record "REVIEW_REQUIRED" is created for all existing licensed deliverables

  # 11. Synthetic-media disclosure
  @AC-11 @synthetic-disclosure
  Scenario: Attach verifiable synthetic-media provenance and human-vs-character disclosure to every approved export
    Given candidate render "RENDER-LUTA-STATE-C-001" has both "PERFORMER" and "WRASAL_CREATIVE" approvals in "Yute::ApprovalLedger"
    When "Yute::LicenseManager" packages "RENDER-LUTA-STATE-C-001" for authorized release
    Then an embedded C2PA and YUTE JSON provenance manifest is bound to the exported asset SHA-256
    And the disclosure explicitly states that the image is an authorized synthetic representation of "Darron-Ray Donaldson" portraying the fictional character "LUTA" under "WO-YUTE-LUTA-DARRON-001"

  # 12. Version history and audit integrity
  @AC-12 @version-audit
  Scenario: Maintain four independent version histories and detect any tampering in the approval ledger
    Given casting binding "CAST-BIND-UNDERTAKERS-LUTA-001" references independent versions for "HUMAN_IDENTITY", "CHARACTER_IDENTITY", "COSTUME_IDENTITY", and "PERFORMANCE_STATE"
    When "COSTUME_IDENTITY" increments from "COSTUME-LUTA-CANON-v001" to "COSTUME-LUTA-CANON-v002"
    Then "HUMAN_IDENTITY" version "YUTE-IDLOCK-DARRON-v001" remains unchanged and unmutated
    And attempting to UPDATE or DELETE any historical row in "approval_ledger_entries" or "vault_access_audit_logs" fails with a database immutability error

  # 13. Child Protection Principle — INNOCENCE (YUTE-FOUNDATION-DOCTRINE-001)
  @AC-13 @child-protection @innocence
  Scenario: Reject synthetic likeness generation and commercial exploitation of a minor even with parental authorization
    Given human subject "SUBJ-TEST-MINOR-001" has age_protection_class "MINOR_PROTECTED"
    And a parent or legal guardian submits a signed guardian authorization form requesting commercial likeness generation
    When "Yute::WelfareGuard" or PostgreSQL constraint "child_protection_hard_shield" evaluates the request
    Then synthetic_likeness_allowed, commercial_exploitation_allowed, public_exposure_allowed, and voice_synthesis_allowed are hard-rejected with "Yute::ChildProtectionViolationError"
    And majority_ratification_required is enforced as "true" with unconditional sovereign reclamation and purge rights upon adulthood

  # 14. The Light Principle — Five-Axis Clarity (YUTE-FOUNDATION-DOCTRINE-001)
  @AC-14 @light-principle @clarity
  Scenario: Require all five Light Principle clarity distinctions on every governed record and export
    Given an output asset is evaluated for clarity disclosure in "clarity_disclosure_manifests"
    When "Yute::ValidationService" inspects the clarity manifest
    Then the manifest explicitly distinguishes "REAL_CAPTURE" from "SYNTHETIC_RECONSTRUCTION"
    And distinguishes "AUTHORIZED_DUAL_CLEARED" from "UNVERIFIED_QUARANTINED"
    And distinguishes "ARCHIVAL_MEMORY" from "RECONSTRUCTED_REPRESENTATION"
    And distinguishes "VERIFIED_EVIDENCE" from "CLAIMED_UNVERIFIED"
    And attests "PASSED_WELFARE_GUARD" confirming human-serving non-exploitative scope

  # 15. Restoration & Non-Valuation Principle — Psalm 23 Dignity Invariant (YUTE-FOUNDATION-DOCTRINE-001)
  @AC-15 @non-valuation @dignity
  Scenario: Prohibit algorithmic scoring of human attractiveness, influence, or commercial worth
    Given YUTE OS enforces constitutional invariant "NO_HUMAN_VALUATION_SCORING"
    When an API payload or service attempts to record "attractiveness_score", "commercial_worth", "influence_rank", or "profitability_score" for any human subject
    Then "Yute::WelfareGuard" rejects the payload with "Yute::HumanValuationProhibitedError"
    And encryption strength, audit integrity, and revocation latency remain identical across all subjects regardless of revenue

  # 16. Memory Growth & Builder Protection Parity — "Pastor pickney christen fuss" (YUTE-FOUNDATION-DOCTRINE-001)
  @AC-16 @memory-correction @founder-protection
  Scenario: Allow contextual memory correction without erasing audit history and enforce builder Passport parity
    Given human subject "SUBJ-FOUNDER-STEWARD-001" has is_builder_steward "true"
    When "SUBJ-FOUNDER-STEWARD-001" registers a YUTE Identity Passport and later submits a contextual correction superseding an older representation
    Then the builder receives full Identity Passport encryption, consent, and revocation protections identical to external talent
    And "subject_context_corrections" records the superseding context so the person is not frozen in an outdated state while preserving hash-chain audit integrity
    And governance configuration requires at least one "DESIGNATED_CO_STEWARD" so no single human carries unshared 24/7 operational burden
