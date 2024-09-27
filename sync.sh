#!/usr/bin/env bash

# This script shall setup all the necessary symbolic links on a system

set -e
shopt -s dotglob

# Navigate to the script directory
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd "$SCRIPT_DIR"

# Bootstrap
./scripts/bootstrappers/bootstrap.sh

# Run the sync scripts
./scripts/syncs/base.sh
./scripts/syncs/tulip.sh
