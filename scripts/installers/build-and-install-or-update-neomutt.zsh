#!/bin/zsh

# This file is being kept separate for Mac as the ncurses libs needs to be overwritten here.
# The default XCode installation seems to miss the `A_ITALICS` definitions.

# Navigate to our working directory.
if [ ! -d "$HOME/GitHub/neomutt" ]; then
  mkdir -p $HOME/GitHub/
  cd $HOME/GitHub/
  git clone git@github.com:neomutt/neomutt.git || { exit 1; }
  cd $HOME/GitHub/neomutt
else
  cd $HOME/GitHub/neomutt
  # OPTIMIZATION: Check if we are already on the latest version and quit earlier
  echo "dotfiles-neomutt: looking for a new version"
  git remote update &> /dev/null
  # GIT_STATUS=$(git status -uno | head -n 2 | tail -n 1)
  # if [[ "$GIT_STATUS" == "Your branch is up to date with"* ]]; then
  #   echo "dotfiles-neomutt: your neomutt version is up-to-date"
  #   exit 0
  # fi
fi

echo "dotfiles-neomutt: your neomutt version is outdated."

# Update our sources to the latest master
echo "dotfiles-neomutt: pulling the latest version"
git pull &> /dev/null

# Do a cleanup
make distclean &> /dev/null

# Create the makefile for our OS and build it
echo "dotfiles-neomutt: building"

export LDFLAGS="-L/opt/homebrew/opt/ncurses/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ncurses/include"

./configure --disable-doc --disable-nls --gnutls > /dev/null
make -j$(nproc) &> /dev/null

# Install neovim into our system with the generated Makefile
echo "dotfiles-neomutt: installation"
sudo make install &> /dev/null

# Make sure that the mailbox is created for the system. It was missing on my mac without this
echo "initialize mailbox" | mail -s "initialize mailbox" adamtajti@localhost
