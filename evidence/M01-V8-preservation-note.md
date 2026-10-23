# M01 V8 — Preservation Note: Original Extraction vs Corrected Derivative

**Purpose:** Explicitly document that the 42,682-byte `google_drive/M01-textbook-chapter-v8.txt` is a **corrected derivative**, not a text-identical extraction, and preserve the unchanged extraction separately with a diff showing every intentional edit.

## Files

| Path | Bytes | Chars | Lines | md5 | sha256 | Role |
|---|---|---|---|---|---|---|
| `evidence/sources/M01-textbook-chapter-v8-extracted-original.txt` | 38737 | 38534 | 237 | `cf5ac4ae0942fa036fcf828f6f539ffb` | `cb9155c467ef0ac0560cf98ca342254dba347267ae94aaa4aee179366f7b3e2d` | **Unchanged extraction** from `1MEEvWMN6PjEcZGvt3OkfXhlqZzXjaQ81` via `google_drive.read_file_text` — preserved verbatim, no edits |
| `google_drive/M01-textbook-chapter-v8.txt` | 42682 | 42463 | 252 | `0ff247b5e4170856d7363b5e95046fbe` | `41788f438e42f9668e5a13324023d6e54a2f783cd96f8d439c53f64804780c83` | **Corrected derivative** — WRASAL-0012 bounded housekeeping corrections + provenance banner — labeled `DERIVED UTF-8 TEXT — V8 with Bounded Housekeeping Corrections (WRASAL-0012)` |
| `google_drive/M01-textbook-chapter-v8.docx` | 49038 | — | — | `95efa955bae54929133361cc36872254` | `36f0bb25e1e8fbd0f8e33ee45b0af459adb7d9b29f9d270d0e5f36bfa4f929b6` | **Inspected Drive original** — preserved, unchanged — `1MEEvWMN6PjEcZGvt3OkfXhlqZzXjaQ81` |
| `evidence/M01-V8-bounded-corrections.diff` | 16431 | — | 54 | — | — | Unified diff of **core chapter text only** (original extraction vs corrected core without banner) — shows every intentional textual edit |
| `evidence/M01-V8-full-derived.diff` | 19478 | — | 69 | — | — | Unified diff of **original extraction vs full derived file with banner** — shows banner addition + all edits |

## Verification

- Original extraction hash matches Drive-derived extraction at inspection time: `cf5ac4ae...` / `cb9155c...` — recorded in `WRASAL-0011` and `WRASAL-0012` and `WO-CAREPATH-TEXTBOOK-001-receipt-check.json`.
- Corrected derivative hash `0ff247b5...` / `41788f43...` differs **intentionally** due to:
  1. Provenance banner (14 lines, ~3945 bytes) added at top — explicitly labeled as derived, missing-file note, correction list.
  2. Bounded corrections: 10 textual replacements (headers, Status, References header, entries [6][7][10][14][16], End disposition, Knowledge Checks heading) — see diff files for line-by-line.

Core narrative (Opening Situation `Maya works part-time...`, sections 1-10, knowledge checks 11-18 stems, glossary, etc.) is **identical except for the bounded corrections** — verified by diff.

## Intended Use

- **Handoff for continued drafting:** Use `google_drive/M01-textbook-chapter-v8.txt` (corrected derivative) as the working text for M02 development — it carries M01's chapter structure, source register with accurate classifications, and objective-to-assessment mapping.
- **Auditability:** Keep `evidence/sources/M01-textbook-chapter-v8-extracted-original.txt` as the **text-identical extraction** for independent verification of what was actually in the `.docx` at inspection time.
- **Do not claim** the derived `.txt` existed in Drive — `M01-textbook-chapter-v8.txt` was **missing** in folder `10-9f65DyZfdU37TEf9-ObAnU08BIlnxi` at inspection (reported in WRASAL-0011).
- **Control-plane scope:** `npm run validate:control-plane` (853 checks) validates **control-plane records only** (projects.yml, priorities, dependencies, work_orders vocabulary) — it does **not** establish textbook accuracy, learning effectiveness, accessibility, or legal approval — those remain `pending` per draft disclaimer.

## Next Action — M02

Per handoff: continue the existing work order `WO-CAREPATH-TEXTBOOK-001` into **M02**, reusing:
- M01 chapter structure (Opening Situation → Learning Goals → 1 Why This Topic Matters → ... → 10 Worked Examples → Glossary → References)
- Source register [1]-[16] with corrected classifications (official government vs Cornell LII nongovernmental vs Rochester university vs ecfr.io unofficial mirror)
- Objective-to-assessment mapping (knowledge checks 11-18 with objectives)

Carry remaining M01 findings (current-law verification, 14:30 vs 14:40 reconciliation, comprehension/accessibility/legal review, measured runtime) **into review** rather than restarting M01 revision cycle. M02 manuscripts not yet established — ready to proceed.
