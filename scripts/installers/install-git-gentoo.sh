#!/bin/sh

if [ -x "$(command -v git)" ]; then
  echo 'dotfiles-git: git is already installed.' >&2
  exit 0
fi

# Install Git
emerge dev-vcs/git

