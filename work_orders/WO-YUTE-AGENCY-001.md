# Arena Work Order

WORK_ORDER_ID: WO-YUTE-AGENCY-001

MILESTONE: YUTE-OS-v003 | AGENCY FIREWALL PROOF + YUTE × YIE | IDENTITY AUTHORIZATION CONTRACT v001 (under YUTE-ADR-0010 & YUTE-ADR-0011)

PRIORITY: P0

VERSION: v001.3

CREATED_ON: 2026-10-31

STATUS: YUTE-ARCH-GOV-002 RECONCILED & PG 16.4 MIGRATIONS (001..004, 17/17 CHECKS) VERIFIED ON DRAFT PR #8 / AWAITING HUMAN RATIFICATION OF YUTE-ADR-0010 & YUTE-ADR-0011 (canonical_acceptance: pending)

PROJECT: yute (YUTE — Know Before You Agree. Control What You Authorize. Preserve The Evidence.)

OBJECTIVE: Reconcile WRASAL / YUTE OS / YIY (Proposed) / YIE governance boundaries under YUTE-ADR-0011, specify YUTE × YIE | IDENTITY AUTHORIZATION CONTRACT v001 (including Founder/Builder protection symmetry, admin-override prohibition, and @YIE-PROOF-001 showing a capable image engine refuses unauthorized identity generation), and verify standalone PostgreSQL 16 migrations (001..004) across 17 adversarial SQLSTATE invariants on PostgreSQL 16.4 while preserving HOLD-RIGHTS-001 and public-repo privacy minimization.

SUCCESS_CONDITION: decisions/YUTE-ADR-0010.md, decisions/YUTE-ADR-0011.md, YUTE_YIE_IDENTITY_AUTHORIZATION_CONTRACT_v001.md, standalone PostgreSQL 16 migrations 001..004 (17/17 PG 16.4 invariants PASS), and evidence/WO-YUTE-AGENCY-001-validation.json pass all 567 control-plane checks with zero unauthorized media in the diff, and Draft PR #8 remains open in Draft mode on wrasalmedia-rgb/wrasal-control for independent human audit.

AUTHORITATIVE_INPUTS:
- decisions/YUTE-ADR-0010.md (Controlled Advancement to Agency Runtime Verification)
- decisions/YUTE-ADR-0011.md (YIY/YIE Identity Services Integration With YUTE Human Agency Governance)
- concepts/YUTE-FOUNDATION-DOCTRINE-001.md (v002.3)
- projects.yml
- work_orders/status-vocabulary.json

DEPENDENCIES:
- AGY-T003: Human audit of GitHub Draft PR #8 diff and signature ratification of YUTE-ADR-0010 and YUTE-ADR-0011 before provisioning private repository wrasalmedia-rgb/yute (READY)
- Independent of WO-YUTE-LUTA-DARRON-001 (remains strictly frozen under HOLD-RIGHTS-001; real performer data and synthetic human reconstruction are NO GO)

CURRENT_TASK: AGY-T003 — Human Ratification of YUTE-ADR-0010, YUTE-ADR-0011 & Draft PR #8 Review

ACCEPTANCE:
- missions/WO-YUTE-AGENCY-001/migrations/004_verify_pg16_invariants.sql (17/17 PG 16.4 SQLSTATE invariants PASS, incl. @YIE-PROOF-001 & @YIE-NEG-01..06)
- missions/WO-YUTE-AGENCY-001/YUTE_YIE_IDENTITY_AUTHORIZATION_CONTRACT_v001.md (YIE-AUTH-ENV-v001, non-self-authorization, <=60s TTL, Founder/Builder parity)
- missions/WO-YUTE-AGENCY-001/YUTE_AGENCY_ACCEPTANCE_TESTS.feature (@YUTE-OS-v003-PROOF, @YIE-PROOF-001, @YIE-NEG-01..@YIE-NEG-07, @TEST-01..@TEST-06)
- Control-plane validation: npm test PASS (567/567 checks)

DECISIONS:
- YUTE-ADR-0011 recorded: YIE supplies identity-processing capabilities while YUTE governs whether they may be used; YIE cannot self-authorize; YIY/YIE corporate relationship remains Proposed and distinct from verified legal formation.
- Founder & Builder Inclusion enforced: administrative privilege never confers permission to access, reproduce, or commercialize another person's likeness; the founder's and builders' own authorized AI likenesses receive identical fail-closed safeguards.
- YUTE-AGENCY-INV-002 enforced via 18 composite foreign keys across migrations 001..003 (incl. 7-column lease-to-envelope FK fk_yie_envelope_lease_scope); @YIE-PROOF-001 verified on PostgreSQL 16.4 (engine_capability_ready=TRUE + missing envelope -> 23514 / 0 bytes decrypted / 0 frames emitted).

EVIDENCE:
- decisions/YUTE-ADR-0010.md
- decisions/YUTE-ADR-0011.md
- concepts/YUTE-FOUNDATION-DOCTRINE-001.md
- evidence/WO-YUTE-AGENCY-001-validation.json
- evidence/WO-YUTE-AGENCY-001-pg16-schema-verification.json
- missions/WO-YUTE-AGENCY-001/YUTE_YIE_IDENTITY_AUTHORIZATION_CONTRACT_v001.md
- missions/WO-YUTE-AGENCY-001/migrations/001_yute_mvp_core.sql
- missions/WO-YUTE-AGENCY-001/migrations/002_yute_agency_foundation.sql
- missions/WO-YUTE-AGENCY-001/migrations/003_yute_yie_authorization_contract.sql
- missions/WO-YUTE-AGENCY-001/migrations/004_verify_pg16_invariants.sql
- missions/WO-YUTE-AGENCY-001/YUTE_PRIVACY_MINIMIZATION_AUDIT_001.md
- missions/WO-YUTE-AGENCY-001/YUTE_OS_AGENCY_FOUNDATION_v001.md
- missions/WO-YUTE-AGENCY-001/YUTE_OS_v003_FIREWALL_PROOF_SPEC.md
- missions/WO-YUTE-AGENCY-001/WO_YUTE_AGENCY_001_WORK_ORDER.md
- missions/WO-YUTE-AGENCY-001/YUTE_AGENCY_ACCEPTANCE_TESTS.feature
- missions/WO-YUTE-AGENCY-001/YUTE_AGENCY_TASK_BACKLOG.csv
- missions/WO-YUTE-AGENCY-001/YUTE_AGENCY_FICTIONAL_TEST_FIXTURES.md
