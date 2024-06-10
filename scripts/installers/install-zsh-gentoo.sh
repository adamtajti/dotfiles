#!/bin/sh

if [ -x "$(command -v zsh)" ]; then
  echo 'dotfiles-zsh: zsh is already installed.' >&2
  exit 0
fi

# Install ZSH
# [ebuild  N     ] app-shells/zsh-5.8.1-r2  USE="(caps) pcre unicode -debug -doc -examples -gdbm -maildir -static" 
emerge zsh

# Install ZSH Completions
emerge app-shells/gentoo-zsh-completions

#autoload -U compinit promptinit
#compinit
#promptinit; prompt gentoo
