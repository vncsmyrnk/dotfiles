default:
  just --list

update-configs:
  git submodule init
  git submodule update --recursive --remote

config:
  #!/bin/bash
  for config in $(git config --file .gitmodules --get-regexp path | awk '{ print $2 }'); do
    cd {{source_directory()}}/$config && just config
  done

config-this name:
  cd {{source_directory()}}/{{name}} && just config

install: update-configs
  #!/bin/bash
  for config in $(git config --file .gitmodules --get-regexp path | awk '{ print $2 }'); do
    cd {{source_directory()}}/$config && just install
  done

install-this name:
  cd {{source_directory()}}/{{name}} && just install

unset-config:
  #!/bin/bash
  for config in $(git config --file .gitmodules --get-regexp path | awk '{ print $2 }'); do
    cd {{source_directory()}}/$config && just unset-config
  done

unset-config-this name:
  cd {{source_directory()}}/{{name}} && just unset-config
