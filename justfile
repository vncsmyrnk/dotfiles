default:
  just --list

update-configs:
  git submodule init
  git submodule update --recursive --remote

[confirm('Are you sure? It is recommended to config each module individually (y/N)')]
config:
  #!/bin/bash
  for config in $(git config --file .gitmodules --get-regexp path | awk '{ print $2 }'); do
    cd {{source_directory()}}/$config && just config
  done

# Configures a module individually
config-this name:
  cd {{source_directory()}}/{{name}} && just config

install: update-configs
  #!/bin/bash
  for config in $(git config --file .gitmodules --get-regexp path | awk '{ print $2 }'); do
    cd {{source_directory()}}/$config && just install
  done

install-this name:
  cd {{source_directory()}}/{{name}} && just install

[confirm('Are you sure? It is recommended to unset each modules config individually (y/N)')]
unset-config:
  #!/bin/bash
  for config in $(git config --file .gitmodules --get-regexp path | awk '{ print $2 }'); do
    cd {{source_directory()}}/$config && just unset-config
  done

# Unsets a module's config individually
unset-config-this name:
  cd {{source_directory()}}/{{name}} && just unset-config

test-recipes:
  #!/bin/bash
  for config in $(find * -maxdepth 0 -type d -not -path './.git'); do
    justfile_path="$config/justfile"
    [ -f $justfile_path ] && {
      grep -q "^config:" $justfile_path && \
      grep -q "^unset-config:" $justfile_path && \
      grep -q "^install:" $justfile_path
    }

    if [ ! "$?" -eq 0 ]; then
      echo "$config not valid. Each module must have a justfile with config, unset-config and install recipes"
      exit 1
    fi
  done
