#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./asm86.sh file1.s|file1.c [file2.s|file2.c ...]
#
# Rules:
# - Output dir: <dir-of-first-file>/build/
# - ELF name: basename of first file (no extension)
# - If only one .s file -> use as/ld
# - Otherwise -> use gcc -m32

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 file1.s|file1.c [file2.s|file2.c ...]" >&2
  exit 1
fi

FIRST="$1"
FIRST_DIR="$(dirname -- "$FIRST")"
BUILD_DIR="${FIRST_DIR}/build"
mkdir -p "$BUILD_DIR"

first_base="$(basename -- "$FIRST")"
base_name="${first_base%.*}"
[[ -z "$base_name" ]] && base_name="$first_base"

OBJ="${BUILD_DIR}/${base_name}.o"
ELF="${BUILD_DIR}/${base_name}"

# If only one argument and it's .s -> use as/ld
if [[ $# -eq 1 && "$FIRST" == *.s ]]; then
  as --32 -g -o "$OBJ" "$FIRST"
  ld -m elf_i386 -g -o "$ELF" "$OBJ"
  echo "Built: $ELF"
  exit 0
fi

# Otherwise use gcc -m32 with -g
gcc -m32 -g -o "$ELF" "$@"
echo "Built: $ELF"
