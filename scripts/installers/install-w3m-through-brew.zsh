#!/bin/zsh

if [ $+commands[w3m] -eq 1 ]; then
  echo 'dotfiles-w3m: w3m is already installed. Returning early.' >&2
  exit 0
fi

echo 'dotfiles-w3m: installing w3m'
brew install w3m

