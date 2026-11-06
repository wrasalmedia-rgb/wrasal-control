#!/bin/sh
# Reproducible encoder provisioning for the WRASAL-ARENA-CIN-001 production sandbox.
# Installs PyAV (libx264) into tools/pylibs (workspace-local, git-ignored).
# Idempotent: safe to re-run after sandbox recycle.
set -eu
cd "$(dirname "$0")/.."
if [ -d tools/pylibs/av ]; then
  echo "encoder already provisioned: tools/pylibs/av"
  exit 0
fi
python3 -m pip install --no-cache-dir --target tools/pylibs av==18.1.0
echo "encoder provisioned: tools/pylibs/av (PyAV 18.1.0, libx264)"
