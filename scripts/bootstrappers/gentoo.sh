#!/usr/bin/env bash

set -e
shopt -s dotglob

git_root_path=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && cd ../../ && pwd)
cd "$git_root_path"

# Source the utilities
source ./scripts/utils/utils.sh

# USER AND GROUP CONFIGURATIONS
whoami=$(whoami)

ensure_member_of_group()
                         {
  group="$1"
  if sudo groupmems -g "$group" --list > /dev/null; then
    sudo groupmod --append --users "$whoami" "$group"
  fi
}

ensure_member_of_group input
ensure_member_of_group pipewire
ensure_member_of_group ollama
ensure_member_of_group docker

# PACKAGE INSTALLATIONS

# eix to query installed packages
if ! [ -x "$(command -v eix)" ]; then
  sudo emerge --noreplace app-portage/eix
fi

# Make sure that nodejs+npm is installed to install pnpm
if ! [ -x "$(command -v node)" ]; then
  sudo emerge --noreplace net-libs/nodejs
fi

# Install pnpm if it's not installed already
printf "\033[0;90mInstall PNPM if it's not installed...\033[0m\n"
npm list -g @pnpm/exe &> /dev/null || sudo npm install -g @pnpm/exe &> /dev/null

# Install rollup bundler if it's not installed already
printf "\033[0;90mInstall rollup if it's not installed...\033[0m\n"
npm list -g rollup &> /dev/null || sudo npm install -g rollup &> /dev/null

# Install or update tree-sitter-cli
printf "\033[0;90mInstall or update tree-sitter-cli...\033[0m\n"
sudo npm -g update tree-sitter-cli &> /dev/null
