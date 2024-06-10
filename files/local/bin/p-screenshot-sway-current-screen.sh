#!/usr/bin/env bash

# Takes a screenshot of the screen, save it to ~/Pictures/Screenshots and copy it to your clipboard.

IMG="$HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%m-%s).png" && \
  grim -o "$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')" "$IMG" && \
  wl-copy < "$IMG"

