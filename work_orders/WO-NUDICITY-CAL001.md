# Arena Work Order

WORK_ORDER_ID: WO-NUDICITY-CAL001

VERSION: v001

CREATED_ON: 2026-11-11

STATUS: BLOCKED AT G0 — MODEL SELECTION COMPLETE, PIPELINE VALIDATED ON STAND-IN, SOURCE FRAME NOT PRESENT (canonical_acceptance: pending)

PROJECT: NUDICITY (WRASAL Media — fine-art photographic production; Chapter III "AFTER DARK")

OBJECTIVE: Select the best actually-available and policy-compatible image-editing model in Arena's arsenal and run a background-only photographic refinement proof of concept that preserves the real people, the original pose, the physical contact and the source pixels byte-exactly — with no subject regeneration, anatomical modification, or change in the intimate activity.

SUCCESS_CONDITION: A verifiable model inventory and rubric-scored selection with a winner and runner-up exist; a dry-run on a non-sensitive stand-in proves the selected route changes zero pixels inside the protected region; the source-frame edit executes only after G0 and G1 pass; the protected region in the final composite is a byte-exact copy of the source; the original is never overwritten; and the Creative Director explicitly approves the result.

AUTHORITATIVE_INPUTS:
- Work order WO-NUDICITY-CAL001 as dispatched 2026-11-11 (source: 8B9E1FE1-EE2E-49E6-A10E-375D1CAF4CEB.jpeg, declared 1152x1536)
- NUDICITY Creative brief, Chapter III "AFTER DARK" (edit region: curtains and upper wall only; preserve the existing window opening and its geometry)
- missions/WO-NUDICITY-CAL001/model_inventory.md (verified inventory and eligibility notes)
- missions/WO-NUDICITY-CAL001/selection_matrix.csv (rubric scoring with evidence)
- missions/WO-NUDICITY-CAL001/qa_report.md (gate results, defects found and corrected, deliverables ledger, unblock list)
- missions/WO-NUDICITY-CAL001/run_manifest.json (provenance of record: hashes, settings, seeds, timestamps)
- missions/WO-NUDICITY-CAL001/dryrun/dryrun_verification.json (independent G2/G3 verification)
- missions/WO-NUDICITY-CAL001/evidence/environment_probe.json (observed environment and egress evidence)

DEPENDENCIES:
- O1 (BLOCKS G0) — Delivery of the source frame 8B9E1FE1-EE2E-49E6-A10E-375D1CAF4CEB.jpeg into the execution environment. Not present: a whole-filesystem search returned zero JPEG files outside system directories, and a Google Drive search across all drives including trashed items returned only one unrelated JPEG.
- O2 (BLOCKS G0) — Written model consent scope confirming coverage of AI-assisted edits and stating any limits on third-party processing. Not supplied with the dispatch.
- O3 (BLOCKS G1 GAP) — Written retention and licence statement for the Arena-native image provider, if the Creative Director requires the source frame to be sent to that provider. Note the selected route uploads no source pixels, so this is required only if the frame itself may be transmitted.
- O4 (BLOCKS G2 on the real frame) — Operator-authored subject seed rectangles and the window opening rectangle, to be entered in config/cal001_mask_config.template.json.
- O5 (G4) — NUDICITY Creative Director approval of the model selection and of the final composite.

CURRENT_TASK: G0 — deliver the source frame and the consent scope (O1, O2). The selection, the pipeline and the dry-run are complete and require no further work before the source arrives.

ACCEPTANCE:
- G0 Privacy/consent — PASS before any external inference. Currently BLOCKED.
- G1 Model eligibility — PASS with a documented open gap (the Arena-native image tool exposes no model id, version, provider, licence or retention policy in its interface or result payload).
- G2 Subject pixel integrity — zero modified pixels inside the protected core mask; feathering strictly outside the protected region. PASS on the dry-run (0 changed pixels, max |delta| = 0, 0 protected pixels covered by the feather band).
- G3 Visual coherence — no halos, doubled limbs, false contact shadows or implausible light; window geometry preserved. PASS on the dry-run (0 new hard vertical seams, edge-strength delta +3.23 of 6.0 allowed, rim delta -6.33 of 10.0 allowed, window alignment residual dx 0 px / dy 0 px).
- G4 Human approval — Creative Director explicitly approves or requests revisions. PENDING.
- Deliverables produced: model_inventory.md, selection_matrix.csv, run_manifest.json, qa_report.md, dryrun/ artefacts, evidence/environment_probe.json, scripts/, config/cal001_mask_config.template.json.
- Deliverables withheld: CAL001_background_test.png (permitted only if G0 and G1 pass), CAL001_subject_mask.png and CAL001_subject_diff.png (require the source frame).
- Control-plane validation: npm test PASS.

DECISIONS:
- No masked-inpainting model is reachable in this environment. ComfyUI is absent, there is no GPU, RAM is 3.8 GiB, and every host that serves diffusion or segmentation weights is blocked (huggingface.co, civitai.com, storage.googleapis.com, raw.githubusercontent.com, objects.githubusercontent.com, release-assets.githubusercontent.com). Candidates C1, C2, C5, C6, C7 are rejected on observed evidence, not on assumption.
- The Arena-native image generator has no mask parameter. Applied directly to a frame it re-renders the frame: measured on the synthetic stand-in it changed 462,837 of 464,013 protected pixels (99.76 percent), max |delta| = 192, and visibly moved the window and re-posed both figures. The direct route is rejected.
- Selected route (C3-PLATE, 92/100): generate a background plate by text-to-image, then restore the protected region byte-exactly with a local OpenCV compositor. Runner-up (C4-LOCAL, 83/100): fully local classical route, zero egress, but cv2.inpaint cannot produce fabric fold structure.
- The selected route uploads no source pixels. Only the prompt text and numeric geometry leave the sandbox, which neutralises provider retention for the source photograph itself.
- The protected region is the subject union PLUS the preserved window opening and its frame. The window is protected because the brief requires its geometry to be preserved.
- The feather ramp runs strictly outward from the protected region, so no blend touches a protected pixel. This is stronger than the G2 minimum and is verified independently by scripts/verify_integrity.py, which re-reads every artefact from disk.
- Mask route: per-figure GrabCut rectangle initialisation (GC_INIT_WITH_RECT) with union and banded refinement, plus an 8 px safety dilation so the protected region fully contains the subject. Mask-initialised trimaps were tried first and produced a preserved slab of original background (raw IoU 0.833); rectangle initialisation raised raw IoU to 0.9812.
- Plate fitting: translation-only window-centre matching at 1:1 scale, shift clamped to 10 percent of frame width, with the plate's own window suppressed by inpainting. Scale-based alignment was tried first and pushed the generated drapery out of frame.
- Output format is PNG (lossless) so protected pixels remain byte-identical.
- The original is never overwritten. No private photograph was transmitted to any service, and no private source file was created.
- projects.yml has no NUDICITY project record. The control-plane validator requires a non-empty `repo` value for every project entry and no NUDICITY repository is a verified fact, so no entry was invented. Establishing the NUDICITY project record is left to the portfolio owner.
- Defects D1 to D4 found during the dry-run are recorded in qa_report.md §5 rather than being silently corrected.

EVIDENCE:
- missions/WO-NUDICITY-CAL001/model_inventory.md
- missions/WO-NUDICITY-CAL001/selection_matrix.csv
- missions/WO-NUDICITY-CAL001/qa_report.md
- missions/WO-NUDICITY-CAL001/run_manifest.json
- missions/WO-NUDICITY-CAL001/README.md
- missions/WO-NUDICITY-CAL001/config/cal001_mask_config.template.json
- missions/WO-NUDICITY-CAL001/evidence/environment_probe.json
- missions/WO-NUDICITY-CAL001/dryrun/standin_source.png
- missions/WO-NUDICITY-CAL001/dryrun/standin_gt_mask.png
- missions/WO-NUDICITY-CAL001/dryrun/standin_geometry.json
- missions/WO-NUDICITY-CAL001/dryrun/dryrun_background_plate.png
- missions/WO-NUDICITY-CAL001/dryrun/dryrun_editor_editmode_probe.png
- missions/WO-NUDICITY-CAL001/dryrun/dryrun_editor_probe_audit.json
- missions/WO-NUDICITY-CAL001/dryrun/dryrun_subject_mask.png
- missions/WO-NUDICITY-CAL001/dryrun/dryrun_subject_core.png
- missions/WO-NUDICITY-CAL001/dryrun/dryrun_subject_band.png
- missions/WO-NUDICITY-CAL001/dryrun/dryrun_mask_metrics.json
- missions/WO-NUDICITY-CAL001/dryrun/dryrun_after.png
- missions/WO-NUDICITY-CAL001/dryrun/dryrun_subject_diff.png
- missions/WO-NUDICITY-CAL001/dryrun/dryrun_edge_spill.png
- missions/WO-NUDICITY-CAL001/dryrun/dryrun_composite_metrics.json
- missions/WO-NUDICITY-CAL001/dryrun/dryrun_verification.json
- missions/WO-NUDICITY-CAL001/scripts/cal001_lib.py
- missions/WO-NUDICITY-CAL001/scripts/synth_standin.py
- missions/WO-NUDICITY-CAL001/scripts/build_mask.py
- missions/WO-NUDICITY-CAL001/scripts/composite.py
- missions/WO-NUDICITY-CAL001/scripts/verify_integrity.py
- missions/WO-NUDICITY-CAL001/scripts/audit_editor_probe.py
- missions/WO-NUDICITY-CAL001/scripts/probe_environment.py
- missions/WO-NUDICITY-CAL001/scripts/build_manifest.py
