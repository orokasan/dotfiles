"ork's vimrc
" Basic setting {{{
set encoding=utf-8
if !has('nvim')
    scriptencoding utf-8,cp932
else
    scriptencoding utf-8
endif
set fileencoding=utf-8
" set fileencodings=utf-8,ucs-bom,iso-2022-jp-3,euc-jisx0213,euc-jp,cp932
" ------------------------------------------------------------------------------
" reset vimrc autocmd group
augroup vimrc
  autocmd!
augroup END
" don't load unused default plugins
let g:loaded_gzip              = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
" let g:loaded_zip               = 1
" let g:loaded_zipPlugin         = 1
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
let g:loaded_matchparen = 1
"---------------------------------------------------------------------
"Python,vimproc
if has('win64')
    let g:python3_host_prog ='python.exe'
endif

" Backup
" set autochdir               " set current directory to editing file dir automatically
set swapfile
if !has('nvim')
    set directory=~/vimfiles/swap
    set undodir=~/vimfiles/undo " put together undo files
endif
set undofile
set autoread                " reload editing file if the file changed externally
set nobackup                " no more backup file
"set backupdir=~/vimfiles/backup
"}}}

" Visual  {{{
set shortmess+=aAcTS
set showtabline=2   " always show tabline
set number          " show line number
set signcolumn=yes  " show signcolumn
set laststatus=2    " always show statusline
set cmdheight=1     " set commandline lines
set noshowcmd       " don't let show inserting command
set noshowmode      " don't let show current mode on commandline
set cursorline      " highlight cursorline
" autocmd vimrc ColorScheme *  hi clear CursorLine
set list            " show invisible character
set listchars=tab:\ \ ,trail:-,extends:»,precedes:«,nbsp:%
set modelines=5
set termguicolors   " ターミナルでも True Color を使えるようにする。
" set lazyredraw
set visualbell      " please stop noisy beep
set t_vb=
set noerrorbells
set fillchars+=vert:\ ,fold:\ 
set hidden          " be able to open files when editing other files
set noruler
" cancel highlight search
nmap<silent> <Esc><Esc> :nohlsearch<CR>
nmap<silent> <C-c><C-c> :nohlsearch<CR>
" Display candidates by list.
set wildmenu
set wildmode=longest:full,full
set previewheight=8 " Adjust window size of preview 
set helpheight=15 "and help.
set ttyfast
" max candidate of completion menu
set pumheight=15 " default
set ambiwidth=double
set background=dark

"}}}

"Quickfix {{{
nnoremap <Leader>f :<C-u>cope<CR>

autocmd vimrc FileType qf call s:my_qf_setting()
function! s:my_qf_setting() abort
    nnoremap <buffer> <CR> :<C-u>.cc<CR>
    nnoremap <buffer> q :<C-u>quit<CR>
endfunction
"}}}

" Editing {{{
set virtualedit=block     "move cursor to one more char than end of line
set scrolloff=5
set display=lastline
set wrap
" Scroll
set sidescrolloff=5
set sidescroll=1
" add japanese matchpairs
set showmatch       " highlight matched pairs
set matchtime=1     " highlighting long
set matchpairs+=（:）,「:」,『:』,【:】,［:］,＜:＞

set nojoinspaces
set textwidth=0             " don't let insert auto indentation
set tabstop=4               " number of spaces inserted by <TAB>
set expandtab
set softtabstop=4
let g:vim_indent_cont = 4
set autoindent
set shiftwidth=4            " number of spaces inserted when auto indentation by vim
set formatoptions+=mMjo

" Searching
set ignorecase
set smartcase
set incsearch
"default global option on :substitute
"set gdefault
set wrapscan
set hlsearch
"completion
set complete=.,w,b,u
" viminfo
if has('nvim')
  set shada=!,:10,'300,<50,s10,h,@10
else
  set viminfo=!,'300,<50,s10,h,n~/.viminfo
endif

" Set minimal height for current window.
set winheight=1
set winwidth=1
" Set maximam maximam command line window.
set cmdwinheight=5
autocmd vimrc CmdwinEnter [:/?=] setlocal signcolumn=no
autocmd vimrc CmdwinEnter : g/^qa\?!\?$/d
autocmd vimrc CmdwinEnter : g/^wq\?a\?!\?$/d
" No equal window size.
set noequalalways
" nicely folding
"{{{
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
set viewoptions-=options
set viewoptions-=curdir
""ディレクトリが保存時無い場合に自動的に作成
""https://vim-jp.org/vim-users-jp/2011/02/20/Hack-202.html
"augroup vimrc-auto-mkdir  " {{{
"  autocmd!
"  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
"  function! s:auto_mkdir(dir, force)  " {{{
"    if !isdirectory(a:dir) && (a:force ||
"    \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
"      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
"    endif
"  endfunction  " }}}
"augroup END  " }}}
""}}}
"transparent completions menu
if has('nvim')
    set pumblend=15
    hi! PmenuSel blend=0
endif
set imdisable
"日本語入力固定モード
"IM-control.vimが必要
"https://sites.google.com/site/fudist/Home/vim-nihongo-ban/vim-japanese/ime-control
"eskk.vimと干渉するため停止している
let g:disable_IM_Control = 1
if !exists('g:disable_IM_Control')
    inoremap <silent> <C-k> <C-^><C-r>=IMState('FixMode')<CR>
endif
""}}}

"Key mapping {{{

let mapleader = "\<Space>"
" improved insert
" in neovim, 'cc' overwrite unnamed register.
"nnoremap <expr>i len(getline('.')) == 0 ? "cc" : "i"
nnoremap <CR> o<ESC>
nnoremap \ O<ESC>
" select all
nnoremap <C-g><C-g> ggVG
" moving visible lines by j/k
nnoremap <silent>j gj
nnoremap <silent>k gk
" moving tip/end of a line
nnoremap <S-l> $
nnoremap <S-h> ^
vnoremap <S-l> $
vnoremap <S-h> ^
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
" change mark keymapping
nnoremap ` m
nnoremap ! `
" yank to end of line
nnoremap Y y$
xnoremap Y y$gv<ESC>
xnoremap y ygv<ESC>

" 'v' behave more compatible with 'y'
nnoremap vv V
nnoremap V v$

nnoremap <Tab> %
vnoremap <Tab> %
xnoremap <Tab> %
nnoremap <C-p> <C-i>
vnoremap <C-p> <C-i>
xnoremap <C-p> <C-i>
nnoremap J gJ
nnoremap gJ J

inoremap z] 」
inoremap z} 』
inoremap z) ）

" colorcolumn
nnoremap <expr><Leader>cl
    \ ":\<C-u>set colorcolumn=".(&cc == 0 ? v:count == 0 ? virtcol('.') : v:count : 0)."\<CR>"
" 。、に移動(f<C-K>._ を打つのは少し長いので)。cf<C-J>等の使い方も可。{{{
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
"}}}
"terminal

" if using iTerm2, map option key to Meta
" Preference -> Profile -> Keys
tnoremap <C-[> <C-\><C-n>
tnoremap <Esc> <C-\><C-n>
if has('mac')
    " can't map A- on Mac
    " ref. https://qiita.com/delphinus/items/aea16e82de2145d2a6b7
    tnoremap ˙ <C-\><C-N><C-w>h
    tnoremap ∆  <C-\><C-N><C-w>j
    tnoremap ˚ <C-\><C-N><C-w>k
    tnoremap Ò  <C-\><C-N><C-w>l
    tnoremap <C-w><C-w>  <C-\><C-N><C-w>w
    inoremap ˙ <C-\><C-N><C-w>h
    inoremap ∆  <C-\><C-N><C-w>j
    inoremap ˚ <C-\><C-N><C-w>k
    inoremap Ò  <C-\><C-N><C-w>l

else
    tnoremap <A-h> <C-\><C-N><C-w>h
    tnoremap <A-j> <C-\><C-N><C-w>j
    tnoremap <A-k> <C-\><C-N><C-w>k
    tnoremap <A-l> <C-\><C-N><C-w>l
    inoremap <A-h> <C-\><C-N><C-w>h
    inoremap <A-j> <C-\><C-N><C-w>j
    inoremap <A-k> <C-\><C-N><C-w>k
    inoremap <A-l> <C-\><C-N><C-w>l
endif

if has('nvim')
    autocmd vimrc TermOpen * set nonumber signcolumn=no | startinsert
endif

 " if has('nvim')
 "   " Neovim 用
 "   autocmd vimrc WinEnter * if &buftype ==# 'terminal' | startinsert | endif
 " else
 "   " Vim 用
 "   autocmd vimrc WinEnter * if &buftype ==# 'terminal' | normal i | endif
 " endif

" close window
nnoremap <C-q> :bd<CR>
" insert date
inoremap <expr><F2> strftime("%Y%m%d")
cnoremap <expr><F2> strftime("%Y%m%d")
nnoremap <C-y> q:

autocmd vimrc CmdwinEnter * map <buffer> <CR> <CR> | nmap <buffer> q :<C-u>close<CR>
" shoot chars deleted by x to blackhole register
nnoremap x "_x
" yank by 'dd'
nnoremap dd "+dd
" check spell
"nnoremap <Leader>. :<C-u>setl spell! spell?<CR>
" don't show searching mes
nnoremap <silent> n n
nnoremap <silent> N N
" for IME status saving
inoremap <silent><ESC> <ESC>
inoremap <silent><C-[> <ESC>
inoremap <silent><C-c> <ESC>
" open vimrc quickly
nnoremap <silent> <leader>v :e ~/dotfiles/?vimrc<CR>
nnoremap <silent> <Leader>sv :<C-u>source $MYVIMRC<CR>
" source opening vim script
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
" make temp file
command! OpenTempfile :edit `=tempname()`
" open folding
nnoremap <silent><C-l> zo
" smart folding closer
nnoremap <silent><C-h> :silent! call <SID>smart_foldcloser()<CR>
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
" edit fold column
if has('GUI') || has('nvim')
    autocmd vimrc ColorScheme * hi link Folded NonText
    autocmd vimrc ColorScheme * hi Folded guifg=bold
endif
" add fold marker
nnoremap  z[     :<C-u>call <SID>put_foldmarker(0)<CR>
nnoremap  z]     :<C-u>call <SID>put_foldmarker(1)<CR>
function! s:put_foldmarker(foldclose_p) "{{{
    let crrstr = getline('.')
    let padding = crrstr ==# '' ? '' : crrstr =~# '\s$' ? '' : ' '
    let [cms_start, cms_end] = ['', '']
    let outside_a_comment_p = synIDattr(synID(line('.'), col('$')-1, 1), 'name') !~? 'comment'
    if outside_a_comment_p
        let cms_start = matchstr(&commentstring,'\V\s\*\zs\.\+\ze%s')
        let cms_end = matchstr(&commentstring,'\V%s\zs\.\+')
    endif
    let fmr = split(&foldmarker, ',')[a:foldclose_p]. (v:count ? v:count : '')
    exe 'norm! A'. padding. cms_start. fmr. cms_end
endfunction
"}}}

" spliting windows
nnoremap <leader>ws :sp<CR>:bprev<CR>
nnoremap <leader>wv :vsp<CR>:bprev<CR>
nnoremap <leader>wc :close<CR>
nnoremap <leader>wn :vne<CR>
nnoremap <leader>wo :only<CR>

" emacs like mapping on insert mode
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-h> <BS>
inoremap <C-a> <HOME>
inoremap <C-e> <END>
"
" move between windows
nnoremap <C-w><C-w> <ESC><C-w>p
nnoremap <C-w><C-u> <ESC><C-w><C-w>
"
" change window size
nnoremap <S-Left>  <C-w><
nnoremap <S-Right> <C-w>>
nnoremap <S-Up>    <C-w>-
nnoremap <S-Down>  <C-w>+

" maximize buffer window size temporally
nmap <C-w>z <Plug>(my-zoom-window)
nmap <C-w><C-z> <Plug>(my-zoom-window)
"{{{
nnoremap <silent> <Plug>(my-zoom-window)
      \ :<C-u>call <SID>toggle_window_zoom()<CR>
function! s:toggle_window_zoom() abort
    if exists('t:zoom_winrestcmd')
        execute t:zoom_winrestcmd
        unlet t:zoom_winrestcmd
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
    endif
endfunction  "}}}
" close help by q
autocmd vimrc FileType help nnoremap <buffer> q <C-w>c
" moving around between buffers
nnoremap <silent><Leader>h :bprev!<CR>
nnoremap <silent><Leader>l :bnext!<CR>

" <s>commandline mapping<s>
" !! USE <CTRL-f> !!
" cnoremap <C-a> <Home>
" cnoremap <C-b> <Left>
" cnoremap <C-d> <Del>
" cnoremap <C-e> <End>
" cnoremap <C-f> <Right>
" cnoremap <C-n> <Down>
" cnoremap <C-p> <Up>
" cnoremap <M-b> <S-Left>
" cnoremap <M-f> <S-Right>
" don't let close window when closing buffer
"https://vim.fandom.com/wiki/Deleting_a_buffer_without_closing_the_window
" Display an error message. {{{
 function! s:Warn(msg)
   echohl ErrorMsg
   echomsg a:msg
   echohl NONE
 endfunction "}}}
 function! s:Bclose(bang, buffer) "{{{
   if empty(a:buffer)
     let btarget = bufnr('%')
   elseif a:buffer =~# '^\d\+$'
     let btarget = bufnr(str2nr(a:buffer))
   else
     let btarget = bufnr(a:buffer)
   endif
   if btarget < 0
     call s:Warn('No matching buffer for '.a:buffer)
     return
   endif
   if empty(a:bang) && getbufvar(btarget, '&modified')
     call s:Warn('No write since last change for buffer '.btarget.' (use :Bclose!)')
     return
   endif
   " Numbers of windows that view target buffer which we will delete.
   let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
   if !g:bclose_multiple && len(wnums) > 1
     call s:Warn('Buffer is in multiple windows (use ":let bclose_multiple=1")')
     return
   endif
   let wcurrent = winnr()
   for w in wnums
     execute w.'wincmd w'
     let prevbuf = bufnr('#')
     if prevbuf > 0 && buflisted(prevbuf) && prevbuf != btarget
       buffer #
     else
       bprevious
     endif
     if btarget == bufnr('%')
       " Numbers of listed buffers which are not the target to be deleted.
       let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
       " Listed, not target, and not displayed.
       let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
       " Take the first buffer, if any (could be more intelligent).
       let bjump = (bhidden + blisted + [-1])[0]
       if bjump > 0
         execute 'buffer '.bjump
       else
         execute 'enew'.a:bang
       endif
     endif
   endfor
   execute 'bdelete'.a:bang.' '.btarget
   execute wcurrent.'wincmd w'
 endfunction
 let g:bclose_multiple = 1
 command! -bang -complete=buffer -nargs=? Bclose call <SID>Bclose(<q-bang>, <q-args>)
"}}}
 nnoremap Q :<C-u>Bclose<CR>
 xnoremap Q :<C-u>Bclose<CR>
" pandoc
" pandoc-crossref
" put config file to ~/.pandoc-crossref/config.yaml
" http://lierdakil.github.io/pandoc-crossref/
    function! s:pandoc_md_to_docx()
        let t = expand('~/dotfiles/pandoc/reference.docx')
        let s = "!pandoc -s --filter pandoc-crossref -f  markdown+ignore_line_breaks -t docx --reference-doc=" . t . " '%:p' -o '%:p:r.docx'"
        execute s
    endfunction
if has('mac')
    nnoremap <Leader>md <C-u>:call <SID>pandoc_md_to_docx()<CR>
else
    nnoremap <Leader>md <C-u>:!start /min pandoc "%:p" -o "%:p:r.docx" --filter pandoc-crossref<CR>
endif
"}}}

" +GUI {{{
if has('GUI')
    let &guioptions = substitute(&guioptions, '[mTrRlLbeg]', '', 'g')
    set guioptions+=M
    set clipboard+=unnamed
    ""Nm秒後にカーソル点滅開始
    set guicursor=n:blinkwait2000
    let no_buffers_menu = 1
    set lines=60 "ウィンドウの縦幅
    set columns=120 " ウィンドウの横幅
    winpos 2 10 " ウィンドウの起動時の位置
    if has('mac')
        set guifont=Cica:h14
    else
    "https://github.com/iij/fontmerger/blob/master/sample/RictyDiminished-with-icons-Regular.ttf
        let s:fontsize = '12'
        let s:font = 'Ricty_Diminished_with-icons'
        let s:myguifont = s:font . ':h' . s:fontsize .':cDEFAULT'
        let &guifont = s:myguifont
        let &guifontwide = s:myguifont
        set renderoptions=type:directx,renmode:5,geom:1
    endif
endif
"}}}

"+kaoriya {{{
if has('kaoriya')
    " auto download vimproc dll
    let g:vimproc#download_windows_dll = 1
    "autodate 'Last Change: .'
    let autodate_format ='%Y/%m/%d-%H:%M:%S'
    let autodate_lines = 10
    " fullscreen
    nnoremap <C-CR> :ScreenMode 6<CR>
    nnoremap <S-CR> :ScreenMode 1<CR>
    " background transparency
    autocmd vimrc GUIEnter * set transparency=235
    " insert date
    inoremap <F3> Last Change: .
    set ambiwidth=auto
endif
"IME状態でカーソルカラー変更
if has('multi_byte_ime')
  highlight CursorIM guifg=NONE guibg=Purple
endif
"}}}

" Neovim {{{
if has('nvim')
    " set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
    "float windowで補完するための設定
    set clipboard+=unnamed
    " set completeopt+=menuone
    set completeopt-=preview
    "set completeopt+=popuphidden
    set wildoptions=pum
    set winblend=20
endif

"}}}

""dein.vim {{{
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

" etc... {{{
"選択範囲の行をカウント {{{
function! g:LineCharVCount() range
    let l:result = 0
    for l:linenum in range(a:firstline, a:lastline)
        let l:result += strchars(getline(l:linenum))
    endfor
    return l:result
endfunction "}}}
"呼び出せる
command! -range LineCharVCount <line1>,<line2>call g:LineCharVCount()
xnoremap<silent> <C-o> :LineCharVCount<CR>

" パフォーマンスのチェック {{{
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

  for i in range(1000)
    call feedkeys('j')
    call feedkeys('j')
    call feedkeys('k')
  endfor
endfunction
"}}}

" rainbowstreaming
nnoremap <Leader>r :<C-u>call <SID>rainbowstream()<CR>
function! s:rainbowstream()
    split
    terminal rainbowstream
    resize 13
endfunction

" yank searched results
function! s:search(pat)
let l:cache = []
execute '%s/' . a:pat . '/\=add(l:cache, submatch(0))/n'
call setreg(v:register,join(l:cache, "\n"))
endfunction
command! -nargs=* SearchYank call s:search(<q-args>)
"}}}

" Memo {{{
"今夜使いたいkey mapping
"*t) =>前方の)の手前まで削除して*
"vim正規表現
"https://qiita.com/kawaz/items/d0708a4ab08e572f38f3
" input apostrophe -> <A-]>
"https://support.apple.com/ja-jp/guide/mac-help/mh27474/mac
" }}}
hi!  link SpecialKey Comment
hi!  link NonText Comment

au vimrc BufReadCmd *.docx,*.doc,*.pages call zip#Browse(expand("<amatch>"))
au vimrc BufRead .textlintrc set ft=json

" vim:set foldmethod=marker:
