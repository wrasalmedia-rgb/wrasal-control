# FOR3NSIC-ALIEN-001 — FOLLOW THE MONEY — Case Folder

**Subject:** ALIEN (fictional) — May 2023 through Oct 25, 2026
**Phase:** 0 — Authority and Evidence Intake Only
**Date:** 2026-10-25
**Branch:** arena/bce16055-wrasal-control
**Commit:** af529b54e14974eec42e1f4dd200f06c61175f15

## Contents

This folder implements read-only forensic reconstruction per work order v1.0.

### Generated artifacts (v0.1.0 Phase 0)

| File | Purpose | Status |
|---|---|---|
| ALIEN-001_evidence_register.csv | 32 evidence IDs, 2 received 30 missing, with SHA-256, source, date received, coverage | PHASE 0 COMPLETE |
| ALIEN-001_master_ledger.csv | Master transaction ledger (required fields per Phase 1) | PLACEHOLDER — 0 transactions |
| ALIEN-001_balance_reconciliation.xlsx | Monthly reconciliation (Opening + credits − debits = expected close) with README + Exception_Map sheets | PLACEHOLDER — 0 periods |
| ALIEN-001_remittance_trace.csv | Jamaica payment chain (Intention→Instruction→...→Obligation credited, 8 dispositions) | PLACEHOLDER — 0 chains |
| ALIEN-001_deposit_return_analysis.csv | Check/hold/return/overdraft sequences (5-step) | PLACEHOLDER — 0 sequences |
| ALIEN-001_event_timeline.csv | Chronology of account/transaction/communication events | 6 events (2 intake + 4 unverified boundaries) |
| ALIEN-001_exception_register.csv | Exceptions with competing explanations, confidence, next actions | 8 global exceptions (all PENDING) |
| ALIEN-001_missing_evidence.md | Full 30-category missing evidence report + prioritized Tier 1-4 request + checklist | PHASE 0 COMPLETE |
| ALIEN-001_forensic_report.md | Human-readable case report (this folder's authoritative Phase 0 report) | PHASE 0 COMPLETE — Gate A requested |
| ALIEN-001_provenance.json | Machine-readable provenance with hashes, acceptance tests, gates, agent matrix, completion contract | PHASE 0 COMPLETE |

### Originals (read-only preservation)

- `originals/FOR3NSIC-ALIEN-001_work_order.md` — Work order authority document (EV-001)
- `originals/repo_manifest.json` — Repo scaffold hashes at baseline commit (EV-002)

Future evidence intake will place originals here with SHA-256 hashes recorded in evidence_register.csv before any redaction. Redacted analysis copies will go in `redacted/` (not yet needed — no PII in Phase 0).

## Doctrine

> REALITY FIRST. TECHNOLOGY SECOND. Recording is not verification. Authorization is not settlement. Debit is not proof of recipient receipt. Missing evidence is not proof of misconduct. Uncertainty must remain visible. No evidence → no authority → no state change.

No transaction classified as fraudulent, stolen, delivered, or lost without evidence.

## Gates

- Gate P0: NOT PASSED as reconstruction completeness — correctly documented as intake-only with 0% coverage
- Gate A Intake Approval: REQUESTED — Human case owner must review evidence_register + missing_evidence + forensic_report and approve scope / supply Tier 1 docs
- Gates B-D: Not yet requested

## What this folder does NOT contain

- No bank statement PDFs/CSVs
- No calculated money-lost or money-received totals
- No allegations of fraud or bank wrongdoing
- No invented closure reasons
- No synthetic ledger entries

## Next steps (upon Gate A + Tier 1 evidence)

See Section 15 of forensic_report.md and Section 9 of missing_evidence.md

```
Checklist in missing_evidence.md Appendix — ~38 monthly statements + exports + closure notice + Jamaican creditor statements
```

---

*Do not manufacture the missing link. Follow the receipts.*
