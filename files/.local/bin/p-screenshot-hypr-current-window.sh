#!/usr/bin/env bash

# Takes a screenshot of the current window, save it to ~/Pictures/Screenshots and copy it to your clipboard.
# Taken from https://github.com/equk/dotfiles/blob/master/configs/bin/screenactive

IMG="$HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%m-%s).png" && \
  hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - "$IMG" && \
  wl-copy < "$IMG"

