"""Build run_manifest.json for WO-NUDICITY-CAL001.

The manifest is the provenance record of record: every artifact is listed with
its SHA-256, byte size and role, alongside the model identification, the
settings used, the execution location and the timestamps.
"""

from __future__ import annotations

import json
import os
import platform
import sys
from datetime import datetime, timezone

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from cal001_lib import sha256_file, write_json  # noqa: E402

MISSION_DIR = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))


def artefact(path: str, role: str, stage: str, provenance: str, note: str = "") -> dict:
    full = os.path.join(MISSION_DIR, path) if not os.path.isabs(path) else path
    if not os.path.exists(full):
        return {"path": path, "role": role, "stage": stage, "present": False,
                "note": note or "NOT PRODUCED"}
    return {
        "path": os.path.relpath(full, MISSION_DIR) if full.startswith(MISSION_DIR) else full,
        "role": role,
        "stage": stage,
        "present": True,
        "sha256": sha256_file(full),
        "bytes": os.path.getsize(full),
        "provenance": provenance,
        "note": note,
    }


def main() -> None:
    dryrun = "dryrun/"
    standin_prov = ("synthetic non-sensitive stand-in generated locally by "
                    "scripts/synth_standin.py; no real person depicted")
    plate_prov = ("Arena-native image generator, text-to-image plate only; "
                  "no source pixels uploaded")
    editor_prov = ("Arena-native image generator, edit mode applied to the "
                   "synthetic stand-in only")

    artefacts = [
        artefact(dryrun + "standin_source.png", "dry-run input frame", "standin_synthesis", standin_prov),
        artefact(dryrun + "standin_gt_mask.png", "ground-truth union subject alpha", "standin_synthesis", standin_prov),
        artefact(dryrun + "standin_geometry.json", "scene geometry + seed rects", "standin_synthesis", standin_prov),
        artefact(dryrun + "standin_mask_config.json", "mask configuration", "config", standin_prov),
        artefact(dryrun + "dryrun_background_plate.png", "generated background plate", "plate_generation", plate_prov),
        artefact(dryrun + "dryrun_editor_editmode_probe.png", "editor edit-mode probe output", "editor_probe", editor_prov,
                 "retained as evidence that the direct-edit route re-renders the frame"),
        artefact(dryrun + "dryrun_editor_probe_audit.json", "editor probe audit", "editor_probe", editor_prov),
        artefact(dryrun + "dryrun_subject_mask.png", "protected subject union mask", "mask_build", standin_prov),
        artefact(dryrun + "dryrun_subject_core.png", "eroded protected core mask", "mask_build", standin_prov),
        artefact(dryrun + "dryrun_subject_band.png", "feather band mask", "mask_build", standin_prov),
        artefact(dryrun + "dryrun_mask_metrics.json", "mask metrics vs ground truth", "mask_build", standin_prov),
        artefact(dryrun + "dryrun_after.png", "background-only composite result", "composite",
                 "original source pixels restored over a generated plate"),
        artefact(dryrun + "dryrun_subject_diff.png", "subject difference map (8x amplified)", "composite", standin_prov),
        artefact(dryrun + "dryrun_edge_spill.png", "edge-spill map (8x amplified)", "composite", standin_prov),
        artefact(dryrun + "dryrun_composite_metrics.json", "composite + G3 coherence metrics", "composite", standin_prov),
        artefact(dryrun + "dryrun_verification.json", "independent G2/G3 verification record", "verification", standin_prov),
        artefact("evidence/environment_probe.json", "execution-environment inventory", "environment_probe", "observed"),
        artefact("config/cal001_mask_config.template.json", "mask config template for the real source", "config",
                 "TEMPLATE - operator must complete against the delivered source frame"),
        artefact("scripts/synth_standin.py", "stand-in generator", "code", "repository"),
        artefact("scripts/cal001_lib.py", "shared mask/composite library", "code", "repository"),
        artefact("scripts/build_mask.py", "subject mask builder", "code", "repository"),
        artefact("scripts/composite.py", "background compositor", "code", "repository"),
        artefact("scripts/verify_integrity.py", "independent integrity verifier", "code", "repository"),
        artefact("scripts/audit_editor_probe.py", "editor direct-route auditor", "code", "repository"),
        artefact("scripts/probe_environment.py", "environment prober", "code", "repository"),
        artefact("scripts/build_manifest.py", "manifest builder", "code", "repository"),
        artefact("scripts/run_source_frame.sh", "one-command source-frame runner", "code", "repository"),
        artefact("scripts/bootstrap_env.sh", "pinned environment bootstrap", "code", "repository"),
        artefact("requirements.lock.txt", "pinned environment lockfile", "code", "repository"),
    ]

    # Source-frame artefacts that the gate conditions did not permit producing.
    withheld = [
        {"path": "CAL001_background_test.png", "status": "withheld",
         "reason": "G0 did not pass: the source frame was not present in the execution "
                   "environment and no consent/clearance record for external inference "
                   "was supplied. The work order permits this artefact only if G0 and G1 pass."},
        {"path": "CAL001_subject_mask.png", "status": "withheld",
         "reason": "A subject mask for the real source cannot be authored without the "
                   "source frame. The stand-in mask is published under dryrun/ instead."},
        {"path": "CAL001_subject_diff.png", "status": "withheld",
         "reason": "No composite of the real source exists, so no real subject "
                   "difference map exists. The stand-in difference map is published "
                   "under dryrun/ instead."},
    ]

    manifest = {
        "work_order_id": "WO-NUDICITY-CAL001",
        "generated_at_utc": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "execution": {
            "mode": "Arena agent sandbox, local repository checkout",
            "location": MISSION_DIR,
            "platform": platform.platform(),
            "python": sys.version.split()[0],
            "workspace_venv": "/home/user/.venv",
            "original_source_overwritten": False,
            "source_frame_present": False,
            "source_frame_expected": "8B9E1FE1-EE2E-49E6-A10E-375D1CAF4CEB.jpeg (1152x1536)",
        },
        "model": {
            "selected_role": "background plate generator",
            "interface": "Arena-native image generation tool (generate_image)",
            "model_identifier": None,
            "model_identifier_note": ("The Arena-native image tool does not expose a model "
                                      "id, version, provider or retention policy in its "
                                      "interface or in its result payload. This is recorded "
                                      "as an open G1 documentation gap, not as an assertion "
                                      "that no model was used."),
            "invocation_mode_used": "text-to-image plate generation (no input image uploaded)",
            "local_synthesis_engine": {
                "name": "OpenCV GrabCut + morphology + distance-transform compositing",
                "version": "opencv-python-headless 5.0.0 (numpy 2.4.6, Pillow 13.0.0, SciPy 1.17.1)",
                "license": "Apache-2.0 (OpenCV), HPND (Pillow), BSD-3-Clause (NumPy/SciPy)",
                "model_weights_required": False,
            },
            "seed": {"standin_synthesis": 20261111,
                     "plate_generation": "not exposed by the Arena-native tool"},
        },
        "settings": {
            "mask_build": {
                "grabcut_init": "GC_INIT_WITH_RECT per operator seed rectangle",
                "grabcut_iterations": 6,
                "banded_refinement_band_px": 14,
                "safety_dilate_px": 8,
                "core_erode_px": 12,
                "feather_band_px": 10,
            },
            "composite": {
                "plate_fit": "centre-crop to 3:4 then resize to source frame",
                "plate_alignment": "translation only, window-centre matched, clamped to 10% of frame width",
                "plate_window_suppression": "cv2.inpaint TELEA over the detected plate window",
                "feather_direction": "outward only, zero overlap with the protected region",
                "output_format": "PNG (lossless) so protected pixels stay byte-identical",
            },
        },
        "artifacts": artefacts,
        "withheld_artifacts": withheld,
        "gates": {
            "G0_privacy_consent": ("blocked on source delivery only - consent scope "
                                    "confirmed 2026-11-11 (covers AI-assisted edits and "
                                    "third-party processing); the source-lock steps "
                                    "(private read-only copy + SHA-256) await the frame"),
            "G1_model_eligibility": ("pass - nine candidate families inventoried against "
                                     "observed evidence; the provider disclosure gap was "
                                     "disclosed before the C3-PLATE approval of 2026-11-11 "
                                     "and is closed by that informed decision"),
            "G2_subject_pixel_integrity": "pass (dry-run, 9/9 checks, 0 changed protected pixels)",
            "G3_visual_coherence": "pass (dry-run, 0 new hard seams, window residual 0 px)",
            "G4_human_approval": ("partial - model selection approved 2026-11-11; approval "
                                   "of the creative result pending because the source "
                                   "composite does not yet exist"),
        },
        "reproducibility": {
            "environment": "requirements.lock.txt",
            "bootstrap": "scripts/bootstrap_env.sh",
            "note": ("/home/user/.venv is excluded from Arena session snapshot persistence "
                     "and is removed between session turns (observed during this work "
                     "order). The lockfile pins the exact versions the dry-run artefacts "
                     "were produced with."),
            "source_frame_runner": "scripts/run_source_frame.sh",
        },
    }

    write_json(os.path.join(MISSION_DIR, "run_manifest.json"), manifest)
    print(json.dumps({"artifacts": len(artefacts),
                      "missing": [a["path"] for a in artefacts if not a["present"]],
                      "withheld": len(withheld)}, indent=2))


if __name__ == "__main__":
    main()
