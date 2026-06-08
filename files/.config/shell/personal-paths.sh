#!/usr/bin/env bash

# This file is designed to be sourced from a shell.
# These functionalities are personal, they that may be used freely on any work.

# This is the personal local bin folder.
export PATH="$HOME/.local/bin:$PATH"

# Add cargo to the path.
export PATH="$HOME/.cargo/bin:$PATH"

# Nimble is a Package manager for the Nim programming language.
# The user installed packages and their binaries are available over here.
export PATH=$HOME/.nimble/bin:$PATH

# ====
# PNPM
# ====
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# =====
# VCPKG
# =====
export PATH="$VCPKG_ROOT:$PATH"

# ==============
# Disabled Paths
# ==============

# klp (log viewer (jsonl))
# export PATH="$HOME/GitHub/dloss/klp/venv/bin:$PATH"
