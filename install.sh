#!/bin/bash
XDG_CONFIG_HOME="${HOME}/.config"
DOTPATH="${HOME}/dotfiles"

for f in .??*
do
  ln -snfv ${DOTPATH}/${f} ${HOME}/${f}
done

ln -snfv ${DOTPATH}/nvim ${XDG_CONFIG_HOME}/nvim
ln -snfv ${DOTPATH}/nvim/init.vim ${HOME}/.vimrc

mkdir ${HOME}/.skk
curl -o ${HOME}/.skk/SKK-JISYO.L https://raw.githubusercontent.com/skk-dev/dict/master/SKK-JISYO.L

exit 0
