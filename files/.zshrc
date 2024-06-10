# NOTE: `/home/adamtajti/` instead of `~/`, so that this can be sourced from a root account.

# ZSH Comes with a profiler that can be enabled by uncommenting the line after this comment.
# `zprof` needs to be called at the bottom to collect the profiles and generate the report.
# zmodload zsh/zprof

source /home/adamtajti/.config/shell/antidote.sh

# TODO: Detect if the .rbenv folder is missing and automatically install rbenv
eval "$(/home/adamtajti/.rbenv/bin/rbenv init - zsh)"

source /home/adamtajti/.config/shell/tulip-zsh-hooks.sh

# TODO: The .histfile backup probably doesn't work right now. Look into a backing it up somehow.
source /home/adamtajti/.config/shell/personal.sh

if [ $(uname) = "Darwin" ]; then
  source /home/adamtajti/.config/shell/darwin.sh
fi

source /home/adamtajti/.config/shell/tulip.sh
source /home/adamtajti/.config/shell/experimental.sh

# Uncomment the following line along with the top zprof related one to profile the startup time.
# zprof

eval "$(atuin init zsh)"

bindkey -M viins '^O' atuin-search
