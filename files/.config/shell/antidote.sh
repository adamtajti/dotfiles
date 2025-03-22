# Add cargo to the path as atuin gets installed there
export PATH="$HOME/.cargo/bin:$PATH"

# I'll bind the keys myself
export ATUIN_NOBIND="yes"

# Install atuin if it's not available. It's used to sync history and make it available
# on every machine: https://github.com/atuinsh/atuin
#if ! type "atuin" > /dev/null; then
#  bash <(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)
#fi

# atuin register -u "adamtajti" -e "adam.tajti@gmail.com"
#atuin import auto
# Disabled this sync, sync it was triggered too frequently
# (atuin sync > /dev/null 2>&1 &)

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

# Attempting to load this with a plugin instead in ~/.zsh_plugins.txt
# autoload -Uz compinit && compinit

bindkey '^O' atuin-search

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

# theme settings for zdharma-continuum/fast-syntax-highlighting
# this is just for documentation, no need to execute in each session.
# fast-theme spa

# Support copy with CTRL+Y (doesn't work yet, PS1 is not the way to go)
copy_prompt_to_clipboard()
{
    # For macOS, use `pbcopy`
    # For Linux, use `xclip` or `wl-copy` depending on your clipboard tool:
    print -n $PS1 | wl-copy
}

zle -N copy_prompt_to_clipboard
bindkey -M vicmd '^y' copy_prompt_to_clipboard  # Bind to Ctrl+y in vi command mode
