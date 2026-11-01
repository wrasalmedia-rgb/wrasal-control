# YUTE™ OS — Master Work Order: `WO-YUTE-AGENCY-001` (Contract Shield + Digital Rights Passport)

- **Document ID:** `WO_YUTE_AGENCY_001_WORK_ORDER`
- **Work Order ID:** `WO-YUTE-AGENCY-001`
- **Milestone:** `YUTE-OS-AGENCY-FOUNDATION-v001`
- **Priority:** `P0` *(Primary YUTE OS Product Foundation — Independent of `WO-YUTE-LUTA-DARRON-001` / `HOLD-RIGHTS-001`)*
- **Constitutional Doctrine:** `concepts/YUTE-FOUNDATION-DOCTRINE-001.md` (`v002`)
- **Version:** `v001`
- **Creation Date:** `2026-10-31`
- **Current Classification:** `ARCHITECTURAL FOUNDATION ESTABLISHED IN SPECIFICATION. RUNTIME ASSURANCE NOT YET VERIFIED.`
- **Canonical Acceptance:** `pending`

---

## 1. WORK ORDER IDENTIFICATION

| Field | Value |
|---|---|
| **Work Order ID** | `WO-YUTE-AGENCY-001` |
| **Title** | YUTE Contract Shield + Digital Rights Passport (`YUTE-OS-AGENCY-FOUNDATION-v001`) |
| **Priority** | `P0` |
| **Parent Ecosystem / Project** | `WRASAL™` / `yute` (`projects.yml`) |
| **Control Repository** | `wrasalmedia-rgb/wrasal-control` (`arena/732271e1-wrasal-control`) |
| **Target Runtime Repository** | `wrasalmedia-rgb/yute` *(Proposed — Ruby 3.3+ / PostgreSQL 16+)* |
| **Relationship to Darron Pilot** | Upstream general foundation; **decoupled from `HOLD-RIGHTS-001`**. Uses 100% fictional test agreements (`YUTE_AGENCY_FICTIONAL_TEST_FIXTURES.md`). The Digital Human Engine (`WO-YUTE-LUTA-DARRON-001`) consumes permissions from `Yute::AgencyFirewall`. |
| **Initial Status** | `SPECIFICATION ESTABLISHED (v002) / RUNTIME VERIFICATION PROPOSED (v003)` |

---

## 2. PROJECT OBJECTIVE

Build YUTE's foundational product layer around **human self-representation, contract comprehension, informed consent, and enforceable digital rights**—serving musicians, young performers, photographers, and everyday individuals even if they **never** generate an AI avatar:

`CONTRACT COMPREHENSION → INFORMED CONSENT → RIGHTS GOVERNANCE → AUTHORIZED ACTION`

Deliver five reusable Ruby/PostgreSQL capabilities—**`Contract Shield`**, **`Consent Ledger`**, **`Digital Rights Passport`**, **`Agency Firewall`**, and **`Evidence Vault`**—proven against constitutional invariant **`YUTE-AGENCY-INV-001`** and hardened against all five Mission Control forensic findings.

---

## 3. SUBJECT AND RIGHTS STATUS (TEST DATA POLICY)

- **Zero Real Personal Data Required for `v002`–`v004`:** All development, database constraint verification, and integration testing use synthetic personas and fictional agreements (`AGR-FICT-HARBOR-LIGHT-001`, `AGR-FICT-LABEL-DEAL-001`, `DRP-FICT-COASTAL-SERIES-001`, `SUBJ-FICT-KAI-001`).
- **Platform Self-Sovereignty:** YUTE's own user agreements must pass `Contract Shield` with zero AI-training capture, unrestricted sublicensing, or perpetual license-backs (`@SELF-GOV-01`).
- **Darron-Ray Donaldson Pilot (`WO-YUTE-LUTA-DARRON-001`):** Remains strictly frozen under **`HOLD-RIGHTS-001`**.

---

## 4. SOURCE INVENTORY

1. `concepts/YUTE-FOUNDATION-DOCTRINE-001.md` (`v002` Constitutional Engineering Revision)
2. `missions/WO-YUTE-AGENCY-001/YUTE_OS_AGENCY_FOUNDATION_v001.md` (5-component architecture, Forensic A–E SQL/service remediations, & `002_yute_agency_foundation.sql`)
3. `missions/WO-YUTE-AGENCY-001/YUTE_AGENCY_ACCEPTANCE_TESTS.feature` (`@YUTE-AGENCY-INV-001`, `@SHIELD-01`, `@PASSPORT-01`, `@FORENSIC-A`..`E`, `@SELF-GOV-01`)
4. `missions/WO-YUTE-AGENCY-001/YUTE_AGENCY_FICTIONAL_TEST_FIXTURES.md` (4 synthetic test suites)
5. `wrasal-control` verified S2/S3 baseline (`projects.yml`, `work_orders/status-vocabulary.json`, `scripts/validate-control-plane.mjs`).

---

## 5. CURRENT SYSTEM MATURITY

- **Specification Layer (`wrasal-control`):** **ESTABLISHED (`v002`).** Control-plane validator passes `567/567` checks; SQL DDL, Ruby interfaces, Gherkin acceptance tests, and fictional fixtures are versioned in Git.
- **Runtime Layer (`wrasalmedia-rgb/yute`):** **UNPROVISIONED (`0%` runtime assurance verified).** In accordance with `wrasal-control/README.md` (*"This repository is implementation-neutral. It does not contain product or runtime code"*), no Ruby runtime or live PostgreSQL claim is made here; runtime verification begins in `v003` upon human authorization to bootstrap `wrasalmedia-rgb/yute`.

---

## 6. PROPOSED TECHNICAL ARCHITECTURE

Full specification in `YUTE_OS_AGENCY_FOUNDATION_v001.md`:
- **Stack:** Ruby `3.3+` (`Sequel`, `Roda`, `Zeitwerk`, `RSpec`, `Cucumber`) + PostgreSQL `16+` (`pgcrypto`, `RLS`, `NOT NULL` + `CHECK` constraints, immutability triggers) + KMS `AES-256-GCM` Vault. **Zero Python, zero Express, zero Next.js.**
- **Five Reusable Agency Components:** `Yute::ContractShield`, `Yute::ConsentLedger`, `Yute::DigitalRightsPassport`, `Yute::AgencyFirewall`, and `Yute::EvidenceVault`, sitting downstream of Gate `00` (`Yute::WelfareGuard`).

---

## 7. PHASED IMPLEMENTATION PLAN (PROPOSED RELEASE GATES `v002 → v005`)

| Proposed Gate | Focus | Tasks | Current Status |
|---|---|---|---|
| **`v002` — Specification Advanced** | Consolidate doctrine, remediate Forensic Findings A–E in DDL/specs, define `YUTE-AGENCY-INV-001` & fictional fixtures. | `AGY-T001`–`AGY-T002` (`COMPLETE`); `AGY-T003` (`READY`) | **SPECIFICATION COMPLETE / REVIEW READY** |
| **`v003` — Runtime Verification** | Provision `wrasalmedia-rgb/yute`, run live PG 16 migrations, verify multi-boundary `CapabilityLease` checks, 3-tier adulthood transition, telemetry sanitizer, and 5-layer `RPP-v001` revocation propagation. | `AGY-T004`–`AGY-T007` | **PROPOSED** |
| **`v004` — Agency Infrastructure** | Deliver working `Contract Shield` (exact substring citations), `Consent Ledger`, `Digital Rights Passport`, end-to-end `YUTE-AGENCY-INV-001`, Digital Human Engine firewall unification, and self-sovereignty CI gate. | `AGY-T008`–`AGY-T012` | **PROPOSED** |
| **`v005` — Controlled Human Pilot** | Independent security test, legal review of disclosures/agreements, and supervised human pilot cohort. | `AGY-T013`–`AGY-T014` | **BLOCKED** (Requires `v003`/`v004` + Security/Legal/S5 sign-off) |

---

## 8. REQUIRED HUMAN APPROVALS

1. **Mission Control / Architecture Authority (`AGY-T003`):** Approve `YUTE-OS-AGENCY-FOUNDATION-v001` and authorize creating `wrasalmedia-rgb/yute` for `v003`.
2. **Legal Counsel (`AGY-T012`, `AGY-T013`):** Approve YUTE's self-sovereign Terms of Service, `Contract Shield` non-legal-advice boundaries, and statutory retention-hold procedures.
3. **Security Reviewer (`AGY-T013`):** Attest multi-boundary lease enforcement, KMS isolation, and revocation propagation before `v005` human onboarding.
4. **WRASAL S5 Authority (`WRAY`):** Separate canonical acceptance decision (`pending` → `accepted`).

---

## 9. DEPENDENCIES

- Internal S2/S3 schemas in `wrasalmedia-rgb/wrasal-control`.
- Provisioning of `wrasalmedia-rgb/yute` with Ruby `3.3+` and PostgreSQL `16+` CI containers (`AGY-T004`).
- Zero dependency on `WO-YUTE-LUTA-DARRON-001` talent outreach (`HOLD-RIGHTS-001`).

---

## 10. RESOURCE REQUIREMENTS

- **Lead Ruby / PostgreSQL Systems Engineer** (`v003`–`v004` migrations, `AgencyFirewall`, `RPP-v001` propagation)
- **Ruby Domain Engineer** (`v004` `Contract Shield` parser & `CitationVerifier`, `Digital Rights Passport`)
- **Entertainment / Digital Rights Legal Counsel** (clause taxonomy validation, YUTE self-sovereign ToS, retention-hold rules)
- **Primary & Co-Custodian Stewards** (two-person integrity roster per Remediation E)
- **Independent Security Reviewer** (`v005` gate)

---

## 11. TASK BREAKDOWN

Full machine-readable 14-task table in `YUTE_AGENCY_TASK_BACKLOG.csv` (`AGY-T001`–`AGY-T014`):
- **`AGY-T001` (`COMPLETE`):** Author `YUTE_OS_AGENCY_FOUNDATION_v001.md` & Forensic A–E SQL/service remediations.
- **`AGY-T002` (`COMPLETE`):** Author `YUTE_AGENCY_ACCEPTANCE_TESTS.feature` (`YUTE-AGENCY-INV-001`) & fictional fixtures.
- **`AGY-T003` (`READY`):** Human Architecture & Legal review to authorize `v003` repository bootstrap.
- **`AGY-T004`–`AGY-T007` (`PROPOSED` — `v003`):** Live PG 16 migration harness, multi-boundary `CapabilityLease` verification, 5-layer revocation propagation (`RPP-v001`), 3-tier adulthood transition, and `TelemetrySanitizer`.
- **`AGY-T008`–`AGY-T012` (`PROPOSED` — `v004`):** `Contract Shield` (`CitationVerifier`), `Consent Ledger` + `Digital Rights Passport`, end-to-end `YUTE-AGENCY-INV-001`, Digital Human Engine firewall unification, and Platform Self-Sovereignty CI gate.
- **`AGY-T013`–`AGY-T014` (`BLOCKED` — `v005`):** Independent security/legal audit and supervised human pilot launch.

---

## 12. ESTIMATED EFFORT (`[PLANNING ESTIMATES]`)

- **`v003` Runtime Verification (`AGY-T004`–`T007`):** `64–96 person-hours` (~2 engineering weeks)
- **`v004` Agency Infrastructure (`AGY-T008`–`T012`):** `80–120 person-hours` (~2.5–3 engineering weeks + `12–20 hrs` legal review)
- **`v005` Security Audit & Controlled Pilot (`AGY-T013`–`T014`):** `40–60 person-hours`

---

## 13. COST ASSUMPTIONS (`[PLANNING ASSUMPTIONS]`)

- **CI / Managed PostgreSQL 16 / KMS Staging (`v003`–`v004`):** `$150 – $450 / month` (zero GPU spend required because `WO-YUTE-AGENCY-001` requires no image/3D avatar rendering).
- **Legal Review of Clause Taxonomy & Self-Sovereign YUTE ToS:** `$2,500 – $5,000`.
- **Pre-Pilot Security Assessment (`v005`):** `$3,000 – $7,500`.

---

## 14. RISKS

1. **False Sense of Legal Advice (`Contract Shield`):** Mitigated by deterministic verbatim clause citations (`CitationVerifier`), `AMBIGUOUS_SCOPE_COUNSEL_NEEDED` flags, and prominent non-representation notices (`@SHIELD-01`).
2. **Non-HTTP Execution Bypass (`Finding A`):** Mitigated by requiring signed `<=60s` `FirewallCapabilityLease` tokens inside `SourceAssetVault` and adapter methods (`@FORENSIC-A`).
3. **Unlawful Deletion Promises vs. Childhood Capture (`Finding B`):** Mitigated by separating `ADULTHOOD_REAUTHORIZATION`, unconditional `PROCESSING_RESTRICTION`, and `ELIGIBLE_DATA_DELETION` with explicit `RetentionExceptionDisclosure` (`@FORENSIC-B`).
4. **Silent Downstream Persistence After Revocation (`Finding C`):** Mitigated by pre-commit mid-flight lease re-verification and `revocation_propagation_targets` status tracking (`@FORENSIC-C`).
5. **Platform Hypocrisy (`Section 06`):** Mitigated by running YUTE's own Terms of Service through `Contract Shield` as a release-blocking CI gate (`@SELF-GOV-01`).

---

## 15. ACCEPTANCE CRITERIA

1. `YUTE-AGENCY-INV-001` denies out-of-scope requests across HTTP, worker, CLI, admin, and adapter boundaries, records exact missing permissions, and transmits **zero** identity/creative bytes.
2. 100% of `Contract Shield` findings verify exact substring citations against `agreement_documents.raw_text_utf8`.
3. `Digital Rights Passport` preserves strict distinction between `OWNED_BY_SUBJECT`, `LICENSED_OUT_SCOPED`, `RESTRICTED_HOLD`, and `UNKNOWN` for avatar and non-avatar users alike.
4. PostgreSQL 16 live runtime rejects `NULL` loopholes (`@FORENSIC-A`), enforces 3-tier adulthood transitions (`@FORENSIC-B`), kills mid-flight revoked writes (`@FORENSIC-C`), blocks indirect valuation proxies (`@FORENSIC-D`), and enforces two-steward integrity + self-sovereign platform terms (`@FORENSIC-E`, `@SELF-GOV-01`).

---

## 16. DELIVERABLES (`missions/WO-YUTE-AGENCY-001/`)

1. `YUTE_OS_AGENCY_FOUNDATION_v001.md` — Consolidated 5-component architecture, Forensic A–E remediations, & hardened PostgreSQL 16 DDL
2. `WO_YUTE_AGENCY_001_WORK_ORDER.md` — 17-section P0 Master Work Order
3. `YUTE_AGENCY_ACCEPTANCE_TESTS.feature` — Executable Cucumber-Ruby Gherkin suite anchored by `@YUTE-AGENCY-INV-001`
4. `YUTE_AGENCY_TASK_BACKLOG.csv` — Strict RFC-4180 14-task backlog across `v002 → v005`
5. `YUTE_AGENCY_FICTIONAL_TEST_FIXTURES.md` — 100% fictional test agreements & personas
6. `README.md` — Deliverable index & SHA-256 provenance digests
- *Control-Plane Links:* `concepts/YUTE-FOUNDATION-DOCTRINE-001.md` (`v002`) and `work_orders/WO-YUTE-AGENCY-001.md`

---

## 17. NEXT AUTHORIZED ACTION

**Execute `AGY-T003` (`READY`):**
Mission Control and WRASAL Legal Counsel review `concepts/YUTE-FOUNDATION-DOCTRINE-001.md` (`v002`) and `missions/WO-YUTE-AGENCY-001/YUTE_OS_AGENCY_FOUNDATION_v001.md` to authorize provisioning **`wrasalmedia-rgb/yute`** for **`v003` Runtime Verification** (`AGY-T004`–`AGY-T007`) using strictly fictional fixtures—while keeping `WO-YUTE-LUTA-DARRON-001` safely paused under `HOLD-RIGHTS-001`.
