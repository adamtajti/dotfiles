#!/usr/bin/env bash

set -e
shopt -s dotglob

git_root_path=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && cd ../../ && pwd)
cd "$git_root_path"

# Source the utilities
source ./scripts/utils/utils.sh

# CachyOS/Arch-specific system config symlinks.
# Add entries here as you customize system-level configs on Arch.
# Examples:
#   _sudo_fn _dotfiles_ln "$PWD/files/cachyos/etc/pacman.conf" "/etc/pacman.conf"
#   _sudo_fn _dotfiles_ln "$PWD/files/cachyos/etc/mkinitcpio.conf" "/etc/mkinitcpio.conf"

printf "\033[0;32mDone. CachyOS sync complete.\033[0m\n"
