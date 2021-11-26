mklink %HOMEPATH%"\_vimrc" %HOMEPATH%"\dotfiles\nvim\init.vim"
mklink %HOMEPATH%"\.textlintrc" %HOMEPATH%"\dotfiles\.textlintrc"
mklink %HOMEPATH%"\package.json" %HOMEPATH%"\dotfiles\package.json"
mklink %HOMEPATH%"\.gitconfig" %HOMEPATH%"\dotfiles\.gitconfig"
mklink /D %HOMEPATH%"\.skk" %HOMEPATH%"\GoogleDrive\.skk"
mklink %HOMEPATH%"\AppData\Roaming\SKKFEP\skkuser.txt"
mklink %HOMEPATH%"\AppData\Roaming\efm-langserver\config.yaml" %HOMEPATH%"\dotfiles\efm-langserver\config.yaml"
mklink /D %HOMEPATH%"\AppData\Local\nvim" %HOMEPATH%"\dotfiles\nvim"
mklink /D %HOMEPATH%"\.vim" %HOMEPATH%"\dotfiles\nvim"
mklink /D %HOMEPATH%"\.vimfiles" %HOMEPATH%"\dotfiles\nvim"
mklink /D %HOMEPATH%"\.goneovim" %HOMEPATH%"\dotfiles\.goneovim"
mkdir %HOMEPATH%"\.backup\vim\swap"
mkdir %HOMEPATH%"\.backup\vim\undo"
mkdir %HOMEPATH%"\.backup\vim\view"
mkdir %HOMEPATH%"\.backup\vim\backup"

:: mdpdfのCSSスタイル用環境変数を設定する
setx MDPDF_STYLES "%HOMEPATH%\dotfiles\mdpdf\style.css"

exit 0
