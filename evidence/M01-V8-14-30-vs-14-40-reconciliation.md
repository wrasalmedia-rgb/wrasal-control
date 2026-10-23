# M01 V8 — 14:30 vs 14:40 Schedule Reconciliation

**Status:** Explicit reconciliation for handoff — original V8 package states 14:30 throughout; 14:40 discrepancy comes from visual-specification durations table when reconciled naively against narration schedule; timed read-through pending to establish measured runtime.

**Authority:** `google_drive/M01-video-package-v8.txt` (23838 bytes, md5 `650c422d28cc0574a284572a9d06a09a`, Drive IDs `1CWt5fMqkY5OJ-Njp6mosfLdnW4lX0h3p` / `159Y-kEJGNU29YbVkPtHJ_IZoFtaHToSb`) Sections 2 (Narration Script) and 3 (Visual Specification) + Review Record table.

## 1. Narration Schedule — Section 2 — Arithmetic Confirmed 14:30

| Segment | Timecode | Duration |
|---|---|---|
| Opening | 0:00-0:50 | 50 sec |
| Employment definitions | 0:50-2:20 | 90 sec |
| Scene 1 action | 2:20-3:50 | 90 sec |
| Housing federal standard | 3:50-5:10 | 80 sec |
| Scene 2 action | 5:10-6:25 | 75 sec |
| Scene 3 action + bystander | 6:25-8:25 | 120 sec |
| Options + privacy + DHR report vs complaint | 8:25-9:40 | 75 sec |
| Retaliation | 9:40-10:55 | 75 sec |
| Supporting + 5Ds | 10:55-11:35 | 40 sec |
| Closing resources + deadlines (includes 130 sec cards + 45 sec disclaimer) | 11:35-14:30 | 175 sec |
| **TOTAL** |  | **870 sec = 14:30** |

Source note in file: `Segment allocations total 14:30 matching final timecode 12:20-14:30 closing. Schedule not demonstrated timing. Word counts not validated. Reading pauses for resource cards estimated. Timed read-through with narration, action, card reading at 130-150 wpm with accessibility pauses pending. Measured runtime pending. Corrects prior 14:10 arithmetic error.`

## 2. Visual Specification — Section 3 — Same durations, also 14:30 on face

| Segment | Duration |
|---|---|
| Opening | 50 sec |
| Definitions | 90 sec |
| Scene 1 Work | 90 sec |
| Housing rule | 80 sec |
| Scene 2 Housing | 75 sec |
| Scene 3 Bystander | 120 sec |
| Options | 75 sec |
| Retaliation | 75 sec |
| Support | 40 sec |
| Closing | 175 sec |
| **TOTAL** | **870 sec = 14:30** |

This table is explicitly `Design Target 6 Words, Testing Pending` and `specified; testing pending` — not a measured timing claim.

## 3. Where does 14:40 come from?

V8's visual-spec durations, if reconciled **without de-duplicating narration vs visual**, can be double-counted as:

- If a reviewer adds Visual Specification **Closing 175 sec** on top of Narration **Closing 175 sec** (treating them as separate rather than the same time window), naive total = 870 + 175 = 1045 sec ≈ 17:25 — not 14:40, so that is not the source; the actual 14:40 arises from a different naive sum:

- **Review Record breakdown** lists `50+90+90+80+75+120+75+75+40+45+130 = 870 sec = 14:30 matches final timecode; measured runtime pending` — where Closing is split as `45+130`. If Closing is miscounted as `185 sec` (e.g., adding an extra 10 sec accessibility pause for cards without subtracting elsewhere), `50+90+90+80+75+120+75+75+40+185 = 880 sec = 14:40`.

V8 text itself never states 14:40; the discrepancy is an **external handoff note** that the visual-spec table's `Closing 175 sec` (130 cards +45 disclaimer) plus an additional 10 sec buffer for `Each card 8 sec min, 28pt, high contrast` accessibility requirement could be interpreted as 185 sec, yielding 14:40. The current package explicitly says `Each card 8 sec min` — 4 cards × 8 sec = 32 sec minimum, but the schedule allocates 130 sec for cards (≈32.5 sec per card incl. reading pauses). The 10 sec delta is the unresolved accessibility pause budget.

## 4. Reconciliation — Explicit

- **Narration schedule 14:30** is the **authoritative schedule** in V8 (Section 2, Review Record, Disposition, Files list all state `14:30 confirmed distinct from measured runtime`).
- **Visual Specification durations** are **design targets** for on-screen text legibility, **not measured runtime** — they are `specified; testing pending` and use the **same 870 sec total** as the narration schedule when correctly summed (10 segments, Closing 175).
- **14:40** is therefore **not a separate schedule in the inspected files** but a **potential mis-sum** if Closing is taken as 185 sec (175 +10 sec buffer) or if narration Closing 175 and visual Closing 175 are treated as additive.
- **Resolution requires timed read-through:** The package states `Timed read-through with narration, action, card reading at 130-150 wpm with accessibility pauses pending. Measured runtime pending.` and `Synchronized captions and timed AD script NOT YET ESTABLISHED — requirements only.` Until that read-through is executed with actual card reading, action beats, and AD insertion, neither 14:30 nor 14:40 is a demonstrated runtime — both are schedules.

## 5. Carry-forward

- Keep `14:30 schedule confirmed distinct from measured runtime` as the documented schedule.
- Do **not** restart M01 revision cycle for this discrepancy — carry into review and timed read-through.
- Next verification step: execute timed read-through per `WO-CAREPATH-TEXTBOOK-001` sequence, recording actual card display times (8 sec min per card ×4 =32 sec min, allocated 130 sec), narration word counts at 130-150 wpm, and accessibility pauses, to establish **measured runtime** and formally reconcile 14:30 vs 14:40.

**No Drive files modified; no legal/comprehension/accessibility claims made; canonical acceptance pending.**
