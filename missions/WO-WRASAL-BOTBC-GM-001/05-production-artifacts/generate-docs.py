#!/usr/bin/env python3
"""Generate WRASAL DOCX/PPTX artifacts via python-docx / python-pptx."""
from pathlib import Path
from docx import Document
from docx.shared import Pt, Inches, RGBColor, Emu
from docx.enum.text import WD_ALIGN_PARAGRAPH, WD_LINE_SPACING
from docx.enum.section import WD_ORIENTATION
from docx.enum.table import WD_TABLE_ALIGNMENT, WD_ALIGN_VERTICAL
from docx.oxml.ns import qn, nsdecls
from docx.oxml import parse_xml
from docx.dml.color import ColorFormat
from pptx import Presentation
from pptx.util import Inches as PPTInches, Pt as PPTPt
from pptx.dml.color import RGBColor as PPTRGB
from pptx.enum.text import PP_ALIGN, MSO_ANCHOR
from pptx.enum.shapes import MSO_SHAPE
import yaml

ROOT = Path(__file__).parent
OUT_DIR = ROOT
TEMPLATE_DIR = ROOT.parent / "06-templates"
TEMPLATE_DIR.mkdir(parents=True, exist_ok=True)

# Shared branding
WRASAL_RED = RGBColor(0xC0, 0x39, 0x2B)
WRASAL_DARK = RGBColor(0x1A, 0x1A, 0x2E)
WRASAL_GRAY = RGBColor(0x95, 0xA5, 0xA6)
WRASAL_GOLD = RGBColor(0xF3, 0x9C, 0x12)
WRASAL_CREAM = RGBColor(0xFF, 0xF8, 0xE1)

def set_cell_bg(cell, hex_color):
    shading = parse_xml(f'<w:shd {nsdecls("w")} w:fill="{hex_color}"/>')
    cell._tc.get_or_add_tcPr().append(shading)

def set_cell_text(cell, text, size=8, bold=False, color=WRASAL_DARK, italic=False, align=WD_ALIGN_PARAGRAPH.LEFT):
    p = cell.paragraphs[0] if cell.paragraphs else cell.add_paragraph()
    p.alignment = align
    p.clear()
    run = p.add_run(text)
    run.font.size = Pt(size)
    run.font.bold = bold
    run.font.color.rgb = color
    run.font.italic = italic
    run.font.name = "Calibri"
    p.paragraph_format.space_after = Pt(2)
    return p

def add_heading(doc, text, level=1, color=WRASAL_DARK, size=None, align=WD_ALIGN_PARAGRAPH.LEFT):
    h = doc.add_heading(level=level)
    h.alignment = align
    run = h.add_run(text)
    run.font.color.rgb = color
    run.font.name = "Calibri"
    run.font.bold = True
    if size:
        run.font.size = Pt(size)
    if level==1:
        run.font.size = Pt(16) if not size else Pt(size)
    # Add bottom border via paragraph
    pPr = h._p.get_or_add_pPr()
    pBdr = parse_xml(f'<w:pBdr {nsdecls("w")}><w:bottom w:val="single" w:sz="6" w:space="4" w:color="C0392B"/></w:pBdr>')
    pPr.append(pBdr)
    return h

def add_para(doc, text, size=9, bold=False, italic=False, color=WRASAL_DARK, align=WD_ALIGN_PARAGRAPH.LEFT, bullet=False):
    p = doc.add_paragraph(style='List Bullet' if bullet else 'Normal')
    p.alignment = align
    run = p.add_run(text)
    run.font.size = Pt(size)
    run.font.bold = bold
    run.font.italic = italic
    run.font.color.rgb = color
    run.font.name = "Calibri"
    p.paragraph_format.space_after = Pt(4)
    p.paragraph_format.line_spacing = 1.15
    return p

# -------------------------------------------------
# 1. CINEMATIC WORK ORDER (DOCX)
# -------------------------------------------------
def generate_work_order():
    doc = Document()
    section = doc.sections[0]
    section.top_margin = Inches(0.6)
    section.bottom_margin = Inches(0.6)
    section.left_margin = Inches(0.65)
    section.right_margin = Inches(0.65)

    # Title
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    run = p.add_run("WRASAL CINEMATIC WORK ORDER")
    run.font.size = Pt(20)
    run.font.bold = True
    run.font.color.rgb = WRASAL_DARK
    run.font.name = "Calibri"
    p.paragraph_format.space_after = Pt(2)

    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    run = p.add_run("Human Sovereignty  •  Agentic Execution  •  Evidence-Based Verification")
    run.font.size = Pt(7)
    run.font.italic = True
    run.font.color.rgb = WRASAL_GRAY
    run.font.name = "Calibri"

    # WO header table
    add_para(doc, "")
    table = doc.add_table(rows=0, cols=2)
    table.style = "Light Shading"
    table.alignment = WD_TABLE_ALIGNMENT.CENTER
    def add_row(k,v, bold_k=True, color_k=WRASAL_DARK, color_v=WRASAL_DARK):
        row = table.add_row()
        c1 = row.cells[0]; c2 = row.cells[1]
        set_cell_bg(c1, "1A1A2E")
        set_cell_bg(c2, "FFFEFE")
        set_cell_text(c1, k, size=7, bold=True, color=RGBColor(0xFF,0xFF,0xFF))
        # handle wrapping for long values
        p2 = c2.paragraphs[0]
        p2.clear()
        run = p2.add_run(v)
        run.font.size = Pt(7)
        run.font.color.rgb = color_v
        run.font.name = "Calibri"
        run.font.bold = False

    add_row("WORK ORDER ID", "WO-BOTBC-TR001-SHOTLIST-001  (Authority: WO-WRASAL-BOTBC-GM-001)")
    add_row("PROJECT", "BROTHERS OF THE BLOOD CLOTH — TRAILER 001: THE INVOCATION")
    add_row("MISSION CLASS", "Autonomous Cinematic Development Engineering")
    add_row("VERSION / DATE", "1.0  •  2026-10-23")
    add_row("STATUS", "DRAFT — AWAITING HUMAN MISSION AUTHORIZATION  →  PROPOSED — Pending Acceptance")
    add_row("BRANCH / COMMIT", "arena/245d64b8-wrasal-control  •  af529b54e14974eec42e1f4dd200f06c61175f15")
    add_row("TARGET EVIDENCE", "Complete production-planning package (34 ShotSpecs, 105s validated, 6 golden shots, reusable templates)")
    add_row("HUMAN APPROVAL", "Reserved — No canonical promotion without explicit human approval")

    doc.add_paragraph()  # spacer
    add_heading(doc, "1. Objective", level=2, color=WRASAL_RED, size=11)
    add_para(doc, "Transform the existing 105-second trailer concept into a coherent, technically specified, reusable, independently validated production-planning system, ready for human acceptance.")
    add_para(doc, "Deliverables: Master cinematic shot list (34 shots), machine-readable shot specifications, cinematic work-order, camera/lens/lighting/blocking matrices, character + garment continuity architecture, sound & editorial cue sheet, storyboard planning package, five reusable template reference artifacts, and independently verified acceptance report.", size=8, color=WRASAL_DARK)

    add_heading(doc, "2. Scope & Required Outputs (A–J)", level=2, color=WRASAL_RED, size=11)
    outputs = [
        "A. Master cinematic shot list — all 34 shots reconciled to 105s (validated programmatically).",
        "B. Machine-readable shot specifications — YAML with 21 required ShotSpec fields per shot (see §4).",
        "C. Cinematic work-order documentation — this document.",
        "D. Camera, lens, lighting, and blocking matrices — independent technical specs for DP, Gaffer, AD.",
        "E. Character identity & continuity architecture — six independent dimensions per character; no collapse into single drift score.",
        "F. White-shirt material continuity specification — state graph from original garment → blue → white over blue → aged → red → retract (FICTIONAL invention, not folklore).",
        "G. Sound design & editorial cue sheet — 105s timeline, 5.1 stems, fourth-voice stem shared SH007→SH031 (T08), SH020 first supernatural visual (T09).",
        "H. Storyboard planning package — frame requirements per shot, placeholder specifications where imagery pending.",
        "I. Evidence, provenance & uncertainty registers — source authority, assumption status (USER-DIRECTED / PROPOSED / UNVERIFIED / CONTRADICTED / BLOCKED).",
        "J. Independently verified acceptance report — 18 tests (T01–T18) with evidence.",
    ]
    for o in outputs:
        add_para(doc, o, size=8, bullet=True)

    add_heading(doc, "3. Authority & Permission Contract", level=2, color=WRASAL_RED, size=11)
    add_para(doc, "AUTONOMOUS (within this mission, subject to platform permission prompts):", size=8, bold=True)
    autos = [
        "Read/inspect relevant repositories and existing specifications.",
        "Inspect accessible project records in connected systems (Notion/Linear/Drive — none discovered).",
        "Create/modify mission-scoped draft files under missions/WO-WRASAL-BOTBC-GM-001/.",
        "Implement validation scripts + tests; generate production-planning documents; run local inspections.",
        "Create reproducible reference artifacts; correct defects within approved scope.",
        "Commit/push dedicated branch arena/245d64b8-wrasal-control; open draft PR when authorized.",
    ]
    for a in autos:
        add_para(doc, a, size=7, bullet=True)
    add_para(doc, "PROHIBITED without additional explicit authorization (constitutional):", size=8, bold=True)
    prohibs = [
        "Merging PRs; deploying/production publishing; making repo/doc public.",
        "Promoting draft creative to canonical authority; changing governance rules.",
        "Deleting historical evidence; disclosing private family biography; modifying unrelated projects.",
        "Purchasing services/incurring unapproved costs; generating likenesses of real individuals without authorization.",
    ]
    for p_ in prohibs:
        add_para(doc, p_, size=7, bullet=True)

    # States distinction
    p = doc.add_paragraph()
    run = p.add_run("State vocabulary:  EXECUTED → VERIFIED → REVIEWED → HUMAN APPROVED → CANONIZED → RELEASED  (not interchangeable)")
    run.font.size = Pt(7)
    run.font.italic = True
    run.font.color.rgb = WRASAL_RED
    run.font.name = "Calibri"
    run.font.bold = True

    add_heading(doc, "4. Baseline Shot Inventory Preservation", level=2, color=WRASAL_RED, size=11)
    add_para(doc, "All 34 shot identifiers (SH001–SH034) preserved from Mission Directive §5. Original durations total 105s (validated). Revisions permitted only with rationale + original state preserved — no silent overwrite.", size=8)

    add_heading(doc, "5. Acceptance Criteria (Measurable)", level=2, color=WRASAL_RED, size=11)
    criteria = [
        "All 34 shots accounted for (T01) — validator passes.",
        "Total timeline = 105s (T02) — programmatic sum.",
        "No timecode gaps/overlaps (T03).",
        "Required ShotSpec fields present (T04) — 21 fields per shot.",
        "Referenced characters/props resolve (T05).",
        "White-shirt material progression coherent (T06) — no red before SH019, only SH020 movement.",
        "Genre-state progression preserves audience experience (T07).",
        "SH007 and SH031 reference same intended audio source — same file hash (T08).",
        "SH020 precedes explicit supernatural attribution (T09).",
        "Cultural claims distinguished from fiction (T10).",
        "No real-family biography promoted to canon (T11).",
        "Identity/biological/ etc. dimensions independently evaluated (T12).",
        "Workbooks/documents open and contain expected structure (T13).",
        "Template references contain reusable fields (T14).",
        "No unauthorized remote modification/publication (T15).",
        "Critical unresolved issues reported (T16).",
        "Implementation claims reference actual evidence (T17).",
        "Human approval remains pending (T18).",
    ]
    for c in criteria:
        add_para(doc, c, size=7, bullet=True)

    add_heading(doc, "6. Execution Record & Evidence Pointers", level=2, color=WRASAL_RED, size=11)
    table2 = doc.add_table(rows=1, cols=2)
    table2.style = "Light Grid"
    hdrs = table2.rows[0].cells
    for i, h in enumerate(["Evidence Type", "Location"]):
        set_cell_text(hdrs[i], h, size=8, bold=True, color=RGBColor(0xFF,0xFF,0xFF))
        set_cell_bg(hdrs[i], "1A1A2E")
    rows = [
        ("Reconnaissance Report", "00-reconnaissance/reconnaissance-report.md"),
        ("Source Authority Register", "01-reconciliation/source-authority-register.md"),
        ("Reconciled Creative Brief", "01-reconciliation/reconciled-creative-brief.md"),
        ("Six Golden ShotSpecs", "02-golden-shots/SH001, SH007, SH014, SH020, SH030, SH031"),
        ("Master Shot List (machine-readable)", "03-full-shotlist/master-shot-list.yaml"),
        ("Master Shot List (workbook)", "03-full-shotlist/WRASAL-Cinematic-Master-Shot-List.xlsx"),
        ("Continuity: Characters", "04-continuity/character-continuity-matrix.md"),
        ("Continuity: White Shirt Graph", "04-continuity/white-shirt-material-graph.md"),
        ("Continuity: Env/Temporal/Camera", "04-continuity/environment-temporal-register.md"),
        ("Camera & Coverage", "05-production-artifacts/camera-coverage-spec.md"),
        ("Lighting Matrix", "05-production-artifacts/lighting-matrix.md"),
        ("Blocking Matrix", "05-production-artifacts/blocking-matrix.md"),
        ("Prop Matrix", "05-production-artifacts/prop-continuity-matrix.md"),
        ("Editorial & Sound Cue Sheet", "05-production-artifacts/editorial-sound-cue-sheet.md"),
        ("Storyboard Package", "05-production-artifacts/WRASAL-Cinematic-Storyboard.pptx"),
        ("Visual DNA", "06-templates/WRASAL-Visual-DNA-and-Continuity-Sheet.docx"),
        ("Cinematic Treatment", "06-templates/WRASAL-Cinematic-Treatment.docx"),
        ("Validation Tests", "07-verification/ + validate-shotlist.mjs"),
        ("Final Mission Report", "FINAL-MISSION-REPORT.md (mission root)"),
    ]
    for k,v in rows:
        r = table2.add_row().cells
        set_cell_text(r[0], k, size=7)
        set_cell_text(r[1], v, size=7, color=RGBColor(0x1A,0x52,0x76))

    add_heading(doc, "7. Risk & Human Decisions", level=2, color=WRASAL_RED, size=11)
    add_para(doc, "CRITICAL DEFECTS: None blocking acceptance (see Final Mission Report §E).  CULTURAL REVIEW REQUIRED: 1980s prop period check, Reader Man representation, opening-line framing — tag for Jamaican cultural consultant.", size=8, bold=True, color=WRASAL_RED)
    add_para(doc, "HUMAN DECISION GATE: ☐ ACCEPT PRODUCTION-PLANNING PACKAGE   ☐ RETURN FOR REVISION   ☐ REJECT  — Canonical acceptance/publication remain distinct decisions if later requested.", size=9, bold=True, color=WRASAL_DARK)

    # Footer
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    run = p.add_run("WRASAL Media  •  Real Brothers. Woven Fates.  •  This work order does not promote draft creative to canon. Human creative sovereignty is absolute.")
    run.font.size = Pt(6)
    run.font.italic = True
    run.font.color.rgb = WRASAL_GRAY
    run.font.name = "Calibri"

    doc.core_properties.title = "WRASAL Cinematic Work Order — The Invocation"
    doc.core_properties.subject = "BOTBC Trailer 001"
    doc.core_properties.author = "WRASAL Executive Creative Production System"
    path = OUT_DIR / "WRASAL-Cinematic-Work-Order-BOTBC-TR001.docx"
    path2 = TEMPLATE_DIR / "WRASAL-Cinematic-Work-Order.docx"
    doc.save(path)
    doc.save(path2)
    print(f"Work Order saved: {path} + {path2}")

def generate_visual_dna():
    doc = Document()
    section = doc.sections[0]
    section.top_margin = Inches(0.6); section.bottom_margin = Inches(0.6)
    section.left_margin = Inches(0.75); section.right_margin = Inches(0.75)

    # Title
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    run = p.add_run("WRASAL VISUAL DNA & CONTINUITY SHEET")
    run.font.size = Pt(18); run.font.bold = True; run.font.color.rgb = WRASAL_DARK; run.font.name="Calibri"
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    run = p.add_run("Brothers of the Blood Cloth  •  The Invocation  •  Reusable Continuity Infrastructure")
    run.font.size = Pt(9); run.font.italic = True; run.font.color.rgb=WRASAL_GRAY; run.font.name="Calibri"

    # What is Visual DNA?
    add_heading(doc, "1. What This Document Is", level=2, color=WRASAL_RED, size=11)
    add_para(doc, "This Visual DNA Sheet is the project's *visual memory*. It records, in one place, the look decisions that must remain coherent across units, days, and periods (1980s vs 2026), and across future WRASAL films that reuse this infrastructure. It is *not* a mood board and *not* an approval of any performer's likeness — it is a control document.", size=8)
    add_para(doc, "REUSABLE STRUCTURE vs BOTBC EXAMPLE:  Sections marked [TEMPLATE] are reusable for any WRASAL film — keep headings, prompts, and QC fields. Sections marked [EXAMPLE: BOTBC] contain this film's values — replace with your film's choices. The separation is enforced by this document's legend (next page).", size=7, italic=True, color=WRASAL_RED)

    # Legend
    add_heading(doc, "Legend — Reusable vs Example", level=2, color=WRASAL_DARK, size=10)
    table = doc.add_table(rows=1, cols=2)
    table.style = "Light Shading"
    table.alignment = WD_TABLE_ALIGNMENT.CENTER
    hdr = table.rows[0].cells
    set_cell_text(hdr[0], "REUSABLE TEMPLATE FIELD", size=8, bold=True, color=RGBColor(0xFF,0xFF,0xFF)); set_cell_bg(hdr[0], "1A1A2E")
    set_cell_text(hdr[1], "WHAT TO REPLACE PER FILM", size=8, bold=True, color=RGBColor(0xFF,0xFF,0xFF)); set_cell_bg(hdr[1], "1A1A2E")
    pairs = [
        ("Aspect ratio box (2.39:1 prompt + safe area note)", "BOTBC uses 2.39:1 scope; your film may differ — update frame diagram + safe action %"),
        ("Color palette swatches (6 slots + LAB/HEX + usage prompt)", "BOTBC: warm funeral cream / 1980s yellow / 2026 neutral / red blood — replace with your palette"),
        ("Typography lockup (title + credit font stack)", "BOTBC title treatment; keep font-family prompt (e.g., serif/sans) but replace typeface choices"),
        ("Texture & material prompts (fabric, paper, skin, light)", "BOTBC hero shirt macro detail; replace with your film's key object material"),
        ("Character visual identity matrix (6 dims)", "BOTBC cast names (MATTHEW, IONE, YVONNE...) — replace; keep 6-dimension QC structure"),
        ("Continuity gate checklist (20 gates)", "BOTBC gates (white-shirt state, door geography) — keep structure; rewrite gates"),
        ("Shooting grammar notes (lens family, movement doctrine)", "BOTBC Cooke Panchro + witness doctrine — keep lens-family prompt; replace selections"),
    ]
    for k,v in pairs:
        r=table.add_row().cells
        set_cell_text(r[0], k, size=7)
        set_cell_text(r[1], v, size=7)

    # Color Palette (EXAMPLE: BOTBC)
    add_heading(doc, "2. Color & Light — [EXAMPLE: BOTBC]", level=2, color=WRASAL_RED, size=11)
    add_para(doc, "[TEMPLATE]: Provide 6 swatches (describe via LAB/HEX + usage). [EXAMPLE]: BOTBC's palette that realizes Tragicomedy → Gothic progression without horror clichés.", size=7, italic=True, color=WRASAL_GRAY)
    pal = doc.add_table(rows=1, cols=4)
    pal.style = "Light Grid"
    hdrs = pal.rows[0].cells
    for i,h in enumerate(["SWATCH / HEX","LAB / USAGE","GOVERNANCE"," QC GATE"]):
        set_cell_text(hdrs[i], h, size=7, bold=True, color=RGBColor(0xFF,0xFF,0xFF)); set_cell_bg(hdrs[i], "C0392B")
    swatches = [
        ("Funeral Warm — #FDEBD0  ■","LAB 94/5/15 — Fellowship hall warmth; SH001–008 church window","Reality First — actual church paint, not set paint","Gate L1: no church scene lit cooler than funeral"),
        ("1980s Domestic — #FEF9E7  ■","LAB 98/1/10 — Yellowing domestic whites; SH009–017","Must read warmer than 2026, not golden hour gimmick","Gate L2: 1980s warmer than 2026 by +4 LAB b shift"),
        ("2026 Neutral — #EBF5FB  ■","LAB 92/-2/-8 — Hushed house present; SH018–030","Neutral, not cold — still Jamaica, not Scandinavia","Gate L3: 2026 not desaturated >5%; no teal push"),
        ("Aged Shirt Cream — #E8DAA0  ■","LAB 88/0/18 — Yellowed fabric (hero C aged)","Prop-aged tea/UV, not grade fake","Gate M1: fabric delta E 8 from optic white"),
        ("Blood Red (Thread) — #C0392B  ■","LAB 42/48/22 — Waxed linen red — FICTIONAL invention","Must never be presented as folklore","Gate C1: no artifact claims folklore without fiction tag"),
        ("Attribution Shadow — #2C3E50  ■","LAB 27/0/-12 — Corridor door shadow holds","No green/purple horror gel","Gate L4: no unmotivated horror color in any interior"),
    ]
    for s_vals in swatches:
        r=pal.add_row().cells
        for i, val in enumerate(s_vals):
            set_cell_text(r[i], val, size=6.5)

    # Typography (EXAMPLE)
    add_heading(doc, "3. Typography & GFX Language — [EXAMPLE: BOTBC]", level=2, color=WRASAL_RED, size=11)
    add_para(doc, "Title Lockup: BROTHERS OF THE BLOOD CLOTH — Serif display (e.g., Canela or Freight Display) — stacked two-line — generous tracking — white on black. SH032 Typographic Statement: 'Four brothers, three mothers, one father' — same serif, smaller — white on black — red thread accent underline (waxed texture, not glow). GFX Principle: GFX is quiet — no kinetic type — authority through spacing.", size=8)
    add_para(doc, "[TEMPLATE]: Title / credit / subtitle font stacks + kerning + color usage + GFX motion prompts — keep structure; replace families per film.", size=7, italic=True, color=WRASAL_GRAY)

    # Material Detail — Shirt
    add_heading(doc, "4. Key Material — The White Shirt — [EXAMPLE: BOTBC]", level=2, color=WRASAL_RED, size=11)
    add_para(doc, "Hero Object: Desmond's white cotton poplin dress shirt — the film's only physical supernatural evidence. State graph: ORIGINAL (optic white) → BLUE cotton hand repair (Ione, irregular, matte) → WHITE polyester over blue (tighter, bright, smooth, +1mm offset) → AGED 40y (cream, yellowed collar/cuffs, fold lines, blue faded/white intact) → RED waxed linen beneath (blood, vivid, waxed) → RETRACT 1.5cm in 1.2s (SH020, only movement, absolutely locked camera). Texture Rule: Thread difference must read on 5\" phone at 2.39 crop (macro legibility gate). [TEMPLATE]: Replace with your film's key object — maintain stitch/geometry/aging/movement specification rigor.", size=8)

    # Character Visual Identity Matrix
    add_heading(doc, "5. Character Visual Identity Matrix — [TEMPLATE + EXAMPLE]", level=2, color=WRASAL_RED, size=11)
    add_para(doc, "[TEMPLATE]: Keep six independent dimensions below — score independently (do not collapse). [EXAMPLE: BOTBC]: Names listed; replace per film.", size=7, italic=True, color=WRASAL_GRAY)
    mat = doc.add_table(rows=1, cols=4)
    mat.style = "Light Grid"
    hdrs = mat.rows[0].cells
    for i,h in enumerate(["CHARACTER (EXAMPLE)","1980s LOOK","2026 LOOK","IDENTITY RISK + MITIGATION"]):
        set_cell_text(hdrs[i], h, size=7, bold=True, color=RGBColor(0xFF,0xFF,0xFF)); set_cell_bg(hdrs[i], "1A1A2E")
    chars = [
        ("MATTHEW — Brothers","(Child in photo SH011)","Funeral suit charcoal, white shirt modern, dark tie — early 40s","Low — single period primary; child must resemble adult"),
        ("MARK","Child photo","Smart-casual (shirt, no tie — contrast to Matthew's formality)","Medium — skeptic performance in SH029 must read in 3s"),
        ("LUKE — Enhanced","Child photo center anchor, holds print edge","Composed, warm — delivers comic beat SH012","PROPOSED enhancement — director approves SH012 weight (risk tokenism)"),
        ("JOHN","Child photo","Understated — listener at door SH024","Low"),
        ("IONE — Central","20s — domestic dress, period hair (consultant)","60s — funeral dress dark, greyed hair/covered — same hands","HIGH — 40y age jump; single actress + hair/makeup preferred (no heavy prosthetic)"),
        ("YVONNE — Handler","— (not in 1980s youth)","60s — elegant elder; hands key (SH018–021 same nails)","Low — single period; hand continuity"),
        ("MARCIA — Witness","—","60s — warm, following sisters","Low — provisional name"),
        ("DESMOND — Father","Late 20s–30s sharp 1980s suit + white shirt (hero)","Voice only 2026 (tape/SH023, beyond door); casket SH002","Medium — young actor timbre must connect to 2026 voice; do NOT link fiction infidelity to real biography"),
        ("READER MAN","—","50s–70s everyday elder — NO invented spiritual costume","HIGH cultural — no beads/charms invented; he questions, not knows"),
    ]
    for vals in chars:
        r=mat.add_row().cells
        for i,v in enumerate(vals):
            set_cell_text(r[i], v, size=6.5)

    # Add 6 dims footnote
    add_para(doc, "Six Dimensions (independent — never collapse): D1 Identity Fidelity · D2 Biological Realism · D3 Physical Plausibility · D4 Styling Control · D5 Cinematic Coherence · D6 Temporal Continuity. No dimension scored as PASS until imagery exists and evaluated (gray → green/red).", size=7, italic=True, color=WRASAL_GRAY)

    # Continuity Gates
    add_heading(doc, "6. Continuity Gates — [TEMPLATE + EXAMPLE]", level=2, color=WRASAL_RED, size=11)
    add_para(doc, "[TEMPLATE]: Keep gate table structure — 20 gates with check/evidence columns. [EXAMPLE: BOTBC gates below — adapt.]", size=7, italic=True, color=WRASAL_GRAY)
    gates = doc.add_table(rows=1, cols=3)
    gates.style = "Light Grid"
    hdrs = gates.rows[0].cells
    for i,h in enumerate(["GATE","CHECK","EVIDENCE LOCATION"]):
        set_cell_text(hdrs[i], h, size=7, bold=True, color=RGBColor(0xFF,0xFF,0xFF)); set_cell_bg(hdrs[i], "C0392B")
    gate_rows = [
        ("G01", "34 identifiers all present SH001–SH034","validator T01 — 03-full-shotlist/master-shot-list.yaml"),
        ("G02", "105s total (programmatic sum)","T02 — validator"),
        ("G03", "No timecode gaps/overlaps","T03"),
        ("G04", "White-shirt: no red before SH019; only SH020 movement","T06 — white-shirt graph"),
        ("G05", "SH007/SH031 same fourth-voice file (hash)","T08 — sound ledger + validator"),
        ("G06", "SH020 precedes attribution (Reader questions SH030 after)","T09"),
        ("G07", "IONE age jump plausible without heavy prosthetic","Character matrix D2 + test photos"),
        ("G08", "Door geography consistent SH024/SH028/SH029/SH030 (same prop)","Camera geography register + plan overlay"),
        ("G09", "1980s period accuracy (no anachronistic props)","Prop matrix anachronism review"),
        ("G10", "Red thread never presented as folklore (fiction-tagged)","T10 — text search in all docs"),
        ("G11", "No real-family biography promoted to canon","T11"),
        ("G12", "6 dims independent scoring — no collapse","T12 — character matrix"),
        ("G13", "Macro legibility at phone size (blue/white/red distinct)","Prop test photos on 5\" screen"),
        ("G14", "SH020 lock (no camera drift during thread move)","T07 — vector check"),
        ("G15", "Shooting grammar: witness stance, no whip-horror","Camera spec + storyboard review"),
        ("G16", "LORNA/INEZ rejected (validator name check)","T04/T05"),
        ("G17", "Luke meaningful contribution (SH011–012 weight)","Creative brief investigation G"),
        ("G18", "Reader Man no automatic authority (questions, not declares)","SH030 dialogue + performance note"),
        ("G19", "SH031 thinned laughter same extras as SH007 (continuity photos)","Blocking matrix + extra roster"),
        ("G20", "Genre progression Tragicomedy→Mystery→Gothic→Attribution Crisis preserved","T07"),
    ]
    for g in gate_rows:
        r=gates.add_row().cells
        for i,v in enumerate(g):
            set_cell_text(r[i], v, size=6.5)
            if i==0:
                r[i].paragraphs[0].runs[0].font.bold=True

    add_heading(doc, "7. How to Reuse This Template", level=2, color=WRASAL_DARK, size=10)
    add_para(doc, "1. Save a copy: Rename from 'WRASAL-Visual-DNA-and-Continuity-Sheet.docx' to '[YOUR FILM] Visual DNA'.", size=8, bullet=True)
    add_para(doc, "2. Replace all [EXAMPLE: BOTBC] sections — keep [TEMPLATE] headings, prompts, and gate structures.", size=8, bullet=True)
    add_para(doc, "3. Swap character/prop/location registers — adapt gate list (keep 18–20 gates for coverage).", size=8, bullet=True)
    add_para(doc, "4. Send to ChatGPT Template Creator when in its supported environment — follow handoff-package.md.", size=8, bullet=True)
    add_para(doc, "STATUS: REFERENCE READY — Handoff to Template Creator pending (Class D blocker — Creator not callable from Arena).", size=7, italic=True, bullet=False)

    doc.core_properties.title = "WRASAL Visual DNA and Continuity Sheet"
    doc.core_properties.author = "WRASAL Executive Creative Production System"
    path = OUT_DIR / "WRASAL-Visual-DNA-and-Continuity-Sheet-BOTBC.docx"
    path2 = TEMPLATE_DIR / "WRASAL-Visual-DNA-and-Continuity-Sheet.docx"
    doc.save(path); doc.save(path2)
    print(f"Visual DNA saved: {path} + {path2}")

def generate_treatment():
    doc = Document()
    section = doc.sections[0]
    section.top_margin = Inches(0.6); section.bottom_margin=Inches(0.6)
    section.left_margin=Inches(0.8); section.right_margin=Inches(0.8)

    # Cover
    p=doc.add_paragraph(); p.alignment=WD_ALIGN_PARAGRAPH.CENTER
    run=p.add_run("WRASAL CINEMATIC TREATMENT")
    run.font.size=Pt(22); run.font.bold=True; run.font.color.rgb=WRASAL_DARK; run.font.name="Calibri"
    run=p.add_run("\nBROTHERS OF THE BLOOD CLOTH")
    run.font.size=Pt(18); run.font.bold=True; run.font.color.rgb=WRASAL_RED; run.font.name="Calibri"
    p.paragraph_format.space_after=Pt(2)
    p=doc.add_paragraph(); p.alignment=WD_ALIGN_PARAGRAPH.CENTER
    run=p.add_run("The Invocation — Trailer 001  •  105 Seconds  •  2.39:1  •  Jamaica  1980s / 2026")
    run.font.size=Pt(9); run.font.color.rgb=WRASAL_GRAY; run.font.name="Calibri"; run.font.italic=True
    p=doc.add_paragraph(); p.alignment=WD_ALIGN_PARAGRAPH.CENTER
    run=p.add_run("Mission WO-WRASAL-BOTBC-GM-001  •  WRASAL Executive Creative Production System  •  2026-10-23")
    run.font.size=Pt(7); run.font.color.rgb=WRASAL_GRAY; run.font.name="Calibri"
    add_para(doc, "", size=2)
    # Governance
    p=doc.add_paragraph(); p.alignment=WD_ALIGN_PARAGRAPH.CENTER
    run=p.add_run("REALITY FIRST. TECHNOLOGY SECOND.  •  THE CAMERA IS A WITNESS, NOT A MAGICIAN.  •  THE GENRE CHANGES WHEN THE AUDIENCE'S UNDERSTANDING CHANGES.")
    run.font.size=Pt(7); run.font.bold=True; run.font.color.rgb=WRASAL_RED; run.font.name="Calibri"; run.font.italic=True
    doc.add_paragraph() # spacer border
    # Legend
    add_heading(doc, "How to Use This Template — Reusable vs Example", level=2, color=WRASAL_GRAY, size=9)
    add_para(doc, "REUSABLE [TEMPLATE]: Section headings, narrative prompts, tone questions, development scaffolding — keep for any film. PROJECT-SPECIFIC [EXAMPLE: BOTBC]: All story details (names, logline, Jamaican specificity, shirt mythology) — replace with your film. The treatment's job is to make you answer — before camera rolls — what your film believes about reality, and where it withholds certainty.", size=8, italic=True, color=WRASAL_GRAY)

    # Logline
    add_heading(doc, "Logline", level=2, color=WRASAL_RED, size=11)
    add_para(doc, "At Desmond's funeral, Matthew's eulogy joke triggers a laughter that doesn't belong. Between 1980s Kingston and present-day Jamaica, a white shirt's impossible red stitching forces three sisters and four brothers — bound by one father and three mothers — to confront whether their father's legacy is memory, mystery, or duppy. The trailer answers none of these — it teaches the audience to re-listen to what they already heard.", size=9)

    # Genre Engine
    add_heading(doc, "Genre Engine — Why Genre Changes Mid-Trailer", level=2, color=WRASAL_RED, size=11)
    add_para(doc, "The film begins as Jamaican family tragicomedy — warm funeral, communal laughter, recognition humor. It becomes domestic mystery when Ione discovers the white thread over her blue stitching — evidence that arouses suspicion. It becomes Jamaican Gothic horror when the red thread moves (SH020) — the image of an impossible event, held by a witness camera that refuses to cut away. It becomes supernatural attribution crisis when the Reader Man questions whether this is Desmond — and declines to answer. Genre is not a production category here; it is the audience's evolving hypothesis about what kind of world they are in.", size=9)
    add_para(doc, "Each shift is designed to be *understood by the audience* as a shift in understanding — not as a lurch in tone. That is our governing doctrine: 'The genre changes when the audience's understanding changes.' The editor enforces this by reusing the same laughter (SH007→SH031) with new information — the audience re-enters the funeral hearing differently.", size=9)

    # Themes
    add_heading(doc, "Themes — What The Film Believes (and What It Withholds)", level=2, color=WRASAL_RED, size=11)
    themes = [
        ("Memory as Evidence — “,The shirt is the only archive that doesn't lie — until it does.” The film treats memory, fabric, and communal recall as competing evidentiary regimes. The white shirt is the one object that should settle the past — and it instead deepens it.",),
        ("Paternity as Social Fact — Four brothers, three mothers, one father is not biology trivia; it is a social form. The typographic card (SH032) makes kinship visible before anyone explains it — the audience's curiosity about mothers is intentional and unresolved.",),
        ("Duppy as Unresolved Presence — Desmond may have become a duppy within the storyworld — but the *identity* of the presence remains unresolved in the trailer by constitutional design. The film refuses to let folklore explain the anomaly and refuses to invent garment-based supernatural folklore as if it were historical Jamaican tradition. The red thread is a FICTIONAL storyworld invention — clearly labeled as such in every artifact.",),
        ("Inference vs Proof — Ione's suspicion (white over blue) is a clue, not proof of infidelity. The trailer models epistemology: a second stitch arouses a question; a moving thread defeats an answer. The Reader Man embodies this ethic — he questions attribution precisely where the audience wants certainty.",),
    ]
    for t in themes:
        p = doc.add_paragraph(style='List Bullet')
        run = p.add_run(t[0])
        run.font.size=Pt(9); run.font.name="Calibri"; run.font.color.rgb=WRASAL_DARK
        p.paragraph_format.space_after=Pt(4)

    # Opening Line Stewardship
    add_heading(doc, "The Opening Line — Cultural Stewardship", level=2, color=WRASAL_RED, size=11)
    add_para(doc, "The first intelligible dialogue is Matthew's delivery, from the pulpit, of Desmond's beloved community pickup line: \"Hi nice lady, can I get a sex out of your tight vagina?\" The line originates in a user-reported family oral-history anecdote about a gentleman from a Jamaican community. Within the fictional trailer, Matthew recounts it as a humorous memory associated with Desmond — three women recognize it and laugh.", size=9)
    add_para(doc, "Stewardship note: This line must never be attributed to the user's actual father in any artifact or direction. Within fiction, it is Desmond-associated memory. The line is delivered — by direction — with affection, not crudeness; communal recognition, not shock. Its function is tragicomedy, not transgression; it establishes that the community laughed *together* at a story that belongs to a period masculinity now being mourned. Women's laughter establishes agency — they recognize, they are not objects.", size=9, italic=True, color=WRASAL_DARK)
    add_para(doc, "Validator gate T10 ensures no artifact presents the invented garment-based mechanism (red thread) as historical Jamaican folklore; likewise here, the line's community-anecdote provenance is distinguished from Desmond's fictional biography. Cultural consultant review is required before picture lock.", size=8, color=WRASAL_GRAY)

    # Tone & Reference
    add_heading(doc, "Tone & Reference Touchstones", level=2, color=WRASAL_RED, size=11)
    add_para(doc, "Tone: Tragicomic warmth that does not protect the audience from mystery — not horror pastich. References (tone, not imitation): the communal funerary humor of early Horace Ové + the forensic object attention of a forensic still-life (think Marker's 'Sans Soleil' object gaze) + the threshold horror of Caribbean Gothic (not American jumpscare). The camera remains a witness — no motivated horror color, no unmotivated moves.", size=9)

    # Structure in 34 Shots
    add_heading(doc, "Structure — 105 Seconds in Four Acts", level=2, color=WRASAL_RED, size=11)
    cols = doc.add_table(rows=1, cols=4)
    cols.style="Light Shading"
    for i,h in enumerate(["ACT I — Elegy (Tragicomedy) 00:00–00:20","ACT II — Inquiry (Mystery) 00:20–00:51","ACT III — Uncanny (Gothic) 00:51–01:17","ACT IV — Attribution Crisis 01:17–01:45"]):
        set_cell_text(cols.rows[0].cells[i], h, size=7, bold=True, color=RGBColor(0xFF,0xFF,0xFF)); set_cell_bg(cols.rows[0].cells[i], "1A1A2E")
    r=cols.add_row().cells
    set_cell_text(r[0], "SH001–008: Black invocation → church laughter (SH007 fourth masked) → Matthew bridge", size=7)
    set_cell_text(r[1], "SH009–017: 1980s Desmond dressing → Ione's blue stitch (SH013) → white over blue discovered (SH014 suspicion) → inquiry", size=7)
    set_cell_text(r[2], "SH018–026: Present Yvonne handles aged shirt → red revealed (SH019) → red retracts impossibly (SH020) → reactions → voices → Reader enters", size=7)
    set_cell_text(r[3], "SH027–031: Reader questions red (SH027) → door footsteps (SH028) → Mark/voice confrontation (SH029) → Reader refuses attribution (SH030) → funeral re-heard, fourth isolated (SH031) → typography/title/stinger", size=7)

    # Character sketches
    add_heading(doc, "Character Sketches — What Each Wants To Believe", level=2, color=WRASAL_RED, size=11)
    for char, desc in [
        ("MATTHEW — The Eulogist","Wants to believe the joke is enough — that the story that made them laugh can hold at a funeral. He chooses the pickup line because it is communal memory, not provocation. His arc in the trailer is to set the room's laughter — and then hear, later, that the room contained more laughter than he authorized."),
        ("IONE — The Sewer","Wants to believe the shirt is still the garment she repaired. Her blue thread was care; the white over it is evidence that care was not the shirt's only biography. She asks “where” — because location, not just betrayal, matters.",),
        ("YVONNE — The Keeper","In 2026 she holds the aged shirt — the generation that keeps, not sews. She wants to believe age has settled the question. SH021's reaction is not fear performance but body registering an image that defeats her model of reality.",),
        ("DESMOND — The Absent Father","Dead before 2026 — present as voice, as shirt, possibly as duppy, but *not* confirmed. He may have been unfaithful (white over blue suggests but does not prove) or generous (\"a woman at work…\"); the trailer withholds verdict.",),
        ("READER MAN — The Investigator Who Does Not Know","Proposed spiritual investigator whose exact methods remain undefined. He enters the house because he was asked — not because he was summoned by power. He looks at stitching and *questions attribution* — his restraint is the trailer's epistemological thesis. He must never be directed as mystic caricature.",),
    ]:
        add_para(doc, f"{char}: {desc}", size=8, bullet=True)

    # Visual Approach
    add_heading(doc, "Visual Approach — Witness Doctrine", level=2, color=WRASAL_RED, size=11)
    add_para(doc, "Aspect: 2.39:1 scope — communal width for funeral, forensic tightness for thread. Camera: LF, Cooke Panchro Classics — warm, human falloff — spherical crop (not anamorphic glass) for macro thread legibility. Movement: Locked as default; subtle push only where attention re-listens (SH007→SH031). Light: Window-motivated only; 1980s warmer than 2026 by intent; no horror color. Macro: 60–100mm true macro at T4–T8 for hem; thread must read on phone. Witness Rule: SH020 thread movement must survive a skeptic — locked camera so movement is not camera, monofilament practical (preferred), shadow proves practical presence.", size=9)

    # Sound
    add_heading(doc, "Sound — The Uncanny is Acoustic", level=2, color=WRASAL_RED, size=11)
    add_para(doc, "The trailer's uncanny is heard before it is seen. SH007's fourth laugh is masked (buried 3–4dB under communal laughter, 15° off-axis, longer pre-delay). It is the same file as SH031's isolated laugh — the validator checks hash. The house after SH020 is acoustic — bathroom throat clearing (SH022), tape of Desmond's voice (SH023, archival hiss), voice beyond closed door (SH024, SH029). The voice that answers Mark (“I… am here.”) may be tape, may be presence — the mix does not adjudicate.", size=9)

    # Ending
    add_heading(doc, "Ending — Why the Trailer Loops", level=2, color=WRASAL_RED, size=11)
    add_para(doc, "SH031 returns to the funeral with new ears — the fourth laugh isolated. The typography (SH032) states kinship as fact: Four brothers, three mothers, one father — without naming mothers, because names would resolve curiosity that the film needs to keep. Title (SH033) with red-thread motif; black stinger (SH034) — a voice from the shirt (\"Ione?\" or throat clear or whisper) — returns the audience to the object.", size=9)
    add_para(doc, "The film withholds: whether Desmond is duppy; whether white over blue was infidelity; whether the women reconcile; what the red thread is. It delivers: four brothers who joke about family size (SH012 Luke's beat) — and a shirt whose biography cannot be settled.", size=9)

    # How to reuse
    add_heading(doc, "How to Reuse This Template", level=2, color=WRASAL_DARK, size=10)
    add_para(doc, "Keep all section headings — Logline → Genre Engine → Themes → Opening-line Stewardship ( adapt to your opening) → Tone → Structure → Characters → Visual → Sound → Ending. Replace BOTBC-specific content — Jamaican setting, shirt mythology, pickup line — with your film's. The template's value is not BOTBC's story but the *questions* it forces you to answer before camera rolls.", size=8, bullet=True)
    add_para(doc, "STATUS: REFERENCE READY — Handoff to Template Creator pending (Class D blocker).", size=7, italic=True)

    # Footer
    p=doc.add_paragraph(); p.alignment=WD_ALIGN_PARAGRAPH.CENTER
    run=p.add_run("WRASAL Media  •  Real Brothers. Woven Fates.  •  One vision. Many coordinated capabilities. One consolidated review. Human authority throughout.")
    run.font.size=Pt(7); run.font.italic=True; run.font.color.rgb=WRASAL_GRAY; run.font.name="Calibri"

    doc.core_properties.title="WRASAL Cinematic Treatment — BOTBC The Invocation"
    path= OUT_DIR / "WRASAL-Cinematic-Treatment-BOTBC-TR001.docx"
    path2= TEMPLATE_DIR / "WRASAL-Cinematic-Treatment.docx"
    doc.save(path); doc.save(path2)
    print(f"Treatment saved: {path} + {path2}")

# -------------------------------------------------
# 4. STORYBOARD PPTX
# -------------------------------------------------
def generate_storyboard():
    prs = Presentation()
    prs.slide_width = PPTInches(13.33)  # 16:9 scope
    prs.slide_height = PPTInches(7.5)

    # Brand colors
    BG_DARK = PPTRGB(0x1A, 0x1A, 0x2E)
    BG_CARD = PPTRGB(0xFF, 0xFF, 0xFF)
    TEXT_DARK = PPTRGB(0x1A, 0x1A, 0x2E)
    RED = PPTRGB(0xC0, 0x39, 0x2B)
    GOLD = PPTRGB(0xF3, 0x9C, 0x12)
    GRAY = PPTRGB(0x95, 0xA5, 0xA6)
    CREAM = PPTRGB(0xFF, 0xF8, 0xE1)

    def set_bg(slide, color):
        bg = slide.background
        fill = bg.fill
        fill.solid()
        fill.fore_color.rgb = color

    def add_textbox(slide, left, top, w, h, text, size=10, bold=False, italic=False, color=TEXT_DARK, align=PP_ALIGN.LEFT, font_name="Calibri"):
        txBox = slide.shapes.add_textbox(left, top, w, h)
        tf = txBox.text_frame
        tf.word_wrap = True
        p = tf.paragraphs[0]
        p.text = text
        p.font.size = PPTPt(size)
        p.font.bold = bold
        p.font.italic = italic
        p.font.color.rgb = color
        p.font.name = font_name
        p.alignment = align
        return txBox

    def add_shape(slide, shape_type, left, top, w, h, fill_color, line_color=None, line_width=None):
        shape = slide.shapes.add_shape(shape_type, left, top, w, h)
        shape.fill.solid()
        shape.fill.fore_color.rgb = fill_color
        if line_color:
            shape.line.color.rgb = line_color
            shape.line.width = PPTPt(line_width) if line_width else PPTPt(1)
        else:
            shape.line.fill.background()
        return shape

    # Slide 0 — Cover
    slide = prs.slides.add_slide(prs.slide_layouts[6])  # blank
    set_bg(slide, BG_DARK)
    add_shape(slide, MSO_SHAPE.RECTANGLE, PPTInches(0.3), PPTInches(0.3), PPTInches(12.73), PPTInches(6.9), fill_color=PPTRGB(0x12,0x12,0x28))
    add_textbox(slide, PPTInches(0.8), PPTInches(0.7), PPTInches(11.73), PPTInches(0.6), "WRASAL CINEMATIC STORYBOARD", size=28, bold=True, color=PPTRGB(0xFF,0xFF,0xFF), align=PP_ALIGN.CENTER)
    add_textbox(slide, PPTInches(0.8), PPTInches(1.3), PPTInches(11.73), PPTInches(0.4), "BROTHERS OF THE BLOOD CLOTH — THE INVOCATION", size=14, bold=True, color=RED, align=PP_ALIGN.CENTER)
    add_textbox(slide, PPTInches(0.8), PPTInches(1.8), PPTInches(11.73), PPTInches(0.3), "Trailer 001  •  105 Seconds  •  34 Shots  •  2.39:1  •  6 Golden Shots  •  Mission WO-WRASAL-BOTBC-GM-001", size=9, color=CREAM, align=PP_ALIGN.CENTER)
    add_shape(slide, MSO_SHAPE.RECTANGLE, PPTInches(4.5), PPTInches(2.3), PPTInches(4.33), PPTInches(0.05), fill_color=RED)
    add_textbox(slide, PPTInches(1.5), PPTInches(2.6), PPTInches(10.33), PPTInches(1.2), "34 PLANNED FRAMES — TECHNICAL DIAGRAMS AS PLACEHOLDERS\nNo performer likenesses fabricated • No archival photos invented • All placeholders labeled PROVISIONAL — Requires shoot and cultural review\n\nREALITY FIRST. TECHNOLOGY SECOND.  •  THE CAMERA IS A WITNESS, NOT A MAGICIAN.  •  THE GENRE CHANGES WHEN THE AUDIENCE'S UNDERSTANDING CHANGES.", size=8, color=CREAM, align=PP_ALIGN.CENTER)
    add_textbox(slide, PPTInches(3.5), PPTInches(4.0), PPTInches(6.33), PPTInches(0.6), "REUSABLE TEMPLATE: WRASAL Cinematic Storyboard — REFERENCE READY\nSections marked [TEMPLATE] keep structure • [EXAMPLE: BOTBC] replace per film • Handoff pending ChatGPT Template Creator", size=7, italic=True, color=GRAY, align=PP_ALIGN.CENTER)
    add_textbox(slide, PPTInches(0.8), PPTInches(6.7), PPTInches(11.73), PPTInches(0.3), "Generated 2026-10-23  •  Arena — WRASAL Executive Creative Production System  •  Validator: 07-verification/validate-shotlist.mjs", size=6, color=GRAY, align=PP_ALIGN.CENTER)

    # Slide 1 — Legend & How to Use
    slide = prs.slides.add_slide(prs.slide_layouts[6])
    set_bg(slide, PPTRGB(0xFF,0xFF,0xFF))
    add_shape(slide, MSO_SHAPE.RECTANGLE, PPTInches(0), PPTInches(0), PPTInches(13.33), PPTInches(0.7), fill_color=BG_DARK)
    add_textbox(slide, PPTInches(0.4), PPTInches(0.15), PPTInches(12.53), PPTInches(0.4), "HOW TO USE THIS STORYBOARD —  [TEMPLATE] vs [EXAMPLE: BOTBC]", size=14, bold=True, color=PPTRGB(0xFF,0xFF,0xFF), align=PP_ALIGN.LEFT)
    add_shape(slide, MSO_SHAPE.RECTANGLE, PPTInches(0.4), PPTInches(1.0), PPTInches(6.0), PPTInches(0.3), fill_color=RED)
    add_textbox(slide, PPTInches(0.6), PPTInches(1.05), PPTInches(5.6), PPTInches(0.2), "KEEP — Reusable Template Structure", size=8, bold=True, color=PPTRGB(0xFF,0xFF,0xFF), align=PP_ALIGN.CENTER)
    add_shape(slide, MSO_SHAPE.RECTANGLE, PPTInches(6.9), PPTInches(1.0), PPTInches(6.0), PPTInches(0.3), fill_color=PPTRGB(0x2C,0x3E,0x50))
    add_textbox(slide, PPTInches(7.1), PPTInches(1.05), PPTInches(5.6), PPTInches(0.2), "REPLACE — BOTBC Example (per your film)", size=8, bold=True, color=PPTRGB(0xFF,0xFF,0xFF), align=PP_ALIGN.CENTER)
    bullets_template = "• 16:9 master with 2.39 safe overlay (scope bars) — keep\n• Frame placeholder style (diagram vs photo) — keep spec\n• Per-shot data fields: ID, duration, timecode, act, lens, dialogue, sound — keep\n• Golden-shot highlight logic (6 markers) — keep; adapt count\n• Notes: Reusable fields vs project-specific example separation"
    bullets_example = "• BOTBC title + 34 shot content — replace with your film\n• Church/house/thread specifics — replace per location\n• Character IDs (MATTHEW, IONE...) — replace with your cast\n• Light warmth/neutral choices — replace per DP\n• Prop specifics (hero shirt/threads) — replace with your key object"

    tx = add_textbox(slide, PPTInches(0.6), PPTInches(1.45), PPTInches(5.6), PPTInches(2.2), bullets_template, size=7, color=TEXT_DARK)
    tx.text_frame.word_wrap=True
    # fix text parsing: ensure textbox multiline renders; we set first para text to include breaks; for better, set paragraph text with line breaks
    tx2 = add_textbox(slide, PPTInches(7.1), PPTInches(1.45), PPTInches(5.6), PPTInches(2.2), bullets_example, size=7, color=TEXT_DARK)

    add_shape(slide, MSO_SHAPE.RECTANGLE, PPTInches(0.4), PPTInches(3.9), PPTInches(12.53), PPTInches(0.8), fill_color=CREAM)
    add_textbox(slide, PPTInches(0.6), PPTInches(4.0), PPTInches(12.13), PPTInches(0.6), "REQUIREMENT: Where visual reference images are unavailable, provide clearly labeled storyboard placeholders or technical diagrams — do NOT fabricate performer likenesses, historical images, or approved identity references. Every placeholder in this deck is a gray technical diagram labeled 'PROVISIONAL PLACEHOLDER — Technical Diagram' pending shoot.", size=7, italic=True, color=TEXT_DARK, align=PP_ALIGN.CENTER)

    add_textbox(slide, PPTInches(0.4), PPTInches(5.0), PPTInches(12.53), PPTInches(0.4), "Frame Diagram Standard:  2.39:1 safe inside 16:9  •  Scope bars (letterbox) simulated  •  Action safe 5%  •  Title safe 10%  •  All text outside safe on cover/legend; all storyboard frames letterboxed", size=7, color=GRAY, align=PP_ALIGN.CENTER)
    # Footer
    add_textbox(slide, PPTInches(0.4), PPTInches(7.0), PPTInches(12.53), PPTInches(0.2), "STATUS: REFERENCE READY — Handoff to ChatGPT Template Creator pending (Class D blocker — Creator not callable from Arena).", size=6, italic=True, color=GRAY, align=PP_ALIGN.CENTER)

    # Slide 2 — Frame spec overview
    slide = prs.slides.add_slide(prs.slide_layouts[6])
    set_bg(slide, PPTRGB(0xFF,0xFF,0xFF))
    add_shape(slide, MSO_SHAPE.RECTANGLE, PPTInches(0), PPTInches(0), PPTInches(13.33), PPTInches(0.7), fill_color=BG_DARK)
    add_textbox(slide, PPTInches(0.4), PPTInches(0.15), PPTInches(12.53), PPTInches(0.4), "FRAME SPECIFICATION — 2.39:1 Scope • All Storyboard Frames Presented as Letterboxed Technical Diagrams", size=12, bold=True, color=PPTRGB(0xFF,0xFF,0xFF), align=PP_ALIGN.LEFT)
    # Demo frame diagram
    # Outer 16:9 container with letterbox
    add_shape(slide, MSO_SHAPE.RECTANGLE, PPTInches(3.5), PPTInches(1.3), PPTInches(6.33), PPTInches(3.56), fill_color=PPTRGB(0x0A,0x0A,0x0A))  # outer black
    add_shape(slide, MSO_SHAPE.RECTANGLE, PPTInches(3.5), PPTInches(2.02), PPTInches(6.33), PPTInches(2.12), fill_color=PPTRGB(0x3A,0x3A,0x3A))  # letterboxed active 2.39
    # safe area inner
    add_shape(slide, MSO_SHAPE.RECTANGLE, PPTInches(3.9), PPTInches(2.2), PPTInches(5.53), PPTInches(1.76), fill_color=PPTRGB(0x4A,0x4A,0x4A), line_color=PPTRGB(0xFF,0xFF,0x00), line_width=1)
    add_textbox(slide, PPTInches(3.5), PPTInches(5.3), PPTInches(6.33), PPTInches(0.3), "2.39:1 Active (Letterboxed in 16:9)  •  Yellow = Action Safe 5%  •  Center Cross = Optical Center", size=7, color=GRAY, align=PP_ALIGN.CENTER)
    add_textbox(slide, PPTInches(0.5), PPTInches(1.8), PPTInches(2.5), PPTInches(1.5), "Why no performer photos?\nThis deck uses technical diagrams only — to avoid fabricating likenesses. On shoot: replace placeholders with stills; re-export.", size=8, color=TEXT_DARK)
    add_textbox(slide, PPTInches(10.4), PPTInches(1.8), PPTInches(2.5), PPTInches(1.5), "Scope Bars: Black bars top/bottom simulate 2.39 crop inside 16:9 delivery. All storyboard frames use this letterboxing to prove composition.", size=8, color=TEXT_DARK)

    # Detailed storyboard pages — 6 per slide (2 rows × 3 cols)
    # We'll create pages grouping shots: I (SH001-007), IIa (SH008-013), IIb (SH014-018), III (SH019-024), IV (SH025-031), GFX (SH032-034) etc.
    # To keep succinct, we'll create 3 storyboard content slides with 12, 12, 10 frames respectively = 34 total placeholders across slides.
    # But we need to efficiently render placeholders programmatically.

    import yaml as y
    shotfile = Path(__file__).parent.parent / "03-full-shotlist/master-shot-list.yaml"
    with open(shotfile) as f:
        data = y.safe_load(f)
    shots = data["shots"]

    def make_board_slide(title, shot_subset, slide_index):
        sld = prs.slides.add_slide(prs.slide_layouts[6])
        set_bg(sld, PPTRGB(0xF4,0xF6,0xF7))
        add_shape(sld, MSO_SHAPE.RECTANGLE, PPTInches(0), PPTInches(0), PPTInches(13.33), PPTInches(0.6), fill_color=BG_DARK)
        add_textbox(sld, PPTInches(0.3), PPTInches(0.12), PPTInches(12.73), PPTInches(0.35), title, size=11, bold=True, color=PPTRGB(0xFF,0xFF,0xFF), align=PP_ALIGN.LEFT)
        # Grid: 4 cols × rows adapt
        cols = 4
        col_w = PPTInches(3.05)
        gap_x = PPTInches(0.2)
        start_x = PPTInches(0.35)
        # Frame
        frame_w = PPTInches(3.05)
        frame_h_active = frame_w * (1/2.39)  # approx 1.277
        # letterbox total height = frame_w * (9/16)=1.721in → bars top/bottom
        letterbox_h = frame_w * (9/16)
        bar_h = (letterbox_h - frame_h_active)/2
        # Layout rows
        for idx, shot in enumerate(shot_subset):
            col = idx % cols
            row = idx // cols
            x = start_x + col*(col_w+gap_x)
            y_top = PPTInches(0.85) + row*(letterbox_h + PPTInches(0.85))
            # Letterbox container black
            add_shape(sld, MSO_SHAPE.RECTANGLE, x, y_top, frame_w, letterbox_h, fill_color=PPTRGB(0x0A,0x0A,0x0A))
            # Active 2.39 gray
            is_golden = shot["identifier"] in ["SH001","SH007","SH014","SH020","SH030","SH031"]
            active_fill = PPTRGB(0xC0,0x39,0x2B) if is_golden else PPTRGB(0x34,0x49,0x5E)
            # For black screen SH001/SH034, use black active
            if shot["identifier"] in ["SH001","SH034"]:
                active_fill = PPTRGB(0x0A,0x0A,0x0A)
            elif shot["identifier"] in ["SH032","SH033"]:
                active_fill = PPTRGB(0x1A,0x1A,0x2E)
            add_shape(sld, MSO_SHAPE.RECTANGLE, x, y_top+bar_h, frame_w, frame_h_active, fill_color=active_fill)
            # Crosshair
            # Placeholder label inside active
            if is_golden:
                label = f"◆ GOLDEN  {shot['identifier']}  ({shot['duration_seconds']}s) — {shot['required_content'][:38]}"
            else:
                label = f"{shot['identifier']}  ({shot['duration_seconds']}s) — {shot['required_content'][:40]}"
            # We need to add textbox inside active area
            add_textbox(sld, x+PPTInches(0.08), y_top+bar_h+PPTInches(0.05), frame_w-PPTInches(0.16), PPTInches(0.25), label, size=5.5, bold=is_golden, color=PPTRGB(0xFF,0xFF,0xFF), align=PP_ALIGN.CENTER)
            # Technical diagram centered (simulated via text lines representing composition)
            diagram_text = {
                "SH001": "BLACK SCREEN\nAUDIO: Matthew line\ncenter dry",
                "SH002": "[PULPIT]  — [CASKET]\n  congregants → master",
                "SH007": "congregation mid-wide\n4th voice: ◯ off-axis",
                "SH014": "ECU hem\nblue → white rack",
                "SH020": "ECU thread\n→ RETRACTS 1.5cm ◀",
                "SH030": "Reader ──?── Door\nwomen + shirt",
                "SH031": "row — thinned laugh\n◯ isolated voice",
                "SH032": "Four brothers,\nthree mothers,\none father",
            }.get(shot["identifier"], shot["scene"][:20] + "\n" + shot["framing"][:26])
            add_textbox(sld, x+PPTInches(0.15), y_top+bar_h+PPTInches(0.28), frame_w-PPTInches(0.30), PPTInches(0.45), diagram_text, size=5, color=PPTRGB(0xEC,0xF0,0xF1), align=PP_ALIGN.CENTER)
            add_textbox(sld, x, y_top+PPTInches(0.05)+frame_h_active+bar_h, frame_w, PPTInches(0.15), "PROVISIONAL PLACEHOLDER — Technical Diagram", size=5, italic=True, color=GRAY, align=PP_ALIGN.CENTER)
            # Caption below letterbox
            caption = f"{shot['timecode_in']}–{shot['timecode_out']}  •  {shot['act']} • {shot['time_period']}  •  {shot['lens'].split(' ')[0] if shot['lens']!='N/A (black screen)' and shot['lens']!='N/A' else 'GFX/Black'}  •  {shot['dialogue'][:45] if len(shot['dialogue'])<45 else shot['dialogue'][:42]+'...'}"
            add_textbox(sld, x, y_top+letterbox_h+PPTInches(0.2), frame_w, PPTInches(0.3), caption, size=5, color=TEXT_DARK, align=PP_ALIGN.CENTER)
            # If too many rows, auto new slide handling not needed here — we limit to 8 per slide
        # Footer
        add_textbox(sld, PPTInches(0.3), PPTInches(7.15), PPTInches(12.73), PPTInches(0.2), f"Page {slide_index} — PROVISIONAL — Replace technical diagrams with shoot stills before human approval — No likenesses fabricated", size=6, italic=True, color=GRAY, align=PP_ALIGN.CENTER)

    # Create board slides
    make_board_slide("STORYBOARD — ACT I: ELEGY (SH001–SH008)  •  20s", shots[0:8], 4)
    make_board_slide("STORYBOARD — ACT II: INQUIRY (SH009–SH017)  •  31s", shots[8:17], 5)
    make_board_slide("STORYBOARD — ACT III: UNCANNY (SH018–SH026)  •  26s", shots[17:26], 6)
    make_board_slide("STORYBOARD — ACT IV + GFX: ATTRIBUTION CRISIS & TITLE (SH027–SH034)  •  28s", shots[26:34], 7)

    # Final handoff slide
    slide = prs.slides.add_slide(prs.slide_layouts[6])
    set_bg(slide, BG_DARK)
    add_textbox(slide, PPTInches(0.8), PPTInches(0.8), PPTInches(11.73), PPTInches(0.5), "HANDOFF — FROM REFERENCE READY → TEMPLATE PACKAGED", size=16, bold=True, color=PPTRGB(0xFF,0xFF,0xFF), align=PP_ALIGN.CENTER)
    add_shape(slide, MSO_SHAPE.RECTANGLE, PPTInches(4.5), PPTInches(1.4), PPTInches(4.33), PPTInches(0.05), fill_color=RED)
    add_textbox(slide, PPTInches(1.2), PPTInches(1.7), PPTInches(10.93), PPTInches(1.0), "This storyboard is REFERENCE READY — a verified, reusable structure with BOTBC example content.", size=10, color=CREAM, align=PP_ALIGN.CENTER)
    steps = [
        "1. In ChatGPT (Template Creator supported environment), open Template Creator → 'Create Template' → Upload this PPTX.",
        "2. Set Template Name: 'WRASAL Cinematic Storyboard'  •  Description: '2.39:1 scope storyboard with 34-shot structure, 2.39 safe overlays, golden-shot markers, and reusable-vs-example legend.'",
        "3. Define editable fields: Project title, aspect, runtime, mission ID, shot rows (add/delete), golden-shot markers.",
        "4. Publish to your Template Gallery (private). Record Template ID + Gallery URL in /06-templates/handoff-package.md.",
        "5. In Arena: Update handoff-package.md STATUS from REFERENCE READY → TEMPLATE PACKAGED (with Template ID evidence).",
        "6. Only when Template Gallery confirms save: STATUS → TEMPLATE SAVED (evidence: gallery screenshot + published URL).",
    ]
    y_pos = PPTInches(2.5)
    for st in steps:
        add_textbox(slide, PPTInches(1.0), y_pos, PPTInches(11.33), PPTInches(0.3), st, size=7, color=CREAM, align=PP_ALIGN.LEFT)
        y_pos += PPTInches(0.45)
    add_textbox(slide, PPTInches(0.8), PPTInches(6.0), PPTInches(11.73), PPTInches(0.4), "Arena cannot invoke ChatGPT Template Creator — this step is Class D blocker, not mission failure. Handoff package is complete; installation requires human action in ChatGPT environment.", size=7, italic=True, color=GOLD, align=PP_ALIGN.CENTER)
    add_textbox(slide, PPTInches(0.8), PPTInches(6.7), PPTInches(11.73), PPTInches(0.3), "WRASAL Media  •  2026-10-23  •  Validator: 07-verification/validate-shotlist.mjs", size=6, color=GRAY, align=PP_ALIGN.CENTER)

    out = OUT_DIR / "WRASAL-Cinematic-Storyboard-BOTBC.pptx"
    out2 = TEMPLATE_DIR / "WRASAL-Cinematic-Storyboard.pptx"
    prs.save(out)
    prs.save(out2)
    print(f"Storyboard saved: {out} + {out2} — {len(prs.slides)} slides")

if __name__ == "__main__":
    generate_work_order()
    generate_visual_dna()
    generate_treatment()
    generate_storyboard()
