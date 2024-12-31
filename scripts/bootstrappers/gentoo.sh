#!/usr/bin/env bash

set -e
shopt -s dotglob

git_root_path=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && cd ../../ && pwd)
cd "$git_root_path"

# Source the utilities
source ./scripts/utils/utils.sh

# Configure the user and its groups
whoami=$(whoami)

ensure_member_of_group()
                         {
  group="$1"
  if sudo groupmems -g "$group" --list > /dev/null; then
    sudo groupmod --append --users "$whoami" "$group"
  fi
}

ensure_member_of_group jellyfin
ensure_member_of_group input
ensure_member_of_group pipewire
ensure_member_of_group ollama
ensure_member_of_group docker
