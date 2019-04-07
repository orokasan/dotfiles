"ork's _vimrc for Windows
"今夜使いたいkey mapping
"ciw => カーソル上の単語を削除してインサートモード
"ci' => シングルクォート内のテキストを削除してインサートモード
"========================================================================
"基本設定
"{{{
"encode
set encoding=utf-8			" vim 内部のエンコーディグ
scriptencoding utf-8,cp932		" vimrcのエンコーディング
set fileencoding=utf-8			" 既定のファイル保存エンコーディング
set fileencodings=utf-8,ucs-bom,iso-2022-jp-3,euc-jisx0213,euc-jp,cp932
" ------------------------------------------------------------------------------
" reset vimrc autocmd group
" ------------------------------------------------------------------------------
augroup vimrc
  autocmd!
augroup END
"========================================================================
"config-file
"========================================================================
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
"Undoファイルをまとめる
set undodir=~/vimfiles/undo
"backupファイルを作成
set backup
set backupdir=~/vimfiles/backup
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set noshowcmd
"モードを表示しない
set noshowmode
"日本語の行の連結時には空白を入力しない。
set formatoptions+=mMj
"folding設定
setlocal foldmethod=marker
"set viminfo='1,<1000,s100,/0,h,n~/vimfiles/viminfo
"いい感じに折りたたみ状態を保存
function! s:is_view_available() abort
  if !&buflisted || &buftype !=# ''
    return 0
  elseif !filewritable(expand('%:p'))
    return 0
  endif
  return 1
endfunction

function! s:mkview() abort
   if s:is_view_available()
    silent! mkview
  endif
endfunction

function! s:loadview() abort
  if s:is_view_available()
    silent! loadview
  endif
endfunction

augroup MyAutoCmd
  autocmd!
  autocmd MyAutoCmd BufWinLeave ?* call s:mkview()
  autocmd MyAutoCmd BufReadPost ?* call s:loadview()
augroup END

"使わないプリセットプラグインを読み込まない
let g:loaded_gzip              = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:loaded_rrhelper          = 1
let g:loaded_2html_plugin      = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_netrw             = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_netrwFileHandlers = 1
"========================================================================
"runtimepath
"========================================================================
set runtimepath+="C:\Program Files\Python37"
" plugins下のディレクトリをruntimepathへ追加する。
"========================================================================
"Python,vimproc
"========================================================================
"メモ
"インストールはAll Userで
"pipからneovim, greenletを導入 Visual Studio C++ 14.0が必要
"参考:https://gammasoft.jp/python/python-version-management/
"kaoriya-vimのpythonに揃える
"64bit版を使用する
let g:python_host_prog ='C:\Program Files (x86)\Python2.7\python.exe'
let g:python3_host_prog ='C:\Program Files\Python37\python.exe'

"vimprocのダウンロード(for Win)
let g:vimproc#download_windows_dll = 1
"}}}
"=========================================================================================
"外観
"{{{
set lazyredraw
set shortmess+=I
"常にタブラインを表示
set showtabline=2
" 括弧入力時の対応する括弧を表示
set showmatch
set number
set matchtime=1
" ステータスラインを常に表示
set laststatus=2
"コマンドライン行数の設定
set cmdheight=1
" ESC連打でハイライト解除
nmap<silent> <Esc><Esc> :nohlsearch<CR><Esc>
nmap<silent> <C-c><C-c> :nohlsearch<CR><Esc>
"モードライン設定
set modelines=5
set noequalalways
" ビープ音を可視化
set visualbell
"IME状態でカーソルカラー変更
if has('multi_byte_ime')
  highlight CursorIM guifg=NONE guibg=Purple
endif
"全角スペースを表示
"コメント以外で全角スペースを指定しているので "scriptencoding"と、
"このファイルのエンコードが一致するよう注意！
"デフォルトのZenkakuSpaceを定義
function! ZenkakuSpace()
  highlight ZenkakuSpace cterm=underline ctermfg=darkgrey gui=underline guifg=darkgrey
endfunction
"一時的にバッファを最大化
function! s:toggle_window_zoom() abort
    if exists('t:zoom_winrestcmd')
        execute t:zoom_winrestcmd
        unlet t:zoom_winrestcmd
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
    endif
endfunction
nnoremap <silent> <Plug>(my-zoom-window)
      \ :<C-u>call <SID>toggle_window_zoom()<CR>
nmap <Leader>wz <Plug>(my-zoom-window)
nmap <Leader>w<C-z> <Plug>(my-zoom-window)

"if has('syntax')
"  augroup ZenkakuSpace
"    autocmd!
"    " ZenkakuSpaceをカラーファイルで設定するなら次の行は削除
"    autocmd ColorScheme       * call ZenkakuSpace()
"    " 全角スペースのハイライト指定
"    autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
"    autocmd VimEnter,WinEnter * match ZenkakuSpace '\%u3000'
"  augroup END
"  call ZenkakuSpace()
"endif
"}}}
"========================================================================
"入力・編集
"{{{
"自動改行をやめる
set textwidth=0
" カーソルを文字が存在しない部分でも動けるようにする
set virtualedit=block
" 行末の1文字先までカーソルを移動できるように
"set virtualedit=onemore
"3行余裕を持たせてスクロール
:set scrolloff=3
"長い行を表示
set display=lastline
set signcolumn=yes
"日本語の文章構造に対応するやつ
set matchpairs+=（:）,「:」,『:』,【:】,［:］,＜:＞,':'
set lazyredraw
"set spelllang=en,cjk
"日付を入力
inoremap <expr> <F2> strftime("%Y%m%d")
"句読点を強引に挿入
nnoremap <Leader>, a、<Esc>
nnoremap <Leader>. a。<Esc>
nnoremap <Leader>? a？<Esc>
nnoremap <Leader>! a！<Esc>
nnoremap <Leader>/ a/<Esc>
nnoremap <Leader>\ a\<Esc>
nnoremap <Leader><Space> a <Esc>
nnoremap <Leader><S-Space> a…<Esc>
" <ESC>でのIME状態保存を無効化
inoremap <silent><ESC> <ESC>
inoremap <silent><C-[> <ESC>
inoremap <silent><C-c> <ESC>
"日本語入力固定モード
"IM-control.vimが必要
"https://sites.google.com/site/fudist/Home/vim-nihongo-ban/vim-japanese/ime-control
" 「日本語入力固定モード」切替キー
inoremap <silent> <C-j> <C-^><C-r>=IMState('FixMode')<CR>

"Tab系
"不可視文字の可視化
set list
"不可視文字の表示
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%

"<TAB>を含むファイルを開いた際、<TAB>を何文字の空白に変換するかを設定
set tabstop=4
"キーボードで<TAB>を入力した際、<TAB>を何文字の空白に変換するかを設定
set expandtab
set softtabstop=4
let g:vim_indent_cont = 4
"自動インデント
set autoindent
"vimが自動でインデントを行った際、設定する空白数
set shiftwidth=4
" The prefix key.
"検索系
"type S, then type what you're looking for, a /, and what to replace it with
nmap S :%s//g<LEFT><LEFT>
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
"Markdown用設定
augroup vimrc_markdown
autocmd!
autocmd BufRead,BufNewFile *.{md} set filetype=markdown
autocmd! FileType markdown hi! def link markdownItalic Normal
autocmd FileType markdown set commentstring=<\!--\ %s\ -->
augroup END
"}}}
"========================================================================
"Key mapping
"{{{
"!!!!!!!!!!LeaderをSpaceキーに!!!!!!!!!!!!!!!
let mapleader = "\<Space>"
nnoremap + <C-a> "数字のプラス
nnoremap - <C-x> "マイナス
nnoremap 0 ^
nnoremap ^ 0
nnoremap 4 $
" Create a blank line above/below current line
nnoremap <leader>j o<ESC>k
nnoremap <leader>k O<ESC>j
" Convenience key for getting to command mode
nnoremap ; :
" Enter normal mode
inoremap jk <esc>
"末尾までヤンク
nnoremap <silent>Y y$
" 折り返し時に表示行単位での移動できるようにする
nnoremap  j gj
nnoremap  k gk
"CTRL-sで保存！
imap <c-s> <Esc>:w<CR>a
"CTRL-qでclose
nnoremap <silent> <C-q> :close<CR>
" For JIS keyboard
inoremap <C-@> <ESC>
"画面分割マッピング
nnoremap <leader>ws :sp<CR>:bprev<CR>
nnoremap <leader>wv :vsp<CR>:bprev<CR>
nnoremap <leader>wc :close<CR>
nnoremap <leader>wn :vne<CR>
nnoremap <leader>wo :only<CR>
"_vimrcを開く
noremap <silent> <leader>vme :e ~/dotfiles/?vimrc<CR>
"開いているfileを読み込む
noremap <Leader>ss :<C-u>source %<CR>
"Shift-l, Shift-hで行末, 行頭に移動
nnoremap <S-l> <End>
nnoremap <S-h> <Home>
" インサートモード時は emacs like なキーバインド
inoremap <C-f> <Right>|			" C-f で左へ移動
inoremap <C-b> <Left>|			" C-b で右へ移動
"inoremap <C-p> <Up>|			" C-p で上へ移動
"inoremap <C-n> <Down>|			" C-n で下へ移動
inoremap <C-a> <Home>|			" C-a で行頭へ移動
inoremap <C-e> <End>|			" C-e で行末へ移動
inoremap <C-h> <BS>|			" C-h でバックスペース
inoremap <C-m> <CR>|			" C-m で改行
inoremap <C-l> <del>
"window移動
nnoremap <C-h> <C-w>h|			" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-j> <C-w>j|			" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-k> <C-w>k|			" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-l> <C-w>l|			" Ctrl + hjkl でウィンドウ間を移動
"windowサイズ変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>
"バッファ移動
nnoremap <silent><Leader>h :bprev!<CR>|
nnoremap <silent><Leader>l :bnext!<CR>|
"コマンドライン上のマッピング
cnoremap <C-a> <Home>| " 一文字戻る
cnoremap <C-b> <Left>| " カーソルの下の文字を削除
cnoremap <C-d> <Del>| " 行末へ移動
cnoremap <C-e> <End>| " 一文字進む
cnoremap <C-f> <Right>| " コマンドライン履歴を一つ進む
cnoremap <C-n> <Down>| " コマンドライン履歴を一つ戻る
cnoremap <C-p> <Up>| " 前の単語へ移動
cnoremap <M-b> <S-Left>| " 次の単語へ移動
cnoremap <M-f> <S-Right>|" 前の単語へ移動
" TABにて対応ペアにジャンプ
nnoremap <Tab> %
xnoremap <Tab> %
"バッファを閉じてもウィンドウが閉じないようにする
"need-Bclose
"https://vim.fandom.com/wiki/Deleting_a_buffer_without_closing_the_window
nnoremap <silent> <C-p> :Bclose<CR>
"Markdownの改行タグ
nnoremap <Leader>nr <C-u>A  <Esc>
"Markdown Docx出力
"pandocが必要
nnoremap <Leader>dmd <C-u> :! pandoc "%:p" -o "%:p:r.docx"<CR>
"}}}
"========================================================================
"Vim-Plug
"{{{
if has('vim_starting')
  set runtimepath+=~/vimfiles/plugged/vim-plug
  if !isdirectory(expand('$HOME/vimfiles/plugged/vim-plug'))
    echo 'install vim-plug...'
    call system('mkdir -p vimfiles/plugged/vim-plug')
    call system('git clone https://github.com/junegunn/vim-plug.git vimfiles/plugged/vim-plug/autoload')
  end
endif

call plug#begin('~/vimfiles/plugged')
"  Plug 'junegunn/vim-plug',

  Plug 'Shougo/neomru.vim' |Plug 'Shougo/unite.vim' |Plug 'Shougo/neoyank.vim' |Plug 'iyuuya/denite-ale' |Plug 'kmnk/denite-dirmark' |Plug 'Shougo/denite.nvim'

if !has('nvim')
  Plug 'roxma/nvim-yarp' 
  Plug 'roxma/vim-hug-neovim-rpc' 
endif
  Plug 'Shougo/defx.nvim'

  Plug 'lambdalisue/gina.vim' "git管理
  Plug 'iwataka/minidown.vim',{'for':'markdown'}
  Plug 'deton/jasegment.vim' "W,E,Bで日本語でも分節移動ができるように

  Plug 'rhysd/vim-operator-surround' "選択範囲に括弧を追加
  Plug 'kana/vim-operator-user'
  Plug 'cohama/lexima.vim' "括弧を補完
  Plug 'kshenoy/vim-signature'
  Plug 'tyru/open-browser.vim' 
  Plug 'basyura/TweetVim' , {'on':['TweetVimHomeTimeline','TweetVimSay']} |  Plug 'mattn/webapi-vim'|  Plug 'basyura/twibill.vim'

  Plug 'itchyny/lightline.vim' | Plug 'mengelbrecht/lightline-bufferline' | Plug 'maximbaz/lightline-ale' | Plug 'itchyny/vim-gitbranch'
  
  Plug 'Shougo/deoplete.nvim', |  Plug 'Shougo/neco-vim' |  Plug 'Shougo/neco-syntax'
    \|  Plug 'Shougo/neosnippet' |  Plug 'Shougo/neosnippet-snippets'

  Plug 'sjl/gundo.vim'
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'Shougo/echodoc.vim'
  Plug 'w0rp/ale'
  Plug 'tyru/eskk.vim'
  Plug 'NLKNguyen/papercolor-theme'
  Plug 'rakr/vim-one'
  Plug 'hzchirs/vim-material'
  Plug 'altercation/vim-colors-solarized'
  Plug 'cocopon/iceberg.vim'
  Plug 'tomasr/molokai'
  Plug 'MvanDiemen/ghostbuster'
  Plug 'nanotech/jellybeans.vim'
  Plug 'jonathanfilip/vim-lucius'
  Plug 'sheerun/vim-wombat-scheme'
  Plug 'w0ng/vim-hybrid'
  Plug 'morhetz/gruvbox'

  Plug 'mattn/benchvimrc-vim',{'on':'BenchVimrc'}

  call plug#end()

filetype plugin indent on
syntax enable
"}}}
"-----------------------------------------------------------------------
"Denite
"{{{
"need-Python3.6
nnoremap [denite] <Nop>
nmap s [denite]
nnoremap <silent> [denite]s :<C-u>DeniteBufferDir
	\  source<CR>
"現在開いているファイルのディレクトリ下のファイル一覧。
nnoremap <silent> [denite]f :<C-u>DeniteBufferDir
	\  file<CR>
"ホームディレクトリ下のファイル一覧。
nnoremap <silent> [denite]t :<C-u>DeniteProjectDir
	\ file<CR>
"バッファ一覧
nnoremap <silent> [denite]b :<C-u>Denite
	\ -buffer-name=normal -mode=normal
	\ buffer<CR>
nnoremap <silent> ? :<C-u>Denite
	\ -buffer-name=search -auto-highlight
	\ line<CR>
nnoremap <silent> * :<C-u>DeniteCursorWord
	\ -buffer-name=search
	\ -auto-highlight -mode=normal line<CR>
"register&neoyank
nnoremap <silent> [denite]y :<C-u>Denite
	\ -mode=normal
	\ register neoyank<CR>
nnoremap <silent> [denite]c :<C-u>Denite
    \ -mode=normal
    \ command_history<CR>
"nnoremap <silent> ;g :<C-u>Denite -buffer-name=search
"      \ -no-empty -mode=normal grep<CR>
"メニュー
nnoremap <silent> [denite]u :<C-u>Denite
	\ -mode=normal -winheight=5
    \ menu<CR>
nnoremap <silent> [denite]h :<C-u>Denite
    \ -buffer-name=search
    \ -highlight-mode-insert=WildMenu
    \ help<CR>
"最近使用したファイル一覧
nnoremap <silent> [denite]n :<C-u>Denite
	\ -mode=normal 
    \ file_mru<CR>
":change
nnoremap <silent> [denite]k :<C-u>Denite -mode=normal change jump<CR>
"searchバッファをresumeして開く
nnoremap <silent><C-n> :<C-u>Denite -buffer-name=search
    \ -resume -mode=normal -refresh<CR>
"open ale message
nnoremap <silent> [denite]a :<C-u>Denite
	\ -buffer-name=search -mode=normal
	\ ale<CR>
"nnoremap <silent>n :<C-u>Denite
"    \ -cursor-pos=+1 -immediately
"    \ -buffer-name=search
"    \ -resume -mode=normal -refresh<CR>
"denite-default option
call denite#custom#option('normal', {
    \ 'quick-move': 'immediately'
    \})

call denite#custom#option('search', {
    \ 'winheight': 5
    \ })

call denite#custom#option('_', {
	\ 'prompt': '»',
	\ 'cursor_wrap': v:true,
	\ 'winheight': 15,
	\ 'highlight_mode_insert': 'WildMenu',
	\ 'statusline': v:false,
    \ 'unique': v:true,
    \ 'vertical-preview': v:true
	\ })
" Change mappings.
call denite#custom#map(
      \ 'insert',
      \ '<C-j>',
      \ '<denite:move_to_next_line>',
      \ 'noremap'
      \)
call denite#custom#map(
      \ 'insert',
      \ '<C-k>',
      \ '<denite:move_to_previous_line>',
      \ 'noremap'
      \)
"C-J,C-Kでsplitで開く
call denite#custom#map('insert', '<C-g>', '<denite:do_action:split>', 'noremap')
call denite#custom#map('insert', '<C-t>', '<denite:do_action:vsplit>', 'noremap')
"C-h,C-lでディレクトリ移動
call denite#custom#map('insert', '<C-l>', '<denite:do_action:default>', 'noremap')
call denite#custom#map('insert', '<C-h>', '<denite:move_up_path>', 'noremap')
"h,lでディレクトリ上下移動
call denite#custom#map('normal', 'l', '<denite:do_action:default>', 'noremap')
call denite#custom#map('normal', 'h', '<denite:move_up_path>', 'noremap')
"defxで開く

function! ToggleSorter(sorter) abort
   let sorters = split(b:denite_context.sorters, ',')
   let idx = index(sorters, a:sorter)
   if idx < 0
       call add(sorters, a:sorter)
   else
       call remove(sorters, idx)
   endif
   let b:denite_new_context = {}
   let b:denite_new_context.sorters = join(sorters, ',')
   return '<denite:nop>'
endfunction
call denite#custom#map('insert', '<C-f>',
    \ 'ToggleSorter("sorter/reverse")', 'noremap expr nowait')

"need rg for grep/file-rec
call denite#custom#var('file/rec', 'command',
      \ ['rg', '--files', '--glob', '!.git'])
call denite#custom#var('grep', 'command', ['rg', '--threads', '1'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'final_opts', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'default_opts',
      \ ['--vimgrep', '--no-heading'])

" Change matchers.
call denite#custom#source(
	\ 'file_mru', 'matchers', ['matcher/fuzzy', 'matcher/project_files'])
call denite#custom#source(
	\ 'file/rec', 'matchers', ['matcher/cpsm'])

" Add custom menus
let s:menus = {
    \ }
let s:menus.window_size = {
	\ 'description': 'Change window size'
	\ }
let s:menus.window_size.command_candidates = [
	\ ['150x40', 'set lines=40 columns=150'],
	\ ['220x50', 'set lines=50 columns=220'],
	\ ['Fullscreen-> :SM 6<CR> ', '']
	\ ]
call denite#custom#var('menu', 'menus', s:menus)

"" Ag command on grep/filerec source
"call denite#custom#var('file_rec', 'command',
"    \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
"call denite#custom#var('grep', 'command', ['ag'])

" Define alias
call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#var('file/rec/git', 'command',
	\ ['git', 'ls-files', '-co', '--exclude-standard'])
call denite#custom#alias('source', 'file/rec/py', 'file/rec')
call denite#custom#var('file/rec/py', 'command',['scantree.py'])
" Change ignore_globs
call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
	\ [ '.git/', '.ropeproject/', '__pycache__/',
	\   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

"Defxで開く
function! s:defx_open(context)
    let path = a:context['targets'][0]['action__path']
    let file = fnamemodify(path, ':p')
    let file_search = filereadable(expand(file)) ? ' -search=' . file : ''
    let dir = denite#util#path2directory(path)
    if &filetype ==# 'defx'
      call defx#call_action('cd', [dir])
      call defx#call_action('search', [path])
    else
      execute('Defx ' . dir . file_search)
  endif
endfunction
"function! s:denite_action_file_rec()

"action:defxを定義
call denite#custom#action('buffer,directory,file,openable,dirmark', 'defx',
        \ function('s:defx_open'))
call denite#custom#map('_', '<C-d>', '<denite:do_action:defx>', 'noremap')
"denite-filerecをactionに定義したい
"call denite#custom#action('buffer,directory,file,openable,dirmark', filerec,
"        \ function ('s:denite_action_file_rec'))
"}}}
"-----------------------------------------------------------------------
"Dirmark
"{{{
nmap [denite]d    <SID>(dirmark)
nmap [denite]D   <SID>(dirmark-add)
nnoremap <silent> <SID>(dirmark) :<C-u>Denite -mode=normal -buffer-name=normal dirmark<CR>
"bookmark by "add"action
nnoremap <silent><expr><nowait> <SID>(dirmark-add)  ':<C-u>DeniteBufferDir dirmark/add <CR>'
"}}}
"-----------------------------------------------------------------------
"Defx
"{{{
nnoremap <silent> <C-e>
	\ :<C-u>Defx<CR>
	\ :setlocal nonumber signcolumn=no<CR>
call defx#custom#option('_', {
    \ 'winwidth': 40,
    \ 'split': 'vertical',
    \ 'direction': 'botright',
    \ 'columns':'mark:filename:time',
    \ 'sort': 'TIME'
    \ })
"    \ 'ignored-files':['desktop.ini','ntuser.*']
"call defx#custom#column('filename', {
"      \ 'directory_icon': '▸',
"      \ 'opened_icon': '▾',
"      \ 'root_icon': ' ',
"      \ 'min_width': 45,
"      \ 'max_width': 45,
"      \ })
"call defx#custom#column('mark', {
"      \ 'readonly_icon': '✗',
"      \ 'selected_icon': '✓',
"      \ })

autocmd vimrc FileType defx call s:defx_my_settings()

    function! s:GetDefxBaseDir(candidate) abort
        if line('.') == 1
            let path_mod  = 'h'
        else
            let path_mod = isdirectory(a:candidate) ? '' : 'h'
        endif
        return fnamemodify(a:candidate,'":p:' . path_mod . '"')
    endfunction

    function! s:denite_rec(context) abort
        let narrow_dir = s:GetDefxBaseDir(a:context.targets[0])
        execute('Denite -default-action=defx file/rec:''' .  narrow_dir . '''')
    endfunction

function! s:defx_my_settings() abort
" Define mappings
nnoremap <silent><buffer><expr> <CR>
\ defx#do_action('drop')
nnoremap <silent><buffer><expr> c
\ defx#async_action('copy')
nnoremap <silent><buffer><expr> m
\ defx#async_action('move')
nnoremap <silent><buffer><expr> p
\ defx#async_action('paste')
nnoremap <silent><buffer><expr> l 
\ defx#is_directory() ?
\ defx#do_action('open') :
\ defx#do_action('drop')
nnoremap <silent><buffer><expr> E
\ defx#do_action('open', 'vsplit')
nnoremap <silent><buffer><expr> t
\ defx#do_action('multi', ['toggle_sort','filename','redraw'])
nnoremap <silent><buffer><expr> T
\ defx#do_action('multi', [['toggle_sort','TIME'],'redraw'])
nnoremap <silent><buffer><expr> P
\ defx#do_action('open', 'pedit')
nnoremap <silent><buffer><expr> K
\ defx#do_action('new_directory')
nnoremap <silent><buffer><expr> N
\ defx#do_action('new_file')
nnoremap <silent><buffer><expr> d
\ defx#do_action('remove')
nnoremap <silent><buffer><expr> r
\ defx#do_action('rename')
nnoremap <silent><buffer><expr> x
\ defx#async_action('execute_system')
nnoremap <silent><buffer><expr> f
\ defx#do_action('open_or_close_tree')
nnoremap <silent><buffer><expr> yy
\ defx#do_action('yank_path')
nnoremap <silent><buffer><expr> .
\ defx#do_action('toggle_ignored_files')
nnoremap <silent><buffer><expr> h
\ defx#do_action('cd', ['..'])
nnoremap <silent><buffer><expr> ~
\ defx#do_action('cd')
nnoremap <silent><buffer><expr> q
\ defx#do_action('quit')
nnoremap <silent><buffer><expr> i
\ defx#do_action('toggle_select') . 'j'
nnoremap <silent><buffer><expr> I
\ defx#do_action('clear_select_all')
nnoremap <silent><buffer><expr> *
\ defx#do_action('toggle_select_all')
nnoremap <silent><buffer><expr> j
\ line('.') == line('$') ? 'gg' : 'j'
nnoremap <silent><buffer><expr> k
\ line('.') == 1 ? 'G' : 'k'
nnoremap <silent><buffer><expr> <C-l>
\ defx#do_action('redraw')
nnoremap <silent><buffer><expr> <C-g>
\ defx#do_action('print')
nnoremap <silent><buffer><expr> cd
\ defx#do_action('change_vim_cwd')
nnoremap <silent><buffer><expr> <C-t>
\ defx#do_action('call', '<SID>denite_rec')

endfunction
"autocmd vimrc ColorScheme * highlight Defx_filename_directory term = bold ctermfg=33 guifg=#4078f2
"}}}
"-----------------------------------------------------------------------
"gina.vim
"{{{
"docのexampleをコピペ
nnoremap <Leader>aa :<C-u>Gina status --short<CR>
nnoremap <Leader>ac :<C-u>Gina commit<CR>

call gina#custom#command#alias('branch', 'br')
call gina#custom#command#option('br', '-v', 'v')
call gina#custom#command#option(
\ '/\%(log\|reflog\)',
\ '--opener', 'vsplit'
\)

call gina#custom#command#option(
\ '/\%(status\|branch\|ls\|grep\|changes\|tag\)',
\ '--opener' , '10split'
\)
call gina#custom#command#option(
\ 'log', '--group', 'log-viewer'
\)
call gina#custom#command#option(
\ 'status', '--group', 'status-viewer'
\)
call gina#custom#command#option(
\ 'reflog', '--group', 'reflog-viewer'
\)
call gina#custom#command#option(
\ 'commit', '-v|--verbose'
\)
call gina#custom#command#option(
\ '/\%(status\|commit\)',
\ '-u|--untracked-files'
\)
call gina#custom#command#option(
\ '/\%(status\|changes\)',
\ '--ignore-submodules'
\)

call gina#custom#action#alias(
\ 'branch', 'track',
\ 'checkout:track'
\)
call gina#custom#action#alias(
\ 'branch', 'merge',
\ 'commit:merge'
\)
call gina#custom#action#alias(
\ 'branch', 'rebase',
\ 'commit:rebase'
\)

call gina#custom#mapping#nmap(
\ 'branch', 'g<CR>',
\ '<Plug>(gina-commit-checkout-track)'
\)
call gina#custom#mapping#nmap(
\ 'status', '<C-^>',
\ ':<C-u>Gina commit<CR>',
\ {'noremap': 1, 'silent': 1}
\)
call gina#custom#mapping#nmap(
\ 'commit', '<C-^>',
\ ':<C-u>Gina status<CR>',
\ {'noremap': 1, 'silent': 1}
\)

"call gina#custom#execute(
"\ '/\%(status\|branch\|ls\|grep\|changes\|tag\)',
"\ 'setlocal winfixheight',
"\)

"denite-neomruでginaを無視
let g:neomru#file_mru_ignore_pattern = 'gina://'
"}}}
"-----------------------------------------------------------------------
"vim-markdow
"{{{
"mapping
nnoremap <Leader>pmd <C-u>:Minidown<CR>
"}}}
"-----------------------------------------------------------------------------------------
"jasegment
let g:jasegment#model='knbc_bunsetu'
let g:jasentence_endpat = '[。．？！]\+'
"-----------------------------------------------------------------------------------------
" operator mappings
"{{{
"mapping
map <silent>ta <Plug>(operator-surround-append)
map <silent>td <Plug>(operator-surround-delete)
map <silent>tr <Plug>(operator-surround-replace)
"2バイト括弧を追加
let g:operator#surround#blocks = {}
let g:operator#surround#blocks['-'] = [
\   { 'block' : ['（', '）'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['P'] },
\   { 'block' : ['「', '」'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['B'] },
\   { 'block' : ['『', '』'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['D'] },
\ ]
"}}}
"-----------------------------------------------------------------------------------------
"lexima
""{{{
""2バイト括弧を追加
call lexima#add_rule({'char': '「', 'input': '「', 'input_after': '」'})
call lexima#add_rule({'char': '『', 'input': '『', 'input_after': '』'})
call lexima#add_rule({'char': '【', 'input': '【', 'input_after': '】'})
call lexima#add_rule({'char': '（', 'input': '（', 'input_after': '）'})
call lexima#add_rule({'char': '<BS>', 'at': '「', 'input': '<BS>', 'delete' : 1})
call lexima#add_rule({'char': '<BS>', 'at': '『', 'input': '<BS>', 'delete' : 1})
call lexima#add_rule({'char': '<BS>', 'at': '【', 'input': '<BS>', 'delete' : 1})
call lexima#add_rule({'char': '<BS>', 'at': '（', 'input': '<BS>', 'delete' : 1})
call lexima#add_rule({'char': '<C-Space>', 'at': '\%#)', 'leave': 1})
call lexima#add_rule({'char': '<C-Space>', 'at': '\%#"', 'leave': 1})
call lexima#add_rule({'char': '<C-Space>', 'at': '\%#''', 'leave': 1})
call lexima#add_rule({'char': '<C-Space>', 'at': '\%#]', 'leave': 1})
call lexima#add_rule({'char': '<C-Space>', 'at': '\%#}', 'leave': 1})
call lexima#add_rule({'char': '<C-Space>', 'at': '\%#』', 'leave': 1})
call lexima#add_rule({'char': '<C-Space>', 'at': '\%#」', 'leave': 1})
call lexima#add_rule({'char': '<C-Space>', 'at': '\%#）', 'leave': 1})
"}}}
"-----------------------------------------------------------------------------------------
"文字数カウントスクリプト
"{{{
"
"1行カウント
function! s:CharCount()
	let l:line = getline(line('.'))
	let l:result =  strlen(substitute(l:line, '.', 'x','g'))
	return l:result
endfunction
"
"全体カウント
function! s:CharAllCount()
	let l:result = 0
	for l:linenum in range(0, line('$'))
		let l:line = getline(l:linenum)
		let l:result += strlen(substitute(l:line, '.', 'x','g'))
	endfor
	return l:result
endfunction

"選択範囲の行をカウント
function! g:LineCharVCount() range
	let l:result = 0
	for l:linenum in range(a:firstline, a:lastline)
		let l:line = getline(l:linenum)
		let l:result += strlen(substitute(l:line, '.', 'x','g'))
	endfor
	echo ' [WordCount] -- ' . l:result . ' : ' . s:CharAllCount() .
				\ ' -- [選択行の字数:全体の字数]'
endfunction
"呼び出す
command! -range LineCharVCount <line1>,<line2>call g:LineCharVCount()
xnoremap<silent> ; :LineCharVCount<CR>
"}}}
"-----------------------------------------------------------------------
"Open-Browser
nmap <Leader>s <Plug>(openbrowser-smart-search)
vmap <Leader>s <Plug>(openbrowser-smart-search)
"-----------------------------------------------------------------------
"TweetVim
"{{{
nnoremap <silent> <Leader>ts  :<C-u>TweetVimSay<CR>
nnoremap <silent> <Leader>tt  :TweetVimHomeTimeline<CR>
nnoremap <silent> <Leader>tm :TweetVimMentions<CR>
nnoremap <silent> <Leader>tu :Unite tweetvim<CR>

let g:tweetvim_tweet_per_page = 60
let g:tweetvim_include_rts    = 1
let g:tweetvim_config_dir = expand('~/vimfiles/.tweetvim')
let g:tweetvim_open_buffer_cmd = 'botright 60vsplit'
let g:tweetvim_display_separator = 1
let g:tweetvim_empty_separator = 1
let g:tweetvim_display_time = 0
let g:tweetvim_async_post = 1
let g:tweetvim_display_username = 1
let g:tweetvim_tweet_limit = 560

augroup TweetVimSetting
autocmd!
" マッピング
" 挿入・通常モードでsayバッファを閉じる
autocmd FileType tweetvim_say nnoremap <buffer><silent><C-g>    :<C-u>q!<CR>
autocmd FileType tweetvim_say inoremap <buffer><silent><C-g>    <C-o>:<C-u>q!<CR><Esc>
" 各種アクション
autocmd FileType tweetvim     nnoremap <buffer>s                :<C-u>TweetVimSay<CR>
autocmd FileType tweetvim     nnoremap <buffer>m                :<C-u>TweetVimMentions<CR>
autocmd FileType tweetvim     nnoremap <buffer><Leader>u        :<C-u>:Unite tweetvim<CR>
autocmd FileType tweetvim     nmap     <buffer>c                <Plug>(tweetvim_action_in_reply_to)
autocmd FileType tweetvim     nnoremap <buffer>t                :<C-u>Unite tweetvim -no-start-insert -quick-match<CR>
autocmd FileType tweetvim     nmap     <buffer><Leader>F        <Plug>(tweetvim_action_remove_favorite)
autocmd FileType tweetvim     nmap     <buffer><Leader>d        <Plug>(tweetvim_action_remove_status)
autocmd FileType tweetvim     nmap     <buffer>o        <Plug>(tweetvim_action_open_links)
autocmd FileType tweetvim     nmap     <silent><buffer>q				:bd<CR>
" リロード
autocmd FileType tweetvim     nmap     <buffer><Tab>            <Plug>(tweetvim_action_reload)
" ページの先頭に戻ったときにリロード
autocmd FileType tweetvim     nmap     <buffer><silent>gg       gg<Plug>(tweetvim_action_reload)
" ページ移動を ff/bb から f/b に
autocmd FileType tweetvim     nmap     <buffer>f                <Plug>(tweetvim_action_page_next)
autocmd FileType tweetvim     nmap     <buffer>b                <Plug>(tweetvim_action_page_previous)
"縦移動（カーソルを常に中央にする）
 autocmd FileType tweetvim    nmap <silent> <buffer> j <Plug>(tweetvim_action_cursor_down)
autocmd FileType tweetvim     nmap <silent> <buffer> k <Plug>(tweetvim_action_cursor_up)
" 不要なマップを除去
autocmd FileType tweetvim     nunmap   <buffer>ff
autocmd FileType tweetvim     nunmap   <buffer>bb
" tweetvim バッファに移動したときに自動リロード
autocmd BufEnter * call <SID>tweetvim_reload()
augroup END

autocmd vimrc ColorScheme * highlight tweetvim_screen_name term = bold ctermfg=33 guifg=#4078f2
autocmd vimrc ColorScheme * highlight tweetvim_at_screen_name term = bold ctermfg=33 guifg=#4078f2
" セパレータを飛ばして移動する
" filetype が tweetvim ならツイートをリロード
function! s:tweetvim_reload()
    if &filetype ==# 'tweetvim'
        call feedkeys("\<Plug>(tweetvim_action_reload)")
    endif
endfunction
"}}}
"-----------------------------------------------------------------------
"lightline
"lightline-bufferline
"lightline-ale
"{{{
let g:lightline = {
\ 'colorscheme': 'wombat',
    \ 'active': {
		\ 'left': [ [ 'mode', 'paste' ],['gitbranch'], [ 'readonly', 'relativepath'] ],
		\ 'right': [
        \ ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok','charcount','lineinfo' ],
        \ ['percent'], [ 'IMEstatus','filetype' ] 
        \ ]
    \ },
	\ 'inactive': {
		\ 'left': [['inactivefn']],
		\ 'right': [[ 'lineinfo' ]]
	\},
    \ 'component_function': {
		\'readonly':'LightlineReadonly',
		\'gitbranch': 'LLgitbranch',
		\'filetype': 'LightlineFiletype',
        \ 'ale': 'ALEGetStatusLine',
		\'inactivefn':'MyInactiveFilename',
		\'relativepath':'MyFilepath',
        \'mode': 'LightlineMode',
	    \'charcount':'LLCharcount'
    \ }
\ }
"if has('GUI')
    let g:lightline.separator =  { 'left': '⮀', 'right': '⮂' }
    let g:lightline.subseparator = { 'left': '⮁', 'right': '⮃' }
"endif

let g:lightline.component = {
    \'lineinfo':'%-2v:%3l',
	\'IMEstatus':'%{IMStatus("-JP-")}'
	\}
let g:lightline.component_expand = {
      \  'buffers': 'lightline#bufferline#buffers',
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }
let g:lightline.component_type = {
      \  'buffers': 'tabsel',
      \  'linter_checking': 'left',
      \  'linter_warnings': 'warning',
      \  'linter_errors': 'error',
      \  'linter_ok': 'left',
      \ }
let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
let g:lightline#bufferline#show_number = 2
let g:lightline#bufferline#number_map = {
\ 0: '⁰', 1: '¹', 2: '²', 3: '³', 4: '⁴',
\ 5: '⁵', 6: '⁶', 7: '⁷', 8: '⁸', 9: '⁹'}

let g:lightline#bufferline#unnamed = '[unnamed]'

command! -bar LightlineUpdate    call lightline#init()|
  \ call lightline#colorscheme()|
  \ call lightline#update()

function! LightlineMode()
return &filetype ==# 'unite' ? 'Unite' :
	\ &filetype ==# 'denite' ? DeniteMode() :
	\ &filetype ==# 'help' ? 'Help' :
	\ &filetype ==# 'defx' ? 'Defx' :
	\ lightline#mode()
endfunction

function! MyInactiveFilename()
return &filetype !~# '\v(help|denite|defx)' ? expand('%:t') : LightlineMode()
endfunction


"lightlineに渡す変数の設定
augroup CharCounter
	autocmd!
	autocmd BufNew,BufEnter,FileWritePre,BufWrite,InsertLeave,CursorMoved,CursorMovedI * call <SID>LLvarCharCount()
	autocmd BufNew,BufEnter,FileWritePre,BufWrite,InsertLeave * call <SID>LLvarCharAllCount()
augroup END

let s:llcharcount = ''
let s:llcharallcount = ''

function! s:LLvarCharAllCount()
	let l:count = s:CharAllCount()
	if l:count == 0
		let l:shresult = '---'
    elseif l:count <10
        let l:shresult ='   ' . l:count
    elseif l:count <100
        let l:shresult ='  ' . l:count
	elseif l:count < 10000
		let l:shresult = l:count
	else
		let l:shresult = (l:count / 1000) . 'k'
	endif
	let s:llcharallcount = l:shresult
endfunction

function! s:LLvarCharCount()
    let l:CC = s:CharCount() < 10 ? '  ' . s:CharCount() :
	    \ s:CharCount() <100 ? ' ' . s:CharCount() : s:CharCount()
    let s:llcharcount = l:CC
endfunction

function! LLCharcount()
    if &filetype !~? 'vimfiler\|gundo|\defx|\denite' && winwidth(0) > 40
        return s:llcharcount . '/' . s:llcharallcount
    else
        return ''
    endif
endfunction

function! LightlineReadonly()
    return &readonly ? '⭤' : ''
endfunction
autocmd vimrc BufNew,BufEnter,FileWritePre,BufWrite * call <SID>llgit()

let s:ginabranch = ''

function! s:llgit()
if exists('*gitbranch#name')
	let s:ginabranch = gitbranch#name()
else
	let s:ginabranch = ''
endif
return s:ginabranch
endfunction

function! LLgitbranch()
  try
    if &filetype !~? 'vimfiler\|gundo' && strlen(s:ginabranch) && winwidth(0) > 40
      let _ = s:llgit()
      return strlen(_) && winwidth(0) > 100  ? '⭠ '._ :
	    \strlen(_) ? ' ⭠': ''
    endif
  catch
  endtry
  return ''
endfunction

function! MyFilepath()
  if &filetype ==# 'denite'
	return DeniteSources()
  else
	let l:ll_filepath = expand('%:~')
	let l:ll_filename = expand('%:t')
"パスの文字数とウィンドウサイズに応じて表示を変える
	let l:ll_fn = winwidth(0) > 70  && strlen(l:ll_filepath) > winwidth(0)-45 ? pathshorten(l:ll_filepath) :
	\ winwidth(0) > 70 ? l:ll_filepath  :
	\ winwidth(0) > 45 ? l:ll_filename  : ''
	let l:ll_modified = &modified ? '[+]' : ''
	return l:ll_fn . l:ll_modified
  endif
endfunction

function! DeniteMode()
    let l:mode_str=denite#get_status('raw_mode')
    call lightline#link(tolower(l:mode_str[0]))
    return l:mode_str
endfunction

function! DeniteSources()
    let l:sources = '['. denite#get_status('sources'). ']'
    let l:path =denite#get_status('path')
    let l:lilnenr = '-'. denite#get_status('linenr'). '-'
    let l:buffer = '['. denite#get_status('buffer_name'). ']'
    let denitesource =  l:lilnenr . l:buffer .l:sources . l:path
    if strlen(denitesource) > 100
        return l:sources .l:path
    else
        return denitesource
    endif
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! ProfileCursorMove() abort
  let profile_file = expand('~/log/vim-profile.log')
  if filereadable(profile_file)
    call delete(profile_file)
  endif

  normal! gg
  normal! zR

  execute 'profile start ' . profile_file
  profile func *
  profile file *

  augroup ProfileCursorMove
    autocmd!
    autocmd CursorHold <buffer> profile pause | q
  augroup END

  for i in range(100)
    call feedkeys('j')
  endfor
endfunction

"}}}
"-----------------------------------------------------------------------
"deoplete
"{{{
" Use deoplete.
autocmd vimrc VimEnter * call s:deoplete_setting()
autocmd vimrc InsertEnter * call deoplete#enable()

function! s:deoplete_setting()
let g:deoplete#enable_at_startup = 0
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#mappings#manual_complete()
function! s:check_back_space() abort"{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction"}}}
" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr><C-g>       deoplete#refresh()
inoremap <expr><C-e>       deoplete#cancel_popup()
inoremap <silent><expr><C-l>       deoplete#complete_common_string()
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
  return pumvisible() ? deoplete#close_popup()."\<CR>" : "\<CR>"
endfunction

call deoplete#custom#source('_', 'matchers',
      \ ['matcher_fuzzy', 'matcher_length'])
" call deoplete#custom#source('buffer', 'mark', '')
" call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])
" call deoplete#custom#source('_', 'disabled_syntaxes', ['Comment', 'String'])
" call deoplete#custom#source('buffer', 'mark', '*')

call deoplete#custom#source('look', 'filetypes', ['help', 'gitcommit'])
call deoplete#custom#option('ignore_sources',
      \ {'_': ['around', 'buffer', 'tag', 'dictionary']})
call deoplete#custom#source('_', 'converters', [
      \ 'converter_remove_paren',
      \ 'converter_remove_overlap',
      \ 'matcher_length',
      \ 'converter_truncate_abbr',
      \ 'converter_truncate_menu',
      \ 'converter_auto_delimiter',
      \ ])
call deoplete#custom#option('keyword_patterns', {
      \ '_': '[a-zA-Z_]\k*\(?',
      \ 'tex': '[^\w|\s][a-zA-Z_]\w*',
      \ })
inoremap <silent><expr> <C-tab> deoplete#manual_complete('file')

call deoplete#custom#option({
      \ 'smart_case': v:true ,
      \ 'auto_complete_delay': 0,
      \ 'auto_refresh_delay': 1,
      \ 'camel_case': v:true,
      \ 'skip_multibyte': v:true,
      \ 'prev_completion_mode': 'length',
      \ 'max_list': 50
      \ })
endfunction
"}}}"
"-----------------------------------------------------------------------
"neosnippet
"{{{
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <expr><TAB>
 \ pumvisible() ? "\<C-n>" :
 \ neosnippet#expandable_or_jumpable() ?
 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
" For conceal markers.
"if has('conceal')
"  set conceallevel=2
"endif
"}}}
"-----------------------------------------------------------------------
"Gundo
let g:gundo_prefer_python3 = 1
let g:gundo_auto_preview = 0
let g:gundo_help = 0
let g:gundo_width = 30
let g:gundo_preview_height = 10
let g:gundo_preview_bottom = 1
nmap U :<C-u>GundoToggle<CR>
"-----------------------------------------------------------------------
"Indent-guides
let g:indent_guides_exclude_filetypes = ['help', 'defx']
"-----------------------------------------------------------------------
"ALE
"{{{
"https://efcl.info/2015/09/10/introduce-textlint/
"https://koirand.github.io/blog/2018/textlint/
"vint: pip install --pre vim-vint
"preset-ja-technical-writing
"npm install textlint-rule-preset-ja-technical-writing@beta
let g:ale_use_global_executables=1
let g:ale_linters = {
    \ 'markdown': ['textlint'],
    \ 'vim':['vint'],
    \ 'text':['textlint']
    \ }
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_sign_column_always = 1
let g:ale_lint_delay = 5000
let g:ale_lint_on_enter = 0
let g:ale_open_list = 0
let g:ale_keep_list_window_open = 0
let g:ale_sign_error = '!!'
let g:ale_sign_warning = '=='
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_statusline_format = ['E:%d', 'W:%d', 'ok']
"}}}
"-----------------------------------------------------------------------
"colorscheme-plugin
autocmd vimrc Colorscheme gruvbox let g:gruvbox_contrast_dark = 'medium'
autocmd vimrc Colorscheme gruvbox let g:gruvbox_italicize_comments = 0
autocmd vimrc Colorscheme gruvbox let g:gruvbox_invert_selection = 0
autocmd vimrc Colorscheme gruvbox let g:gruvbox_guisp_fallback = 'bg'
"colorscheme hybrid
colorscheme gruvbox
set background=dark

"========================================================================
"Gvim
if has('GUI')
    set clipboard=unnamed
    let &guioptions = substitute(&guioptions, '[TMrRlLbeg]', '', 'g')
"    set guioptions-=TMrRlLbeg
    set guioptions+=MC
    "ツールバー非表示
    set lines=40 "ウィンドウの縦幅
    set columns=150 " ウィンドウの横幅
    winpos 50 30 " ウィンドウの起動時の位置
    set cmdheight=1 "コマンドライン行数の設定
    set cursorline
    hi clear CursorLine
    ""Nm秒後にカーソル点滅開始
    set guicursor=n:blinkwait2000
    "フォント
    "ConsolasにPowerlineSymbolsをパッチしてある
    "https://qiita.com/s_of_p/items/b7ab2e4a9e484ceb9ee7
"    set guifont=Consolas:h11:cDEFAULT
"    set guifontwide=MS_Gothic:h12:cDEFAULT
    set guifont=Ricty_Diminished_for_Powerline:h13:cDEFAULT
    set guifontwide=Ricty_Diminished_for_Powerline:h13:cDEFAULT
    set renderoptions=type:directx,renmode:5,geom:2
    set ambiwidth=double
else
    set t_Co=256
    set termguicolors
endif

if has('kaoriya')
    "autodate
    let autodate_format ='%Y/%m/%d-%H:%M:%S'
    let autodate_lines = 10
    "フルスクリーン化
    nnoremap <C-CR> :ScreenMode 6<CR>
    nnoremap <S-CR> :ScreenMode 1<CR>
    "背景透過
    autocmd vimrc GUIEnter * set transparency=245
endif
autocmd vimrc VimEnter * imap <C-k> <Plug>(eskk:toggle)
autocmd vimrc VimEnter * cmap <C-k> <Plug>(eskk:toggle)

if has('vim_starting')
	let g:eskk_dictionary = '~/.skk-jisyo'
endif

let g:eskk_debug = 0
let g:eskk_egg_like_newline = 1
let g:eskk_revert_henkan_style = "okuri"
let g:eskk_enable_completion = 0
let g:eskk#large_dictionary = { 'path': "~/.eskk/SKK-JISYO.M", 'sorted': 1, 'encoding': 'euc-jp', }
"-----------------------------------------------------------------------
"vim:set foldmethod=marker:
