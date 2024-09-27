# This file is designed to be sourced from a shell
# These functionalities are strictly Darwin / MacOS oriented

# -------------------------------------------------------------------------------------------------
# Finder
# -------------------------------------------------------------------------------------------------
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# -------------------------------------------------------------------------------------------------
# Homebrew
# -------------------------------------------------------------------------------------------------
alias brewu='brew update && brew upgrade && brew cleanup && brew doctor'

echo "loading shell/darwin.sh"
# env
if [ "$IN_HORI_NIX_SHELL" != "yes" ]; then
  echo "Loading Homebrew shellenv"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Not loading Homebrew shellenv"
fi

# Disable homebrew auto update
export HOMEBREW_NO_AUTO_UPDATE=1

# xcode setup for Aembryo
export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)

# -------------------------------------------------------------------------------------------------
# Python
# -------------------------------------------------------------------------------------------------
export PATH="$HOME/Library/Python/3.9/bin:$PATH"

