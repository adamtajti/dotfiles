export ZVM_SYSTEM_CLIPBOARD_ENABLED=true

# SECTION: Clone Antidote if it's missing
# DEPENDENCY: Git
if ! [ -e "$HOME/.antidote" ]; then
  echo "Cloning Antidote to $HOME/.antidote"
  git clone --depth=1 https://github.com/mattmc3/antidote.git $HOME/.antidote
fi

# SECTION: Antidote Initialization

# Source the main entry point
source ~/.antidote/antidote.zsh

# https://getantidote.github.io/#ultra-high-performance-install
# Set the name of the static .zsh plugins file antidote will generate.
zsh_plugins=$HOME/.zsh_plugins.zsh

# Ensure you have a .zsh_plugins.txt file where you can add plugins.
[[ -f ${zsh_plugins:r}.txt ]] || touch ${zsh_plugins:r}.txt

# Lazy-load antidote.
fpath+=(~/.antidote)
autoload -Uz $fpath[-1]/antidote

# Generate static file in a subshell when .zsh_plugins.txt is updated.
if [[ ! $zsh_plugins -nt ${zsh_plugins:r}.txt ]]; then
  (antidote bundle <${zsh_plugins:r}.txt >|$zsh_plugins)
fi

# Source your static plugins file.
source $zsh_plugins

# SECTION: Foot's ZSH modifications
#
# Pasted this section from foot's documentation
function osc7-pwd()
{
  emulate -L zsh # also sets localoptions for us
  setopt extendedglob
  local LC_ALL=C
  # shellcheck disable=SC1003,SC1009,SC1073,SC1072
  printf '\e]7;file://%s%s\e\' $HOST ${PWD//(#m)([^@-Za-z&-;_~])/%${(l:2::0:)$(([##16]#MATCH))}}
}

function chpwd-osc7-pwd()
{
  (( ZSH_SUBSHELL )) || osc7-pwd
}

# For some reason the add-zsh-hook wasn't available without autoload
autoload -U add-zsh-hook
add-zsh-hook -Uz chpwd chpwd-osc7-pwd

# Load completions
# https://getantidote.github.io/completions

# if [[ "$(uname -a)" == *"gentoo"* ]]; then
#   fpath+="/usr/share/zsh/site-functions"
#   #export FPATH="/usr/share/zsh/site-functions:$FPATH"
# fi

bindkey -M vicmd '^O' fzf-history-widget
bindkey -M viins '^O' fzf-history-widget

export FZF_ALT_C_COMMAND="fd --type d --strip-cwd-prefix"
export FZF_CTRL_T_COMMAND="fd --type f --strip-cwd-prefix "
export FZF_CTRL_T_HIDDEN_COMMAND="fd --type f --stip-cwd-prefix --hidden --follow --exclude .git"

# autoload -Uz compinit && compinit
# ZSH_COMPDUMP=${ZSH_COMPDUMP:-${ZDOTDIR:-~}/.zcompdump}
#
# # cache .zcompdump for about a day
# if [[ $ZSH_COMPDUMP(#qNmh-20) ]]; then
#   compinit -C -d "$ZSH_COMPDUMP"
# else
#   compinit -i -d "$ZSH_COMPDUMP"; touch "$ZSH_COMPDUMP"
# fi
# {
#   # compile .zcompdump
#   if [[ -s "$ZSH_COMPDUMP" && (! -s "${ZSH_COMPDUMP}.zwc" || "$ZSH_COMPDUMP" -nt "${ZSH_COMPDUMP}.zwc") ]]; then
#     zcompile "$ZSH_COMPDUMP"
#   fi
# } &!

bindkey "^H" backward-delete-char
bindkey "^?" backward-delete-char
