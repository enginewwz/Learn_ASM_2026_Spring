#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./icx_build.sh <output_name> <file1.c> [file2.c ...]
#
# Output:
#   <dir-of-first-source>/build/<output_name>

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <output_name> <file1.c> [file2.c ...]" >&2
  exit 1
fi

OUT_NAME="$1"
shift

FIRST_SRC="$1"
FIRST_DIR="$(dirname -- "$FIRST_SRC")"
BUILD_DIR="${FIRST_DIR}/build"
mkdir -p "$BUILD_DIR"

ELF="${BUILD_DIR}/${OUT_NAME}"

# Compile & link with required flags
icx -O3 -xHost -fp-model=fast -qopt-zmm-usage=high -qopenmp -o "$ELF" "$@"

echo "Built: $ELF"