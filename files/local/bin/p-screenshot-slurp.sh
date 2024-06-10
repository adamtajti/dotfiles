#!/usr/bin/env bash

# Takes a screenshot of an area, save it to ~/Pictures/Screenshots and copy it to your clipboard.

IMG="$HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%m-%s).png" && \
  grim -g "$(slurp -s '#4d5d8da0' -b '#00000000' -c '4d5d8daf')" "$IMG" && \
  wl-copy < "$IMG"
