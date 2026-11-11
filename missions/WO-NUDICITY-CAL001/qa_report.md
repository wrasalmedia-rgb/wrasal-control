# WO-NUDICITY-CAL001 — QA Report

**Work order:** WO-NUDICITY-CAL001 — First Edit Model Selection & Calibration
**Date:** 2026-11-11
**Executor:** Arena agent sandbox (Image Model Evaluator / Photographic Integrity QA)
**Creative brief:** Chapter III — AFTER DARK

---

## 1. Verdict

> ## 🛑 BLOCKED — at gate G0
>
> **The source frame is not present in the execution environment.**
> `8B9E1FE1-EE2E-49E6-A10E-375D1CAF4CEB.jpeg` (1152 × 1536) could not be
> located anywhere: a whole-filesystem search returned **zero** `.jpeg` / `.jpg`
> files outside system directories, and a Google Drive search across all drives
> (including trashed items) returned exactly one JPEG —
> `Presentation - REDEFINE REALITY.jpg` — which is unrelated. The work order's
> "Current evidence" claim that the source exists locally could not be
> reproduced and is contradicted by the search.
>
> **Consequence.** Steps 1, 4 and 5 of the Execution section could not be run
> against the real frame, `CAL001_background_test.png` was **withheld** (the
> brief permits it only if G0 and G1 pass), and no image edit was performed on
> any private photograph. **No source pixel left the sandbox at any point.**
>
> **What *was* completed.** The model inventory, the policy/license gate, the
> rubric-scored selection with a winner and a runner-up, and a **full end-to-end
> dry-run of the selected route on a non-sensitive synthetic stand-in**, with
> independent verification: **9 / 9 integrity and coherence checks pass, 0
> modified pixels inside the protected region.** The pipeline is validated and
> ready; it is the *input* that is missing.

---

## 2. Gate results

| Gate | Result | Evidence |
|---|---|---|
| **G0 Privacy / consent** | 🛑 **BLOCKED** | Source frame absent from the sandbox and from Drive → cannot copy it to a read-only location, cannot record its SHA-256, cannot verify consent scope attached to the frame. No consent record covering AI-assisted edits or third-party processing was supplied with the dispatch. |
| **G1 Model eligibility** | ⚠️ **PASS with an open documentation gap** | Seven candidate families inventoried and probed (`model_inventory.md`). Two are eligible. The selected editor **does not expose a model id, version, provider, licence or retention policy** — its tool result returns only `{file_path, status}`. Recorded as an open gap, not as an assertion. |
| **G2 Subject pixel integrity** | ✅ **PASS (dry-run)** | `dryrun/dryrun_verification.json` — 9/9 checks. `changed_pixels_inside_protected = 0`, `max_abs_delta_in_protected = 0`, `feather_pixels_inside_protected = 0`, `changed_pixels_outside_edit_region = 0`, `changed_pixels_in_window = 0`, `subject_pixels_outside_protected = 0`. |
| **G3 Visual coherence** | ✅ **PASS (dry-run)** | `new_hard_vertical_seams = 0`; boundary edge-strength delta `+3.23` (threshold 6.0); rim-luma delta `-6.33` (threshold 10.0); window geometry residual `dx = 0 px, dy = 0 px`; drapery column coverage 0.70 (left) / 0.94 (right); background mean-luma drift 29.7 vs 28.9 — i.e. the replacement reads as the same scene under the same light. |
| **G4 Human approval** | ⏳ **PENDING** | Awaiting the NUDICITY Creative Director. Nothing was approved implicitly by the pipeline passing. |

### G2 detail — independent verification

`scripts/verify_integrity.py` re-reads every artefact from disk and re-derives
the protected region from the mask files, so it does not trust any in-memory
state produced by the mask builder or the compositor.

```
PASS  frame_size_identical
PASS  G2a_core_pixels_unmodified            core_pixels = 262482, changed = 0, max |Δ| = 0
PASS  G2b_protected_region_unmodified        protected_pixels = 464013, changed = 0, max |Δ| = 0
PASS  G2c_feather_strictly_outside_protected feather_pixels_inside_protected = 0
PASS  G2d_no_change_outside_edit_region      changed_outside_edit_region = 0
PASS  G2e_window_opening_preserved           window_pixels = 220792, changed = 0, max |Δ| = 0
PASS  G3a_no_new_hard_vertical_seams          new_seam_count = 0
PASS  G3b_no_halo_rim_at_subject_boundary    edge Δ = 3.23 (≤6.0), rim Δ = -6.33 (≤10.0)
PASS  G2f_protected_region_covers_subject    subject_pixels_outside_protected = 0
```

---

## 3. Model selection

Full inventory: `model_inventory.md`. Rubric scoring: `selection_matrix.csv`.

| | Candidate | Score /100 | Status |
|---|---|---|---|
| **Winner** | **C3-PLATE** — Arena-native image generator as a *background-plate generator*, plus the local OpenCV byte-exact compositor | **92** | Eligible in the plate-generator role only |
| **Runner-up** | **C4-LOCAL** — fully local classical route (GrabCut mask + `cv2.inpaint` fill + local composite) | **83** | Eligible; best privacy posture, weakest creative quality |

**Why the winner is a two-stage route and not a masked-inpainting model.** No
masked-inpainting model is reachable in this environment, and the one masked
editor that *is* reachable has no mask input at all. Applying it directly to a
frame re-renders the frame: measured on the synthetic stand-in it changed
**462 837 of 464 013 protected pixels (99.76 %)**, max |Δ| = 192, and visibly
moved the window and re-posed both figures
(`dryrun/dryrun_editor_editmode_probe.png`,
`dryrun/dryrun_editor_probe_audit.json`). That is a hard G2 failure, and it is
why the selected route uses the generator only to produce a *separate
background plate* and then restores the protected region from the source.

**Why the plate route beats the purely local route on quality.** `cv2.inpaint`
(Telea) reproduces low-frequency tone but no fabric fold structure, so it
cannot satisfy "matte charcoal or deep oxblood drapery with subtle folds". The
plate route produces real drape structure, real red ambient falloff and a
window with a genuine light source, and the local compositor still guarantees
the pixel lock.

**The privacy advantage of the plate route.** The plate is generated
**text-to-image**. The only things that leave the sandbox are the prompt text
and numeric geometry — **no source pixels are uploaded at all**. That is what
keeps the source photograph out of any provider's retention system, and it is
why G0 is blocked on *consent scope and source delivery* rather than on the
technical impossibility of a private edit.

### Candidate families named in the work order — all rejected, with evidence

| Family | Verdict | Evidence |
|---|---|---|
| Local Stable Diffusion inpainting via ComfyUI | ❌ Rejected | Not installed (`comfyui_on_path=false`, no checkpoint on disk), no GPU, 3.8 GiB RAM, weight hosts blocked |
| Compatible Flux inpainting / editing variants | ❌ Rejected | Weights unobtainable (`huggingface.co`, `civitai.com` unreachable); no ML runtimes installed |
| Any Arena-native masked image editor | ⚠️ Partial | No mask parameter exists on the tool; used as a plate generator instead, with the lock enforced locally |

Additional families probed and rejected: MediaPipe selfie segmentation (wheel
bundles no `.tflite`; `storage.googleapis.com` blocked), rembg/u2net and
BiRefNet-portrait via GitHub release assets (asset CDN blocked — the fetch ends
at the 302 redirect with 0 bytes), Segment Anything (release asset URL 404 from
this network), and `image_search` stock imagery (no geometry control,
provenance unclear).

---

## 4. Dry-run detail (Execution step 3)

**Input.** `dryrun/standin_source.png` — a 1152 × 1536 synthetic frame produced
entirely locally by `scripts/synth_standin.py` from a fixed seed (20261111). It
contains **no real person and no sexual content**: two abstract draped forms
standing in contact, a window opening, charcoal curtain columns, red ambient
wash from the left and cool light from the window. A ground-truth union subject
alpha is produced alongside it, so the masking route can be scored numerically.

**Mask quality** (`dryrun/dryrun_mask_metrics.json`):

| Metric | Value |
|---|---|
| Raw mask IoU vs ground truth | **0.9812** |
| Protected-region IoU (after 8 px safety dilation) | 0.8831 |
| Subject pixels outside the protected region | **0** (100 % coverage) |
| False positives in the raw mask | 4 718 px (1.6 % of the raw mask) |
| Connected components in the union mask | 1 — the two touching figures correctly merge into a single union mask |

**Composite** (`dryrun/dryrun_composite_metrics.json`):

| Metric | Value |
|---|---|
| Generated (plate) pixels | 856 734 |
| Feathered pixels | 38 669 |
| Changed pixels inside the protected region | **0** |
| Max |Δ| inside the protected region | **0** |
| Changed pixels outside the edit region | **0** |
| Changed pixels inside the preserved window | **0** |
| Plate→frame window alignment residual | dx = 0 px, dy = 0 px |
| Plate window suppression | performed (the plate's own window is inpainted away so the preserved source window is the only one) |

---

## 5. Defects found and corrected during the dry-run

Reported because the dry-run is supposed to find these, and a QA report that
hides them is worthless.

| # | Defect | Detection | Correction |
|---|---|---|---|
| D1 | **Preserved slab of original background.** Marking the whole operator seed rectangle as probable-foreground let the GrabCut colour model keep background pixels, so a rectangular patch of the *old* curtain survived around the subject and read as a dark box. | Visual review of `dryrun_after.png`; raw-mask IoU stuck at 0.833 with 54 097 false-positive pixels | Switched the mask route from a mask-initialised trimap to **per-figure rectangle initialisation** (`GC_INIT_WITH_RECT`), then union + banded refinement. IoU 0.833 → **0.9812**, false positives 54 097 → 4 718 |
| D2 | **Drapery pushed out of frame.** Aligning the plate to the source window by *scale* (1.338×) moved the generated curtain columns outside the frame and left an unlit wall patch where the source curtains had been. | Visual review; `curtain_coverage.left_curtain_rect.coverage_ratio` = 0.70 | Changed plate fitting to **translation-only** window-centre matching (scale fixed at 1:1, shift clamped to 10 % of frame width), plus suppression of the plate's own window. New hard seams 0 |
| D3 | **Halo test was measuring the wrong thing.** The first G3b formulation compared the subject's mean luma with the background's, so it flagged a *normal* subject/background contrast as a halo and failed a clean composite. | The check failed on an artefact that was visually correct | Rewrote G3b as a **gradient-and-rim test** comparing boundary edge strength and near-rim brightness in the composite against the same measurements in the source. Now passes with meaningful margins (edge Δ 3.23 / 6.0, rim Δ −6.33 / 10.0) |
| D4 | **Alpha ramp inverted.** The first composite treated pure-plate pixels as blended and blended pixels as replaced, producing a fully feathered edit region instead of a clean plate. | `generated_pixels = 0` with `feathered_pixels = 862735` — obviously wrong for a 10 px band | Rewrote the composite as a single outward-only alpha ramp: `out = source·(1−α) + plate·α`, with `α = 0` forced on every protected pixel and the integer buffer re-stamped from the source for the protected region and the non-edit region |

---

## 6. Deliverables ledger

### Produced

| Deliverable | Status | Path |
|---|---|---|
| `model_inventory.md` | ✅ Produced | `missions/WO-NUDICITY-CAL001/model_inventory.md` |
| `selection_matrix.csv` | ✅ Produced | `missions/WO-NUDICITY-CAL001/selection_matrix.csv` |
| `run_manifest.json` | ✅ Produced | `missions/WO-NUDICITY-CAL001/run_manifest.json` |
| `qa_report.md` | ✅ Produced | `missions/WO-NUDICITY-CAL001/qa_report.md` |
| Dry-run artefacts (before/after, subject mask, subject diff, edge spill, metrics, verification) | ✅ Produced | `missions/WO-NUDICITY-CAL001/dryrun/` |
| Environment probe | ✅ Produced | `missions/WO-NUDICITY-CAL001/evidence/environment_probe.json` |
| Pipeline code | ✅ Produced | `missions/WO-NUDICITY-CAL001/scripts/` |
| Mask config template for the real source | ✅ Produced | `missions/WO-NUDICITY-CAL001/config/cal001_mask_config.template.json` |

### Withheld

| Deliverable | Status | Reason |
|---|---|---|
| `CAL001_background_test.png` | 🛑 **Withheld** | The brief permits this artefact **only if G0 and G1 pass**. G0 did not pass (source frame absent; no consent record). Publishing a file under this name would falsely imply a source-frame result. |
| `CAL001_subject_mask.png` | 🛑 **Withheld** | A subject mask for the real source cannot be authored without the source frame. The stand-in mask is published as `dryrun/dryrun_subject_mask.png` instead. |
| `CAL001_subject_diff.png` | 🛑 **Withheld** | No composite of the real source exists, so no real subject difference map exists. The stand-in difference map is published as `dryrun/dryrun_subject_diff.png` instead. |

**The original was never overwritten.** No private source file was present, none
was created, and no private photograph was transmitted to any service.

---

## 7. What is required to unblock

| # | Requirement | Owner | Blocks |
|---|---|---|---|
| **O1** | Deliver `8B9E1FE1-EE2E-49E6-A10E-375D1CAF4CEB.jpeg` (1152 × 1536) into the sandbox, or authorise a retrieval path for it | Work order owner | G0, all source-dependent artefacts |
| **O2** | Supply the model consent scope: does it cover AI-assisted edits, and does it limit third-party processing? | NUDICITY Creative Director | G0 |
| **O3** | Confirm that **no source pixels** are to be uploaded to any provider. The selected route already satisfies this (text-to-image plate only). If the frame itself may be sent to the provider, a written retention/licence statement is required first | NUDICITY Creative Director | G1 gap |
| **O4** | Author the operator seed rectangles over the real frame and record the window opening rectangle | NUDICITY Creative Director / retoucher | G2 on the real frame |

### The exact command sequence that runs once O1–O4 are met

```sh
cd missions/WO-NUDICITY-CAL001/scripts
P=/home/user/.venv/bin/python

# 0. source -> private read-only copy + SHA-256 (see README.md "Runbook", step 1)
# 1. mask the real frame (operator seed rects come from the completed config)
$P build_mask.py --image <source> \
                 --config ../config/cal001_mask_config.json \
                 --out-dir ../dryrun --prefix CAL001

# 3. composite the background-only edit
$P composite.py --source <source> \
                --plate <generated_plate.png> \
                --subject-mask ../dryrun/CAL001_subject_mask.png \
                --config ../config/cal001_mask_config.json \
                --out-dir ../dryrun --prefix CAL001

# 4. independent verification (non-zero exit on any G2/G3 failure)
$P verify_integrity.py --source <source> \
                       --after ../dryrun/CAL001_after.png \
                       --subject-mask ../dryrun/CAL001_subject_mask.png \
                       --config ../config/cal001_mask_config.json \
                       --out ../dryrun/CAL001_verification.json
```

---

## 8. Approval request

**To the NUDICITY Creative Director:**

1. **Approve or amend the model selection** — C3-PLATE (92/100) as winner, with
   C4-LOCAL (83/100) as runner-up. If you consider the Arena-native provider's
   undisclosed retention and licence terms disqualifying (O3), the runner-up
   executes with zero egress but a materially weaker result.
2. **Confirm the privacy posture** — the selected route uploads no source pixels
   (O3).
3. **Note that nothing has been approved implicitly.** G4 remains PENDING. The
   dry-run passed its own gates on a synthetic stand-in; that is a statement
   about the *pipeline*, not about the *creative result*, which does not yet
   exist.
4. **Release the source frame and the consent scope** (O1, O2) to schedule the
   single permitted source-frame edit.

**Status returned to Arena intake: BLOCKED at G0, with the pipeline validated
and the selection documented.**
