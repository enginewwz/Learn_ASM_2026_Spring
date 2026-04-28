#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./mips_build.sh <file1.c|file1.s> [file2.c|file2.s ...] [-- <extra_flags...>]
#
# Rules:
# - Compile each source file into a .o first
# - Then link all .o into a final ELF
# - All outputs go to: <dir-of-first-file>/build/
# - .o name: source basename + .o
# - ELF name: basename of the first file (no extension)

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

# ELF name = basename of the first file without extension
first_base="$(basename -- "$FIRST")"
elf_name="${first_base%.*}"
if [[ -z "$elf_name" ]]; then
  elf_name="$first_base"
fi
ELF_PATH="${BUILD_DIR}/${elf_name}"

CC="mipsel-linux-gnu-gcc"
if ! command -v "$CC" >/dev/null 2>&1; then
  echo "Error: '$CC' not found in PATH. Please install mipsel cross toolchain or export PATH." >&2
  exit 127
fi

# Compile each source to .o
OBJ_FILES=()
for src in "${INPUTS[@]}"; do
  base="$(basename -- "$src")"
  name="${base%.*}"
  if [[ -z "$name" ]]; then
    name="$base"
  fi
  obj="${BUILD_DIR}/${name}.o"
  OBJ_FILES+=("$obj")

  echo "[INFO] Compile: $src -> $obj"
  "$CC" -c "$src" -o "$obj"
done

# Link all .o into the final ELF
echo "[INFO] Link: ${OBJ_FILES[*]} -> $ELF_PATH"
"$CC" -o "$ELF_PATH" "${OBJ_FILES[@]}" "${EXTRA_FLAGS[@]}"

echo "[OK] Built: $ELF_PATH"