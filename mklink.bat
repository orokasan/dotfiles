mklink /D %HOMEPATH%"\AppData\Local\nvim" %HOMEPATH%"\GoogleDrive\config\dotfiles\nvim"
mklink /D %HOMEPATH%"\dotfiles" %HOMEPATH%"\GoogleDrive\config\dotfiles"
mklink %HOMEPATH%"\.textlintrc" %HOMEPATH%"\dotfiles\.textlintrc"
mklink %HOMEPATH%"\package.json" %HOMEPATH%"\dotfiles\package.json"
mklink %HOMEPATH%"\.gitconfig" %HOMEPATH%"\dotfiles\.gitconfig"
mklink /D %HOMEPATH%"\.skk" %HOMEPATH%"\GoogleDrive\config\.skk"
mklink %HOMEPATH%"\AppData\Roaming\efm-langserver\config.yaml" %HOMEPATH%"\dotfiles\efm-langserver\config.yaml"
mklink /D %HOMEPATH%"\.goneovim" %HOMEPATH%"\dotfiles\.goneovim"
mkdir %HOMEPATH%"\.backup\vim\swap"
mkdir %HOMEPATH%"\.backup\vim\undo"
mkdir %HOMEPATH%"\.backup\vim\view"
mkdir %HOMEPATH%"\.backup\vim\backup"

:: mdpdfのCSSスタイル用環境変数を設定する
setx MDPDF_STYLES "%HOMEPATH%\dotfiles\mdpdf\style.css"

