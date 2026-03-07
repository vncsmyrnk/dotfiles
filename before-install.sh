#!/usr/bin/env bash

os=$(cat /etc/os-release | grep "^NAME=" | cut -d "=" -f2 | tr -d '"')

echo "downloading modules..."
git submodule init
git submodule update

echo "Checking base deps..."
command -v git >/dev/null && command -v just >/dev/null &&
  command -v nix >/dev/null && {
  echo "deps OK."
  exit 0
}

echo "installing deps..."
if [ "$os" = "Arch Linux" ]; then
  sudo pacman -S git just nix
fi

echo "deps installed."
