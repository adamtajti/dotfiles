#!/bin/bash

# This script is based on the WSL configuration. I moved to Ubuntu to check how the performance will change.

sudo apt-get install --yes git

git config --global user.name "Adam Tajti"
# NOTE: You may want to override email per repo with --local instead of --global.
git config --global user.email adam.tajti@gmail.com 
# Set global git editor to "vim" temporarily; switch to "nvim" when installed.
git config --global core.editor vim 

# Copy the SSH keys from the hosts Dropbox mount and set the correct chmod on them.
mkdir -p ~/.ssh

# TODO: These should be committed into the repository instead to avoid installing Dropbox right
#       at the start unless it's absolutely necessary.
cp "$HOME/Dropbox/Backups/id_ed25519" "$HOME/.ssh/"
chmod 600 "$HOME/.ssh/id_ed25519"
cp "$HOME/Dropbox/Backups/id_ed25519.pub" "$HOME/.ssh/"
chmod 644 "$HOME/.ssh/id_ed25519.pub"

# -------------------------------------------------------------------------------------------------
# APT Repositories
# -------------------------------------------------------------------------------------------------

# for neovim-nightly
sudo add-apt-repository --yes ppa:neovim-ppa/unstable

sudo apt update


# -------------------------------------------------------------------------------------------------
# APT Packages
# -------------------------------------------------------------------------------------------------

sudo apt-get install --yes zsh # ZSH - I love a couple of plugins that I got used to here
# Oh My ZSH Installation (modifies ~/.zshrc, I don't like that, commented it out for now)
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

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
git config --global core.editor vim # Set global git editor to "nvim"

sudo apt-get install --yes kitty # i crave this so hard after some time spent in the default term

# Update the package indexes
sudo apt update



# -------------------------------------------------------------------------------------------------
# APT Global Upgrade
# -------------------------------------------------------------------------------------------------
sudo apt upgrade

# -------------------------------------------------------------------------------------------------
# AppImages
# -------------------------------------------------------------------------------------------------

mkdir -p ~/.bin
curl -L https://github.com/sindresorhus/caprine/releases/download/v2.59.1/Caprine-2.59.1.AppImage -o ~/.bin/Caprine-2.59.1.AppImage
chmod u+x ~/.bin/Caprine-2.59.1.AppImage
# ~/.bin/Caprine-2.59.1.AppImage
