# Draft — Students’ Loan Bureau (SLB) Historical Ledger & Data Request

**Status:** Prepared only; **not sent**. No SLB portal was accessed and no institution was contacted.  
**Identity reference in case copy:** user-declared, unverified; `TRN •••••7932`. Full identifier omitted.  
**Priority suggested by work order:** Request the earliest available historical statement, ideally the first statement covering the loan’s initial period, alongside the full ledger. **No loan, balance, arrears, payment, or eligibility is assumed.**

## Safe submission route

The SLB identifies the Customer Portal (STEEP) as the account channel and offers support at [slbja.com/contact-us](https://www.slbja.com/contact-us/) (phone **876-619-4752**, WhatsApp **876-279-8080**, listed hours Monday–Friday, 9:00 a.m.–3:30 p.m.). Its official site describes a **Data Subject Request** service and says a customer may request a report of information held via email or the customer portal in its [Privacy Notice](https://www.slbja.com/wp-content/uploads/2025/01/PRIVACY-NOTICE-AND-TERMS-OF-USE-AGREEMENT_.pdf).

The SLB’s contact page asks account-information requesters to include full names and TRNs. **Do not add the full TRN to this repository copy.** Before sending identity documents or an unmasked TRN, the taxpayer should use the authenticated portal or call an official SLB contact to confirm a secure, verified submission method. No passwords or one-time codes should be shared with Arena.

## Draft request (borrower to submit)

**To:** Students’ Loan Bureau — Customer Service / Loan Servicing / Data Subject Request  
**Subject:** Request for complete historical loan account records, payment allocations and account status

Dear Students’ Loan Bureau,

I request a copy of the records SLB holds about my loan account(s), including a complete historical transaction ledger and the underlying account/servicing records listed below. Please provide each loan account separately and tell me what identity verification or Data Subject Request form is required. I will supply my identifying details directly through the official secure process you confirm.

This request is for records and account clarification only. It is not an admission that a balance is correct, a request to enroll in Debt Reset, or authorization to alter my repayment arrangements. Please do not change terms, initiate a payment, or enroll an account based on this request.

For **each loan account** associated with my verified identity, please provide, to the extent held and available:

1. Loan account number/reference, product type, borrower/principal-borrower roles, date opened, and current account status. Please state whether any separate loans were consolidated and provide the mapping to the original loan numbers.
2. Executed loan agreement/promissory note and amendments; approved amount, disbursement schedule, each actual disbursement, institution/payee, dates, and amounts.
3. Full transaction-level history from loan opening/inception to the latest available date, including opening and closing balances for each statement period; transaction, effective, posting, and statement dates; transaction description/code; principal, interest, insurance, fees/commission, arrears, adjustment and reversal components; and resulting balances.
4. Payment history and payment allocations, including every scheduled, voluntary, extra, salary-deduction, bank-order, online, remittance, or other recorded payment; amount and currency; payment/reference/instrument number; receipt/transaction ID; received date and effective credit date; allocation to principal, interest, insurance, fees, or unapplied funds; and any associated reversal, return, refund, reapplication, or correction linked to its original payment.
5. Repayment terms by effective date: interest calculation method, rates, capitalization, moratorium periods, repayment start dates, scheduled installments, due dates, rate or schedule changes, and the contractual basis for fees, penalties, or insurance charges.
6. Arrears/default status history, notices, payment arrangements, restructuring, appeals, collection/legal referrals, and any status changes with the effective dates and calculations used.
7. A current **itemized payoff/settlement quotation** as of a stated date, including quote expiry, per-diem or continuing charges, principal, interest, insurance, fees, arrears and payment instructions. Please distinguish a payoff quotation from the ledger balance and identify its assumptions.
8. Any SLB payment receipts or confirmations available in the portal, plus the source reference and account allocation for each. Please identify payments reported as received but later reversed or reallocated.
9. All Debt Reset or other relief records that apply or could apply to each loan: application/enrollment status, eligibility determination and date, terms offered/accepted, required conditions and deadlines, payment plan, waivers/credits posted, reversals/reinstatements, and the balance before/after each change. Please state explicitly if no application or benefit is recorded.
10. Credit-reporting history for the loan, if held: bureau(s), account/status/balance/payment-history data supplied and dates, corrections/disputes, and supporting notice/reference.
11. A data-subject report of personal information held about me and the source/correction route for records that I believe are inaccurate or incomplete.
12. Any periods, transaction categories, or source systems not included in the response; retention limits; and the procedure for obtaining missing records or certified account-history copies.

**Date range:** [from inception / specify if known] through [request date].  
**Loan number(s):** [provide privately through verified channel; if unknown, ask SLB to locate accounts after identity verification].  
**Borrower name and secure contact details:** [complete privately].  
**Preferred response:** [SLB secure portal or other verified delivery route].

Please acknowledge receipt and provide a case/reference number. If some requested records are not available, please list what is unavailable, the applicable date range, the reason if known, and any alternative record that supports the stated balance or transaction history.

Sincerely,  
[Borrower name — complete privately]  
[Date]

## Debt Reset: written clarification to request, not an application

SLB’s official [press release dated April 29, 2026](https://www.slbja.com/debt-reset-press-release/) says the programme was extended through December 2026. The current [Debt Reset FAQ](https://www.slbja.com/debt-reset/) says the programme runs December 1, 2025–December 31, 2026, but a separate answer describes a five-month payment condition ending April 30, 2026. The page also restricts benefits by loan type and status as of October 31, 2025. These public pages do **not** establish this borrower’s eligibility or the operative deadline for a particular loan.

Ask SLB to confirm **in writing**, for each account, before any enrollment or payment decision:

- whether the loan product is eligible (the FAQ says Debt Reset applies to Targeted Loan accounts, not all SLB loan types);
- the account’s qualifying status and calculation date;
- exact current program deadline and whether the deadline differs for application, arrears-clearing payments, and benefit posting;
- exact principal/interest/insurance/fee amounts required and payment allocation;
- consequences of missed or late installment and whether waivers can be reversed;
- whether any benefit has already posted, with posting date and ledger entries.

**Do not apply, enroll, pay, or accept a settlement as part of this preparation.** User review and separate authorization are required.

## Statement reconciliation fields based on SLB’s published glossary

The [SLB Loan Statement Glossary](https://www.slbja.com/wp-content/uploads/2025/12/SLB-Loan-Statement-Glossary.pdf) identifies fields including loan account number, print date, product, interest rate, disbursed principal, installment dates, opening principal balance, principal paid, interest charged/paid/balance, fees and insurance, total amount paid, net payments, total payment reversed, instrument number, arrears and estimated closing balance. Request the actual line-level transaction detail behind each summary field; do not infer a missing transaction from a summary total.

The glossary notes that for repayment start dates before March 31, 2016, it reflects payments from April 1, 2016 after Reducing Balance Method implementation. If the relevant loan period predates that date, ask SLB for earlier source records and the method used to calculate/carry forward the opening balance.

## Evidence handling after response

- Preserve the original statement/export or SLB response in future-only `financial_originals/`; never mix it with administrative originals in `originals/`.
- Record new evidence and custody events append-only. Hash the original bytes before extraction. Hash establishes file integrity relative to the hashed copy; it does not by itself prove the issuer or content is authentic.
- Record supplier, secure retrieval path, apparent-authenticity observations, and issuer-verification status separately. No document is called independently SLB-authenticated unless independent issuer verification actually occurred.
- Compare SLB’s reported ledger to sender/provider proof and exact SLB allocations. A SLB statement can show the creditor’s record, but it does not alone prove the originating bank debit or remittance path.

**No request sent; no loan record received; no balance certified.**
