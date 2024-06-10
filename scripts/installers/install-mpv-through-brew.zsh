#!/bin/zsh

if [ $+commands[mpv] -eq 1 ]; then
  echo 'dotfiles-mpv: mpv is already installed. Returning early.' >&2
  exit 0
fi

echo 'dotfiles-mpv: installing mpv'
brew install mpv

