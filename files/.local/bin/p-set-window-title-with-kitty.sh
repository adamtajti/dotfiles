#!/usr/bin/env zsh
# Requires vim to be installed to modify Kittys output to be JQ compatible
# Requires jq to be installed to parse the JSON output from Kitty

KITTEN_SCRIPT_TEMP_FILE=$(mktemp)
script -q -c "kitty +kitten ask" "$KITTEN_SCRIPT_TEMP_FILE"
vim "$KITTEN_SCRIPT_TEMP_FILE" -c "normal 2dd0dt{jdG" -c "%s/'/\"/g" -c "wq"
ACTUAL_NAME=$(cat "$KITTEN_SCRIPT_TEMP_FILE" | jq -r .response) 
echo -e "\033]$ACTUAL_NAME\007"
