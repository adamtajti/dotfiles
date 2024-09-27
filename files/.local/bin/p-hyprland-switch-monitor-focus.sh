#!/usr/bin/env bash

# Switches the focus to the other monitor. 

monitorID=$(hyprctl activeworkspace -j | jq -r '.monitorID')
numMonitors=$(hyprctl monitors -j | jq '. | length')
monitorToFocus=$(((monitorID + 1) % numMonitors))

hyprctl dispatch focusmonitor "$monitorToFocus"
