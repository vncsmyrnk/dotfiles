# Config Utils ⚙️

My linux tools config for general purposes.

Each config tool is a submodule and must be able to install itself.

## Motivation

- Gather all configuration files for general purpose _CLI_ tools in one place.
- Have a unique and modular installer

## Strcuture expected

Each module must have a `justfile` with the following recipes:

- `install`: Install dependencies and run configuration commands (usually with `stow`)
- `config`: Run the config commands only
- `delete-config`: Undo the config (usually with `stow -D`)

## Usage

```bash
git clone git@github.com:vncsmyrnk/dotfiles.git $HOME
cd $HOME/dotfiles
git submodule init
git submodule update
just install # or `just config`
```
