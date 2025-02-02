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

## Usage

```bash
git clone git@github.com:vncsmyrnk/dotfiles.git $HOME/dotfiles
cd $HOME/dotfiles
./before-install.sh
just install
```

> [!WARNING]
> - For configs breaking changes make sure to _unset_ its config and then _config_ it again.
