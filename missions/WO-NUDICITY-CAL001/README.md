# WO-NUDICITY-CAL001 — First Edit Model Selection & Calibration

**Status:** 🛑 BLOCKED at G0 **on source delivery only** — the source frame is not
yet attached to the session. The model selection was approved (C3-PLATE) and the
consent scope was confirmed (covers AI-assisted edits and third-party
processing) on 2026-11-11. The background-only editing pipeline is complete and
validated on a non-sensitive synthetic stand-in; the single permitted
source-frame edit has not been performed and no private photograph was
transmitted to any service.

**Creative brief:** Chapter III — AFTER DARK
**Owner / approval authority:** NUDICITY Creative Director

## Documents

| Document | Purpose |
|---|---|
| `model_inventory.md` | Verified model/tool inventory, eligibility notes, environment probe results |
| `selection_matrix.csv` | Rubric scoring (100 points) for nine candidates, with evidence |
| `qa_report.md` | Gate-by-gate result, defects found and corrected, deliverables ledger, unblock list, approval request |
| `run_manifest.json` | Provenance of record: model, settings, seeds, SHA-256 for every artefact, timestamps, locations |
| `config/cal001_mask_config.template.json` | Template to complete against the real source frame |
| `evidence/environment_probe.json` | Raw, re-runnable environment and egress evidence |
| `dryrun/` | Stand-in dry-run artefacts, before/after, masks, diffs, metrics, verification |
| `scripts/` | The reproducible pipeline |

## Architecture of the selected route

The selected route is a **two-stage composite**, not a single masked-inpainting
model, because no masked-inpainting model is reachable here and the one masked
editor that *is* reachable has no mask input.

```
  text prompt  ──────────────►  Arena-native image generator  ──►  background plate
  (geometry as numbers only)         (no source pixels uploaded)         │
                                                                            │
  source frame ──► local OpenCV: subject mask (GrabCut + refinement) ───────┤
                     │                                                        │
                     └──────────► local compositor ──────────────────────────┘
                                    protected region copied byte-exact
                                    outward-only feather, zero overlap
```

Two properties fall out of this design:

1. **The pixel lock is structural, not prompt-dependent.** The protected region
   (subject union ∪ preserved window opening and frame) is copied from the source
   in the integer buffer; the feather ramp runs strictly outward from it, so no
   blend can touch a protected pixel. Verified: 0 changed pixels, max |Δ| = 0.
2. **No source pixels leave the sandbox.** The generator receives a text prompt
   and numeric geometry; it never receives the frame.

## Runbook (once O1 and O4 in `qa_report.md` §7 are met)

**One command does the whole source-frame run** — source lock, mask, composite
and independent verification — and refuses to run against an uncompleted
config:

```sh
cd missions/WO-NUDICITY-CAL001
PLATE=<generated_plate.png> bash scripts/run_source_frame.sh <path_to_source.jpeg>
```

`/home/user/.venv` is excluded from Arena session snapshot persistence and is
removed between session turns. Restore it first with:

```sh
bash missions/WO-NUDICITY-CAL001/scripts/bootstrap_env.sh
```

<details>
<summary>Underlying steps, run individually</summary>

```sh
cd missions/WO-NUDICITY-CAL001/scripts
P=/home/user/.venv/bin/python

# 1. Copy the source to a private read-only location and record its SHA-256.
install -m 0440 <source.jpeg> /home/user/.cal001_private/source_readonly.jpeg
sha256sum /home/user/.cal001_private/source_readonly.jpeg

# 2. Complete the mask config against the real frame:
#    subject_seed_rects (one per person), window_rect, edit_region_rect,
#    left/right_curtain_rect.
$EDITOR ../config/cal001_mask_config.json

# 3. Mask the real frame.
$P build_mask.py --image /home/user/.cal001_private/source_readonly.jpeg \
                 --config ../config/cal001_mask_config.json \
                 --out-dir ../dryrun --prefix CAL001

# 4. Generate the background plate (text-to-image only — never pass the source
#    frame into the generator). Prompt must name the drape colour, the window
#    position as percentages, the red ambient direction and the 3:4 crop.

# 5. Composite the background-only edit.
$P composite.py --source /home/user/.cal001_private/source_readonly.jpeg \
                --plate <generated_plate.png> \
                --subject-mask ../dryrun/CAL001_subject_mask.png \
                --config ../config/cal001_mask_config.json \
                --out-dir ../dryrun --prefix CAL001

# 6. Independent verification — exits non-zero on any G2/G3 failure.
$P verify_integrity.py --source /home/user/.cal001_private/source_readonly.jpeg \
                       --after ../dryrun/CAL001_after.png \
                       --subject-mask ../dryrun/CAL001_subject_mask.png \
                       --config ../config/cal001_mask_config.json \
                       --out ../dryrun/CAL001_verification.json

# 7. Refresh the manifest.
$P build_manifest.py
```

`CAL001_background_test.png` is produced only if G0 and G1 both pass; the
compositor writes `CAL001_after.png` and the Creative Director promotes it to
the briefed filename after human approval.

</details>

## Reproducing the dry-run from scratch

```sh
cd missions/WO-NUDICITY-CAL001/scripts
P=/home/user/.venv/bin/python
$P synth_standin.py
$P build_mask.py --image ../dryrun/standin_source.png \
                 --config ../dryrun/standin_mask_config.json \
                 --out-dir ../dryrun --ground-truth ../dryrun/standin_gt_mask.png \
                 --prefix dryrun
$P composite.py --source ../dryrun/standin_source.png \
                --plate ../dryrun/dryrun_background_plate.png \
                --subject-mask ../dryrun/dryrun_subject_mask.png \
                --config ../dryrun/standin_mask_config.json \
                --out-dir ../dryrun --prefix dryrun
$P verify_integrity.py --source ../dryrun/standin_source.png \
                       --after ../dryrun/dryrun_after.png \
                       --subject-mask ../dryrun/dryrun_subject_mask.png \
                       --config ../dryrun/standin_mask_config.json \
                       --ground-truth ../dryrun/standin_gt_mask.png \
                       --out ../dryrun/dryrun_verification.json
$P probe_environment.py ../evidence/environment_probe.json
$P build_manifest.py
```

## Environment

Python 3.11.2 with `numpy 2.4.6`, `opencv-python-headless 5.0.0.93`,
`Pillow 13.0.0`, `SciPy 1.17.1`, `matplotlib 3.11.2` — pinned in
`requirements.lock.txt` and restored by `scripts/bootstrap_env.sh`. No GPU. No
ComfyUI. No model weights obtainable — see `model_inventory.md` §1.
