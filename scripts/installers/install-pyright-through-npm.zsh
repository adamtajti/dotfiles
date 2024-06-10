#!/bin/zsh

if [ $+commands[pyright] -eq 1 ]; then
  echo 'dotfiles-pyright: pyright is already installed. Returning early.' >&2
  exit 0
fi

echo 'dotfiles-pyright: installing pyright'
npm install --global pyright &> /dev/null


