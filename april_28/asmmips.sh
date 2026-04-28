#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./mips_build.sh <file1.c|file1.s> [file2.c|file2.s ...] [-- <extra_flags...>]
#
# Flow:
# 1) Directly compile+relocatable-link all sources into one combined .o (with -g)
# 2) Link the combined .o into the final ELF (with -g)
#
# Output dir:
#   <dir-of-first-file>/build/
#
# Names:
# - Combined .o -> build/<first_basename>.o
# - ELF         -> build/<first_basename> (no extension)

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <file1.c|file1.s> [file2.c|file2.s ...] [-- <extra_flags...>]" >&2
  exit 2
fi

# Split inputs and extra flags (after --)
INPUTS=()
EXTRA_FLAGS=()
SEEN_DASHDASH=0
for arg in "$@"; do
  if [[ "$arg" == "--" ]]; then
    SEEN_DASHDASH=1
    continue
  fi
  if [[ $SEEN_DASHDASH -eq 0 ]]; then
    INPUTS+=("$arg")
  else
    EXTRA_FLAGS+=("$arg")
  fi
done

FIRST="${INPUTS[0]}"
FIRST_DIR="$(dirname -- "$FIRST")"
BUILD_DIR="${FIRST_DIR}/build"
mkdir -p "$BUILD_DIR"

# Base name for combined .o and ELF
first_base="$(basename -- "$FIRST")"
base_name="${first_base%.*}"
if [[ -z "$base_name" ]]; then
  base_name="$first_base"
fi

COMBINED_O="${BUILD_DIR}/${base_name}.o"
ELF_PATH="${BUILD_DIR}/${base_name}"

CC="mipsel-linux-gnu-gcc"
if ! command -v "$CC" >/dev/null 2>&1; then
  echo "Error: '$CC' not found in PATH. Please install mipsel cross toolchain or export PATH." >&2
  exit 127
fi

# 1) Directly compile+relocatable-link all sources into one .o (with -g)
echo "[INFO] Relocatable link (sources -> combined .o): ${INPUTS[*]} -> $COMBINED_O"
"$CC" -g -r -o "$COMBINED_O" "${INPUTS[@]}"

# 2) Link combined .o into final ELF (with -g)
echo "[INFO] Final link: $COMBINED_O -> $ELF_PATH"
"$CC" -g -o "$ELF_PATH" "$COMBINED_O" "${EXTRA_FLAGS[@]}"

echo "[OK] Built: $ELF_PATH"