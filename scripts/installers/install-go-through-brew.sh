#!/bin/zsh

if [ $+commands[go] -eq 1 ]; then
  echo 'dotfiles-go: go is already installed. Returning early.' >&2
  exit 0
fi

echo 'dotfiles-go: installing go'
brew install go

