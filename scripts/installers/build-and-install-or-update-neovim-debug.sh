#!/bin/zsh

# # Navigate to our working directory.
# if [ ! -d "$HOME/GitHub/neovim" ]; then
#   mkdir -p $HOME/GitHub/
#   cd $HOME/GitHub/
#   git clone https://github.com/neovim/neovim.git || { exit 1; }
#   cd $HOME/GitHub/neovim
# else
#   cd $HOME/GitHub/neovim
#   # OPTIMIZATION: Check if we are already on the latest version and quit earlier
#   echo "dotfiles-neovim: looking for a new version"
#   git remote update &> /dev/null
#   GIT_STATUS=$(git status -uno | head -n 2 | tail -n 1)
#   if [[ "$GIT_STATUS" == "Your branch is up to date with"* ]]; then
#     # TODO: Edge-case: After removing the neovim version this installation script will fail from this fetching optimization. Check if the app is installed at all, continue if it's not
#     #echo "dotfiles-neovim: your neovim version is up-to-date"
#     #exit 0
#   else
#     echo "dotfiles-neovim: your neovim version is outdated."
#   fi
# fi

# HACK: Temporarily introduced this to erase local modifications to ensure that the build will succeed
# Disable it while developing
#git reset --hard &> /dev/null

# Update our sources to the latest master
# echo "dotfiles-neovim: pulling the latest version"
# git pull &> /dev/null

# Do a cleanup
make distclean &> /dev/null

# Create the makefile for our OS and build it
echo "dotfiles-neovim: building"

rm -rf ~/neovim


# Set the installation folder to $HOME/neovim to avoid root installation

# Relese build:
#make CMAKE_BUILD_TYPE="Release" CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim" -j$(nproc) &> /dev/null

# Debug build:
make CMAKE_BUILD_TYPE="Debug" CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim" -j$(nproc)

# Install neovim into our system with the generated Makefile
echo "dotfiles-neovim: installation"
make install
