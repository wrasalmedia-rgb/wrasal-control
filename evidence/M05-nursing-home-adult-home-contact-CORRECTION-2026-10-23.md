# M05 DOH Reporting Routes — Correction to Shared-Contact Addendum (Contrary Official Evidence)

**Execution:** 2026-10-23 America/New_York (EDT) — bounded patch same execution as M05 V1 → V1.1 (47900B 99911ef63378e12c583641852833430c) and M06 V1 → V1.1 (46780B 211e8a428e5e2b9824e21552a6001669); **Scheduled re-verification:** Oct 26 2026 prospective — see `evidence/M02-M03-execution-vs-scheduled-reverification-2026-10-25.md`.
**Status:** NOT APPROVED FOR PUBLIC RELEASE — control-record validation only; subject-matter verification of other claims still open (M02/M04 actual passages).
**Contrary source evidence:** Official NYS DOH Profiles guidance via **profiles.health.ny.gov** lists separately:
- **Nursing homes:** https://profiles.health.ny.gov/nursing_home/ — complaint **1-888-201-4563** (Nursing Home Complaint Hotline via NYS DOH Bureau of Vital / Nursing Home Complaint)
- **Adult care facilities / assisted living including adult homes:** https://profiles.health.ny.gov/adult_care/ — complaint **1-866-893-6772** (Adult Care Facility Complaint Hotline)
Official distinction confirms **DOH does NOT list a single shared contact** — addendum's prior conclusion was incorrect.

**What was incorrect:** `evidence/M05-nursing-home-adult-home-contact-verification-2026-10-26.md` V1 4749B ea7dc8c2 concluded *“DOH centralizes nursing home and adult care facility complaints; 1-888-201-4563 is published as the DOH centralized complaint ... Adult homes also route via DOH central intake; the number is the same portal, with adult care triage ... Manuscript is correct that DOH is the entry point for both”* — this **shared-contact conclusion is superseded** per distinct official numbers above. The V1 addendum is preserved at `evidence/sources/M05-addendum-V1-preserved-2026-10-26.txt` 4749B ea7dc8c2 and marked **SUPERSEDED** in its current file; `evidence/sources/M05-textbook-chapter-v1-V1-preserved-2026-10-25.txt` 44901B b925774 remains preserved; diff `evidence/M05-V1-to-V1.1-DOH-correction.diff` 107 lines 24576B shows bounded correction; `evidence/M06-V1-to-V1.1-DOH-crossref-correction.diff` 67 lines 18238B shows propagation.

**Correction applied (bounded patch):**

- **M05 V1 → V1.1:** Lesson **§6 B split to two distinct contacts**: Nursing homes → **1-888-201-4563 [M05-7a]** (Mrs. Chen), Adult care / adult homes → **1-866-893-6772 [M05-7b]** (Ms. Washington); Resource **§9 split** to Nursing Home [M05-7a] + Adult Care Facility [M05-7b] with profiles.health.ny.gov citations; **Examples 2 corrected** to adult-care 1-866-893-6772, **Example 3 corrected** to nursing-home 1-888-201-4563 with explicit “do not interchange” note; **Recap split** to separate bullets; **Glossary DOH updated** to two distinct hotlines; **KC55 updated** to test nursing-home 1-888-201-4563 with adult-home 1-866-893-6772 distractor note; **References split** to [M05-7a]/[M05-7b] with official DOH Profile URLs, old [M05-7] marked superseded.
- **M06 V1 → V1.1:** All affected cross-references updated from “DOH centralized complaint 1-888-201-4563 portal” to **“DOH Nursing Home Complaint 1-888-201-4563 [M05-7a] vs Adult Care Facility Complaint 1-866-893-6772 [M05-7b] (separate per official profiles.health.ny.gov)”** — §5 overlap table, §8 licensed facility steps, §9 finding help, Example 3, [M06-7]; prior verification addendum reference updated to point to this CORRECTION file.
- **Other uninspected reporting claims left open** per instruction — no restart; only DOH number separation corrected.

**Verification:** After correction, **nursing homes** map to official nursing-home channel (1-888-201-4563); **adult care facilities / assisted living including adult homes** map to distinct adult-care channel (1-866-893-6772); both via official DOH Profiles — profiles.health.ny.gov is official NY.gov publisher for facility profiles (see footer of profiles.health.ny.gov referencing NYSDOH). Prior addendum incorrectly inferred shared central intake; new official listing contradicts that. M06 propagation ensures bounded patch does not persist error.

**No Drive originals modified, no merge/deploy, canonical pending.**

