#!/usr/bin/env bash

set -e
shopt -s dotglob

git_root_path=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd ../../ && pwd)
cd "$git_root_path"

# Source the utilities
source ./scripts/utils/utils.sh

# Sync files as sudo
sudo chmod 644 ./files/gentoo/var/lib/portage/world
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/var/lib/portage/world" "/var/lib/portage/world"
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/sysctl.conf" "/etc/sysctl.conf"
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/portage/make.conf" "/etc/portage/make.conf"

sudo chown root:root "$PWD/files/gentoo/etc/sudoers.d/wheel"
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/sudoers.d/wheel" "/etc/sudoers.d/wheel"
