# WO-NUDICITY-CAL001 — Model Inventory

**Work order:** WO-NUDICITY-CAL001 — First Edit Model Selection & Calibration
**Inventory taken:** 2026-11-11
**Inventory taken by:** Arena agent sandbox, `/home/user/wrasal-control`
**Method:** every entry below was *observed* in the execution environment or
*probed* over the network. Nothing is asserted from memory or from documentation
that could not be reached. Raw probe output is in
`evidence/environment_probe.json`; the code that produced it is
`scripts/probe_environment.py`.

> **Critical finding, stated first.** The source frame
> `8B9E1FE1-EE2E-49E6-A10E-375D1CAF4CEB.jpeg` (1152 × 1536) **is not present
> in this execution environment**. A whole-filesystem search returned zero
> `.jpeg`/`.jpg` files outside system directories, and a Google Drive search
> across all drives (including trashed items) returned exactly one JPEG —
> `Presentation - REDEFINE REALITY.jpg`, which is unrelated. The work order's
> "Current evidence" claim that the source exists locally could not be
> reproduced and is contradicted by the search. Consequence: **G0 cannot pass**,
> the source-dependent artefacts are withheld, and no edit was performed on the
> real frame.

---

## 1. Execution environment (measured)

| Property | Observed value | Consequence |
|---|---|---|
| Platform | `Linux-6.1.158+-x86_64-with-glibc2.36`, x86_64 | — |
| Python | 3.11.2 (venv at `/home/user/.venv`) | — |
| GPU | `nvidia-smi` **not present**; no CUDA runtime | Local diffusion inference is impossible on any practical budget |
| RAM | 3.8 GiB total | A SD/Flux UNet would not fit with useful throughput |
| Disk | 21 GiB, 20 GiB free | Sufficient for the local classical toolchain only |
| ComfyUI | **not on PATH**, no `/ComfyUI`, no `comfy` binary | Local SD inpainting route unavailable |
| Installed imaging stack | `numpy 2.4.6`, `opencv-python-headless 5.0.0`, `Pillow 13.0.0`, `SciPy 1.17.1`, `matplotlib 3.11.2` | This is the local pixel-lock / compositing engine |

### Network egress (probed, `evidence/environment_probe.json`)

| Host | Reachable | Role for this work order |
|---|---|---|
| `pypi.org`, `files.pythonhosted.org` | yes | Python packages (and any package that *bundles* weights) |
| `registry.npmjs.org` | yes | npm packages |
| `github.com`, `api.github.com`, `codeload.github.com` | yes | Source code, release **metadata** |
| `raw.githubusercontent.com` | **no** | Blocked — raw file fetch impossible |
| `objects.githubusercontent.com` | **no** | Blocked — release-asset CDN |
| `release-assets.githubusercontent.com` | **no** | Blocked — release-asset CDN (verified: a `u2net.onnx` fetch ends at the 302 redirect with 0 bytes) |
| `huggingface.co` | **no** | Blocked — primary host for SD / Flux / SAM weights |
| `civitai.com` | **no** | Blocked — community weight host |
| `storage.googleapis.com` | **no** | Blocked — MediaPipe weight host |

**Consequence:** no pretrained *diffusion* or *neural segmenter* weight file is
obtainable in this sandbox, because every host that serves one is blocked, and
release-asset downloads terminate at the redirect with zero bytes. The only
weights that could ever arrive here are ones **bundled inside a PyPI wheel**.

---

## 2. Candidate inventory

### C1 — Local Stable Diffusion inpainting via ComfyUI

| Field | Value |
|---|---|
| Model identifiers / versions | **None. Not installed.** No `comfy` binary on PATH; no `/ComfyUI` tree; no SD/SDXL checkpoint files anywhere on disk |
| Host location | n/a |
| Mask / inpainting support | Would support, if installed (not installed) |
| Retention policy | n/a — local only |
| License | n/a — not installed |
| Evidence | `environment_probe.json` → `host.comfyui_on_path = false`; filesystem search for checkpoints → none |
| **Eligibility** | **REJECTED — absent.** Two independent hard blockers: the software is not present, and the weights it needs cannot be downloaded (HF blocked, no GPU, 3.8 GiB RAM) |

### C2 — Compatible Flux inpainting / editing variants (local)

| Field | Value |
|---|---|
| Model identifiers / versions | **None. Not installed.** No `diffusers`, no `transformers`, no `torch`, no Flux weights on disk or obtainable |
| Host location | n/a |
| Mask / inpainting support | n/a |
| Retention policy | n/a |
| License | n/a |
| Evidence | `environment_probe.json` → `installed_packages` has no ML runtimes; `huggingface.co` and `civitai.com` both unreachable; `nvidia_smi_present = false` |
| **Eligibility** | **REJECTED — unobtainable.** Weights have no reachable host; no GPU; RAM budget below any workable inference size. Also note Flux-family licences carry downstream-use conditions that would need separate review even if the weights were reachable |

### C3 — Arena-native image editor (`generate_image`)

| Field | Value |
|---|---|
| Model identifier / version | **NOT EXPOSED.** The tool's interface exposes no model id, no version, no provider name, and the tool result payload returned only `{file_path, status}` with no model attribution. This is recorded as an **open G1 documentation gap** — not as a claim that no model ran |
| Host location | Remote, provider-operated; not observable from the sandbox |
| Mask / inpainting support | **None.** The tool accepts `prompt`, `file_path`, `images` (reference images) and `offer_options`. There is **no mask parameter and no negative-region control**. Verified by direct test: an edit-mode call on the synthetic stand-in re-rendered the entire frame — the window moved, the wall and curtain layout changed, and both figures were re-posed and re-rendered (`dryrun/dryrun_editor_editmode_probe.png`) |
| Pixel-lock route | **Yes, but only via the local compositor.** The editor can be used as a *background plate generator*; the protected region is then restored byte-exact from the source by the local compositor. Applied directly, it changed **462 837 of 464 013 protected pixels (99.76 %)**, max |Δ| = 192 → **fails G2** (`dryrun/dryrun_editor_probe_audit.json`) |
| Retention policy | **NOT DISCLOSED** by the interface. Unverifiable from inside the sandbox |
| License | **NOT DISCLOSED** by the interface |
| Evidence | `dryrun/dryrun_editor_probe_audit.json`, `dryrun/dryrun_editor_editmode_probe.png`, `dryrun/dryrun_background_plate.png` |
| **Eligibility** | **ELIGIBLE for the plate-generator role only.** It must not receive the real source frame, and it must never be used as the final frame. Provider retention and licence remain **unverified** — G1 carries an open documentation gap |

### C4 — Local classical mask + compositing engine (OpenCV)

| Field | Value |
|---|---|
| Model identifiers / versions | `opencv-python-headless 5.0.0` (GrabCut, morphology, distance transform, `inpaint`), `numpy 2.4.6`, `Pillow 13.0.0`, `SciPy 1.17.1` |
| Host location | Local, inside the sandbox at `/home/user/.venv` |
| Mask / inpainting support | **Yes.** `cv2.grabCut` with `GC_INIT_WITH_RECT` per operator seed rectangle, union across rectangles, then a banded refinement pass |
| Pixel-lock route | **Yes — this is the authoritative lock.** The protected region (subject union ∪ preserved window opening and frame) is copied byte-exact; the feather ramp runs strictly *outward* from it, so no blend touches a protected pixel |
| Retention policy | **None — no egress at all.** Nothing in this leg leaves the machine |
| License | Apache-2.0 (OpenCV), HPND (Pillow), BSD-3-Clause (NumPy / SciPy) — permissive, no source-photo obligations |
| Evidence | `dryrun/dryrun_mask_metrics.json`, `dryrun/dryrun_verification.json`, `scripts/build_mask.py`, `scripts/composite.py`, `scripts/verify_integrity.py` |
| **Eligibility** | **ELIGIBLE — SELECTED as the mask and pixel-lock engine.** Weights-free, licence-clean, fully local, deterministic and re-runnable |

### C5 — MediaPipe selfie segmentation

| Field | Value |
|---|---|
| Model identifiers / versions | `mediapipe 1.2.2` installs, but the wheel **ships no `.tflite` file** (searched the whole site-packages tree: zero hits) |
| Host location | n/a |
| Evidence | `mediapipe` 1.2.2 installed then removed; `find site-packages/mediapipe* -name "*.tflite"` → 0 results; `storage.googleapis.com` unreachable |
| **Eligibility** | **REJECTED — weights unobtainable.** The wheel bundles no model and the weight host is blocked. It was also removed from the venv so that it does not pull the non-headless `opencv-contrib-python` build that breaks `cv2` with `libGL.so.1: cannot open shared object file` |

### C6 — rembg / u2net (and BiRefNet-portrait) via GitHub release assets

| Field | Value |
|---|---|
| Model identifiers / versions | `u2net.onnx`, `BiRefNet-portrait-epoch_150.onnx` and siblings exist in `danielgatis/rembg` release `v0.0.0` (confirmed via `api.github.com` release-asset listing) |
| Host location | n/a — assets are served from `release-assets.githubusercontent.com` |
| Evidence | `api.github.com/repos/danielgatis/rembg/releases/tags/v0.0.0` lists `BiRefNet-portrait-epoch_150.onnx` (972 666 916 bytes) and `u2net.onnx`; a direct fetch of `u2net.onnx` returns HTTP 302 with **0 bytes downloaded** because `release-assets.githubusercontent.com` is unreachable |
| **Eligibility** | **REJECTED — release-asset CDN blocked.** Note: `BiRefNet-portrait` would have been the preferred portrait-matting model for this task; it remains unavailable here |

### C7 — Segment Anything (facebookresearch/segment-anything)

| Field | Value |
|---|---|
| Model identifiers / versions | `sam_vit_b_01ec64.pth` (v1.0 release) |
| Evidence | `https://github.com/facebookresearch/segment-anything/releases/download/v1.0/sam_vit_b_01ec64.pth` → **HTTP 404** from this network; primary distribution host `huggingface.co` unreachable; release-asset CDN unreachable |
| **Eligibility** | **REJECTED — weights unobtainable** (404 on the release path, blocked hosts elsewhere) |

### C8 — `image_search` (stock imagery) as a plate source

| Field | Value |
|---|---|
| Model identifiers / versions | Web image search, no model identifier |
| Mask / inpainting support | n/a — returns whole images, no geometry control |
| Evidence | Tool schema exposes only `query` and `count` |
| **Eligibility** | **REJECTED as the plate source.** It cannot be constrained to the source frame's curtain/wall geometry, and stock-image provenance/licence for a private fine-art composite would need separate clearance. Retained only as an optional reference source for art direction |

---

## 3. Inventory conclusion

There **is** a policy-compatible route in this environment, and it is a
two-stage composite rather than a single masked-inpainting model:

1. **Arena-native image generator** produces a *background plate* from a text
   prompt. **No source pixels are uploaded** — only the prompt and numeric
   geometry leave the sandbox.
2. **Local OpenCV pipeline** restores the protected region byte-exact from the
   source and blends the plate underneath it with an outward-only feather.

This route was executed end-to-end on a non-sensitive synthetic stand-in and
passed every integrity and coherence check
(`dryrun/dryrun_verification.json`: 9/9 checks pass, 0 changed pixels inside the
protected region).

The route **has not** been run on the real source frame, because the source
frame is absent from the environment and no consent or external-processing
clearance record was supplied. See `qa_report.md`.

### Open items — status as at 2026-11-11

| # | Item | Status |
|---|---|---|
| O1 | Deliver the source frame `8B9E1FE1-EE2E-49E6-A10E-375D1CAF4CEB.jpeg` (1152 × 1536) into the sandbox | ⏳ **Open** — route chosen: attach it to the Arena conversation |
| O2 | Model consent scope: does it cover AI-assisted edits, and does it limit third-party processing? | ✅ **Closed** — covers AI-assisted edits **and** third-party processing |
| O3 | Written retention/licence statement for the Arena-native image provider | ✅ **Closed by informed decision** — the gap was disclosed here and in `qa_report.md` §1/§3 *before* the Creative Director approved C3-PLATE on 2026-11-11. The selected route uploads no source pixels, so the provider never holds the source frame; the statement would only be required if the frame itself were to be transmitted |
| O4 | Author the operator seed rectangles over the real frame and record the window opening rectangle (`config/cal001_mask_config.template.json` is ready to complete) | ⏳ **Open** — actionable the moment the frame is attached |

### Reproducibility note

`/home/user/.venv` is excluded from Arena session snapshot persistence and is
removed between session turns — observed during this work order. The
environment is therefore pinned in `requirements.lock.txt` and restored with
`scripts/bootstrap_env.sh`, which re-creates the exact versions the dry-run
artefacts were produced with. Re-running the pipeline with those pins
reproduces byte-identical mask and composite outputs.
