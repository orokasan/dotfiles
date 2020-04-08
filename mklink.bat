mklink %HOMEPATH%"\_vimrc" %HOMEPATH%"\dotfiles\nvim\init.vim"
mklink %HOMEPATH%"\.textlintrc" %HOMEPATH%"\dotfiles\.textlintrc"
mklink /D %HOMEPATH%"\AppData\Local\nvim" %HOMEPATH%"\dotfiles\nvim"
mklink /D %HOMEPATH%"\.vim" %HOMEPATH%"\dotfiles\nvim"
mklink /D %HOMEPATH%"\.goneovim" %HOMEPATH%"\dotfiles\.goneovim"
mkdir %HOMEPATH%"\dotfiles\nvim\swap"
mkdir %HOMEPATH%"\dotfiles\nvim\undo"
mkdir %HOMEPATH%"\dotfiles\nvim\view"

exit 0
