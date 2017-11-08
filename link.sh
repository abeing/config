#!/bin/zsh
function {
  local -a configs
  configs=("screenrc" "vimrc.local" "gitconfig" "zshrc" "nethackrc")

  for config in $configs
  do
    if [[ ! -a ~/.$config ]] then
      echo Linking $config
      ln -s ~/config/$config ~/.$config
    else
      echo Skipping $config, already linked.
    fi
  done
}
