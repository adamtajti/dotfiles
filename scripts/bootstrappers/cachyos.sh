#!/usr/bin/env bash

set -e
shopt -s dotglob

git_root_path=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && cd ../../ && pwd)
cd "$git_root_path"

# Source the utilities
source ./scripts/utils/utils.sh

# USER AND GROUP CONFIGURATIONS
whoami=$(whoami)

ensure_member_of_group()
                         {
  group="$1"
  if getent group "$group" > /dev/null; then
    sudo usermod --append --groups "$group" "$whoami"
  fi
}

ensure_member_of_group input
ensure_member_of_group pipewire
ensure_member_of_group docker
ensure_member_of_group wheel

# PACKAGE INSTALLATIONS
# Uncomment the lines below on first setup to install packages from the saved lists.
# After the initial install, keep them commented to avoid unnecessary work on each sync.

# echo "Installing base packages..."
# sudo pacman -S --needed --noconfirm git base-devel

# echo "Installing AUR helper (paru)..."
# if ! command -v paru &> /dev/null; then
#   git clone https://aur.archlinux.org/paru.git /tmp/paru
#   cd /tmp/paru && makepkg -si --noconfirm && cd "$git_root_path"
# fi

# echo "Installing packages from package list..."
# sudo pacman -S --needed --noconfirm - < "$git_root_path/files/cachyos/pkglist-pacman.txt"

# echo "Installing AUR packages..."
# paru -S --needed --noconfirm - < "$git_root_path/files/cachyos/pkglist-aur.txt"

# echo "Installing global npm packages..."
# xargs -a "$git_root_path/files/cachyos/pkglist-npm.txt" npm install -g
