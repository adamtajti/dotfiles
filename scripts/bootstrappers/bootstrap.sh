#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

if grep -q microsoft /proc/version; then
  "$SCRIPT_DIR/base_unix_file_permissions.sh"
  "$SCRIPT_DIR/wsl.sh"
elif [[ "$(uname -a)" == *"adamtajti-ubuntu"* ]]; then
  "$SCRIPT_DIR/base_unix_file_permissions.sh"
  "$SCRIPT_DIR/ubuntu.sh"
elif [[ "$(uname -a)" == *"Darwin"* ]]; then
  "$SCRIPT_DIR/base_unix_file_permissions.sh"
  "$SCRIPT_DIR/mac.sh"
elif [[ "$(uname -a)" == *"gentoo"* ]]; then
  "$SCRIPT_DIR/base_unix_file_permissions.sh"
  "$SCRIPT_DIR/gentoo.sh"
elif [[ "$(uname -a)" == *"NixOS"* ]]; then
  echo "error: NixOS isn't supported anymore" >&2
  exit 1
else
  echo "error: Unable to determine the correct bootstrapper for this system!" >&2
  exit 1
fi

"$SCRIPT_DIR/base_git_config.sh"
