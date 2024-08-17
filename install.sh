#!/bin/bash

configs=(tmux-config zsh-config vim-config)

for config in ${configs[@]}; do
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  source $SCRIPT_DIR/$config/install.sh --sourcing
  symbolic_install
done
