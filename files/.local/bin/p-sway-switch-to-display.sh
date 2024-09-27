#!/usr/bin/env bash

if [ -z "$1" ]; then
  notify-send 'ERROR' "No display was given to p-sway-switch-to-display.sh as \$1"
fi

visible_workspace_on_output=$(swaymsg -t get_workspaces| jq ".[] | select(.visible == true and .output == \"$1\") | .name")
swaymsg workspace "$visible_workspace_on_output"
