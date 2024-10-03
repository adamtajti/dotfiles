#!/usr/bin/env bash

set -e
shopt -s dotglob

git_root_path=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd ../../ && pwd)
cd "$git_root_path"

# Source the utilities
source ./scripts/utils/utils.sh

# Sync files as sudo
sudo chmod 644 ./files/gentoo/var/lib/portage/world # This is probably unnecessary, candidate for removal
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/var/lib/portage/world" "/var/lib/portage/world"
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/sysctl.conf" "/etc/sysctl.conf"

_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/portage/make.conf" "/etc/portage/make.conf"
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/portage/repos.conf/eselect-repo.conf" "/etc/portage/repos.conf/eselect-repo.conf"
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/portage/repos.conf/gentoo.conf" "/etc/portage/repos.conf/gentoo.conf"
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/portage/package.accept_keywords" "/etc/portage/package.accept_keywords"
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/portage/package.mask" "/etc/portage/package.mask"
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/portage/package.unmask" "/etc/portage/package.unmask"
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/portage/package.use" "/etc/portage/package.use"

sudo chown root:root "$PWD/files/gentoo/etc/sudoers.d/wheel"
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/sudoers.d/wheel" "/etc/sudoers.d/wheel"

# /usr/src/linux is already a symlink to the latest usr/src/<kernel_folder>, so it would be problematic to link there.
# instead lets link it in /usr/src/.config and copy it there as well once I want to backup.
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/usr/src/linux/.config" "/usr/src/.config"
