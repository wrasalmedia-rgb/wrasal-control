"""Generate the non-sensitive synthetic stand-in used for the CAL001 dry-run.

The stand-in is produced entirely locally with deterministic code. It contains
no real person, no photographic capture of a human, and no sexual content: two
abstract draped forms (mannequin-like) standing in contact, in a night interior
with a window opening and curtain columns.

Its purpose is to validate, with ground truth, that:
  * the masking route recovers a two-person union mask,
  * the protected window opening survives byte-exact,
  * the protected subject pixels survive byte-exact,
  * the composite shows no halo / spill at the subject boundary.

Outputs
  standin_source.png   composite "before" frame (HxWx3 uint8, PNG lossless)
  standin_gt_mask.png  ground-truth union subject alpha (HxW uint8)
  standin_geometry.json window rect, figure rects, edit region polygon
"""

from __future__ import annotations

import os
import sys

import cv2
import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from cal001_lib import write_json, write_png  # noqa: E402

W, H = 1152, 1536
SS = 2  # supersampling factor for anti-aliased edges
SEED = 20261111

# --- scene geometry (in final-frame pixel coordinates) -------------------
WINDOW = (548, 196, 934, 768)          # x0, y0, x1, y1
LEFT_CURTAIN = (36, 0, 536, 1180)
RIGHT_CURTAIN = (946, 0, 1152, 1180)
WALL_BAND_TOP = (0, 0, 1152, 196)      # upper wall above the window head
EDIT_REGION = (0, 0, 1152, 1180)        # curtains + upper wall only


def _blob(cx, cy, rx, ry, rot=0.0):
    """Closed elliptical polygon points for a body part."""
    t = np.linspace(0, 2 * np.pi, 160, endpoint=False)
    x = rx * np.cos(t)
    y = ry * np.sin(t)
    xr = x * np.cos(rot) - y * np.sin(rot)
    yr = x * np.sin(rot) + y * np.cos(rot)
    return np.stack([cx + xr, cy + yr], axis=1)


def _figure_alpha(shape, parts):
    """Rasterise a list of (points, value) into an alpha map.

    Points are already expressed in supersampled frame coordinates.
    """
    alpha = np.zeros(shape, dtype=np.float32)
    for pts, value in parts:
        cv2.fillPoly(alpha, [np.round(pts).astype(np.int32)], float(value))
    return alpha


def build_scene():
    rng = np.random.default_rng(SEED)
    s = SS

    # ---------------- background --------------------------------------
    bg = np.zeros((H * s, W * s, 3), dtype=np.float32)
    yy = np.linspace(0.0, 1.0, H * s, dtype=np.float32)[:, None]
    xx = np.linspace(0.0, 1.0, W * s, dtype=np.float32)[None, :]

    # upper wall: deep oxblood / charcoal vertical gradient
    wall_top = np.array([38, 24, 26], dtype=np.float32)
    wall_bot = np.array([22, 16, 19], dtype=np.float32)
    wall = wall_top[None, None, :] * (1 - yy[..., None]) + wall_bot[None, None, :] * yy[..., None]
    wall = np.repeat(wall, W * s, axis=1)

    # lower room (bed / floor) — kept out of the edit region
    floor = np.array([16, 12, 14], dtype=np.float32)
    wall[H * s * int(0.77):] = floor

    # soft wall vignette
    vig = 1.0 - 0.45 * (((xx - 0.5) * 1.6) ** 2 + ((yy - 0.32) * 1.15) ** 2)
    wall = np.clip(wall * np.clip(vig, 0.25, 1.0)[..., None], 0, 255)

    # curtain columns: matte charcoal with vertical folds
    def curtain(x0, x1, tint):
        x0s, x1s = x0 * s, x1 * s
        cw = x1s - x0s
        cx = np.linspace(0.0, 1.0, cw, dtype=np.float32)
        folds = 0.5 + 0.5 * np.sin(cx * np.pi * 2.0 * 7.0 + 0.6)
        folds = folds ** 1.7
        shade = (0.35 + 0.65 * folds)[None, :, None]
        col = np.array(tint, dtype=np.float32)[None, None, :] * shade
        col = np.repeat(col, H * s, axis=0)
        # drape falloff toward the floor
        fall = np.clip(1.15 - 0.75 * yy, 0.30, 1.0)[..., None]
        return np.clip(col * fall, 0, 255)

    wall[:, LEFT_CURTAIN[0] * s:LEFT_CURTAIN[2] * s] = curtain(LEFT_CURTAIN[0], LEFT_CURTAIN[2], (46, 44, 50))
    wall[:, RIGHT_CURTAIN[0] * s:RIGHT_CURTAIN[2] * s] = curtain(RIGHT_CURTAIN[0], RIGHT_CURTAIN[2], (44, 42, 48))

    # window opening: cool daylight
    wx0, wy0, wx1, wy1 = [v * s for v in WINDOW]
    gy = np.linspace(0.0, 1.0, wy1 - wy0, dtype=np.float32)[:, None]
    gx = np.linspace(0.0, 1.0, wx1 - wx0, dtype=np.float32)[None, :]
    glow = 150 + 70 * (1.0 - gy) + 30 * np.sin(gx * np.pi)
    pane = np.array([196, 214, 236], dtype=np.float32)[None, None, :] * glow[..., None] / 255.0
    wall[wy0:wy1, wx0:wx1] = pane

    # window frame / mullion (geometry that must be preserved)
    frame = np.array([26, 22, 24], dtype=np.float32)
    mull = 14 * s
    wall[wy0:wy0 + mull, wx0:wx1] = frame
    wall[wy1 - mull:wy1, wx0:wx1] = frame
    wall[wy0:wy1, wx0:wx0 + mull] = frame
    wall[wy0:wy1, wx1 - mull:wx1] = frame
    wall[wy0:wy1, (wx0 + wx1) // 2 - mull // 2:(wx0 + wx1) // 2 + mull // 2] = frame
    wall[(wy0 + wy1) // 2 - mull // 2:(wy0 + wy1) // 2 + mull // 2, wx0:wx1] = frame

    bg = wall.copy()

    # ---------------- figures ----------------------------------------
    # Abstract draped forms. Deliberately non-photographic and non-sexual:
    # smooth cloth-like volumes, neutral tones, no anatomical detail.
    fig_a_parts = [
        (_blob(392 * s, 560 * s, 108 * s, 150 * s), 1.0),          # torso
        (_blob(392 * s, 372 * s, 56 * s, 70 * s), 1.0),           # head
        (_blob(300 * s, 560 * s, 52 * s, 150 * s, rot=0.16), 1.0),  # arm L
        (_blob(486 * s, 566 * s, 48 * s, 140 * s, rot=-0.14), 1.0),  # arm R
        (_blob(352 * s, 860 * s, 70 * s, 180 * s), 1.0),           # leg L
        (_blob(438 * s, 858 * s, 66 * s, 178 * s), 1.0),           # leg R
    ]
    fig_b_parts = [
        (_blob(664 * s, 640 * s, 100 * s, 140 * s), 1.0),
        (_blob(660 * s, 468 * s, 52 * s, 66 * s), 1.0),
        (_blob(584 * s, 636 * s, 46 * s, 132 * s, rot=-0.12), 1.0),
        (_blob(746 * s, 640 * s, 44 * s, 128 * s, rot=0.12), 1.0),
        (_blob(630 * s, 906 * s, 62 * s, 166 * s), 1.0),
        (_blob(706 * s, 906 * s, 58 * s, 164 * s), 1.0),
    ]

    shape = (H * s, W * s)
    alpha_a = _figure_alpha(shape, fig_a_parts)
    alpha_b = _figure_alpha(shape, fig_b_parts)
    alpha = np.clip(alpha_a + alpha_b, 0, 1)
    # contact overlap between the two figures (union, so the mask stays a union)
    alpha = np.clip(alpha + 0.0, 0, 1)

    # figure shading: warm red ambient from the left, cool window light from the right
    skin = np.zeros((H * s, W * s, 3), dtype=np.float32)
    warm = np.array([188, 146, 122], dtype=np.float32)
    cool = np.array([196, 198, 206], dtype=np.float32)
    lightmix = np.clip((xx - 0.33) / 0.42, 0, 1)[..., None]
    body = warm[None, None, :] * (1 - lightmix) + cool[None, None, :] * lightmix
    form = 0.72 + 0.38 * np.clip(1.0 - np.abs(yy - 0.40) * 1.5, 0.2, 1.0)[..., None]
    skin[:] = np.clip(body * form, 0, 255)

    bg = bg * (1 - alpha[..., None]) + skin * alpha[..., None]

    # ---------------- lighting pass ----------------------------------
    # red ambient wash from the left wall, cool spill from the window
    red_wash = np.clip(1.0 - xx / 0.62, 0, 1) ** 1.7 * 0.55
    bg += np.array([96, 16, 20], dtype=np.float32)[None, None, :] * red_wash[..., None]

    cool_spill = np.zeros((H * s, W * s), dtype=np.float32)
    cv2.rectangle(cool_spill, (wx0, wy0), (wx1, wy1), 1.0, -1)
    cool_spill = cv2.GaussianBlur(cool_spill, (0, 0), 70 * s)
    bg += np.array([22, 32, 52], dtype=np.float32)[None, None, :] * cool_spill[..., None]

    # ---------------- sensor realism ---------------------------------
    bg = np.clip(bg, 0, 255)
    bg = bg + rng.normal(0.0, 3.1, bg.shape).astype(np.float32)  # film grain
    bg = np.clip(bg, 0, 255).astype(np.uint8)

    # ---------------- downsample (anti-alias) ------------------------
    frame = cv2.resize(bg, (W, H), interpolation=cv2.INTER_AREA)
    gt = cv2.resize((alpha * 255.0).astype(np.uint8), (W, H), interpolation=cv2.INTER_AREA)
    gt = (gt > 110).astype(np.uint8) * 255

    return frame, gt


def main() -> None:
    out_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "dryrun")
    out_dir = os.path.normpath(out_dir)
    frame, gt = build_scene()

    src_path = os.path.join(out_dir, "standin_source.png")
    gt_path = os.path.join(out_dir, "standin_gt_mask.png")
    write_png(src_path, frame, {"CAL001_stage": "dryrun_standin",
                                "CAL001_provenance": "synthetic non-sensitive stand-in; no real person"})
    write_png(gt_path, gt, {"CAL001_stage": "dryrun_standin",
                            "CAL001_provenance": "ground-truth union subject alpha"})

    geometry = {
        "standin_size": {"width": W, "height": H},
        "aspect_ratio": "3:4",
        "window_rect": {"x0": WINDOW[0], "y0": WINDOW[1], "x1": WINDOW[2], "y1": WINDOW[3]},
        "window_guard_px": 10,
        "left_curtain_rect": {"x0": LEFT_CURTAIN[0], "y0": LEFT_CURTAIN[1],
                              "x1": LEFT_CURTAIN[2], "y1": LEFT_CURTAIN[3]},
        "right_curtain_rect": {"x0": RIGHT_CURTAIN[0], "y0": RIGHT_CURTAIN[1],
                               "x1": RIGHT_CURTAIN[2], "y1": RIGHT_CURTAIN[3]},
        "edit_region_rect": {"x0": EDIT_REGION[0], "y0": EDIT_REGION[1],
                             "x1": EDIT_REGION[2], "y1": EDIT_REGION[3]},
        "figure_seed_rects": [
            {"label": "figure_A", "x0": 262, "y0": 280, "x1": 548, "y1": 1060},
            {"label": "figure_B", "x0": 548, "y0": 390, "x1": 806, "y1": 1080},
        ],
        "subject_union_bbox": {
            "x0": int(np.argwhere(gt > 0)[:, 1].min()),
            "y0": int(np.argwhere(gt > 0)[:, 0].min()),
            "x1": int(np.argwhere(gt > 0)[:, 1].max()) + 1,
            "y1": int(np.argwhere(gt > 0)[:, 0].max()) + 1,
        },
        "note": "Seed rects stand in for the coarse operator-authored trimap that "
                "the same script consumes for a real source frame.",
    }
    write_json(os.path.join(out_dir, "standin_geometry.json"), geometry)
    print("standin written:", src_path)
    print("ground truth subject pixels:", int((gt > 0).sum()))


if __name__ == "__main__":
    main()
