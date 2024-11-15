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

env:
  @curl -L "https://drive.google.com/uc?export=download&id=10CiS_hWr3nZBs3ca9cVwtKJw7AAt7OXL" -o ~/.env.enc
  @openssl enc -aes-256-cbc -d -in ~/.env.enc -out ~/.env -pbkdf2 || rm ~/.env ;\
  rm ~/.env.enc
