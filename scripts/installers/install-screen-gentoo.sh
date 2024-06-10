#!/bin/sh

if [ -x "$(command -v screen)" ]; then
  echo 'dotfiles-screen: screen is already installed.' >&2
  exit 0
fi

# Install Screen
emerge app-misc/screen

