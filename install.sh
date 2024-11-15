#!/bin/bash
XDG_CONFIG_HOME="${HOME}/.config"

for f in .??*
do
  ln -snfv ${DOTPATH}/${f} ${HOME}/${f}
done

ln -snfv ${DOTPATH}/nvim ${XDG_CONFIG_HOME}/nvim
ln -snfv ${DOTPATH}/nvim/init.vim ${HOME}/.vimrc
ln -snfv ${DOTPATH}/../.skk/ ${HOME}/.skk

exit 0
