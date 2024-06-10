#!/bin/zsh

source ~/.zshrc
if [ -x "$(command -v nvm)" ]; then
  echo 'dotfiles-node: NVM is not installed. Returning early.' >&2
  exit 0
fi

# Install the currently specified Node version
NODE_VERSION="v14.19.3"
CURRENTLY_INSTALLED_NODE_VERSION=$(nvm ls --no-colors | grep "default \->" | sed 's/\default\ ->.*\(v[0-9\.]*\).*/\1/')

if [ "$NODE_VERSION" != "$CURRENTLY_INSTALLED_NODE_VERSION" ]; then
  echo "dotfiles-node: Your node version is out-of-date. Installing $NODE_VERSION..."
  nvm install $NODE_VERSION
  nvm use $NODE_VERSION
  nvm alias default $NODE_VERSION
else
  echo "dotfiles-node: Your node version is up-to-date. Returning early."
fi

