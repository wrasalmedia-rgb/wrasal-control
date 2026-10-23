# M02 V1 — Review Preparation — WRASAL-0015

**Purpose:** M02 Confidentiality and Professional Boundaries V1 review preparation — verify October 24 dating, classify `nysenate.gov` as governmental, label fictional gift limits, and check role-specific disclosure/reporting guidance. Carry forward findings without claiming content approval. `1,083` control-plane checks validate record structure only, not content accuracy, learning effectiveness, or legal correctness.

**Manuscript:** `google_drive/M02-textbook-chapter-v1.txt` — 38924 bytes, 301 lines, md5 `dd48d9c492b9a7558b4526b71fa82195`, sha256 `9f534e979b54f5f7fde31abac33cee3d37a8762d84c6d36b70ea21fa63523d42` — V1 DRAFT Oct 24 2026 Not approved for public release. M01 preservation/diffs remain reported evidence until independently inspected.

---

## 1) Verify October 24 Dating

**Check:** Consistency of Review date across manuscript, with no future-dating error.

**Observed:**
- Line 4: `V1 DRAFT — Sources [M02-1]–[M02-16] with Classifications Labeled — Not approved for public release — Review date Oct 24 2026`
- Line 9: `**Review date:** October 24, 2026 — verify all agency phone numbers, websites, laws, regulations, and agency guidance before publication — laws and policies change.`
- Line 156: `Review date: Oct 24 2026 — verify all contacts, websites, and rules. Laws, regulations, and agency policies change.` (Section 9 Finding Help footer)
- Line 299: `Review date: Oct 24 2026. Verify before publication.` (References footer)

**Result:** **Consistent** — all four occurrences reference **October 24, 2026** (two as `Oct 24 2026`, two as `October 24, 2026`). Format variation is stylistic (abbrev vs full month) but calendrical value identical. No conflicting dates (e.g., Oct 23 vs Oct 24). Dating is **one day after M01’s Oct 23 2026 review date**, reflecting sequential drafting — plausible sequential chronology. No internal mismatch found.

**Carry-forward:** Dating verified as internally consistent V1 draft marker; not a legal effective date. Actual publication must re-verify laws/numbers/websites immediately before release, as disclaimer states.

---

## 2) Classify `nysenate.gov` as Governmental

**Issue:** Reference entries mixed `nysenate.gov` (official NY State Legislature site for Consolidated Laws) with Cornell LII (nongovernmental legal-text publisher). Prior M01 had similar misclassification flagged and corrected (Cornell LII nongovernmental vs govinfo official). M02 repeats partial mislabeling.

**Observed occurrences in `google_drive/M02-textbook-chapter-v1.txt`:**
- `[M02-3]` PHL §18 (line 284): `Nongovernmental legal-text publisher for statute text: New York Laws via Cornell LII https://www.law.cornell.edu/wex/table_new_york ; e.g., https://www.nysenate.gov/legislation/laws/PBH/18` — **INCORRECT bundling** — `nysenate.gov` listed as example *under* nongovernmental label, though it is governmental.
- `[M02-4]` MHL §33.13 (line 285): `Official NY.gov law publisher: https://www.nysenate.gov/legislation/laws/MHY/33.13 ; Nongovernmental publisher text: https://www.law.cornell.edu/wex/table_new_york` — **CORRECT** separation.
- `[M02-5]` SSL §413 (line 286): `Law text via nysenate.gov: https://www.nysenate.gov/legislation/laws/SOS/413` — **Neutral label** (“via”), not explicitly classified — acceptable but should be explicit governmental in next revision.
- `[M02-6]` EDN §6509 (line 287): `Law via nysenate.gov: https://www.nysenate.gov/legislation/laws/EDN/6509` — same neutral.
- `[M02-16]` cross-reference (line 297): `Nongovernmental legal-text publisher for statutory text: Cornell LII ... ; Official publisher via nysenate.gov legislation pages` — **CORRECT** separation.

**Corrected classification:**
- `nysenate.gov` = **governmental** — official publisher of New York State Consolidated Laws, operated by the New York State Senate (state legislature). Hosts verbatim session law excerpts and consolidated law browsing.
- `law.cornell.edu` (Cornell LII) = **nongovernmental legal-text publisher/reference** — private university institute republishing law for reference, not official enactment.
- `govinfo.gov` / `ecfr.gov` = **governmental** official federal.
- `hhs.gov`, `samhsa.gov`, `health.ny.gov`, `omh.ny.gov`, `oasas.ny.gov`, `op.nysed.gov`, `nyc.gov`, `ocfs.ny.gov`, `nysmandatedreporter.org`, `socialworkers.org` — as currently labeled (governmental except NASW professional association nongovernmental) — correct.

**Action:** Recorded as finding to be fixed in next bounded correction. Proposed corrected wording for `[M02-3]` (to be applied in M02 V1.1):

> `Official NY.gov: https://www.health.ny.gov/regulations/public_health_law/ ; Official governmental law publisher (NYS Legislature): https://www.nysenate.gov/legislation/laws/PBH/18 ; Nongovernmental legal-text reference for cross-check: Cornell LII https://www.law.cornell.edu/wex/table_new_york`

And for `[M02-5]`/`[M02-6]`/`[M02-16]` ensure explicit `Official governmental publisher (NYS Legislature): https://www.nysenate.gov/...` label.

No claim of legal correctness made; classification is record-keeping accuracy only.

---

## 3) Label Fictional Gift Limits

**Observation:**
- Section 4 line 72: `Gifts, money, and favors: Many agencies do not allow gifts over a small value, loans, or extra errands.` — generic, not fictional yet (acceptable).
- Knowledge Check 23 (lines 206-212): `Question: A participant sends you a friend request and offers a $40 gift card to thank you. Your agency's handbook says gifts over $15 are not allowed and staff should keep personal social media separate. What is the most in-role response?` — **$40 and $15 are fictional scenario values**, not real agency regulation or law. Manuscript does not label them as fictional in the stem; could be misread as universal rule.

**Risk:** Learners might generalize “$15 limit” as universal legal standard. Agency gift policies vary — some prohibit any gifts, some set different thresholds, some allow within reason.

**Verified intent:** Teaching point is boundary principle (decline, explain policy, keep work/personal separate, offer alternatives), not specific dollar amount. Scenario is fictional Sam/Elena universe.

**Action:** Recorded as finding. Proposed labeling for next revision:

> `Question: Fictional scenario — A participant sends you a friend request and offers a $40 gift card to thank you. In this fictional scenario, the agency's handbook says gifts over $15 are not allowed and staff should keep personal social media separate. What is the most in-role response? ... Note: Gift limits in this scenario are fictional for teaching — check your real agency's handbook for actual policy.`

Add similar `Fictional scenario — gift limits used for teaching` note to Section 4 gift example if amounts retained. Opening Situation and all Sam/Elena narratives are already fictional (peer support specialist in Bronx) — gift amounts should be explicitly marked same.

---

## 4) Check Role-Specific Disclosure/Reporting Guidance

**Scope of check:** Does M02 correctly convey that disclosure, mandated reporting, and safety intervention duties are **role-dependent, setting-dependent, and fact-specific**, without overgeneralizing frontline discretion?

**Observed guidance (key excerpts):**

- Disclaimer (line 10): `When in doubt, ask a supervisor or agency counsel before sharing information.` — correct deference.

- Section 3 Consent closing (lines 59-64): Emergency contact ≠ permission — correctly qualified `for most non-emergency disclosures unless a specific exception or your agency's policy says otherwise`.

- Section 5A (line 86): `Most private health and service information needs consent to share with family/friends/other agencies/outside coworkers who do not need it for your job [M02-1][M02-3][M02-4].` — correct generalized default with consent requirement, cites correct bases.

- Section 5B Child abuse (lines 89-90): `Certain professionals are mandated reporters under Social Services Law §413 and must make a report to the Statewide Central Register when the law's threshold is met — for example, when you have reasonable cause to suspect child abuse or maltreatment while acting in your professional capacity [M02-5]. Many agencies make all staff mandated reporters by policy even if the law does not. You do not need to prove abuse, and you do not investigate on your own — you follow your agency's reporting steps and call the register [M02-5].` — **Correctly role-specific:** “Certain professionals” + “Many agencies make all staff… by policy even if law does not” — avoids overclaiming universal mandate; threshold `reasonable cause to suspect` quoted correctly; no investigation solo.

- Section 5B Harm to self/others (lines 91-92): `Frontline staff generally do not decide on their own to break confidentiality to warn an identifiable third party — they immediately involve a supervisor, clinical lead, or safety team who can assess imminence, check relevant state law and case law, and decide what, if anything, must be shared to protect safety, using the least amount of private information necessary [M02-4][M02-8]. In New York, duties related to threats and protective actions are role-specific and fact-specific — follow your supervisor and your agency's safety plan [M02-4][M02-8].` — **Correctly scoped:** “generally do not decide on their own,” “immediately involve supervisor/clinical lead,” “role-specific and fact-specific,” “least amount,” cites OMH safety protocol references.

- Section 5D (lines 97-99): `Do not guess. Pause, explain you will check, and involve a supervisor.` — correct.

- Section 7 Less helpful (lines 122-125): `Promising "I won't tell anyone, no matter what"` called out as less helpful — correct.

- Section 8 Breach (lines 134-135): `Tell a supervisor right away... Your agency likely has a privacy officer... timeframe for reviewing possible breaches [M02-1][M02-3].` — correct.

- Example 5 (lines 172-174): `Sam is a mandated reporter under agency policy. Sam does not investigate alone or tell the parent "I won't report." Sam follows agency steps: ensure immediate safety, call a supervisor, and make a report to the Statewide Central Register when threshold is met [M02-5].` — **Correctly distinguishes** law vs agency policy mandate, and procedural steps.

- Knowledge Checks 26-27 (lines 237, 243-246): 26 mandated reporting `Follow agency steps... when threshold is met; document facts without opinions [M02-5]` — correct. 27 imminent risk `Immediately get supervisor/clinical lead... do not make solo disclosure decisions [M02-4][M02-8]` — correct.

- Reviewer Notes (lines 274-276): `Duty to warn/protect: Fact-specific, role-specific — frontline staff involve supervisor/clinical lead; state law and case law (e.g., Tarasoff-type analyses) vary by jurisdiction — not for solo frontline judgment [M02-8].` — correct caveat.

**Result:** **Guidance is appropriately role-specific and non-overgeneralizing** as written. Frontline discretion is consistently limited to “involve supervisor,” mandated reporting is distinguished as law-defined “certain professionals” plus agency-policy expansion, safety duties are marked fact-specific, and every sharing instruction includes minimum-necessary and least-private-information limits. No overclaim of universal duty to warn or universal mandated-reporter status.

**Minor improvement noted (non-blocking):** Knowledge Check 26 stem says `While working in your professional role with a child and family, you have reasonable cause to suspect... Under Social Services Law §413 ... what is your duty?` — Could add `or under agency policy if it makes you a mandated reporter` qualifier in stem to reinforce agency-policy nuance already in explanation. Carry as optional copy-edit for V1.1, not a factual error.

---

## Summary

- October 24 dating: **verified consistent** (4 occurrences, same calendrical value, sequential with M01 Oct 23).
- `nysenate.gov`: **misclassified in [M02-3]** as nongovernmental example; correctly governmental — finding recorded for next bounded correction.
- Fictional gift limits ($15/$40): **correctly identified as fictional scenario values** needing explicit `Fictional scenario:` label to avoid misreading as universal rule.
- Role-specific disclosure/reporting: **verified as correctly scoped** — frontline staff defers to supervisor, mandated reporter law vs agency policy distinguished, least-necessary sharing, no solo decisions.

All findings are **review preparation, not approval**. No legal, comprehension, accessibility, or measured-runtime claims made. `1,083` checks remain record-validation only.

**Next:** Apply bounded corrections for `nysenate.gov` + fictional gift label in M02 V1.1 (or confirm in manuscript update), then proceed to M03 drafting per WO-CAREPATH-TEXTBOOK-001 sequence.

**Carry-forward:** M01 ready for review, 14:30 arithmetic resolved (870 sec), measured runtime pending; M02 V1 draft reported authored, now review-prepared; M03–M11 drafting not yet established; canonical acceptance/release pending.
