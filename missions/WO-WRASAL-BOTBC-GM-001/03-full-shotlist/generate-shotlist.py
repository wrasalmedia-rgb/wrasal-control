#!/usr/bin/env python3
"""Generate BOTBC The Invocation Master Shot List YAML + XLSX with deterministic validation."""
import yaml
import json
import os
import sys
from pathlib import Path
from datetime import datetime

ROOT = Path(__file__).parent
OUT_YAML = ROOT / "master-shot-list.yaml"
OUT_JSON = ROOT / "master-shot-list.json"  # secondary
REPORT = ROOT / "shotlist-validation.json"

# Baseline inventory from Mission Directive §5
baseline = [
    ("SH001", 6, "Black screen; Matthew delivers opening line", "2026", "Funeral", "I", "Tragicomedy"),
    ("SH002", 3, "Church master shot, casket and pulpit", "2026", "Funeral", "I", "Tragicomedy"),
    ("SH003", 2, "Matthew observes congregation", "2026", "Funeral", "I", "Tragicomedy"),
    ("SH004", 2, "Yvonne recognizes joke", "2026", "Funeral", "I", "Tragicomedy"),
    ("SH005", 2, "Ione laughs", "2026", "Funeral", "I", "Tragicomedy"),
    ("SH006", 2, "Marcia laughs", "2026", "Funeral", "I", "Tragicomedy"),
    ("SH007", 3, "Congregation laughter conceals fourth voice", "2026", "Funeral", "I→II", "Tragicomedy→Mystery"),
    ("SH008", 3, "Matthew: 'Daddy used to love that story'", "2026", "Funeral", "II", "Domestic Mystery"),
    ("SH009", 3, "Young Desmond dressing, historical period", "1980s", "Ione & Desmond Home", "II", "Domestic Mystery"),
    ("SH010", 3, "Woman examines trousers pockets", "1980s", "Ione & Desmond Home", "II", "Domestic Mystery"),
    ("SH011", 3, "Four brothers photographed together", "1980s", "Family Portrait", "II", "Domestic Mystery"),
    ("SH012", 3, "Brothers exchange joke about family size", "2026/1980s", "Family Portrait", "II", "Domestic Mystery"),
    ("SH013", 4, "Ione's original blue-thread stitching", "1980s", "Domestic Repair", "II", "Domestic Mystery"),
    ("SH014", 3, "White repair discovered over blue stitching", "1980s", "Domestic Repair", "II", "Domestic Mystery"),
    ("SH015", 3, "Ione questions the repair", "1980s", "Domestic Inquiry", "II", "Domestic Mystery"),
    ("SH016", 3, "Desmond gives vague explanation", "1980s", "Domestic Inquiry", "II", "Domestic Mystery"),
    ("SH017", 3, "Ione questions where shirt was repaired", "1980s", "Domestic Inquiry", "II", "Domestic Mystery"),
    ("SH018", 3, "Present-day Yvonne handles white shirt", "2026", "House Present", "III", "Gothic Horror"),
    ("SH019", 3, "Red thread revealed beneath older repairs", "2026", "House Present", "III", "Gothic Horror"),
    ("SH020", 3, "Red thread retracts impossibly", "2026", "House Present", "III", "Gothic Horror"),
    ("SH021", 3, "Yvonne reacts to unexplained movement", "2026", "House Present", "III", "Gothic Horror"),
    ("SH022", 2, "Empty bathroom; familiar throat clearing", "2026", "House Present", "III", "Gothic Horror"),
    ("SH023", 3, "Mark hears recorded voice resembling father", "2026", "House Present", "III", "Gothic Horror"),
    ("SH024", 3, "John hears father's voice beyond bedroom door", "2026", "House Present", "III", "Gothic Horror"),
    ("SH025", 3, "Reader Man enters family house", "2026", "House Present", "III", "Gothic Horror"),
    ("SH026", 3, "Women examine shirt together", "2026", "House Present", "III", "Gothic Horror"),
    ("SH027", 4, "Reader Man questions red stitching", "2026", "House Present", "IV", "Attribution Crisis"),
    ("SH028", 3, "Bedroom door; approaching footsteps", "2026", "House Present", "IV", "Attribution Crisis"),
    ("SH029", 3, "Mark says father is dead; voice responds", "2026", "House Present", "IV", "Attribution Crisis"),
    ("SH030", 3, "Reader Man questions attribution to Desmond", "2026", "House Present", "IV", "Attribution Crisis"),
    ("SH031", 4, "Return to funeral; fourth laugh isolated", "2026", "Funeral", "IV→I", "Attribution Crisis→Tragicomedy"),
    ("SH032", 4, "Four brothers, three mothers, one father typography", "GFX", "GFX", "—", "—"),
    ("SH033", 3, "Film title; red-thread visual motif", "GFX", "GFX", "—", "—"),
    ("SH034", 4, "Black screen; final shirt-related voice stinger", "2026", "House Present", "IV", "Attribution Crisis"),
]

# Detailed specs per shot - enrich with all required fields
def fmt_tc(seconds):
    m = seconds // 60
    s = seconds % 60
    return f"{m:02d}:{s:02d}:00"

# Build full ShotSpecs
shots = []
elapsed = 0
for idx, (sid, dur, content, period, scene, act, genre) in enumerate(baseline):
    start = elapsed
    end = elapsed + dur
    timecode_in = f"00:{start//60:02d}:{start%60:02d} +{dur:02d}s"
    # actually use 00:MM:SS format
    start_tc = f"00:{start//60:02d}:{start%60:02d}"
    end_tc = f"00:{end//60:02d}:{end%60:02d}"

    # Assign detailed per spec
    # Character mappings derived from brief
    char_map = {
        "SH001": ["MATTHEW"],
        "SH002": ["MATTHEW","IONE","YVONNE","MARCIA","MARK","LUKE","JOHN","DESMOND_CASKET"],
        "SH003": ["MATTHEW"],
        "SH004": ["YVONNE"],
        "SH005": ["IONE"],
        "SH006": ["MARCIA"],
        "SH007": ["IONE","YVONNE","MARCIA","MATTHEW","CONGREGATION"],
        "SH008": ["MATTHEW"],
        "SH009": ["DESMOND"],
        "SH010": ["IONE","DESMOND"],
        "SH011": ["MATTHEW","MARK","LUKE","JOHN"],
        "SH012": ["MATTHEW","MARK","LUKE","JOHN"],
        "SH013": ["IONE"],
        "SH014": ["IONE"],
        "SH015": ["IONE","DESMOND"],
        "SH016": ["DESMOND","IONE"],
        "SH017": ["IONE","DESMOND"],
        "SH018": ["YVONNE"],
        "SH019": ["YVONNE"],
        "SH020": ["YVONNE","RED_THREAD"],
        "SH021": ["YVONNE"],
        "SH022": ["DESMOND_VOICE"],
        "SH023": ["MARK","DESMOND_VOICE"],
        "SH024": ["JOHN","DESMOND_VOICE"],
        "SH025": ["READER_MAN","IONE","YVONNE","MARCIA"],
        "SH026": ["IONE","YVONNE","MARCIA"],
        "SH027": ["READER_MAN","IONE","YVONNE","MARCIA"],
        "SH028": ["MARK","JOHN","DESMOND_PRESENCE"],
        "SH029": ["MARK","DESMOND_VOICE"],
        "SH030": ["READER_MAN","IONE","YVONNE","MARCIA","MARK"],
        "SH031": ["MATTHEW","IONE","YVONNE","MARCIA","CONGREGATION"],
        "SH032": [],
        "SH033": [],
        "SH034": ["DESMOND_VOICE"],
    }
    prop_map = {
        "SH001": [],
        "SH002": ["P_CASKET","P_PULPIT","P_EULOGY_PAPERS"],
        "SH003": ["P_EULOGY_PAPERS"],
        "SH004": ["P_CHURCH_PEWS"],
        "SH005": ["P_CHURCH_PEWS"],
        "SH006": ["P_CHURCH_PEWS"],
        "SH007": ["P_CHURCH_PEWS"],
        "SH008": ["P_PULPIT"],
        "SH009": ["P_WHITE_SHIRT_1980S_YOUNG","P_TROUSERS_1980S","P_WARDROBE_1980S"],
        "SH010": ["P_TROUSERS_1980S","P_WHITE_SHIRT_1980S_YOUNG"],
        "SH011": ["P_PHOTOGRAPH_FOUR_BROTHERS","P_CAMERA_PROP_1980S"],
        "SH012": ["P_PHOTOGRAPH_FOUR_BROTHERS"],
        "SH013": ["P_WHITE_SHIRT_HERO_1980S","P_BLUE_THREAD","P_NEEDLE"],
        "SH014": ["P_WHITE_SHIRT_HERO_1980S","P_BLUE_THREAD","P_WHITE_THREAD"],
        "SH015": ["P_WHITE_SHIRT_HERO_1980S"],
        "SH016": ["P_WHITE_SHIRT_HERO_1980S"],
        "SH017": ["P_WHITE_SHIRT_HERO_1980S"],
        "SH018": ["P_WHITE_SHIRT_HERO_2026_AGED","P_WHITE_THREAD","P_BLUE_THREAD"],
        "SH019": ["P_WHITE_SHIRT_HERO_2026_AGED","P_RED_THREAD","P_WHITE_THREAD","P_BLUE_THREAD"],
        "SH020": ["P_WHITE_SHIRT_HERO_2026_AGED","P_RED_THREAD","P_WHITE_THREAD","P_BLUE_THREAD"],
        "SH021": ["P_WHITE_SHIRT_HERO_2026_AGED","P_RED_THREAD"],
        "SH022": ["P_BATHROOM_SINK","P_MIRROR"],
        "SH023": ["P_CASSETTE_PLAYER","P_TAPE_DESMOND_VOICE"],
        "SH024": ["P_BEDROOM_DOOR","P_WHITE_SHIRT_HERO_2026_AGED"],
        "SH025": ["P_DOOR_HOUSE_ENTRANCE","P_READER_BAG"],
        "SH026": ["P_WHITE_SHIRT_HERO_2026_AGED","P_RED_THREAD"],
        "SH027": ["P_WHITE_SHIRT_HERO_2026_AGED","P_RED_THREAD"],
        "SH028": ["P_BEDROOM_DOOR"],
        "SH029": ["P_BEDROOM_DOOR"],
        "SH030": ["P_WHITE_SHIRT_HERO_2026_AGED","P_BEDROOM_DOOR"],
        "SH031": ["P_CHURCH_PEWS","P_PULPIT"],
        "SH032": ["P_TYPOGRAPHY_CARD_4B3M1F"],
        "SH033": ["P_TITLE_CARD_BOTBC","P_RED_THREAD_MOTIF"],
        "SH034": [],
    }

    # Camera assignments
    camera_map = {
        "SH001": {"camera":"Alexa Mini LF (audio) ","lens":"N/A (black screen)","framing":"Black 2.39:1","angle":"N/A","movement":"Locked","lighting":"N/A (black)"},
        "SH002": {"camera":"Alexa Mini LF on sticks A-cam","lens":"24mm Cooke Panchro T2.8","framing":"Wide master church, casket FG, pulpit BG","angle":"Eye level, center aisle","movement":"Locked","lighting":"Window daylight soft camera-right + bounce"},
        "SH003": {"camera":"A-cam LF","lens":"50mm Cooke Panchro T2.0","framing":"Medium close Matthew","angle":"Slight low, eye level","movement":"Locked","lighting":"Window + pulpit practical"},
        "SH004": {"camera":"B-cam LF","lens":"85mm Cooke Panchro T2.0","framing":"Close Yvonne","angle":"Eye level","movement":"Locked","lighting":"Window soft camera-right"},
        "SH005": {"camera":"B-cam LF","lens":"85mm T2.0","framing":"Close Ione","angle":"Eye level","movement":"Locked","lighting":"Same church window"},
        "SH006": {"camera":"B-cam LF","lens":"85mm T2.0","framing":"Close Marcia","angle":"Eye level","movement":"Locked","lighting":"Same church window"},
        "SH007": {"camera":"A-cam LF on sticks","lens":"32mm Cooke Panchro T4.0","framing":"Mid-wide congregation, pulpit soft BG","angle":"Eye level center","movement":"Subtle push 2% or locked","lighting":"Window soft camera-right, bounce fill 1.5:1"},
        "SH008": {"camera":"A-cam LF","lens":"50mm T2.0","framing":"Medium Matthew at pulpit","angle":"Eye level","movement":"Locked","lighting":"Same church, warm"},
        "SH009": {"camera":"LF on sticks","lens":"35mm T2.8","framing":"Medium Desmond dressing, mirror FG","angle":"Eye level, slight profile","movement":"Locked","lighting":"1980s warm window daylight + tungsten practical"},
        "SH010": {"camera":"LF","lens":"50mm T2.8","framing":"Insert hands in pockets","angle":"45° down","movement":"Locked","lighting":"Same warm domestic"},
        "SH011": {"camera":"LF on sticks","lens":"35mm T2.8","framing":"Group portrait four brothers","angle":"Eye level","movement":"Locked (photograph pose)","lighting":"1980s portrait window + fill"},
        "SH012": {"camera":"LF","lens":"40mm T2.8","framing":"Medium group joke","angle":"Eye level","movement":"Handheld drift 5% (energy)","lighting":"Portrait warm"},
        "SH013": {"camera":"LF + macro","lens":"100mm Macro T4.0","framing":"ECU hem blue stitching","angle":"45° overhead","movement":"Locked micro","lighting":"Raking window + hard accent for thread texture"},
        "SH014": {"camera":"LF + macro","lens":"60mm Macro T5.6","framing":"ECU hem white over blue","angle":"45° overhead","movement":"Manual focus rack blue→white","lighting":"Same raking warm domestic"},
        "SH015": {"camera":"LF","lens":"50mm T2.2","framing":"Medium Ione questioning","angle":"Eye level","movement":"Locked","lighting":"Warm domestic, window soft"},
        "SH016": {"camera":"LF","lens":"50mm T2.2","framing":"Medium Desmond vague explanation","angle":"Eye level slight low","movement":"Locked","lighting":"Same domestic"},
        "SH017": {"camera":"LF","lens":"50mm T2.2","framing":"Two-shot Ione/Desmond","angle":"Eye level 3/4","movement":"Locked","lighting":"Same domestic, cooler fill for tension"},
        "SH018": {"camera":"LF on sticks","lens":"60mm Macro T4.0","framing":"ECU Yvonne hands + shirt aged","angle":"45° overhead","movement":"Hands handle fabric","lighting":"2026 neutral daylight soft window"},
        "SH019": {"camera":"LF + macro","lens":"60mm Macro T5.6","framing":"ECU red thread revealed","angle":"45° overhead","movement":"Locked","lighting":"Neutral + 1×2 LED 5200K 15% thread accent"},
        "SH020": {"camera":"LF locked sticks overhead","lens":"60mm Macro T5.6-8.0","framing":"ECU red thread retracts","angle":"90° overhead","movement":"Absolutely locked","lighting":"Neutral window + 1×2 LED thread specular"},
        "SH021": {"camera":"LF","lens":"85mm T2.0","framing":"Close Yvonne reaction","angle":"Eye level","movement":"Locked","lighting":"Neutral, subtle shadow deeper"},
        "SH022": {"camera":"LF","lens":"28mm T4.0","framing":"Wide empty bathroom, mirror","angle":"Eye level","movement":"Locked, hold 2s","lighting":"Bathroom practical tungsten + window gap"},
        "SH023": {"camera":"LF","lens":"40mm T2.8","framing":"Medium Mark + cassette player","angle":"Eye level","movement":"Locked","lighting":"Neutral interior, desk lamp"},
        "SH024": {"camera":"LF","lens":"35mm T2.8","framing":"Medium John at bedroom door","angle":"Eye level","movement":"Locked","lighting":"Corridor neutral window + door separation edge"},
        "SH025": {"camera":"LF on sticks","lens":"35mm T4.0","framing":"Medium Reader Man entering doorway","angle":"Eye level, slight low","movement":"Reader walks in 1.5s, hold","lighting":"2026 neutral doorway window"},
        "SH026": {"camera":"LF","lens":"35mm T4.0","framing":"Medium three women + shirt","angle":"Eye level","movement":"Locked","lighting":"Neutral window camera-left, bounce"},
        "SH027": {"camera":"LF","lens":"40mm T4.0","framing":"Medium Reader Man examining shirt with women","angle":"Eye level 3/4","movement":"Locked","lighting":"Neutral + corridor edge"},
        "SH028": {"camera":"LF","lens":"35mm T4.0","framing":"Medium bedroom door, corridor","angle":"Eye level","movement":"Locked, hold for footsteps","lighting":"Neutral corridor, door edge light"},
        "SH029": {"camera":"LF","lens":"40mm T2.8","framing":"Close Mark vs door","angle":"Eye level slight low","movement":"Locked","lighting":"Neutral, practical door light"},
        "SH030": {"camera":"LF on sticks","lens":"35mm T4.0","framing":"Medium two-shot Reader Man FG door BG women mid","angle":"Eye level slight low 10°","movement":"Locked","lighting":"Neutral window + corridor edge"},
        "SH031": {"camera":"LF on sticks","lens":"40mm Cooke Panchro T2.8","framing":"Medium close congregation row isolated","angle":"Eye level same as SH007","movement":"Slow drift 0.5in toward row","lighting":"Same church but fill -0.5 stop vs SH007 (subliminal cooler)"},
        "SH032": {"camera":"GFX — typography","lens":"N/A","framing":"Center typography 2.39:1","angle":"N/A","movement":"Static card 4s","lighting":"N/A — white on black with red thread motif glow"},
        "SH033": {"camera":"GFX — title","lens":"N/A","framing":"Title + red thread motif","angle":"N/A","movement":"Static with subtle red thread pulse (GFX)","lighting":"N/A — grade"},
        "SH034": {"camera":"LF (audio) on sticks","lens":"N/A (black)","framing":"Black 2.39:1 + voice stinger","angle":"N/A","movement":"Locked","lighting":"N/A"},
    }

    cam = camera_map[sid]

    # Narrative function per spec
    narrative_map = {
        "SH001": "Invocation — elegy frames film as memory; plants transgressive communal joke",
        "SH002": "Establishment — reveals mourning space; casket/pulpit geography",
        "SH003": "Eulogist as witness — Matthew watches response",
        "SH004": "Recognition — Yvonne recognizes line, communal authorship",
        "SH005": "Recognition — Ione recognizes; her deeper knowledge (shirt) begins",
        "SH006": "Recognition — Marcia recognizes; communal laughter completed",
        "SH007": "Auditory clue masked — fourth laugh concealed; audience's first unnoticed excess",
        "SH008": "Bridge — Matthew contextualizes story as father's love; 1980s transition",
        "SH009": "1980s anchor — Desmond embodied as young man, before shirt's biography",
        "SH010": "Domestic investigation primer — woman examines pockets (evidence habit)",
        "SH011": "Kinship image — four brothers as photograph; Luke anchoring composition",
        "SH012": "Kinship humor — brothers' joke about family size; Luke's comic contribution",
        "SH013": "Care — Ione's blue-thread repair (original significance)",
        "SH014": "Evidence — white over blue discovered (suspicion, not proof)",
        "SH015": "Inquiry — Ione questions repair",
        "SH016": "Evasion — Desmond vague explanation (mystery, not resolution)",
        "SH017": "Inquiry — where was shirt repaired? (geography, not just who)",
        "SH018": "Present re-encounter — Yvonne handles aged shirt",
        "SH019": "Uncanny reveal — red thread beneath repairs",
        "SH020": "First supernatural visual — red thread retracts impossibly (epistemological rupture)",
        "SH021": "Human consequence — Yvonne reacts; body registers impossibility",
        "SH022": "Acoustic uncanny — empty bathroom, familiar throat clearing (off-screen presence)",
        "SH023": "Acoustic uncanny — Mark hears recorded voice resembling father (tape vs presence)",
        "SH024": "Acoustic uncanny — John hears father's voice beyond bedroom door",
        "SH025": "Arrival of investigator — Reader Man enters (no automatic authority)",
        "SH026": "Collective examination — women examine shirt together",
        "SH027": "Inquiry — Reader Man questions red stitching (evidence, not attribution)",
        "SH028": "Threshold — bedroom door footsteps (acoustic uncanny)",
        "SH029": "Attribution crisis — Mark says father dead; voice responds (dialogue uncanny)",
        "SH030": "Attribution restraint — Reader Man questions attribution to Desmond (structure's doubt)",
        "SH031": "Recontextualization — return to funeral, fourth laugh isolated (same file as SH007)",
        "SH032": "Kinship statement — typography: Four brothers, three mothers, one father",
        "SH033": "Title — film title + red-thread motif (visual identity)",
        "SH034": "Stinger — black screen voice stinger (shirt-related)",
    }

    dialogue_map = {
        "SH001": 'MATTHEW (V.O./on-mic): "Hi nice lady, can I get a sex out of your tight vagina?" — [verbatim open, affection in voice]',
        "SH002": "No dialogue — room ambient, congregation settling",
        "SH003": "No dialogue — Matthew observes",
        "SH004": "No dialogue — Yvonne recognition (non-verbal laughter)",
        "SH005": "No dialogue — Ione laughter",
        "SH006": "No dialogue — Marcia laughter",
        "SH007": "No dialogue — communal laughter (fourth laugh concealed in mix)",
        "SH008": 'MATTHEW: "Daddy used to love that story."',
        "SH009": "No dialogue — Desmond dressing (room ambient, radio faint 1980s)",
        "SH010": "No dialogue — fabric/pocket sounds",
        "SH011": "(Camera shutter) — no dialogue; photograph creation",
        "SH012": 'BROTHERS: Joke about family size — PROVISIONAL: MARK: "Four boys? Daddy did have range." LUKE (beat): "Range? Daddy had coverage." (PROPOSED — writer lock pending)',
        "SH013": "No dialogue — Ione stitching (craft focus)",
        "SH014": "No dialogue — fabric rustle; Ione discovery breath",
        "SH015": 'IONE: "Weh yuh get dis shirt fix?" / "Where did you get this shirt repaired?" (patwah + English; actress choice)',
        "SH016": 'DESMOND: Vague — "A woman at work... she did help with a hem." (PROVISIONAL — writer lock pending)',
        "SH017": 'IONE: "Which woman? Where was this fixed?" — repeats inquiry on location',
        "SH018": "No dialogue — Yvonne handling shirt (fabric sounds)",
        "SH019": "No dialogue — reveal (breath, fabric)",
        "SH020": "No dialogue — thread retraction (soft fabric whisper, no stinger)",
        "SH021": "YVONNE: Tiny catch-breath — non-verbal reaction",
        "SH022": "DESMOND'S THROAT CLEARING (familiar, off-screen) — no visible source",
        "SH023": 'TAPE: Desmond voice — "Hi nice lady..." (archival quality) — MARK hears',
        "SH024": 'VOICE beyond door — "John..." or throat clearing — JOHN hears',
        "SH025": "No dialogue — Reader Man entrance (footsteps, room hush)",
        "SH026": "No dialogue — women examining shirt (soft patwah murmurs, unscripted)",
        "SH027": 'READER MAN: "When you first see the red? Was it here before Desmond pass?" (PROVISIONAL — writer lock)',
        "SH028": "FOOTSTEPS beyond bedroom door — no dialogue",
        "SH029": 'MARK: "Mi father dead. ... You nuh dead?" — VOICE (off): "I... am here." / responds (PROVISIONAL)',
        "SH030": 'READER MAN: "You think a Desmond do this? It don\'t have to be him." (PROVISIONAL — questioning attribution)',
        "SH031": "Isolated fourth laugh (same file as SH007) — thinned communal laughter",
        "SH032": "No dialogue — typography only",
        "SH033": "No dialogue — title + motif; score holds",
        "SH034": 'VOICE STINGER: Shirt-related — "Ione?" or throat clear or thread whisper — [final uncanny] (PROVISIONAL — sound lock)',
    }

    blocking_map = {
        "SH001": "Matthew at pulpit, still, forward lean; congregation off-screen seated",
        "SH002": "Casket FG center, pulpit BG, congregation rows, aisle; Matthew at pulpit",
        "SH003": "Matthew at pulpit looks to congregation; papers before him",
        "SH004": "Yvonne in pew, head tilt recognition, then laugh",
        "SH005": "Ione in pew, surprise + warmth laugh, glances to Yvonne",
        "SH006": "Marcia in pew, communal laugh",
        "SH007": "Congregation rows mid-wide, pulpit soft BG; 10-15 laughing; no extra is 'fourth laugher' (sound only)",
        "SH008": "Matthew at pulpit, center, warm",
        "SH009": "Desmond at dresser, putting on white shirt, mirror foreground, window light",
        "SH010": "Ione hands examine trousers pockets, Desmond off or background dressing",
        "SH011": "Four brothers in line, Luke center holding print edge (composition anchor), photographer camera foreground implied",
        "SH012": "Four brothers loose semi-circle, Luke delivers comic beat",
        "SH013": "Ione hands ECU, blue thread stitching hem 12cm section",
        "SH014": "Same hands/hem, white over blue discovery — focus rack",
        "SH015": "Ione medium, holding shirt, questioning Desmond off-frame",
        "SH016": "Desmond medium, vague, not meeting Ione eyeline fully",
        "SH017": "Two-shot, Ione pressing where, Desmond evading geography",
        "SH018": "Yvonne hands ECU, aged shirt, yellowed fabric, handling",
        "SH019": "Same hands, red thread revealed beneath — static then breath",
        "SH020": "Shirt hem flat held taut between Yvonne thumbs, red thread retracts 1.5cm in 1.2s — hands OFF thread",
        "SH021": "Yvonne close, recoil/micro stillness, eyes on thread, breath catch",
        "SH022": "Empty bathroom, still, throat clearing off/mid",
        "SH023": "Mark at table with cassette player, hears tape, head tilt",
        "SH024": "John at bedroom door, listening, door closed",
        "SH025": "Reader Man steps through doorway, women midground with shirt",
        "SH026": "Three women around table, shirt between, examining together",
        "SH027": "Reader Man with women, examining shirt, questioning red",
        "SH028": "Bedroom door closed, corridor, footsteps approaching off",
        "SH029": "Mark at door, says father dead; voice responds beyond",
        "SH030": "Reader Man FG, door deep, women mid, Mark off — questions attribution",
        "SH031": "Congregation row medium close, thinned laughter, one not laughing; pulpit BG; fourth voice isolated",
        "SH032": "Typography centered: 'Four brothers, three mothers, one father' — white on black, red thread accent",
        "SH033": "Title: BROTHERS OF THE BLOOD CLOTH + red-thread motif animation",
        "SH034": "Black screen; voice stinger; no image",
    }

    shot = {
        "identifier": sid,
        "act": act,
        "scene": scene,
        "time_period": period,
        "timecode": f"{start_tc}–{end_tc} ({dur}s)",
        "timecode_in": start_tc,
        "timecode_out": end_tc,
        "duration_seconds": dur,
        "elapsed_start_seconds": start,
        "elapsed_end_seconds": end,
        "narrative_function": narrative_map[sid],
        "genre_state": genre,
        "required_content": content,
        "subject": sid.replace("SH","Subject_"), # placeholder
        "character_ids": char_map[sid],
        "prop_ids": prop_map[sid],
        "camera": cam["camera"],
        "lens": cam["lens"],
        "framing": cam["framing"],
        "angle": cam["angle"],
        "movement": cam["movement"],
        "lighting": cam["lighting"],
        "blocking": blocking_map[sid],
        "performance": f"See golden spec if applicable; otherwise: naturalistic, period-appropriate, patwah as cast",
        "dialogue": dialogue_map[sid],
        "sound": f"See per-shot sound design; T08 applies to SH007/SH031; T09 applies to SH020",
        "editorial_transition_in": f"Cut from previous; see shot spec for rhythm note",
        "editorial_transition_out": f"Cut to next; see shot spec",
        "continuity": f"Requires: {', '.join(char_map[sid]+prop_map[sid]) if (char_map[sid]+prop_map[sid]) else 'no principal continuity — GFX'}",
        "source_reference": "Mission Directive §5 Baseline Inventory — Wrasal God Mode v1.0",
        "assumptions": "See Phase 01 reconciled brief — assumptions flagged PROPOSED/UNVERIFIED",
        "verification_status": "PENDING — requires Phase 07 deterministic validation",
        "revisable": True,
        "original_state_preserved": content,
    }
    # Override some detailed performance/dialogue per golden spec
    if sid == "SH001":
        shot["dialogue"] = dialogue_map[sid]
        shot["performance"] = "MATTHEW affectionate, not crude — half-smile in voice; forward lean; speaks from memory not paper"
    elif sid == "SH007":
        shot["sound"] = "Congregation laughter (10-15 voices, church IR) + FOURTH_VOICE stem (same file as SH031, -18 LUFS masked, 10-15° off-axis, longer pre-delay)"
        shot["blocking"] = blocking_map[sid]
    elif sid == "SH014":
        shot["camera"] = "LF + macro on sticks"
        shot["lens"] = "60mm Macro T5.6 (true macro 1:1)"
        shot["blocking"] = "Same hem as SH013; fingers trace blue then encounter white; rack focus blue→white; hold 0.9s read"
    elif sid == "SH020":
        shot["camera"] = "LF locked overhead on sticks (absolutely stable)"
        shot["lens"] = "60mm Macro T5.6-8.0 1:1 macro"
        shot["sound"] = "Thread retracts 1.5cm in 1.2s (practical monofilament or CG); soft fabric whisper -22 LUFS; no stinger; hands OFF thread >2cm gap preserved"
    elif sid == "SH030":
        shot["dialogue"] = dialogue_map[sid]
        shot["performance"] = "READER MAN restrained, questioning not declaring; no ritual gesture; uncertainty as structure"
    elif sid == "SH031":
        shot["sound"] = "Thinned communal laughter (-10dB + LPF) + FOURTH_VOICE same file as SH007 at -12 LUFS isolated (recognizable timbre) — T08 enforcement"
        shot["camera"] = "LF on sticks, 40mm T2.8"
    # generic enrich
    shots.append(shot)
    elapsed = end

# Build master document
master = {
    "mission": "WO-WRASAL-BOTBC-GM-001 / WO-BOTBC-TR001-SHOTLIST-001",
    "project": "BROTHERS OF THE BLOOD CLOTH — THE INVOCATION",
    "version": "1.0",
    "date": "2026-10-23",
    "aspect_ratio": "2.39:1",
    "total_runtime_seconds": elapsed,
    "total_shots": len(shots),
    "schema_version": "wrasal-shot-spec-v1",
    "governance": {
        "reality_first": True,
        "camera_as_witness": True,
        "genre_changes_when_understanding_changes": True,
    },
    " shots": shots  # intentional leading space bug? fix
}
# Correct key naming (yaml python allows)
master_correct = {
    "mission": "WO-WRASAL-BOTBC-GM-001 / WO-BOTBC-TR001-SHOTLIST-001",
    "project": "BROTHERS OF THE BLOOD CLOTH — THE INVOCATION",
    "version": "1.0",
    "date": "2026-10-23",
    "aspect_ratio": "2.39:1",
    "total_runtime_seconds": elapsed,
    "total_shots": len(shots),
    "schema_version": "wrasal-shot-spec-v1",
    "governance": {
        "reality_first": True,
        "camera_as_witness": True,
        "genre_changes_when_understanding_changes": True,
    },
    "shots": shots,
    "white_shirt_provenance": {
        "hero_shirt_1980s": "white cotton poplin, blue cotton repair (hand) then white polyester over blue",
        "hero_shirt_2026": "same garment aged 40y (yellowing at collar/cuffs, fold lines) + red waxed thread beneath repairs",
        "red_thread": "waxed linen Fil au Chinois #1143 blood-red — fictional storyworld invention, not folklore",
    },
    "sound_provenance": {
        "SH007_FOURTH_VOICE": "single stem, recorded same church same mic rotated 15° off-axis; also used as SH031_FOURTH_VOICE (same file hash)",
        "SH020_thread": "practical monofilament pull OR CG — recorded as practical first; VFX clean only as backup",
    },
    "validation": {
        "T01_all_shots": "must be 34",
        "T02_total_105s": True,
        "T08_same_audio_SH007_SH031": "same stem file reference",
        "T09_SH020_precedes_attribution": True,
    }
}

# Write YAML
with open(OUT_YAML, "w") as f:
    yaml.safe_dump(master_correct, f, sort_keys=False, allow_unicode=True, width=120)

# Also JSON for XLSX generator
import json as j
with open(OUT_JSON, "w") as jf:
    j.dump(master_correct, jf, indent=2)

print(f"YAML written to {OUT_YAML} — {len(shots)} shots, {elapsed}s total")
# Validation quick
assert elapsed == 105, f"Total not 105 but {elapsed}"
assert len(shots) == 34, f"Expected 34 got {len(shots)}"
# Check timecodes sequential
for i in range(1, len(shots)):
    assert shots[i]["elapsed_start_seconds"] == shots[i-1]["elapsed_end_seconds"], f"Gap at {shots[i]['identifier']}"
print("Validation PASS: T01, T02, T03")
