# ALIEN-001 Missing Evidence & Document Request — Phase 0

**Case:** FOR3NSIC-ALIEN-001 — FOLLOW THE MONEY (ALIEN)  
**Subject:** Alien — first bank account opened May 2023 through October 25, 2026  
**Version:** 1.0 (Phase 0 Intake)  
**Date:** 2026-10-25 (UTC)  
**Classification:** Confidential Financial Evidence — Read-Only  
**Author:** Arena.ai Intake Agent (external execution worker)  
**Human Approval Gate:** Gate A — Intake approval REQUIRED before reconstruction  
**Commit:** af529b54e14974eec42e1f4dd200f06c61175f15  
**Branch:** arena/bce16055-wrasal-control  
**Evidence Register:** ALIEN-001_evidence_register.csv (32 evidence IDs, 2 received, 30 missing categories)  
**Provenance:** ALIEN-001_provenance.json  

---

## Executive Summary — No Financial Documents Have Been Supplied

As of 2026-10-25, the intake repository contains **no bank statements, transaction exports, check images, wire confirmations, or creditor receipts** for the period May 2023–October 25, 2026. The only sources inventoried are:

- **EV-001** Work Order FOR3NSIC-ALIEN-001 v1.0 (authority document, not financial evidence)
- **EV-002** wrasal-control repository scaffold at git commit af529b5 (control-plane baseline)

All 30 financial evidence categories defined in Work Order Section 3 (A–E) are **MISSING**. Consequently:

- **Gate P0 is NOT PASSED.** No reconstruction may be represented as complete.
- No master ledger entries have been extracted.
- No balance reconciliation has been attempted.
- No Jamaica payment has an evidenced disposition.
- No check/overdraft sequence has been traced.
- No money lost, fraud, successful delivery, or bank wrongdoing is alleged — **no evidence supports or refutes such claims at this time**.

This document catalogs each missing category, explains why it matters, and proposes a prioritized request order for the human case owner.

---

## 1. Method — How Missing Was Determined

- Work Order Section 3 Input Evidence Register enumerates five evidence families (A–E) that Arena shall request or ingest where available.
- Phase 0 requires: assign unique evidence ID, record filename/date received/date range/format/custodian, compute SHA-256, preserve original read-only, generate redacted copy, record missing periods.
- Intake searched the current repository working tree, git history, and supplied conversation attachments. Result: zero financial source files found.
- Each missing family has been assigned evidence IDs EV-003–EV-032 with status `MISSING` in the evidence register and `UNRESOLVED` in the exception register.
- Originals: preserved read-only where they exist (EV-001 work order text hashed and stored in `cases/ALIEN-001/originals/`; EV-002 preserved via immutable git commit). Future originals will be stored in `cases/ALIEN-001/originals/` with SHA-256 hashes recorded before any redaction.

**Governing doctrine enforced:**
> Recording is not verification. Authorization is not settlement. Debit is not proof of recipient receipt. Missing evidence is not proof of misconduct. Uncertainty must remain visible. No evidence → no authority → no state change.

---

## 2. Coverage Map — What Should Exist vs What Exists

### 2.1 Account Timeline (Work Order Section 2)

| Period | Account or Event | Initial Status | Evidence Present? | Coverage |
|---|---|---|---|---|
| May 2023 | First account opened | Story premise | No | 0% — EV-003 missing |
| May 2023 – Sep 2024 | Deposits, checks, overdrafts, payments (Account One) | Reconstruction required | No | 0% — up to 17 calendar-month periods missing + exports* |
| Sep 2024 | First account closed | Reason unknown | No | 0% — EV-007 missing |
| Oct – Nov 2024 | Gap between accounts | Funding and obligations unresolved | No | 0% — EV-032 gap |
| Dec 2024 | Second account opened | Story premise | No | 0% — EV-004 missing |
| Dec 2024 – Oct 25, 2026 | Continued financial activity (Account Two) | Reconstruction required | No | 0% — up to 23 calendar-month periods missing + exports* |
| **TOTAL** | **May 2023 – Oct 25, 2026** | **42 calendar months inclusive** | **No** | **0% coverage — up to 40 potential statements (17+23) + 2-month gap = 42 calendar months** |

**Key boundary conditions that must not be inferred:**
- Account One and Account Two were **not** continuously active (Work Order Section 5: Do not infer that the two accounts were continuously active).
- Closure reason (customer vs bank-initiated) is **unknown** and must remain unstated until EV-007 supplies a closure notice (AT-06).
- Gap funding source is **unknown** (EV-032).

> **Erratum — Corrected coverage calculation (Gate A review 2026-10-25):** Previous draft stated ~16/22/38. Corrected inclusive calendar-month maximum is **17 (May 2023–Sep 2024) + 23 (Dec 2024–Oct 2026) = 40 potential monthly statements**; total calendar months May 2023–Oct 2026 inclusive = **42 (17 + 2 gap + 23)**. This is a **calendar-month ceiling**, not a verified count of issued statements. Actual number of statements issued depends on: (a) account opening date within May 2023 (partial first cycle), (b) closing date within Sep 2024/Dec 2024, (c) bank statement cycle day (calendar vs 15th-15th etc.), and (d) whether closing statement is combined/partial. Statement cycles must be established from actual bank records when supplied — see exception register EXC-P0-001 footnote.

---

## 3. Detailed Missing Evidence by Family

### A. Bank Account Records (EV-003 through EV-009)

| Evidence ID | Document | Date Range / Quantity Est. | Priority | Why Required (Work Order Phase) |
|---|---|---|---|---|
| EV-003 | **Monthly statements — Account One** | May 2023–Sep 2024 (up to 17 calendar-month periods: 2023-05 .. 2024-09)* | **P1 — CRITICAL** | Phase 1 Master Ledger source + Phase 2 balance reconciliation (Opening + credits − debits = expected closing). AT-02 requires every period inventoried as present/partial/missing. AT-03 requires reproducible arithmetic. Without these, no balance can be confirmed. |
| EV-004 | **Monthly statements — Account Two** | Dec 2024–Oct 25, 2026 (up to 23 calendar-month periods: 2024-12 .. 2026-10)* | **P1 — CRITICAL** | Same as above for Account Two. Also required for Phase 5 closure/reopening: first posted deposit and initial funding source. |
| EV-005 | **Transaction exports CSV/OFX/QFX** | May 2023–Oct 2026 (both accounts) | P1 — CRITICAL | Phase 1 extraction source if statements are PDF-scanned. Preserves original transaction wording, posting date, amount, running balance, transaction_reference. Must retain source meaning without alteration. |
| EV-006 | **Opening and closing balance records** | Both accounts, all periods | P1 — CRITICAL | Phase 2 reconciliation anchor + Phase 5 closure: last posted transaction, documented closing balance, final disbursement trace, initial funding source identification. |
| EV-007 | **Account closure correspondence** | Sep 2024 (Account One) | P1 — CRITICAL | Phase 5: locate closure notice, determine documented closing balance, trace final disbursement, establish closure initiator **only if records support it** (AT-06 prohibits invention). |
| EV-008 | **Deposit and withdrawal confirmations** | All deposits/withdrawals May 2023–Oct 2026 | P2 — HIGH | Distinguish transaction date vs posting date vs authorization vs settlement; identify provisional credit dates and holds. |
| EV-009 | **Overdraft and fee notices** | All overdraft episodes | P2 — HIGH | Phase 4: produce separate timeline for every significant overdraft episode; separately account for overdraft fees, reversals, corrections. |

**What to request:**  
Bank-issued monthly statements (PDF preferred; CSV/OFX export if available) for **both** Account One and Account Two covering full date ranges above. Include statement header showing account alias (last 4 redacted), statement period, opening balance, closing balance. Include all pages (even blank/notice pages) to preserve running balance continuity.

**Redaction guidance (Phase 0 step 6):**  
Originals remain unchanged with SHA-256 hash computed. Generate redacted analysis copies masking full account numbers (keep last 4 for alias), full name → initials if required, but preserve amounts, dates, descriptions, and running balances exactly.

---

### B. Checks and Deposits (EV-010 through EV-014)

| Evidence ID | Document | Priority | Why Required |
|---|---|---|---|
| EV-010 | Check images and deposit receipts | P2 — HIGH | Phase 4 deposit/return sequence step 1–2: entered + provisional credit |
| EV-011 | Deposit dates and provisional credit dates | P2 — HIGH | Distinguish provisional credit date from availability date |
| EV-012 | Hold and funds-availability notices | P2 — HIGH | Explain apparent shortages: delayed availability vs posted spending |
| EV-013 | Returned-check notifications | P2 — HIGH | Step 4 of sequence: subsequently returned/reversed; AT-05 link reversal to original |
| EV-014 | Reversal entries and related fees | P2 — HIGH | Step 5: additional debits/fees; Phase 2 separately account reversals/corrections |

**What to request:**  
For every deposited check during the period: front/back check images, deposit slip/receipt with deposit date, bank notice showing provisional credit date and amount, hold notice showing available amount and release date, and if returned: returned-check notification, reversal entry on statement, and fee debit.

**Analytical rule:**  
A disappearing pending entry is **not** automatically a debit, refund, or loss. Identify its corresponding posted transaction, expiration, reversal, or unresolved status.

---

### C. International Payments to Jamaica (EV-015 through EV-020)

This family is the core of the **Follow the Money** question and the ~$500–$600 monthly intention.

| Evidence ID | Document | Priority | Why Required |
|---|---|---|---|
| EV-015 | Wire/remittance instructions | **P1 — CRITICAL** | Phase 3 payment chain start: Intention → Instruction → Authorization |
| EV-016 | Payment confirmation numbers | P1 — CRITICAL | Authorization → Debit evidence |
| EV-017 | Transaction tracking references | P1 — CRITICAL | Processing stage |
| EV-018 | Exchange-rate and fee disclosures | P1 — CRITICAL | Preserve original debit and net received; FX conversion |
| EV-019 | Cancellation/rejection/return/recall notices | P1 — CRITICAL | Classify disposition: CONFIRMED_RETURNED/CANCELLED/REJECTED |
| EV-020 | Recipient acknowledgments + receiving-bank records | **P1 — CRITICAL** | Phase 3 end: Recipient credit → Obligation credited; AT-04 compliance |

**What to request for each intended remittance (~41 possible monthly intents over period, per $500–600 lead):**  
- Remittance instruction record (date, sender alias, recipient name alias, amount intended, corridor USA→Jamaica, provider e.g., wire service/bank wire/remittance app)
- Confirmation number and tracking reference
- Bank debit entry tying instruction to ledger (with posting date)
- Fee and FX disclosure (rate, fee, net to recipient)
- Settlement confirmation or cancellation/return notice
- Receiving-bank credit advice or recipient acknowledgment
- Creditor application record (see E family)

**Critical distinction the report must maintain:**  
The ~$500–$600 monthly payment intention is a **lead, not proof** (Work Order Section 2 Scope). Do not assume 41 payments occurred. Some chains may be `CONFIRMED_NOT_INITIATED` (intention existed but instruction never sent). Some may be `INSTRUCTION_FOUND_DEBIT_UNVERIFIED`. Each chain is evidenced independently.

**Disposition classification (Phase 3 — exhaustive):**
- CONFIRMED_RECEIVED
- CONFIRMED_RETURNED
- CONFIRMED_CANCELLED
- CONFIRMED_REJECTED
- CONFIRMED_NOT_INITIATED
- DEBIT_CONFIRMED_RECEIPT_UNVERIFIED
- INSTRUCTION_FOUND_DEBIT_UNVERIFIED
- UNRESOLVED

Currently **all chains are UNRESOLVED** (EXC-P0-005).

---

### D. Communications and Security (EV-021 through EV-026)

| Evidence ID | Document | Priority | Why Required |
|---|---|---|---|
| EV-021 | Bank emails/letters/secure messages | P3 — MEDIUM | Phase 6 chronology of relevant messages/notices |
| EV-022 | Authentication and verification notices | P3 — MEDIUM | Distinguish routine verification from fraud alerts |
| EV-023 | Fraud or account restriction notifications | P2 — HIGH | Account restriction hypothesis; correlate with closure Sep 2024 |
| EV-024 | Screenshots of payment statuses | P2 — HIGH | Evidence of processing/settlement status at a point in time |
| EV-025 | Browser error records (Safari/Chrome/pop-up) | P3 — MEDIUM | Investigative possibility until evidenced; Phase 6 |
| EV-026 | Suspected phishing messages | P3 — MEDIUM | Correlate with transaction dates; phishing hypothesis |

**What to request:**  
Export or forward bank secure-message inbox (PDF), email notices (full headers), authentication codes are **NOT** requested (Phase 6 prohibits requesting passwords/OTPs/security answers). Include screenshots showing payment status, error pages (with URL and timestamp visible), and any suspected phishing (with headers).

**Hypothesis discipline (Phase 6):**  
Safari, Chrome, pop-up blocking, phishing, and account restrictions remain **possibilities until supported by evidence**. Do not presume browser failure or phishing caused missing payments.

---

### E. External Reconciliation — Jamaica (EV-027 through EV-031)

| Evidence ID | Document | Priority | Why Required |
|---|---|---|---|
| EV-027 | Jamaican debt statements | **P1 — CRITICAL** | Independent confirmation of obligation balances; Phase 3 endpoint |
| EV-028 | Creditor receipts | P1 — CRITICAL | Obligation credited |
| EV-029 | Bill payment confirmations | P1 — CRITICAL | Obligation credited |
| EV-030 | Recipient account credits | P1 — CRITICAL | Receiving-bank credit (AT-04) |
| EV-031 | Correspondence about missing/delayed payments | P2 — HIGH | Exception context for delayed/returned items |

**What to request:**  
Statements from Jamaican creditor(s) or debt holder(s) showing obligation name, period, amount due, amount credited, remaining balance — covering May 2023–Oct 2026. Include receipts or confirmation numbers tying each credit to a US debit (by date/amount/reference). Include correspondence where payee queried missing payments.

**AT-04 enforcement:**  
> No payment is marked received solely from a sender-side debit.  
A Jamaican debt is **not** paid because a US account was debited. Confirm whether intended creditor **applied funds to the obligation** (recipient account credit + obligation credited events).

---

## 4. Prioritized Document Request Order

**Tier 1 — Unblock Ledger & Reconciliation (must have before any $ total):**
1. EV-003 + EV-004 — Monthly statements for both accounts (full periods)
2. EV-005 — Transaction exports (CSV/OFX/QFX) if available
3. EV-006 + EV-007 — Opening/closing balances and closure correspondence

**Tier 2 — Unblock Jamaica Payment Trace (the $500–600 question):**
4. EV-015 + EV-016 + EV-017 — Remittance instructions, confirmations, tracking refs
5. EV-018 — FX and fee disclosures
6. EV-019 + EV-020 — Cancellation/return notices and recipient/receiving-bank records
7. EV-027 + EV-028 + EV-030 — Jamaican debt statements, creditor receipts, recipient credits

**Tier 3 — Unblock Check/Overdraft Explanation (apparent shortages):**
8. EV-009 + EV-010–EV-014 — Overdraft notices, check images, holds, returned-check notifications, reversals

**Tier 4 — Unblock Communication/Security Chronology (closure reason + fraud/phishing hypotheses):**
9. EV-021 + EV-023 + EV-024 — Bank messages, restriction notices, payment-status screenshots
10. EV-022 + EV-025 + EV-026 — Auth notices, browser errors, phishing messages
11. EV-031 — Correspondence about missing/delayed payments

---

## 5. Acceptance Tests Blocked by Missing Evidence

| Test | Requirement | Status |
|---|---|---|
| AT-01 | Every extracted transaction links to identifiable source | **BLOCKED** — 0 transactions extracted (no sources) |
| AT-02 | All statement periods inventoried as present/partial/missing | **SATISFIED at Phase 0** — all periods inventoried as MISSING (this document) |
| AT-03 | Balance arithmetic reproducible with differences logged | **BLOCKED** — no opening balances or posted entries |
| AT-04 | No payment marked received solely from sender-side debit | **SATISFIED by restraint** — no payments marked received (all UNRESOLVED) |
| AT-05 | Every check reversal linked to original deposit when evidence permits | **BLOCKED** — no checks/reversals supplied |
| AT-06 | Account closure reasons not invented | **SATISFIED by restraint** — closure reason remains unstated |
| AT-07 | Allegations/security hypotheses separated from observations | **SATISFIED by restraint** — no allegations made |
| AT-08 | Every material finding independently retestable | **SATISFIED at Phase 0** — findings limited to coverage gaps with evidence IDs |
| AT-09 | Confirmed totals distinguished from estimates/unresolved | **SATISFIED by restraint** — no totals presented as confirmed |
| AT-10 | Original evidence unmodified + human approval required | **SATISFIED at Phase 0** — originals preserved read-only; human approval Gates A–D documented as pending |

---

## 6. Preservation Method for Future Evidence

When documents are supplied:

1. **Do not modify original files.** Save to `cases/ALIEN-001/originals/` with original filename.
2. Compute **SHA-256** hash immediately; record in evidence register.
3. Generate **redacted analysis copy** in `cases/ALIEN-001/redacted/` masking full account numbers (keep last 4), identity documents, and credentials per Section 3E. Hash redacted copy separately.
4. Record source, custodian, date received, date range, format (CSV/OFX/QFX/PDF/image/email), and evidence ID.
5. Extraction preserves original transaction wording verbatim; add normalized fields alongside, never overwriting source meaning.
6. Secrets, full account numbers, identity documents, access credentials must be protected or redacted in working copies.

**Unreproducible / unreadable documents:** Logged as extraction_status=`unreadable` in register and as exception in exception register with proposed remediation (e.g., request rescan, alternate export).

---

## 7. What This Intake Does NOT Claim

To prevent misreading:

- ❌ Does not allege fraud, theft, loss, successful delivery, or bank wrongdoing.
- ❌ Does not calculate money lost, money received, or money owed.
- ❌ Does not classify any payment as successfully delivered based on a debit.
- ❌ Does not attribute account closure to customer or bank action.
- ❌ Does not conclude that the $500–600 monthly intention resulted in payments.
- ❌ Does not treat a disappearing pending authorization as a debit, refund, or loss.
- ✅ Does document that **without source records, no financial conclusion can be drawn** and that uncertainty must remain visible.

---

## 8. Gates & Next Steps

### Human Approval Gates (Work Order Section 8)

| Gate | Title | Phase 0 Status | What Human Must Do |
|---|---|---|---|
| **Gate A** | Intake approval | **REQUESTED** | Confirm evidence sources, authority, and permissible scope. Review this missing-evidence report and evidence register. Authorize progression to Phase 1 or supply additional documents. |
| Gate B | Reconstruction approval | NOT YET | Review ledger coverage and material discrepancies once extraction begins. |
| Gate C | Findings approval | NOT YET | Accept/reject/return individual conclusions for further review. |
| Gate D | Final release | NOT YET | Authorize forensic report for its intended audience. |

**Arena may prepare recommendations and evidence requests without authorization to contact a bank/creditor/recipient/third party. Arena must not initiate transfers, submit disputes, change account settings, or communicate allegations externally without separate explicit authorization (Section 8).**

### Next Candidate — If Authorized

Upon Gate A approval and receipt of Tier 1 documents:

1. Re-run intake: hash, preserve, inventory new evidence (update register to v0.2).
2. Execute Phase 1: Build master ledger (ALIEN-001_master_ledger.csv) extracting every entry without altering source meaning; preserve transaction/posting/authorization/settlement dates separately.
3. Execute Phase 2: Reconcile statement balances; investigate differences; assign exception IDs.
4. Execute Phase 3: Trace each Jamaica remittance individually with evidenced disposition.
5. Execute Phase 4: Reconstruct check/hold/overdraft timelines.
6. Execute Phase 5: Reconstruct closure and reopening with funding source.
7. Execute Phase 6: Build communication/security chronology.
8. Execute Phase 7: Final exception analysis.
9. Publish all 10 versioned artifacts with independent Challenge Agent review.

---

## 9. Contact & Custody

- **Human case owner (custodian):** Responsible for supplying originals; retains authority over scope and external contacts.
- **Arena Intake Agent:** Read-only examination; no authority to state-change balances, initiate transfers, or allege misconduct.
- **Originals custodian:** Human case owner (bank retains authoritative records).
- **Working copies location:** `cases/ALIEN-001/` on branch `arena/bce16055-wrasal-control` at commit `af529b5` + Phase 0 additions.

---

## Appendix — File Checklist for Human Case Owner

Copy this checklist when gathering documents:

```
[ ] Account One statements May 2023–Sep 2024 (all months, all pages)
[ ] Account Two statements Dec 2024–Oct 25 2026 (all months, all pages)
[ ] Transaction exports CSV/OFX/QFX if available (both accounts)
[ ] Opening/closing balance confirmations
[ ] Account One closure letter/notice + final disbursement record
[ ] Deposit/withdrawal confirmations + hold notices
[ ] Overdraft/fee notices (all episodes)
[ ] Check images + deposit receipts (all deposited checks)
[ ] Returned-check notifications + reversal entries
[ ] Remittance instructions + confirmation numbers (all Jamaica payments)
[ ] Tracking references + FX/fee disclosures
[ ] Cancellation/rejection/return notices
[ ] Recipient acknowledgments / receiving-bank credits
[ ] Jamaican creditor debt statements (May 2023–Oct 2026)
[ ] Creditor receipts / bill payment confirmations
[ ] Correspondence about missing/delayed payments
[ ] Bank emails/letters/secure messages (full headers)
[ ] Fraud/restriction notices
[ ] Payment-status screenshots (with URL+timestamp)
[ ] Browser error records / phishing messages (if any)
```

---

*End of Phase 0 Missing Evidence Report v1.0 — 2026-10-25*  
*No inference. No invention. Follow the receipts.*
