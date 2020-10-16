"ork's vimrc
" Basic setting {{{
set encoding=utf-8
scriptencoding utf-8,cp932
set fileformats=unix,dos,mac
set fileencodings=utf-8,ucs-bom,iso-2022-jp-3,euc-jisx0213,euc-jp,cp932
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
if has('win32')
    let g:python3_host_prog ='python.exe'
endif
if has('win64') && !has('nvim')
    set pythonthreedll=C:\Python38\python38.dll
endif
" let g:vimproc#download_windows_dll = 1
" Backup
" set autochdir               " set current directory to editing file dir automatically
set swapfile
set undofile
set directory=~/.backup/vim/swap
set undodir=~/.backup/vim/undo " put together undo files
set backupdir=~/.backup/vim/backup " put together undo files
set autoread                " reload editing file if the file changed externally
set backup                " no more backup file
let mapleader = "\<Space>"
"}}}

" dein.vim {{{
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if &runtimepath !~# '/dein.vim'
      if !isdirectory(s:dein_repo_dir)
        if !executable('git')
          echo 'Please install git or update your path to include the git executable!'
        endif
        echo 'install dein.vim ...'
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
      endif
      " let path = fnamemodify(s:dein_repo_dir, ':p')
    " execute 'set runtimepath+=' . substitute(path, '\\$', '', '')
    execute 'set runtimepath+=' . fnamemodify(s:dein_repo_dir, ':p')
endif

let s:toml      = '~/dotfiles/nvim/rc/dein.toml'
let s:lazy_toml = '~/dotfiles/nvim/rc/dein_lazy.toml'
let s:no_dependency_toml = '~/dotfiles/nvim/rc/dein_no_dependency.toml'

if has('nvim')
    let s:lsp_toml = '~/dotfiles/nvim/rc/dein_nvim_lsp.toml'
else
    let s:lsp_toml = '~/dotfiles/nvim/rc/dein_vim_lsp.toml'
endif
    " let s:lsp_toml = '~/dotfiles/nvim/rc/dein_vim_lsp.toml'

let s:myvimrc = expand('$MYVIMRC')
if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir,s:myvimrc)
    call dein#load_toml(s:toml,      {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})
    " call dein#load_toml(s:lsp_toml,  {'merged': 1})
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

" Visual  {{{
" language C
set ambiwidth=double
set shortmess+=aAcTt
set showtabline=2   " always show tabline
set nonumber          " show line number
set signcolumn=yes  " show signcolumn
set laststatus=2    " always show statusline
set cmdheight=1     " set commandline lines
set noshowcmd       " don't let show inserting command
set noshowmode      " don't let show current mode on commandline
set cursorline      " highlight cursorline
" autocmd vimrc ColorScheme *  hi clear CursorLine
set list            " show invisible character
set listchars=tab:^-,trail:\ ,extends:»,precedes:«,nbsp:%
set modelines=5
set termguicolors
set lazyredraw
set t_Co=256
set synmaxcol=512
set belloff=all
set fillchars+=vert:\ ,fold:\ ,diff:\ 
set hidden          " be able to open files when editing other files
set splitright
set noruler
" Display candidates by list.
set wildmenu
set wildmode=longest:full,full
set previewheight=10 " Adjust window size of preview
set helpheight=15 "and help.
set ttyfast
" max candidate of completion menu
set pumheight=15 " default
set diffopt=internal,context:3,filler,algorithm:histogram,indent-heuristic,vertical
"}}}

" Editing {{{
set virtualedit=block     "move cursor to one more char than end of line
set display+=lastline,uhex
set wrap
" Scroll
" autocmd vimrc WinEnter * setlocal scroll=1
set scrolloff=5
set sidescrolloff=5
set sidescroll=1
" add japanese matchpairs
set showmatch       " highlight matched pairs
set matchtime=1     " highlighting long
set matchpairs+=<:>,（:）,「:」,『:』,【:】,［:］,＜:＞,〔:〕
set nojoinspaces
set textwidth=0             " don't let insert auto indentation
set tabstop=8               " number of spaces inserted by <TAB>
set expandtab
set softtabstop=4
let g:vim_indent_cont = 4
set autoindent
set shiftwidth=4            " number of spaces inserted when auto indentation by vim
set formatoptions+=mMjoB
set iskeyword+=-
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
set history=1000
if has('nvim')
  set shada=!,'200,<100,s10,h
else
  set viminfo=!,'200,<100,s10,h,n~/.vim/.viminfo
endif

" set unnamed register to clipboard.
" NOTE: not working well with CTRL-V in neovim.
" workaround in neovim section.
set clipboard+=unnamedplus
" mouse in terminal
set mouse=a
" Set minimal height for current window.
set winheight=1
set winwidth=1
" Set maximam maximam command line window.
set cmdwinheight=8
" equal window size.
" set equalalways
" for cmdwin
autocmd vimrc CmdwinEnter * call <SID>cmdwin_settings()
function! s:cmdwin_settings() abort
    " delete useless commands
    silent g/^qa\?!\?$/d
    silent g/^e\?!\?$/d
    silent g/^wq\?a\?!\?$/d
    " move to nice position
    " CmdwinEnter seems not to fire below commands
    setlocal signcolumn=no            
    setlocal scrolloff=0              
    nnoremap <buffer><silent>q :close<CR>     
    silent call feedkeys('G', 'n')
    silent call feedkeys('$', 'n')
    silent call feedkeys('z-', 'n')
endfunction

" open .docx as .zip
au vimrc BufReadCmd *.docx,*.doc,*.pages,*.xlsm,*.xlsx  call zip#Browse(expand("<amatch>"))
" .textlintrc is json
au vimrc BufRead .textlintrc set ft=json
set completeopt+=menuone
set completeopt-=preview
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

"Key map - moving {{{
nnoremap <CR> o<ESC>
" nnoremap \ O<ESC>
" moving visible lines by j/k
nnoremap <silent>j gj
nnoremap <silent>k gk
" moving tip/end of a line
nnoremap <S-l> $
nnoremap <S-h> ^
vnoremap <S-l> $
vnoremap <S-h> ^
" nnoremap G Gzz
nnoremap <C-f> <C-f>zz
nnoremap <C-b> <C-b>zz
nnoremap <C-d> <C-d>
nnoremap <C-u> <C-u>
nnoremap <C-o> <C-o>zz
" moving around between buffers
nnoremap <silent><Leader>h :bprev!<CR>
nnoremap <silent><Leader>l :bnext!<CR>
nnoremap <silent><Leader>l :bnext!<CR>
" matchit mapping
nmap <TAB>  %
nmap g<TAB> g%
xmap <TAB>  %
xmap g<TAB> g%
omap <TAB>  %
omap g<TAB> g%
" native <TAB> is useful
nnoremap <C-p> <C-i>zz
vnoremap <C-p> <C-i>
xnoremap <C-p> <C-i>
"}}}
"Key map - shortcuts {{{
" Convenience key for getting to command mode
nmap ; :
vmap ; :
xmap ; :
" Enter normal mode
inoremap jk <esc>
" cancel highlight search
" nmap<silent> <Esc><Esc> :nohlsearch<CR>
" nmap<silent> <C-c><C-c> :nohlsearch<CR>
" make temp file
command! -nargs=? Otempfile :edit `=tempname()` | setf <args>
" open location list
nnoremap <Leader>f :<C-u>lopen<CR>
" open cmdwin
nnoremap <C-y> q:"_dd
autocmd vimrc CmdwinEnter * map <buffer> <CR> <CR>
" open vimrc quickly
nnoremap <silent> <leader>v :e $MYVIMRC<CR>
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
" pandoc/pandoc-crossref:put config file to ~/.pandoc-crossref/config.yaml
function! s:pandoc_md_to_docx() "{{{
" http://lierdakil.github.io/pandoc-crossref/
let t = expand('~/dotfiles/pandoc/reference.docx')
let s = "!pandoc -s --filter pandoc-crossref -f  markdown+ignore_line_breaks -t docx --reference-doc=" . t . " '%:p' -o '%:p:r.docx'"
execute s
endfunction "}}}
if has('mac')
    nnoremap <Leader>md <C-u>:call <SID>pandoc_md_to_docx()<CR>
else
    nnoremap <Leader>md <C-u>:!start /min pandoc "%:p" -o "%:p:r.docx" --filter pandoc-crossref<CR>
endif
"}}}
"Key map - editting {{{
" emacs like mapping on insert mode
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-h> <BS>
inoremap <C-a> <HOME>
inoremap <C-e> <END>
" yank to end of line
nnoremap Y y$
" xnoremap Y y$gv<ESC>
" xnoremap y ygv<ESC>
xnoremap Y y$`]
xnoremap y y`]
" 'v' behave more compatible with 'y'
" nnoremap vv V
" nnoremap V v$
" shoot chars deleted by x to blackhole register
nnoremap x "_x
" Create a blank line above/below current line
nnoremap <leader>j o<ESC>k
nnoremap <leader>k O<ESC>j
" repeat :substitute with same flag
nnoremap <silent> & :&&<CR>
" << keeps visual mode
vnoremap < <gv
vnoremap > >gv
vnoremap > >gv
" insert date
inoremap <expr><F2> strftime("%Y%m%d")
cnoremap <expr><F2> strftime("%Y%m%d")
"improve command completion
cnoremap <expr> <C-n> pumvisible() ? "\<C-n>" : "\<DOWN>"
cnoremap <expr> <C-p> pumvisible() ? "\<C-p>" : "\<UP>"
" for IME status saving
" inoremap <silent><ESC> <ESC>
" inoremap <silent><C-[> <ESC>
" inoremap <silent><C-c> <ESC>
"}}}

"Key map - terminal {{{
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
"}}}

"Key map - folding {{{
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
" }}}

"Key map - window {{{
" " :close by 'q'
" nnoremap <silent> q :close<CR>
" escape 'q'
" escape 'gq'
" nnoremap gQ gq
autocmd FileType help nnoremap <buffer> q <C-w>c
" don't close window when closing buffer
nnoremap <silent> Q :<C-u>Bclose<CR>
xnoremap <silent> Q :<C-u>Bclose<CR>
 function! s:Bclose(bang, buffer) "{{{
"https://vim.fandom.com/wiki/Deleting_a_buffer_without_closing_the_window
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
" Display an error message. {{{
 function! s:Warn(msg)
   echohl ErrorMsg
   echomsg a:msg
   echohl NONE
 endfunction "}}}
"}}}
" autocmd vimrc FileType help nnoremap <silent><buffer> q :close<CR>
" open tab by gt if no tab
nnoremap <silent>gt :<C-u>call <SID>improved_gt()<CR>
function! s:improved_gt() abort
    if tabpagenr('$') == 1
        execute 'tabnew'
    else
        normal! gt
    endif
endfunction

" spliting windows
nnoremap <leader>ws :sp<CR>:bprev<CR>
nnoremap <leader>wv :vsp<CR>:bprev<CR>
nnoremap <leader>wc :close<CR>
nnoremap <leader>wn :vne<CR>
nnoremap <leader>wo :only<CR>
" move between windows
nnoremap <C-w>w <C-w>p
nnoremap <C-w><C-w> <C-w>p
nnoremap <C-w>u <C-w><C-w>
nnoremap <C-w><C-u> <C-w><C-w>
" change window size
nnoremap <S-Left>  <C-w><
nnoremap <S-Right> <C-w>>
nnoremap <S-Up>    <C-w>-
nnoremap <S-Down>  <C-w>+
nnoremap <Left>  <C-w>h
nnoremap <Right> <C-w>l
nnoremap <Up>    <C-w>k
nnoremap <Down>  <C-w>j
" maximize buffer window size temporally
nmap <C-w>z <Plug>(my-zoom-window)
nmap <C-w><C-z> <Plug>(my-zoom-window)
" mouse mapping
nmap <S-LeftMouse> <CR>
nmap <2-LeftMouse> <CR>
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
"}}}

" Terminal {{{
if has('nvim')
    autocmd vimrc TermOpen term://* setlocal nonumber scrolloff=0 signcolumn=no nobuflisted
else
    autocmd vimrc TerminalOpen term://* setlocal nonumber scrolloff=0 signcolumn=no nobuflisted
endif

if has('nvim')
  " neovim 用
  autocmd vimrc TermEnter * startinsert
else
  " Vim 用
  autocmd vimrc WinEnter * if &buftype ==# 'terminal' | normal i | endif
endif

" function! s:undo_entry()
"   let history = get(w:, 'qf_history', [])
"   if !empty(history)
"     call setqflist(remove(history, -1), 'r')
"   endif
" endfunction

" function! s:del_entry() range
"   let qf = getqflist()
"   let history = get(w:, 'qf_history', [])
"   call add(history, copy(qf))
"   let w:qf_history = history
"   unlet! qf[a:firstline - 1 : a:lastline - 1]
"   call setqflist(qf, 'r')
"   execute a:firstline
" endfunction
"}}}

"Quickfix {{{
 autocmd vimrc FileType qf call s:my_qf_setting()
 function! s:my_qf_setting() abort
     set modifiable
     " nnoremap <buffer> <CR> :<C-u>.cc<CR>
     nnoremap <silent><buffer> q :<C-u>close<CR>
     call <SID>is_loc()
     noremap <buffer> p  <CR>zz<C-w>p
 endfunction
 function! s:is_loc()
 let wi = getwininfo(win_getid())[0]
 if wi.loclist
     nnoremap <silent><buffer> <CR> :.ll<CR><C-w>p
 elseif wi.quickfix
     nnoremap <silent><buffer> <CR> :.cc<CR><C-w>p
 else
     echom 'here is not quickfix and location list.'
 endif
 endfunction
"}}}

" +GUI {{{
if has('GUI')
     let &guioptions = substitute(&guioptions, '[mTrRlLbeg]', '', 'g')
    set guioptions+=Mc!
    """Nm秒後にカーソル点滅開始
    "set guicursor=n:blinkwait2000
    "let no_buffers_menu = 1
    set lines=60 "ウィンドウの縦幅
    set columns=120 " ウィンドウの横幅
    winpos 500 10 " ウィンドウの起動時の位置
    if has('mac')
        set guifont=Cica:h14
    else
    "https://github.com/iij/fontmerger/blob/master/sample/RictyDiminished-with-icons-Regular.ttf
        " let s:fontsize = '12'
        " let s:font = 'Ricty_Diminished_with-icons'
        " let s:myguifont = s:font . ':h' . s:fontsize .':cDEFAULT'
        " let &guifont = s:myguifont
        " let &guifontwide = s:myguifont
        set guifont=Cica:h12:
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
    " autocmd vimrc GUIEnter * set transparency=235
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
    au ColorScheme * highlight! iCursor guifg=#161821 guibg=#84a0c6
    " set guicursor=n-v-c:block-Cursor-blinkon0,i-ci:iCursor,r-cr:hor20
    " fix CTRL-V yank issue
    " set clipboard=unnamedplus
    " nnoremap y "+y
    " xnoremap y "+ygv<ESC>
    " nnoremap Y "+y$
    " xnoremap Y "+y$gv<ESC>
    " nnoremap gp "+p
    " xnoremap gp "+p
    " nnoremap gP "+P
    " xnoremap gP "+P
    set completeopt+=menuone
    set completeopt-=preview
    " show complettion popup in commandline.
    set wildoptions=pum
    set winblend=0
    set termguicolors
    " remove end of buffer ~~~~~~~~~
    set fillchars+=eob:\ 
    "transparent completions menu
    set pumblend=15
    set inccommand=nosplit
    au TextYankPost * silent! lua vim.highlight.on_yank()
    " au TextYankPost * lua require'vim.highlight'.on_yank("IncSearch", 200)
endif
"}}}

" highlight {{{
" for foldcolumn
" hi! link SpecialKey Comment
if has('nvim')
    hi! PmenuSel blend=0
endif
" edit fold column
set background=dark
colorscheme iceberg
"}}}

" filetype config {{{
let g:tex_conceal=''
"}}}

" misc {{{
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
  endfor
endfunction
"}}}

" yank searched results
function! s:search(pat)
let l:cache = []

execute '%s/' . a:pat . '/\=add(l:cache, submatch(0))/n'
call setreg(v:register,join(l:cache, "\n"))
endfunction
command! -nargs=* SearchYank call s:search(<q-args>)

let g:lightline#bufferline#smarttab = 1

" set colorscheme
try
    exe 'colorscheme ' . g:colors_name
catch /^Vim\%((\a\+)\)\=:E185:/
    echom "colorscheme '"  . g:colors_name .  "' is not found. Using 'peachpuff' instead"
    exe 'colorscheme peachpuff'
endtry
" if has('win32')
" set shell=\"C:\msys64\usr\bin\bash.exe\"\ -f
" set shellcmdflag=-c
" set shellquote=\"
" set shellxescape=
" set shellxquote=
" endif
"}}}

hi! link NonText Comment

" for neovide initialize hook
if exists('neovide')
    set guifont=:RictyDiminished\ NF:h16
endif
if exists('g:gonvim_running')
    " for goneovim bug(20/06/30)
" augroup GonvimAu
"     " au! Optionset *
"     " au GonvimAu OptionSet * if &ro != 1 | silent! call rpcnotify(1, "Gui", "gonvim_optionset") | endif
"     au GonvimAu OptionSet * silent! call rpcnotify(1, "Gui", "gonvim_optionset") | redraw
"     " au! BufEnter,FileType,VimEnter,WinEnter *
" augroup end
 augroup GonvimAuStatusline
    autocmd!
  augroup end
  augroup GonvimAuLint
    autocmd!
  augroup end
  augroup GonvimAuFiler
    autocmd!
  augroup end
  augroup GonvimAuFilepath
    autocmd!
  augroup end
  augroup GonvimAuMinimap
    autocmd!
  augroup end
  augroup GonvimAuMinimapSync
    autocmd!
  augroup end
  " augroup GonvimAuMd
  "   autocmd!
  " augroup end
  augroup GonvimAuWorkspace
    autocmd!
  augroup end
  set mouse=nicr
  set pumheight=10
" set scrolljump=5
  cd ~/
endif
nnoremap <F1> :split ~/Dropbox/共有*/ToDo_??.txt<CR>
set diffopt=internal,context:10,algorithm:minimal,vertical,foldcolumn:0,indent-heuristic,filler,hiddenoff
autocmd FileType text syntax sync minlines=50
autocmd FileType markdown syntax sync minlines=50
" autocmd vimrc DiffUpdated * call timer_start(0, 'Vimdiff_config')
function! Vimdiff_config(timer) abort
" if &diff
  windo set wrap
  wincmd w
  " nnoremap q :tabclose<CR>
  " endif
endfunction

" autocmd vimrc TabLeave * silent! unmap q
nnoremap <silent><C-q> :tabclose<CR>
noremap <ScrollWheelUp> <C-u>
noremap <ScrollWheelDown> <C-d>
" au vimrc BufEnter * set scroll=3
nnoremap <MiddleMouse> :close<CR>
" nnoremap <expr>q &diff ? execute('tabclose') : "q"
set background=dark

nnoremap S :<C-u>%s/
vnoremap S :%s/
nnoremap gs :%s///g<Left><Left>
vnoremap gs :<C-u>%s///g<Left><Left>
" /\v(①|②|③|④|⑤|⑥|⑦|⑧|⑨|⑩)/
" nnoremap /  /\v
" nnoremap ?  ?\v
set updatetime=1500
let g:denite_text_pos = 0
" augroup MyCursorLineGroup
"     autocmd!
"     au WinEnter * setlocal cursorline
"     au WinLeave * setlocal nocursorline
" augroup end
finish
nnoremap <C-n> <cmd>call Nvim_lsp_showdiagnostics()<CR>
nnoremap \ <cmd>lne<CR>zz
nnoremap \| <cmd>lp<CR>zz
let g:nvim_lsp_diagnostics = []
function! Nvim_lsp_showdiagnostics() abort
    call s:qf_to_loc()
    if empty(g:nvim_lsp_diagnostics)
        echom 'No diagnostics results found'
    else
        echo 'Retrieved diagnostics results'
        botright lopen
    endif
endfunction
autocmd dein User LspDiagnosticsChanged call <SID>qf_to_loc()
function! s:qf_to_loc() abort
    let callback = getqflist()
    " echo callback
    if !empty(callback)
        let g:nvim_lsp_diagnostics = []
        for i in callback
        let i.col = s:to_col(i.bufnr, i.lnum, i.col)
        " echo i
        call add(g:nvim_lsp_diagnostics, i)
        endfor  
        " echo list
        call setloclist(0, g:nvim_lsp_diagnostics, ' ')
    endif
endfunction
function! s:to_col(expr, lnum, char) abort
    let l:lines = getbufline(a:expr, a:lnum)
    if l:lines == []
        if type(a:expr) != v:t_string || !filereadable(a:expr)
            " invalid a:expr
            return a:char + 1
        endif
        " a:expr is a file that is not yet loaded as a buffer
        let l:lines = readfile(a:expr, '', a:lnum)
    endif
    let l:linestr = l:lines[-1]
    return strlen(strcharpart(l:linestr, 0, a:char))
endfunction
function! Nvim_lsp_result_to_quickfix() abort
    let res = []
    let i = bufnr('%')
    let res = luaeval('vim.lsp.util.diagnostics_by_buf[' . i . ']')
    for l in res[0]
        let bufnr = l['bufnr']
        let lnum = l['lnum']
        let col = l['col']
        let text = l['text']
        call setqflist([bufnr,lnum,col,text], ' ')
    endfor
    " let result = g:res
    " call setqflist(result, ' ')
endfunction
if has('nvim') && dein#is_sourced('nvim-lspconfig')
lua << EOF
do
-- function vim.lsp.util.set_qflist(items)
--   vim.fn.setqflist({}, 'a', {
--     title = 'Language Server';
--     items = items;
--   })
-- end
-- function vim.lsp.util.set_loclist(items)
--   vim.fn.setloclist(0, {}, 'a',{
--     title = 'Language Server';
--     items = items;
--   })
-- end
  local string = require'string'
  local method = "textDocument/publishDiagnostics"
  local default_callback = vim.lsp.callbacks[method]
  vim.lsp.callbacks[method] = function(err, method, result, client_id)
    default_callback(err, method, result, client_id)
    if result and result.diagnostics then
      for _, v in ipairs(result.diagnostics) do
        v.uri = v.uri or result.uri
        v.bufnr = vim.uri_to_bufnr(v.uri)
        v.lnum = v.range.start.line + 1
        v.col = v.range.start.character + 1
        v.text = v.message
      end
        -- local uri = result.uri
        -- local bufnr = vim.uri_to_bufnr(uri)
        -- vim.lsp.util.buf_diagnostics_save_positions(bufnr, result.diagnostics)
      -- vim.fn.nvim_set_var('diagnostics', result.diagnostics)
      vim.lsp.util.set_qflist(result.diagnostics)
    end
    -- if vim.lsp.util.diagnostics_by_buf[vim.fn.bufnr(0)] then
  end
end

local nvim_lsp = require'nvim_lsp'
local configs = require'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

-- local bin_name = "efm-langserver"
-- 
-- configs["efm_ls"] = {
--   default_config = {
--     cmd = {"efm-langserver"};
--     filetypes = {text, txt, markdown, IPA};
--     root_dir = function(fname)
--       return vim.fn.getcwd()
--     end;
--   };
-- }
require'nvim_lsp'.efm.setup{}

vim.api.nvim_set_var("enable_nvim_lsp_diagnostics", true)

require'nvim_lsp'.gopls.setup{}
require'nvim_lsp'.clangd.setup{}
require'nvim_lsp'.julials.setup{}
require'nvim_lsp'.texlab.setup{}
-- util.base_install_dir= '~/.cache/nvim/nvim_lsp/'
    -- settings = {
    --   latex = {
    --     build = {
    --       executable = "latexmk";
    --       args = {"uplatex", "-kanji=utf-8", "-halt-on-error", "-synctex=1", "-interaction=nonstopmode", "-file-line-error"};
    --       onSave = false;
    --         };
    --     };
    -- };
-- }
-- require'nvim_lsp'.pyls_ms.setup{}
-- require'nvim_lsp'.pyls.setup{}
require'nvim_lsp'.jedi_language_server.setup{}
require'nvim_lsp'.yamlls.setup{}
-- require'nvim_lsp'.sumneko_lua.setup{}
require'nvim_lsp'.vimls.setup{}
require'nvim_lsp'.tsserver.setup{}
EOF
endif
"lsp.txtそのまま
"set omnifunc=v:lua.vim.lsp.omnifunc
nnoremap <silent> <c-]>      <cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> <c-k>      <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <c-k>          <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gd         <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gD         <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> 1gD        <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent><Leader>fmt <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
"let g:tex_flavor = "latex"
"set updatetime=1000
"function! s:vimenter() abort
""augroup nvim_lsp
"au!
"autocmd CursorHold <buffer> lua vim.lsp.util.show_line_diagnostics()
"autocmd CursorHoldI <buffer> lua vim.lsp.util.show_line_diagnostics()
"autocmd CursorMoved <buffer> lua vim.lsp.util.show_line_diagnostics()
"autocmd CursorMovedI <buffer> lua vim.lsp.util.show_line_diagnostics()
"endfunction
"autocmd dein BufEnter * call s:vimenter()
sign define LspDiagnosticsErrorSign text= texthl=LspDiagnosticsError linehl= numhl=
sign define LspDiagnosticsWarningSign text= texthl=LspDiagnosticsWarning linehl= numhl=
sign define LspDiagnosticsInformationSign text=! texthl=LspDiagnosticsInformation linehl= numhl=
sign define LspDiagnosticsHintSign text=? texthl=LspDiagnosticsHint linehl= numhl=
hi link  LspDiagnosticsError Error
highlight LspReferenceText guifg=Red
highlight LspReferenceWrite guifg=Red
highlight LspReferenceRead guifg=Red
highlight link LspDiagnosticsError Error
highlight LspDiagnosticsWarning guifg=Green
highlight link LspDiagnosticsUnderline Underlined
autocmd ColorScheme * highlight LspReferenceText guifg=Red
autocmd ColorScheme * highlight LspReferenceWrite guifg=Red
autocmd ColorScheme * highlight LspReferenceRead guifg=Red
autocmd ColorScheme * highlight link LspDiagnosticsError Error
autocmd ColorScheme * highlight LspDiagnosticsWarning guifg=Green
autocmd ColorScheme * highlight link LspDiagnosticsUnderline Underlined

vmap u 'aUgv<ESC>ll
vmap r 'aRgv<ESC>ll

	let g:previm_enable_realtime = 1
autocmd BufReadPre gina://* set noswapfile
" autocmd vimrc WinEnter * if &ft == 'twitvim' | resize 17| endif
autocmd FileType twitvim nnoremap <silent><buffer> K :echo getline('.')<CR>
autocmd FileType twitvim nnoremap <silent><buffer><expr> k line('.') =~ '\v^(1\|2\|3)$' ? 'G' : 'k'
autocmd FileType twitvim nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg2j' : 'j'
autocmd FileType twitvim nnoremap <silent><buffer> <C-n> :NextTwitter<CR>
autocmd FileType twitvim nnoremap <silent><buffer> <C-p> :PreviousTwitter<CR>
autocmd FileType twitvim nnoremap <silent><buffer> r :RefreshTwitter<CR>
autocmd FileType twitvim nnoremap <silent><buffer> <CR> :ProfileTwitter `expand('<cword>')[0:-2]`<CR>
autocmd FileType twitvim nmap <silent><buffer> <leader>o /http<CR>:call histdel('/',-1)<CR><Plug>(openbrowser-smart-search)0
nnoremap <silent> <F3> :FriendsTwitter<CR>
nnoremap <silent> <Leader>r :RefreshTwitter<CR>
	let g:previm_show_header = 0
function! Test()
let text = getline('.')
let row = text / winwidth(0) + 1
let col = - col('.')
let buf = nvim_create_buf(v:false, v:true)
setlocal wrap
call nvim_buf_set_lines(buf, 0, -1, v:true, [text])
let opts = {'relative': 'cursor', 'width': winwidth(0), 'height': row, 'col': col + 1, 'row': 0, 'anchor': 'NW', 'style': 'minimal'} 
let win = nvim_open_win(buf, 0, opts)
" call nvim_open_win(0, v:false, {
"     \ 'relative': 'win',
"     \ 'anchor': "SE",
"     \ 'row': 0,
"     \ 'col': 0,
"     \ 'width': winwidth(0),
"     \ 'height': row,
"     \ 'focusable': v:false
"     \})
endfunction
let twitvim_enable_python3 = 1
let twitvim_timestamp_format = '%H:%M-%m/%d'
let twitvim_count = 15
function! Mdpdf()
!mdpdf --border=12.7mm %
endfunction
augroup your_config_scrollbar_nvim
    autocmd!
    autocmd BufEnter    * silent! lua require('scrollbar').show()
    autocmd BufLeave    * silent! lua require('scrollbar').clear()

    autocmd CursorMoved * silent! lua require('scrollbar').show()
    autocmd VimResized  * silent! lua require('scrollbar').show()

    autocmd FocusGained * silent! lua require('scrollbar').show()
    autocmd FocusLost   * silent! lua require('scrollbar').clear()
augroup end

function! g:Vimrc_select_a_last_modified() abort
    return ['v', getpos("'["), getpos("']")]
endfunction
vnoremap y ygv<ESC>
" vim:set foldmethod=marker:

