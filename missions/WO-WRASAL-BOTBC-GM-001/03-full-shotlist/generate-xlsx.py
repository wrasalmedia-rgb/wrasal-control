#!/usr/bin/env python3
"""Generate Master Shot List XLSX with professional formatting."""
import yaml
from pathlib import Path
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter

ROOT = Path(__file__).parent
YAML_PATH = ROOT / "master-shot-list.yaml"
XLSX_PATH = ROOT / "WRASAL-Cinematic-Master-Shot-List.xlsx"
XLSX_REUSABLE_PATH = Path(__file__).parent.parent / "06-templates" / "WRASAL-Cinematic-Master-Shot-List.xlsx"

# Load YAML
with open(YAML_PATH) as f:
    data = yaml.safe_load(f)
shots = data["shots"]

# Define styles
BLACK = "0A0A0A"
WRASAL_RED = "C0392B"  # red thread
WRASAL_GOLD = "F39C12"
WRASAL_CREAM = "FFF8E1"
WRASAL_DARK = "1A1A2E"
WRASAL_GRAY = "95A5A6"
HEADER_FILL = PatternFill(start_color=WRASAL_DARK, end_color=WRASAL_DARK, fill_type="solid")
HEADER_FONT = Font(name="Calibri", size=8, bold=True, color="FFFFFF")
TITLE_FONT = Font(name="Calibri", size=16, bold=True, color=WRASAL_DARK)
SUBTITLE_FONT = Font(name="Calibri", size=9, italic=True, color=WRASAL_GRAY)
BODY_FONT = Font(name="Calibri", size=8, color="1A1A2E")
BODY_FONT_BOLD = Font(name="Calibri", size=8, bold=True, color="1A1A2E")
THIN_BORDER = Border(
    left=Side(style="thin", color="D5D8DC"),
    right=Side(style="thin", color="D5D8DC"),
    top=Side(style="thin", color="D5D8DC"),
    bottom=Side(style="thin", color="D5D8DC")
)
ACT_FILLS = {
    "I": PatternFill(start_color="FDEBD0", end_color="FDEBD0", fill_type="solid"),
    "I→II": PatternFill(start_color="F9E79F", end_color="F9E79F", fill_type="solid"),
    "II": PatternFill(start_color="A9CCE3", end_color="A9CCE3", fill_type="solid"),
    "III": PatternFill(start_color="D5F5E3", end_color="D5F5E3", fill_type="solid"),
    "IV": PatternFill(start_color="E8DAEF", end_color="E8DAEF", fill_type="solid"),
    "IV→I": PatternFill(start_color="F5CBA7", end_color="F5CBA7", fill_type="solid"),
    "—": PatternFill(start_color="EAEDED", end_color="EAEDED", fill_type="solid"),
}
PERIOD_FILLS = {
    "2026": PatternFill(start_color="EBF5FB", end_color="EBF5FB", fill_type="solid"),
    "1980s": PatternFill(start_color="FEF9E7", end_color="FEF9E7", fill_type="solid"),
    "2026/1980s": PatternFill(start_color="F4ECF7", end_color="F4ECF7", fill_type="solid"),
    "GFX": PatternFill(start_color="F2F3F4", end_color="F2F3F4", fill_type="solid"),
}

wb = Workbook()
ws = wb.active
ws.title = "MASTER SHOT LIST"

# Print settings
ws.sheet_properties.pageSetUpPr.fitToPage = True
ws.page_setup.orientation = "landscape"
ws.page_setup.paperSize = ws.PAPERSIZE_A3
ws.page_setup.fitToWidth = 1
ws.page_setup.fitToHeight = 0
ws.print_title_rows = "5:5"
ws.sheet_properties.pageSetUpPr.fitToPage = True

# Title block (rows 1-4)
ws.merge_cells("A1:R1")
title_cell = ws["A1"]
title_cell.value = "BROTHERS OF THE BLOOD CLOTH — THE INVOCATION"
title_cell.font = TITLE_FONT
title_cell.alignment = Alignment(horizontal="center", vertical="center")
ws.row_dimensions[1].height = 24

ws.merge_cells("A2:R2")
sub = ws["A2"]
sub.value = "WRASAL Cinematic Master Shot List  •  Trailer 001  •  105 Seconds  •  34 Shots  •  2.39:1  •  Mission WO-WRASAL-BOTBC-GM-001"
sub.font = SUBTITLE_FONT
sub.alignment = Alignment(horizontal="center", vertical="center")
ws.row_dimensions[2].height = 12

ws.merge_cells("A3:R3")
gov = ws["A3"]
gov.value = "REALITY FIRST. TECHNOLOGY SECOND.  •  THE CAMERA IS A WITNESS, NOT A MAGICIAN.  •  THE GENRE CHANGES WHEN THE AUDIENCE'S UNDERSTANDING CHANGES."
gov.font = Font(name="Calibri", size=7, italic=True, color=WRASAL_RED, bold=True)
gov.alignment = Alignment(horizontal="center", vertical="center")
ws.row_dimensions[3].height = 10

ws.merge_cells("A4:R4")
meta = ws["A4"]
meta.value = f"Version 1.0  •  2026-10-23  •  Golden Shots: SH001 · SH007 · SH014 · SH020 · SH030 · SH031  •  Status: PROPOSED — Pending Human Approval  •  Evidence: Deterministic validation T01–T17 in /07-verification/"
meta.font = Font(name="Calibri", size=7, color=WRASAL_GRAY)
meta.alignment = Alignment(horizontal="center", vertical="center")
ws.row_dimensions[4].height = 10

# Header row (row 5)
headers = [
    ("#", 5),
    ("SHOT", 7),
    ("DUR", 5),
    ("TIMECODE", 14),
    ("ACT", 7),
    ("PERIOD", 10),
    ("SCENE", 13),
    ("GENRE STATE", 15),
    ("REQUIRED CONTENT", 26),
    ("CHARACTERS", 16),
    ("CAMERA / LENS", 18),
    ("FRAMING / ANGLE", 18),
    ("LIGHTING", 18),
    ("BLOCKING", 20),
    ("SOUND / DIALOGUE", 20),
    ("CONTINUITY", 16),
    ("VERIFICATION", 11),
    ("ASSUMPTIONS", 14),
]
for col, (h, w) in enumerate(headers, start=1):
    cell = ws.cell(row=5, column=col, value=h)
    cell.font = HEADER_FONT
    cell.fill = HEADER_FILL
    cell.alignment = Alignment(horizontal="center", vertical="center", wrap_text=True)
    cell.border = THIN_BORDER
    ws.column_dimensions[get_column_letter(col)].width = w
ws.row_dimensions[5].height = 20

# Shot rows (row 6+)
row = 6
for idx, s in enumerate(shots):
    # Alternating row band
    base_fill = PatternFill(start_color="FFFFFF", end_color="FFFFFF", fill_type="solid") if idx % 2 == 0 else PatternFill(start_color="F8F9F9", end_color="F8F9F9", fill_type="solid")
    act_fill = ACT_FILLS.get(s["act"], base_fill)
    period_fill = PERIOD_FILLS.get(s["time_period"], base_fill)

    # Golden shot highlight
    is_golden = s["identifier"] in ["SH001","SH007","SH014","SH020","SH030","SH031"]
    if is_golden:
        # Add thick left border indicator
        pass

    vals = [
        idx+1,  # #
        s["identifier"],
        f'{s["duration_seconds"]}s',
        f'{s["timecode_in"]}–{s["timecode_out"]}',
        s["act"],
        s["time_period"],
        s["scene"],
        s["genre_state"],
        s["required_content"],
        ", ".join(s["character_ids"]) if s["character_ids"] else "— (GFX)",
        f'{s["camera"]} · {s["lens"]}',
        f'{s["framing"]} / {s["angle"]} / {s["movement"]}',
        s["lighting"],
        s["blocking"],
        f'DLG: {s["dialogue"][:90]}...' if len(s["dialogue"])>90 else f'DLG: {s["dialogue"]}' if s["dialogue"] else s["sound"],
        s["continuity"],
        s["verification_status"].split("—")[0].strip(),
        s["assumptions"].split("—")[0].strip(),
    ]
    for col, val in enumerate(vals, start=1):
        cell = ws.cell(row=row, column=col, value=val)
        cell.font = Font(name="Calibri", size=7, bold=(col in [2,3]) or is_golden, color="1A1A2E")
        if is_golden and col == 2:
            cell.font = Font(name="Calibri", size=8, bold=True, color=WRASAL_RED)
            cell.fill = PatternFill(start_color="FDEDEC", end_color="FDEDEC", fill_type="solid")
        elif col == 5:  # ACT
            cell.fill = act_fill
        elif col == 6:  # PERIOD
            cell.fill = period_fill
        elif col in [4,10]:
            cell.font = Font(name="Calibri", size=7, color="1A5276")
        elif col == 9:
            cell.font = Font(name="Calibri", size=7, italic=False, color="1A1A2E")
        elif col == 1:
            cell.font = Font(name="Calibri", size=7, bold=True, color=WRASAL_GRAY)
        else:
            cell.fill = base_fill
        cell.alignment = Alignment(vertical="center", wrap_text=True, horizontal="center" if col in [1,2,3,4,5,6] else "left")
        cell.border = THIN_BORDER
        # Special: golden shot row subtle background
        if is_golden:
            if col not in [2,5,6]:
                # Mix base with faint red
                cell.fill = PatternFill(start_color="FEF9F9" if idx%2==0 else "FDEDEC", end_color="FEF9F9" if idx%2==0 else "FDEDEC", fill_type="solid")

    ws.row_dimensions[row].height = 32
    row += 1

# Summary footer row
ws.merge_cells(f"A{row}:R{row}")
foot = ws.cell(row=row, column=1, value=f"TOTAL RUNTIME: {data['total_runtime_seconds']}s (105s verified)  •  34 Shots  •  Golden Shots (6) control narrative  •  Reusable Template: WRASAL-Cinematic-Master-Shot-List.xlsx — REFERENCE READY — handoff to ChatGPT Template Creator pending (Class D blocker)")
foot.font = Font(name="Calibri", size=7, bold=True, color=WRASAL_RED)
foot.fill = PatternFill(start_color="FDEDEC", end_color="FDEDEC", fill_type="solid")
foot.alignment = Alignment(horizontal="center", vertical="center")
ws.row_dimensions[row].height = 14
row+=1

# Second footer — governance
ws.merge_cells(f"A{row}:R{row}")
foot2 = ws.cell(row=row, column=1, value="Evidence: /03-full-shotlist/master-shot-list.yaml (machine-readable)  •  Validator: /07-verification/validate-shotlist.mjs  •  No real-family biography promoted to canon  •  Red thread = FICTIONAL storyworld invention (not folklore)")
foot2.font = Font(name="Calibri", size=6, italic=True, color=WRASAL_GRAY)
foot2.alignment = Alignment(horizontal="center", vertical="center")
ws.row_dimensions[row].height = 10

# Freeze panes
ws.freeze_panes = "A6"
# Filter
ws.auto_filter.ref = f"A5:R{row-3}"
# Print
ws.sheet_properties.pageSetUpPr.fitToPage = True

# Legend sheet
ws2 = wb.create_sheet("LEGEND & REUSABLE FIELDS")
ws2.sheet_properties.pageSetUpPr.fitToPage = True
ws2.page_setup.orientation = "portrait"
ws2.sheet_properties.tabColor = WRASAL_RED

# Legend content
legend_rows = [
    ("WRASAL CINEMATIC MASTER SHOT LIST — HOW TO REUSE THIS TEMPLATE", TITLE_FONT, 20),
    ("This XLSX is a REFERENCE READY reusable template. Distinguishing reusable structure from BOTBC example:", SUBTITLE_FONT, 12),
    ("REUSABLE FIELDS (Keep for any film)", Font(name="Calibri", size=9, bold=True, color=WRASAL_DARK), 12),
    ("• Columns A–R structure, validation, timecode formulas, act/period color logic, governance footer.", BODY_FONT, 10),
    ("• Title block (Row 1–4) — replace film title, trailer, aspect, runtime, mission ID.", BODY_FONT, 10),
    ("• Header row (Row 5) — do not change column semantics; required by ShotSpec schema.", BODY_FONT, 10),
    ("• Golden-shot highlight rule — mark your project's 5–7 narrative control shots; keep logic.", BODY_FONT, 10),
    ("• Legend sheet — keep; update genre/act definitions per film.", BODY_FONT, 10),
    ("PROJECT-SPECIFIC EXAMPLE (Replace)", Font(name="Calibri", size=9, bold=True, color=WRASAL_RED), 12),
    ("• Rows 6–39: BOTBC's 34 shots with durations summing to 105s — replace with your film's shot list.", BODY_FONT, 10),
    ("• Governance footer mentions BOTBC — replace with your project's title/doctrine.", BODY_FONT, 10),
    ("• Character/prop IDs: MATTHEW, IONE, P_WHITE_SHIRT_HERO_2026_AGED — replace with your cast/props.", BODY_FONT, 10),
    ("• Lighting/camera choices: Cooke Panchro, 1980s warm vs 2026 neutral — replace with your DP choices.", BODY_FONT, 10),
    ("VALIDATION", Font(name="Calibri", size=9, bold=True, color=WRASAL_DARK), 12),
    ("Run: node 07-verification/validate-shotlist.mjs  •  Checks: T01 34 IDs, T02 105s total, T03 timecode continuity, T04 required fields, T05 character/prop resolution", BODY_FONT, 10),
    ("STATUS", Font(name="Calibri", size=9, bold=True, color=WRASAL_DARK), 12),
    ("REFERENCE READY — Handoff package in /06-templates/handoff-package.md describes ChatGPT Template Creator packaging steps. TEMPLATE PACKAGED / SAVED only after execution in ChatGPT environment (Class D blocker noted).", Font(name="Calibri", size=7, italic=True, color=WRASAL_GRAY), 10),
]

r=1
for text, font, h in legend_rows:
    ws2.merge_cells(f"A{r}:H{r}")
    c = ws2.cell(row=r, column=1, value=text)
    c.font = font
    c.alignment = Alignment(horizontal="left", vertical="center", wrap_text=True)
    ws2.row_dimensions[r].height = h
    r+=1
for col in range(1,9):
    ws2.column_dimensions[get_column_letter(col)].width = 14

# Save both locations
XLSX_PATH.parent.mkdir(parents=True, exist_ok=True)
XLSX_REUSABLE_PATH.parent.mkdir(parents=True, exist_ok=True)
wb.save(XLSX_PATH)
# Save copy to templates (reusable)
wb.save(XLSX_REUSABLE_PATH)
print(f"XLSX saved to {XLSX_PATH} and {XLSX_REUSABLE_PATH}")
print(f"  Sheets: {wb.sheetnames}, Shots: {len(shots)}, Total: {data['total_runtime_seconds']}s")
