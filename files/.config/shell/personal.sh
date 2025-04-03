#!/usr/bin/env bash

# This file is designed to be sourced from a shell. These functionalities are
# personal, they that may be used for my personal work or at any given company

# less is the default pager. I had issues with it once.
# PAGER="nvim"

export NVIM_NOTIFY_DEBUG_MODE="true"
export CLICKUP_DEBUG_ENABLED="true"
export CLICKUP_TRACE_ENABLED="true"

# If you come from bash you might have to change your $PATH.
export PATH="$HOME/.local/bin:$PATH"

# Atuin
export PATH="$HOME/.atuin/bin:$PATH"

# FVim: A NeoVIM GUI written in F# that supports multi-grid windowing.
# This means that buffers can be opened as external toplevel windows.
export PATH="$HOME/GitHub/yatli/fvim/bin/Release/net6.0/linux-x64/publish/:$PATH"

# klp (log viewer (jsonl))
# export PATH="$HOME/GitHub/dloss/klp/venv/bin:$PATH"

# This was required to setup Nim, which is used to the minorg project.
export PATH=$HOME/.nimble/bin:$PATH

# tfswitch ... thanks for another non-standard path to pollute my home directory you fuckers
export PATH=$PATH:/home/adamtajti/bin

# Quick addition cause I keep forgetting where to place the .Desktop files
export DESKTOP_FILES_HOME_DIR="$HOME/.local/share/applications/"

p-cd-desktop-files-home-dir()
{
  cd "$DESKTOP_FILES_HOME_DIR" || exit 1
}

# Set default browser, used by sway for example
export BROWSER="firefox"

# pnpm
export PNPM_HOME="/home/adamtajti/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# setup GTK if that's what's used
if [[ "$DESKTOP_SESSION" == "gnome" ]]; then
  resize_opt="$(gsettings get 'org.gnome.desktop.wm.preferences' 'resize-with-right-button')"
  if [[ "$resize_opt" != "true" ]]; then
   gsettings set 'org.gnome.desktop.wm.preferences' 'resize-with-right-button' "true"
  fi
fi

# IMPORTANT: Passing the environment variables to sudo.
# This is required to make the `sudo nvim ...` commands work correctly with
# Clipboard support on Wayland.
alias sudo="sudo -E"

# Curl with automatic -w switch
alias c="curl -w '\\n'"

# Start Zathura in the background
alias z="detach zathura"

# -----------------------------------------------------------------------------
# UX / TTS
# -----------------------------------------------------------------------------

tts()
{
  /home/adamtajti/GitHub/TTS/venv/bin/tts --text "$1" --model_name "tts_models/en/ljspeech/tacotron2-DDC" --vocoder_name "vocoder_models/en/ljspeech/hifigan_v2" --out_path "/tmp/tts_lj" && mpv /tmp/tts_lj
}

# -----------------------------------------------------------------------------
# QT
# -----------------------------------------------------------------------------

# https://wiki.gentoo.org/wiki/GTK_themes_in_Qt_applications
QT_QPA_PLATFORMTHEME=qt5ct

# -----------------------------------------------------------------------------
# Make
# -----------------------------------------------------------------------------

# I tend to use make more and more and sometimes I forget to set the -j option:
export MAKEFLAGS='-j 12'


# -----------------------------------------------------------------------------
# VCPKG
# -----------------------------------------------------------------------------
export VCPKG_DISABLE_METRICS="YES"
export VCPKG_ROOT="$HOME/GitHub/microsoft/vcpkg"
export PATH="$VCPKG_ROOT:$PATH"

# -----------------------------------------------------------------------------
# ZSH
# -----------------------------------------------------------------------------

# Push it to the limit
# I'm using Altuin to synchronize the history between different workstations.
export HISTFILE=~/.histfile
export HISTSIZE=1000000000 # the number of items for the internal history list
export SAVEHIST=1000000000 # maximum number of items for the history file

# Cleaning the history up from the duplicates.
export HISTCONTROL=ignoredups

# The meaning of these options can be found in man page of `zshoptions`.
setopt HIST_IGNORE_ALL_DUPS  # do not put duplicated command into history list
setopt HIST_SAVE_NO_DUPS  # do not save duplicated command
setopt HIST_REDUCE_BLANKS  # remove unnecessary blanks
setopt EXTENDED_HISTORY  # record command start time

# Share the history between the shells
setopt SHARE_HISTORY

# Lol, you can't use `#` comments in command prompts without this
setopt interactivecomments

# VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
# VI_MODE_SET_CURSOR=true
# MODE_INDICATOR="%F{white}+%f"
# INSERT_MODE_INDICATOR="%F{yellow}+%f"

# Sets the title of the terminal to executed man page
man()
{
  echo -en "\033]0;man $*\a"
  /bin/man "$@"
  echo -en "\033]0;foot\a"
}

alias l="lsd --long"
alias lt="lsd --long --tree"
alias ga="git add"
alias gwp="git commit -am wip && git push -u origin HEAD"
alias gpo="git push -u origin HEAD"
alias gd="git diff"
grc()
{
  git rebase --continue
}
alias n="notebook"
alias j="journal"

# follow the symbolic links by default, that's my expected behavior
alias rg="rg --follow"

# create a new temporary directory and navigate there, good for temp testing
cdt()
{
  local cdt_path="/tmp/cdt"
  mkdir -p "$cdt_path"
  cd "$(mktemp --directory --tmpdir="$cdt_path")"
}

alias cdtmp="cdt"

# SECTION: Starship
export STARSHIP_CONFIG="$HOME/.config/starship.toml"

# SECTION: Gaming

# Nukes down all the Path of Exile related stuff
p-steam-close-poe()
{
  killall steam
  killall reaper
  killall  pv-bwrap
  killall wine
  killall winserver
  killall gamescope
  killall -9 'winedevice.exe'
}

# SECTION: Sway

p-screenshot-area()
{
  slurp | grim -g - - | wl-copy
}

p-screenshot-monitor()
{
  grim -o "$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')"
}

p-record-screen()
{
  wf-recorder -g "$(slurp)" -f ~/recording.mp4
}

p-focused-window-pid()
{
  swaymsg -t get_tree -r | jq '.. | (.nodes? // empty)[] | select(.focused) | .pid'
}

p-get-poe-pid()
{
  swaymsg -t get_tree -r | jq '.. | (.nodes? // empty)[] | select(.nodes[].name == "Path of Exile")'
}

# SECTION: Terminal Emulators

# Set the title / name of the current window...
# p-set-title()
# {
#   echo -e "\033]$1\007"
# }

case "$TERM" in
  foot*|xterm*|rxvt*)
    function p-set-title ()
    {
      # OSC 0: https://github.com/DanteAlighierin/foot?tab=readme-ov-file#supported-oscs
      builtin print -n -- "\e]0;$@\a"
    }
    ;;
  screen)
    function xtitle ()
    {
      builtin print -n -- "\ek$@\e\\"
    }
    ;;
  kitty)
    function p-set-title ()
    {
      echo -e "\033]$1\007"
    }
    ;;
  *)
    function p-set-title ()
    {
      return
    }
esac

# With ZSH set the title automatically
function precmd ()
{
  # OSC 133: https://github.com/DanteAlighierin/foot?tab=readme-ov-file#supported-oscs
  print -Pn "\e]133;A\e\\" # for foot, jumping between prompts
  p-set-title "$(print -P zsh '(%~)')"
}

function preexec ()
{
  p-set-title " $1"
}

# -----------------------------------------------------------------------------
# Kitty
# -----------------------------------------------------------------------------

if test -n "$KITTY_INSTALLATION_DIR"; then
    #export KITTY_SHELL_INTEGRATION="enabled no-title"
    export KITTY_SHELL_INTEGRATION="enabled"

    # This should only run in ZSH. I try to source this config in my ~/.bashrc
    if [ -z "${BASH_VERSINFO[*]}" ]; then
      autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
      kitty-integration
      unfunction kitty-integration
    fi
fi


# -----------------------------------------------------------------------------
# Shell
# -----------------------------------------------------------------------------

p-repeat-command-until-failure()
{
  while true
  do
    "$@" || return $?
  done
}

p-repeat-command-until-success()
{
  while true
  do
    "$@" || continue 1
    return 0
  done
}

# Watch commands
watch-date()
{
  watch -n 0.1 -c 'date'
}

mkdirdate()
{
  mkdir "$@" "$(date +"%Y-%m-%d")"
}

alias gsed="sed"

# -----------------------------------------------------------------------------
# Go
# -----------------------------------------------------------------------------

# Lists a detailed dependency list for the current project.
p-go-dependencies()
{
  go list -deps -f '{{define "M"}}{{.Path}}@{{.Version}}{{end}}{{with .Module}}{{if not .Main}}{{if .Replace}}{{template "M" .Replace}}{{else}}{{template "M" .}}{{end}}{{end}}{{end}}' | sort -u
}

p-go-clean()
{
  go clean -cache
  go clean -testcache
  go clean -modcache
  go clean -fuzzcache
}

# -----------------------------------------------------------------------------
# Docker
# -----------------------------------------------------------------------------

# Stop all the docker containers and remove the images
p-docker-clean()
{
  docker stop "$(docker ps -a -q)"
  docker rm "$(docker ps -a -q)"
  docker rmi "$(docker images -q)"

  # To remove the build caches as well. Once I had weird build errors on helm packages that didn't even exist
  # on my local machine anymore.
  # --force: Do not prompt for confirmation
  docker builder prune --all --force

  # This one should remove all the volumes as well.
  # --force: Do not prompt for confirmation
  docker system prune --all --volumes --force
}

p-docker-stop-all()
{
  docker ps | tail -n +2 | cut -d' ' -f 1 | xargs -P "$(nproc)" -I {} docker stop {}
}

p-docker-compose-healthcheck-why()
{
  if [ "$#" -ne 1 ]; then
    echo "usage: p-docker-compose-healthcheck-why <container_name>" >&2
    return 1
  fi

  docker inspect --format "{{json .State.Health }}" "$1" | jq
}

# -----------------------------------------------------------------------------
# Space Savings
# -----------------------------------------------------------------------------

p-save-space()
{
  # Docker can hold quite a bit of space
  p-docker-clear &

  # Clear Go modcache
  go clean -modcache &

  # Run Nix GC
  nix store gc
}

# -----------------------------------------------------------------------------
# Network
# -----------------------------------------------------------------------------

p-check-port-usage()
{
  sudo lsof -i "4tcp:$1" -sTCP:LISTEN
}

p-list-port-usages()
{
  sudo lsof -i -P -n +c0 | grep LISTEN
}

# -----------------------------------------------------------------------------
# Kubernetes
# -----------------------------------------------------------------------------

p-k8s-get-all-from-namespace()
{
  kubectl api-resources --verbs=list --namespaced -o name \
    | xargs -n 1 kubectl get --show-kind --ignore-not-found -n "$1"
}

# -----------------------------------------------------------------------------
# Git
# -----------------------------------------------------------------------------

export GITHUB_PATH="$HOME/GitHub"

# Git Commands
gs()
{
  git status
}

function lazygit()
{
  git commit -a -m "$1"
  git push -u origin HEAD
}

# Git WIP - Quickly commits all the changes to remote, could be useful in workflow development
gw()
{
  lazygit "wip"
}

# Util function to convert bytes to human readable format
p-to-human-readable()
{
  awk 'function human(x) {
         s=" B   KiB MiB GiB TiB EiB PiB YiB ZiB"
         while (x>=1024 && length(s)>1)
               {x/=1024; s=substr(s,5)}
         s=substr(s,1,4)
         xf=(s==" B  ")?"%5d   ":"%8.2f"
         return sprintf( xf"%s ", x, s)
      }
      {gsub(/^[0-9]+/, human($1)); printf}'
}

p-git-find-branches-which-contains-commit-sha()
{
  git --no-pager branch -r --contains "$1"
}

p-git-find-branches-which-contains-commit-message()
{
  git branch --contains "$(git log --all --grep="$1" --format='%H')" --all | sed 's/^..//'
}

p-git-local-ignore-file()
{
  local file="$1"
  local git_root="$(git rev-parse --show-toplevel)"
  if [ -z "$file" ]; then
      echo "Usage: ignore_file_locally <file>" >&2
      return 1
  fi

  echo "$file" >> "$git_root/.git/info/exclude"
  echo "Added $file to local exclude list"
}

p-git-commit-count-between-two-brances()
{
  local from="$1"
  local to="$2"

  # It is important to check the origin as the local branches may be out of date
  git rev-list --count --first-parent "origin/$from..origin/$to"
}

p-git-worktree-checkout()
{
  if [ "$#" -ne 1 ]; then
    echo "usage: p-git-worktree-checkout <branch>" >&2
    echo "example: p-git-worktree-checkout branch-name" >&2
    return 1
  fi

  branch_name=$1
  remote_url=$(git config --get remote.origin.url)
  p_gh_repo_name=$(basename -s .git "$remote_url")

  repo_path=$(p-git-root-path)
  git worktree add --checkout "${repo_path}/../${p_gh_repo_name}.${branch_name}" "$branch_name"
  cd "${repo_path}/../${p_gh_repo_name}.${branch_name}"
}

p-git-worktree-new()
{
  if [ "$#" -ne 1 ]; then
    echo "usage: p-git-worktree-new <branch>" >&2
    echo "example: p-git-worktree-new adam.branch-name" >&2
    return 1
  fi

  branch_name=$1
  remote_url=$(git config --get remote.origin.url)
  p_gh_repo_name=$(basename -s .git "$remote_url")

  repo_path=$(p-git-root-path)
  git worktree add -b "$branch_name" "${repo_path}/../${p_gh_repo_name}.${branch_name}"
  cd "${repo_path}/../${p_gh_repo_name}.${branch_name}"
}

p-git-show-large-loc-commits()
{
  git --no-pager log --since="6 months ago" --stat --pretty='format:%n %s (%an)' --stat-count=-1 | grep --before-context=3 --no-group-separator -E '[0-9]{4} insertions' | grep -v -E "^ \.\.\."
}

p-git-glob-branches-since()
{
  if [ "$#" -ne 2 ]; then
    echo "usage: p-git-glob-branches-since <glob> <since>" >&2
    echo "example: p-git-glob-branches-since '**/go.mod' '1 month ago'" >&2
    return 1
  fi

  glob=$1
  since=$2

  git log --all --source --since "$since" -- "$glob" | grep -o "refs/.*" | sort -u
}

p-git-glob-branches-since-until()
{
  if [ "$#" -ne 3 ]; then
    echo "usage: p-git-glob-branches-since-until <glob> <since> <until>" >&2
    echo "example: p-git-glob-branches-since-until '**/go.mod' '1 month ago' '2 weeks ago'" >&2
    return 1
  fi

  glob=$1
  since=$2

  git log --all --source --since "$since" -- "$glob" | grep -o "refs/.*" | sort -u
}

p-git-glob-branch-history()
{

  if [ "$#" -ne 1 ]; then
    echo "usage: p-git-glob-branch-history <glob>" >&2
    echo "example: p-git-glob-branch-history '**/go.mod'" >&2
    return 1
  fi

  glob=$1

  i=0
  iplusone=$((iplusone=i+1))

  # Show 4 weeks of evolution by default
  while [ $i -lt 4 ]
  do
    echo "\n$i weeks ago -> $iplusone weeks ago:"

    delta \
      --wrap-max-lines 0 \
      --hunk-header-style omit \
      --paging never \
      --file-style omit \
      <(p-git-glob-branches-since-until "$glob" "$i weeks ago" "$i weeks ago") \
      <(p-git-glob-branches-since-until "$glob" "$iplusone weeks ago" "$i weeks ago")

    i=$((i=i+1))
    iplusone=$((iplusone=iplusone+1))
  done
}

p-git-largest-files()
{
  large_files="$(git rev-list --all --objects | awk '{print $1}' | git cat-file --batch-check | sort -k3nr | head -n 500)"

  while read -r largefile; do
    # Blob SHA
    echo "$largefile" | awk '{printf "%s ", $1}'

    # Human readable size output
    echo "$largefile" | awk '{printf "%s", $3}' | p-to-human-readable

    # Path to file / folder of the blob
    echo "$largefile" | awk '{system("git rev-list --all --objects | grep " $1 " | cut -d \" \" -f 2-")}'

  done <<< "$large_files"
}

p-git-get-default-branch-from-origin()
{
  git remote show origin | sed -n '/HEAD branch/s/.*: //p'
}

p-git-submodules-pull-latest-upstream()
{
  # shellcheck disable=SC2016 # i dont want variable injections here
  git submodule foreach zsh -c '
  default_branch=$(git remote show origin | sed -n '\''/HEAD branch/s/.*: //p'\'')
    git pull origin $default_branch
  '
}

# Supported formats:
# git@github.com:exercism/cli.git
p-git-take()
{
  local ssh_format_example="git@github.com:exercism/cli.git"
  local ssh_format=$1

  if [[ -z "$ssh_format" ]]; then
    echo "usage: take <git-clone-ssh-format>" >&2
    echo "example: take $ssh_format_example" >&2
    return 1
  fi

  local left_part
  left_part=$(echo "$ssh_format" | cut -d'/' -f 1)
  if [[ -z "$left_part" ]]; then
    echo "invalid format: $ssh_format. correct example: $ssh_format_example" >&2
    return 1
  fi

  local gh_owner
  gh_owner=$(echo "$left_part" | cut -d':' -f 2)
  local right_part
  right_part=$(echo "$ssh_format" | cut -d'/' -f 2)
  if [[ -z "$right_part" ]]; then
    echo "invalid format: $ssh_format. correct example: $ssh_format_example" >&2
    return 1
  fi

  local gh_repo_name=${right_part//\.git/}

  local path_to_clone="$HOME/GitHub/$gh_owner/$gh_repo_name"
  mkdir -p "$path_to_clone"
  cd "$path_to_clone" || return 1

  if [ -z "$( ls -A './' )" ]; then
    git clone "$1" .
  else
    hub sync
  fi
}

p-git-remote-head-sha()
{
  git ls-remote "$1" HEAD | cut -d $'\t' -f 1
}

p-git-temp-take()
{
  temp_dir="$(mktemp -d)"
  git clone --quiet "$1" "$temp_dir"
  cd "$temp_dir" || return 1
}

p-git-temp-take-bare-for-history()
{
  temp_dir="$(mktemp -d)"
  git clone --quiet --bare --filter=blob:none --single-branch "$1" "$temp_dir"
  cd "$temp_dir" || return 1
}

p-git-largest-files-summarized()
{
  python3 ~/.config/shell/scripts/p-git-largest-files-summarized.py
  # keys=()
  # values=()
  #
  # temp_file="../rev-list.txt"
  #
  # if [ ! -f "$temp_file" ]; then
  #   git rev-list --objects --all > $temp_file
  # fi
  #
  # while read -r largefile; do
  #   echo $largefile
  #   sha=$(echo "$largefile" | awk '{printf "%s ", $1}')
  #   size=$(echo "$largefile" | awk '{printf "%s", $3}')
  #
  #   file_path_line=$(grep "$sha" "$temp_file")
  #   echo "$file_path_line"
  #   file_path=$(echo "$file_path_line" | awk '{print $2}')
  #   echo "$file_path"
  #
  #   printf "."
  #
  #   index=-1
  #   for i in $(seq 0 $(( ${#keys[@]} - 1 ))); do
  #     if [[ "${keys[$i]}" == "$file_path" ]]; then
  #       index=$i
  #       break
  #     fi
  #   done
  #
  #   if [[ $index -ge 0 ]]; then
  #     previous_size=${values[$index]}
  #     new_size=$((previous_size + size))
  #     values[$index]=$new_size
  #   else
  #     keys+=("$file_path")
  #     values+=("$size")
  #   fi
  #
  #   # if [[ -v files[$file_path] ]]; then
  #   #   previous_size_string=${files[$file_path]}
  #   #   declare -i previous_size="$previous_size_string"
  #   #   let "previous_size=previous_size_string"
  #   #   new_size=$((previous_size + size))
  #   #   files[$file_path]=$new_size
  #   # else
  #   #   files[$file_path]=$size
  #   # fi
  #
  # done <<< "$(cat $temp_file | awk '{print $1}' | git cat-file --batch-check | sort -k3nr | head -n 5)"
  #
  # printf "\n\n"
  # # in bash: ${!keys[@]}
  # # in zsh: ${(@k)keys}
  # for i in "${(@k)keys}"; do
  #   file_path=${keys[$i]}
  #   size=${values[$i]}
  #   human_readable_size=$(printf "%s" "$size")
  #   echo "$file_path: $human_readable_size"
  # done

  # for file_path in "${!files[@]}"; do
  #   size="${files[$file_path]}"
  #   echo $size
  #   human_readable_size=$(printf "%s" $size | p-to-human-readable)
  #   echo "$file_path: $human_readable_size"
  # done
}



p-git-diff()
{
  git diff --cached | bat --paging=never
}

# -----------------------------------------------------------------------------
# Nix
# -----------------------------------------------------------------------------

export NIX_STORE_PATH="/nix/store"

p-nix-clean()
{
  nix store gc
}

# -----------------------------------------------------------------------------
# Zygote
# -----------------------------------------------------------------------------

export ZYGOTE_PATH="$GITHUB_PATH/Zygote"

_p-zygote-build()
{
  cd "$ZYGOTE_PATH" &&
    cmake \
      -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
      -S ./ \
      -B ./build "${@[@]}" &&
    cd ./build &&
    make &&
    sudo make install
}

p-zygote-build-and-observe()
{
  _p-zygote-build "${@[@]}" &&
    l --tree "$AEMBRYO_PATH/build/"
}

p-zygote-build()
{
  _p-zygote-build "$@";
}

# -----------------------------------------------------------------------------
# Aembryo
# -----------------------------------------------------------------------------

export AEMBRYO_PATH="$GITHUB_PATH/Aembryo"
_p-aembryo-build()
{
  cd "$AEMBRYO_PATH" &&
    cmake \
      -DZygote_DIR="/usr/local/lib64/cmake/Zygote/" \
      -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
      -S ./ \
      -B ./build "${@[@]}" &&
    cd ./build &&
    make
}

p-aembryo-build-release()
{
  declare -a additional_args=()
  additional_args+=("-DCMAKE_BUILD_TYPE=Release")
  _p-aembryo-build "${additional_args[@]}"
}

p-aembryo-build-minsize()
{
  declare -a additional_args=()
  additional_args+=("-DCMAKE_BUILD_TYPE=MinSizeRel")
  _p-aembryo-build "${additional_args[@]}"
}

p-aembryo-build-and-run-fresh()
{
  declare -a additional_args=()
  additional_args+=("--fresh")
  _p-aembryo-build "${additional_args[@]}" &&
    "$AEMBRYO_PATH/build/Aembryo"
}

p-aembryo-build-and-run()
{
  _p-aembryo-build &&
    "$AEMBRYO_PATH/build/Aembryo"
}

p-aembryo-code()
{
  cd "$AEMBRYO_PATH" && nvim .
}

# -----------------------------------------------------------------------------
# Dotfiles
# -----------------------------------------------------------------------------

# Path to my dotfiles folder and its main attractions
# This is where I store my configurations and installer and user scripts.
export DOTFILES_PATH="$GITHUB_PATH/dotfiles"
export DOTFILES_CONFIG_PATH="$DOTFILES_PATH/files/config"
export DOTFILES_CONFIG_NVIM_PATH="$DOTFILES_CONFIG_PATH/nvim"
export DOTFILES_CONFIG_SHELL_PATH="$DOTFILES_CONFIG_PATH/shell"
export DOTFILES_NVIM_PLUGINS_PATH="$DOTFILES_CONFIG_NVIM_PATH/lua/plugins"
export DOTFILES_SNIPPETS_PATH="$DOTFILES_PATH/files/snippets/luasnippets/"

p-dotfiles-edit()
{
  (cd "$DOTFILES_PATH" && nvim "$DOTFILES_PATH")
}

p-dotfiles-edit-nvim-plugins()
{
  (cd "$DOTFILES_PATH" && nvim .)
}

# To fetch the latest and build a new nvim release
p-dotfiles-update-nvim()
{
  eval "$DOTFILES_PATH/scripts/installers/build-and-install-or-update-neovim.sh"
}

# System Maintanence
p-dotfiles-system-update()
{
  (cd "$DOTFILES_PATH/scripts/installers" && ./_update-system.sh)
}

# Update the links
p-dotfiles-update-links()
{
  (cd "$DOTFILES_PATH" && ./scripts/setup.sh)
}

p-dotfiles-add()
{
  (
    if [[ "$(uname -a)" != *"gentoo"* ]]; then
      echo "Only Gentoo is supported at the moment." 1>&2
      return 1
    fi

    if [[ "$#" -lt 1 ]]; then
      echo "usage: p-dotfiles-add <source>" 1>&2
      echo "example: p-dotfiles-add ~/.gnupg/gpg-agent.conf" 1>&2
      return 1
    fi

    path="${1/#\~/$HOME}"

    if ! [[ -f "$path" ]]; then
      echo "The provided path is not a file. Only files are supported at the moment!" 1>&2
      return 1
    fi

    # Store the source path without the actual value of $HOME
    source_path="${path/$HOME/~}"
    echo "source_path: $source_path"

    # TODO: Actually insert the link into this file
  )
}

# -----------------------------------------------------------------------------
# NVIM & NeoVide
# -----------------------------------------------------------------------------
alias v="nvim"
alias nv="detach neovide"

# Sets the default editor to nvim
export EDITOR="nvim"
export ZVM_VI_EDITOR="nvim"

# Make sure that the custom neovim installations are detected
export PATH="$HOME/neovim/bin:$PATH"
# I started using bob at 2024-09-17
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"

# This is where the lazy.nvim package manager installs the packages
# This can be aquired from inside neovim: `lua print(vim.fn.stdpath('data'))`
export NVIM_DATA_PATH="$HOME/.local/share/nvim"
export NVIM_LAZY_PATH="$NVIM_DATA_PATH/lazy"
export NVIM_STATE_PATH="$HOME/.local/state/nvim/"
export NVIM_CACHE_PATH="$HOME/.cache/nvim/"

#alias ssh="/usr/local/bin/tsh ssh"
# ssh()
# {
#   kitty +kitten ssh "$@"
# }

# This completely clears the scrollback buffer so it can be easier to open it up with cmd+z in nvim
kittyclear()
{
  printf '\033[2J\033[3J\033[1;1H'
}

cls()
{
  kittyclear
}

clear()
{
  kittyclear
}

# Fuzzy searching can get quite complex. Lets make an alias for it
search()
{
  fd --type f | fzf
}

if [[ $OSTYPE == 'darwin'* ]]; then
  export DROPBOX_PATH="$HOME/Library/CloudStorage/Dropbox"
else
  export DROPBOX_PATH="$HOME/Dropbox"
fi

# A shortcut for opening neomutt with my Personal profile
p-mutt()
{
  GPG_TTY=$(tty)
  export GPG_TTY
  ~/GitHub/neomutt/contrib/oauth2/mutt_oauth2.py ~/GitHub/neomutt/contrib/oauth2/adam.tajti.personal.tokens &> /dev/null
  neomutt -F ~/.neomutt/profile.personal
}

# Notebook support
export NOTEBOOK_PATH="$DROPBOX_PATH/Notebook"
notebook()
{
  cd "$NOTEBOOK_PATH" && nvim .
}
# The journal is part of the notebook.
# I may want to look into setting up an always running server, which I would just connect to and save from time to time.
journal()
{
  cd "$NOTEBOOK_PATH" && \
    nvim "$NOTEBOOK_PATH" -c ":execute 'PossessionLoad notebook' | execute 'Neorg journal today'"
}


# Makes git auto completion faster favouring for local completions
# Source: https://github.com/skwp/dotfiles/blob/master/zsh/git.zsh
__git_files ()
{
    _wanted files expl 'local files' _files
}

# Crazy Globals; alias -g is only supported by ZSH
if [ -z "$BASH_VERSINFO" ]; then
  alias -g C='wc -l'
  alias -g H='head'
  alias -g T='tail'
  #alias -g L="less --use-color"
  alias -g N="/dev/null"
  alias -g S='sort'
  alias -g G='grep'
  alias -g J='jq'
fi

alias dmesg='dmesg --color=always'
alias D='dmesg --color=always'

# Change the working directory to GitHub
cdgh()
{
  cd "$HOME/GitHub" || exit
}

# Clone the repo and cd into it
ghc()
{
  cdgh && take "$1"
}

cdd()
{
  cd "$DOTFILES_PATH" || exit
}

p-git-root-path()
{
  git rev-parse --show-toplevel
}

p-cdr()
{
  cd "$(p-git-root-path)" || exit
}

# -----------------------------------------------------------------------------
# Terraform
# -----------------------------------------------------------------------------

# tfswitch
alias tfswitch="tfswitch -b ~/.local/bin/terraform"


# -----------------------------------------------------------------------------
# GitHub/nix build hacks
# -----------------------------------------------------------------------------

# Commenting all of these out at 2023-11-14. Remove this section after 2024-02-14.

# export PATH="/opt/homebrew/opt/libarchive/bin:$PATH"
#
# # I'm not sure if these should be simply overwritten this way or not
# export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/libarchive/lib"
# export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/libarchive/include"
# export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/libarchive/lib/pkgconfig"
#
# # libeditline is not found, sadeg.
# #For compilers to find libedit you may need to set:
# #  export LDFLAGS="-L/opt/homebrew/opt/libedit/lib"
# #  export CPPFLAGS="-I/opt/homebrew/opt/libedit/include"
# #
# #For pkg-config to find libedit you may need to set:
# #  export PKG_CONFIG_PATH="/opt/homebrew/opt/libedit/lib/pkgconfig"
# export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/libedit/lib"
# export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/libedit/include"
# export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/libedit/lib/pkgconfig"

# less defaults to tab width of 4, but I would like it to render that as 2
# export LESS="-R -M --shift 5" # default on Gentoo
export LESS="-R -M --shift 5 -x2 -F"

p-hex-to-rgb()
{
  if [ "$#" -ne 1 ]; then
    echo "usage: p-hex-to-rgb <hex>" >&2
    echo "example: p-hex-to-rgb 080808" >&2
    return 1
  fi

  hex=$1
  printf "%d %d %d\n" 0x${hex:0:2} 0x${hex:2:2} 0x${hex:4:2}
}

# I started using Podman on Ubuntu, it's no longer required though on Gentoo
# export DOCKER_HOST='unix:///home/adamtajti/.local/share/containers/podman/machine/qemu/podman.sock'

# Setting the default py to py3. Added this on Windows, fingers crossed that it'll go well
# on Mac as well.
alias python="python3"

# Gentoo: Startup sway with XDF_CURRENT_DESKTOP set on dbus invocation
p-gentoo-start-sway()
{
  XDG_CURRENT_DESKTOP=sway dbus-run-session sway
}

p-gentoo-update()
{
  sudo emerge --sync &&
    sudo emerge --ask --verbose --update --deep --newuse --with-bdeps=y @world
}

p-install-1password-desktop-amd64()
{
  (
    cd "$(mktemp -d)" || return 1
    curl -sSO https://downloads.1password.com/linux/tar/stable/x86_64/1password-latest.tar.gz
    sudo tar -xf 1password-latest.tar.gz
    sudo mkdir -p /opt/1Password
    sudo rm -rf /opt/1Password # to support reinstall
    sudo mkdir -p /opt/1Password
    sudo mv 1password-*/* /opt/1Password
    sudo ln -s /opt/1Password/1password /usr/local/bin/1password
  )
}

p-install-1password-cli-amd64()
{
  (
    cd "$(mktemp -d)" || return 1
    #ARCH="<choose between 386/amd64/arm/arm64>" && \
    ARCH="amd64" && \
    wget "https://cache.agilebits.com/dist/1P/op2/pkg/v2.24.0/op_linux_${ARCH}_v2.24.0.zip" -O op.zip && \
    unzip -d op op.zip && \
    sudo mv op/op /usr/local/bin/ && \
    rm -r op.zip op && \
    sudo groupadd -f onepassword-cli && \
    sudo chgrp onepassword-cli /usr/local/bin/op && \
    sudo chmod g+s /usr/local/bin/op
  )
}

p-install-tsh-amd64()
{
  (
    cd "$(mktemp -d)" || return 1
    curl "https://get.gravitational.com/teleport-v6.2.28-linux-amd64-bin.tar.gz" | tar xz \
      && cd teleport/ \
      && sudo ./install
  )
}

p-install-pnpm-amd64()
{
  curl -fsSL https://get.pnpm.io/install.sh | sh -
}

p-install-aws-cli-amd64()
{
  (
    cd "$(mktemp -d)" || return 1
    curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
      && unzip awscli-bundle.zip \
      && sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
  )
}

p-git-setup-fork-maintainer-gha()
{
  if [ "$#" -ne 2 ]; then
    echo "usage: p-git-setup-fork-maintainer-gha '<your_fork>' '<original_repo>'" >&2
    echo "example: p-git-setup-fork-maintainer-gha 'adamtajti/lualine.nvim' 'nvim-lualine/lualine.nvim'" >&2
    return 1
  fi

  your_fork=$1
  original_repo=$2

  tmp_work_dir=$(mktemp -d)

  cd "$tmp_work_dir" || return 1
  git clone "git@github.com:${your_fork}.git" "fork" > /dev/null || return 2
  cd "fork" || return 1

  mkdir -p ".github/workflows"
  workflow_file=".github/workflows/rebase.yml"
  if [[ -f "$workflow_file" ]]; then
    echo "WARN: The rebase workflow ('$workflow_file') already exists in the freshly cloned fork. Considering out job done."
    return 0
  fi

  branch=$(git branch --show-current)

  cat <<EOF > "$workflow_file"
name: Rebase Upstream (Nightly)
on:
  schedule:
  - cron: "0 0 * * *"
  workflow_dispatch:

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
      with:
        fetch-depth: 0
    - uses: imba-tjd/rebase-upstream-action@master
      with:  # all args are optional
        upstream: ${original_repo}
        branch: ${branch}
EOF

  git add "$workflow_file"
  git commit -m "Add rebase workflow to sync with ${original_repo}"
  git push -u origin HEAD
}

p-poe1-start-path-of-building()
{
  wine-vanilla-9.0 "$HOME/.wine/drive_c/users/adamtajti/AppData/Roaming/Path of Building Community/Path of Building.exe" &> /dev/null &
}

POE2_STEAM_ITEM_FILTERS_PATH="$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/compatdata/2694490/pfx/drive_c/users/steamuser/Documents/My Games/Path of Exile 2/"

p-poe2-edit-stem-item-filters()
{
  nvim "$POE2_STEAM_ITEM_FILTERS_PATH"
}

POE2_STEAM_PATH="$HOME/.var/app/com.valvesoftware.Steam/data/Steam/steamapps/common/Path of Exile 2/"
p-cd-poe2-flatpak-steam()
{
  cd "$POE2_STEAM_PATH" || exit 1
}

POE2_STANDALONE_PATH="$HOME/.var/app/org.winehq.Wine/data/wine/drive_c/Program Files (x86)/Grinding Gear Games/Path of Exile 2"
p-cd-poe2-flatpak-wine-standalone()
{
  cd "$POE2_STANDALONE_PATH" || exit 1
}

# Runs the launcher of poe2, which fetches the latest updates and allows to
# start the actual game.
p-run-poe2-flatpak-wine-standalone()
{
  flatpak run org.winehq.Wine "$POE2_STANDALONE_PATH/Client.exe"
}

p-run-wizard-of-legend-wine()
{
  flatpak run org.winehq.Wine '/home/adamtajti/.var/app/org.winehq.Wine/data/wine/drive_c/GOG Games/Wizard of Legend/WizardOfLegend.exe'
}

p-wine-winecfg-reset()
{
  cp ~/Dropbox/Backups/wine-reset-default-winecfg.reg '/home/adamtajti/.var/app/org.winehq.Wine/data/wine/drive_c/'
  flatpak run org.winehq.Wine regedit 'C:\wine-reset-default-winecfg.reg'
  kill $(ps aux | grep '.exe$' | cut -d ' ' -f 2)
}

p-start-unreal-editor()
{
  "$HOME/Unreal/Engine/Binaries/Linux/UnrealEditor" &> /dev/null &
}

p-tor-qute()
{
  (torsocks qutebrowser --config ~/.config/qutebrowser/tor-config.py --target private-window --set "content.proxy" "socks://localhost:9050") &
}


p-py-venv()
{
  venv_name=${1:-venv}

  python -m venv "$venv_name"
  source "./$venv_name/bin/activate"
}

PATH_OF_EXILE_PATH="$HOME/.local/share/Steam/steamapps/common/Path of Exile"
PATH_OF_EXILE_LOG_CLIENT_TXT_PATH="$PATH_OF_EXILE_PATH/logs/Client.txt"

p-open-last-screenshot()
{
  xdg-open "$HOME/Pictures/Screenshots/$(lsd --timesort --icon=never ~/Pictures/Screenshots | head -n 1 | cut -d' ' -f 1)"
}

alias p-k8s-jq-get-container-images="jq -r '.spec.template.spec.containers[].image'"

p-k8s-get-deployment-container-versions-cmd()
{
  namespace=$1
  deployment_name=$2

  echo "kubectl -n $namespace get deployments/$deployment_name -o json | jq -r '.spec.template.spec.containers[].image'"
}

p-journalctl-clear-all-logs()
{
  sudo journalctl --rotate
  sudo journalctl --vacuum-time=1s
}

p-start-searxng()
{
  docker run --rm -d -p 23111:8080 -v "$HOME/Dropbox/SearXNG:/etc/searxng" -e "BASE_URL=http://localhost:23111/" -e "INSTANCE_NAME=home.searxng" searxng/searxng
}

PORTAGE_AUTOUNMASK_PATH="/etc/portage/package.accept_keywords/zz-autounmask"

# Emerges a package without doing any dispatch config madness
p-gentoo-emerge()
{
  if [ "$#" -ne 1 ]; then
    echo "usage: p-gentoo-emerge <package_name>" >&2
    echo "note: the package name can be specified without the category" >&2
    return 1
  fi

  package_name=$(eix "^$1\$" -#)

  if [ -z "$package_name" ]; then
    printf "error: failed to find a suitable package with the name of '%s'\n" "$package_name" >&2
    echo "alternatives:" >&2
    eix "$1" -# | sed 's/^/- /' >&2
    return 1
  fi

  if eix "$package_name" --brief2 --nocolor --versionlines | tail -n '+3' | head -n 1 | grep -q '^ \+~ \+'; then
    echo "only masked versions are available for $package_name..."
    echo "unmasking by appending to $PORTAGE_AUTOUNMASK_PATH..."
    sudo tee -a "$PORTAGE_AUTOUNMASK_PATH" > /dev/null <<EOF
# added through my personal.sh p-gentoo-emerge funcion
$package_name ~amd64
EOF
    echo "emerge --ask '$package_name':"
    sudo emerge --ask "$package_name"
  else
    echo "emerge --ask '$package_name':"
    sudo emerge --ask "$package_name"
  fi
}

p-system-clean()
{
  p-go-clean
  p-docker-clean
  p-nix-clean

	dir_to_clean="$HOME/.gradle/cache"
	if [ -d  "$dir_to_clean" ]; then
		rm -rf "$dir_to_clean"
	fi

	dir_to_clean="$HOME/.yarn/berry/cache"
	if [ -d  "$dir_to_clean" ]; then
		rm -rf "$dir_to_clean"
	fi

	cargo install --quiet cargo-cache && cargo cache --autoclean

	flatpak uninstall --unused

	sudo eclean packages
	sudo eclean distfiles

	sudo eclean-kernel --ask --num 1 --no-bootloader-update
}

p-system-backup()
{
  BACKUP_MOUNT="/mnt/backup"
  sudo tar cfz "$BACKUP_MOUNT/boot_backup.tar.gz" /boot
  sudo tar cfz "$BACKUP_MOUNT/efi_backup.tar.gz" /efi
  sudo xfsdump -l 0 -L root -M root -f /mnt/backup/root-backup /
}

p-linux-print-motherboard()
{
  dmesg | grep DMI
}

p-systemd-list-timers()
{
  systemctl status '*timer'
  systemctl --user status '*timer'
}

if [ -d "$HOME/.rbenv/bin" ]; then
  eval "$(~/.rbenv/bin/rbenv init - --no-rehash zsh)"
fi

# Faster reboot, sometimes I switch to Windows for gaming
p-reboot()
{
  sudo systemctl reboot --force --force
}

# $1: dbname, ex.: white-label
# $2: query, ex.: SELECT * FROM users
p-psql-json()
{
  psql -U postgres -c "WITH sq AS ($2) SELECT json_agg(row_to_json(sq)) from sq;" "$1" | head -n 3 | tail -n 1 | jq .
}

p-timestamp()
{
  if [ -z "$1" ]; then
    node --print 'Math.floor(new Date() / 1000)'
  else
    node --print "new Date($1 * 1000).toLocaleString()"
  fi
}

p-temp-project-node()
{
  DIR=$(mktemp -d)
  cd "$DIR" || return 1
  npm init -y
  echo "console.log('Hello, Node.js!');" > index.js
  nvim ./index.js
}

p-temp-project-cpp-meson()
{
  cd "$(mktemp -d)" || return 1
  meson init

  cat <<EOF > "build-and-run.sh"
#!/usr/bin/env bash

meson setup build
meson compile -C build
./build/tmp
EOF

  chmod u+x build-and-run.sh
  echo "build-and-run.sh:"
  ./build-and-run.sh
}

p-temp-project-cpp-cmake()
{
  cd "$(mktemp -d)" || return 1

  cat <<EOF > "tmp.cpp"
#include <iostream>

int main() {
  std::cout << "Hello tmp" << std::endl;
  return 0;
}
EOF

  cmake_version=$(cmake --version | head -n 1 | cut -d ' ' -f 3)
  cat <<EOF > "CMakeLists.txt"
cmake_minimum_required(VERSION $cmake_version)
project(tmp)
add_executable(tmp tmp.cpp)
EOF

  cat <<EOF > "build-and-run.sh"
#!/usr/bin/env bash

cmake -B build
cmake --build build
./build/tmp
EOF

  chmod u+x build-and-run.sh
  echo "build-and-run.sh:"
  ./build-and-run.sh
}

p-toggle-mpd-mute()
{
  pactl set-sink-input-mute "$(pactl list sink-inputs | perl -ne '/^Sink Input #(\d+)/ && { $sourceid=$1 }; /^\s+node.name = \"mpd.MPD PipeWire Output\"/ && print $sourceid;')" toggle
}

p-input-list-input-devices()
{
  libinput list-devices
}

p-ram-free-cache()
{
  # To free pagecache, dentries and inodes:
  sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
  # To free pagecache:
  # sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
  # To free dentries and inodes:
  # sudo sh -c 'echo 2 > /proc/sys/vm/drop_caches'
}

p-pkg-config-variables-for-package()
{
  while IFS= read -r var; do
    printf "%s=%s\n" "$var" "$(pkg-config --variable "$var" "$1")"

  done <<< "$(pkg-config --print-variables "$1")"
}

p-vcpkg-init()
{
  pwd="$PWD" # save the current dir as this command will temporarily navigate away

  if ! command -v vcpkg >/dev/null; then
    echo "error: vcpkg is not installed, returning early" >&2
    return 1
  fi

  if [ -f "vcpkg-configuration.json" ]; then
    echo "error: vcpkg-configuration.json found. consider using p-vcpkg-update-registries() instead" >&2
    return 1
  fi

  if [ -f "vcpkg.json" ]; then
    echo "error: vcpkg.json found. consider using p-vcpkg-update-registries() instead" >&2
    return 1
  fi

  local head
  head=$(p-git-remote-head-sha 'git@github.com:microsoft/vcpkg.git')

  cd "$pwd" || return 1

  cat <<EOF > "vcpkg-configuration.json"
{
  "default-registry": null,
  "registries": [
    {
      "kind": "git",
      "baseline": "$head",
      "repository": "https://github.com/microsoft/vcpkg",
      "packages": ["*"]
    }
  ]
}
EOF

  echo "{}" > "vcpkg.json"
}

p-vcpkg-update-registries()
{
  local vcpkg_configuration
  vcpkg_configuration="vcpkg-configuration.json"

  if ! [ -f "$vcpkg_configuration" ]; then
    echo "error: $vcpkg_configuration not found" >&2
    return 1
  fi

  local tmpfile
  local head
  while IFS= read -r configured_repo; do
    echo "updating $configured_repo in $vcpkg_configuration..."
    head=$(p-git-remote-head-sha "$configured_repo")
    tmpfile=$(mktemp)

    yq "(.registries[] | select(.repository = \"$configured_repo\")).baseline = \"$head\"" "$vcpkg_configuration" > "$tmpfile"
    mv "$tmpfile" "$vcpkg_configuration"
  done <<< "$(jq -r '.registries[].repository' "$vcpkg_configuration")"
}

p-vcpkg-remove-all-installations()
{
  list="$(vcpkg list)"
  if [ -n "$list" ]; then
    return 0
  fi

  # shellcheck disable=SC2046
  vcpkg remove $(vcpkg list | cut -d $' ' -f 1)
}

p-vcpkg-set-debug-and-verbose()
{
  export VERBOSE=1
  export VCPKG_TRACE_FIND_PACKAGE=ON
}

alias p-html-to-pdf-weasyprint="weasyprint"

p-git-find-commits-and-files-which-included-changes-that-referenced-a-substring()
{
   git --no-pager log --format=format:%H -G "$1" | xargs -n1 git --no-pager grep -l "$1"

   # this counts the references of the matches, so it may not be accurate
   # git --no-pager log --format 'format:%H' --pickaxe-regex -S "$1" | xargs -n1 git --no-pager grep -l "$1"
}

p-git-rebase-ours-which-means-the-other-branch() {
  git checkout --ours "$@"
  git add "$@"
}

p-git-rebase-ours-which-means-the-other-branch-all-modified() {
  while IFS= read -r conflicted_file_path; do
    git checkout --ours "$conflicted_file_path"
    git add "$conflicted_file_path"
  done <<< "$(git status --porcelain | grep '^UU ' | sed 's/^UU //')"
}

p-enter-developer-vcpkg-shell()
{
  export VCPKG_ROOT="$HOME/GitHub/adamtajti/vcpkg"
  export PATH="$VCPKG_ROOT:$PATH"
}

p-diff-two-files-between-magic-blocks()
{
  # todo: input the magic block
  diff <(awk '/# magic_block\(qqq\)/,/# magic_block_end/' <"$1") <(awk '/# magic_block\(qqq\)/,/# magic_block_end/' <"$2")
}

p-git-gh-local-config-repo()
{
  git config --local user.email "adam.tajti@gmail.com"
  git config --local user.signingkey "B36435500BA192CB"
  git config --local commit.gpgsign 1
}
