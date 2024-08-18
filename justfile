default:
  just --list

config:
  for file in $(git config --file .gitmodules --get-regexp path | awk '{ print $2 }'); do \
    cd {{source_directory()}}/$file && just config ;\
  done

install:
  for file in $(git config --file .gitmodules --get-regexp path | awk '{ print $2 }'); do \
    cd {{source_directory()}}/$file && just install ;\
  done

delete-config:
  for file in $(git config --file .gitmodules --get-regexp path | awk '{ print $2 }'); do \
    cd {{source_directory()}}/$file && just delete-config ;\
  done
