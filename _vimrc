"ork's _vimrc for Windows
"今夜使いたいkey mapping
"*t) =>前方の)の手前まで削除して*
"aw =>1単語の範囲
"ap =>段落の範囲
"<C-t>&<C-d>=> インデント増減
"vim正規表現
"https://qiita.com/kawaz/items/d0708a4ab08e572f38f3
"========================================================================
"基本設定 {{{
"
"encode
set encoding=utf-8         "vim 内部のエンコーディグ
if !has('nvim')
scriptencoding utf-8,cp932 "vimrcのエンコーディング
else
scriptencoding utf-8
endif
set fileencoding=utf-8     " 既定のファイル保存エンコーディング
set fileencodings=utf-8,ucs-bom,iso-2022-jp-3,euc-jisx0213,euc-jp,cp932
set runtimepath+=~/.fzf
set runtimepath+=~/vimfiles
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
let g:loaded_godoc = 1
"========================================================================
"Python,vimproc
"メモ
"インストールはAll Userで
"pipからneovim, greenletを導入 Visual Studio C++ 14.0が必要
"参考:https://gammasoft.jp/python/python-version-management/
"kaoriya-vimのpythonに揃える
"64bit版を使用する
"set runtimepath+='~/vimfiles'
if has('win64')
    let g:python3_host_prog ='python.exe'
endif
"vimprocをダウンロード(for Win)
let g:vimproc#download_windows_dll = 1
"}}}
"========================================================================
"外観  {{{
set shortmess+=aAcsT
set showtabline=2   "常にタブラインを表示
set number          "行番号を表示
set signcolumn=yes  "signcolumを常に表示
set laststatus=2    " ステータスラインを常に表示
set cmdheight=1     "コマンドライン行数の設定
set noshowcmd       " 入力中のコマンドをステータスに表示しない
set noshowmode      "モードを表示しない
set cursorline      "cusorlineをハイライト
set list                    "不可視文字の可視化
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%
"cursorlineのhighlight syntaxを消す(行番号ハイライトのみにする)
autocmd vimrc ColorScheme *  hi clear CursorLine
set modelines=5     "モードライン設定
set showmatch       "括弧入力時の対応する括弧を表示
set matchtime=1     "括弧のハイライト時間(ミリ秒)
set lazyredraw
set visualbell      "ビープを停止
set t_vb=
set noerrorbells
set hidden          " バッファが編集中でもその他のファイルを開けるように
" ESC連打でハイライト解除
nmap<silent> <Esc><Esc> :nohlsearch<CR>
nmap<silent> <C-c><C-c> :nohlsearch<CR>
" Display candidates by list.
set wildmenu
set wildmode=longest:full,full
set previewheight=8 " Adjust window size of preview 
set helpheight=15 "and help.
set ttyfast
"補完ポップアップの最大数
set pumheight=10
if has('GUI')
    let &guioptions = substitute(&guioptions, '[mTrRlLbeg]', '', 'g')
    set guioptions+=M
    let no_buffers_menu = 1
endif

"全角スペースを表示
"コメント以外で全角スペースを指定しているので "scriptencoding"と、
"このファイルのエンコードが一致するよう注意！
"デフォルトのZenkakuSpaceを定義
"function! ZenkakuSpace()
"  highlight ZenkakuSpace cterm=underline ctermfg=darkgrey gui=underline guifg=darkgrey
"endfunction

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
set virtualedit=block       " カーソルを文字が存在しない部分でも動けるようにする
"set virtualedit=onemore "行末の1文字先までカーソルを移動できるように
set scrolloff=5             "3行余裕を持たせてスクロール
set display=lastline        "長い行をいい感じに表示
"日本語の文章構造に対応するやつ
set matchpairs+=（:）,「:」,『:』,【:】,［:］,＜:＞
"set spelllang=en,cjk
set swapfile              " スワップファイルを作らない/作る
set directory=~/vimfiles/swap
set autoread                " 編集中のファイルが変更されたら自動で読み直す
set undodir=~/vimfiles/undo "Undoファイルをまとめる
set nobackup                  "backupファイルを作成
"set backupdir=~/vimfiles/backup

set textwidth=0             "自動改行をやめる
set formatoptions+=mMj      "日本語の行の連結時には空白を入力しない。など
set tabstop=4               "<TAB>空白の表示設定
set expandtab
set softtabstop=4           "<TAB>の空白変換数
let g:vim_indent_cont = 4
set autoindent              "自動インデント
set shiftwidth=4            "vimが自動でインデントを行った際、設定する空白数

set ignorecase              " 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set smartcase               " 検索文字列に大文字が含まれている場合は区別して検索する
set incsearch               " 検索文字列入力時に順次対象文字列にヒットさせる
set gdefault
set wrapscan                " 検索時に最後まで行ったら最初に戻る
set hlsearch                " 検索語をハイライト表示

"Markdown用設定
"autocmd! FileType markdown hi! def link markdownItalic Normal
autocmd vimrc FileType markdown set commentstring=<\!--\ %s\ -->

"folding設定
setlocal foldmethod=marker
"
"viminfo設定(nvimと設定分ける)
if has('nvim')
    set shada=!,'300,<50,s10,h,rA:,rB:
else
  set viminfo=!,'300,<50,s10,h
endif
" Set minimal height for current window.
set winheight=1
set winwidth=1
" Set maximam maximam command line window.
set cmdwinheight=5
" No equal window size.
set noequalalways
"ctags設定
set tags=vim.tags
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
"
let g:disable_IM_Control = 1
if !exists('g:disable_IM_Control')
" 「日本語入力固定モード」切替キー
    inoremap <silent> <C-k> <C-^><C-r>=IMState('FixMode')<CR>
endif
"}}}
"========================================================================
"Key mapping {{{

let mapleader = "\<Space>"
"いい感じに挿入
nnoremap <expr>i len(getline('.')) == 0 ? "cc" : "i"
"行頭、行末への移動
nnoremap 0 ^
xnoremap 0 ^
nnoremap ^ 0
xnoremap ^ 0
nnoremap 4 $
xnoremap 4 $
" Create a blank line above/below current line
nnoremap <leader>j o<ESC>k
nnoremap <leader>k O<ESC>j
" Convenience key for getting to command mode
nnoremap ; :
" Enter normal mode
inoremap jk <esc>
nnoremap m '
"末尾までヤンク
nnoremap Y y$
xnoremap Y y$
nnoremap vv 0v$
nmap <Tab> %
vmap <Tab> %
"Qでマクロ
nnoremap Q q
xnoremap Q q
" 折り返し時に表示行単位での移動できるようにする
nnoremap <silent>j gj
nnoremap <silent>k gk
nnoremap J gJ
nnoremap gJ J
" colorcolumn
nnoremap <expr><Leader>cl
    \ ":\<C-u>set colorcolumn=".(&cc == 0 ? v:count == 0 ? virtcol('.') : v:count : 0)."\<CR>"
" 。、に移動(f<C-K>._ を打つのは少し長いので)。cf<C-J>等の使い方も可。
"function! s:MapFT(key, char)
"    for cmd in ['f', 'F', 't', 'T']
"        execute 'noremap <silent> ' . cmd . a:key . ' ' . cmd . a:char
"    endfor
"endfunction
"call <SID>MapFT('<C-J>', '。')
"call <SID>MapFT('<C-U>', '、')
"" 前/次の「。、」の後に改行を挿入する
"nnoremap <silent> f<C-H> f。a<CR><Esc>
"nnoremap <silent> f<C-L> f、a<CR><Esc>
"nnoremap <silent> F<C-H> F。a<CR><Esc>
"nnoremap <silent> F<C-L> F、a<CR><Esc>
"nnoremap <silent> f<C-M> :call search('[、。]')<CR>a<CR><Esc>
"nnoremap <silent> F<C-M> :call search('[、。]', 'b')<CR>a<CR><Esc>
" 空行単位移動
vnoremap <C-j> }
vnoremap <C-k> {
tnoremap <C-[> <C-\><C-n>
tnoremap <Esc> <C-\><C-n>
inoremap <c-s> <Esc>:w<CR>a
nnoremap <silent><C-q> :bd<CR>
nnoremap <silent>q :close<CR>
"日付を入力(+kaoriya限定)
inoremap <F3> Last Change: .
"日付を入力
inoremap <expr><F2> strftime("%Y%m%d")
cnoremap <expr><F2> strftime("%Y%m%d")
" x でレジスタを使わない
nnoremap x "_x
"ddでヤンク
nnoremap dd "+dd
" スペルチェック
nnoremap <Leader>. :<C-u>setl spell! spell?<CR>
"検索メッセージを非表示
nnoremap <silent> n n
nnoremap <silent> N N
" <ESC>でのIME状態保存を無効化
inoremap <silent><ESC> <ESC>
inoremap <silent><C-[> <ESC>
inoremap <silent><C-c> <ESC>
"_vimrcを開く
noremap <silent> <leader>v :e ~/dotfiles/?vimrc<CR>
"開いているVimscriptを読み込む
nnoremap <Leader>ss :<C-u>call <SID>source_script('%')<CR>
if !exists('*s:source_script')  "{{{
  function s:source_script(path) abort
    let path = expand(a:path)
    if !filereadable(path) || getbufvar(a:path, '&filetype') !=# 'vim'
      return
    endif
    execute 'source' fnameescape(path)
    echo printf(
          \ '"%s" has sourced (%s)',
          \ simplify(fnamemodify(path, ':~:.')),
          \ strftime('%c'),
          \)
  endfunction
endif  "}}}
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
""Shift-l, Shift-hで行末, 行頭に移動
"nnoremap <S-l> <End>
"nnoremap <S-h> <Home>
" インサートモード時はちょっとemacs like なキーバインド
inoremap <C-f> <Right>|			" C-f で左へ移動
inoremap <C-b> <Left>|			" C-b で右へ移動
inoremap <C-h> <BS>|			" C-h でバックスペース
inoremap <C-a> <HOME>
inoremap <C-e> <END>
"window移動
nnoremap <C-h> <C-w>h|			" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-j> <C-w>j|			" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-k> <C-w>k|			" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-l> <C-w>l|			" Ctrl + hjkl でウィンドウ間を移動
"windowサイズ変更
nnoremap <S-Left>  <C-w><
nnoremap <S-Right> <C-w>>
nnoremap <S-Up>    <C-w>-
nnoremap <S-Down>  <C-w>+
"一時的にバッファを最大化
nnoremap <silent> <Plug>(my-zoom-window)
      \ :<C-u>call <SID>toggle_window_zoom()<CR>
nmap <Leader>wz <Plug>(my-zoom-window)
function! s:toggle_window_zoom() abort "{{{
    if exists('t:zoom_winrestcmd')
        execute t:zoom_winrestcmd
        unlet t:zoom_winrestcmd
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
    endif
endfunction  "}}}
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
nnoremap <silent><C-p> :Bclose<CR>
"Markdown Docx出力
"pandocが必要
if has('mac')
    "nnoremap <Leader>pd <C-u>:!pandoc -f markdown+ignore_line_breaks -t docx --reference-doc='/Users/ork/.pandoc/reference.docx' -o '%:p:r.docx' '%:p'<CR>
    nnoremap <Leader>pd <C-u>:!pandoc -f markdown+ignore_line_breaks -t docx --reference-doc=reference.docx -o '%:p:r.docx' '%:p'<CR>
else
    nnoremap <Leader>pd <C-u>:!start /min pandoc "%:p" -o "%:p:r.docx" --filter pandoc-crossref<CR>
endif

"}}}

"========================================================================
"+kaoriya {{{
if has('kaoriya')
    "autodate 'Last Change: .'
    let autodate_format ='%Y/%m/%d-%H:%M:%S'
    let autodate_lines = 10
    "フルスクリーン化
    nnoremap <C-CR> :ScreenMode 6<CR>
    nnoremap <S-CR> :ScreenMode 1<CR>
    "背景透過
    autocmd vimrc GUIEnter * set transparency=235
endif

set termguicolors    " ターミナルでも True Color を使えるようにする。
if has('nvim')
    set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
    set clipboard=unnamed
    "float windowで補完するための設定
    set completeopt-=preview
    set wildoptions=pum
endif
"IME状態でカーソルカラー変更
if has('multi_byte_ime')
  highlight CursorIM guifg=NONE guibg=Purple
endif
"}}}
"========================================================================
"dein.vim {{{
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
      if !isdirectory(s:dein_repo_dir)
        echo 'install dein.vim ...'
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
      endif
 execute 'set runtimepath+=' .fnamemodify(s:dein_repo_dir, ':p')
endif

let s:toml      = '~/dotfiles/dein.toml'
let s:lazy_toml = '~/dotfiles/dein_lazy.toml'
let s:myvimrc = expand('$MYVIMRC')

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir,s:myvimrc)
    call dein#load_toml(s:toml,      {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})
    call dein#end()
    call dein#save_state()

    if !has('vim_starting')
        call dein#call_hook('source')
        call dein#call_hook('post_source')
    endif
endif

filetype plugin indent on
syntax enable

command! -nargs=0 -complete=command DeinInstall  call dein#install()
command! -nargs=0 -complete=command DeinUpdate call dein#update()
command! -nargs=0 -complete=command DeinRecache call dein#recache_runtimepath() |echo "Recache Done"
"}}}
"-----------------------------------------------------------------------
"lightline {{{
"lightline-bufferline
"lightline-ale
let g:lightline = {
\ 'colorscheme': 'iceberg',
    \ 'active': {
        \ 'left': [ ['mode', 'paste'],['eskk','denitebuf','git'], [ 'readonly', 'path'] ],
        \ 'right': [ ['lineinfo'],
            \ ['charcount'], [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok', 'percent','IMEstatus']
        \ ]
    \ },
    \ 'inactive': {
        \ 'left': [['inactivefn','denitebuf','denitesource']],
        \ 'right': [[ 'percent' ]]
    \ },
    \ 'tabline' : {
    \ 'left': [['buffers']], 
    \ 'right': [ ['winnr'],['fileencoding','filetype'] ]
    \ },
    \ 'component':{
    \},
    \ 'component_function': {
        \ 'readonly':'LLReadonly',
        \ 'denitebuf': 'LLDeniteBuffer',
        \ 'inactivefn':'LLInactiveFilename',
        \ 'path':'LLMyFilepath',
        \ 'mode': 'LLMode',
        \ 'charcount':'LLCharcount',
        \ 'eskk': 'LLeskk',
        \ 'git':'LLgit',
        \ 'lineinfo':'LLlineinfo',
        \ 'denitesource' : 'LLDeniteSource'
    \ },
    \ 'component_expand': {
        \ 'buffers': 'lightline#bufferline#buffers',
        \ 'linter_checking': 'lightline#ale#checking',
        \ 'linter_warnings': 'lightline#ale#warnings',
        \ 'linter_errors': 'lightline#ale#errors',
        \ 'linter_ok': 'lightline#ale#ok'
    \ },
   \ 'component_type' : {
        \ 'buffers': 'tabsel',
        \ 'linter_checking': 'middle',
        \ 'linter_warnings': 'warning',
        \ 'linter_errors': 'error',
        \ 'linter_ok': 'middle'
    \ }
\ }
if !has('nvim')
    let g:lightline.subseparator= { 'left': '', 'right': '' }
    let g:lightline.separator= { 'left': '', 'right': '' }
endif
"   let g:lightline.separator= { 'left': '', 'right': '' }
"   let g:lightline.subseparator= { 'left': '', 'right': '' }
"    let g:lightline.separator =  { 'left': '⮀', 'right': '⮂' }
"    let g:lightline.subseparator = { 'left': '⮁', 'right': '⮃' }
let g:component_function_visible_condition = {
        \ 'readonly': 1,
        \ 'denitebuf': 1,
        \ 'inactivefn': 1,
        \ 'path': 1, 
        \ 'mode': 1,
        \ 'charcount': 1,
        \ 'eskk': 1,
        \ 'git': 1,
        \ 'lineinfo': 1
        \ }
 
let g:lightline.tabline_subseparator= { 'left': '', 'right': '' }
let g:lightline.tabline_separator= { 'left': '', 'right': '' }

if exists('g:disable_IM_Control') && g:disable_IM_Control == 1
else
    let g:lightline.component += {
        \'IMEstatus':'%{IMStatus("-JP-")}'
        \}
endif

let g:lightline#bufferline#unnamed = '[unnamed]'
let g:lightline#bufferline#filename_modifier = ':t'
let g:lightline#bufferline#show_number = 2
let g:lightline#bufferline#number_map = {
\ 0: '⁰', 1: '¹', 2: '²', 3: '³', 4: '⁴',
\ 5: '⁵', 6: '⁶', 7: '⁷', 8: '⁸', 9: '⁹'}

function! LLMode()
return &filetype ==# 'unite' ? 'Unite' :
    \ &filetype ==# 'help' ? 'Help' :
    \ &filetype ==# 'denite' ? 'Denite' :
    \ &filetype ==# 'defx' ? 'Defx' :
    \ &filetype ==# 'gundo' ? 'Gundo' :
    \ &filetype ==# 'tweetvim' ? 'Tweetvim' :
    \ lightline#mode()
endfunction
"例外filetype
let s:ignore_filetype = '\v(vimfiler|gundo|defx|tweetvim|denite|denite-filter)'

function! LLInactiveFilename()
    return &filetype !~# s:ignore_filetype ? expand('%:t') : LLMode()
endfunction

function! LLeskk() abort
    if &filetype ==# 'denite-filter'
        return exists('*LLmyeskk') ? LLmyeskk() : ''
    else
        return &filetype !~# s:ignore_filetype && exists('*LLmyeskk') ? LLmyeskk() : ''
    endif
endfunction

function! LLlineinfo() abort
    let l:col = col('.')
    let l:fixedcol = l:col <10 ? '  ' . l:col :
        \ l:col <100 ? ' ' . l:col : l:col
    
    if &filetype !~# s:ignore_filetype
        return winwidth(0) > 65 ?
            \  printf('%s:%d#%d', l:fixedcol , line('.') , line('$') ) :
            \  printf('%s:%d', l:fixedcol , line('.') )
        else
            return printf('%d:%d', col('.') , line('.') )
        endif
endfunction

"lightlineに渡す変数の設定
augroup CharCounter
    autocmd!
    autocmd BufNew,BufEnter,TextChanged,CursorMoved,CursorMovedI * call <SID>llvarCharCount()
    autocmd BufNew,BufEnter,FileWritePre,BufWrite,InsertLeave * call <SID>llvarCharAllCount()
augroup END

let s:llcharcount = ''
let s:llcharallcount = ''

function! s:llvarCharAllCount()
    let l:count = g:CharAllCount()
    let s:llcharallcount = l:count == 0 ?   '***' :
        \ l:count <10 ? '   ' . l:count :
        \ l:count <100 ? '  ' . l:count :
        \ l:count <1000 ? ' ' . l:count : l:count
endfunction

function! s:llvarCharCount()
    let l:count = g:CharCount()
    let s:llcharcount = l:count < 10 ? '**' . l:count :
        \ l:count <100 ? '*' . l:count :
        \ l:count
endfunction

function! LLCharcount()
    if &filetype !~# s:ignore_filetype
        return winwidth(0) > 70 ? '[' . s:llcharcount . ']' . s:llcharallcount . 'w' :
            \ winwidth(0) > 65 ? '[' . s:llcharcount . ']w' : ''
    else
        return ''
    endif
endfunction

function! LLReadonly()
"    return &readonly ? '⭤' : ''
    return &readonly ? '' : ''
endfunction

let s:llgitbranch = ''
autocmd vimrc BufNew,BufEnter,FileWritePre,BufWrite * call <SID>llgitcache()
function! s:llgitcache()
    let l:git = gitbranch#name()
    if &filetype !~# s:ignore_filetype && strlen(l:git)
        let s:llgitbranch =  winwidth(0) > 100  ? ' '. l:git :''
    else
        let s:llgitbranch = ''
"    return strlen(_) && winwidth(0) > 100  ? '⭠ '._ :
"      \strlen(_) ? ' ⭠': ''
    endif
endfunction

function! LLgit() abort
        return s:llgitbranch
endfunction

"autocmd vimrc InsertEnter,BufEnter * if exists('*anzu#clear_search_status') 
"    \| call anzu#clear_search_status() | endif

autocmd vimrc CmdlineLeave /,\? :call timer_start(0, {-> execute('AnzuUpdateSearchStatus') } )
"autocmd vimrc User IncSearchExecute :call execute('AnzuUpdateSearchStatus')

function! LLMyFilepath()
    if &filetype ==# 'denite'
        return LLDeniteSource()
    elseif strlen(anzu#search_status())
        return s:llanzu()
    elseif &filetype !~# s:ignore_filetype
        let l:ll_filepath = expand('%:~')
        let l:ll_filename = expand('%:t')
        if winwidth(0) > 80
            let l:ll_fn =  strlen(l:ll_filepath) < 40 ? l:ll_filepath :
            \ l:ll_filename
        else
            let l:ll_fn = l:ll_filename
        endif
            let l:ll_modified = &modified ? '[+]' : ''
            return l:ll_fn . l:ll_modified
    else
        return ''
    endif
endfunction

function! s:llanzu()
let s:anzu = anzu#search_status()
"    if winwidth(0) > 100
        return strlen(s:anzu) < 30 ? s:anzu : matchstr(s:anzu,'(\d\+\/\d\+)')
"    else
"        return ''
"    endif
endfunction

function! LLDeniteBuffer()
if &filetype ==# 'denite'
    let l:buffer = denite#get_status('buffer_name')
    return l:buffer
else
    return ''
endif
endfunction

function! LLDeniteSource()
    if &filetype !=# 'denite'
        return ''
    endif

    let l:linenr = denite#get_status('linenr')
    let l:sources = denite#get_status('sources')
    let l:p =denite#get_status('path')
    let l:path = substitute(l:p, '[', '', 'g')
    let l:path = substitute(l:path, ']', '', 'g')
    let l:path = fnamemodify(l:path,':~')
    if strlen(l:path) > 50
        let l:path = fnamemodify(l:path,':t')
    endif
    if strlen(l:sources) > 60
        let l:sources = matchstr(l:sources, '.\+\ze:[') .
            \ matchstr(l:sources, ']\zs.\+') 
    endif
    let denitesource = l:sources . ' - [' . l:path . ']'
    "if strlen(denitesource) > 100
        return denitesource
    "endif
endfunction

"デバッグ用
command! -bar LightlineUpdate    call lightline#init()|
  \ call lightline#colorscheme()|
  \ call lightline#update()

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
"if has('nvim')
"    set pumblend=15
"    hi PmenuSel blend=0
"endif
"-----------------------------------------------------------------------
"文字数カウント "{{{
"1行カウント
function! g:CharCount()
	let l:line = getline(line('.'))
	return strlen(substitute(l:line, '.', 'x','g'))
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
xnoremap<silent> <C-o> :LineCharVCount<CR>
"}}}
"========================================================================================
"Gvim {{{
if has('GUI')
    set clipboard=unnamed
    "ツールバー非表示
    ""Nm秒後にカーソル点滅開始
    set guicursor=n:blinkwait2000
    "フォント
    "ConsolasにPowerlineSymbolsをパッチしてある
    "https://qiita.com/s_of_p/items/b7ab2e4a9e484ceb9ee7
"    set guifont=Consolas:h11:cDEFAULT
"    set guifontwide=MS_Gothic:h12:cDEFAULT
"    set guifont=Ricty_Diminished_for_Powerline:h13:cDEFAULT
"Nerdfont
"
"https://github.com/iij/fontmerger/blob/master/sample/RictyDiminished-with-icons-Regular.ttf
    if has('mac')
        set guifont=Cica:h14
    else
        let s:fontsize = '13.5'
        let s:font = 'Ricty_Diminished_with-icons'

        let s:myguifont = s:font . ':h' . s:fontsize .':cDEFAULT'
        let &guifont = s:myguifont
        let &guifontwide = s:myguifont
        set renderoptions=type:directx,renmode:5,geom:1
    endif
"    if has('kaoriya')
"        autocmd vimrc SourcePost ?vimrc ScreenMode 6
"    else
        set lines=60 "ウィンドウの縦幅
        set columns=120 " ウィンドウの横幅
        winpos 2 10 " ウィンドウの起動時の位置
    "全角文字を自動判定
"    endif
else
    set t_Co=256
    set ambiwidth=double
endif

    if has('kaoriya')
        set ambiwidth=auto
    endif
"}}}
"-----------------------------------------------------------------------
"colorscheme-plugin {{{
colorscheme iceberg
"補完ポップアップメニューの色変更
autocmd vimrc ColorScheme iceberg highlight PmenuSel ctermbg=236 guibg=#3d425b
autocmd vimrc ColorScheme iceberg highlight Pmenu  ctermfg=252 ctermbg=236 guifg=#c6c8d1 guibg=#272c42
autocmd vimrc ColorScheme iceberg highlight NormalFloat ctermfg=252 ctermbg=236 guifg=#c6c8d1 guibg=#272c42
autocmd vimrc ColorScheme iceberg highlight clear Search
autocmd vimrc ColorScheme iceberg highligh Search gui=underline
"colorscheme hybrid
"colorscheme gruvbox
set background=dark
"let ayucolor='dark'

"colorscheme ayu
"}}}
"itermでの背景透過時のPowerlineフォントの表示崩れを防ぐ
"が、この設定で背景関連の透過が崩れる
"https://qiita.com/tarosaiba/items/fcc399006025ebe9152c
"highlight! Normal ctermbg=NONE guibg=NONE
"highlight! NonText ctermbg=NONE guibg=NONE
"highlight! LineNr ctermbg=NONE guibg=NONE
if exists('g:vv')
    VVset fontfamily='Cica'
    VVset fontsize=14
    VVset windowheight=100%
    VVset windowwidth=60%
    VVset windowleft=0
    VVset windowtop=0k
endif

"vim:set foldmethod=marker:"
