#!/bin/zsh

echo 'dotfiles-typescript: updating typescript-language-server and typescript to the latest version'
npm install -g typescript-language-server@latest typescript@latest &> /dev/null
