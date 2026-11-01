# Arena Work Order

WORK_ORDER_ID: WO-YUTE-AGENCY-001

MILESTONE: YUTE-OS-v003 | AGENCY FIREWALL PROOF (under YUTE-ADR-0010)

PRIORITY: P0

VERSION: v001.2

CREATED_ON: 2026-10-31

STATUS: PG 16.4 MIGRATIONS & SQL INVARIANTS VERIFIED ON DRAFT PR #8 / AWAITING HUMAN RATIFICATION OF YUTE-ADR-0010 FOR RUBY 3.3 RUNTIME (canonical_acceptance: pending)

PROJECT: yute (YUTE — Know Before You Agree. Control What You Authorize. Preserve The Evidence.)

OBJECTIVE: Resolve all P0 and P1 findings from YUTE-PR8-REVIEW-001 by extracting standalone PostgreSQL 16 migration files (001..003) and executing them against PostgreSQL 16.4, enforcing YUTE-AGENCY-INV-002 via 15 composite foreign keys (TEST-06), defining EGRESS-FENCE-v001 transaction/lock/socket ordering, modeling the 5-stage consent process (PRESENTED -> ACKNOWLEDGED -> EXPLAINED -> DECIDED -> AUTHORIZED), and minimizing personal details in public Darron discovery artifacts while preserving HOLD-RIGHTS-001.

SUCCESS_CONDITION: decisions/YUTE-ADR-0010.md, upgraded YUTE_OS_AGENCY_FOUNDATION_v001.md (v001.1), YUTE_OS_v003_FIREWALL_PROOF_SPEC.md, updated Gherkin/fixtures/backlog, and evidence/WO-YUTE-AGENCY-001-validation.json pass all 567 control-plane checks with zero unauthorized media in the diff, and a Draft PR is open on wrasalmedia-rgb/wrasal-control for independent human audit.

AUTHORITATIVE_INPUTS:
- decisions/YUTE-ADR-0010.md (Controlled Advancement to Agency Runtime Verification)
- concepts/YUTE-FOUNDATION-DOCTRINE-001.md (v002)
- projects.yml
- work_orders/status-vocabulary.json

DEPENDENCIES:
- AGY-T003: Human audit of GitHub Draft PR diff and signature ratification of YUTE-ADR-0010 before provisioning private repository wrasalmedia-rgb/yute (READY)
- Independent of WO-YUTE-LUTA-DARRON-001 (remains strictly frozen under HOLD-RIGHTS-001; real performer data and synthetic human reconstruction are NO GO)

CURRENT_TASK: AGY-T003 — Human Ratification of YUTE-ADR-0010 & Draft PR Diff Audit

ACCEPTANCE:
- missions/WO-YUTE-AGENCY-001/migrations/003_verify_pg16_invariants.sql (10/10 PG 16.4 SQLSTATE invariants PASS)
- missions/WO-YUTE-AGENCY-001/YUTE_OS_v003_FIREWALL_PROOF_SPEC.md (5 inspectable proof artifacts + TEST-01..TEST-06)
- missions/WO-YUTE-AGENCY-001/YUTE_AGENCY_ACCEPTANCE_TESTS.feature (@YUTE-OS-v003-PROOF, @YUTE-AGENCY-INV-001, @YUTE-AGENCY-INV-002, @TEST-01..@TEST-06)
- Control-plane validation: npm test PASS (567/567 checks)

DECISIONS:
- YUTE-ADR-0010 recorded: Tier 1 Limited Engineering Authorization (fictional-data consent/firewall verification) separated from Tier 2 Full Product Reactivation (FROZEN / NO GO).
- YUTE-AGENCY-INV-002 enforced via 15 composite foreign keys across 001_yute_mvp_core.sql and 002_yute_agency_foundation.sql: cross-subject, cross-asset, and cross-purpose splicing fails closed with SQLSTATE 23503 (TEST-06).
- Five-Stage Consent Process modeled (PRESENTED -> ACKNOWLEDGED -> EXPLAINED -> DECIDED -> AUTHORIZED) preserving process evidence without manufacturing claims of internal comprehension; EGRESS-FENCE-v001 defines Point of Irrevocable Egress (first_payload_byte_flushed_at).
- Public-repo privacy minimization executed (YUTE-PRIVACY-AUDIT-001): raw personal email and granular personal body-marking motifs redacted across public Darron discovery records while HOLD-RIGHTS-001 remains active.

EVIDENCE:
- decisions/YUTE-ADR-0010.md
- concepts/YUTE-FOUNDATION-DOCTRINE-001.md
- evidence/WO-YUTE-AGENCY-001-validation.json
- evidence/WO-YUTE-AGENCY-001-pg16-schema-verification.json
- missions/WO-YUTE-AGENCY-001/migrations/001_yute_mvp_core.sql
- missions/WO-YUTE-AGENCY-001/migrations/002_yute_agency_foundation.sql
- missions/WO-YUTE-AGENCY-001/migrations/003_verify_pg16_invariants.sql
- missions/WO-YUTE-AGENCY-001/YUTE_PRIVACY_MINIMIZATION_AUDIT_001.md
- missions/WO-YUTE-AGENCY-001/YUTE_OS_AGENCY_FOUNDATION_v001.md
- missions/WO-YUTE-AGENCY-001/YUTE_OS_v003_FIREWALL_PROOF_SPEC.md
- missions/WO-YUTE-AGENCY-001/WO_YUTE_AGENCY_001_WORK_ORDER.md
- missions/WO-YUTE-AGENCY-001/YUTE_AGENCY_ACCEPTANCE_TESTS.feature
- missions/WO-YUTE-AGENCY-001/YUTE_AGENCY_TASK_BACKLOG.csv
- missions/WO-YUTE-AGENCY-001/YUTE_AGENCY_FICTIONAL_TEST_FIXTURES.md
