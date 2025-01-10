#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

"$SCRIPT_DIR/base.sh"

if grep -q microsoft /proc/version; then
  "$SCRIPT_DIR/wsl.sh"
elif [[ "$(uname -a)" == *"adamtajti-ubuntu"* ]]; then
  "$SCRIPT_DIR/ubuntu.sh"
elif [[ "$(uname -a)" == *"Darwin"* ]]; then
  "$SCRIPT_DIR/mac.sh"
elif [[ "$(uname -a)" == *"gentoo"* ]]; then
  "$SCRIPT_DIR/gentoo.sh"
elif [[ "$(uname -a)" == *"NixOS"* ]]; then
     >&2 echo "error: NixOS isn't supported anymore"
  exit 1
else
     >&2 echo "error: Unable to determine the correct synchronizer for this system!"
  exit 1
fi

"$SCRIPT_DIR/tulip.sh"
