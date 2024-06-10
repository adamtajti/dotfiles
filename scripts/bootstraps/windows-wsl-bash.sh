#!/bin/bash

# This script is designed to be ran once during system initialization right after the installation
# of a WSL2 distribution, which comes with Git and Python3 preinstalled, so those are not required
# for dotfiles.
# 2023-11-01: Abandoned

echo "INFO: Run this script in WSL once during system initialization."

if ! [[ $(grep microsoft /proc/version) ]]; then
    echo "ERROR: It looks like you're trying to run this script outside of a WSL environment." >&2
    exit 1
fi

# -------------------------------------------------------------------------------------------------
# These steps can be replayed again
# -------------------------------------------------------------------------------------------------

git config --global user.name "Adam Tajti"
# NOTE: You may want to override email per repo with --local instead of --global.
git config --global user.email adam.tajti@gmail.com 
# Set global git editor to "vim" temporarily; switch to "nvim" when installed.
git config --global core.editor vim 

# Copy the SSH keys from the hosts Dropbox mount and set the correct chmod on them.
mkdir -p ~/.ssh
# wslpath and wslvar is only available through APT packages since Ubuntu 22.04
sudo apt install --yes --no-install-recommends wslu

# TODO: These should be committed into the repository instead to avoid installing Dropbox right
#       at the start unless it's absolutely necessary.
HOST_USER_DIR=$(wslpath "$(wslvar USERPROFILE)")
cp "$HOST_USER_DIR/Dropbox/Backups/id_ed25519" "$HOME/.ssh/"
chmod 600 "$HOME/.ssh/id_ed25519"
cp "$HOST_USER_DIR/Dropbox/Backups/id_ed25519.pub" "$HOME/.ssh/"
chmod 644 "$HOME/.ssh/id_ed25519.pub"

# -------------------------------------------------------------------------------------------------
# TODO: From here on on these steps should be only ran once:
# -------------------------------------------------------------------------------------------------
echo "TODO: Detect if the installation has been done before."

# To install the latest Nix.
# It would be best to prompt for this. It might conflict with the work related installation.
# sh <(curl -L https://nixos.org/nix/install) --daemon

# -------------------------------------------------------------------------------------------------
# APT Repositories
# -------------------------------------------------------------------------------------------------

# for neovim-nightly
sudo add-apt-repository --yes ppa:neovim-ppa/unstable

sudo apt update

# -------------------------------------------------------------------------------------------------
# APT Packages
# -------------------------------------------------------------------------------------------------

sudo apt-get install --yes fzf # required in general and by my neovim configuration
sudo apt-get install --yes ripgrep # needed for neovim telescope searches and in general
sudo apt-get install --yes gcc # c compiler
sudo apt-get install --yes g++ # c/c++ compiler
sudo apt-get install --yes make # required to build some of the lsps in neovim / mason
sudo apt-get install --yes nodejs
sudo apt-get install --yes npm # a couple of neovim packages are using npm to install tools
sudo apt-get install --yes golang-go # required for a couple of neovim plugins and in general
sudo apt-get install --yes unzip # required for a couple of neovim plugins and in general
sudo apt-get install --yes luarocks # it looks like luarocks is required for luacheck...
sudo apt-get install --yes ruby # required for solargraph / ruby lsp
sudo apt-get install --yes virtualenv # python, mason/djlint requires it
sudo apt-get install --yes python-is-python3 # god
sudo apt-get install --yes neovim # fetched from the unstable repo; nightly

# -------------------------------------------------------------------------------------------------
# APT Global Upgrade
# -------------------------------------------------------------------------------------------------
sudo apt upgrade

