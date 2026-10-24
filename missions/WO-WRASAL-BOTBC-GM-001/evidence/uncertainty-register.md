# Uncertainty Register — Brothers of the Blood Cloth: The Invocation

**Mission ID:** WO-WRASAL-BOTBC-GM-001  
**Date:** 2026-10-23  
**Steward:** Evidence Steward — Append-Only  
**Governing Rule:** Uncertainty must never silently become confidence.

---

## Classification

| Status | Meaning | May Arena Resolve Autonomously? |
|--------|---------|----------------------------------|
| **UNVERIFIED** | Claimed but without independent corroboration | No — tag explicitly, propose verification path |
| **PROVISIONAL** | Arena-proposed best guess pending human review | Yes — with flag `requires_human_decision: true` |
| **BLOCKED** | Cannot proceed without human/external authority | No — report with choices + consequences |
| **RESOLVED** | Confirmed by source or test | Yes — cite evidence |

---

## Open Uncertainties (by Domain)

### Cultural & Historical (High Priority for Consultant Review)

| ID | Uncertainty | Status | Evidence Needed | Next Step |
|----|-------------|--------|-----------------|-----------|
| UC-001 | 1980s prop period accuracy (Desmond suit, trousers, radio, furniture, banknotes) — risk anachronism | UNVERIFIED | Jamaican 1980s archive / consultant | Prop dating checklist before shoot — gate G09 |
| UC-002 | Opening line's period-perspective pickup line — cultural framing appropriate? | UNVERIFIED | Jamaican community elder consultant | Treatment stewardship note reviewed by consultant before picture lock — T10 |
| UC-003 | Reader Man representation — methods/biography undefined per directive; casting/wardrobe must not exoticize | UNVERIFIED | Jamaican spiritual community advisor | Wardrobe + performance review with advisor — SH030 spec flagged |
| UC-004 | Red thread presented as folklore — validator ensures no artifact claims folklore; all label FICTIONAL | PROVISIONAL | Text search of all docs for folklore claims | T10 — verified pass (FICTIONAL tag present) |
| UC-005 | Patwah dialect in dialogue (PROVISIONAL lines SH015–016, SH027, SH029–030) — requires writer/dialect steward | PROVISIONAL | Jamaican dialect steward + actor | Dialogue lock pending — writer's room + actor authenticity |

### Casting & Character

| ID | Uncertainty | Status | Next Step |
|----|-------------|--------|-----------|
| UC-006 | Ione 40y age jump (20s→60s) biological realism without heavy prosthetic | UNVERIFIED | Casting test — single actress vs two actresses resemblance; makeup test |
| UC-007 | Luke's meaningful contribution — PROPOSED SH011 center anchor + SH012 comic beat — director approval | PROVISIONAL | Director review of SH011–012 blocking + runtime neutral approval |
| UC-008 | Four brothers' maternal assignments (which two share mother) — explicitly NOT established | BLOCKED | Human decision required — do not invent; SH032 typography is statement without names |
| UC-009 | Yvonne/Marcia provisional names (replacement for LORNA) — community casting may shift | PROVISIONAL | Director confirmation of sister roles |
| UC-010 | YVONNE hand continuity (same nails/skin SH018–021) | UNVERIFIED | On-set continuity photos + hand double plan if needed |
| UC-011 | Ione/Yvonne/Marcia exact sister-to-brother relationship — not established | BLOCKED | Do not invent unsupported biographical relationship — T11 |

### Production & Technical

| ID | Uncertainty | Status | Next Step |
|----|-------------|--------|-----------|
| UC-012 | Red thread practical retraction rig (monofilament 1.5cm in 1.2s) feasible at T5.6–T8 depth | PROVISIONAL | Prop test: rig rehearsal day — macro DoF test, wire removal VFX clean backup |
| UC-013 | Shirt aging treatment (fabric Delta E 8 tea/UV) authentic & stable across shoot days | UNVERIFIED | Prop master fabric swatch test — photograph under 5600K before production |
| UC-014 | Church location holds 60 extras + window light soft — location availability | UNVERIFIED | Scout Jamaica church — confirm acoustics + power + window direction |
| UC-015 | Fourth voice casting — timbre memorable enough to be recognized SH007→SH031 (naïve listener ≥3/5 recognition) | PROVISIONAL | Voice artist test: play SH007 masked → SH031 isolated to 5 listeners; gate before mix lock |
| UC-016 | 1980s vs 2026 lighting warmth difference readable without gimmick (+4 LAB shift) | PROVISIONAL | DP test stills — 1980s warm vs 2026 neutral side-by-side review |
| UC-017 | SH020 thread legibility on 5\" phone at 2.39 crop | UNVERIFIED | Prop test photograph on phone — validated threshold |
| UC-018 | SH031 subliminal lighting change (fill -0.5 stop) perceived as grade error | PROVISIONAL | Monitor waveform — keep ≤0.5 stop; witness A/B where viewer not told about change |
| UC-019 | Location house = childhood house (aged) vs moved — which house is family house LOC-03 | BLOCKED | Location scout decision with art dept — impacts door geography |
| UC-020 | Hem vs collar as white-shirt repair site (chosen hem for macro logic) — director may prefer collar | PROVISIONAL | Director approval of material graph hem rationale |

### External Capability Blockers (Resolved as Pending, Not Failure)

| ID | Blocker | Class | Status | Reason | Mitigation |
|----|---------|-------|--------|--------|------------|
| UC-BLK-01 | No approved production repository exists | D | PENDING | No GitHub repo wrasal/wrayve/dust/yute accessible; `gh repo view` 404 | Complete local artifact package in `missions/WO-WRASAL-BOTBC-GM-001/`; record remote persistence pending; no new remote repo created without authorization |
| UC-BLK-02 | ChatGPT Template Creator not callable from Arena | D | PENDING | Template Creator is ChatGPT capability; Arena lacks skill to invoke | All 5 templates produced as REFERENCE READY (XLSX/DOCX/PPTX) + handoff package — see 06-templates/handoff-package.md; installation requires human in ChatGPT |
| UC-BLK-03 | Notion/Linear/Drive inspected but no BOTBC records discovered via sandbox | D | UNVERIFIED | No project records queryable via filesystem inspection | Recorded as UNVERIFIED external dependency; do not fabricate existence |

---

## Resolved Uncertainties (Evidence Now Available)

| ID | Was | Now | Evidence |
|----|-----|-----|----------|
| UC-R-001 | SH001–SH034 total = 105s? | RESOLVED PASS | T02 programmatic sum 105s — validator |
| UC-R-002 | Fourth laugh same file SH007→SH031? | RESOLVED PASS | T08 fiction-tagged + sound provenance declared same stem `SH007_FOURTH_VOICE.wav` |
| UC-R-003 | SH020 first supernatural visual & precedes attribution? | RESOLVED PASS | T06/T09 graph + index check |
| UC-R-004 | INEZ/LORNA prohibited names not used? | RESOLVED PASS | Text search + validator T04-name |
| UC-R-005 | 34 identifiers preserved? | RESOLVED PASS | T01 |

---

*Evidence Steward — Uncertainty never silent*  
*For each open uncertainty, see assigned next step + gate validator before shoot.*
