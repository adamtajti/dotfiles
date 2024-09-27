# This file is meant to be sourced as a utility script

# Sets up a symbolic link from the target to the local dotfile
# The paths must be absolute.
# Usage: _dotfiles_ln DOTFILE TARGET
_dotfiles_ln() {
  if [ $# -ne 2 ]; then
    echo "usage: _dotfiles_ln DOTFILE TARGET" 2>&1
    return 1
  fi

  local dotfile=$1
  local target=$2

  # The target was already a symbolic link. Change it to the new location as needed
  if [ -L "$target" ]; then
    points_to=$(readlink --canonicalize "$target")

    if [ "$points_to" = "$dotfile" ]; then
      return 0
    fi

    rm --interactive=never "$target"
  fi

  if [ -d "$target" ]; then
    echo "TARGET='$target' is a directory."
    echo "You're going to be prompted to delete this folder..."
    rm --recursive --interactive=once "$target"
  fi

  if [ -f "$target" ]; then
    echo "TARGET='$target' is a file."
    echo "You're going to be prompted to delete this file..."
    rm --interactive=always "$target"
  fi

  local exit_code=0
  ln -s "$dotfile" "$target" || exit_code=$?

  local color_code=""
  if [ $exit_code -ne 0 ]; then
    color_code="\e[31m"
  else
    color_code="\e[32m"
  fi

  echo -e "- ${color_code}$target\e[0m -> ${color_code}$dotfile\e[0m"
}

# Sets up symbolic links from the target root to the local dotfile root
# The paths must be absolute.
# Usage: _dotfiles_ln_dir_contents DOTFILE_ROOT TARGET_ROOT
_dotfiles_ln_dir_contents() {
  if [ $# -ne 2 ]; then
    echo "usage: _dotfiles_ln_dir_contents DOTFILE_ROOT TARGET_ROOT" 2>&1
    return 1
  fi

  local dotfile_root=$1
  local target_root=$2

  if ! [ -e "$target_root" ]; then
    mkdir -p "$target_root"
  fi

  if ! [ -d "$dotfile_root" ]; then
    echo "error: $dotfile_root is not a folder" 2>&1
    return 1
  fi

  pushd "$dotfile_root" >/dev/null || return 1
  for current_path in *; do
    _dotfiles_ln "$dotfile_root/$current_path" "$target_root/$current_path"
  done
  popd >/dev/null || return 1
}

_sudo_fn() {
  (($#)) || {
    echo "Usage: sudo-function FUNC [ARGS...]" >&2
    return 1
  }
  sudo bash -c "$(declare -f "$1");$(printf ' %q' "$@")"
}
