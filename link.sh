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

  # Special case for Emacs's init.el because it goes in a sub-directory.
  # TODO: Support dotfiles nested deeper than `~/.`, which would be
  # useful for Vim as well.
  if [[ ! -d ~/.emacs.d ]] then
      mkdir ~/.emacs.d
  fi
  if [[ ! -a ~/.emacs.d/init.el ]] then
     ln -s ~/config/init.el ~/.emacs.d/init.el
  fi
}
