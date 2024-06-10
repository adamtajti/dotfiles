#!/bin/zsh

if [ $+commands[gen] -eq 1 ]; then
  echo 'dotfiles-generate: generate is already installed. Returning early.' >&2
  exit 0
fi

echo 'dotfiles-generate: installing generate'
npm install --global generate &> /dev/null

