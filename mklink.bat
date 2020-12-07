mklink %HOMEPATH%"\_vimrc" %HOMEPATH%"\dotfiles\nvim\init.vim"
mklink %HOMEPATH%"\.textlintrc" %HOMEPATH%"\dotfiles\.textlintrc"
mklink %HOMEPATH%"\package.json" %HOMEPATH%"\dotfiles\package.json"
mklink %HOMEPATH%"\.gitconfig" %HOMEPATH%"\dotfiles\.gitconfig"
mklink %HOMEPATH%"\.skk-jisyo" %HOMEPATH%"\GoogleDrive\.skk\.skk-jisyo"
mklink %HOMEPATH%"\AppData\Roaming\SKKFEP\skkuser.txt"
mklink /D %HOMEPATH%"\AppData\Local\nvim" %HOMEPATH%"\dotfiles\nvim"
mklink /D %HOMEPATH%"\.vim" %HOMEPATH%"\dotfiles\nvim"
mklink /D %HOMEPATH%"\.goneovim" %HOMEPATH%"\dotfiles\.goneovim"
mkdir %HOMEPATH%"\.backup\vim\swap"
mkdir %HOMEPATH%"\.backup\vim\undo"
mkdir %HOMEPATH%"\.backup\vim\view"
mkdir %HOMEPATH%"\.backup\vim\backup"

:: mdpdfのCSSスタイル用環境変数を設定する
setx MDPDF_STYLES "%HOMEPATH%\dotfiles\mdpdf\style.css"

exit 0
