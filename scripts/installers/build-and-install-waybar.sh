#!/bin/bash

set -eu

# Checkout the latest waybar version
if [ ! -d "$HOME/GitHub/waybar" ]; then
  mkdir -p $HOME/GitHub/
  cd $HOME/GitHub/
  git clone git@github.com:Alexays/Waybar.git waybar || { exit 1; }
  cd $HOME/GitHub/waybar
else
  cd $HOME/GitHub/waybar
  # OPTIMIZATION: Check if we are already on the latest version and quit earlier
  echo "dotfiles-waybar: looking for a new version"
  git remote update &> /dev/null
  GIT_STATUS=$(git status -uno | head -n 2 | tail -n 1)
  if [[ "$GIT_STATUS" == "Your branch is up to date with"* ]]; then
    echo "dotfiles-waybar: your waybar version is up-to-date"
    exit 0
  else
    echo "dotfiles-waybar: your waybar version is outdated."
  fi
fi

git pull &> /dev/null

meson build

# ninja -C build
sudo ninja -C build install # is it enough to issue this?
