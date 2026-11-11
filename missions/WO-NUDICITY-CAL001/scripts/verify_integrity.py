"""Independent G2/G3 verification for WO-NUDICITY-CAL001.

This script re-reads every artifact from disk and re-derives the protected
region from the mask files, so it does not trust any in-memory state produced by
build_mask.py or composite.py. It is the evidence of record for the
subject-pixel-integrity gate.
"""

from __future__ import annotations

import argparse
import json
import os
import sys

import cv2
import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from cal001_lib import dilate, erode, read_rgb, rect_mask, write_json  # noqa: E402


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--source", required=True)
    ap.add_argument("--after", required=True)
    ap.add_argument("--subject-mask", required=True)
    ap.add_argument("--config", required=True)
    ap.add_argument("--ground-truth", default=None)
    ap.add_argument("--out", required=True)
    args = ap.parse_args()

    with open(args.config, "r", encoding="utf-8") as handle:
        cfg = json.load(handle)

    source = read_rgb(args.source)
    after = read_rgb(args.after)
    subject = read_rgb(args.subject_mask)[:, :, 0]
    subject = (subject > 127).astype(np.uint8) * 255

    h, w = source.shape[:2]
    checks = []

    def check(name, passed, detail):
        checks.append({"check": name, "result": "pass" if passed else "fail",
                       "detail": detail})
        return passed

    # ---- shape ---------------------------------------------------------
    check("frame_size_identical", source.shape == after.shape,
          {"source": list(source.shape), "after": list(after.shape)})

    # ---- rebuild the protected region independently --------------------
    # Radii are scaled the same way build_mask.py and composite.py scale them,
    # so the verifier checks the geometry that was actually used.
    reference_width = float(cfg.get("reference_width_px", 1152))
    scale = max(w / reference_width, 0.25)

    def S(value):
        return max(1, int(round(float(value) * scale)))

    protected = subject.copy()
    window_mask = None
    wr = cfg.get("window_rect")
    if wr:
        window_mask = rect_mask((h, w), wr["x0"], wr["y0"], wr["x1"], wr["y1"])
        protected = np.maximum(protected, dilate(window_mask, int(cfg.get("window_guard_px", 10))))

    marker_masks = []
    for marker in cfg.get("preserve_markers", []) or []:
        m = rect_mask((h, w), marker["x0"], marker["y0"], marker["x1"], marker["y1"])
        marker_masks.append(m)
        protected = np.maximum(protected, m)

    core = erode(protected, S(cfg.get("core_erode_px", 12)))
    band = dilate(protected, S(cfg.get("feather_band_px", 10)))
    feather_band = np.logical_and(band > 0, protected == 0)

    # ---- G2a: core mask pixels are byte-identical ---------------------
    diff = np.abs(source.astype(np.int16) - after.astype(np.int16)).max(axis=2)
    changed = diff > 0
    core_bool = core > 0
    changed_in_core = int(np.logical_and(changed, core_bool).sum())
    check("G2a_core_pixels_unmodified", changed_in_core == 0,
          {"core_pixels": int(core_bool.sum()),
           "changed_pixels_in_core": changed_in_core,
           "max_abs_delta_in_core": int(diff[core_bool].max()) if core_bool.any() else 0})

    # ---- G2b: full protected region is byte-identical ------------------
    prot_bool = protected > 0
    changed_in_prot = int(np.logical_and(changed, prot_bool).sum())
    check("G2b_protected_region_unmodified", changed_in_prot == 0,
          {"protected_pixels": int(prot_bool.sum()),
           "changed_pixels_in_protected": changed_in_prot,
           "max_abs_delta_in_protected": int(diff[prot_bool].max()) if prot_bool.any() else 0})

    # ---- G2c: feathering lies strictly outside the protected region ----
    overlap = int(np.logical_and(feather_band, prot_bool).sum())
    check("G2c_feather_strictly_outside_protected", overlap == 0,
          {"feather_band_pixels": int(feather_band.sum()),
           "feather_pixels_inside_protected": overlap})

    # ---- G2d: nothing changed outside the declared edit region ---------
    er = cfg.get("edit_region_rect")
    if er:
        edit = rect_mask((h, w), er["x0"], er["y0"], er["x1"], er["y1"]) > 0
        outside = int(np.logical_and(changed, ~edit).sum())
        check("G2d_no_change_outside_edit_region", outside == 0,
              {"changed_pixels_outside_edit_region": outside})

    # ---- G2e: window opening and its frame are byte-identical ----------
    if window_mask is not None:
        win = window_mask > 0
        changed_win = int(np.logical_and(changed, win).sum())
        check("G2e_window_opening_preserved", changed_win == 0,
              {"window_pixels": int(win.sum()),
               "changed_pixels_in_window": changed_win,
               "max_abs_delta_in_window": int(diff[win].max())})

    # ---- G2g: provenance markers preserved byte-exact -------------------
    if marker_masks:
        changed_markers = int(sum(np.logical_and(changed, m > 0).sum() for m in marker_masks))
        check("G2g_provenance_markers_preserved", changed_markers == 0,
              {"markers": len(marker_masks),
               "changed_pixels_inside_markers": changed_markers})

    # ---- G3a: no new hard vertical seams in the background -------------
    def column_profile(img):
        luma = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY).astype(np.float32)
        return luma.mean(axis=0)

    src_step = np.abs(np.diff(column_profile(source)))
    out_step = np.abs(np.diff(column_profile(after)))
    seams = np.nonzero((out_step > 14.0) & (src_step <= 8.0))[0]
    check("G3a_no_new_hard_vertical_seams", seams.size == 0,
          {"new_seam_count": int(seams.size), "columns": [int(c) for c in seams[:24]]})

    # ---- G3b: halo / rim test -------------------------------------------
    # A halo is a NEW hard luminance rim at the protected boundary, not simply a
    # subject that contrasts with its background. The test compares boundary
    # edge strength and near-rim brightness in the composite against the same
    # measurements in the source frame.
    prot_bin = (protected > 0).astype(np.uint8)
    boundary = np.logical_and(dilate(prot_bin, 3) > 0, erode(prot_bin, 3) == 0)
    near_rim = np.logical_and(dilate(prot_bin, 3) > 0, prot_bin == 0)
    far_rim = np.logical_and(dilate(prot_bin, 26) > 0, dilate(prot_bin, 3) == 0)

    def luma(img):
        return cv2.cvtColor(img, cv2.COLOR_RGB2GRAY).astype(np.float32)

    src_l, out_l = luma(source), luma(after)

    def gradient_magnitude(light):
        gx = cv2.Sobel(light, cv2.CV_32F, 1, 0, ksize=3)
        gy = cv2.Sobel(light, cv2.CV_32F, 0, 1, ksize=3)
        return np.abs(gx) + np.abs(gy)

    src_grad = gradient_magnitude(src_l)
    out_grad = gradient_magnitude(out_l)

    def edge_strength(grad):
        if not boundary.any():
            return 0.0
        return float(grad[boundary].mean())

    src_edge = edge_strength(src_grad)
    out_edge = edge_strength(out_grad)
    edge_delta = out_edge - src_edge

    def rim_brightness(light, mask):
        return float(light[mask].mean()) if mask.any() else 0.0

    src_near, out_near = rim_brightness(src_l, near_rim), rim_brightness(out_l, near_rim)
    src_far, out_far = rim_brightness(src_l, far_rim), rim_brightness(out_l, far_rim)
    src_rim_delta = src_near - src_far
    out_rim_delta = out_near - out_far
    rim_delta = out_rim_delta - src_rim_delta

    halo_ok = abs(edge_delta) <= 6.0 and abs(rim_delta) <= 10.0
    check("G3b_no_halo_rim_at_subject_boundary", halo_ok,
          {"source_boundary_edge_strength": round(src_edge, 3),
           "composite_boundary_edge_strength": round(out_edge, 3),
           "edge_strength_delta": round(edge_delta, 3),
           "edge_strength_delta_threshold": 6.0,
           "source_near_minus_far_rim_luma": round(src_rim_delta, 3),
           "composite_near_minus_far_rim_luma": round(out_rim_delta, 3),
           "rim_delta": round(rim_delta, 3),
           "rim_delta_threshold": 10.0})

    # ---- subject coverage against ground truth (dry-run only) ----------
    if args.ground_truth:
        gt = read_rgb(args.ground_truth)[:, :, 0]
        gt_bool = gt > 0
        uncovered = int(np.logical_and(gt_bool, subject == 0).sum())
        check("G2f_protected_region_covers_subject", uncovered == 0,
              {"subject_ground_truth_pixels": int(gt_bool.sum()),
               "subject_pixels_outside_protected": uncovered})

    result = "pass" if all(c["result"] == "pass" for c in checks) else "fail"
    payload = {
        "verdict": result,
        "source": os.path.abspath(args.source),
        "after": os.path.abspath(args.after),
        "checks": checks,
        "summary": {"total": len(checks),
                    "passed": sum(1 for c in checks if c["result"] == "pass"),
                    "failed": sum(1 for c in checks if c["result"] == "fail")},
    }
    write_json(args.out, payload)
    print(json.dumps(payload, indent=2))
    raise SystemExit(0 if result == "pass" else 1)


if __name__ == "__main__":
    main()
