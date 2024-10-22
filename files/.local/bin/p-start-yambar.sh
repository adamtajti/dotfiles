#!/usr/bin/env bash

set -e

killall yambar || echo "no yambar processes were killed"

monitors=$(wlr-randr | grep "^[^ ]" | awk '{ print$1 }')

for monitor in ${monitors}; do
  swaymsg focus output "${monitor}"

  if [ "$monitor" = "DP-2" ]; then
    W1=1 W2=2 W3=3 W4=4 W5=5 yambar -d error &
  elif [ "$monitor" = "DP-3" ]; then
    W1=11 W2=12 W3=13 W4=14 W5=15 yambar -d error &
  elif [ "$monitor" = "HDMI-A-1" ]; then
    W1=6 W2=7 W3=8 W4=9 W5=10 yambar -d error &
  else
    echo "Unknown monitor: $monitor. Skipping"
  fi

  sleep 0.2
done

exit 0
