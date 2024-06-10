
#!/bin/sh

# Check if NodeJS is already installed or not
if [ -x "$(command -v node)" ]; then
  echo 'dotfiles-node: node is already installed.' >&2
  exit 0
fi

# Install NodeJS
emerge net-libs/nodejs

