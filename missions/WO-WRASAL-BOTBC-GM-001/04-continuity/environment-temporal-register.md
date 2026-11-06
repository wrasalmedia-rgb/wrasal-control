# Environment, Temporal & Camera Geography Registers

**Project:** BROTHERS OF THE BLOOD CLOTH — THE INVOCATION  
**Mission:** WO-WRASAL-BOTBC-GM-001  
**Date:** 2026-10-23

---

## A. Environment Register

### A.1 Principal Locations

| Loc ID | Name | Description | Period | Shots | Continuity Notes |
|--------|------|-------------|--------|-------|------------------|
| LOC-01 | Church | Jamaican church (Kingston parish or equivalent) — wooden pews, pulpit, high windows, casket space, center aisle | 2026 | SH001–008, SH031 | Same location SH001→SH008→SH031; returned to after house sequences. Must hold ~60 extras. Warm window light. |
| LOC-02 | Ione & Desmond Home Interior (1980s) | Bedroom + domestic area — bed/dresser, mirror, laundry/ironing surface, curtains, radio, period furniture | 1980s | SH009–017 | Warm 1980s domestic. Window daylight (1980s warmth). Props: dresser, mirror, trousers, hero shirt, period phone. Must distinguish from 2026 house visually via warmer grade + period props. |
| LOC-03 | Family House Interior (2026) | Living room / bedroom / corridor / bathroom — same house as LOC-02 but 40y later (aged) or successor house (family home) | 2026 | SH018–030, SH034 | Neutral 2026 daylight. Corridor with bedroom door (SH024, SH028, SH029, SH030) — consistent geography. Bathroom (SH022). Living room table for collective shirt examination (SH026–027, SH030). |
| LOC-04 | Photo Studio / Portrait Location (1980s) | Simple indoor portrait setup — backdrop or domestic wall, photographer implied | 1980s | SH011–012 | Where four brothers' photograph taken — warm portrait light. |
| LOC-05 | GFX Stage | Black screen / typography / title — no location | GFX | SH032–034 (plus SH001/SH034 black) | Controlled GFX; no continuity to physical locations. |

#### Location Aging Logic

If LOC-02 = LOC-03 (same physical house 40y apart):
- 1980s: fresh paint, period fixtures, younger domestic objects.
- 2026: paint faded, fixtures aged/replaced, modern objects intrude, but corridor door retains same proportions/door hardware family (continuity anchor).

If LOC-02 ≠ LOC-03 (different houses — Ione moved):
- Still maintain door continuity (same door moved/replicated) — audience needs threshold recognition.

**Decision Required (PROPOSED):** Use same house aged — more coherent for threshold door. Flagged `requires_location_scout_decision: true`.

### A.2 Location Continuity Gating

| Gate | Check | Enforced |
|------|-------|----------|
| Church holds all funeral shots (SH002, SH007, SH031) same geography | Validator checks LOC-01 consistency | Yes — T05 |
| Bedroom door is same door in SH024, SH028, SH029, SH030 — geography test | Same LOC-03 door prop, same frame, same handle height | Yes |
| 1980s domestic distinguishable from 2026 house (props, grade) | Props register + lighting matrix | Yes — manual review |

---

## B. Temporal Register

### B.1 Timeline Map

| Period | Fictional Year(s) | Trailer Shots | Visual Signifiers | Sound Signifiers |
|--------|-------------------|---------------|-------------------|------------------|
| **1980s** | ~1984–1987 (Desmond in late 20s) | SH009–017 (9 shots, 27s) — plus SH011–012 photo | Warm (print emulation slight), period menswear, wood furniture, tube radio, yellowed whites vs optic white, blue/white thread new | Distant 1980s radio, outside birds, house settling (warmer) |
| **2026** | Present (Desmond deceased) | SH001–008 (17s), SH018–031, SH034 (house + funeral) | Neutral-warm to neutral-cool (2026 neutral; SH031 slightly cooler), aged shirt (yellowed), modern grooming, corridor door | Modern ambient, cassette hiss (SH023), throat clearing, footsteps, fourth laugh |
| **GFX** | Non-diegetic | SH032–033 (7s) | Typography/title, red-thread motif | Score, typography sound (if any) |
| **Photograph Past** | 1980s (child brothers) | SH011–012 (photo creation) | Portrait photography style | Shutter, brothers' joke |

### B.2 Time Period Transition Table

| Cut | From → To | Transition | Editorial Note |
|-----|-----------|------------|----------------|
| SH008→SH009 | 2026 funeral → 1980s dressing | Hard cut on Matthew's "Daddy used to love that story" — memory motivated | Matthew's line is time portal |
| SH017→SH018 | 1980s shirt inquiry → 2026 shirt present | Hard cut on Ione's question "Where was this repaired?" → Yvonne handles same shirt aged | Same shirt bridges 40 years |
| SH012→SH013 | Photo → stitching | Cut on group laugh → Ione hand close | Communal → forensic |
| SH031→SH032 | 2026 funeral (recontext.) → GFX typography | Hard cut; typography carries reverb tail | Funeral → statement |

### B.3 Temporal Continuity Gates

| Gate | Check |
|------|-------|
| No 2026 prop in 1980s (anachronism) | Props register §7.2 + validator |
| 1980s costume distinct from 2026 (no modern cuts) | Character register |
| Shirt aging consistent: 1980s optic white → 2026 cream/yellow (delta E 8) | Material graph |
| Child photo SH011 period paper/frame matches 1980s (not inkjet) | Props register |

---

## C. Camera Geography Register

### C.1 Camera Positions & Eyelines

Map ensures camera geography is coherent (no crossing the line inadvertently).

| Shot | Camera Position (plan view) | Eyeline Target | Screen Direction |
|------|------------------------------|----------------|------------------|
| SH002 | Center aisle, eye level, facing pulpit | Congregation → pulpit; Matthew → congregation | Pulpit background center |
| SH003 | Slight low, pulpit axis | Matthew → congregation (camera-left pews) | Matthew right-of-center looking left |
| SH004–006 | Reverse: congregation pews facing pulpit | Yvonne/Ione/Marcia → pulpit (Matthew) | Pulpit implied camera-right background |
| SH007 | Mid-wide congregation, pulpit soft BG | Congregation → pulpit; no one → camera | Congregation foreground |
| SH008 | Pulpit axis, back to congregation | Matthew → congregation (same as SH003 but medium) | Matthew center, congregation implied foreground |
| SH009 | Bedroom: dresser axis, window camera-right | Desmond → mirror | Mirror foreground reflection |
| SH010 | Overhead/hands | Hands → trousers/shirt | Fabric center |
| SH011 | Portrait: straight-on, subject axis | Four brothers → camera (photograph pose) | Center frame |
| SH012 | Same axis, looser | Brothers ↔ each other (joke) | Interpersonal |
| SH013–014 | Macro overhead | Hands → hem | Hem horizontal; hands edge |
| SH015 | Two-shot interior: Ione FG | Ione → Desmond camera-left | Ione right looking left |
| SH016 | Reverse: Desmond FG | Desmond → Ione but avoiding (eyeline off by 10°) | Desmond left looking right but down |
| SH017 | Two-shot | Ione → Desmond (pressing) | Same line |
| SH018–020 | Macro overhead (2026) | Yvonne hands → shirt hem | Hem center; hands edges |
| SH021 | Close Yvonne | Yvonne → shirt (off-frame below) | Yvonne center, eyeline down |
| SH022 | Bathroom wide: door axis | Empty — implied presence off-camera | Mirror center |
| SH023 | Mark at table | Mark → cassette player / off beyond | Player center, Mark eyeline to object |
| SH024 | John at bedroom door | John → door | Door center deep |
| SH025 | Doorway: Reader enters | Reader → house interior (women mid) | Doorway center, Reader FG |
| SH026 | Table: women around shirt | Women → shirt center | Shirt center |
| SH027 | Same table, Reader joins | Reader + women → shirt | Reader camera-right |
| SH028 | Corridor door | (Empty) — footsteps imply off beyond door | Door center deep |
| SH029 | Mark at door | Mark → door; voice ← beyond door | Door deep, Mark FG 3/4 |
| SH030 | Corridor: Reader + women + door | Reader → Mark / shirt; women → Reader/door | Reader FG right, door deep center, women mid left |
| SH031 | Congregation row (tighter than SH007) | Row → pulpit (as SH007) but one not laughing looks off-axis slight | Row foreground, pulpit soft deep |

### C.2 Line & Geography Preservation

- **Funeral geography:** Pulpit is always deep/center; congregation faces it (camera respects line).
- **Bathroom/door threshold geography:** Door is always deep center when featured; who faces it determines meaning (John faces door = listener; Reader faces door but questions evidence, not engages presence).
- **Domestic 1980s Ione/Desmond:** Eyeline 30° cross, not 180° direct confrontation (domestic, not courtroom).
- **House 2026 3-way:** Reader Man's axis is 3/4 to door, not to camera — he addresses community, not audience.

### C.3 Camera Continuity Validation

- [ ] 180-degree line not crossed in any dialogue pair (to be checked on plan view diagram in blocking matrix).
- [ ] Door geography same across SH024/SH028/SH029/SH030 (plan view overlay).

---

## D. Editorial Progression Register

| Act | Shots | Timecode | Editorial Rhythm | Sound Logic |
|-----|-------|----------|------------------|-------------|
| **I Elegy** | SH001–007 | 00:00–00:20 | Long hold SH001 (6s), short singles SH003–006 (2s portrait rhythm), SH007 mid-wide (3s room) | Church acoustic bed continuous; fourth laugh masked |
| **II Inquiry** | SH008–017 | 00:20–00:51 | SH008 bridge (3s); 1980s inserts + two-shots (3s each, SH013 4s holds craft) | Domestic warmth; dialogue-forward; fabric foley |
| **III Uncanny** | SH018–026 | 00:51–01:17 | SH018–021 thread arc (3s each, SH022 hold 2s), SH023–026 voices/entry (3s) | House hush; thread whisper; voices off/beyond; collective exam |
| **IV Attribution Crisis** | SH027–031 | 01:17–01:34 | SH027 4s inquiry, SH028–030 3s crisis, SH031 4s isolation (longest in act — forces re-listen) | Reader questions; footsteps; response; isolation |
| **GFX/Typographic** | SH032–034 | 01:34–01:45 | SH032 typography 4s, SH033 title 3s, SH034 stinger 4s | Score holds; voice stinger |

**Rhythm Logic:** Short portraits build communal speed (SH003–006) → longer forensic holds test observation (SH013 4s) → uncanny stillness slows (SH018–020 3s locked overhead) → isolation hold SH031 4s forces re-evaluation.

---

## E. Sound Register (Summary)

Full cue sheet in `05-production-artifacts/editorial-sound-cue-sheet.md`; summary here:

| Sound Object | Source File Provenance | First Heard | Reused |
|--------------|------------------------|-------------|--------|
| Fourth laugh | SH007_FOURTH_VOICE.wav — single stem, church IR, 15° off-axis | SH007 (masked) | SH031 (isolated, same hash) |
| Tape voice Desmond | Archival tape recording (cassette) — SH023 | SH023 | — (related timbre to SH001's line but archival quality) |
| Voice beyond door | SH024, SH029, SH034 — same performer, different processing | SH024 | SH029 (responds), SH034 (stinger) |
| Throat clearing | SH022 — familiar | SH022 | Linked timbre to fourth voice (same family, not same file) |
| Red thread retraction | Waxed thread through weave (close mic) — SH020 | SH020 | — |

**Validation T08:** SH007 and SH031 fourth voice must be same source file — validator checks reference field.

---

## F. Supernatural Events Register (Observed vs Attributed)

| Event | Shot | Observed (What We See/Hear) | Attributed (What Characters Claim) | Validator Status |
|-------|------|------------------------------|------------------------------------|------------------|
| Fourth laugh | SH007 | Extra voice in congregation laughter — spatially off; masked | No attribution yet — congregants likely think it's congregant | T08 tracks |
| Red thread reveal | SH019 | Red thread beneath older repairs — visual anomaly | No attribution — Yvonne hasn't interpreted | T09 pending |
| **Red retracts** | **SH020** | **Thread moves without visible pull — impossible — FIRST VISUAL SUPERNATURAL** | No attribution — Yvonne reacts with body, not theory | **T09: SH020 precedes explicit attribution** |
| Throat clearing | SH022 | Familiar sound in empty bathroom — acoustic uncanny | No attribution — presence implied off | — |
| Tape voice | SH023 | Recorded voice resembling father — archival hiss | Mark hears as father — but could be tape | — |
| Voice beyond door | SH024/029 | Voice behind closed door, answers Mark | Mark: "Mi father dead" — voice answers — crisis | — |
| Footsteps | SH028 | Footsteps approaching door — empty corridor | No attribution | — |
| Fourth laugh isolated | SH031 | Same laugh isolated — SH007's excess re-heard | Recontextualization — not new attribution | T08 |
| Voice stinger | SH034 | Shirt-related voice (black screen) — final uncanny | Not attributed | — |
| **Reader investigates** | **SH025/027/030** | **Reader Man questions red, questions Desmond attribution** | **Explicit questioning — NOT automatic identification** | **T09/T10** |

**Doctrine Enforcement:** No shot conclusively explains anomaly; no folklore mechanism invented and presented as tradition.

---

*Continuity Intelligence — Environment, Temporal, Camera, Editorial, Sound, Supernatural Registers v1.0*  
*All continuity fields validated deterministically where possible (T05, T06, T09)*
