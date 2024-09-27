#!/usr/bin/env bash

# Get the name of the current output
current_output=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused).name')

# Path to the previous output file
pop="/tmp/sway-previous-output"

previous_output=$(touch $pop && cat $pop)
if [ -z "$previous_output" ]; then
  notify-send 'DEBUG' "Previous output was zero. Current output: $current_output. Writing it to $pop"
  echo "$current_output" > "$pop"
else
  if [[ $previous_output == $current_output ]]; then
    notify-send 'DEBUG' "Previous output was non-zero: $previous_output. It's the same as $current_output"
fi

# Get the list of all outputs
# outputs=( $(swaymsg -t get_outputs | jq -r '.[] | .name') )
# # notify-send 'DEBUG' "Outputs: ${outputs[*]}" # DP-2 DMI-A-1
#
# # Determine the next output
# next_output=${outputs[$next_index]}
#
# # Get the visible workspace on the next output
# visible_workspace_on_next_output=$(swaymsg -t get_workspaces| jq ".[] | select(.visible == true and .output == \"$next_output\") | .name")
#
# #notify-send 'DEBUG' "Current workspace on next output: $current_workspace_on_next_output" # HDMI-A-1
#
# swaymsg workspace "$visible_workspace_on_next_output"
#
