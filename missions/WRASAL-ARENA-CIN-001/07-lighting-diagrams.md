# 07 — Lighting Diagrams (Text)

Conventions: top-down plans; `CAM` at 0°; angles screen-space (90° = camera-right, 270° = camera-left). Ratios are key:fill at subject face. Kelvin = correlated color temperature. All sources motivated per `03` §3.4.

---

## LT-A — SHOT-A (soft daylight intimacy)

```
                        BACKGROUND: dune field @ -1.0 stop (P-01)
                                     |
                                     |
        KEY: diffused sun equiv.     |
        1.2 m soft source            |
        5200 K, 45° cam-left         |
        (221 deg plan)               |
                 \                   |
                  \  45 deg          |
                   \                 |
                    v                |
      [NEG 4x4 @270deg,   CH-01  ===bow axis==> 270 deg
       2 m, edge control]  (1.35 m)
                    ^                |
                   /  fill 315 deg: sand bounce (natural)
                  /   + 1/4 white card 1.5 m cam-right
        RATIO 2.5:1 at face          |
                                     |
                        CAM 0 deg | 85 mm T2.8 | eye 1.35 m
                                     |
                        CH-02 torso @ 60 deg, 1.2 m, OOF (P-04)
```
- Key quality: shadowless-soft (source ≈ 8× face size); brow shadow absent; single catchlight per eye, cam-left.
- Front elevation: key center at +20° above eye line; fill at −10° (ground bounce feel).
- Exposure: face key = T2.8 @ ISO 800 equiv.; background −1 stop; mentor robe falls to P-04 naturally (no flag needed).

## LT-B — SHOT-B (fire vs. dusk, two temperatures)

```
        ZENITH: dusk sky 9000 K, -3 stops vs fire pools (top fill only)
                                     |
   adobe wall L (P-06)               |              adobe wall R (P-06)
        |                            |                     |
        |     FIRE POOL 1            |        FIRE POOL 2 (cart)
        |     1900-2200 K            |        1900-2200 K, wheel rim-first
        |     @270deg fg-left        |        @90deg mid-right
        |         \                  |                /
        |          \  flicker 6-9 Hz |  natural      /
        |           v                v              v
        |        CH-05 crawl axis 270 deg <==================
        |           ^                |
        |           | rim from pool 1 (edge on robe, P-08 tint)
        |                            |
        |   ANOM-01 @ 0 deg, 60-80 m: slit P-09 cool white,
        |   NO spill on street; body #1A1F23 vs sky P-05
        |                            |
                        CAM 0 deg, -12 deg tilt | 32 mm T4 | 0.6 m
```
- Ratio: 6:1 within fire pools; street between pools −2.5 stops; sky −3 stops.
- Flicker: natural turbulence 6–9 Hz, non-periodic; **never** synced to shutter harmonics (QC-204).
- Smoke: backlit by pools → volumetric glow layers; density ramp fg→bg increasing.
- Negative: no blue moonlight key; no fire on roofs; no slit spill.

## LT-C — SHOT-C (hard low backlight through haze)

```
        SUN: 3200 K effective, elev ~8 deg, az ~20 deg cam-right
        disc IN FRAME (soft edge via haze)  ( P-11 )
                   \                       |
                    \   backlight 45-70 deg rim on hair/jaw (P-12, P-18)
                     v                     |
        haze field P-10 uniform  <==== CH-03 profile facing 90 deg
                     ^                     |
                    /  fill: SKY BOUNCE ONLY (no card, no bounce)
                   /   ratio ~5:1; frontal value P-17 (legal near-black)
        CAM 0 deg | 85 mm T4 | 1.55 m | halation ON (red-edge, <=1.5% h)
```
- Flare policy: gentle halation + veiling glow lower-right; **no** anamorphic streaks, **no** ghost rings (QC-205).
- Rim width: 1–2% frame width on hair mass; jaw rim continuous.
- Exposure: haze field at +1.5 stops over middle gray; sun disc clipped (only legal full clip).

## LT-D — SHOT-D (expose-for-sky silhouette)

```
        SUN: fully hidden behind dust wall (no disc, no direct ray)
        SKY LUMINANCE RAMP:
          lower-left  P-15 (glow, +2.5 stops over mid)
          mid field   P-13 (mid red, key value)
          upper-right P-14 (deep mass, -2 stops)
                                     |
        cloud boil <= 2% frame/s     |
                                     |
        RIDER+HORSE @ crest: -6...-8 stops vs sky => P-16 silhouette
        cape 270 deg | plume 270 deg | hind hooves planted
                                     |
                        CAM 0 deg, -8 deg tilt | 75-100 mm T5.6-T8 | locked
```
- Edge policy: silhouette outline crisp (no glow fringe > 0.3% frame width); crest line clean against glow zone.
- No fill of any kind on subject (QC-206): any readable detail on rider/horse = fail.
- Dust plume lit by glow zone (P-15 tint), drift 270°.

---

## 7.5 Package light continuity rules

1. One motivated source family per shot (`03` §3.4); B is the only two-temperature shot.
2. Backlight escalation A(none) → B(fire rim) → C(sun rim) → D(total silhouette).
3. Black-point warmth constant: lift tint ≈ +2 IRE warm across package.
4. Practical sources must show interaction: firelight on smoke, sun rim on hair, glow on plume (QC-207).
