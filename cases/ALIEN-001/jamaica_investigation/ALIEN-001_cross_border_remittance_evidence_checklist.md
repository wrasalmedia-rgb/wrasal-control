# Cross-Border Remittance Evidence Checklist — United States to Jamaica

**Status:** Evidence-request checklist only; no transfer has been alleged or verified.
**Purpose:** Trace each individually identified payment without inferring a link from similar amounts or dates.
**Identity rule:** Do not use the TRN as a public search key. Use provider/bank/creditor references and masked account aliases; disclose identity details only through the user’s verified official account channel when necessary.

## Per-payment chain

Create a separate packet for each candidate transfer. Record `unknown` where evidence is absent; do not fill gaps from memory as if documented.

### A. Obligation and intent (context, not payment proof)

- [ ] Identify the alleged obligation separately: creditor, account/loan/tax type, obligation period, statement/assessment reference, due date and amount.
- [ ] Preserve the obligation source (TAJ assessment/account statement, SLB statement, or other creditor statement); record the issuing source, original filename, source date, coverage and hash.
- [ ] Record payment purpose as user recollection only if volunteered, distinctly labeled `user_statement_unverified`; do not treat recollection as transaction evidence.
- [ ] Preserve payment instruction, authorization/confirmation, recipient name/account or creditor reference, requested amount/currency and requested service speed/date.

### B. U.S. sender-side bank / funding evidence

- [ ] Original account statement or downloadable bank transaction record covering the date; preserve original currency and exact amount.
- [ ] Bank transaction ID, ACH trace number, wire reference, check number, card/transfer reference or other unique identifier.
- [ ] Authorization record: who initiated, timestamp/time zone, method, beneficiary instructions, confirmation/receipt, and any authentication/approval evidence the bank provides.
- [ ] Debit date, posting date, value date, amount, currency, fees, exchange/foreign transaction fee, and ledger balance effect if stated.
- [ ] Status: pending, posted/settled, returned, rejected, reversed, refunded, disputed, or unknown — quote source terminology.
- [ ] Bank trace/investigation response, cancellation/recall request and outcome, refund or return details linked to the original identifier.
- [ ] Do not equate an authorized instruction with a debit, or a debit with recipient receipt.

### C. Transfer company / payment processor

- [ ] Provider legal/brand name and originating U.S. channel; customer transaction/receipt ID; trace/tracking number.
- [ ] Sender and beneficiary fields (mask personally identifying values in working copies); intended recipient and destination.
- [ ] Amount sent (USD), provider fee, taxes/charges, exchange-rate quote and timestamp, JMD amount expected/available, and any rate adjustment.
- [ ] Lifecycle events with timestamps/time zones: created, accepted, compliance hold, processing, ready for pickup, deposited, collected, paid, failed, cancelled, refunded, returned, expired, or unknown.
- [ ] In Jamaica: payout agent/location, location-specific service and provider, pickup/deposit method, payout date, payout amount/currency, recipient identity check description (redact ID numbers), payout receipt/reference and any recipient acknowledgment.
- [ ] For a claimed Jamaican agent, check the Bank of Jamaica’s [official remittance-company/location list](https://boj.org.jm/core-functions/financial-system/list-of-remittance-companies/) and [supervision information](https://boj.org.jm/core-functions/financial-system/cambios-remittance/supervision-of-remittance-services/) for the provider, agent/location and relevant date. Record the list’s “as of” date. A listing is a regulatory/pathway cross-check, not evidence a specific transfer occurred.
- [ ] Request provider-side trace or written case response if any lifecycle stage is incomplete, disputed, or unmatched. Use the reference via the user’s verified provider channel; Arena does not contact provider.

### D. Recipient-side receipt and creditor posting

- [ ] Recipient-side bank/remittance statement or receipt, with date received, amount/currency and unique provider reference.
- [ ] If funds went to a creditor: creditor’s account statement/receipt showing amount received, date received, posting/effective date, account/loan/tax period credited, allocation (principal/interest/insurance/fees/tax type), unapplied amount, and resulting balance.
- [ ] Obtain the creditor’s transfer trace or reference crosswalk if provider reference differs from creditor transaction ID.
- [ ] Record returns, reversals, reapplications, chargebacks, corrections and linked original transaction references.
- [ ] Confirm whether creditor statement reflects payment settled/applied versus pending/unallocated; preserve the exact wording and date.

### E. Matching and currency control

- [ ] Exact transaction/reference ID match first. If unavailable, document the documented crosswalk linking distinct IDs.
- [ ] Keep separate values: USD principal sent, USD fee, FX rate (units, timestamp/source), expected JMD, actual JMD paid out, JMD credited, and any recipient/creditor fee.
- [ ] Store arithmetic as reproducible calculation with inputs and source IDs. Do not silently use current exchange rates to estimate historical conversion.
- [ ] Preserve original date, time, time zone, posting/value date and creditor effective date separately.
- [ ] Amount/date similarity alone is insufficient to match records. Require a reference link or strong, documented corroboration; otherwise register an exception.

### F. Evidence and custody controls

- [ ] New financial source receives a new evidence ID and append-only custody event; never overwrite an existing evidence row or custody entry.
- [ ] Financial originals go to future-only `cases/ALIEN-001/financial_originals/`; administrative originals remain in `originals/`; narrative premises remain in the event timeline.
- [ ] Preserve original bytes first; compute SHA-256 before extraction; store the original hash and redacted-copy hash separately.
- [ ] Hash supports byte-level file integrity only. Separately record who supplied it/how, visible apparent-authenticity observations, and whether issuer/provider authenticity was independently verified.
- [ ] Keep full account numbers, full TRN, IDs, transfer recipient personal data, passwords and one-time codes out of repository files. Redacted working copies retain sufficient evidence references while masking personal identifiers.
- [ ] No external contact by Arena. User submits inquiries through their own authenticated provider/creditor channel.

## Outcome taxonomy (one status per link; no global leap)

`NOT_DOCUMENTED` · `INSTRUCTED` · `AUTHORIZED` · `DEBIT_POSTED` · `PROCESSOR_ACCEPTED` · `PROCESSING` · `AVAILABLE_FOR_PICKUP` · `PAID_OUT` · `RETURNED` · `CANCELLED` · `REFUNDED` · `RECIPIENT_RECEIPT_DOCUMENTED` · `CREDITOR_POSTED` · `CREDITOR_ALLOCATED` · `DISPUTED` · `UNRESOLVED`.

A later status requires evidence of that specific event. `DEBIT_POSTED` never implies `PAID_OUT`; `PAID_OUT` never by itself implies `CREDITOR_ALLOCATED`.

## Initial state

No transaction packet is opened until a source or a specifically identified user-reported candidate is supplied. At preparation time: no sender statement, transfer receipt, recipient proof or creditor payment posting has been received. Therefore there are **zero reconstructed transfers** and no finding about loss, delivery, non-delivery, or misconduct.
