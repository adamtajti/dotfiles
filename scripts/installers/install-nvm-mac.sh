#!/bin/sh

if [ -x "$(command -v nvm)" ]; then
  echo 'dotfiles-nvm: nvm is already installed.' >&2
  exit 0
fi

# Install NVM
# The command is taken from https://github.com/nvm-sh/nvm#install--update-script
echo "dotfiles-nvm: installing / updating nvm"
LATEST_VERSION=$(curl -s https://github.com/nvm-sh/nvm/releases | grep "/nvm-sh/nvm/tree/v" | head -n 1 | sed 's/.*\/nvm\-sh\/nvm\/tree\/v\([0-9\.]*\).*/\1/')
curl -s -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v${LATEST_VERSION}/install.sh" | bash &> /dev/null

# 
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

echo "dotfiles-nvm: done"

