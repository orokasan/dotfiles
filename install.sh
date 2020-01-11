#!/bin/bash
# https://qiita.com/okamos/items/40966158d0271ae7198bより
DOTPATH="${HOME}/dotfiles"
XDG_CONFIG_HOME="${HOME}/.config"
DOT_TARBALL="https://github.com/orokasan/dotfiles/tarball/master"
REMOTE_URL="git@github.com:orokasan/dotfiles.git"

# コマンドの有無は今後よく使うので
has() {
  type "$1" > /dev/null 2>&1
}
# 使い方なのだよ
usage() {
  name=`basename $0`
  cat <<EOF
Usage:
  $name [arguments] [command]
Commands:
  deploy
  initialize
Arguments:
  -f $(tput setaf 1)** warning **$(tput sgr0) Overwrite dotfiles.
  -h Print help (this message)
EOF
  exit 1
}

# オプション -fは上書き、-hはヘルプ表示
while getopts :f:h opt; do
  case ${opt} in
    f)
      OVERWRITE=true
      ;;
    h)
      usage
      ;;
  esac
done
shift $((OPTIND - 1))

# ディレクトリがなければダウンロード（と解凍）する
if [ -n "${OVERWRITE}" -o ! -d ${DOT_DIRECTORY} ]; then
  echo "Downloading dotfiles..."
  mkdir ${DOTPATH}

  if type "git" > /dev/null 2>&1; then
    git clone --recursive "${REMOTE_URL}" "${DOTPATH}"
  else
    curl -fsSLo ${HOME}/dotfiles.tar.gz ${DOT_TARBALL}
    tar -zxf ${HOME}/dotfiles.tar.gz --strip-components 1 -C ${DOTPATH}
    rm -f ${HOME}/dotfiles.tar.gz
  fi

  echo $(tput setaf 2)Download dotfiles complete!. ✔︎$(tput sgr0)
fi

cd ${DOTPATH}

for f in .??*
do
  # 無視したいファイルやディレクトリはこんな風に追加してね
  [[ ${f} = ".git" ]] && continue
  [[ ${f} = ".gitignore" ]] && continue
  [[ ${f} = ".DS_Store" ]] && continue

  ln -snfv ${DOTPATH}/${f} ${HOME}/${f}
done

ln -snfv ${DOTPATH}/efm-langserver ${HOME}/.config/efm-langserver
ln -snfv ${DOTPATH}/.vim ${HOME}/.vim/
if [ ! -d ${XDG_CONFIG_HOME}/nvim/ ]; then
	mkdir "${XDG_CONFIG_HOME}/nvim"
fi
ln -snfv ${DOTPATH}/.vim/.vimrc ${XDG_CONFIG_HOME}/nvim/init.vim
echo $(tput setaf 2)Deploy dotfiles complete!. ✔︎$(tput sgr0)
#
# 引数によって場合分け
command=$1
[ $# -gt 0 ] && shift

# 引数がなければヘルプ
case $command in
  deploy)
    link_files
    ;;
  init*)
    initialize
    ;;
  *)
    usage
    ;;
esac

exit 0
