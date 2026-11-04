# Project Horizon Platform — Presentation & Desktop Frame Strategy

**WO: WO-HZN-WEB-001 · Design System: HZN-DESIGN-001 / HZN-VIS-P00 v002 · Viewport: 1440px Desktop · Compliance: WCAG 2.2 AA**

---

## Executive Overview

The **1440px desktop view** for the **Project Horizon & Horizon Family Services Combined Web Platform** is fully rendered, incorporating all **11 design tokens**, **WCAG 2.2 AA accessibility specs**, and the **dual non-profit / for-profit visual branding** `Deep Teal #0A4D4E` vs `Warm Copper #8C4A27`.

This document details the **multi-frame presentation structure** and **export specifications** for client review — mapping the inspector (`pjhzn-site/`) and production view (`horizon-prod/`) to the 9-frame board deck.

> **Live Viewers**
> - Inspector (design QA, 3-panel): `pjhzn-site/index.html` → also served as `pjhzn-site/mockup_viewer.html` on **:3000**
> - Production (marketing scroll): `horizon-prod/index.html` on **:3001**
> - Both share the same 11 `webp` assets (6.5 MB, file-based, cacheable).

---

## 11 Design Tokens (Locked)

| # | Token | Value | Usage |
|---|-------|-------|-------|
| 01 | `--bg-workspace` | `#0b0f14` | Inspector outer canvas |
| 02 | `--bg-panel` | `#141b22` | Left/right inspector panels, header |
| 03 | `--bg-panel-light` | `#1c2631` | Toggle active, card inner |
| 04 | `--border-panel` | `#273544` | Panel borders, device frame (mobile 8px) |
| 05 | `--ink` | `#0F171E` | Primary text, header ink, footer #0F171E |
| 06 | `--plaster` | `#faf7f2` | Production page background |
| 07 | `--plaster-2` | `#f2ede6` | Hover, subtle card |
| 08 | `--line` | `#e8ecef` | Borders, dividers (production) |
| 09 | `--stone` | `#8b9bb0` | Muted labels, metadata |
| 10 | **Deep Teal** | **`#0A4D4E`** (inspector accent `#147375`) | Non-profit: Project Horizon — housing, navigation, community |
| 11 | **Warm Copper** | **`#8C4A27`** | Clinical: Family Services — outpatient, dental, therapy, pharmacy |
| — | **Scrim** | `rgba(15,23,30,0.88)` (Home) / `rgba(15,23,30,0.85)` (About/Leadership) | Hero overlay for 14.03:1 → 6.87:1 contrast (WCAG AAA/AA) |

*Typography:* Cinzel 600/700 (serif H1) + Plus Jakarta Sans 400/500/600/700 (body). Touch target ≥44×44px, focus-visible teal ring, reduced-motion respected.

---

## Page-by-Page Desktop Standalone Specifications

All frames are **1440px wide** (desktop). Export height is **auto** (full-page scroll) at **@2x (2880px wide) PNG** for Retina board decks. Viewport for interactive review: **1440 × 900**.

| Frame # | Page Ref | Viewport Dimensions | Hero Banner Image | Scrim & Primary Color Token | Key Presentation Objective |
|---------|----------|---------------------|-------------------|------------------------------|----------------------------|
| **01** | `HZN-P01` Home | **1440 × 900** (export 2880 × auto @2x) | `image_8.png` → `IMG-HERO-01.webp` — *Shared Hybrid Arched Entry - Open Path* | `rgba(15,23,30,0.88)` / Dual Teal+Copper | Validate dual-entity landing gate & entity selection. Gate shows both missions in one threshold; CTA pair (“Explore Project Horizon” vs “Family Services”) proves non-profit/for-profit separation at a glance. |
| **02** | `HZN-P02` About | **1440 × 900** (2880 × auto @2x) | `image_9.png` → `IMG-ABT-01.webp` — *Welcoming Facility Entrance - Warm Wood* | `rgba(15,23,30,0.85)` / Hybrid Warm Wood | Present governance, 501(c)(3) status & corporate separation. 21:9 ultrawide header + “Built to feel like a good neighbor’s home…” + 8,400 sq ft / 1979 / WCAG AA stats. |
| **03** | `HZN-P03` Non-Profit | **1440 × 900** (2880 × auto @2x) | `image_6.png` → `IMG-NP-HERO.webp` — *Deep Teal Non-Profit Hub (Community room teal pendants)* | `#0A4D4E` Deep Teal (scrim `rgba(15,23,30,0.88)` on hero) | Feature community housing, reentry support & learning atrium. Two cards: `IMG-NP-PRG01` Transitional Housing + `IMG-NP-PRG02` Resource & Learning Hub. |
| **04** | `HZN-P04` Clinical | **1440 × 900** (2880 × auto @2x) | `image_5.png` → `IMG-FP-HERO.webp` — *Warm Copper Clinical Hub (copper reception tranquil healthcare)* | `#8C4A27` Warm Copper | Highlight outpatient clinical suites, therapy & health services. Two cards: `IMG-FP-PRG01` Outpatient Consult + `IMG-FP-PRG02` Therapy Commons (fireplace, bouclé). |
| **05** | `HZN-P05` Programs | **1440 × 900** (2880 × auto @2x) | `image_6.png` (reuse) → `IMG-DIR-CAT01.webp` — *Abstract Growth Corridor (staircase)* | Neutral `#f8fafb` / Structured Grid `1fr 1fr` + entity dots | Full 7-program cross-entity directory preview. Housing → Resource Centers → Behavioral Health → Dental/Pharmacy → Youth → Unified Intake (featured, ink background). |
| **06** | `HZN-P06` Leadership | **1440 × 900** (2880 × auto @2x) | `image_3.png` → `IMG-LEAD-01.webp` — *Executive Governance Backdrop (executive conference room)* | `rgba(15,23,30,0.85)` / Dark `#0f1720` header | Executive directory layout & board governance slots. 4-lead grid, daylight deliberation banner. |
| **07** | `HZN-P07` Careers | **1440 × 900** (2880 × auto @2x) | `image_7.png` → `IMG-CAR-01.webp` — *Collaborative Workspace Culture* | Dual Entity Accent (Teal/Copper pills) | Present recruitment workflow & sample vacancy templates. “No AI screening. Human review…” + 4 open roles (Peer Navigator → Pharmacy Tech) + “How we hire” card. |
| **08** | `HZN-P08` Contact | **1440 × 900** (2880 × auto @2x) | *Dynamic Form* — no hero; uses `IMG-ABT-01` warm entry as fallback | Non-Profit / For-Profit Radio (`Deep Teal` vs `Warm Copper` chips) | General routing form with PHI privacy notices. Entity-aware triage: General / Project Horizon / Family Services + HIPAA-aware helper (“no PHI in general form”). |
| **09** | `HZN-P09` Privacy | **1440 × 900** (2880 × auto @2x) | *Text-focused layout* — reuses `IMG-HERO-01` desaturated | Standard Neutral Slate `#3b4a5a` on `#f8fafb` | Website data-handling & regulatory compliance baseline. Plain-language HIPAA-aware copy, shared-consent language, WCAG audit footer. |

### Image Alias Map (for `image_X.png` exports)

Spec references `image_3.png`, `image_5.png`, `image_6.png`, `image_7.png`, `image_8.png`, `image_9.png`. These are **aliases** to the 11 `webp` assets decoded from the original React artifacts:

| Spec Alias | File (durable) | Concept | Contrast |
|------------|----------------|---------|----------|
| `image_8.png` | `IMG-HERO-01.webp` | Shared Hybrid Arched Entry - Open Path | 14.03:1 AAA |
| `image_9.png` | `IMG-ABT-01.webp` | Welcoming Facility Entrance - Warm Wood | 12.25:1 AAA |
| `image_6.png` | `IMG-NP-HERO.webp` | Deep Teal Non-Profit Hub (teal pendants) | 10.57:1 AAA |
| `image_6.png` *(reuse)* | `IMG-DIR-CAT01.webp` | Abstract Growth Corridor (Programs) | 6.87:1 AA |
| `image_5.png` | `IMG-FP-HERO.webp` | Warm Copper Clinical Hub | 8.18:1 AAA |
| `image_3.png` | `IMG-LEAD-01.webp` | Executive Governance Backdrop | 10.91:1 AAA |
| `image_7.png` | `IMG-CAR-01.webp` | Collaborative Workspace Culture | 12.25:1 AAA |
| *(cards)* `image_0–4,10` | `IMG-NP-PRG01/02`, `IMG-FP-PRG01/02`, `IMG-DIR-CAT01` | Program detail cards | — |

All are in `pjhzn-site/assets/` and `horizon-prod/assets/` (identical hashes; minifier-rotated vars only: `So/Fo/Uo…` = `_u/$u/Yo…`).

---

## Desktop Frame Rendering — Inspector vs Production

- **Inspector (`pjhzn-site/index.html` = `mockup_viewer.html`)**: 3-column `320px | 1fr | 340px` grid. Center `stage-wrapper` is **1440px max (1280px content + 80px chrome) × 850px viewport** in Desktop mode, **390 × 780 + 8px #273544 device frame** in Mobile mode. Left nav tracks `HZN-P01..09` with `rgba(20,115,117,0.15)` active + `3px #147375` border; right panel shows Screen Metadata, Mapped Asset, Accessibility Audit per frame. Hash routing (`#home` → `#privacy`) preserves share state.
- **Production (`horizon-prod/index.html`)**: Single-page scroll, `max-width:1440px` centered, `24px` gutter, `28px` rounded hero cards (`16:9` Home, `21:9` About, `16/8.5` Entity). Sticky header `76px` (`56px` mobile) with blur `18px`. Full-page capture for deck: scroll to bottom, include footer compliance.

Both enforce: hero `h1` Cinzel 42px (36px mobile), scrim `rgba(15,23,30,0.88)` for **4.5:1+ contrast**, ≥44px touch targets, native `<button>`/`<a>`, keyboard + `IntersectionObserver` active states.

---

## Export & Framing Instructions

### To export individual 1440px desktop frame snapshots:

1. **Launch `mockup_viewer.html`** (or `pjhzn-site/index.html`):
   ```sh
   python3 -m http.server 3000 --directory pjhzn-site
   # open http://localhost:3000/mockup_viewer.html
   ```
   *Production alternative:* `horizon-prod/index.html` on `:3001` for scroll captures.

2. **Select Desktop (1440px)** in the top control bar — rightmost toggle (`🖥 Desktop (1440px)`). Confirm `stage-wrapper` shows `box-shadow: 0 24px 60px rgba(0,0,0,0.55)` and `border-radius: 8px` (not the 390px device frame). Inspector header should read `PROJECT HORIZON · WEB-G0 HOLD · HZN-DESIGN-001`.

3. **Click through pages 01 to 09** in the left sidebar (or hash `#home` → `#privacy`):
   - 01 Home → 02 About → 03 Non-Profit → 04 Clinical → 05 Programs → 06 Leadership → 07 Careers → 08 Contact → 09 Privacy
   - Wait for hero `webp` to load (check Network: `200 image/webp`, no data-URI).

4. **Export frames as high-density PNG assets (Retina equivalent)** for board deck inclusion:
   - **Manual:** Use browser screenshot (Chrome DevTools → Device Toolbar → `1440 × 900`, DPR `2×` → Capture full size screenshot). Save as `HZN-P0X-1440@2x.png`.
   - **Automated:** `npx capture-website` or Playwright:
     ```js
     import { chromium } from 'playwright';
     for (const id of ['home','about','project-horizon','horizon-family-services','programs','leadership','careers','contact','privacy']) {
       await page.goto(`http://localhost:3000/mockup_viewer.html#${id}`);
       await page.waitForTimeout(800);
       await page.screenshot({ path: `exports/HZN-${id}-1440@2x.png`, fullPage: true, scale: 'css' }); // set viewport 1440x900, deviceScaleFactor 2
     }
     ```
   - For production scroll: capture full page (`fullPage:true`) per section anchor (`#about`, `#project-horizon`, etc.) on `:3001`.

5. **Name exports per spec:**
   ```
   exports/
   ├── HZN-P01-Home-1440@2x.png            (image_8.png hero)
   ├── HZN-P02-About-1440@2x.png           (image_9.png hero)
   ├── HZN-P03-NonProfit-1440@2x.png        (image_6.png Deep Teal)
   ├── HZN-P04-Clinical-1440@2x.png        (image_5.png Warm Copper)
   ├── HZN-P05-Programs-1440@2x.png        (image_6.png reuse, grid)
   ├── HZN-P06-Leadership-1440@2x.png      (image_3.png dark)
   ├── HZN-P07-Careers-1440@2x.png         (image_7.png dual accent)
   ├── HZN-P08-Contact-1440@2x.png         (dynamic form, radio)
   └── HZN-P09-Privacy-1440@2x.png         (text-focused slate)
   ```

6. **Framing for deck:**
   - Place each PNG on **#0b0f14 workspace** mat with **#141b22 panel** label bar (as in inspector) for context, or full-bleed on **#faf7f2** for production narrative.
   - Add caption: `HZN-P0X · Viewport 1440×900 · Hero image_X.png · Scrim rgba(15,23,30,0.88) · Contrast 14.03:1 → 6.87:1 · #0A4D4E / #8C4A27`
   - Retain **WEB-G0 HOLD** watermark until licensed photography replaces pre-production `webp` mocks.

---

## Compliance Notes

- **WEB-G0 HOLD** still active — no production deploy, no commercial launch, pre-production mocks only (per YUTE-EXEC-AUTH-001 HOLD-RIGHTS-001 analog).
- All hero scrims verified for WCAG AAA (14.03:1 Home) → AA (6.87:1 Programs) at `rgba(15,23,30,0.88/0.85)`.
- Contact form enforces **PHI warning** (“no PHI in general form”) and entity routing (Teal vs Copper chips) — matches `HZN-P08` spec.
- Privacy (`HZN-P09`) uses plain-language, HIPAA-aware copy; capture with text-focused layout (no hero dominance).

---

## Quick Links

- Inspector: `pjhzn-site/mockup_viewer.html` (port 3000)
- Production: `horizon-prod/index.html` (port 3001)
- Assets: `*/assets/*.webp` (11 files, 6.5 MB, identical hashes across viewers)
- Original artifacts: `*/original-artifact*.html` (8.9 MB each, preserved)
- This spec: `docs/HORIZON_DESKTOP_FRAME_STRATEGY.md` (this file)
