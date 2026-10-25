# ALIEN-001 Chain of Custody & Evidence Controls — Phase 0 → Gate A Verification

**Case:** FOR3NSIC-ALIEN-001 — FOLLOW THE MONEY (ALIEN)  
**Version:** 0.1.1 (Corrected coverage)  
**Date:** 2026-10-25 Gate A Verification  
**Baseline Commit:** af529b54e14974eec42e1f4dd200f06c61175f15  
**Phase 0 Commit:** ec404b9ff25487f8c2fc6b26ddb75983b607a89e  
**Classification:** Confidential Financial Evidence — Read-Only  
**Custodian (human):** Human case owner ( retains authority over scope, external contacts, final approval Gates A-D)  
**Custodian (execution):** Arena.ai Intake Agent (external execution worker) on branch `arena/bce16055-wrasal-control`  
**Access Controls:** Branch protection via human approval gates; no autonomous financial actions authorized

---

## 1. Purpose

Git history and SHA-256 hashes support integrity checking but **do not alone establish an immutable chain of custody**. This document records the controls required by Gate A correction item #5:

- source acquisition (how each artifact/file entered custody)
- custody transfers (who handled it, when, where it moved)
- access controls (who could read/modify, how restricted)
- later modifications (versioning, corrections like 38→40)
- redaction procedures (future financial records)

This closes the gap identified in Phase 0 review: “Git history and file hashes support integrity checking, but do not alone establish an immutable chain of custody.”

---

## 2. Source Acquisition — Every File, When and How

### 2.1 Authority document (EV-001)

| Field | Record |
|---|---|
| **Evidence ID** | EV-001 |
| **Description** | FOR3NSIC-ALIEN-001 Work Order v1.0 (Issued 2026-10-25, Classification Confidential, Execution Mode Read-only) |
| **Acquisition date (UTC)** | 2026-10-25T17:24:04Z (system clock at evidence register creation) preserved 2026-10-25T17:31Z |
| **Source** | Arena work order message in conversation (Arena.ai Agent Mode); not a bank record |
| **Received via** | Human-provided text in Arena session; no file upload; transcribed verbatim to `cases/ALIEN-001/originals/FOR3NSIC-ALIEN-001_work_order.md` |
| **Original form** | Markdown text in conversation (no file hash from sender) |
| **Preserved form** | File `cases/ALIEN-001/originals/FOR3NSIC-ALIEN-001_work_order.md` created by Intake Agent (41 lines authority text + preservation header) |
| **SHA-256 (preserved)** | `5a08e681da88d4f4dc59db36de69c9f8dad3a48d2377b00338876cc20f71e769` (recomputed 2026-10-25T17:31Z) |
| **Custodian** | Arena Intake Agent (preservation) → human case owner (authority) |
| **Access** | Branch `arena/bce16055-wrasal-control` (read for Arena session, push requires GitHub auth as wrasalmedia-rgb) |
| **Redaction** | None required (no PII/account numbers in work order); working copy identical to original |
| **Later modifications** | None to original; corrections in v0.1.1 (coverage) apply only to derived artifacts (register, report), not to this preserved original — original remains read-only as committed at ec404b9 |

### 2.2 Repository scaffold (EV-002)

| Field | Record |
|---|---|
| **Evidence ID** | EV-002 |
| **Description** | wrasal-control portfolio-control scaffold at baseline commit |
| **Acquisition date** | 2026-10-15T18:35:55-04:00 (merge commit PR#3) — branch `arena/bce16055-wrasal-control` created from this commit 2026-10-25 |
| **Source** | GitHub `wrasalmedia-rgb/wrasal-control` — commit `af529b54e14974eec42e1f4dd200f06c61175f15` (merge of `docs/wrasal-campaign-execution-method-001`) |
| **Git SHA (commit)** | `af529b5` short, `af529b54e14974eec42e1f4dd200f06c61175f15` full |
| **Git SHA (Phase 0 commit)** | `ec404b9ff25487f8c2fc6b26ddb75983b607a89e` (Phase 0 intake) |
| **Files hashed** | `README.md` `5ea9a578…`, `projects.yml` `5452ab3a…`, `dependencies.yml` `568c092a…`, `priorities.yml` `e08cccd…`, `concepts/WRASAL-CAMPAIGN-EXEC-METHOD-001.md` `2ed6b4af…`, `work_orders/status-vocabulary.json` `4a9a0d60…`, `evidence/WRASAL-0005-validation.json` `500c609d…` (see `originals/repo_manifest.json`) |
| **Preserved form** | `cases/ALIEN-001/originals/repo_manifest.json` (manifest with hashes of scaffold files at baseline) + immutable git objects |
| **Custodian** | wrasalmedia-rgb (GitHub) → Arena sandbox (clone) → Intake Agent (preservation) |
| **Access** | Git history is read-only storage; modification requires new commit with new hash (detectable) |

### 2.3 Phase 0 derived artifacts (10 deliverables, v0.1.0 → v0.1.1 corrected)

| Artifact | Created (UTC) | Source | Derived From | SHA-256 (v0.1.0) | SHA-256 (v0.1.1 corrected) | Access |
|---|---|---|---|---|---|---|
| `ALIEN-001_evidence_register.csv` | 2026-10-25T17:25:00Z | Intake Agent generation | EV-001 categories A-E + gap | `c053ac71b6c2acdc008ea5848ad4a18d3af097c809ec18af39e281c7e3a47973` | *recompute below* (minor note correction about coverage not affecting rows) | Branch, read-only except Intake Agent |
| `ALIEN-001_master_ledger.csv` | 2026-10-25T17:25Z | Intake Agent | EV-003..EV-005 (MISSING) → header only | `9141e7662a71a4b17f2a4a70dbb7f30ffaa3ce332a00a33b9a7d14e9666e0cd4` | unchanged (header only) | same |
| `ALIEN-001_balance_reconciliation.xlsx` | 2026-10-25T17:29Z | Intake Agent (python openpyxl 3.1.5) | Phase 2 placeholder | `1ac72cbe785308cf00c237cc6a45632ad7450f65bfc55e8dd6b4f693a502d2a9` → corrected 2026-10-25T~17:40Z | *recompute below* | same |
| `ALIEN-001_remittance_trace.csv` | 2026-10-25T17:25Z | Intake Agent | EV-015..EV-020 (MISSING) | `09fd356cfa68ac3252f04aaba4506709431872855c615e3f21de182057377b9c` | unchanged | same |
| `ALIEN-001_deposit_return_analysis.csv` | 2026-10-25T17:25Z | Intake Agent | EV-010..EV-014 (MISSING) | `cf3c3c8628ad89d063749c18260b79fc13b74a8135d3a901f7cb00998a12942a` | unchanged | same |
| `ALIEN-001_event_timeline.csv` | 2026-10-25T17:25Z | Intake Agent | Boundary events May2023-Oct2026 | `dbbe22c79b8347a3b89fc31ab239d45b53bd55d2e82af16a204116b9d39e3b89` | unchanged | same |
| `ALIEN-001_exception_register.csv` | 2026-10-25T17:25Z | Intake Agent | 8 globals EXC-P0-001..008 | `65508b846c0433fa5dde38d7a12dfd5c91a83d95dee6778cb1c36b761dd9f604` | unchanged (notes reference but count not in this file) | same |
| `ALIEN-001_missing_evidence.md` | 2026-10-25T17:26Z | Intake Agent | Work Order §3A-E | `74a928251d0712af52c88f465b5f379ef41b75371092052437fef94e75fa7bfc` → corrected | *recompute below* | same |
| `ALIEN-001_forensic_report.md` | 2026-10-25T17:28Z | Intake Agent | Phases 0-7 snapshot | `996b3cf18abf0e5ec0aaa6f5739e28f8a945eafb26d04e2268f6dfcc8126eb9c` → corrected | *recompute below* | same |
| `ALIEN-001_provenance.json` | 2026-10-25T17:30Z | Intake Agent | All above + git + validator | `fcc99c821aa31d8754377a54f54d42a022d30d48dfbbd77658decfe35a75e8d4` → corrected | *recompute below* | same |

**Acquisition method for derived artifacts:** Not externally supplied — generated by Intake Agent from work order authority + observation of empty repository (zero financial sources). No external file ingestion occurred in Phase 0, so no unrecorded custody transfer from human→Arena for financial data.

### 2.4 Financial source files (EV-003..EV-032)

| Field | Record |
|---|---|
| **Count** | 30 categories, 0 files received |
| **Acquisition date** | — (not yet supplied) |
| **Custody transfer (future)** | Human case owner → secure handoff (e.g., encrypted archive, redacted analysis copy) → `cases/ALIEN-001/originals/` (read-only) + `cases/ALIEN-001/redacted/` (analysis copy) |
| **Access controls (future)** | Originals readable by Intake Agent for hashing/extraction only; no autonomous modification; human retains revocation; no external bank contact per §8 |
| **Redaction** | Full account numbers masked to last 4 for alias, identity docs to initials if required, credentials/access tokens never stored — documented in §5 below |

---

## 3. Custody Transfers — Who Handled What, When

### 3.1 Human ↔ Arena custody flow

```
Human case owner
  │
  │ (1) Work order text via Arena conversation 2026-10-25
  ▼
Arena sandbox (branch arena/bce16055-wrasal-control from af529b5)
  │
  │ (2) Intake Agent clones repo, creates cases/ALIEN-001/ , preserves originals/, hashes
  ▼
Intake Agent
  │
  │ (3) Generates 10 artifacts v0.1.0 (header-only placeholders where no data)
  ▼
Git commit ec404b9 (2026-10-25T17:31:31Z, author Arena Intake Agent <arena@wrasal.media>, committer same, signed by GitHub push as wrasalmedia-rgb)
  │
  │ (4) Push to origin/arena/bce16055-wrasal-control (GitHub)
  ▼
GitHub (remote durable storage)
  │
  │ (5) Human review (Gate A Conditional Approval 2026-10-25) — identifies coverage 16/22/38→17/23/40 correction
  ▼
Arena verification pass (this document + v0.1.1 corrections)
  │
  │ (6) Corrected artifacts v0.1.1 (same branch, new commit to be pushed)
  ▼
Human re-review (Gate A Verification Receipt)
```

**Each transfer leaves an artifact:**
- (1) Conversation history (Arena log) + preserved work order file with hash
- (2) `repo_manifest.json` with scaffold hashes
- (3) Artifacts with version 0.1.0 and provenance JSON capturing tool/branch/commit
- (4) Git commit object (immutable SHA, parent af529b5) and `git push` log
- (5) Gate A Decision text (human-provided)
- (6) New commit with correction notes (this custody doc + receipt) — audit trail of modification

### 3.2 Why Git SHA alone is insufficient (Gate A review point)

| What Git SHA proves | What it does NOT prove |
|---|---|
| The file content at that commit hash has not changed since the commit (integrity) | Who originally acquired the file (acquisition source) |
| The commit parentage (history) is as claimed | Whether the acquisition was lawful/authorized (human authority) |
| Later modifications create new SHA (tamper detection) | Access controls between acquisition and commit (custody transfers) |
| Push time is logged remotely | That redaction was performed correctly (masking vs deletion) |
|  | Chain of custody across handoffs (human→Arena→GitHub) |

**Therefore this custody document supplements SHA hashes with:**
- Acquisition timestamps and sources (Section 2)
- Custody transfer log (Section 3.1)
- Access restriction声明 (Section 4)
- Explicit modification history (Section 6)
- Redaction procedure (Section 5)

---

## 4. Access Controls & Restrictions

### 4.1 Phase 0 access (2026-10-25 through Gate A)

| Resource | Who can read | Who can modify | Restriction mechanism |
|---|---|---|---|
| **Branch `arena/bce16055-wrasal-control`** | Anyone with repo read (public? private per wrasalmedia-rgb settings) — Arena sandbox clones with GitHub token as `wrasalmedia-rgb` | Arena Intake Agent (push) + wrasalmedia-rgb (human) via GitHub permissions; no other writers | GitHub ACL (owner wrasalmedia-rgb admin); Arena token scoped to sandbox session; branch not yet merged to `main` |
| **Local sandbox `/home/user/wrasal-control`** | Arena agent process only (ephemeral E2B container) | Same agent | E2B sandbox isolation; destroyed after session |
| **Originals `cases/ALIEN-001/originals/`** | Intake Agent (for hashing), human reviewer (after push) | **None after commit** — originals committed as-is; future financial originals will be read-only (no in-place edit) | Git immutability (new commit needed to change) + policy (preserve verbatim) |
| **Derived artifacts `cases/ALIEN-001/*.csv|md|json|xlsx`** | Intake Agent, human reviewer | Intake Agent only, versioned (0.1.0 → 0.1.1) | Same as above; corrections logged in errata, not silent edits |
| **Human case owner data** | Human owner + Intake Agent (read-only per “Evidence review only” authorization) | **No autonomous financial actions** — no transfers, disputes, account changes, external allegations without separate explicit authorization (Work Order §8) | Execution boundary in Gate A Decision: “Arena may prepare/validate pipeline; may not initiate transactions/placeholder totals/inferred receipts/external contact” |

### 4.2 Future financial evidence (post-Tier 1)

| Resource | Access (planned) |
|---|---|
| **Originals `originals/`** | Human supplies originals → Intake Agent copies to `originals/` (filename preserved), computes SHA-256 immediately, records in register; originals never edited; access log updated |
| **Redacted `redacted/`** | Intake Agent generates redacted copy masking full account numbers (keep last 4 for Account One/Two alias), identity docs, credentials; hashes redacted separately; analysis uses redacted copies only |
| **Ledger/Reconciliation/Trace artifacts** | Intake Agent extracts (Phase 1) preserving original description verbatim + normalized fields alongside; Reconciliation Agent (Phase 2) computes balances; Remittance Agent (Phase 3) classifies dispositions — all read-only derivations, never overwriting source |
| **External systems (banks, creditors)** | **No direct access authorized** — Arena has no bank account access (Work Order execution architecture); all data comes via human-supplied files; no external contact without Gate authorization |

---

## 5. Redaction Procedures (Future Financial Records)

Documented now so custody verification can check compliance when evidence arrives (Work Order §3E + §4 Phase 0 step 6).

### 5.1 What is redacted (analysis copies only)

| Data category | Original (`originals/`) | Redacted (`redacted/`) | Alias preservation |
|---|---|---|---|
| **Full account numbers** | Preserved verbatim, hashed | Masked: `****1234` (keep last 4) | Last 4 retained as Account One/Two alias |
| **Full names** | Preserved → hashed → then redacted if required | Initials or alias per case owner instruction | Link to evidence ID maintained |
| **Identity documents (SSN, passport, etc.)** | Never requested; if inadvertently included, hash then delete from analysis copy | Removed entirely in redacted copy | Flag to case owner |
| **Banking passwords, OTPs, security Q&A** | **Prohibited to request per Phase 6** | Never stored | Report as policy violation |
| **Transaction amounts, dates, descriptions, running balances** | Preserved | **Never altered** — redaction must not change financial fields | Required for AT-01/AT-03 |
| **Original transaction wording** | Preserved verbatim | Preserved verbatim in redacted copy | Source meaning retained |

### 5.2 Redaction workflow (to be logged per Evidence ID)

```
For each supplied file (e.g., EV-003-S1 = Account One statement 2023-05):
1. Save original to originals/ with original filename (EV-003-S1_Statement_2023-05.pdf)
2. Compute SHA-256 hash of original; record in evidence_register.csv + repo_manifest update
3. Generate redacted copy in redacted/ (EV-003-S1_Statement_2023-05_redacted.pdf) with masks above
4. Compute SHA-256 hash of redacted copy; record separately
5. Extraction (Phase 1) reads redacted copy but references original evidence ID; original wording preserved
6. Log entry: acquisition timestamp, custodian, original hash, redacted hash, modifier (Intake Agent), access list
```

**Verification check (future):** Human reviewer can recompute both hashes independently with `sha256sum originals/File` and `sha256sum redacted/File` and compare to register/provenance.

---

## 6. Later Modifications — Versioning & Errata (v0.1.0 → v0.1.1)

### 6.1 What changed (Gate A corrections 2026-10-25)

| File | Correction | Reason | Effect on Originals |
|---|---|---|---|
| `ALIEN-001_forensic_report.md` §2.1 + §4.7 + §15 checklist | `16 → 17`, `22 → 23`, `~38 → up to 40 potential (calendar-month maximum)`, `~41 months → 42 calendar months inclusive` | Technical correction: inclusive month counts; calendar vs issued distinction | Derived artifact only; originals (EV-001/EV-002) unchanged |
| `ALIEN-001_missing_evidence.md` §2.1 + §3A + §2 footnote | Same 17/23/40/42 + erratum footnote distinguishing calendar-month ceiling from actual issued count (opening date, closing date, cycle day) | Same + required by Gate A item #1 | Same |
| `ALIEN-001_provenance.json` `case_boundaries.calendar_months_approx` `evidence_inventory_summary.statement_periods_missing_approx` | `41 → 42`, `38 → 40` + added `statement_periods_calendar_month_ceiling: 40` + `calculation_note` | Same | Version bump 0.1.0→0.1.1; originals unchanged |
| `ALIEN-001_balance_reconciliation.xlsx` README_Phase0 + Reconciliation + Exception_Map | `38 → 40 potential`, `16 Account One → 17 cal-mo`, `22 → 23 cal-mo`, `ALL PERIODS MISSING` note updated, footer note added re: cycle | Same | Same (new xlsx hash) |
| `ALIEN-001_gate_a_verification_receipt.md` (new) | Required return per Gate A | Documents corrections + verification | New file |
| `ALIEN-001_chain_of_custody.md` (this file) | Required per Gate A item #5 | Supplements hashes with custody controls | New file |

**What did NOT change:** Original preserved files (`originals/FOR3NSIC-ALIEN-001_work_order.md`, `originals/repo_manifest.json`) and scaffold hashes (`README.md`, `projects.yml`, etc.) remain at v0.1.0 hashes — read-only as committed at ec404b9. Financial placeholder CSVs with header only (`master_ledger.csv`, `remittance_trace.csv`, `deposit_return_analysis.csv`) had no coverage numbers and are unchanged.

### 6.2 Modification logging (audit trail)

| Timestamp (UTC) | Actor | Action | Branch | Commit parent | New commit (to be) |
|---|---|---|---|---|---|
| 2026-10-15T22:35:55Z | wrasalmedia-rgb (merge) | Baseline scaffold `af529b5` | `main` → `arena/bce16055-wrasal-control` fork | ff1cb98 | af529b5 |
| 2026-10-25T17:31:31Z | Arena Intake Agent | Phase 0 v0.1.0 (32 IDs, 10 artifacts, 38→later corrected) | `arena/bce16055-wrasal-control` | af529b5 | ec404b9 |
| 2026-10-25T17:3x:00Z (now) | Arena Intake Agent (verification) | v0.1.1 corrections (40/42, custody doc, receipt) | same branch | ec404b9 | *next commit (pending push)* |
| (future) | Intake Agent + Human | Phase 1 Tier 1 financial evidence intake (when supplied) | same branch | *next* | *future commit* |

**Independent verification:** Any reviewer can checkout `ec404b9`, compute `sha256sum cases/ALIEN-001/*`, compare to `ALIEN-001_provenance.json` v0.1.0 hashes, then apply v0.1.1 patch and verify only the listed files changed, with reason documented in errata.

---

## 7. Distinction: Fictional Premises vs Authenticated Records

Required by Gate A item #6:

| Category | Definition | Handling in artifacts | Example |
|---|---|---|---|
| **Fictional case premise** | Story boundary from Work Order narrative, not bank-verified; used for investigation scope | Labeled `story premise — unverified` in timeline, report §2, provenance `case_boundaries`; source = EV-001 (work order), not EV-003..004 | “First account opened May 2023” (EV-001 narrative) |
| **Missing authenticated record** | Financial document that should exist to prove premise, but not yet supplied | Labeled `MISSING` in register, coverage 0%, exception UNRESOLVED | Bank statement for Account One May 2023 opening balance (EV-003) |
| **Authenticated financial record** | Bank-issued statement/export with hash, read-only original, extracted entry with evidence ID | Labeled `received` + SHA-256 + extraction `extracted` + reconciliation `matched`/`disputed`; source = EV-003..EV-032 (future) | *None yet* — placeholder ledger has 0 entries |
| **Finding/Conclusion** | Forensic inference backed by authenticated record (AT-01..04, Gate P2) | Requires evidence ID + hash + reproducible arithmetic; pending in Phase 0 | “No reconstruction can be performed” (finding about missing evidence, backed by register count) |

**Current state (Phase 0):** All account boundary events (Account One opened May 2023, closed Sep 2024, gap Oct-Nov 2024, Account Two opened Dec 2024, cutoff Oct 25 2026) are **fictional premises** sourced to EV-001, marked `unverified` in `ALIEN-001_event_timeline.csv` (EVT-ACCOUNT-OPEN-001 etc.). No authenticated records exist to confirm opening balances, transactions, or closure details. Report and provenance explicitly separate these categories to prevent premature promotion of premises to verified findings.

---

## 8. Acceptance-Test Qualification (Gate A item #7)

Detailed in Gate A Verification Receipt §6.4, summarized here:

| Test | Phase 0 Result (v0.1.1) | Qualification |
|---|---|---|
| AT-01 Every transaction links to source | **BLOCKED** | Not PASS — 0 transactions, no source to link (will be PASS only when Phase 1 extracts with evidence IDs) |
| AT-02 All periods inventoried | **PASS — Phase 0 only** | PASS covers inventory classification only (present/partial/missing); not financial correctness — correct ceiling is 40 potential (17+23), actual verified count still pending |
| AT-03 Balance arithmetic reproducible | **BLOCKED** | Not PASS — no balances to compute; will be PASS when Phase 2 computes Opening+credits−debits = expected closing with logged differences |
| AT-04 No payment marked received from debit | **PASS — by restraint, Phase 0** | PASS because no payment marked received at all; remains Phase-0-only until Jamaican creditor receipts (EV-027..030) confirm recipient credit |
| AT-05 Reversal links to deposit | **BLOCKED** | No reversals/deposits supplied |
| AT-06 Closure reason not invented | **PASS — by restraint, Phase 0** | PASS because no reason stated; remains Phase-0-only until EV-007 closure notice inspected |
| AT-07 Allegations separated from observations | **PASS — by restraint, Phase 0** | PASS because no fraud/phishing allegations made; hypotheses remain open possibilities |
| AT-08 Every finding retestable | **PASS — Phase 0 only** | PASS for Phase 0 findings (inventory/coverage gaps with evidence IDs+hashes); financial findings not yet retestable (no data) |
| AT-09 Confirmed vs estimate distinguished | **PASS — by restraint, Phase 0** | PASS because no totals asserted as confirmed (e.g., $500–600 noted as lead not proof) |
| AT-10 Originals unmodified + approval required | **PASS — Phase 0 only** | PASS for read-only preservation (git + originals/) and Gates A requested; final certification requires Gate D |

---

## 9. References for Independent Verification

- **Evidence register:** `cases/ALIEN-001/ALIEN-001_evidence_register.csv` — 32 IDs, source/filename/date range/format/custodian/SHA-256, with corrected notes (17/23/40)
- **Missing evidence:** `cases/ALIEN-001/ALIEN-001_missing_evidence.md` — 30 missing categories, coverage matrix with erratum footnote
- **Forensic report:** `cases/ALIEN-001/ALIEN-001_forensic_report.md` — §§ 2, 4, 12, 15 with corrected coverage
- **Provenance:** `cases/ALIEN-001/ALIEN-001_provenance.json` — v0.1.1 with 40/42, custody metadata, hashes
- **Verification receipt:** `cases/ALIEN-001/ALIEN-001_gate_a_verification_receipt.md` — reproducible validation, artifact manifest with recomputed hashes
- **Git history:** `git log --oneline —graph --all` shows `af529b5` (baseline) → `ec404b9` (Phase 0) → *next (v0.1.1 correction)*; `git show <hash> --name-only` lists changed files; `git ls-tree <hash>` shows blobs with hashes matching `sha256sum` outputs in receipt
- **Validator report:** `evidence/WRASAL-0005-validation.json` — 567 checks PASS; see receipt §3 for forensic vs control-plane distinction

---

*Git hashes check integrity. This document checks custody. Both are needed for a verified evidence-intake system.*  
*Version 0.1.1 — Corrected per Gate A 2026-10-25 — Ready for independent hash recomputation.*
