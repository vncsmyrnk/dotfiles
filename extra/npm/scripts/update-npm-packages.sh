#!/usr/bin/env bash

NPM_GLOBALS_PATH="$HOME/.local/share/npm-globals"

if [ ! -d "$NPM_GLOBALS_PATH" ]; then
  echo "Not using npm custom global packages. No check needed."
  exit 0
fi

cd $NPM_GLOBALS_PATH
npm update --save
