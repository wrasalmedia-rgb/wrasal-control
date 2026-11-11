"""Shared helpers for WO-NUDICITY-CAL001 background-only editing pipeline.

Design rule enforced by this module: the protected region (subject + preserved
window opening) is never written by any generative or resampling step. All
blending happens OUTSIDE the eroded core, so protected pixels stay byte-exact.
"""

from __future__ import annotations

import hashlib
import json
import os
from dataclasses import dataclass, field, asdict
from typing import Dict, List, Optional, Sequence, Tuple

import cv2
import numpy as np
from PIL import Image, PngImagePlugin

# --------------------------------------------------------------------------
# I/O
# --------------------------------------------------------------------------


def sha256_file(path: str) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as handle:
        for chunk in iter(lambda: handle.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def sha256_array(arr: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(arr).tobytes()).hexdigest()


def read_rgb(path: str) -> np.ndarray:
    """Read an image as an HxWx3 uint8 RGB array (no colour conversion surprises)."""
    with Image.open(path) as img:
        img = img.convert("RGB")
        return np.asarray(img, dtype=np.uint8)


def write_png(path: str, arr: np.ndarray, meta: Optional[Dict[str, str]] = None) -> str:
    """Write uint8 RGB (or RGBA) PNG losslessly, embedding provenance metadata."""
    os.makedirs(os.path.dirname(os.path.abspath(path)), exist_ok=True)
    img = Image.fromarray(arr)
    info = PngImagePlugin.PngInfo()
    for key, value in (meta or {}).items():
        info.add_text(key, str(value))
    img.save(path, format="PNG", pnginfo=info, optimize=False)
    return path


def write_json(path: str, payload) -> str:
    os.makedirs(os.path.dirname(os.path.abspath(path)), exist_ok=True)
    with open(path, "w", encoding="utf-8") as handle:
        json.dump(payload, handle, indent=2, sort_keys=True)
        handle.write("\n")
    return path


# --------------------------------------------------------------------------
# Mask algebra
# --------------------------------------------------------------------------


def rect_mask(shape: Tuple[int, int], x0: int, y0: int, x1: int, y1: int) -> np.ndarray:
    """Axis-aligned rectangle mask, half-open bounds."""
    h, w = shape[:2]
    mask = np.zeros((h, w), dtype=np.uint8)
    x0 = max(0, min(w, int(x0)))
    x1 = max(0, min(w, int(x1)))
    y0 = max(0, min(h, int(y0)))
    y1 = max(0, min(h, int(y1)))
    mask[y0:y1, x0:x1] = 255
    return mask


def erode(mask: np.ndarray, radius: int) -> np.ndarray:
    if radius <= 0:
        return mask.copy()
    kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (2 * radius + 1, 2 * radius + 1))
    return cv2.erode(mask, kernel, iterations=1)


def dilate(mask: np.ndarray, radius: int) -> np.ndarray:
    if radius <= 0:
        return mask.copy()
    kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (2 * radius + 1, 2 * radius + 1))
    return cv2.dilate(mask, kernel, iterations=1)


def fill_holes(mask: np.ndarray) -> np.ndarray:
    """Fill interior holes of a binary mask (background flood fill from border)."""
    binary = (mask > 0).astype(np.uint8)
    h, w = binary.shape
    flooded = np.zeros((h + 2, w + 2), dtype=np.uint8)
    ff = binary.copy()
    cv2.floodFill(ff, flooded, (0, 0), 1)
    holes = (ff == 0).astype(np.uint8)
    return ((binary + holes) * 255).astype(np.uint8)


def keep_largest_components(mask: np.ndarray, count: int = 2) -> np.ndarray:
    """Keep the `count` largest connected components of a binary mask."""
    binary = (mask > 0).astype(np.uint8)
    num, labels, stats, _ = cv2.connectedComponentsWithStats(binary, connectivity=8)
    if num <= 1:
        return mask
    order = np.argsort(-stats[1:, cv2.CC_STAT_AREA])[:count] + 1
    keep = np.isin(labels, order).astype(np.uint8) * 255
    return keep


def feather_alpha(core: np.ndarray, band: np.ndarray, width: int) -> np.ndarray:
    """Alpha ramp in [0,1] that is 0 at the core boundary and 1 outside the band.

    Distance is measured from the protected core, so the blend can never touch
    a protected pixel.
    """
    if width <= 0:
        return (band > 0).astype(np.float32)

    core_bin = (core > 0).astype(np.uint8)
    if core_bin.sum() == 0:
        return (band > 0).astype(np.float32)

    # distance from every pixel to the nearest core pixel
    distance = cv2.distanceTransform(1 - core_bin, cv2.DIST_L2, 5)
    alpha = np.clip(distance / float(width), 0.0, 1.0)
    alpha[core_bin > 0] = 0.0
    alpha[(band == 0) & (core_bin == 0)] = 0.0
    return alpha.astype(np.float32)


# --------------------------------------------------------------------------
# Metrics
# --------------------------------------------------------------------------


def iou(a: np.ndarray, b: np.ndarray) -> float:
    a_bin = a > 0
    b_bin = b > 0
    union = np.logical_or(a_bin, b_bin).sum()
    if union == 0:
        return 1.0
    return float(np.logical_and(a_bin, b_bin).sum()) / float(union)


def diff_map(a: np.ndarray, b: np.ndarray) -> np.ndarray:
    """Per-pixel max channel absolute difference as uint8."""
    return np.abs(a.astype(np.int16) - b.astype(np.int16)).max(axis=2).astype(np.uint8)


# --------------------------------------------------------------------------
# Provenance
# --------------------------------------------------------------------------


@dataclass
class Provenance:
    work_order_id: str
    stage: str
    source_label: str
    source_sha256: Optional[str] = None
    notes: str = ""
    extra: Dict[str, object] = field(default_factory=dict)

    def as_dict(self) -> Dict[str, object]:
        return asdict(self)
