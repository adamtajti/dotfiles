#!/bin/zsh

if [ $+commands[lolcat] -eq 1 ]; then
  echo 'dotfiles-lolcat: lolcat is already installed. Returning early.' >&2
  exit 0
fi

echo 'dotfiles-lolcat: installing lolcat'
brew install lolcat
