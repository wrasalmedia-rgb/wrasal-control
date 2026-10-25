# Unified Reconciliation Schema — Jamaica Tax, SLB Debt & U.S.-Origin Payments

**Status:** Empty schema only; no financial rows are populated.
**Rule:** One row represents one source-evidenced event at one link in the chain. Do not compress intent, debit, provider processing, payout, recipient receipt and creditor allocation into one presumed “payment” row. Rows may share a `chain_id` only when source references/corroboration support the connection.

## Tracks

- `TAJ_TAX` — taxpayer-account obligations, filings, assessed entries, payment receipts, payment postings and adjustments.
- `SLB_LOAN` — each loan agreement, disbursement, charge, installment, payment, allocation, reversal, waiver or balance record.
- `US_SENDER` — U.S. bank or payment-account events.
- `TRANSFER_PROVIDER` — processor/remittance-company status and payout events.
- `JM_RECIPIENT` — recipient-side bank/remittance receipt.
- `JM_CREDITOR` — creditor-received and creditor-allocated event.
- `CREDIT_REPORT` — supporting reported account/status, not a substitute for source ledger.
- `ADMIN` / `NARRATIVE` — separate administrative or work-order premises; never financial transaction rows.

## Fields

| Field | Type / allowed form | Purpose / rule |
|---|---|---|
| `case_id` | Text; `FOR3NSIC-ALIEN-001` | Case key. |
| `chain_id` | Text; assigned only on documented or user-identified candidate chain | Groups linked events, not proof of link. Leave blank if not yet linkable. |
| `event_id` | Unique text, append-only | Row/event ID. Never reuse or overwrite. |
| `track` | Enum above | Evidence track for this event. |
| `link_stage` | `OBLIGATION`, `INTENT`, `AUTHORIZATION`, `SENDER_FUNDING`, `SENDER_DEBIT`, `PROVIDER_ACCEPTANCE`, `FX`, `PAYOUT`, `RECIPIENT_RECEIPT`, `CREDITOR_POSTING`, `CREDITOR_ALLOCATION`, `REVERSAL`, `REFUND`, `CREDIT_REPORT`, `OTHER` | Distinguishes legally/operationally different events. |
| `event_type` | Source-grounded free text/code | Original source event description; retain source wording. |
| `event_status` | Controlled status (see below) | Status from the relevant source, not an inference. |
| `status_source_wording` | Text / null | Exact status label in source (e.g. “available,” “paid,” “posted”). |
| `account_alias` | Case alias only | `Account One`, `Account Two`, `TAJ account`, `SLB loan-01`, `US account A`, etc.; no full numbers. |
| `obligation_id` | Source reference / null | Assessment, tax period, loan number alias, creditor-account alias. Protect full identifier outside repository if necessary. |
| `source_evidence_id` | EV ID / null | Evidence-register link. No event without source may be promoted as a fact. |
| `source_document_ref` | File name / page / row / cell / source record ID | Pinpoint citation within the source. Do not put TRN or full account number in filename. |
| `source_sha256` | 64-hex / null | SHA-256 of preserved original bytes. Establishes byte integrity only, not issuer or content authenticity. |
| `file_integrity_status` | `HASH_MATCHED`, `HASH_NOT_CHECKED`, `HASH_MISMATCH`, `NOT_APPLICABLE` | File-level integrity assessment. |
| `document_provenance` | Text / null | Who supplied it, date/time, channel, retrieval/handoff path, custody reference and known gaps. |
| `apparent_authenticity_status` | `CONSISTENT`, `INCONSISTENT`, `NOT_ASSESSED`, `NOT_APPLICABLE` | Observed features/page continuity/internal consistency only. Never equate to issuer verification. |
| `issuer_verification_status` | `INDEPENDENTLY_VERIFIED`, `NOT_ATTEMPTED`, `UNABLE_TO_VERIFY`, `NOT_APPLICABLE` | Whether issuer/provider was independently confirmed. `INDEPENDENTLY_VERIFIED` requires actual independent verification evidence. |
| `source_entity` | Text | Bank, TAJ, SLB, named processor, remittance agent or bureau as represented in source. |
| `source_record_date` | ISO date / null | Statement/receipt/report issue or generation date. |
| `event_date_local` | ISO date / null | Date the source says the underlying event occurred. |
| `event_time_local` | ISO time / null | Time if present. Do not fabricate missing times. |
| `source_timezone` | IANA/offset/text / null | Source time zone, if known. |
| `posting_date` | ISO date / null | Date the sender/recipient/creditor posted it. Separate from event and effective date. |
| `effective_date` | ISO date / null | Date source says funds/credit apply, if distinct. |
| `statement_period_start` / `statement_period_end` | ISO dates / null | Period boundaries shown in statement. |
| `currency_original` | ISO currency code / null | Currency in which source records amount. Preserve USD and JMD separately. |
| `amount_original` | Decimal string / null | Source amount exactly as displayed; do not use binary float for arithmetic. |
| `fee_amount` / `fee_currency` | Decimal string / ISO code / null | Fee separate from principal. |
| `fx_rate` | Decimal string / null | Rate exactly as source states; include quote direction and time. |
| `fx_base_currency` / `fx_quote_currency` | ISO codes / null | Makes rate direction unambiguous, e.g. USD per JMD or JMD per USD. |
| `settlement_amount` / `settlement_currency` | Decimal string / ISO code / null | Processor/payout settlement amount, distinct from sender amount and creditor credit. |
| `recipient_amount` / `recipient_currency` | Decimal string / ISO code / null | Amount received by named recipient if source documents it. |
| `creditor_amount` / `creditor_currency` | Decimal string / ISO code / null | Amount posted by the creditor; distinct from remittance payout. |
| `principal_allocation` | Decimal string / null | Creditor allocation to principal, if stated. |
| `interest_allocation` | Decimal string / null | Creditor allocation to interest, if stated. |
| `insurance_allocation` | Decimal string / null | Creditor allocation to insurance, if stated. |
| `fee_or_penalty_allocation` | Decimal string / null | Creditor allocation to fees/penalties, if stated. |
| `unapplied_amount` | Decimal string / null | Amount received but not allocated, if source shows it. |
| `instrument_or_trace_ref_masked` | Masked reference / null | Preserve a useful non-secret identifier. Restrict complete sensitive refs outside public/report copies as needed. Never place full TRN here. |
| `linked_event_ids` | List / null | Other event IDs explicitly connected by source references or documented crosswalk. Similar amount/date alone is insufficient. |
| `calculation_id` | Text / null | Link to reproducible calculation/worksheet. Include formula and source IDs separately. |
| `exception_id` | EXC ID / null | Missing, conflicting, incomplete or unmatched evidence. |
| `reconciliation_status` | `UNRESOLVED`, `MATCHED`, `PARTIAL`, `DISPUTED`, `NOT_APPLICABLE` | `MATCHED` only when the specific link is supported. Overall case stays unresolved until coverage is adequate. |
| `notes` | Text | Limitations, source wording, missing records, no unsupported conclusions. |

## Controlled event statuses

Use only a status supported by the row’s source: `NOT_DOCUMENTED`, `INSTRUCTED`, `AUTHORIZED`, `DEBIT_POSTED`, `PROCESSOR_ACCEPTED`, `PROCESSING`, `AVAILABLE_FOR_PICKUP`, `PAID_OUT`, `RETURNED`, `CANCELLED`, `REFUNDED`, `RECIPIENT_RECEIPT_DOCUMENTED`, `CREDITOR_POSTED`, `CREDITOR_ALLOCATED`, `DISPUTED`, `UNRESOLVED`.

`AUTHORIZED` ≠ `DEBIT_POSTED`; `DEBIT_POSTED` ≠ `PAID_OUT`; `PAID_OUT` ≠ `RECIPIENT_RECEIPT_DOCUMENTED`; recipient receipt ≠ `CREDITOR_ALLOCATED`.

## Required identifiers and privacy

- Preserve bank/processor/creditor-issued references in evidence sources; store only masked values in routine report exports where the full reference can identify a person or account.
- TRN remains a user-declared, unverified identity reference. Do not use as a public search key, do not store the full value, and do not treat a match as a payment or debt fact.
- Use the evidence register and custody log for source identity, hash, provenance and location. Keep financial source originals separate from administrative originals and narrative materials.
- No row is populated until a user supplies a source document or specifically identifies an unverified candidate; candidate recollection must be labeled `user_statement_unverified`, not a financial event.

## Arithmetic controls

- Preserve source amounts as decimal strings with source currency and exact precision. Never aggregate USD and JMD without an evidence-backed historical FX rate and fee treatment.
- A cross-border difference is calculated only when the required input sources and conversion basis exist; otherwise leave it blank/unresolved and create an exception.
- A balance is reconciled only for a defined account/period using creditor/bank opening balance + documented credits − documented debits/charges = closing balance, with each component sourced. Statement summaries without transaction detail remain attributed to the issuer.
- This schema contains **no example transaction rows**. Zero financial transactions are currently reconstructed.
