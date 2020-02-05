mklink %HOMEPATH%"\_vimrc" %HOMEPATH%"\dotfiles\nvim\init.vim"
mklink %HOMEPATH%"\.textlintrc" %HOMEPATH%"\dotfiles\.textlintrc"
mklink %HOMEPATH%"\AppData\Local\nvim\init.vim" %HOMEPATH%"\dotfiles\nvim\init.vim"
mklink /D %HOMEPATH%"\.vim" %HOMEPATH%"\dotfiles\nvim"
mkdir %HOMEPATH%"\dotfiles\nvim\swap"
mkdir %HOMEPATH%"\dotfiles\nvim\undo"
mkdir %HOMEPATH%"\dotfiles\nvim\view"

exit 0
