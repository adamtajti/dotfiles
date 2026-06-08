#!/usr/bin/env bash

# This file is designed to be sourced from a shell.
# These functionalities are personal, they that may be used freely on any work.

# -----------------------------------------------------------------------------
# GENERIC
# -----------------------------------------------------------------------------

# An attempt to speed up nody-gyp builds
export JOBS=16

# Set default browser.
# export BROWSER="firefox"
# export BROWSER="firefox-bin"
export BROWSER="brave-browser-nightly"
# export BROWSER="google-chrome-stable"
# export BROWSER="qutebrowser"

# Set the default terminal.
export TERMINAL="footclient"
# export TERMINAL="kitty"
# export TERMINAL="ghostty +new-window"

# -----------------------------------------------------------------------------
# YARN
# -----------------------------------------------------------------------------

# The global cache setting has been playing along nicely so far.
export YARN_ENABLE_GLOBAL_CACHE=true

# YARN_COMPRESSION_LEVEL 0 should have been the default since Yarn 4.
# It doesn't affect the cache size that much and it's much faster.
# I can't enable it globally though, since it results in different lock files.
# The cache key becomes different as well. A change like this would need to be introduced
# in a separate branch and it would inevitably result in friction with other pull requests.
#export YARN_COMPRESSION_LEVEL=0

# -----------------------------------------------------------------------------
# PNPM
# -----------------------------------------------------------------------------
export PNPM_HOME="/home/adamtajti/.local/share/pnpm"

# -----------------------------------------------------------------------------
# WINE/PROTON
# -----------------------------------------------------------------------------
export WINEFSYNC=1
export WINE_LARGE_ADDRESS_AWARE=1
#WINEPREFIX=~/.wine /usr/bin/setup_dxvk.sh install --symlink
#WINEPREFIX=~/.wine /usr/bin/setup_vkd3d_proton.sh install --symlink

# -----------------------------------------------------------------------------
# VCPKG
# -----------------------------------------------------------------------------
export VCPKG_DISABLE_METRICS="YES"
export VCPKG_ROOT="$HOME/GitHub/microsoft/vcpkg"

# -----------------------------------------------------------------------------
# ZSH
# -----------------------------------------------------------------------------

# Push it to the limit
export HISTFILE=~/.zsh_history
export HISTSIZE=1000000000 # the number of items for the internal history list
export SAVEHIST=1000000000 # maximum number of items for the history file

# Cleaning the history up from the duplicates.
export HISTCONTROL=ignoredups

# The meaning of these options can be found in man page of `zshoptions`.
setopt HIST_IGNORE_ALL_DUPS  # do not put duplicated command into history list
setopt HIST_SAVE_NO_DUPS  # do not save duplicated command
setopt HIST_REDUCE_BLANKS  # remove unnecessary blanks
setopt INC_APPEND_HISTORY_TIME  # append command to history file immediately after execution
setopt EXTENDED_HISTORY  # record command start time

# Share the history between the shells
setopt SHARE_HISTORY

# Lol, you can't use `#` comments in command prompts without this
setopt interactivecomments

# VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
# VI_MODE_SET_CURSOR=true
# MODE_INDICATOR="%F{white}+%f"
# INSERT_MODE_INDICATOR="%F{yellow}+%f"

# -----------------------------------------------------------------------------
# Make
# -----------------------------------------------------------------------------

# I tend to use make more and more and sometimes I forget to set the -j option:
export MAKEFLAGS='-j 12'

# -----------------------------------------------------------------------------
# QT
# -----------------------------------------------------------------------------

# https://wiki.gentoo.org/wiki/GTK_themes_in_Qt_applications
QT_QPA_PLATFORMTHEME=qt5ct

# -----------------------------------------------------------------------------
# Git
# -----------------------------------------------------------------------------

export GITHUB_PATH="$HOME/GitHub"
