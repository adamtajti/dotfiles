#!/bin/zsh
# Navigate to our working directory.
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-vi-mode" ]; then
  mkdir -p $HOME/.oh-my-zsh/custom/plugins/
  cd $HOME/.oh-my-zsh/custom/plugins
  git clone https://github.com/jeffreytse/zsh-vi-mode || { exit 1; }
else
  cd $HOME/.oh-my-zsh/custom/plugins/zsh-vi-mode
  # OPTIMIZATION: Check if we are already on the latest version and quit earlier
  echo "dotfiles-zsh-vi-mode: looking for a new version"
  git remote update &> /dev/null
  GIT_STATUS=$(git status -uno | head -n 2 | tail -n 1)
  if [[ "$GIT_STATUS" == "Your branch is up to date with"* ]]; then
    echo "dotfiles-zsh-vi-mode: your zsh-vi-mode version is up-to-date"
    exit 0
  fi
fi

echo "dotfiles-zsh-vi-mode: your zsh-vi-mode version is outdated."

# Update our sources to the latest master
echo "dotfiles-zsh-vi-mode: pulling the latest version"
git pull &> /dev/null
