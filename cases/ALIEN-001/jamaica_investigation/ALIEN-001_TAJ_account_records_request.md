# Draft — Tax Administration Jamaica (TAJ) Account Records Request

**Status:** Prepared only; **not sent**. User must review, complete and submit through an official channel.  
**Case:** FOR3NSIC-ALIEN-001 — read-only evidence discovery  
**Identity reference in case copy:** user-declared, unverified; `TRN •••••7932`. The full identifier is intentionally not present in this file.

> **Privacy handling:** TAJ’s published terms warn that email may not be secure for confidential information. Do not paste the full TRN, identity documents, passwords, or account credentials into this repository or ordinary email. Prefer the authenticated TAJ Portal or first contact TAJ through a verified official route to ask how to submit an identity-verified records request securely. The taxpayer completes identity fields privately.

## Draft request (taxpayer to submit)

**To:** Tax Administration Jamaica — Taxpayer/Customer Services  
**Subject:** Request for my taxpayer-account records and transaction history

Dear Tax Administration Jamaica,

I am requesting access to the taxpayer-account records held in my name for the periods and tax types listed below. This is a records request only. It is not an admission that a liability exists, a request to make a payment, or authorization for a third party to access my account.

Please advise what identity verification and secure submission steps are required. I will provide my full identity details directly through the official channel you designate. Please do not send confidential account information to an unverified email address.

For each tax type/account that is associated with me, please provide, where available:

1. Account/tax-type identifiers and status, including whether an account was opened, active, closed, or not found; do not infer applicability from my TRN alone.
2. Account statements or a complete transaction listing for **[insert requested start date] through [insert requested end date]**, showing opening and closing balances and statement/print dates.
3. Returns filed or recorded, filing periods, submission/acceptance dates, confirmation/reference numbers, and any amended or superseding returns.
4. Assessments, notices, and other liability entries, with tax type, period, assessment date, principal amount, interest, penalties, fees, adjustment date, and current status.
5. All payments and credits recorded, showing payment/reference number, source/channel if recorded, amount and currency, transaction/receipt date, effective/posting date, tax type/period allocation, and any unapplied amount.
6. Official payment receipts or instructions for retrieving receipts, including any reference needed to obtain them through TAJ’s public receipt service.
7. Reversals, returned payments, chargebacks, reapplications, offsets, refunds, credits, or corrections, with dates, amounts, reason/status, and linked original reference.
8. Refund claims and outcomes, tax-compliance notices, payment arrangements or account adjustments, where applicable.
9. A written statement identifying missing periods, unavailable records, retention limitations, and the correct process to request any record not available through the portal.

**Periods requested:** [list exact tax years/periods; or “all periods available”]  
**Tax types requested:** [identify if known; otherwise “all taxpayer accounts associated with my verified identity, with each tax type listed separately”]  
**Preferred response method:** [authenticated portal / secure method TAJ specifies]  
**Taxpayer name and secure contact details:** [complete privately before submission]  
**Identity verification:** [complete directly in TAJ’s official secure process; do not place the full identifier in this repository copy]

Please provide a reference number for this request and identify any additional form, fee, or proof of identity required. If records cannot be provided, please identify the unavailable record types and the appropriate next step.

Sincerely,  
[Taxpayer name — complete privately]  
[Date]

## Submission route and handling notes

- TAJ’s [official portal/eServices](https://www.jamaicatax.gov.jm/eservices?inheritRedirect=true) lists account-related services, filings/payments, payment receipt generation and other non-logon services. It does not give Arena access to private accounts.
- The [TAJ Tax Portal FAQs](https://www.jamaicatax.gov.jm/tax-portal-faqs) say an individual can register to check the status of returns and payments made by an agent/representative.
- Use the contact details displayed on TAJ’s [official website](https://www.jamaicatax.gov.jm/) to ask for the correct secure personal-records procedure. Do not rely on a search advertisement, image result, or third-party map listing as an official channel.
- The [TAJ terms of use](https://www.jamaicatax.gov.jm/web/guest/terms-of-use) advise that email may not be secure for confidential information and state that proof of identity/authentication may be required for personal account information; fees may apply to some requests.
- If TAJ issues receipts only after a payment reference and amount are entered, retain the official receipt returned and the source bank/payment record. A TAJ receipt should then be matched to its tax account and posting/allocation.

## Evidence handling if TAJ responds

1. Preserve the downloaded/original file without editing, using the future financial-source area `cases/ALIEN-001/financial_originals/` (do not create that directory until receipt).
2. Assign a new evidence ID only at actual receipt; append a custody event. Do not add the TRN to the filename.
3. Compute SHA-256 on original bytes before extraction. The hash proves byte integrity relative to the hashed file, not TAJ authorship/issuance; record the secure retrieval method and visible source/provenance separately.
4. Keep an unredacted original restricted; use a redacted working copy with the identity reference masked. Do not store the full identifier in Git.
5. Distinguish TAJ’s recorded assessment from a paid amount, a payment debit from a posted credit, and a posted credit from its allocation to the right tax type/period. Any gap remains unresolved.

**No tax liability is presumed. No request has been sent.**
