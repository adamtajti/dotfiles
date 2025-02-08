#!/usr/bin/env bash
# Initializes file permissions in the local git repository checkout

git_root_path="$(dirname "$0")/../../"
if ! cd "$git_root_path"; then
  echo "fatal: failed to navigate to the git root directory" >&2
  exit 1
fi

chmod o-r ./files/.local/etc/tuh
