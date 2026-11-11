#!/usr/bin/env bash
# One-command source-frame run for WO-NUDICITY-CAL001.
#
# Prereqs before this script can succeed:
#   1. The source frame is present at $SOURCE (or pass it as $1).
#   2. config/cal001_mask_config.json exists and has been completed by a human:
#        subject_seed_rects (one per person), window_rect, edit_region_rect,
#        left_curtain_rect, right_curtain_rect.
#   3. A background plate has been generated at $PLATE.
#      The plate MUST be text-to-image. Never pass the source frame into the
#      generator: the selected route uploads no source pixels by design.
#
# The script never writes to the source file and never overwrites an existing
# read-only copy.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MISSION="$(cd "${HERE}/.." && pwd)"
PY="${PY:-/home/user/.venv/bin/python}"
PRIVATE_DIR="${PRIVATE_DIR:-/home/user/.cal001_private}"

SOURCE="${1:-${SOURCE:-}}"
PLATE="${PLATE:-}"
CONFIG="${CONFIG:-${MISSION}/config/cal001_mask_config.json}"
OUT_DIR="${OUT_DIR:-${MISSION}/dryrun}"

if [[ -z "${SOURCE}" || ! -f "${SOURCE}" ]]; then
  echo "ERROR: source frame not found. Pass it as \$1 or set SOURCE=." >&2
  exit 2
fi
if [[ -z "${PLATE}" || ! -f "${PLATE}" ]]; then
  echo "ERROR: set PLATE=<generated background plate path>." >&2
  exit 2
fi
if [[ ! -f "${CONFIG}" ]]; then
  echo "ERROR: mask config not found at ${CONFIG}." >&2
  exit 2
fi

# --- 0. refuse to run against an uncompleted config ----------------------
"${PY}" - "${CONFIG}" <<'EOF'
import json, sys
cfg = json.load(open(sys.argv[1]))
missing = []
if not cfg.get("subject_seed_rects"):
    missing.append("subject_seed_rects")
for key in ("window_rect", "edit_region_rect"):
    if not cfg.get(key):
        missing.append(key)
if missing:
    sys.exit("ERROR: mask config is incomplete, missing: " + ", ".join(missing))
if cfg.get("source_sha256") in (None, ""):
    sys.exit("ERROR: mask config source_sha256 is empty; record the source hash first.")
EOF

# --- 1. source lock: private read-only copy + SHA-256 -------------------
mkdir -p "${PRIVATE_DIR}"
chmod 700 "${PRIVATE_DIR}"
readonly_copy="${PRIVATE_DIR}/source_readonly.$(basename "${SOURCE}")"
if [[ ! -f "${readonly_copy}" ]]; then
  install -m 0440 "${SOURCE}" "${readonly_copy}"
fi
SOURCE_SHA="$(sha256sum "${readonly_copy}" | awk '{print $1}')"
echo "source read-only copy : ${readonly_copy}"
echo "source sha256         : ${SOURCE_SHA}"

CONFIG_SHA="$(/home/user/.venv/bin/python - "${CONFIG}" "${SOURCE_SHA}" <<'EOF'
import json, sys
path, sha = sys.argv[1], sys.argv[2]
cfg = json.load(open(path))
if cfg.get("source_sha256") != sha:
    print(f"WARNING: config source_sha256={cfg.get('source_sha256')} != actual {sha}")
EOF
)" || true
[[ -n "${CONFIG_SHA}" ]] && echo "${CONFIG_SHA}"

# --- 2. mask -------------------------------------------------------------
"${PY}" "${HERE}/build_mask.py" \
  --image "${readonly_copy}" \
  --config "${CONFIG}" \
  --out-dir "${OUT_DIR}" \
  --prefix CAL001

# --- 3. composite --------------------------------------------------------
"${PY}" "${HERE}/composite.py" \
  --source "${readonly_copy}" \
  --plate "${PLATE}" \
  --subject-mask "${OUT_DIR}/CAL001_subject_mask.png" \
  --config "${CONFIG}" \
  --out-dir "${OUT_DIR}" \
  --prefix CAL001

# --- 4. independent verification (non-zero exit on any G2/G3 failure) ----
set +e
"${PY}" "${HERE}/verify_integrity.py" \
  --source "${readonly_copy}" \
  --after "${OUT_DIR}/CAL001_after.png" \
  --subject-mask "${OUT_DIR}/CAL001_subject_mask.png" \
  --config "${CONFIG}" \
  --out "${OUT_DIR}/CAL001_verification.json"
VERIFY_RC=$?
set -e

# --- 5. refresh provenance ----------------------------------------------
"${PY}" "${HERE}/build_manifest.py" || true

echo
if [[ ${VERIFY_RC} -eq 0 ]]; then
  echo "G2/G3 VERIFICATION: PASS  -> ${OUT_DIR}/CAL001_verification.json"
  echo "Next: Creative Director review of ${OUT_DIR}/CAL001_after.png (G4)."
else
  echo "G2/G3 VERIFICATION: FAIL (rc=${VERIFY_RC}) -> ${OUT_DIR}/CAL001_verification.json" >&2
fi
exit ${VERIFY_RC}
