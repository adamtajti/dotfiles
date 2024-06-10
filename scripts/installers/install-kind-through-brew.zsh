#!/bin/zsh

if [ $+commands[kind] -eq 1 ]; then
  echo 'dotfiles-kind: kind is already installed. Returning early.' >&2
  exit 0
fi

echo 'dotfiles-kind: installing kind'
brew install kind


# From the output of the install
# TODO: Make a script which sets up the completions as well.
# for zsh users
# % kind completion zsh > /usr/local/share/zsh/site-functions/_kind
# % autoload -U compinit && compinit
# or if zsh-completion is installed via homebrew
# % kind completion zsh > "${fpath[1]}/_kind"
# or if you use oh-my-zsh (needs zsh-completions plugin)
# % mkdir $ZSH/completions/
# % kind completion zsh > $ZSH/completions/_kind
