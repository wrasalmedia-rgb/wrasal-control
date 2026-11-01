# Arena Work Order

WORK_ORDER_ID: WO-YUTE-AGENCY-001

MILESTONE: YUTE-OS-v003 | AGENCY FIREWALL PROOF (under YUTE-ADR-0010)

PRIORITY: P0

VERSION: v001.1

CREATED_ON: 2026-10-31

STATUS: CONDITIONAL GO FOR FICTIONAL-DATA SPEC & DRAFT PR / AWAITING HUMAN RATIFICATION OF YUTE-ADR-0010 (canonical_acceptance: pending)

PROJECT: yute (YUTE GUARD — Know Before You Agree + Agency Firewall)

OBJECTIVE: Reconcile the October 20 Frozen/Concept portfolio baseline via YUTE-ADR-0010 (separating Tier 1 fictional-data consent engineering from Tier 2 frozen commercial/likeness reactivation), harden ConsentLedger signer-attribution ceremonies (3.A) and 4-axis non-universal revocation accounting (3.B), anchor Product Zero on YUTE GUARD ("KNOW BEFORE YOU AGREE."), specify the YUTE-OS-v003 young recording artist Agency Firewall Proof + Five Adversarial Runtime Tests (TEST-01..TEST-05), and open an inspectable Draft PR against wrasal-control.

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
- missions/WO-YUTE-AGENCY-001/YUTE_OS_v003_FIREWALL_PROOF_SPEC.md (5 inspectable proof artifacts + TEST-01..TEST-05)
- missions/WO-YUTE-AGENCY-001/YUTE_AGENCY_ACCEPTANCE_TESTS.feature (@YUTE-OS-v003-PROOF, @YUTE-AGENCY-INV-001, @TEST-01..@TEST-05)
- Control-plane validation: npm test PASS (567/567 checks)

DECISIONS:
- YUTE-ADR-0010 recorded: Tier 1 Limited Engineering Authorization (fictional-data consent/firewall verification) separated from Tier 2 Full Product Reactivation (FROZEN / NO GO).
- Product Zero locked to YUTE GUARD ("KNOW BEFORE YOU AGREE."): simple agreement upload, cited clause highlights, plain-language meaning, surfaced uncertainties, human decision, opt-in preservation.
- Forensic 3.A & 3.B enforced in DDL: document SHA-256 alone cannot create a ConsentLedger grant without verified signer ceremony; revocation tracks 4 separate axes and forbids claiming external deletion without receipt confirmation.

EVIDENCE:
- decisions/YUTE-ADR-0010.md
- concepts/YUTE-FOUNDATION-DOCTRINE-001.md
- evidence/WO-YUTE-AGENCY-001-validation.json
- missions/WO-YUTE-AGENCY-001/YUTE_OS_AGENCY_FOUNDATION_v001.md
- missions/WO-YUTE-AGENCY-001/YUTE_OS_v003_FIREWALL_PROOF_SPEC.md
- missions/WO-YUTE-AGENCY-001/WO_YUTE_AGENCY_001_WORK_ORDER.md
- missions/WO-YUTE-AGENCY-001/YUTE_AGENCY_ACCEPTANCE_TESTS.feature
- missions/WO-YUTE-AGENCY-001/YUTE_AGENCY_TASK_BACKLOG.csv
- missions/WO-YUTE-AGENCY-001/YUTE_AGENCY_FICTIONAL_TEST_FIXTURES.md
