#!/bin/zsh

echo 'dotfiles-eslint: updating eslint and eslint_d to the latest version'
npm install -g eslint@latest &>/dev/null
npm install -g eslint_d@latest &>/dev/null
