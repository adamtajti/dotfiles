#!/usr/bin/env bash

set -e
shopt -s dotglob

git_root_path=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && cd ../../ && pwd)
cd "$git_root_path"

# Source the utilities
source ./scripts/utils/utils.sh

# Sync files as sudo
printf "\033[0;32mSynchronizing symbolic links...\033[0m"
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/sysctl.conf" "/etc/sysctl.conf"
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/sysctl.d" "/etc/sysctl.d"

# Portage
sudo chmod 644 ./files/gentoo/var/lib/portage/world # This is probably unnecessary, candidate for removal
sudo chown root:root ./files/gentoo/var/lib/portage/world
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/var/lib/portage/world" "/var/lib/portage/world"

_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/portage/make.conf" "/etc/portage/make.conf"
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/portage/repos.conf/eselect-repo.conf" "/etc/portage/repos.conf/eselect-repo.conf"
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/portage/repos.conf/gentoo.conf" "/etc/portage/repos.conf/gentoo.conf"
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/portage/package.accept_keywords" "/etc/portage/package.accept_keywords"
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/portage/package.mask" "/etc/portage/package.mask"
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/portage/package.unmask" "/etc/portage/package.unmask"
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/portage/package.use" "/etc/portage/package.use"
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/portage/env" "/etc/portage/env"
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/portage/package.env" "/etc/portage/package.env"

sudo chmod 644 "$PWD/files/gentoo/etc/login.defs"
sudo chown root:root "$PWD/files/gentoo/etc/login.defs"
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/login.defs" "/etc/login.defs"

_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/ddclient.conf" "/etc/ddclient.conf"

# Nginx
sudo chown root:root ./files/gentoo/etc/nginx/*
sudo chmod 644 ./files/gentoo/etc/nginx/*
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/nginx" "/etc/nginx"

sudo chown root:root "$PWD/files/gentoo/etc/sudoers.d/wheel"
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/etc/sudoers.d/wheel" "/etc/sudoers.d/wheel"

# /usr/src/linux is already a symlink to the latest usr/src/<kernel_folder>,
# so it would be problematic to link there. instead lets link it in
# /usr/src/.config and copy it there as well once I want to backup.
_sudo_fn _dotfiles_ln "$PWD/files/gentoo/usr/src/linux/.config" "/usr/src/.config"

# eix to query installed packages

if ! [ -x "$(command -v eix)" ]; then
  sudo emerge --noreplace app-portage/eix
fi

# Make sure that nodejs+npm is installed to install pnpm
if ! [ -x "$(command -v node)" ]; then
  sudo emerge --noreplace net-libs/nodejs
fi

# Install pnpm if it's not installed already
printf "\033[0;32mInstall PNPM if it's not installed...\033[0m"
npm list -g @pnpm/exe &> /dev/null || sudo npm install -g @pnpm/exe

# Install rollup bundler if it's not installed already
printf "\033[0;32mInstall rollup if it's not installed...\033[0m"
npm list -g rollup &> /dev/null || sudo npm install -g rollup

# Install or update tree-sitter-cli
sudo npm -g update tree-sitter-cli

printf "\033[0;32mDone. May your blade never dull!\033[0m"

# TODO: Script the installation of rust/+cargo and then clone rmz and install it
# from source / create an ebuild and contribute to gentoo/gentoo or to guru
