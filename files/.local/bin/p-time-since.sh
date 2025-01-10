#!/usb/bin/env bash

# $1: 2025-01-04 10:00:00

# Get the current timestamp
current_time=$(date +%s)

# Get the timestamp for event
ten_am_today=$(date -d "$1" +%s)

# Calculate the elapsed time in seconds
elapsed_seconds=$((current_time - ten_am_today))

# Convert elapsed seconds to days, hours, minutes, and seconds
days=$((elapsed_seconds / 86400))
hours=$(((elapsed_seconds % 86400) / 3600))
minutes=$(((elapsed_seconds % 3600) / 60))
seconds=$((elapsed_seconds % 60))

# Display the result
echo "${days}d ${hours}h ${minutes}m ${seconds}s"
