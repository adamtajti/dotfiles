#!/usr/bin/env bash

echo "executing base.sh"

set -e
shopt -s dotglob

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
_dotfiles_ln_dir_contents "$PWD/files/.local/snippets" "$HOME/.local/snippets"
_dotfiles_ln \
	"$PWD/files/.local/snippets/luasnippets/all/quotes.lua" \
	"$HOME/.local/snippets/luasnippets/_polylingual/quotes.lua"
_dotfiles_ln \
	"$PWD/files/.local/snippets/luasnippets/zsh/zsh.lua" \
	"$HOME/.local/snippets/luasnippets/sh/sh.lua"

_dotfiles_ln_dir_contents "$PWD/files/.fonts" "$HOME/.fonts"

_dotfiles_ln "$PWD/files/.asoundrc" "$HOME/.asoundrc"
# used by markdownlint-cli
_dotfiles_ln "$PWD/files/.markdownlintrc" "$HOME/.markdownlintrc"
_dotfiles_ln "$PWD/files/.zshrc" "$HOME/.zshrc"
_dotfiles_ln "$PWD/files/.zshenv" "$HOME/.zshenv"
_dotfiles_ln "$PWD/files/.inputrc" "$HOME/.inputrc"
_dotfiles_ln "$PWD/files/.gitconfig" "$HOME/.gitconfig"
_dotfiles_ln "$PWD/files/.mailcap" "$HOME/.mailcap"

mkdir -p "$HOME/.gnupg"
_dotfiles_ln "$PWD/files/.gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"

mkdir -p "$HOME/.neomutt"
_dotfiles_ln \
	"$PWD/files/.neomutt/profile.personal" \
	"$HOME/.neomutt/profile.personal"