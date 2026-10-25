# ALIEN-001 — Hold Confirmation, Timeline Erratum & Custody Refinement

**Case:** FOR3NSIC-ALIEN-001 — FOLLOW THE MONEY  
**Reported closeout:** `933662f`  
**Baseline:** v0.1.1 frozen at `bb09bc1`; preserved without edits  
**Active preparation:** v0.1.2 closeout with this correction recorded as v0.1.3  
**Decision:** PROVISIONAL ACCEPTANCE — PHASE 1 HOLD CONTINUES  
**Current financial finding:** **UNDETERMINED**  
**Date:** 2026-10-25  

> Preserve the existing baseline. Do not begin financial reconstruction. Correct the timeline count and distinguish byte integrity from document provenance and issuer authenticity. No new financial evidence was received; no financial transactions or monetary findings are inferred.

## 1. Timeline count and classification — reconciled

The current clean CSV is `cases/ALIEN-001/ALIEN-001_event_timeline.csv` (also mirrored at the repository root). It contains **8 lines total: 1 header + 7 data rows**. There is no comment/pseudo-row in the CSV. Classification totals are **2 administrative + 5 narrative_premise = 7 data rows**.

| Event ID | Class | Description / scope |
|---|---|---|
| `EVT-INTAKE-001` | administrative | Phase 0 intake initiated |
| `EVT-INTAKE-002` | administrative | Evidence register inventory created |
| `EVT-ACCOUNT-OPEN-001` | narrative_premise | Account One opening premise, May 2023; no statement supplied |
| `EVT-ACCOUNT-CLOSE-001` | narrative_premise | Account One closure premise, Sep 2024; reason unknown |
| `EVT-GAP-001` | narrative_premise | Oct–Nov 2024 gap premise; funding and obligations unresolved |
| `EVT-ACCOUNT-OPEN-002` | narrative_premise | Account Two opening premise, Dec 2024; no statement supplied |
| `EVT-PERIOD-END-001` | narrative_premise | Work-order reconstruction cutoff, Oct 25 2026 |

The prior closeout/README wording that reported six narrative timeline events was wrong. The earlier v0.1.1 verification receipt also described the frozen timeline as “header + 6 events”; that statement is retained as historical receipt text, not repeated as a current count. At `bb09bc1`, the frozen timeline blob `dbbe22c…` contains seven event-ID rows (2 intake + 5 boundary/cutoff rows). The frozen manifest itself remains untouched. The v0.1.2 pre-correction timeline had seven intended event rows but malformed column alignment; it is replaced by a correctly serialized CSV, not treated as a financial record or a change to the frozen baseline.

**Current timeline SHA-256:** `de93bd48bcde1c3df655d4cc224d66ca8c665fe3d39dd6ae9cc8e66ff0ab6193`  
**Reproducible checks:**

```bash
wc -l cases/ALIEN-001/ALIEN-001_event_timeline.csv
# 8 (header + 7 data rows)
python3 - <<'PY'
import csv
from collections import Counter
with open('cases/ALIEN-001/ALIEN-001_event_timeline.csv', newline='', encoding='utf-8') as f:
    rows = list(csv.DictReader(f))
print(len(rows), Counter(row['evidence_class'] for row in rows))
print([row['event_id'] for row in rows])
PY
# 7 Counter({'narrative_premise': 5, 'administrative': 2})
# IDs listed in the table above
sha256sum cases/ALIEN-001/ALIEN-001_event_timeline.csv
```

**Frozen baseline versus current file:** the frozen manifest continues to identify the `bb09bc1` timeline blob by hash `dbbe22c…` (2,328 bytes). The current v0.1.3 timeline is a new, auditable version with a different hash and clean 13-column rows. Nothing in the frozen manifest or historical receipt is rewritten. The discrepancy is recorded in this erratum and current provenance.

## 2. Custody assurance — four distinct questions

A SHA-256 hash answers a narrow question: **are these bytes the same as the bytes that were hashed?** It does not establish who created or supplied the document, whether it came from a bank, or whether the issuer confirms it.

| Dimension | What it establishes | What it does not establish |
|---|---|---|
| **File integrity** | A recomputed hash matches the preserved file's recorded hash; byte changes are detectable relative to that hash. | Source, authorship, bank issuance, or factual accuracy. |
| **Document provenance / custody** | The recorded handoff and handling path (who supplied the file, when, by what method, and where it was preserved), to the extent documented. | That the original supplier was the issuer or that the document is genuine. |
| **Apparent authenticity** | Observable features and internal consistency (for example, statement period, page sequence, account alias, and balance arithmetic) may be consistent with a bank document. Record observations and limitations. | Independent confirmation by the bank; visual features can be imitated. |
| **Independently verified issuer authenticity** | The issuer has independently confirmed issuance, through an appropriately verified channel or equivalent evidence. | This cannot be claimed from a hash, a screenshot, a logo, or internal consistency alone. |

For all currently missing financial evidence (EV-003..032), these checks are **not performed** because no financial source documents have been received. No current evidence is described as independently bank-authenticated. Any future receipt must record each dimension separately, including `not_attempted` where applicable. Do not contact a bank or other third party without explicit human authorization under the Work Order.

The future admission receipt should report: source identity as provided; handoff/provenance facts and gaps; preserved-file hash and verification; apparent-authenticity observations and exceptions; issuer-verification status (`verified`, `not_attempted`, or `unable_to_verify`, with method/source); and the human accept/reject request. An “ACCEPTED for provisional forensic ingestion” decision must not be presented as independent bank authentication.

## 3. Append-only custody and separation

- The v0.1.1 frozen manifest and its recorded hashes remain unchanged. Current corrections are separate versioned artifacts with new hashes and Git history; historical evidence and receipt text remain traceable.
- A future source acquisition receives a new evidence ID (EV-033+) and a new custody event (CUST-017+); do not overwrite existing evidence-register rows or earlier custody entries. Administrative originals remain in `originals/`; financial source originals are kept separately in `financial_originals/`; narrative premises remain in the timeline. No new directory is needed until evidence arrives.
- Financial source documents remain distinct from administrative artifacts and narrative premises through the `evidence_class` field. A repository commit or a verified hash is never financial corroboration.
- No financial source has been received: zero extracted transactions, zero periods reconciled, and zero supported monetary findings. The master ledger remains empty and financial conclusions remain **UNDETERMINED / UNRESOLVED**.

## 4. Hold directive and next trigger

**Hold remains active.** No reconstruction, ledger promotion, external bank contact, or monetary conclusion is authorized by this reconciliation.

**Next execution trigger:** receipt of the first financial source document, preferably the earliest available Account One statement covering May 2023. Its receipt begins with preservation and a custody record; it does not presume an opening balance, deposit, withdrawal, or posting chronology. Those facts can only be recorded if shown by the source and admitted through the Phase 1 Evidence Admission Receipt, with exceptions and a human approval request.

**Next deliverable:** Phase 1 Evidence Admission Receipt with source identity, custody reference, file-integrity result, provenance, apparent-authenticity observations, issuer-authentication status, validation outcome, exceptions, and human approval request.

> **REALITY FIRST. TECHNOLOGY SECOND. The paper trail begins with a receipt, not an assumption.**
