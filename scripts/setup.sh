#!/usr/bin/env bash

# The base system should be installed at this point (manually for now):
#
# - Git + SSH + git-crypt (to clone this repository)
# - Dropbox (to fetch the SSH keys to clone this repository)
# - Key to decrypt the sensitive files

set -e

DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"
DOTFILES_BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"
export DOTFILES_BASEDIR

cd "${DOTFILES_BASEDIR}"
git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
git submodule update --init --recursive "${DOTBOT_DIR}"

selected_configuration=""
if grep -q microsoft /proc/version; then
  selected_configuration="wsl.yaml"
elif [[ "$(uname -a)" == *"adamtajti-ubuntu"* ]]; then
  selected_configuration="ubuntu.yaml"
elif [[ "$(uname -a)" == *"Darwin"* ]]; then
  selected_configuration="mac.yaml"
elif [[ "$(uname -a)" == *"gentoo"* ]]; then
  selected_configuration="gentoo.yaml"
elif [[ "$(uname -a)" == *"NixOS"* ]]; then
  >&2 echo "CRITICAL: NixOS configuration is unmaintained ATM!"
  exit 1;
  selected_configuration="nixos.yaml"
else
  >&2 echo "CRITICAL: Unable to determine the correct configuration for this system!"
  exit 1;
fi

# args were seperated into an array for comment support
args=(
  --verbose
  #--quiet
  --base-directory "$DOTFILES_BASEDIR"
  --config-file "$DOTFILES_BASEDIR/$selected_configuration"
  --plugin "$DOTFILES_BASEDIR/dotbot-includes/includes.py"
  --plugin "$DOTFILES_BASEDIR/dotbot-sudo/sudo.py"
)

# Runs dotbot based on the previously selected configuration.
"$DOTFILES_BASEDIR/$DOTBOT_DIR/$DOTBOT_BIN" \
  "${args[@]}" \
  "${@}"
