# Config Utils ⚙️

My linux tools config for general purposes.

Each config tool is a submodule and must be able to install itself.

## Motivation

- Gather all configuration files for general purpose _CLI_ tools in one place.
- Have a unique and modular installer

## Usage

```bash
git clone git@github.com:vncsmyrnk/confutils.git $HOME
cd $HOME/confutils
git submodule init
git submodule update

# run `install.sh` or `config.sh` depending on your needs
```

## Structure expected for each module

Modules must have an `install.sh` in the project root and have the functions `symolic_install` and `config`.

- `symoblic_install`: Install depencencies and create symbolic links to the configuration paths.
- `config`: Just create the symoblic links considering the dependencies are already installed

Example: `zsh-config` has a `.zshrc`. Inside that project, `symoblic_install` must install `zsh` and create a symbolic link of that file to `$HOME/.zshrc`.`config` must just create the symbolic links.

Example format:

```bash
#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sourcing=false

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --sourcing)
      sourcing=true
      shift
      ;;
    *)
      break
      ;;
  esac
done

before() {
  echo "example before"
}

config() {
  echo "example config"
}

symbolic_install() {
  before
  echo "example symbolic install"
}

install() {
  before
  echo "example main"
}

if [[ "$sourcing" = "false" ]]; then
  install
fi
```

The installer of this project will call for the `symbolic_install`. This function must be able to install dependencies and create the needed symbolic links for configuration files.
