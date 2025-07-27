default:
  just --list

sync-configs:
  git submodule init
  git submodule update --recursive

pull-latest-configs:
  git submodule init
  git submodule foreach "git checkout main && git pull --rebase"

config +configs:
  #!/bin/bash
  for config in {{configs}}; do
    cd {{source_directory()}}/$config && just config
  done

install +configs:
  #!/bin/bash
  for config in {{configs}}; do
    cd {{source_directory()}}/$name && just install
  done

unset-config +configs:
  #!/bin/bash
  for config in {{configs}}; do
    cd {{source_directory()}}/$config && just unset-config
  done

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
