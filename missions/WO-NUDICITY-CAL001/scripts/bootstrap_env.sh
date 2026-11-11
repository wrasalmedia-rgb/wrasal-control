#!/usr/bin/env bash
# Re-create the pinned WO-NUDICITY-CAL001 execution environment.
#
# Needed because /home/user/.venv is excluded from Arena session snapshot
# persistence and is removed between session turns. The pinned versions are
# identical to those the dry-run artefacts were produced with, so re-running the
# pipeline reproduces byte-identical mask and composite outputs.
#
# Usage: bash scripts/bootstrap_env.sh [venv_path]
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MISSION="$(cd "${HERE}/.." && pwd)"
VENV="${1:-/home/user/.venv}"

echo "creating venv at ${VENV}"
python3 -m venv "${VENV}"
"${VENV}/bin/python" -m pip install --quiet --no-input --upgrade pip
"${VENV}/bin/python" -m pip install --quiet --no-input \
  -r "${MISSION}/requirements.lock.txt"

echo "installed:"
"${VENV}/bin/python" - <<'EOF'
import numpy, cv2, PIL, scipy, matplotlib
print(f"  numpy                 {numpy.__version__}")
print(f"  opencv-python-headless {cv2.__version__}")
print(f"  pillow                {PIL.__version__}")
print(f"  scipy                 {scipy.__version__}")
print(f"  matplotlib            {matplotlib.__version__}")
assert hasattr(cv2, "grabCut") and hasattr(cv2, "inpaint")
print("  grabCut + inpaint     available")
EOF

echo "environment ready: ${VENV}/bin/python"
