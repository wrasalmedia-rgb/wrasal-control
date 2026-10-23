# M02 V1 — Reviewer Findings Addendum — Reporting Guidance Remains Open

**Status:** M02 review-prepared but reporting-guidance finding **remains open** per reviewer 2026-10-25. Prior WRASAL-0015 concluded role-specific guidance was correctly scoped — that conclusion is revised here. Source-classification (`nysenate.gov` governmental) and fictional gift-limit labeling remain reported addressed (bounded correction applied, diff 32 lines, md5 `dd48d9c492b9a7558b4526b71fa82195 → 4acc0908650818122675602b00b126af`).

**Manuscript:** `google_drive/M02-textbook-chapter-v1.txt` V1 DRAFT Oct 24 2026 (original 38924 bytes, corrected 39148 bytes). Commit `f78d202` not inspected here per reviewer.

---

## Two distinctions requiring correction:

### 1) Date consistency is not date verification — RECONCILED, NOT CLOSED AS VERIFIED

- Four matching `October 24` labels (lines 4, 9, 156, 299) establish **internal consistency only** (same calendrical value, stylistic `Oct 24` vs `October 24` variation).
- They **do not establish when work occurred**. Reconciliation against execution timestamps and timezone is now documented in `evidence/M02-V1-date-reconciliation-2026-10-24.md`:
  - Execution: git AuthorDate `2026-10-23 22:11:55 +0000` (M02 authoring) and `2026-10-23 22:19:45 +0000` (review prep) — both `2026-10-23 18:xx -0400` America/New_York (EDT, UTC-4).
  - Manuscript Review date: `2026-10-24` — one calendar day *after* execution, serving as prospective re-verification date before publication, not creation date.
- Corrected understanding: internal consistency verified, execution date reconciled to Oct 23 UTC/EDT, Review date remains Oct 24 as future marker pending pre-publication re-check. No claim work occurred Oct 24.

### 2) Employer policy does not confer statutory mandated-reporter status — GUIDANCE MUST BE SEPARATED

**Sources provided:**
- [NYSenate.gov](http://NYSenate.gov) — SSL §413 text: `No school, school official, child care provider, foster care provider, residential care facility provider, hospital, medical institution provider or mental health facility provider shall impose any conditions, including prior approval or prior notification, upon a member of their staff specifically required to report under this title.` [Ref: SOS §413(1)(c) via nysenate.gov; corroborated by FindLaw SOS §413, Law.Justia 2022 SOS 413, OCFS Pub1159, OASAS guidance.]
- [Mandated Reporters — NYC ACS](https://www.nyc.gov/site/acs/child-welfare/mandated-reporters.page?utm_source=chatgpt.com): `As a mandated reporter you must immediately make a report or cause a report to be made (for example: ensuring that a supervisor makes the report), when in your professional role you are presented with reasonable cause to suspect abuse or neglect.` — Simply notifying a supervisor is **not equivalent** to ensuring report occurs; reporter retains duty to ensure report was made and was named if multiple reporters.
- Supporting: OCFS CPS Manual Ch2 (2023) — `mandated reporter has legal obligation to personally make a report to SCR... may not inform leader with intent that that person will make call`; Justice Center — `An individual owns responsibility to report, regardless of protocols`; Access Continuing Education — `must report personally, then immediately notify person in charge that report was made`.

**Gap in M02 V1 as authored (lines 89-90, 172, 237, 243-246):**
- Line 89-90: `Certain professionals are mandated reporters under SSL §413 and must make a report... Many agencies make all staff mandated reporters by policy even if law does not.` — Conflates statutory vs policy-based in same paragraph without clear separation of legal status. Policy-based “all staff” does **not** create statutory mandated-reporter status under law; it creates an *agency-policy* reporting responsibility.
- Line 90: `You do not need to prove abuse, and you do not investigate on your own — you follow your agency's reporting steps and call the register [M02-5].` — Omits that statutory reporters **cannot be required to follow agency prior-approval/prior-notification** before calling; agency steps must not impose conditions. Current wording could be read as agency steps are prerequisite.
- Example 5 (line 172-174): `Sam is a mandated reporter under agency policy. Sam does not investigate alone or tell the parent "I won't report." Sam follows agency steps: ensure immediate safety, call a supervisor, and make a report to the Statewide Central Register when threshold met [M02-5]. Afterward, Sam documents...` — Implies sequence `call supervisor → make report` as if supervisor consultation precedes reporting. For *statutory* reporters, that sequence would violate SSL §413(1)(c) if interpreted as approval/notification prerequisite. For *policy-based* reporters, agency may require supervisor involvement, but that must be described **separately** from statutory duty.
- Knowledge Check 26 (line 237): `Follow agency steps, ensure immediate safety, consult supervisor, and make a report to the Statewide Central Register when threshold met; document facts without opinions [M02-5]. Correct Answer: C` — Same issue — `consult supervisor` listed before `make report` without clarifying that supervisor approval is **not required** and must not delay statutory report. Correct answer should reflect `report or cause report immediately` and `then immediately notify person in charge after report made` per §413(1)(b), with supervisor notification *after*, not before.
- Knowledge Check 27 + Emergency-response guidance (lines 243-246, 91-92): `Immediately get a supervisor/clinical lead... do not make solo disclosure decisions [M02-4][M02-8]. Correct Answer: B` — For *child abuse* reporting, this is incorrect if applied — frontline statutory reporter **must** make/cause report directly, not defer to supervisor solo-decision. For *harm-to-self/others imminent risk* (mental health safety), supervisor involvement is appropriate per OMH protocol, but chapter must distinguish the two domains. Currently Section 5B lumps child-abuse mandated reporting and general imminent-risk safety under same “involve supervisor” logic, obscuring statutory difference.

**Required corrections for M02 V1.1 bounded revision (to remain open until applied):**
1. **Separate descriptions:**
   - **Statutory mandated reporters** (listed in SSL §413(1)(a) — physicians, nurses, social workers, teachers, police, child care providers, etc.): Explain they are **required by law** to report or cause report immediately upon reasonable cause while acting in professional capacity, **must do so personally** (call SCR `1-800-635-1522` or `1-800-342-3720` after-hours, LDSS-2221A within 48h), **must immediately notify person in charge *after* report** per §413(1)(b), and **employer shall not impose prior approval/prior notification** per §413(1)(c). Cite nysenate.gov [M02-5] with official governmental classification.
   - **Policy-based reporters** (agency says “all staff report”): Explain they are **required by agency policy**, follow agency handbook, may be required to tell supervisor per agency protocol, but this does **not** confer statutory status, does not create immunity under statute, and does **not** alter statutory reporters’ independent duty.
2. **Remove supervisor prerequisite:** Revise `Example 5`, `Section 5B steps`, `KC 26` to state `report or cause report immediately when threshold met, then immediately notify person in charge after report made — do not wait for supervisor approval or notification before reporting` for statutory cases. For policy-based cases, state supervisor notification is per agency, not law.
3. **Clarify “cause a report”:** Per NYC ACS, `report or cause a report to be made (for example: ensuring that a supervisor makes the report)` — but reporter must **ensure report actually occurred** (obtain Call I.D., confirm named in report, follow up), not merely tell supervisor. Current `call a supervisor, and make a report` is ambiguous; should be `report yourself, or ensure supervisor makes report and you are named/Call I.D. obtained`.
4. **Distinguish domains:** Keep imminent-risk safety protocol (OMH [M02-4][M02-8] — supervisor/clinical-lead assessment, least-necessary sharing) **separate** from child-abuse mandated reporting. Do not merge under one “get supervisor” rule.

**Checks affected:** 26 (mandated reporting) and 27 (imminent risk) plus Example 5 and Section 5B emergency-response guidance — all remain **open findings** until V1.1 correction.

**No claim of legal correctness made beyond source fidelity; corrections will cite official governmental `nysenate.gov` SSL §413 text and NYC ACS `mandated-reporters.page` verbatim as provided.**

---

## Other findings — remain reported addressed:

- October 24 dating **internal consistency** verified (4 labels) but now reconciled to execution timestamps (see separate reconciliation file) — addressed.
- `nysenate.gov` **governmental** vs Cornell LII nongovernmental — corrected in V1 39148-byte version, diff 32 lines — reported addressed.
- Fictional gift-limit **$15/$40** labeled as fictional scenario in KC 23 — reported addressed.
- Role-specific disclosure general guidance (privacy vs confidentiality, consent elements, minimum necessary, Part 2 stricter) — remains as authored, with above mandated-reporter clarification to be applied.

**State:** M01 review pending (14:30 arithmetic resolved, measured runtime pending) · M02 draft reported authored, targeted reporting-guidance findings open (checks 26-27, emergency-response, date-reconciliation) · M03 next · release not authorized.
