#!/bin/bash

# NOTE: This script has been abandoned, but I may come back to it, or look into further dotfiles plugins to use.

# === Gentoo Specific Dependencies ===
if [[ "$(uname -a)" == *"gentoo"* ]]; then
  # Ensure that the necessary repositories are synced up
  emerge --sync

  # Ensure that Git is installed
  ./install-git-gentoo.sh

  # Ensure that ZSH is installed
  ./install-zsh-gentoo.sh

  # Install Screen (think about switching to tmux as that's supposed to be superior and we're using it at work)
  ./install-screen-gentoo.sh

  # Install Node
  ./install-nodejs-gentoo.sh
fi

# === Mac Specific Dependencies ===
if [[ "$(uname -a)" == *"Darwin"* ]]; then
  # ZSH comes as preinstalled on Mac, nothing to do

  # Install Brew
  ./install-brew-mac.zsh
  
  # Install NVM
  ./install-nvm-mac.sh

  # Install Node & NPM
  ./install-node-mac.sh

  # Update NPM through NPM
  ./update-npm-through-npm.sh

  # Installs Go
  # - Requires Brew to be installed
  ./install-go-through-brew.sh

  # Installs or Updates gopls
  # - Requires Go to be installed
  ./install-or-update-gopls-through-go.zsh

  # Installs Neomutt
  # - Requires Brew to be installed
  ./build-and-install-or-update-neomutt.zsh

  # Installs w3m to be able to browse / render HTML from CLI
  # - Requires Brew to be installed
  ./install-w3m-through-brew.zsh

  # Installs kind to be able to spin up small Kubernetes clusters for testing
  # - Requires Brew to be installed
  ./install-kind-through-brew.zsh

  # Installs lolcat to display text in a fun way
  # - Requires Brew to be installed
  ./install-lolcat-through-brew.zsh

	# Installs MPV through brew. I might use it as a general media player, but I'm planning to use
	# it from scripts.
  # - Requires Brew to be installed
	./install-mpv-through-brew.zsh
fi

# === Generic Dependencies ===

# Installs or Updates Kitty
curl --silent -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin &> /dev/null

# Builds and installs / updates NeoVIM
# - Requires Git to be installed
./build-and-install-or-update-neovim.sh

# Installs typescript-language-server and typescript
# - Requires Node to be installed
./install-typescript-language-server-and-typescript-through-npm.sh

# Installs prettier and prettierd
# - Requires Node to be installed
./install-prettier-through-npm.zsh

# Installs eslint and eslint_d
# - Requires Node to be installed
./install-eslint-through-npm.zsh

# Installs bash-language-server
# - Requires Node to be installed
./install-bash-language-server-through-npm.zsh

# Installs pyright, which is an LSP server for Python
# - Requires Node to be installed
./install-pyright-through-npm.zsh

# Installs fixjson (used by null-ls in neovim)
# - Requires Node to be installed
./install-fixjson-through-npm.zsh

# Installation of zsh-vi-mode
# - Requires Git to be installed
./clone-or-update-zsh-vi-mode.zsh

# Installs generate to be used for generating code
# - Requires Node to be installed
./install-generate-through-npm.zsh

# Installs generate-gitignore to be used for initializing new projects with gitignore
# - Requires Node to be installed
./install-generate-gitignore-through-npm.zsh
