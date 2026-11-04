# Project Horizon — WEB-G0 Interactive Mockup Inspector

**Rebuilt from `PJHZN.html` React artifact (single-file data-URI bundle) into production-handoff structure.**

## What was recovered

- **9 Core Platform Pages** (WO-HZN-WEB-001, HZN-DESIGN-001) extracted from minified `qr` array:
  - HZN-P01 Home — Shared Hybrid Arched Entry (IMG-HERO-01, 14.03:1 AAA)
  - HZN-P02 About Us — Warm Wood Entrance (IMG-ABT-01, 12.25:1 AAA)
  - HZN-P03 Project Horizon — Deep Teal Non-Profit Hub (#0A4D4E, 10.57:1)
  - HZN-P04 Family Services — Warm Copper Clinical Hub (#8C4A27, 8.18:1)
  - HZN-P05 Programs — Abstract Growth Corridor (IMG-DIR-CAT01, 6.87:1 AA)
  - HZN-P06 Leadership — Executive Governance (IMG-LEAD-01, 10.91:1)
  - HZN-P07 Careers — Collaborative Workspace (IMG-CAR-01, 12.25:1)
  - HZN-P08 Contact — Warm Entry routing (IMG-ABT-01)
  - HZN-P09 Privacy — Data Handling Transparency (IMG-HERO-01)

- **11 photographic assets** decoded from base64 `data:image/webp` → `assets/*.webp` (6.5 MB total), mapped:
  - `IMG-HERO-01`, `IMG-ABT-01`, `IMG-NP-HERO`, `IMG-NP-PRG01`, `IMG-NP-PRG02`, `IMG-FP-HERO`, `IMG-FP-PRG01`, `IMG-FP-PRG02`, `IMG-DIR-CAT01`, `IMG-LEAD-01`, `IMG-CAR-01`

- **Design tokens preserved**:
  - Workspace #0b0f14, Panel #141b22/#1c2631, Border #273544, Accent Teal #147375, Accent Gold #d97706
  - Serif: Cinzel 600/700, Sans: Plus Jakarta Sans 400/500/600/700
  - Scrim rgba(15,23,30,0.88), ≥44px touch targets, focus-visible teal ring, WCAG 2.2 AA verified

## Structure (vs. original)

Original: single-file React 18 + Tailwind blob (9.2 MB HTML, 9.2 MB module script, data-URIs inline) — unshareable, slow, opaque.

Rebuilt:
```
pjhzn-site/
├── index.html          # semantic, accessible, hash-routed shell
├── styles.css          # tokenized, responsive, no Tailwind runtime
├── app.js              # vanilla JS router + renderer (hash, arrow keys)
├── assets/*.webp       # 11 optimized photos (file-based, cacheable)
└── original-artifact.html  # source preserved
```

## Inspector features

- **Left**: 9-page nav with HZN-P01..P09 codes, active teal highlight, keyboard + hash routing
- **Center**: Stage wrapper — Desktop (1280×850, full) / Mobile (390×780, 8px device frame, 32px radius) — hero with scrim, entity theming (teal/copper), program cards, footer
- **Right**: Screen Metadata, Mapped Asset (preview + LOCAL badge), Accessibility Audit (contrast, scrim, touch target)
- **Header**: PROJECT HORIZON wordmark, WEB-G0 HOLD badge, Desktop/Mobile toggle, WO-HZN-WEB-001 label

## Accessibility & production

- Native `<button>` navigation, `aria-pressed`, alt text from asset names, contrast ratios shown per page
- All interactive ≥44×44px, sticky header/stage bar, hash URL for shareable deep links
- No data-URI bloat, no React runtime, <30 KB JS/CSS (excluding images)

## Run

```sh
python3 -m http.server 3000 --directory pjhzn-site
# or
npm run dev  # if Vite added later
```

Open http://localhost:3000 — use arrow keys or sidebar to navigate, toggle Desktop/Mobile in header.

## Next steps

- Replace pre-production `webp` with licensed originals before public launch (WEB-G0 HOLD still active)
- Add Figma links, dev handoff specs (spacing, breakpoints), and Storybook if needed
- Verify HIPAA/plain-language copy for Privacy page with legal

