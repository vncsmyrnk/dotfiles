# .dotfiles ⚙️

My linux tools config for general purposes.

## Motivation

- Gather all configuration files for general purpose _CLI_ tools in one place.
- Have a unique and modular installer

## Structure expected

Each config tool is a submodule and must be able to install itself.

Each module must have a `justfile` with the following recipes:

- `install`: Installs dependencies and run configuration commands (usually with `stow`)
- `config`: Runs the config commands only
- `unset-config`: Unsets the config (usually with `stow -D`)

A module can be its own repo or commited directly into this repo on the _extra_ folder.

## Install

```bash
git clone git@github.com:vncsmyrnk/dotfiles.git $HOME/dotfiles
cd $HOME/dotfiles
./before-install.sh         # checks base dependencies
just install {config-name}  # actually installs and configs modules
```

> [!WARNING]
> - When updating with breaking changes make sure to _unset_ the updated config and then _config_ it again.
> - It is recommended to config each module individually. `shell-utils` should be configured first, then `zsh-config` and then the rest.
