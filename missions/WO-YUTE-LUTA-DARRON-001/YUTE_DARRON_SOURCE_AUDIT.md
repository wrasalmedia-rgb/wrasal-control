# YUTE™ Digital Human Preservation Engine — Source Discovery & Provenance Audit

- **Document ID:** `YUTE_DARRON_SOURCE_AUDIT`
- **Companion Deliverable:** `YUTE_DARRON_SOURCE_MANIFEST.csv`
- **Version:** `v001`
- **Creation Date:** `2026-11-01`
- **Work Order:** `WO-YUTE-LUTA-DARRON-001`
- **Protocol:** `YUTE-DHPE-001`
- **Milestone:** `YUTE-PILOT-001 | THE HUMAN IDENTITY PASSPORT`
- **Pilot Subject (Real Person):** Darron-Ray Donaldson (`SUBJ-DARRON-RAY-DONALDSON`)
- **Proposed Character Portrayal:** LUTA, King of the Dream Realm (`CHAR-UNDERTAKERS-LUTA` — *WRASAL | THE UNDERTAKERS*)
- **Operating Mode:** Read-Only Public-Source Discovery
- **Lifecycle Status:** `DISCOVERY COMPLETE / PRODUCTION AUTHORIZATION PENDING`

---

## 1. Executive Summary & Subject Verification

On `2026-11-01`, the YUTE Digital Human Preservation Research Agent conducted a polite, read-only public-source inspection of `https://darronray.com/` and its outbound credit references under protocol `YUTE-DHPE-001`.

### 1.1 Subject Confirmation (`[VERIFIED EVIDENCE]`)
- **Confirmed Professional Identity:** `https://darronray.com/` (HTML `<title>`: *"Darron-Ray Donaldson – Actor | Entertainment Freelancer"*) is the official professional portfolio of **Darron-Ray Donaldson**, a commercial actor, model, and talent based in Jamaica.
- **Published Biographical Claims on `darronray.com`:** States that Darron-Ray Donaldson has several years of industry experience working with recording artists including **Stephen Marley** and **Shenseea**, and commercial brands including **MasterCard**, **Digicel**, and **Jamaica National General Insurance**.
- **Corroborated Screen Credits (`[VERIFIED EVIDENCE]`):** Public filmography registries (`imdb.com`, `lightreelfilm.com`, `youtube.com/@UNICEFJamaica`) independently confirm dramatic acting credits including *Spotlight Shorts JA: Absolute Power* (UNICEF Jamaica, 2021), *Exit Wounds* (Dir. Jamar Cleary, 2023, role: Noel), *Behind Closed Doors (A Jamaican Story 2021)* (Dir. Mark Anthony Dean, 2024, role: Dr. Omar), and *From Yard - Sun to City* (role: Trevor).
- **Official Contact Channels (`[VERIFIED EVIDENCE]`):**
  - Direct Email: `darronrayd@gmail.com` (published on `https://darronray.com/` explicitly for creative project inquiries).
  - Official Social Link: `https://www.instagram.com/darron_d/` (`@darron_d`).
  - Representation / Talent Agency: `UNKNOWN` (no talent agent or management company is listed on `darronray.com`; outreach begins via direct email to establish whether talent counsel or an agency represents him).

### 1.2 Core Provenance & Rights Finding
Every single photograph and video showcased on `darronray.com` involves **layered intellectual-property and personality rights**:
1. **Performer Likeness Rights:** Held by Darron-Ray Donaldson (currently **unconsented** for YUTE).
2. **Photographic / Cinematographic Copyrights:** Held by third-party photographers (Adrian McDonald, Gerald Gordon, Kristen Reynolds, Britney Holung, plus at least two uncredited photographers) and music-video/film producers (Sevana / In.Digg.Nation, Stalk Ashley, Boss Lady Muzik / VEVO, UNICEF Jamaica).
3. **Co-Subject & Underlying Artwork Rights:** Several portfolio images contain co-models/co-actors (`SRC-002`, `SRC-016`), photographer watermarks (`@lexonart` in `SRC-002`), editorial face-paint artifacts (`SRC-009`–`SRC-011`), or visible body tattoos (`SRC-016`) carrying separate tattoo-artist copyright considerations.

**Zero images or video frames were copied into any training dataset or committed to repository storage.** Five search-engine-indexed public previews (`SRC-002`, `SRC-009`, `SRC-010`, `SRC-011`, `SRC-016`) were ephemerally inspected during discovery to support descriptive visual analysis and immediately purged from the workspace (`git status` verified clean of third-party media).

---

## 2. Website Architecture, Automated-Access Rules & Terms Audit

| Check | Endpoint / Evidence Inspected | Observed Result (`2026-11-01`) | Epistemic Class | Governance Consequence |
|---|---|---|---|---|
| Primary HTML Root | `https://darronray.com/` | HTTP `200 OK`; single-page portfolio with section anchors (`#`, slides `0`–`4`) | `[VERIFIED EVIDENCE]` | Primary discovery source confirmed |
| Robots Exclusion | `https://darronray.com/robots.txt` | HTTP `404 Not Found` | `[VERIFIED EVIDENCE]` | No `robots.txt` disallow rules published; polite low-rate read-only inspection observed |
| XML Sitemaps | `https://darronray.com/sitemap.xml`, `/wp-sitemap.xml` | HTTP `404 Not Found` | `[VERIFIED EVIDENCE]` | Site operates as single-page static/cached WordPress export without multi-page sitemap |
| WordPress REST API | `https://darronray.com/wp-json/wp/v2/pages`, `/media` | HTTP `404 Not Found` | `[VERIFIED EVIDENCE]` | REST API disabled or static-exported; EXIF/original upload metadata not exposed via JSON |
| Image Delivery CDN | `https://i0.wp.com/darronray.com/wp-content/uploads/...` | Jetpack Photon CDN URLs with `?resize=400,516&ssl=1` thumbnails and `?fit=W,H&ssl=1` target bounds | `[TECHNICAL INFERENCE]` | `fit=W,H` query parameters record WordPress target dimensions where populated (`UNKNOWN` where `fit=,`) |
| Site Terms / License | Footer & page body of `https://darronray.com/` | Footer credits web designer `Nathanael Hay | www.stratuss.art`; **no Terms of Use, Creative Commons license, or AI opt-in statement published** | `[VERIFIED EVIDENCE]` | Default statutory copyright applies (**All Rights Reserved**); zero implied license for AI training or likeness synthesis |
| Restricted Video Link | `https://www.youtube.com/watch?v=_1NO8C-K3uE` (*Simalexia – Love U Bad*) | YouTube returned `"Private video — Please sign in to verify that you may see it"` | `[VERIFIED EVIDENCE]` | Marked `RESTRICTED_PRIVATE_YOUTUBE`; zero authentication bypass attempted |
| Outbound Broken Links | `vogue.it` PhotoVogue link (`SRC-008`), `tribeninestudios.co` (`SRC-012`), `stratuss.art` | `vogue.it` returned HTTP `500`; `tribeninestudios.co` and `stratuss.art` failed network fetch | `[VERIFIED EVIDENCE]` | Recorded transparently; unverified external claims remain `UNKNOWN` |

---

## 3. Portfolio Organization & Collaborator Directory

`darronray.com` organizes Darron-Ray Donaldson's visual portfolio into seven distinct sections:

1. **Biography & Contact Header:** Professional summary, commercial/music client list (Stephen Marley, Shenseea, MasterCard, Digicel, Jamaica National General Insurance), direct email (`darronrayd@gmail.com`), and Instagram (`@darron_d`).
2. **Lexon Art (`www.lexonphotography.com` — Confirmed Live):** 3 editorial photographs (`Quarantine.jpg`, `Magnifi.jpg`, `perf-altered-web.jpg`) credited to Jamaican fine-art and portrait photographer **Adrian McDonald** (`@lexonstories` / `@lexonart`).
3. **Vogue (`www.vogue.it` — PhotoVogue *"Bloom"*):** 3 editorial photographs (`image0.jpeg`, `VOGUE-ITALY-BLOOM-IG-SIZE..jpg`, `IMG_3906.jpg`) credited to photographer **Gerald Gordon** (rendered twice in responsive HTML markup; deduplicated to 3 unique assets `SRC-005`–`SRC-007` plus external link `SRC-008`).
4. **Tribe Nine Studio (`www.tribeninestudios.co`):** 3 commercial lifestyle lookbook photographs (`Photo-from-Darron-Ray-Donaldson1.jpg`, `Photo-from-Darron-Ray-Donaldson.jpg`, `Photo-from-Darron-Ray-Donaldson2.jpg`, titled *Tribe Nine x Wharf 1–3*). Brand credited as **Tribe Nine Studios**; **individual photographer is uncredited (`UNKNOWN`)** on the portfolio page.
5. **Photobunny:** 3 high-resolution WebP editorial portraits (`Photo-bunny-photography_...webp`, `2560x1388` and `1707x2560`) credited to photographer **Kristen Reynolds**.
6. **Gallery:** 4 standalone portfolio photographs:
   - `PSX_20200610_182350-1.jpg` (`1600x2000`, photographer `UNKNOWN`).
   - `JIK2595-1-1.jpg` (resolution `UNKNOWN`, photographer `UNKNOWN`, camera prefix `_JIK`).
   - `Copy of Headshots - Britney Holung photography` (`1497x2297`, photographer **Britney Holung** identified via filename/title metadata).
   - `JIK2374-1-scaled.jpg` (`1709x2560`, photographer `UNKNOWN`, camera prefix `_JIK`).
7. **Showreel & Other Works:**
   - **Showreel Compilation (`SRC-020`):** Mutes original music-video audio for copyright compliance and credits **Takunda Ababio** (`instagram.com/takundaababio/`) for background music; cites 4 source music videos:
     - *Sevana – Justice* (`SRC-021`, 2018, Dir. **Teeqs**, DP **Gabrielle Blackwood**, Prod. **The DrumKeys** / **In.Digg.Nation Collective**).
     - *Simalexia – Love U Bad* (`SRC-022`, currently **Private** on YouTube).
     - *Stalk Ashley – Young* (`SRC-023`, 2019, Dir. `UNKNOWN`).
     - *Tommy Lee Sparta – Monster* (`SRC-024`, 2019, Prod. **Boss Lady Muzik / VEVO**, Dir. `UNKNOWN`).
   - **Other Works (`SRC-025`):** Embedded YouTube short film *Spotlight Shorts JA: Absolute Power* published by **UNICEF Jamaica** (`2021-12-11`, `08:14`, `1920x1080`).

---

## 4. Reference Suitability & Triage Summary

Not all portfolio assets are suitable for digital-human identity preservation, even if licensed. Based on Phase 01 provenance and Phase 02 preview triage, the 29 cataloged records in `YUTE_DARRON_SOURCE_MANIFEST.csv` fall into four operational tiers:

| Priority Tier | Source IDs | Count | Suitability Rationale |
|---|---|---|---|
| **P0 — Discovery Root** | `SRC-001` | 1 | Establishes subject identity, contact channel, and portfolio structure. |
| **P1 — Primary Portfolio Candidates (Conditional on Dual License)** | `SRC-013`, `SRC-014`, `SRC-015`, `SRC-018` | 4 | Named photographers (**Britney Holung** headshot at `1497x2297`; **Kristen Reynolds** portraits up to `2560px`). Must obtain written performer + photographer licenses and request uncompressed originals. |
| **P2 — Secondary / Contextual Study Only (Blocked on Authorship or Normalization)** | `SRC-003`, `SRC-005`, `SRC-006`, `SRC-007`, `SRC-009`, `SRC-010`, `SRC-011`, `SRC-017`, `SRC-019` | 9 | Editorial styling, white midline face/beard paint (`SRC-009`–`SRC-011`), PhotoVogue platform terms (`SRC-005`–`SRC-007`), or uncredited photographer authorship (`SRC-009`–`SRC-011`, `SRC-017`, `SRC-019`). Useful for human visual study; **not clean biometric/texture ground truth** compared to a new WRASAL-commissioned calibrated capture session. |
| **P3 — Do Not Ingest / Provenance Record Only** | `SRC-002`, `SRC-004`, `SRC-008`, `SRC-012`, `SRC-016`, `SRC-020`–`SRC-029` | 15 | Excluded due to co-subjects (`SRC-002`, `SRC-016`), watermarks (`SRC-002`), digital alteration (`SRC-004`), private access (`SRC-022`), third-party music-video/film master copyrights (`SRC-020`–`SRC-025`), social scraping prohibitions (`SRC-026`), or text-only metadata (`SRC-008`, `SRC-012`, `SRC-027`–`SRC-029`). |

### Key Strategic Recommendation from Phase 01
Licensing third-party portfolio photographs requires clearing up to **six separate photographers/brands**, several of whom are uncredited on the site or include editorial paint/retouching. Therefore, while clearing 1–3 existing headshots (starting with Britney Holung `SRC-018` and Kristen Reynolds `SRC-013`–`SRC-015`) is viable for **YUTE Reference Vault** archival provenance, **production-grade identity preservation should commission a dedicated, first-party WRASAL/YUTE calibrated capture shoot directly with Darron-Ray Donaldson** under a clean work-made-for-hire / joint-governance photography agreement where WRASAL owns the capture copyright and Darron-Ray Donaldson retains sovereign likeness authority via his **YUTE Identity Passport™**.
