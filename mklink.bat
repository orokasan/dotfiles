mklink %HOMEPATH%"\_vimrc" %HOMEPATH%"\dotfiles\_vimrc"
mklink %HOMEPATH%"\_gvimrc" %HOMEPATH%"\dotfiles\_gvimrc"
mklink %HOMEPATH%"\.textlintrc" %HOMEPATH%"\dotfiles\.textlintrc"
mklink /D %HOMEPATH%"\vimfiles\colors" %HOMEPATH%"\dotfiles\colors"
mklink /D %HOMEPATH%"\vimfiles\syntax" %HOMEPATH%"\dotfiles\syntax"
mklink /D %HOMEPATH%"\vimfiles\Plugin" %HOMEPATH%"\dotfiles\Plugin"
exit 0
