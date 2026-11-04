# WO-HZN-WEB-001 — Project Horizon Platform (1440px Desktop)

**Executive Overview:** The 1440px desktop view for the **Project Horizon & Horizon Family Services Combined Web Platform** is fully rendered, incorporating all 11 design tokens, WCAG 2.2 AA accessibility specs, and the dual non-profit / for-profit visual branding `#0A4D4E` Deep Teal vs `#8C4A27` Warm Copper. This document details the multi-frame presentation structure and export specifications for client review.

See: `docs/HORIZON_DESKTOP_FRAME_STRATEGY.md` (canonical) and `exports/manifest.json` for machine-readable frame specs.

## Quick Export

1. `python3 -m http.server 3000 --directory pjhzn-site` → open `mockup_viewer.html`
2. Toggle **Desktop (1440px)**
3. Click pages 01→09 in left sidebar
4. Capture @2x PNG (2880px wide) per frame for deck

All frames: **1440×900 viewport**, scrim `rgba(15,23,30,0.88)` / `0.85`, Deep Teal `#0A4D4E` / Warm Copper `#8C4A27`.

**Aliases:** `image_3.png` → `IMG-LEAD-01.webp`, `image_5.png` → `IMG-FP-HERO.webp`, `image_6.png` → `IMG-NP-HERO.webp`, `image_7.png` → `IMG-CAR-01.webp`, `image_8.png` → `IMG-HERO-01.webp`, `image_9.png` → `IMG-ABT-01.webp` — symlinked in `*/assets/` for export tooling parity.
