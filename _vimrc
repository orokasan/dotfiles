"ork's _vimrc for Windows
"今夜使いたいkey mapping
"ciw => カーソル上の単語を削除してインサートモード
"ci' => シングルクォート内のテキストを削除してインサートモード
"vim正規表現
"https://qiita.com/kawaz/items/d0708a4ab08e572f38f3
"========================================================================
"基本設定 {{{
"encode
set encoding=utf-8			" vim 内部のエンコーディグ
scriptencoding utf-8,cp932		" vimrcのエンコーディング
set fileencoding=utf-8			" 既定のファイル保存エンコーディング
set fileencodings=utf-8,ucs-bom,iso-2022-jp-3,euc-jisx0213,euc-jp,cp932
" ------------------------------------------------------------------------------
" reset vimrc autocmd group
augroup vimrc
  autocmd!
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
"Python,vimproc
"メモ
"インストールはAll Userで
"pipからneovim, greenletを導入 Visual Studio C++ 14.0が必要
"参考:https://gammasoft.jp/python/python-version-management/
"kaoriya-vimのpythonに揃える
"64bit版を使用する
set runtimepath+="C:\Program Files\Python37"
let g:python_host_prog ='C:\Program Files (x86)\Python2.7\python.exe'
let g:python3_host_prog ='C:\Program Files\Python37\python.exe'
"vimprocのダウンロード(for Win)
let g:vimproc#download_windows_dll = 1
"}}}
"========================================================================================
"外観  {{{

set shortmess+=IaT
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
" ビープ音を可視化
set visualbell

if has('nvim')
  " Display candidates by popup menu.
  set wildmenu
  set wildmode=full
  set wildoptions+=pum
else
  " Display candidates by list.
  set nowildmenu
  set wildmode=list:longest,full
endif
"
" Adjust window size of preview and help.
set previewheight=8
set helpheight=20

set ttyfast

"全角スペースを表示
"コメント以外で全角スペースを指定しているので "scriptencoding"と、
"このファイルのエンコードが一致するよう注意！
"デフォルトのZenkakuSpaceを定義
"function! ZenkakuSpace()
"  highlight ZenkakuSpace cterm=underline ctermfg=darkgrey gui=underline guifg=darkgrey
"endfunction
"一時的にバッファを最大化
"function! s:toggle_window_zoom() abort
"    if exists('t:zoom_winrestcmd')
"        execute t:zoom_winrestcmd
"        unlet t:zoom_winrestcmd
"    else
"        let t:zoom_winrestcmd = winrestcmd()
"        resize
"        vertical resize
"    endif
"endfunction
"nnoremap <silent> <Plug>(my-zoom-window)
"      \ :<C-u>call <SID>toggle_window_zoom()<CR>
"nmap <Leader>wz <Plug>(my-zoom-window)
"nmap <Leader>w<C-z> <Plug>(my-zoom-window)

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
"入力・編集 {{{

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
set matchpairs+=（:）,「:」,『:』,【:】,［:］,＜:＞
"set spelllang=en,cjk
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
"autocmd! FileType markdown hi! def link markdownItalic Normal
autocmd vimrc FileType markdown set commentstring=<\!--\ %s\ -->

"folding設定
setlocal foldmethod=marker
"viminfo設定(nvimと設定分ける)
if has('nvim')
  set shada=!,'300,<50,s10,h
else
  set viminfo=!,'300,<50,s10,h
endif
" Set minimal height for current window.
" set winheight=20
set winheight=1
" Set maximam maximam command line window.
set cmdwinheight=5
" No equal window size.
set noequalalways

"いい感じに折りたたみ状態を保存 {{{
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
  autocmd MyAutoCmd BufWinLeave * call s:mkview()
  autocmd MyAutoCmd BufReadPost * call s:loadview()
augroup END
"}}}
" Make directory automatically. {{{
" --------------------------------------
" http://vim-users.jp/2011/02/hack202/
autocmd MyAutoCmd BufWritePre *
      \ call s:mkdir_as_necessary(expand('<afile>:p:h'), v:cmdbang)
function! s:mkdir_as_necessary(dir, force) abort
  if !isdirectory(a:dir) && &l:buftype ==# '' &&
        \ (a:force || input(printf('"%s" does not exist. Create? [y/N]',
        \              a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction
"}}}

"日本語入力固定モード
"IM-control.vimが必要
"https://sites.google.com/site/fudist/Home/vim-nihongo-ban/vim-japanese/ime-control
"eskk.vimと干渉するため停止している
let g:disable_IM_Control = 1

if !exists('g:disable_IM_Control')
" 「日本語入力固定モード」切替キー
    inoremap <silent> <C-k> <C-^><C-r>=IMState('FixMode')<CR>
endif

"}}}
"========================================================================
"Key mapping {{{

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
" TABで対応ペアにジャンプ
nnoremap <Tab> %
xnoremap <Tab> %
" 折り返し時に表示行単位での移動できるようにする
nnoremap  j gj
nnoremap  k gk
"CTRL-sで保存！
imap <c-s> <Esc>:w<CR>a
"CTRL-qでclose
nnoremap <silent> <C-q> :close<CR>
" For JIS keyboard
inoremap <C-@> <ESC>
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
"_vimrcを開く
noremap <silent> <leader>vme :e ~/dotfiles/?vimrc<CR>
"開いているfileを読み込む
noremap <Leader>ss :<C-u>source %<CR>
"lでfoldingを展開
nnoremap <expr>l foldclosed('.') != -1 ? 'zo' : 'l'
"CTRL-SPACEで閉じる
nnoremap <silent><C-Space> :<C-u>call <SID>smart_foldcloser()<CR>
function! s:smart_foldcloser() "{{{
  if foldlevel('.') == 0
    norm! zM
    return
  endif

  let foldc_lnum = foldclosed('.')
  norm! zc
  if foldc_lnum == -1
    return
  endif

  if foldclosed('.') != foldc_lnum
    return
  endif
  norm! zM
endfunction
"}}}

"画面分割マッピング
nnoremap <leader>ws :sp<CR>:bprev<CR>
nnoremap <leader>wv :vsp<CR>:bprev<CR>
nnoremap <leader>wc :close<CR>
nnoremap <leader>wn :vne<CR>
nnoremap <leader>wo :only<CR>
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
"dein.vim {{{
set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim

 let s:toml      = '~/dotfiles/dein.toml'
 let s:lazy_toml = '~/dotfiles/dein_lazy.toml'

if dein#load_state('$HOME/.cache/dein')
    call dein#begin('~/.cache/dein')
        call dein#load_toml(s:toml,      {'lazy': 0})
        call dein#load_toml(s:lazy_toml, {'lazy': 1})
    call dein#end()
    call dein#save_state()
endif

filetype plugin indent on
syntax enable
"}}}
"-----------------------------------------------------------------------
"文字数カウント "{{{
"1行カウント
function! g:CharCount()
	let l:line = getline(line('.'))
	let l:result =  strlen(substitute(l:line, '.', 'x','g'))
	return l:result
endfunction

"全体カウント
function! g:CharAllCount()
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
	echo ' [WordCount] -- ' . l:result . ' : ' . g:CharAllCount() .
				\ ' -- [選択行の字数:全体の字数]'
endfunction
"呼び出す
command! -range LineCharVCount <line1>,<line2>call g:LineCharVCount()
xnoremap<silent> ; :LineCharVCount<CR>
"}}}
"-----------------------------------------------------------------------
"lightline {{{
"lightline-bufferline
"lightline-ale
let g:lightline = {
\ 'colorscheme': 'iceberg',
    \ 'active': {
        \ 'left': [ [ 'mode', 'paste' ],['eskk','gitbranch'], [ 'readonly', 'relativepath'] ],
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
        \'charcount':'LLCharcount',
        \'eskk': 'LLeskk'
    \ }
\ }

"if has('GUI')
    let g:lightline.separator =  { 'left': '⮀', 'right': '⮂' }
    let g:lightline.subseparator = { 'left': '⮁', 'right': '⮃' }
"endif

if exists('g:disable_IM_Control') && g:disable_IM_Control == 1
    let g:lightline.component = {
        \'lineinfo':'%-2v:%3l'
        \}
else
    let g:lightline.component = {
        \'lineinfo':'%-2v:%3l',
        \'IMEstatus':'%{IMStatus("-JP-")}'
        \}
endif

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
    \ &filetype ==# 'gundo' ? 'Gundo' :
    \ &filetype ==# 'tweetvim' ? 'Tweetvim' :
    \ lightline#mode()
endfunction

function! LLeskk()
    if exists('*eskk#is_enabled') && &filetype !~? '\v(vimfiler|gundo|defx|tweetvim|denite)'
        if eskk#is_enabled()
            return printf(get(a:000, 0, '[%s]'),
                \ get(g:eskk#statusline_mode_strings,
                \ eskk#get_current_instance().mode, '??'))
        elseif mode() !=# 'i'
            return s:eskk_insert_status ? printf('[あ]')
                \ : s:eskk_inserton ? printf('[あ]') : printf('[--]')
        else
            return printf('[--]')
        endif
    else
        return ''
    endif
endfunction

function! MyInactiveFilename()
return &filetype !~# '\v(help|denite|defx|tweetvim)' ? expand('%:t') : LightlineMode()
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
    let l:count = g:CharAllCount()
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
    let l:CC = g:CharCount() < 10 ? '  ' . g:CharCount() :
        \ g:CharCount() <100 ? ' ' . g:CharCount() : g:CharCount()
    let s:llcharcount = l:CC
endfunction

function! LLCharcount()
    if &filetype !~? '\v(vimfiler|gundo|defx|tweetvim|denite)'
        \ && winwidth(0) > 40
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
elseif &filetype !~? 'vimfiler\|gundo|\defx\|tweetvim'
    let l:ll_filepath = expand('%:~')
    let l:ll_filename = expand('%:t')
"パスの文字数とウィンドウサイズに応じて表示を変える
    let l:ll_fn = winwidth(0) < 65 ? '' :
        \ strlen(l:ll_filepath) > winwidth(0)-65 ? pathshorten(l:ll_filepath) :
        \  l:ll_filepath
    let l:ll_modified = &modified ? '[+]' : ''
    return l:ll_fn . l:ll_modified
else
    return ''
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
"eskk.vim"{{{
if has('vim_starting')
	let g:eskk_dictionary = '~/dotfiles/.skk-jisyo'
endif

"InsertLeaveイベント上で他プラグインと干渉する(順序の問題?)
"=> vimrcをリロードすると動作しなくなる
"リセットのタイミングを変えることで直った(?)
if !exists('eskkautocmd_loaded')
  let autocommands_loaded = 1
    autocmd InsertLeave * call <SID>eskk_status()
    autocmd InsertEnter * call <SID>eskk_insert_config()
endif
function! s:eskk_status() abort
    if eskk#is_enabled()
         let s:eskk_inserton = 1
    else
        let s:eskk_inserton = ''
    endif
endfunction

let s:eskk_inserton = ''
function! s:eskk_insert_config() abort
    if s:eskk_inserton || s:eskk_insert_status
        call eskk#enable()
    endif
endfunction

let s:eskk_insert_status = ''
nnoremap <silent><expr><C-y> <SID>eskk_inserttoggle()
function! s:eskk_inserttoggle() abort
    if s:eskk_insert_status || s:eskk_inserton
        let s:eskk_insert_status = 0
        let s:eskk_inserton = 0
        echo 'eskk status off'
    else
        let s:eskk_insert_status = 1
        echo 'eskk status on'
    endif
endfunction

let g:eskk#debug = 0
let g:eskk#show_annotation = 1
let g:eskk#rom_input_style = 'msime'
let g:eskk#egg_like_newline = 1
let g:eskk#egg_like_newline_completion = 1
let g:eskk#tab_select_completion = 1
let g:eskk_revert_henkan_style = 'okuri'
let g:eskk#large_dictionary = {'path': '~/.eskk/SKK-JISYO.L', 'sorted': 1, 'encoding': 'euc-jp', }

let g:eskk#cursor_color = {
\   'ascii': '#b4be82',
\   'hira': '#e28878',
\   'kata': '#84a0c6',
\   'abbrev': '#4169e1',
\   'zenei': '#ffd700',
\}

autocmd MyAutoCmd User eskk-initialize-post
      \ EskkMap -remap jj <ESC>
autocmd MyAutoCmd User eskk-initialize-pre call s:eskk_initial_pre()
function! s:eskk_initial_pre() abort
  let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
  call t.add_map('z ', '　')
  call t.add_map('~', '〜')
  call t.add_map('zc', '©')
  call t.add_map('zr', '®')
  call t.add_map('z9', '（')
  call t.add_map('z0', '）')
  call eskk#register_mode_table('hira', t)
endfunction
"}}}
"-----------------------------------------------------------------------
"colorscheme-plugin {{{
colorscheme iceberg
"colorscheme hybrid
"colorscheme gruvbox
set background=dark
"}}}
"========================================================================
"Gvim {{{
if has('GUI')
    set clipboard=unnamed
    let &guioptions = substitute(&guioptions, '[TMrRlLbeg]', '', 'g')
"    set guioptions-=TMrRlLbeg
    set guioptions+=!MC
    "ツールバー非表示
    set lines=50 "ウィンドウの縦幅
    set columns=220 " ウィンドウの横幅
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
    colorscheme iceberg
endif
"}}}
"========================================================================
"+kaoriya {{{
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
"IME状態でカーソルカラー変更
if has('multi_byte_ime')
  highlight CursorIM guifg=NONE guibg=Purple
endif

"}}}
"vim:set foldmethod=marker:
