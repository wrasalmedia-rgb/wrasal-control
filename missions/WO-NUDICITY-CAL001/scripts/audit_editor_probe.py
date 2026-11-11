"""Audit the Arena-native editor's edit-mode output against the subject mask.

Purpose: quantify, with evidence, whether the Arena-native editor can be used
DIRECTLY on a frame (i.e. without the local original-pixel compositor). The
direct route is expected to fail the subject-pixel-integrity gate, which is the
reason the selected route generates a separate background plate instead.

Runs against the synthetic stand-in only. No real source frame is involved.
"""

from __future__ import annotations

import argparse
import os
import sys

import cv2
import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from cal001_lib import dilate, erode, read_rgb, rect_mask, write_json  # noqa: E402


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--source", required=True)
    ap.add_argument("--editor-output", required=True)
    ap.add_argument("--subject-mask", required=True)
    ap.add_argument("--config", required=True)
    ap.add_argument("--out", required=True)
    args = ap.parse_args()

    import json

    with open(args.config, "r", encoding="utf-8") as handle:
        cfg = json.load(handle)

    source = read_rgb(args.source)
    edited = read_rgb(args.editor_output)
    subject = read_rgb(args.subject_mask)[:, :, 0]
    subject = (subject > 127).astype(np.uint8) * 255

    h, w = source.shape[:2]
    if edited.shape[:2] != source.shape[:2]:
        edited = cv2.resize(edited, (w, h), interpolation=cv2.INTER_AREA)

    protected = subject.copy()
    wr = cfg.get("window_rect")
    if wr:
        win = rect_mask((h, w), wr["x0"], wr["y0"], wr["x1"], wr["y1"])
        protected = np.maximum(protected, dilate(win, int(cfg.get("window_guard_px", 10))))

    diff = np.abs(source.astype(np.int16) - edited.astype(np.int16)).max(axis=2)
    changed = diff > 0
    prot = protected > 0
    core = erode(protected, int(cfg.get("core_erode_px", 12))) > 0

    payload = {
        "route": "Arena-native editor applied directly to the frame (no local compositor)",
        "source": os.path.abspath(args.source),
        "editor_output": os.path.abspath(args.editor_output),
        "editor_output_size": {"width": int(edited.shape[1]), "height": int(edited.shape[0])},
        "source_size": {"width": int(w), "height": int(h)},
        "subject_pixels": int((subject > 0).sum()),
        "changed_pixels_in_subject": int(np.logical_and(changed, subject > 0).sum()),
        "changed_pixels_in_core": int(np.logical_and(changed, core).sum()),
        "changed_pixels_in_protected": int(np.logical_and(changed, prot).sum()),
        "max_abs_delta_in_protected": int(diff[prot].max()) if prot.any() else 0,
        "changed_pixel_fraction_of_protected": round(
            float(np.logical_and(changed, prot).sum()) / max(int(prot.sum()), 1), 6),
        "mean_abs_delta_in_protected": round(float(diff[prot].mean()), 4) if prot.any() else 0.0,
        "g2_direct_route_verdict": "fail" if int(np.logical_and(changed, prot).sum()) > 0 else "pass",
        "note": ("The editor has no mask input, so it re-renders the whole frame. "
                 "The direct route therefore cannot satisfy G2. The selected route "
                 "uses the editor only to generate a background plate and restores "
                 "the protected region from the source with a local compositor."),
    }
    write_json(args.out, payload)
    print(json.dumps(payload, indent=2))


if __name__ == "__main__":
    main()
