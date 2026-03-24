#!/usr/bin/env bash
set -euo pipefail

# Check arguments
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 file1.s [file2.s ...]"
  exit 1
fi

for src in "$@"; do
  # Ensure the source file exists
  if [ ! -f "$src" ]; then
    echo "Skip: file not found -> $src" >&2
    continue
  fi

  # Derive paths
  src_dir=$(dirname "$src")
  src_base=$(basename "$src" .s)
  out_dir="$src_dir/build"

  # Ensure output directory exists
  mkdir -p "$out_dir"

  obj="$out_dir/$src_base.o"
  exe="$out_dir/$src_base"

  # Assemble
  as --32 -g -o "$obj" "$src"
  # Link
  ld -m elf_i386 -g -o "$exe" "$obj"

  echo "Built: $exe"
done
