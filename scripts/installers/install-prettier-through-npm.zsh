#!/bin/zsh

echo 'dotfiles-prettier: updating prettier and prettierd to the latest version'
npm install -g prettier@latest &>/dev/null
npm install -g @fsouza/prettierd@latest &>/dev/null
