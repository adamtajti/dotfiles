# This file is designed to be sourced from a shell. These functionalities are 
# personal, they that may be used for my personal work or at any given company

# less is the default pager. I had issues with it once.
# PAGER="nvim"

# If you come from bash you might have to change your $PATH.
export PATH="$HOME/.local/bin:$PATH"

# This was required to setup Nim, which is used to the minorg project.
export PATH=$HOME/.nimble/bin:$PATH

# tfswitch ... thanks for another non-standard path to pollute my home directory you fuckers
export PATH=$PATH:/home/adamtajti/bin

# Set default browser, used by sway for example
export BROWSER="firefox-bin"
#export BROWSER="qutebrowser" # I'm cruising with qutebrowser for now, it seems to work well enough
# export BROWSER="firefox"

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

# -----------------------------------------------------------------------------
# UX / TTS
# -----------------------------------------------------------------------------

tts() {
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

# VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
# VI_MODE_SET_CURSOR=true
# MODE_INDICATOR="%F{white}+%f"
# INSERT_MODE_INDICATOR="%F{yellow}+%f"

# Sets the title of the terminal to executed man page
man() {
  echo -en "\033]0;man $*\a"
  /bin/man "$@"
  echo -en "\033]0;foot\a"
}

shellconf() {
  # shellcheck disable=SC1091
  local title="/home/adamtajti/GitHub/dotfiles/files/config/shell" 
  p-set-title $title && vim $title && exec zsh
}

alias l="lsd --long"
alias lt="lsd --long --tree"
alias v="nvim"
alias ga="git add"

# SECTION: Starship

export STARSHIP_CONFIG="$HOME/.config/starship.toml"

# SECTION: Gaming

# Nukes down all the Path of Exile related stuff
p-steam-close-poe() {
  killall steam
  killall reaper
  killall  pv-bwrap
  killall wine
  killall winserver
  killall gamescope
  killall -9 'winedevice.exe'
}

# SECTION: Sway

p-screenshot-area() {
  slurp | grim -g - - | wl-copy  
}

p-screenshot-monitor() {
  grim -o "$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')"
}

p-record-screen() {
  wf-recorder -g "$(slurp)" -f ~/recording.mp4
}

p-focused-window-pid() {
  swaymsg -t get_tree -r | jq '.. | (.nodes? // empty)[] | select(.focused) | .pid'
}

p-get-poe-pid() {
  swaymsg -t get_tree -r | jq '.. | (.nodes? // empty)[] | select(.nodes[].name == "Path of Exile")'
}

# SECTION: Terminal Emulators

# Set the title / name of the current window...
p-set-title() {
  echo -e "\033]$1\007"
}

case "$TERM" in
  foot*|xterm*|rxvt*)
    function p-set-title () {
      # OSC 0: https://github.com/DanteAlighierin/foot?tab=readme-ov-file#supported-oscs 
      builtin print -n -- "\e]0;$@\a"
    }
    ;;
  screen)
    function xtitle () {
      builtin print -n -- "\ek$@\e\\"
    }
    ;;
  kitty)
    function p-set-title () {
      echo -e "\033]$1\007"
    }
    ;;
  *)
    function p-set-title () {
      return
    }
esac

# With ZSH set the title automatically
function precmd () {
  # OSC 133: https://github.com/DanteAlighierin/foot?tab=readme-ov-file#supported-oscs 
  print -Pn "\e]133;A\e\\" # for foot, jumping between prompts
  p-set-title "$(print -P zsh '(%~)')"
}

function preexec () {
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

p-repeat-last-command-until-failure() {
  while true
  do
    eval "$(history -p !!)" || exit
  done
}

# Watch commands
watch-date() {
  watch -n 0.1 -c 'date'
}

mkdirdate() {
  mkdir "$@" "$(date +"%Y-%m-%d")"
}

alias gsed="sed"

# -----------------------------------------------------------------------------
# Go
# -----------------------------------------------------------------------------

# Lists a detailed dependency list for the current project.
p-go-dependencies() {
  go list -deps -f '{{define "M"}}{{.Path}}@{{.Version}}{{end}}{{with .Module}}{{if not .Main}}{{if .Replace}}{{template "M" .Replace}}{{else}}{{template "M" .}}{{end}}{{end}}{{end}}' | sort -u
}

# -----------------------------------------------------------------------------
# Docker
# -----------------------------------------------------------------------------

# Stop all the docker containers and remove the images
p-docker-clear() {
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

p-docker-stop-all() {
  docker ps | tail -n +2 | cut -d' ' -f 1 | xargs -P "$(nproc)" -I {} docker stop {} 
}

p-docker-compose-healthcheck-why() {
  if [ "$#" -ne 1 ]; then
    echo "usage: p-docker-compose-healthcheck-why <container_name>"
    return 1
  fi

  docker inspect --format "{{json .State.Health }}" "$1" | jq
}

# -----------------------------------------------------------------------------
# Space Savings
# -----------------------------------------------------------------------------

p-save-space() {
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

p-check-port-usage() {
  sudo lsof -i "4tcp:$1" -sTCP:LISTEN
}

p-list-port-usages() {
  sudo lsof -i -P -n | grep LISTEN
}

# -----------------------------------------------------------------------------
# Kubernetes
# -----------------------------------------------------------------------------

p-k8s-get-all-from-namespace() {
  kubectl api-resources --verbs=list --namespaced -o name \
    | xargs -n 1 kubectl get --show-kind --ignore-not-found -n "$1"
}

# -----------------------------------------------------------------------------
# Git
# -----------------------------------------------------------------------------

export GITHUB_PATH="$HOME/GitHub"

# Git Commands
gs() {
  git status
}

function lazygit() {
  git commit -a -m "$1"
  git push -u origin HEAD
}

# Git WIP - Quickly commits all the changes to remote, could be useful in workflow development
gw() {
  lazygit "wip"
}

# Util function to convert bytes to human readable format
p-to-human-readable() {
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

p-git-local-ignore-file() {
  local file="$1"
  local git_root="$(git rev-parse --show-toplevel)"
  if [ -z "$file" ]; then
      echo "Usage: ignore_file_locally <file>"
      return 1
  fi

  echo "$file" >> "$git_root/.git/info/exclude"
  echo "Added $file to local exclude list"
}

p-git-commit-count-between-two-brances() {
  local from="$1"
  local to="$2"

  # It is important to check the origin as the local branches may be out of date
  git rev-list --count --first-parent "origin/$from..origin/$to"
}

p-git-worktree-checkout() {
  if [ "$#" -ne 1 ]; then
    echo "usage: p-git-worktree-checkout <branch>"
    echo "example: p-git-worktree-checkout branch-name"
    return 1
  fi

  branch_name=$1
  remote_url=$(git config --get remote.origin.url)
  repo_name=$(basename -s .git "$remote_url")

  repo_path=$(p-git-root-path)
  git worktree add --checkout "${repo_path}/../${repo_name}.${branch_name}" "$branch_name"
  cd "${repo_path}/../${repo_name}.${branch_name}"
}

p-git-worktree-new() {
  if [ "$#" -ne 1 ]; then
    echo "usage: p-git-worktree-new <branch>"
    echo "example: p-git-worktree-new adam.branch-name"
    return 1
  fi

  branch_name=$1
  remote_url=$(git config --get remote.origin.url)
  repo_name=$(basename -s .git "$remote_url")

  repo_path=$(p-git-root-path)
  git worktree add -b "$branch_name" "${repo_path}/../${repo_name}.${branch_name}"
  cd "${repo_path}/../${repo_name}.${branch_name}" 
}

p-git-show-large-loc-commits() {
  git --no-pager log --since="6 months ago" --stat --pretty='format:%n %s (%an)' --stat-count=-1 | grep --before-context=3 --no-group-separator -E '[0-9]{4} insertions' | grep -v -E "^ \.\.\."
}

p-git-glob-branches-since() {
  if [ "$#" -ne 2 ]; then
    echo "usage: p-git-glob-branches-since <glob> <since>"
    echo "example: p-git-glob-branches-since '**/go.mod' '1 month ago'"
    return 1
  fi

  glob=$1
  since=$2

  git log --all --source --since "$since" -- "$glob" | grep -o "refs/.*" | sort -u
}

p-git-glob-branches-since-until() {
  if [ "$#" -ne 3 ]; then
    echo "usage: p-git-glob-branches-since-until <glob> <since> <until>"
    echo "example: p-git-glob-branches-since-until '**/go.mod' '1 month ago' '2 weeks ago'"
    return 1
  fi

  glob=$1
  since=$2

  git log --all --source --since "$since" -- "$glob" | grep -o "refs/.*" | sort -u
}

p-git-glob-branch-history() {

  if [ "$#" -ne 1 ]; then
    echo "usage: p-git-glob-branch-history <glob>"
    echo "example: p-git-glob-branch-history '**/go.mod'"
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

p-git-largest-files() {
  while read -r largefile; do
    # Blob SHA
    echo "$largefile" | awk '{printf "%s ", $1}'

    # Human readable size output
    echo "$largefile" | awk '{printf "%s", $3}' | p-to-human-readable

    # Path to file / folder of the blob
    echo "$largefile" | awk '{system("git rev-list --all --objects | grep " $1 " | cut -d \" \" -f 2-")}'
  done <<< "$(git rev-list --all --objects | awk '{print $1}' | git cat-file --batch-check | sort -k3nr | head -n 500)"
}

p-git-largest-files-summarized() {
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



p-git-diff() {
  git diff --cached | bat --paging=never
}

# -----------------------------------------------------------------------------
# Nix
# -----------------------------------------------------------------------------

export NIX_STORE_PATH="/nix/store"

# -----------------------------------------------------------------------------
# Zygote
# -----------------------------------------------------------------------------

export ZYGOTE_PATH="$GITHUB_PATH/Zygote"

_p-zygote-build() {
  cd "$ZYGOTE_PATH" && 
    cmake \
      -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
      -S ./ \
      -B ./build "${@[@]}" && 
    cd ./build && 
    make && 
    sudo make install
}

p-zygote-build-and-observe() {
  _p-zygote-build "${@[@]}" && 
    l --tree "$AEMBRYO_PATH/build/"
}

p-zygote-build() {
  _p-zygote-build "$@";
}

# -----------------------------------------------------------------------------
# Aembryo
# -----------------------------------------------------------------------------

export AEMBRYO_PATH="$GITHUB_PATH/Aembryo"
_p-aembryo-build() {
  cd "$AEMBRYO_PATH" && 
    cmake \
      -DZygote_DIR="/usr/local/lib64/cmake/Zygote/" \
      -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
      -S ./ \
      -B ./build "${@[@]}" && 
    cd ./build && 
    make
}

p-aembryo-build-release() {
  declare -a additional_args=()
  additional_args+=("-DCMAKE_BUILD_TYPE=Release")
  _p-aembryo-build "${additional_args[@]}"
}

p-aembryo-build-minsize() { 
  declare -a additional_args=()
  additional_args+=("-DCMAKE_BUILD_TYPE=MinSizeRel")
  _p-aembryo-build "${additional_args[@]}"
}

p-aembryo-build-and-run-fresh() {
  declare -a additional_args=()
  additional_args+=("--fresh")
  _p-aembryo-build "${additional_args[@]}" && 
    "$AEMBRYO_PATH/build/Aembryo"
}

p-aembryo-build-and-run() {
  _p-aembryo-build && 
    "$AEMBRYO_PATH/build/Aembryo"
}

p-aembryo-code() {
  cd "$AEMBRYO_PATH" && 
    vim .
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
export DOTFILES_VIM_PLUGINS_PATH="$DOTFILES_CONFIG_NVIM_PATH/lua/plugins"
export DOTFILES_SNIPPETS_PATH="$DOTFILES_PATH/files/snippets/vscode/snippets"

p-dotfiles-push() {
  echo "lol"
}

# To quickly edit dotfiles
p-dotfiles-vim() {
  p-set-title 'p-dotfiles-vim' && (cd "$DOTFILES_PATH" && vim "$DOTFILES_PATH")
}

p-dotfiles-vim-neovim-plugins() {
  p-set-title 'p-dotfiles-vim-neovim-plugins' && (cd "$DOTFILES_PATH" && vim "$DOTFILES_PATH/files/config/nvim/lua/plugins/lazy/")
}

# To fetch the latest and build a new nvim release
p-dotfiles-update-vim(){
  eval "$DOTFILES_PATH/scripts/installers/build-and-install-or-update-neovim.sh"
}

# System Maintanence
p-dotfiles-system-update(){
  (cd "$DOTFILES_PATH/scripts/installers" && ./_update-system.sh)
}

# Update the links
p-dotfiles-update-links(){
  (cd "$DOTFILES_PATH" && ./scripts/setup.sh)
}

# -----------------------------------------------------------------------------
# NeoVIM
# -----------------------------------------------------------------------------

# Sets the default editor to nvim
EDITOR="nvim"

# Make sure that the custom neovim installation is detected
export PATH="$HOME/neovim/bin:$PATH"

# Use nvim by default and start neovim as a server
# Once this is configured the nvr (neovim-remote client) will be able to open new files in the same
# neovim instance
export NEOVIM_REMOTE_RPC_API_ENDPOINT="/tmp/3069faa81c0b87b3acab8add3d4e600d66da8e76"

vim() {
  nvim "$@"
}

#alias vim="nvim --listen $NEOVIM_REMOTE_RPC_API_ENDPOINT"
#alias nvr="nvr --servername $NEOVIM_REMOTE_RPC_API_ENDPOINT"

# This is where the lazy.nvim package manager installs the packages
# This can be aquired from inside neovim: `lua print(vim.fn.stdpath('data'))`
export NVIM_DATA_PATH="$HOME/.local/share/nvim"
export NVIM_LAZY_PATH="$NVIM_DATA_PATH/lazy"

#alias ssh="/usr/local/bin/tsh ssh"
ssh() {
  kitty +kitten ssh "$@"
}

# This completely clears the scrollback buffer so it can be easier to open it up with cmd+z in nvim
kittyclear() {
  printf '\033[2J\033[3J\033[1;1H'
}

cls() {
  kittyclear
}

clear() { 
  kittyclear
}

# Fuzzy searching can get quite complex. Lets make an alias for it
search() {
  fd --type f | fzf
}

if [[ $OSTYPE == 'darwin'* ]]; then
  export DROPBOX_PATH="$HOME/Library/CloudStorage/Dropbox"
else
  export DROPBOX_PATH="$HOME/Dropbox"
fi

# A shortcut for opening neomutt with my Personal profile
p-mutt() {
  GPG_TTY=$(tty)
  export GPG_TTY
  ~/GitHub/neomutt/contrib/oauth2/mutt_oauth2.py ~/GitHub/neomutt/contrib/oauth2/adam.tajti.personal.tokens &> /dev/null
  neomutt -F ~/.neomutt/profile.personal
}


# Notebook support
export NOTEBOOK_PATH="$DROPBOX_PATH/Notebook"
notebook() {
  p-set-title 'notebook' && (cd "$NOTEBOOK_PATH" && vim "$NOTEBOOK_PATH")
}
journal() {
  p-set-title 'journal' && (cd "$NOTEBOOK_PATH" && vim "$NOTEBOOK_PATH")
}


# Makes git auto completion faster favouring for local completions
# Source: https://github.com/skwp/dotfiles/blob/master/zsh/git.zsh
__git_files () {
    _wanted files expl 'local files' _files
}

# Crazy Globals; alias -g is only supported by ZSH
if [ -z "$BASH_VERSINFO" ]; then
  alias -g C='wc -l'
  alias -g H='head'
  alias -g T='tail'
  alias -g L="less --use-color"
  alias -g N="/dev/null"
  alias -g S='sort'
  alias -g G='grep'
  alias -g J='jq'
fi


alias dmesg='dmesg --color=always'
alias D='dmesg --color=always'

# Change the working directory to GitHub
cdgh() {
  cd "$HOME/GitHub" || exit
}

# Clone the repo and cd into it
ghc() {
  cdgh && take "$1"
}

cdd() {
  cd "$DOTFILES_PATH" || exit
}

p-git-root-path() {
  git rev-parse --show-toplevel
}

p-cdr() {
  cd "$(p-git-root-path)" || exit
}

p-git-local-exclude() {
  GIT_ROOT_DIR=`git rev-parse --show-toplevel`
  # TODO: Get the path to the file that is referenced.
  # Add the relative path from the git root to the file into .git/info/exclude
}

# -----------------------------------------------------------------------------
# Terraform
# -----------------------------------------------------------------------------

# tfenv setup for different terraform versions
export PATH="$HOME/.tfenv/bin:$PATH"
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
#export LESS="-R -x2"

p-hex-to-rgb() {
  if [ "$#" -ne 1 ]; then
    echo "usage: p-hex-to-rgb <hex>"
    echo "example: p-hex-to-rgb 080808"
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
p-gentoo-start-sway() {
  XDG_CURRENT_DESKTOP=sway dbus-run-session sway
}

p-gentoo-update() {
  sudo emerge --sync &&
    sudo emerge --ask --verbose --update --deep --newuse --with-bdeps=y @world
}

p-install-1password-desktop-amd64() {
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

p-install-1password-cli-amd64() {
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

p-install-tsh-amd64() {
  (
    cd "$(mktemp -d)" || return 1
    curl "https://get.gravitational.com/teleport-v6.2.28-linux-amd64-bin.tar.gz" | tar xz \
      && cd teleport/ \
      && sudo ./install
  )
}

p-install-pnpm-amd64() {
  curl -fsSL https://get.pnpm.io/install.sh | sh -
}

p-install-aws-cli-amd64() {
  (
    cd "$(mktemp -d)" || return 1
    curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
      && unzip awscli-bundle.zip \
      && sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
  )
}


p-git-setup-fork-maintainer-gha() {
  if [ "$#" -ne 2 ]; then
    echo "usage: p-git-setup-fork-maintainer-gha '<your_fork>' '<original_repo>'"
    echo "example: p-git-setup-fork-maintainer-gha 'adamtajti/lualine.nvim' 'nvim-lualine/lualine.nvim'"
    return 1
  fi

  your_fork=$1
  original_repo=$2

  tmp_work_dir=$(mktemp -d)

  cd "$tmp_work_dir" || return 1
  git clone "git@github.com:${your_fork}.git" "fork" > /dev/null || return 2
  cd "fork" || echo "Failed to change to the fork directory" || return 3

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
        branch:   ${branch}
EOF

  git add "$workflow_file"
  git commit -m "Add rebase workflow to sync with ${original_repo}"
  git push -u origin HEAD
}

p-start-path-of-building() {
  wine-vanilla-9.0 "$HOME/.wine/drive_c/users/adamtajti/AppData/Roaming/Path of Building Community/Path of Building.exe" &> /dev/null &
}

p-start-unreal-editor() {
  "$HOME/Unreal/Engine/Binaries/Linux/UnrealEditor" &> /dev/null &
}

p-tor-qute() {
  (torsocks qutebrowser --config ~/.config/qutebrowser/tor-config.py --target private-window --set "content.proxy" "socks://localhost:9050") &
}


p-py-venv() {
  venv_name=${1:-lol}

  python -m venv "$venv_name"
  source "./$venv_name/bin/activate"
}

PATH_OF_EXILE_PATH="$HOME/.local/share/Steam/steamapps/common/Path of Exile"
PATH_OF_EXILE_LOG_CLIENT_TXT_PATH="$PATH_OF_EXILE_PATH/logs/Client.txt"

p-open-last-screenshot() {
  xdg-open "$HOME/Pictures/Screenshots/$(lsd --timesort --icon=never ~/Pictures/Screenshots | head -n 1 | cut -d' ' -f 1)"
}

alias p-k8s-jq-get-container-images="jq -r '.spec.template.spec.containers[].image'"

p-k8s-get-deployment-container-versions-cmd() {
  namespace=$1
  deployment_name=$2

  echo "kubectl -n $namespace get deployments/$deployment_name -o json | jq -r '.spec.template.spec.containers[].image'"
}

p-journalctl-clear-all-logs() {
  sudo journalctl --rotate
  sudo journalctl --vacuum-time=1s
}
