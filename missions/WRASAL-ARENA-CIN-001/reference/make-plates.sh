#!/bin/sh
# Reproducible derivation of quadrant plates from the source reference grid.
# Usage: sh make-plates.sh   (run from this directory)
# Requires ImageMagick (convert). Source: source/image-1.png (1920x824).
set -eu
cd "$(dirname "$0")"
SRC=source/image-1.png
mkdir -p plates
convert "$SRC" -crop 960x412+0+0     +repage plates/shot-A.png
convert "$SRC" -crop 960x412+960+0   +repage plates/shot-B.png
convert "$SRC" -crop 960x412+0+412   +repage plates/shot-C.png
convert "$SRC" -crop 960x412+960+412 +repage plates/shot-D.png
echo "plates written; verify checksums against data/manifest.json"
