# Horizon Community Collaborative — Production View (HZN-VIS-P00 v002)

**Source:** `PJHZN2.html` (8.9 MB React artifact, second upload — "Dure" revision). Rebuilt for durable production handoff.

## vs Inspector (pjhzn-site)

| Aspect | Inspector (`pjhzn-site`) | Production (`horizon-prod`) |
|---|---|---|
| Purpose | Design QA — 9 pages with metadata, contrast, asset IDs, 3-column inspector | Public site — single-page scroll, marketing copy, real navigation |
| Nav | 9 items HZN-P01..09, left panel | 8 items (Home, About, Project Horizon, Family Services, Programs, Leadership, Careers, Contact) + sticky header, mobile drawer, IntersectionObserver active state |
| Hero | Scrim + kicker + entity chip | Full 16:9 banner + overlay tags + 3 stats (16:9, 1440px, 4.5:1) |
| Content | Wire blocks + program cards | Full prose, 7 pathways, leadership grid, careers listings, contact form with routing |
| Footer | Minimal | 4-col: Visit, Entities, Compliance (WCAG 2.2 AA, 44px, scrim) |

## Extracted truths (second file)

- **Design tokens:** `--plaster #faf7f2`, `--plaster-2 #f2ede6`, `--ink #0F171E`, `--ink-soft #4b5e6b`, `--stone #8b9bb0`, `--line #e8ecef`, `--teal #0A4D4E`, `--teal-wash #e6f3f2`, `--copper #8C4A27`, `--copper-wash #fdf0e8`, `--scrim rgba(15,23,30,0.88)`
- **Typography:** Cinzel 400/500/600/700 + Plus Jakarta Sans 300–700
- **Nav:** 8 anchors, active underline (ink), CTA “Visit”, mobile 2-col drawer
- **Hero:** IMG-HERO-01, “Open Path to Community & Care”, dual-entity blurb (501c3 + for-profit), two CTAs, Light Oak / Soft Plaster tags
- **About:** IMG-ABT-01 21:9, “Built to feel like a good neighbor’s home…”, 8,400 sq ft / 1979 / WCAG AA, oak millwork + terrazzo prose
- **Project Horizon:** HZN-P03, teal, IMG-NP-HERO + 2 cards (Bridge Housing, Resource Centers)
- **Family Services:** HZN-P04, copper, IMG-FP-HERO + 2 cards (Outpatient, Therapy Commons)
- **Programs:** HZN-P05, IMG-DIR-CAT01, 7 pathways (Housing Nav → Unified Intake)
- **Leadership:** HZN-P06, IMG-LEAD-01, 4 cards
- **Careers:** HZN-P07, IMG-CAR-01, 4 jobs, “No AI screening. Human review…”
- **Contact:** HZN-P08/FT, Warm Entry, entity-aware select, HIPAA note
- **Footer:** 2400 Open Path Way, Portland OR 97204, 7:30a–7p / 9a–3p, hello@horizon.community, (503) 555-0142, entities, compliance (WCAG 2.2 AA, 44px, Cinzel+Jakarta)

## Assets
Same 11 webp as inspector (IMG-HERO-01 → IMG-CAR-01, 6.5 MB) — hashes identical (var names rotated by minifier: So/Fo/Uo… = _u/$u/Yo…).

## Structure
```
horizon-prod/
├── index.html          # static production site (no React, no data-URI)
├── styles.css          # tokens + responsive grid
├── assets/*.webp       # 11 photos (file-based, cacheable)
└── original-artifact-v002.html
```

## Run
```sh
python3 -m http.server 3001 --directory horizon-prod
# inspector already on 3000: pjhzn-site
```

Both preserve WEB-G0 HOLD / production NO-GO — replace mocks with licensed originals before launch.
