#!/bin/sh

cd $HOME/GitHub

# Get the latest upstream downloaded
if [! -d "$HOME/GitHub/awakened-poe-trade"]; then
  git clone git@github.com:hsource/awakened-poe-trade.git
  cd awakened-poe-trade
else
  cd awakened-poe-trade
  git pull
fi
git remote add upstream git@github.com:SnosMe/awakened-poe-trade.git
git fetch upstream

# Rebase the macos patch
git checkout macos
git fetch && git reset --hard origin/macos
# The rebase may show conflicts. If there are conflicts, you may need to manually resolve them or wait for a new release
git rebase upstream/master

# Ensure dependencies are updated and build
cd main
DEFAULT_VERSION=$(nvm version default)
nvm install stable
nvm use stable
yarn install
yarn make-index-files
yarn electron:build
nvm use $DEFAULT_VERSION

