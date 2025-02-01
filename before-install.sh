#!/bin/bash

os=$(cat /etc/os-release | grep "^NAME=" | cut -d "=" -f2 | tr -d '"')
deps=(git just)

echo "Checking base deps..."
command -v $deps >/dev/null && {
  echo "deps OK."
  exit 0
}

echo "installing deps..."
if [ "$os" = "Debian GNU/Linux" ] || [ "$os" = "Ubuntu" ]; then
  command -v brew >/dev/null || {
    echo "brew needed. Please install brew before installing deps."
  }
  sudo apt-get install git
  brew install just
elif [ "$os" = "Arch Linux" ]; then
  sudo pacman -S git just
fi
echo "deps installed."
