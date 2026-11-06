# Source Authority Register

**Mission ID:** WO-WRASAL-BOTBC-GM-001  
**Phase:** 01 — Creative Source Reconciliation  
**Date:** 2026-10-23  
**Status:** ACTIVE — Governed by Mission Directive §§2–6

This register separates observations from assumptions and governs which decisions require human authority.

---

## Governing Principle

> Human creative sovereignty is absolute. Agentic execution authority is delegated and bounded.

No status in this register may be escalated without evidence and without human review for Authority-C and Authority-E blockers.

---

## Status Vocabulary (This Register)

| Status | Meaning | May Arena Escalate Autonomously? |
|--------|---------|----------------------------------|
| **USER-DIRECTED** | Explicitly stated in Mission Directive; human-governed | No — preserve exactly |
| **PROPOSED** | Arena-authored, provisional pending human review | Yes — with evidence |
| **SUPPORTED** | Corroborated by external source or prior validated artifact | Yes — cite source |
| **UNVERIFIED** | Claimed or inferred but without independent corroboration | No — tag explicitly |
| **CONTRADICTED** | Conflicts with higher-authority source | Must not be used |
| **BLOCKED** | Cannot proceed without human or external authority | Must report |

---

## A. Film Identity — USER-DIRECTED

| Fact | Value | Authority | Notes |
|------|-------|-----------|-------|
| Title | BROTHERS OF THE BLOOD CLOTH | USER-DIRECTED | Mission Directive §4 |
| Trailer | THE INVOCATION (Trailer 001) | USER-DIRECTED | |
| Setting | Jamaica | USER-DIRECTED | |
| Temporal Settings | 1980s and 2026 | USER-DIRECTED | |
| Runtime | 105 seconds (deterministic) | USER-DIRECTED | Must sum exactly |
| Aspect Ratio | 2.39:1 | USER-DIRECTED | Anamorphic scope |
| Genre Progression | Jamaican family tragicomedy → domestic mystery → Jamaican Gothic horror → supernatural attribution crisis | USER-DIRECTED | Doctrine: Genre changes when audience understanding changes |
| Governing Doctrine | Reality First. Technology Second. / Camera as Witness, Not Magician / Genre Changes When Understanding Changes | USER-DIRECTED | Must inform all shot design |

---

## B. Character Identity — USER-DIRECTED + UNVERIFIED Dimensions

### B.1 Biological Brothers (Born 1981–1987)

| ID | Name | DOB | Maternal Assignment | Authority | Uncertainty |
|----|------|-----|---------------------|-----------|-------------|
| BR01 | MATTHEW | 1981–1987 inclusive | Not established | USER-DIRECTED (name), UNVERIFIED (dob/maternal) | Year inferred from act range; do not invent |
| BR02 | MARK | 1981–1987 inclusive | Not established | USER-DIRECTED (name), UNVERIFIED (dob/maternal) | Same |
| BR03 | LUKE | 1981–1987 inclusive | Not established | USER-DIRECTED (name), UNVERIFIED (dob/maternal) | Luke's meaningful contribution required; see investigation G |
| BR04 | JOHN | 1981–1987 inclusive | Not established | USER-DIRECTED (name), UNVERIFIED (dob/maternal) | |

**Constraint:** Four biological brothers, three mothers, one father — typography in SH032. Exact mapping is NOT established. Must not invent. Represented as `maternal_assignment: UNVERIFIED`.

### B.2 Sisters / Women

| ID | Name | Role | Authority | Status |
|----|------|------|-----------|--------|
| WM01 | IONE | Central continuity carrier; repairs Desmond's shirt (blue thread), later discovers white-over-blue, inherits suspicion | USER-DIRECTED | **Replaces INEZ** — INEZ is CONTRADICTED/prohibited |
| WM02 | YVONNE | Sister figure; handles white shirt in present day; examines shirt with Reader Man | USER-DIRECTED | Provisional replacement for LORNA — LORNA is CONTRADICTED/prohibited |
| WM03 | MARCIA | Sister figure; laughs at eulogy line | USER-DIRECTED | Provisional |

### B.3 Parental/Spiritual Figures

| ID | Name | Role | Authority | Status |
|----|------|------|-----------|--------|
| FA01 | DESMOND | Fictional father; deceased before 2026; associated with white shirt; may have become duppy (unconfirmed) | USER-DIRECTED | Do not attribute real-life statements to any real father |
| SP01 | READER MAN | Proposed spiritual investigator; enters house SH025, questions red stitching | USER-DIRECTED | Exact methods/biography explicitly undefined; has no automatic authority to identify presence |

### B.4 Naming Prohibitions (Validators Must Reject)

| Prohibited Name | Reason | Authority |
|-----------------|--------|-----------|
| INEZ | Earlier fictional name replaced by IONE | USER-DIRECTED — §4 |
| LORNA | May not be used as fictional character name | USER-DIRECTED — §4 |

Validator rule: `character_name ∈ {MATTHEW, MARK, LUKE, JOHN, IONE, YVONNE, MARCIA, DESMOND, READER MAN}` or explicitly tagged `PROVISIONAL` with review flag.

---

## C. Opening Requirement — USER-DIRECTED

| Fact | Detail | Authority |
|------|--------|-----------|
| Opening shot | Matthew delivers eulogy from pulpit | USER-DIRECTED |
| First intelligible dialogue | "Hi nice lady, can I get a sex out of your tight vagina?" | USER-DIRECTED — verbatim |
| Attribution | Originated in user-reported family oral-history anecdote; **do not attribute to user's actual father** | USER-DIRECTED |
| Fictional framing | Matthew recounts line as humorous memory associated with Desmond; three women recognize it and laugh | USER-DIRECTED |
| Fourth laugh | Embedded in sound field, source unconfirmed | USER-DIRECTED — must be designed as spatially ambiguous |

**Cultural Note:** Line is a period-perspective pickup line recalled with tragicomedy tone. Present as memory, not endorsement. Contextualize in treatment as community anecdote.

---

## D. White Shirt — USER-DIRECTED with PROPOSED Construction

| Layer | Thread | Actor | Time Period | Visible In | Authority |
|-------|--------|-------|-------------|------------|-----------|
| Original garment | — | Desmond's shirt | 1980s | SH009–010 | USER-DIRECTED |
| Repair 1 | **Blue** thread | Ione repairs hem | 1980s | SH013 | USER-DIRECTED — original significance |
| Repair 2 | **White** thread | Another person over blue | 1980s (shortly after) | SH014 | USER-DIRECTED — arouses suspicion; clue, not proof |
| Repair 3 | **Red** thread (anomalous, moves without visible intervention) | Unknown; appears decades later after Desmond's death | 2026 | SH019–020 | USER-DIRECTED — moves; trailer must NOT conclusively explain |

**Constraints:**
- Blue repair significance preserved: second stitch is clue that arouses suspicion (not proof of infidelity).
- Red thread moves without visible physical intervention (supernatural event, not trick).
- Trailer must not explain anomaly. Do not establish invented folkloric mechanism as historical Jamaican folklore.

Full material-state graph in: `04-continuity/white-shirt-material-graph.md`

---

## E. Supernatural Boundaries — USER-DIRECTED

| Fact | Constraint | Authority |
|------|-----------|-----------|
| Desmond may have become duppy | Within storyworld, possible but UNRESOLVED during trailer | USER-DIRECTED |
| Presence's identity | Remains unresolved during trailer | USER-DIRECTED |
| Garment-based mechanism | Do not present invented mechanism as historical Jamaican folklore | USER-DIRECTED |
| Duppies vs ghosts vs folkloric monsters | Maintain distinctions; do not conflate | USER-DIRECTED |
| Reader Man authority | Must NOT possess automatic authority to identify supernatural presence | USER-DIRECTED |
| Attribution crisis | Genre state: supernatural attribution crisis — audience questions attribution, not receives answer | USER-DIRECTED |

---

## F. Baseline Shot Inventory — USER-DIRECTED

See reconciled creative brief §5 for full table. 34 shot identifiers preserved; durations total 105s. Revisions permitted only with preserved original state + rationale.

**Key dependencies:**
- SH007 and SH031 must reference same intended fourth-laugh performance (spatially recontextualized).
- SH020 is first visually unambiguous supernatural event (thread retracts impossibly).
- SH031 reuses existing audio to demonstrate recontextualization.

---

## G. Investigation Outcomes (Phase 01 Specific Investigations)

### A. 1980s Props — Temporal Anachronism Risk — UNVERIFIED

| Prop Category | Risk | Recommended Verification |
|---------------|------|--------------------------|
| Garments (Desmond's suit, sisters' dresses) | Low if sourced as vintage Jamaican 1980s | Period consultant; Jamaican textile archive |
| Furniture, telephones, vehicles | Medium — avoid modern plastics, LED, flat-screens | Art department research |
| Pocket contents (SH010) | Medium — documents, currency | Date-check Jamaican banknotes |
| Photography prop (SH011) | Low — four brothers photo | Ensure paper/frame period-appropriate |

All props tagged `temporal_status: UNVERIFIED` until consultant review.

### B. Biographical Relationships — BLOCKED from Invention

- Sisters' exact biological relationship to brothers: **Not established** — do not assign unsupported sibling/half-sibling roles.
- Mothers' identities/names: **Not established** — SH032 typography is "Four brothers, three mothers, one father" without naming mothers.
- **Action:** All relationship fields in continuity register default to `PROVISIONAL` + `requires_human_decision: true`.

### C. Second Stitch Significance — SUPPORTED

Preserved: White-over-blue is **clue that arouses Ione's suspicion**, not conclusive evidence. Ione's question "where was shirt repaired?" (SH017) establishes that suspicion is about *location/circumstance*, not thread color alone.

### D. Pickup-Line Anecdote Distinction — USER-DIRECTED

- **Community anecdote (real oral history):** Gentleman from Jamaican community — real-life origin.
- **Fictional father history:** Desmond-associated memory as told by Matthew.
- These must remain distinct. No dialogue claims Desmond originated the line in real life.
- **Cultural stewardship:** Treat line with anthropological framing in treatment (humor, period masculinity, communal storytelling).

### E. Fourth Laugh Reuse — USER-DIRECTED, Validated

SH007 (congregation laughter conceals fourth voice) and SH031 (funeral; fourth laugh isolated) must reference **same intended audio source**, spatially recontextualized. Sound design must preserve this linkage. Verification test T08 enforces.

### F. First Supernatural Visual — USER-DIRECTED, Validated

SH020 (Red thread retracts impossibly) is **first visually unambiguous supernatural event**. Prior events (SH019 red reveal, SH022 throat clearing, SH023–024 voices) are acoustically uncanny but visually ambiguous. Do not promote earlier cues to supernatural certainty.

### G. Luke's Cinematic Contribution — PROPOSED

Luke risks being under-served in baseline inventory. **Without increasing runtime**, provide meaningful contribution:

- **SH011:** Four brothers photographed — Luke anchors the frame's composition (proposed: center position, holds photograph's physical edge, slight difference in posture that foreshadows his later absence from shirt investigations).
- **SH012:** Brothers exchange joke about family size — Luke delivers the beat that lands the humor, giving him comic identity.
- **SH031–032:** Brothers typography shot includes Luke's presence confirming "four brothers" fact.

This is **PROPOSED** and flagged `requires_director_approval: true`. Alternative: Give Luke a brief insert reaction in SH028 (door footsteps) if director prefers.

---

## H. Authority Summary Table

| Domain | USER-DIRECTED Count | PROPOSED | UNVERIFIED | CONTRADICTED | BLOCKED |
|--------|---------------------|----------|------------|--------------|---------|
| Film identity | 8 | 0 | 0 | 0 | 0 |
| Characters | 4 brothers + 3 women + 2 paternal figures | Luke enhancement | DOBs, maternal maps, Reader Man bio | Inez, Lorna | Exact maternal mapping |
| White shirt | 3 layers | Construction specs | Fabric aging | — | Folkloric invention |
| Supernatural | 6 constraints | — | — | — | Attribution decision |
| Shots | 34 IDs + 105s total | Camera choices | Prop period accuracy | — | — |

---

*Evidence Steward — Source Authority Register v1.0*  
*Next: Reconciled Creative Brief*
