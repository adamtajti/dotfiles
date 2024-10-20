#!/usr/bin/env bash

set -e

killall yambar || echo "no yambar processes were killed"

monitors=$(wlr-randr | grep "^[^ ]" | awk '{ print$1 }')

# TODO: Template different bars based on the their configured workspaces
# visible_workspace_on_output=$(swaymsg -t get_workspaces| jq ".[] | select(.visible == true and .output == \"$1\") | .name")

for monitor in ${monitors}; do
  swaymsg focus output "${monitor}"
  yambar &
  sleep 0.2
done

exit 0
