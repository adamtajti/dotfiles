#!/bin/zsh

# Checkout teleport v6.2.0
if [ ! -d "$HOME/GitHub/teleport" ]; then
  mkdir -p $HOME/GitHub/
  cd $HOME/GitHub/
  git clone git@github.com:gravitational/teleport.git || { exit 1; }
  cd $HOME/GitHub/teleport
  git checkout v6.2.0
fi

cd $HOME/GitHub/teleport
make full

# create the default data directory before starting:
sudo mkdir -p -m0700 /var/lib/teleport
sudo chown $USER /var/lib/teleport

cp build/* $HOME/.local/bin/
