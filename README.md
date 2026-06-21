# .dotfiles ⚙️

My linux tools config for general purposes.

## Motivation

- Gather all configuration files for general purpose _CLI_ tools in one place.
- Have a unique and modular installer

## Structure expected

Each config tool is a submodule and must be able to install itself.

Each module should have a `justfile` or `Makefile` with build/installation recipes.

## Install

Config tools can be managed via `dotfiles` command, installable via `make install`.
