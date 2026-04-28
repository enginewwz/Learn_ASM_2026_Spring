#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./run_mips_elf.sh <path-to-elf> [args...]
#
# This runs:
#   qemu-mipsel-static -L /usr/mipsel-linux-gnu/ <elf> [args...]

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <path-to-elf> [args...]" >&2
  exit 2
fi

ELF="$1"
shift

QEMU="qemu-mipsel-static"
SYSROOT="/usr/mipsel-linux-gnu/"

if ! command -v "$QEMU" >/dev/null 2>&1; then
  echo "Error: '$QEMU' not found in PATH." >&2
  exit 127
fi

if [[ ! -f "$ELF" ]]; then
  echo "Error: ELF not found: $ELF" >&2
  exit 1
fi

exec "$QEMU" -L "$SYSROOT" "$ELF" "$@"