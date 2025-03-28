# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# NOTE: `/home/adamtajti/` instead of `~/`, so that this can be sourced from a root account.

# ZSH Comes with a profiler that can be enabled by uncommenting the line after this comment.
# `zprof` needs to be called at the bottom to collect the profiles and generate the report.
# zmodload zsh/zprof

source ~/.config/shell/antidote.sh

source ~/.config/shell/tulip-zsh-hooks.sh

source ~/.config/shell/personal.sh
source ~/.config/shell/personal-private.sh

if [ $(uname) = "Darwin" ]; then
  source ~/.config/shell/darwin.sh
fi

source ~/.config/shell/tulip.sh
source ~/.config/shell/experimental.sh

# Uncomment the following line along with the top zprof related one to profile the startup time.
# zprof

eval "$($HOME/.atuin/bin/atuin init zsh)"

bindkey -M viins '^O' atuin-search

# dont trust the completion cache, this is useful while developing gentoo packages.
zstyle ":completion:*:commands" rehash 1

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
