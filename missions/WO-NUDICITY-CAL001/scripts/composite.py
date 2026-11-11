"""Composite the generated background plate under the ORIGINAL protected pixels.

Guarantees enforced here:
  1. Every pixel inside the protected region (subject union + preserved window
     opening and its frame) is copied byte-exact from the source frame.
  2. Feathering happens strictly OUTSIDE the protected region. There is no
     blend ramp that touches a protected pixel, so no subject or window pixel
     can be partially re-lit by the plate.
  3. Pixels outside the declared edit region are also copied byte-exact from
     the source frame (the edit is confined to curtains + upper wall).
"""

from __future__ import annotations

import argparse
import json
import os
import sys

import cv2
import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from cal001_lib import (  # noqa: E402
    dilate,
    diff_map,
    read_rgb,
    rect_mask,
    write_json,
    write_png,
)


def detect_window(plate_rgb):
    """Locate the bright, cool-toned window opening in a generated plate."""
    hsv = cv2.cvtColor(plate_rgb, cv2.COLOR_RGB2HSV)
    h, s, v = hsv[:, :, 0], hsv[:, :, 1], hsv[:, :, 2]
    blue = (h >= 85) & (h <= 135) & (s >= 20) & (s <= 170) & (v >= 120)
    bright = (v >= 150) & (s <= 150)
    mask = ((blue | bright)).astype(np.uint8)
    mask = cv2.morphologyEx(mask, cv2.MORPH_CLOSE, np.ones((15, 15), np.uint8))
    num, labels, stats, _ = cv2.connectedComponentsWithStats(mask, connectivity=8)
    if num <= 1:
        return None
    best = 1 + int(np.argmax(stats[1:, cv2.CC_STAT_AREA]))
    area = stats[best, cv2.CC_STAT_AREA]
    frac = area / float(mask.size)
    if frac < 0.004 or frac > 0.55:
        return None
    x = stats[best, cv2.CC_STAT_LEFT]
    y = stats[best, cv2.CC_STAT_TOP]
    return {"x0": int(x), "y0": int(y),
            "x1": int(x + stats[best, cv2.CC_STAT_WIDTH]),
            "y1": int(y + stats[best, cv2.CC_STAT_HEIGHT]),
            "area_frac": round(frac, 5)}


def detect_drapery_columns(plate_rgb, band=(0.15, 0.75), min_amplitude=2.5):
    """Columns that carry vertical drapery-fold structure.

    A curtain column has a brightness profile that oscillates horizontally at
    the fold pitch, so a high-passed column profile shows repeated extrema.
    """
    h, w = plate_rgb.shape[:2]
    y0 = int(h * band[0])
    y1 = int(h * band[1])
    luma = cv2.cvtColor(plate_rgb, cv2.COLOR_RGB2GRAY).astype(np.float32)
    profile = luma[y0:y1, :].mean(axis=0)
    smooth = cv2.blur(profile.reshape(1, -1), (81, 1)).ravel()
    high = profile - smooth
    cols = np.abs(high) > min_amplitude
    if not cols.any():
        return cols, 0
    # count sign alternations to avoid counting a single smooth ramp
    signs = np.sign(high[cols])
    alternations = int(np.sum(signs[1:] * signs[:-1] < 0))
    return cols, alternations


def suppress_plate_window(plate_rgb, window_box, margin=18):
    """Erase the plate's own window so the preserved source window is the only
    window in the composite (no foreign frame or glass showing at the edges)."""
    if not window_box:
        return plate_rgb, False
    h, w = plate_rgb.shape[:2]
    x0 = max(0, window_box["x0"] - margin)
    y0 = max(0, window_box["y0"] - margin)
    x1 = min(w, window_box["x1"] + margin)
    y1 = min(h, window_box["y1"] + margin)
    mask = np.zeros((h, w), dtype=np.uint8)
    mask[y0:y1, x0:x1] = 255
    out = cv2.inpaint(cv2.cvtColor(plate_rgb, cv2.COLOR_RGB2BGR), mask, 9, cv2.INPAINT_TELEA)
    return cv2.cvtColor(out, cv2.COLOR_BGR2RGB), True


def fit_plate_to_frame(plate_rgb, src_w, src_h, window_rect):
    """Fit the plate to the source frame at 1:1 scale, align its window centre to
    the source window centre by TRANSLATION ONLY, then suppress the plate's own
    window.

    Scale is deliberately not used for alignment: zooming the plate to match the
    window opening pushes the generated drapery out of frame and leaves an
    unlit wall patch where the source curtains were.
    """
    plate = plate_rgb
    ph, pw = plate.shape[:2]
    target_ratio = src_w / float(src_h)
    plate_ratio = pw / float(ph)

    if plate_ratio > target_ratio:
        new_w = int(round(ph * target_ratio))
        x0 = (pw - new_w) // 2
        plate = plate[:, x0:x0 + new_w]
    else:
        new_h = int(round(pw / target_ratio))
        y0 = (ph - new_h) // 2
        plate = plate[y0:y0 + new_h, :]
    plate = cv2.resize(plate, (src_w, src_h), interpolation=cv2.INTER_AREA)

    detected = detect_window(plate)
    alignment = {"mode": "uniform_fit", "detected_window": detected}

    if detected and window_rect:
        cx_src = (window_rect["x0"] + window_rect["x1"]) / 2.0
        cy_src = (window_rect["y0"] + window_rect["y1"]) / 2.0
        cx_det = (detected["x0"] + detected["x1"]) / 2.0
        cy_det = (detected["y0"] + detected["y1"]) / 2.0
        max_shift = int(round(src_w * 0.10))
        tx = float(np.clip(cx_src - cx_det, -max_shift, max_shift))
        ty = float(np.clip(cy_src - cy_det, -max_shift, max_shift))
        matrix = np.array([[1.0, 0.0, tx], [0.0, 1.0, ty]], dtype=np.float64)
        aligned = cv2.warpAffine(plate, matrix, (src_w, src_h),
                                 flags=cv2.INTER_CUBIC, borderMode=cv2.BORDER_REFLECT_101)
        after = detect_window(aligned)
        residual = None
        if after:
            residual = {
                "dx_px": int(round(((after["x0"] + after["x1"]) / 2.0) - cx_src)),
                "dy_px": int(round(((after["y0"] + after["y1"]) / 2.0) - cy_src)),
                "plate_window_w": int(after["x1"] - after["x0"]),
                "plate_window_h": int(after["y1"] - after["y0"]),
                "source_window_w": int(window_rect["x1"] - window_rect["x0"]),
                "source_window_h": int(window_rect["y1"] - window_rect["y0"]),
            }
        aligned, suppressed = suppress_plate_window(aligned, after or detected)
        alignment = {"mode": "translation_only_window_centre",
                     "tx": round(tx, 2), "ty": round(ty, 2),
                     "detected_window": detected, "residual": residual,
                     "plate_window_suppressed": suppressed}
        return aligned, alignment

    return plate, alignment


def outward_feather_alpha(protected, band_px: int):
    """Alpha ramp that is 0 at the protected boundary and 1 `band_px` outside.

    Never touches a protected pixel.
    """
    protected_bin = (protected > 0).astype(np.uint8)
    if protected_bin.sum() == 0 or band_px <= 0:
        return np.zeros(protected.shape, dtype=np.float32)
    distance = cv2.distanceTransform(1 - protected_bin, cv2.DIST_L2, 5)
    alpha = np.clip(distance / float(band_px), 0.0, 1.0)
    alpha[protected_bin > 0] = 0.0
    return alpha.astype(np.float32)


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--source", required=True)
    ap.add_argument("--plate", required=True)
    ap.add_argument("--subject-mask", required=True)
    ap.add_argument("--config", required=True)
    ap.add_argument("--out-dir", required=True)
    ap.add_argument("--prefix", default="dryrun")
    args = ap.parse_args()

    with open(args.config, "r", encoding="utf-8") as handle:
        cfg = json.load(handle)

    source = read_rgb(args.source)
    h, w = source.shape[:2]
    plate = read_rgb(args.plate)

    subject = read_rgb(args.subject_mask)[:, :, 0]
    subject = (subject > 127).astype(np.uint8) * 255

    window_rect = cfg.get("window_rect")
    edit_rect = cfg.get("edit_region_rect")

    # ---- protected region: subject union + preserved window opening -------
    protected = subject.copy()
    window_guard_px = int(cfg.get("window_guard_px", 10))
    window_mask = None
    if window_rect:
        window_mask = rect_mask((h, w), window_rect["x0"], window_rect["y0"],
                                window_rect["x1"], window_rect["y1"])
        protected = np.maximum(protected, dilate(window_mask, window_guard_px))

    # ---- edit region ------------------------------------------------------
    if edit_rect:
        edit_region = rect_mask((h, w), edit_rect["x0"], edit_rect["y0"],
                                 edit_rect["x1"], edit_rect["y1"])
    else:
        edit_region = np.full((h, w), 255, dtype=np.uint8)

    # ---- plate fitting ----------------------------------------------------
    aligned, alignment = fit_plate_to_frame(plate, w, h, window_rect)

    # ---- composite --------------------------------------------------------
    band_px = int(cfg.get("feather_band_px", 10))
    alpha = outward_feather_alpha(protected, band_px)

    # alpha == 0 on every protected pixel (exact copy) and ramps to 1 across
    # the outward band; beyond the band the plate is used verbatim.
    out = source.copy()
    edit_area = (edit_region > 0)
    a = alpha[:, :, None]
    blended = source.astype(np.float32) * (1.0 - a) + aligned.astype(np.float32) * a
    blended = np.clip(np.round(blended), 0, 255).astype(np.uint8)
    out[edit_area] = blended[edit_area]

    # hard guarantees, re-applied on the integer buffer
    out[protected > 0] = source[protected > 0]
    out[~edit_area] = source[~edit_area]

    protected_bool = protected > 0
    gen_area = edit_area & (alpha >= 1.0) & ~protected_bool
    blend = edit_area & (alpha > 0.0) & (alpha < 1.0) & ~protected_bool

    # ---- diagnostics ------------------------------------------------------
    dmap = diff_map(source, out)
    changed = dmap > 0

    metrics = {
        "source": os.path.abspath(args.source),
        "plate": os.path.abspath(args.plate),
        "frame": {"width": w, "height": h},
        "alignment": alignment,
        "counts": {
            "protected_pixels": int(protected_bool.sum()),
            "subject_pixels": int((subject > 0).sum()),
            "window_guard_pixels": int((window_mask > 0).sum()) if window_mask is not None else 0,
            "edit_region_pixels": int((edit_region > 0).sum()),
            "generated_pixels": int(gen_area.sum()),
            "feathered_pixels": int(blend.sum()),
            "changed_pixels_total": int(changed.sum()),
            "changed_pixels_inside_protected": int((changed & protected_bool).sum()),
            "changed_pixels_outside_edit_region": int(
                (changed & (edit_region == 0)).sum()),
            "max_abs_diff_inside_protected": int(dmap[protected_bool].max()) if protected_bool.any() else 0,
        },
    }

    # ---------------- G3 coherence probes --------------------------------
    g3 = {}

    # (a) drapery coverage: does the plate actually carry curtain-fold
    #     structure across the source frame's declared curtain columns?
    drape_cols, alternations = detect_drapery_columns(aligned)
    g3["plate_drapery_columns_with_folds"] = int(drapape_count := drape_cols.sum())
    g3["plate_drapery_fold_alternations"] = alternations
    curtain_checks = {}
    for key in ("left_curtain_rect", "right_curtain_rect"):
        rect = cfg.get(key)
        if not rect:
            continue
        band = np.zeros(w, dtype=bool)
        band[max(0, rect["x0"]):min(w, rect["x1"])] = True
        covered = int(np.logical_and(drape_cols, band).sum())
        total = int(band.sum())
        curtain_checks[key] = {
            "columns_total": total,
            "columns_with_fold_structure": covered,
            "coverage_ratio": round(covered / total, 4) if total else 0.0,
        }
    g3["curtain_coverage"] = curtain_checks

    # (b) seam detection: new hard vertical transitions that were not in the
    #     source frame (a hard edge in the plate replacing curtain/wall).
    def column_profile(img):
        luma = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY).astype(np.float32)
        rows = (edit_region > 0)
        band_rows = np.nonzero(rows.any(axis=1))[0]
        if band_rows.size == 0:
            return np.zeros(img.shape[1], dtype=np.float32)
        return luma[band_rows[0]:band_rows[-1] + 1, :].mean(axis=0)

    src_profile = column_profile(source)
    out_profile = column_profile(out)
    src_step = np.abs(np.diff(src_profile))
    out_step = np.abs(np.diff(out_profile))
    new_seams = np.nonzero((out_step > 14.0) & (src_step <= 8.0))[0]
    g3["new_hard_vertical_seams"] = {
        "count": int(new_seams.size),
        "columns": [int(c) for c in new_seams[:24]],
        "threshold_abs_luma_step": 14.0,
    }

    # (c) colour coherence: mean luma/chroma drift of the edited background
    #     against the source background it replaced.
    edit_only = (edit_region > 0) & (~protected_bool) & changed
    if edit_only.any():
        g3["background_colour_drift"] = {
            "mean_abs_rgb_delta": [round(float(np.abs(source[edit_only].astype(np.int16) -
                                                          out[edit_only].astype(np.int16)).mean(axis=0)[c]), 2)
                                   for c in range(3)],
            "mean_luma_source": round(float(source[edit_only].mean()), 2),
            "mean_luma_composite": round(float(out[edit_only].mean()), 2),
        }

    # (d) window geometry: the preserved opening must be pixel-identical.
    if window_mask is not None:
        win = window_mask > 0
        g3["window_integrity"] = {
            "window_pixels": int(win.sum()),
            "changed_pixels_inside_window": int((changed & win).sum()),
            "max_abs_diff_inside_window": int(dmap[win].max()),
        }

    metrics["g3_coherence"] = g3

    out_dir = os.path.normpath(args.out_dir)
    os.makedirs(out_dir, exist_ok=True)
    meta = {"CAL001_stage": "composite", "CAL001_provenance": cfg.get("provenance", "")}

    write_png(os.path.join(out_dir, f"{args.prefix}_after.png"), out, meta)
    write_png(os.path.join(out_dir, f"{args.prefix}_subject_diff.png"),
              np.clip(dmap.astype(np.int16) * 8, 0, 255).astype(np.uint8), meta)

    # edge-spill view: differences that sit within 6px of the protected boundary
    boundary = cv2.dilate((protected > 0).astype(np.uint8),
                          cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (13, 13))) - \
        cv2.erode((protected > 0).astype(np.uint8),
                  cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (13, 13)))
    spill = np.zeros((h, w), dtype=np.uint8)
    spill[boundary > 0] = dmap[boundary > 0]
    write_png(os.path.join(out_dir, f"{args.prefix}_edge_spill.png"),
              np.clip(spill.astype(np.int16) * 8, 0, 255).astype(np.uint8), meta)

    write_json(os.path.join(out_dir, f"{args.prefix}_composite_metrics.json"), metrics)
    print(json.dumps(metrics["counts"], indent=2))
    print(json.dumps(alignment, indent=2))


if __name__ == "__main__":
    main()
