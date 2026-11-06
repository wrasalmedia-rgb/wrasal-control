# Prompt Authoring Template (reusable guide)

Use for any new shot in any sequence of this visual grammar. Fill in order; do not skip blocks; keep prose flowing (models read prose, not bullets).

## T2V assembly (order fixed)

1. **STYLE** — package style prefix, verbatim: `Photorealistic live-action cinema, 2.39:1, 24 fps, 1/48 s motion blur.`
2. **FRAME/LENS** — size, angle, height, focal, stop, focus plane, DoF intent (translate via `08` §8.6).
3. **SUBJECT+WARDROBE** — character lock description (age band, features, wardrobe bible items, prop locks).
4. **BEAT VERBS** — ordered micro-actions with amplitudes and time shares (`09` grammar: verb chains, one register).
5. **ENVIRONMENT** — paste the ENV gen prompt block from `06`.
6. **LIGHT** — source, kelvin, plan/elevation, ratio, rim, halation policy; state what must NOT light anything.
7. **CAMERA MOVE** — move + amplitude + settle behavior; horizon policy.
8. **TEXTURE/GRAIN** — pore/fabric/sand detail, grain class, halation; explicit `no smoothing`.
9. **PHYSICS LOCKS** — verbatim from shot DNA `physics_locks`.

Attach negatives: `N-GLOBAL` + shot set. Log: model, version, seed, params, prompt hash.

## I2V assembly (order fixed)

`Animate this exact frame as photorealistic live-action cinema, 24 fps, 1/48 s motion blur, 2.39:1 preserved.` then:
- `MOVE:` animated elements + amplitudes + beat order.
- `HOLD:` frozen geometry/values/framing/defocus (from shot DNA `locked_elements`).
- `CAM:` move + amplitude.
- `AMP:` LOW|MED|HIGH.
- `PHYS:` physics locks verbatim.
- `ABSOLUTE:` hard bans (text, silhouette breach, exposure fixes…).
- `Texture:` preservation notes + grain.

Plate rules: only approved locks; prep-clean (subtitle inpaint for C); checksum logged.

## Quality bar while writing

- Every adjective must map to a DNA field; if it doesn't, cut it or add the field.
- Prefer measurable phrasing: degrees, stops, percent-of-frame, seconds, Beaufort, kelvin.
- One emotional register per shot; state it once.
- Negatives are mirrored as QC rejection criteria — never rely on prompt support alone (CAP-04).
- Length budget: ≤1500 chars per model call; if over, compress ENV block first, never physics locks.

## Pre-flight (before any batch)

- [ ] CAP ids invoked by this prompt are VERIFIED in `data/capability_matrix.json` (QC-900).
- [ ] Plate checksum matches manifest.
- [ ] Negatives attached; delivery mode chosen per `12` §12.5.
- [ ] Batch size set (G2 ≥6, G3 ≥12) and log fields ready.
- [ ] Human gate status allows generation at this stage (G1 for look-dev stills→motion tests, G2 for finals).
