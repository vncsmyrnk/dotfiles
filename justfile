default:
  just --list

config:
  #!/bin/bash
  for config in $(git config --file .gitmodules --get-regexp path | awk '{ print $2 }'); do
    cd {{source_directory()}}/$config && just config
  done

config-this name:
  cd {{source_directory()}}/{{name}} && just config

install:
  #!/bin/bash
  for file in $(git config --file .gitmodules --get-regexp path | awk '{ print $2 }'); do
    cd {{source_directory()}}/$file && just install
  done

install-this name:
  cd {{source_directory()}}/{{name}} && just install

delete-config:
  #!/bin/bash
  for file in $(git config --file .gitmodules --get-regexp path | awk '{ print $2 }'); do
    cd {{source_directory()}}/$file && just delete-config
  done

delete-config-this name:
  cd {{source_directory()}}/{{name}} && just delete-config
