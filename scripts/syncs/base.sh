#!/usr/bin/env bash

set -e
shopt -s dotglob

git_root_path=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && cd ../../ && pwd)
cd "$git_root_path"

# Source the utilities
source ./scripts/utils/utils.sh

# These are mostly closed source projects that I'm working on.
mkdir -p "$HOME/Projects"
# These are open source projects that I'm interested in or I'm working at.
mkdir -p "$HOME/GitHub"
# I like to have a folder where my screenshots gets saved.
# TODO: Save them straigt to Dropbox instead
mkdir -p "$HOME/Pictures/Screenshots"

_dotfiles_ln_dir_contents "$PWD/files/.config" "$HOME/.config"
_dotfiles_ln_dir_contents "$PWD/files/.local/bin" "$HOME/.local/bin"
_dotfiles_ln_dir_contents "$PWD/files/.local/homepage" "$HOME/.local/homepage"
_dotfiles_ln_dir_contents "$PWD/files/.local/share" "$HOME/.local/share"
_dotfiles_ln_dir_contents "$PWD/files/.local/etc" "$HOME/.local/etc"
_dotfiles_ln_dir_contents "$PWD/files/.fonts" "$HOME/.fonts"

_dotfiles_ln "$PWD/files/.asoundrc" "$HOME/.asoundrc"
# used by markdownlint-cli
_dotfiles_ln "$PWD/files/.markdownlintrc" "$HOME/.markdownlintrc"
_dotfiles_ln "$PWD/files/.zshrc" "$HOME/.zshrc"
_dotfiles_ln "$PWD/files/.zshenv" "$HOME/.zshenv"
_dotfiles_ln "$PWD/files/.zprofile" "$HOME/.zprofile"
_dotfiles_ln "$PWD/files/.zsh_plugins.txt" "$HOME/.zsh_plugins.txt"
_dotfiles_ln "$PWD/files/.bashrc" "$HOME/.bashrc"
_dotfiles_ln "$PWD/files/.inputrc" "$HOME/.inputrc"
_dotfiles_ln "$PWD/files/.mailcap" "$HOME/.mailcap"
_dotfiles_ln "$PWD/files/.rtorrent.rc" "$HOME/.rtorrent.rc"

# user local (used for `npm install '@scope/...'`)
_dotfiles_ln "$PWD/files/.npmrc" "$HOME/.npmrc"
# global (used for `sudo su -` -> `npm install -g '@scope/...'`)
sudo mkdir -p "/etc/npm"
_sudo_fn _dotfiles_ln "$PWD/files/.npmrc" "/etc/npm/npmrc"

# global tuh (used to `sudo npm install -g '@scope/...'`) (huh)
sudo mkdir -p "/usr/etc"
_sudo_fn _dotfiles_ln "$PWD/files/.npmrc" "/usr/etc/npmrc"

_dotfiles_ln "$PWD/files/.xkb" "$HOME/.xkb"

mkdir -p "$HOME/.gnupg"
#_dotfiles_ln "$PWD/files/.gnupg/gpg.conf" "$HOME/.gnupg/gpg.conf"
_dotfiles_ln "$PWD/files/.gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"

mkdir -p "$HOME/.neomutt"
_dotfiles_ln \
  "$PWD/files/.neomutt/profile.personal" \
  "$HOME/.neomutt/profile.personal"

# NEW CONFIGS (added for CachyOS migration)
_dotfiles_ln_dir_contents "$PWD/files/.config/ghostty" "$HOME/.config/ghostty"
_dotfiles_ln_dir_contents "$PWD/files/.config/helix" "$HOME/.config/helix"
_dotfiles_ln_dir_contents "$PWD/files/.config/btop" "$HOME/.config/btop"
_dotfiles_ln_dir_contents "$PWD/files/.config/htop" "$HOME/.config/htop"
_dotfiles_ln_dir_contents "$PWD/files/.config/flameshot" "$HOME/.config/flameshot"
_dotfiles_ln_dir_contents "$PWD/files/.config/qt5ct" "$HOME/.config/qt5ct"
_dotfiles_ln_dir_contents "$PWD/files/.config/qt6ct" "$HOME/.config/qt6ct"
_dotfiles_ln_dir_contents "$PWD/files/.config/easyeffects" "$HOME/.config/easyeffects"
_dotfiles_ln_dir_contents "$PWD/files/.config/xsettingsd" "$HOME/.config/xsettingsd"
_dotfiles_ln_dir_contents "$PWD/files/.config/weechat" "$HOME/.config/weechat"
_dotfiles_ln_dir_contents "$PWD/files/.config/opensnitch" "$HOME/.config/opensnitch"
_dotfiles_ln_dir_contents "$PWD/files/.config/wireshark" "$HOME/.config/wireshark"
_dotfiles_ln_dir_contents "$PWD/files/.config/nwg-look" "$HOME/.config/nwg-look"
_dotfiles_ln "$PWD/files/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
_dotfiles_ln "$PWD/files/.config/user-dirs.dirs" "$HOME/.config/user-dirs.dirs"
_dotfiles_ln "$PWD/files/.config/mimeapps.list" "$HOME/.config/mimeapps.list"
