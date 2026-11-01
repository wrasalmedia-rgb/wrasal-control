# Arena Work Order

WORK_ORDER_ID: WO-YUTE-AGENCY-001

MILESTONE: YUTE-OS-v003 | THE AUTHORITY PROOF (under YUTE-ADR-0010, YUTE-ADR-0011 & YUTE-ARCH-GOV-003)

PRIORITY: P0

VERSION: v001.4

CREATED_ON: 2026-10-31

STATUS: SPECIFICATION VERIFIED IN PART — PG 16.4 WASM ENGINE MIGRATIONS (001..005, 27/27 CHECKS) VERIFIED ON DRAFT PR #8 / AWAITING HUMAN RATIFICATION OF YUTE-ADR-0010 & YUTE-ADR-0011 FOR NETWORKED PG 16 & RUBY 3.3 RUNTIME (canonical_acceptance: pending; production: NO GO)

PROJECT: yute (YUTE — Know Before You Agree. Control What You Authorize. Preserve The Evidence.)

OBJECTIVE: Remediate Mission Control Engineering Audit 002 (YUTE-ARCH-GOV-003) across Findings A..D and Section 04 by adding migration 004_yute_authority_proof_hardening.sql (Ed25519 verify-only key registry & deterministic signing preimage SHA-256, row-locking atomic single-use envelope claim, live current-state authority re-evaluation at both pre-processing claim and receipt finalization boundaries, observable one-shot isolated worker disposal telemetry without overclaiming RAM erasure, and non-superuser NOBYPASSRLS service roles with FORCE ROW LEVEL SECURITY), verifying 27/27 SQLSTATE & RLS invariants on PostgreSQL 16.4, and specifying YUTE-OS-v003 | THE AUTHORITY PROOF (10 outcomes + 7 inspectable receipts) while preserving HOLD-RIGHTS-001 and human ratification gates.

SUCCESS_CONDITION: decisions/YUTE-ADR-0010.md, decisions/YUTE-ADR-0011.md, YUTE_YIE_IDENTITY_AUTHORIZATION_CONTRACT_v001.md (v001.1), standalone PostgreSQL 16 migrations 001..005 (27/27 PG 16.4 checks PASS), and evidence/WO-YUTE-AGENCY-001-validation.json pass all 567 control-plane checks with zero unauthorized media in the diff, and Draft PR #8 remains open in Draft mode on wrasalmedia-rgb/wrasal-control for independent human audit.

AUTHORITATIVE_INPUTS:
- decisions/YUTE-ADR-0010.md (Controlled Advancement to Agency Runtime Verification)
- decisions/YUTE-ADR-0011.md (YIY/YIE Identity Services Integration With YUTE Human Agency Governance)
- concepts/YUTE-FOUNDATION-DOCTRINE-001.md (v002.4)
- projects.yml
- work_orders/status-vocabulary.json

DEPENDENCIES:
- AGY-T003: Human audit of GitHub Draft PR #8 diff and signature ratification of YUTE-ADR-0010 and YUTE-ADR-0011 before provisioning private repository wrasalmedia-rgb/yute (READY — no human approval implied by Audit 002)
- Independent of WO-YUTE-LUTA-DARRON-001 (remains strictly frozen under HOLD-RIGHTS-001; real performer data, commercial deployment, and public launch are BLOCKED / NO GO)

CURRENT_TASK: AGY-T003 — Human Ratification of YUTE-ADR-0010, YUTE-ADR-0011 & Draft PR #8 Review

ACCEPTANCE:
- missions/WO-YUTE-AGENCY-001/migrations/005_verify_pg16_invariants.sql (27/27 PG 16.4 SQLSTATE & RLS checks PASS across migrations 001..004)
- missions/WO-YUTE-AGENCY-001/YUTE_YIE_IDENTITY_AUTHORIZATION_CONTRACT_v001.md (v001.1 — Findings A..D, Section 04 DB Roles, & 7-artifact Authority Proof)
- missions/WO-YUTE-AGENCY-001/YUTE_AGENCY_ACCEPTANCE_TESTS.feature (@AUTH-PROOF-01..@AUTH-PROOF-10, @YIE-PROOF-001, @YIE-NEG-01..07, @TEST-01..06)
- Control-plane validation: npm test PASS (567/567 checks)

DECISIONS:
- Audit 002 Finding A separated cleanly: PostgreSQL 16 enforces deterministic signing preimage SHA-256, 64-byte hex structure, active signing-key status, and fail-closed receipt verification status, while elliptic-curve Ed25519 signature verification math is explicitly tracked as a Ruby 3.3 Yie::AuthorizationGate runtime obligation (@AUTH-PROOF-03).
- Audit 002 Findings B & C enforced in 004_yute_authority_proof_hardening.sql: yie_claim_single_use_envelope() acquires FOR UPDATE row lock and blocks replay (23505), while yie_assert_live_authority_currency() re-evaluates live upstream spec/grant/subject/asset/lease/key currency at both pre-processing claim and receipt finalization boundaries (23514).
- Audit 002 Finding D & Section 04 enforced: replaced overbroad memory-erasure assumptions with one-shot isolated subprocess/microVM termination telemetry (PROCESS_ISOLATION_TELEMETRY_ONLY_NOT_RAM_PROOF), and restricted yie_capability_service via NOBYPASSRLS, FORCE ROW LEVEL SECURITY, 0 source_assets privileges, and 0 envelope INSERT privileges (42501).

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
- missions/WO-YUTE-AGENCY-001/migrations/004_yute_authority_proof_hardening.sql
- missions/WO-YUTE-AGENCY-001/migrations/005_verify_pg16_invariants.sql
- missions/WO-YUTE-AGENCY-001/YUTE_PRIVACY_MINIMIZATION_AUDIT_001.md
- missions/WO-YUTE-AGENCY-001/YUTE_OS_AGENCY_FOUNDATION_v001.md
- missions/WO-YUTE-AGENCY-001/YUTE_OS_v003_FIREWALL_PROOF_SPEC.md
- missions/WO-YUTE-AGENCY-001/WO_YUTE_AGENCY_001_WORK_ORDER.md
- missions/WO-YUTE-AGENCY-001/YUTE_AGENCY_ACCEPTANCE_TESTS.feature
- missions/WO-YUTE-AGENCY-001/YUTE_AGENCY_TASK_BACKLOG.csv
- missions/WO-YUTE-AGENCY-001/YUTE_AGENCY_FICTIONAL_TEST_FIXTURES.md
