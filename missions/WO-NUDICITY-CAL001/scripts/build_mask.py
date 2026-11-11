"""Build the protected subject mask (union of all people) for CAL001.

Route: operator-authored coarse seed rects -> OpenCV GrabCut -> component
selection -> hole fill -> banded refinement -> eroded core + feather band.

Why this route and not a neural segmenter: no pretrained segmentation or
diffusion weights are obtainable in this environment (see model_inventory.md),
so the mask must be produced by a weights-free, licence-clean engine. GrabCut
is MIT-licensed OpenCV code and needs no model files.

The script is source-agnostic: it takes a JSON config describing the seed
rects, so the exact same code path runs on the dry-run stand-in and on the
real source once that frame is delivered.
"""

from __future__ import annotations

import argparse
import os
import sys

import cv2
import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from cal001_lib import (  # noqa: E402
    dilate,
    erode,
    fill_holes,
    iou,
    read_rgb,
    rect_mask,
    write_json,
    write_png,
)

GC_BGD = 0
GC_FGD = 1
GC_PR_BGD = 2
GC_PR_FGD = 3


def build_trimap(shape, seeds, inner_shrink: int, outer_expand: int):
    """Coarse trimap from operator seed rects (mask-initialisation variant).

    Kept for comparison only. The rectangle-initialised route in
    `grabcut_union_with_rects` is the one actually used, because a whole seed
    rect marked probable-foreground lets the colour model keep background
    pixels and produces a preserved slab of original background around the
    subject.
    """
    h, w = shape[:2]
    trimap = np.full((h, w), GC_PR_BGD, dtype=np.uint8)

    for seed in seeds:
        x0, y0, x1, y1 = seed["x0"], seed["y0"], seed["x1"], seed["y1"]
        prob = rect_mask((h, w), x0, y0, x1, y1)
        inner = erode(prob, inner_shrink)
        outer = dilate(prob, outer_expand)

        trimap[prob > 0] = GC_PR_FGD
        trimap[inner > 0] = GC_FGD
        trimap[(outer == 0) & (trimap == GC_PR_BGD)] = GC_BGD

    return trimap


def grabcut_union_with_rects(image_bgr, seeds, iterations: int):
    """Run GrabCut once per operator seed rectangle and union the results.

    Rectangle initialisation lets the colour model decide what inside the
    rectangle is subject, which is what keeps the mask tight around the people
    instead of preserving the whole rectangle.
    """
    h, w = image_bgr.shape[:2]
    union = np.zeros((h, w), dtype=np.uint8)

    for seed in seeds:
        x0, y0, x1, y1 = seed["x0"], seed["y0"], seed["x1"], seed["y1"]
        x0 = max(0, min(w - 2, int(x0)))
        y0 = max(0, min(h - 2, int(y0)))
        x1 = max(x0 + 2, min(w, int(x1)))
        y1 = max(y0 + 2, min(h, int(y1)))
        mask = np.zeros((h, w), dtype=np.uint8)
        bgd = np.zeros((1, 65), dtype=np.float64)
        fgd = np.zeros((1, 65), dtype=np.float64)
        try:
            cv2.grabCut(image_bgr, mask, (x0, y0, x1 - x0, y1 - y0), bgd, fgd,
                        iterations, cv2.GC_INIT_WITH_RECT)
        except cv2.error:
            continue
        union = np.maximum(union, np.where((mask == GC_FGD) | (mask == GC_PR_FGD),
                                           255, 0).astype(np.uint8))
    return union


def refine_banded(image, mask, band_px: int):
    """Second GrabCut pass with a narrow band around the current mask."""
    h, w = mask.shape[:2]
    trimap = np.full((h, w), GC_BGD, dtype=np.uint8)
    core = erode(mask, band_px)
    band = dilate(mask, band_px)
    trimap[band > 0] = GC_PR_BGD
    trimap[(mask > 0) & (core == 0)] = GC_PR_FGD
    trimap[core > 0] = GC_FGD

    bgd = np.zeros((1, 65), dtype=np.float64)
    fgd = np.zeros((1, 65), dtype=np.float64)
    try:
        cv2.grabCut(image, trimap, None, bgd, fgd, 5, cv2.GC_INIT_WITH_MASK)
    except cv2.error:
        return mask
    out = np.where((trimap == GC_FGD) | (trimap == GC_PR_FGD), 255, 0).astype(np.uint8)
    return out


def select_subject_components(mask, seeds, min_area_frac: float = 0.004):
    """Keep components that sit inside an operator seed (drops curtain/frame blobs)."""
    binary = (mask > 0).astype(np.uint8)
    num, labels, stats, _ = cv2.connectedComponentsWithStats(binary, connectivity=8)
    if num <= 1:
        return mask

    total = float(binary.sum())
    keep = []
    for label in range(1, num):
        area = stats[label, cv2.CC_STAT_AREA]
        if area < max(min_area_frac * total, 400):
            continue
        comp = (labels == label)
        hits = 0
        for seed in seeds:
            box = np.zeros((binary.shape[0], binary.shape[1]), dtype=np.uint8)
            box[seed["y0"]:seed["y1"], seed["x0"]:seed["x1"]] = 1
            overlap = float(np.logical_and(comp, box > 0).sum())
            if overlap > 0.25 * area:
                hits += 1
        if hits:
            keep.append(label)

    if not keep:
        return mask
    return np.isin(labels, keep).astype(np.uint8) * 255


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--image", required=True)
    ap.add_argument("--config", required=True)
    ap.add_argument("--out-dir", required=True)
    ap.add_argument("--ground-truth", default=None)
    ap.add_argument("--prefix", default="dryrun")
    args = ap.parse_args()

    import json

    with open(args.config, "r", encoding="utf-8") as handle:
        cfg = json.load(handle)

    image = read_rgb(args.image)
    h, w = image.shape[:2]
    bgr = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

    seeds = cfg["subject_seed_rects"]
    iterations = cfg.get("grabcut_iterations", 6)

    # Radii are authored against a reference frame width and scaled to the
    # actual frame, so the same config behaves identically at 1152 px and on a
    # larger frame instead of becoming proportionally too tight.
    reference_width = float(cfg.get("reference_width_px", 1152))
    scale = max(w / reference_width, 0.25)

    def S(value: int) -> int:
        return max(1, int(round(float(value) * scale)))

    mask = grabcut_union_with_rects(bgr, seeds, iterations)
    mask = select_subject_components(mask, seeds, cfg.get("min_area_frac", 0.004))
    mask = fill_holes(mask)
    mask = cv2.morphologyEx(mask, cv2.MORPH_CLOSE,
                            cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (9, 9)))
    mask = fill_holes(mask)

    refined = refine_banded(bgr, mask, S(cfg.get("refine_band_px", 14)))
    refined = select_subject_components(refined, seeds, cfg.get("min_area_frac", 0.004))
    refined = fill_holes(refined)
    raw_mask = refined

    # Safety dilation: the protected region must fully CONTAIN the subject.
    # Over-protection is safe (it only preserves more original pixels);
    # under-protection would let the composite touch a subject pixel.
    safety = S(cfg.get("safety_dilate_px", 8))
    mask = dilate(raw_mask, safety) if safety > 0 else raw_mask.copy()

    core = erode(mask, S(cfg.get("core_erode_px", 12)))
    band = dilate(mask, S(cfg.get("feather_band_px", 10)))

    out_dir = os.path.normpath(args.out_dir)
    os.makedirs(out_dir, exist_ok=True)
    meta = {"CAL001_stage": "mask_build", "CAL001_provenance": cfg.get("provenance", "")}

    write_png(os.path.join(out_dir, f"{args.prefix}_subject_mask.png"), mask, meta)
    write_png(os.path.join(out_dir, f"{args.prefix}_subject_core.png"), core, meta)
    write_png(os.path.join(out_dir, f"{args.prefix}_subject_band.png"), band, meta)

    metrics = {
        "image": os.path.abspath(args.image),
        "image_size": {"width": w, "height": h},
        "seed_rects": seeds,
        "settings": {
            "inner_shrink_px": cfg.get("inner_shrink_px", 26),
            "outer_expand_px": cfg.get("outer_expand_px", 46),
            "grabcut_iterations": cfg.get("grabcut_iterations", 6),
            "refine_band_px": S(cfg.get("refine_band_px", 14)),
            "core_erode_px": S(cfg.get("core_erode_px", 12)),
            "feather_band_px": S(cfg.get("feather_band_px", 10)),
            "reference_width_px": reference_width,
            "applied_radius_scale": round(scale, 4),
        },
        "subject_pixels": int((mask > 0).sum()),
        "core_pixels": int((core > 0).sum()),
        "band_pixels": int((band > 0).sum()),
        "subject_bbox": None,
        "components": int(cv2.connectedComponents((mask > 0).astype(np.uint8))[0] - 1),
    }
    ys, xs = np.nonzero(mask > 0)
    if len(xs):
        metrics["subject_bbox"] = {"x0": int(xs.min()), "y0": int(ys.min()),
                                   "x1": int(xs.max()) + 1, "y1": int(ys.max()) + 1}

    if args.ground_truth:
        gt = read_rgb(args.ground_truth)[:, :, 0]
        metrics["ground_truth_pixels"] = int((gt > 0).sum())
        metrics["raw_mask_iou"] = round(iou(raw_mask, gt), 6)
        metrics["protected_mask_iou"] = round(iou(mask, gt), 6)
        metrics["raw_false_positive_pixels"] = int(((raw_mask > 0) & (gt == 0)).sum())
        metrics["raw_false_negative_pixels"] = int(((raw_mask == 0) & (gt > 0)).sum())
        metrics["protected_false_positive_pixels"] = int(((mask > 0) & (gt == 0)).sum())
        metrics["protected_false_negative_pixels"] = int(((mask == 0) & (gt > 0)).sum())
        metrics["subject_pixel_coverage"] = round(
            1.0 - (metrics["protected_false_negative_pixels"] / max(metrics["ground_truth_pixels"], 1)), 6)
        metrics["core_subject_coverage"] = round(
            1.0 - (int(((core == 0) & (gt > 0)).sum()) / max(metrics["ground_truth_pixels"], 1)), 6)

    write_json(os.path.join(out_dir, f"{args.prefix}_mask_metrics.json"), metrics)
    print(json.dumps(metrics, indent=2))


if __name__ == "__main__":
    main()
