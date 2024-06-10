#!/bin/zsh
#
if [ $+commands[brew] -eq 1 ]; then
  echo 'dotfiles-brew: brew is already installed. Returning early.' >&2
  exit 0
fi

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
