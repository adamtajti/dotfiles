#!/usr/bin/env bash

echo "executing tulip.sh"

set -e
shopt -s dotglob

# Source the utilities
source ./scripts/utils/utils.sh

mkdir -p "$HOME/.neomutt"
_dotfiles_ln "$PWD/files/.neomutt/profile.tulip" "$HOME/.neomutt/profile.tulip"
