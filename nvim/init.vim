"ork's vimrc
set fileformats=unix,dos,mac
set encoding=utf-8
set fileencodings=utf-8,cp932

" ------------------------------------------------------------------------------
" reset vimrc autocmd group

augroup vimrc
  autocmd!
augroup END
" don't load unused default plugins
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
let g:loaded_matchparen = 1
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_python_provider = 0
let g:loaded_ruby_provider = 0
"---------------------------------------------------------------------
if has('win32')
    let g:python3_host_prog = expand('~\AppData\Local\Programs\Python\Python39\python.exe')
endif
set rtp+=$VIM/vim82
set notermguicolors
set swapfile
set undofile
set directory=~/.backup/vim/swap
set undodir=~/.backup/vim/undo " put together undo files
set backupdir=~/.backup/vim/backup " put together undo files
set autoread                " reload editing file if the file changed externally
set backup
let mapleader = "\<Space>"
set rtp+=C:\Users\t_kuriki\.cache\dein\repos\github.com\Shougo\ddc.vim
"}}}
" dein.vim {{{
" let g:dein#auto_recache = 1
" let g:dein#lazy_rplugins=1
" let g:dein#inline_vimrcs=[expand('~/dotfiles/nvim/config.vim')]
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
    execute 'set runtimepath+=' . fnamemodify(s:dein_repo_dir, ':p')
endif
let s:toml      = '~/dotfiles/nvim/rc/dein.toml'
let s:lazy_toml = '~/dotfiles/nvim/rc/dein_lazy.toml'
let s:lua_toml = '~/dotfiles/nvim/rc/dein_lua.toml'
let s:exp_toml = '~/dotfiles/nvim/rc/dein_experimental.toml'
let s:comp_toml = '~/dotfiles/nvim/rc/dein_comp.toml'
let s:no_dependency_toml = '~/dotfiles/nvim/rc/dein_no_dependency.toml'
    let s:lsp_toml = '~/dotfiles/nvim/rc/dein_nvim_lsp.toml'
let s:myvimrc = expand('$MYVIMRC')
if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir,[s:myvimrc,s:toml,s:lazy_toml])
    call dein#load_toml(s:toml,      {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})
    " call dein#load_toml(s:exp_toml, {'merged': 0})
    call dein#load_toml(s:comp_toml, {'merged': 0})
if has('nvim')
    call dein#load_toml(s:lsp_toml,  {'merged': 0})
    call dein#load_toml(s:lua_toml,  {'merged': 0})
endif
    call dein#end()
    call dein#save_state()
    if !has('vim_starting')
        call dein#call_hook('source')
        call dein#call_hook('post_source')
    endif
endif
filetype plugin indent on
syntax on
command! -nargs=0 -complete=command DeinInstall  call dein#install()
command! -nargs=0 -complete=command DeinUpdate call dein#update()
command! -nargs=0 -complete=command DeinRecache call dein#recache_runtimepath() |echo "Recache Done"
"}}}
" Visual  {{{
" language C
set ambiwidth=double
set shortmess+=aAcTtI
set showtabline=2   " always show tabline
set nonumber
set signcolumn=yes  " show signcolumn
set laststatus=2    " always show statusline
set cmdheight=1     " set commandline lines
set noshowcmd       " don't let show inserting command
set noshowmode      " don't let show current mode on commandline
set cursorline      " highlight cursorline
" autocmd vimrc ColorScheme *  hi clear CursorLine
set list            " show invisible character
set listchars=tab:^-,trail:-,extends:»,precedes:«,nbsp:%
set modelines=5
set termguicolors
" set lazyredraw
set t_Co=256
set synmaxcol=1500
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
" max candidate of completion menu
set pumheight=12 " default
"}}}
" Editing {{{
set virtualedit=block     "move cursor to one more char than end of line
set wrap
" Scroll
set scrolloff=5
set sidescrolloff=5
set sidescroll=1
" add japanese matchpairs
set showmatch       " highlight matched pairs
set matchtime=1     " highlighting long
set matchpairs+=<:>,（:）,「:」,『:』,【:】,［:］,＜:＞,〔:〕
set nojoinspaces
set textwidth=0             " don't let insert auto indentation
set tabstop=4               " number of spaces inserted by <TAB>
set expandtab
set softtabstop=-1
let g:vim_indent_cont = 4
set autoindent
set shiftwidth=0
set formatoptions=mMjBcrql
au vimrc FileType * set fo-=o
set iskeyword+=-
" Searching
set ignorecase
set smartcase
set incsearch
"default global option on :substitute
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
set clipboard+=unnamed,unnamedplus
" mouse in terminal
set mouse=a
" Set minimal height for current window.
set winheight=1
set winwidth=1
" Set maximam command line window.
set cmdwinheight=8
" equal window size.
set equalalways
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
    nnoremap <buffer><silent>q <Cmd>close<CR>
    norm $
endfunction
set completeopt=menuone,longest
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
""}}}
set imdisable
""}}}
"Key map - moving {{{
nnoremap <CR> o<ESC>
" moving visible lines by j/k
nnoremap <silent>j gj
nnoremap <silent>k gk
" moving tip/end of a line
nnoremap <S-l> $
nnoremap <S-h> ^
vnoremap <S-l> g_
vnoremap <S-h> ^
" nnoremap G Gzz
nnoremap <C-f> <C-f>zz
nnoremap <C-b> <C-b>zz
nnoremap <C-d> <C-d>
nnoremap <C-u> <C-u>
nnoremap <C-o> <C-o>zz
" moving around buffers
nnoremap <silent><Leader>h <Cmd>bprev!<CR>
nnoremap <silent><Leader>l <Cmd>bnext!<CR>
nnoremap <silent><Leader>l <Cmd>bnext!<CR>
" moving around tabpages
nnoremap <silent> <C-L> <Cmd>tabnext<CR>
nnoremap <silent> <C-H> <Cmd>tabprevious<CR>
nnoremap <silent>gt <Cmd>call <SID>improved_gt()<CR>
function! s:improved_gt() abort
    if tabpagenr('$') == 1
        execute 'tabnew'
    else
        normal! gt
    endif
endfunction
nmap <C-j> <NOP>
" matchit mapping
" nmap <TAB>  %
" nmap g<TAB> g%
" xmap <TAB>  %
" xmap g<TAB> g%
" omap <TAB>  %
" omap g<TAB> g%
" native <TAB> is useful
nnoremap <C-p> <C-i>zz
vnoremap <C-p> <C-i>
xnoremap <C-p> <C-i>
" mark
" nnoremap M m
" nnoremap m `
"}}}
"Key map - shortcuts {{{
" Convenience key for getting to command mode
nmap ; :
vmap ; :
xmap ; :
" Enter normal mode
inoremap jk <esc>
" make temp file
command! -nargs=? Otempfile :edit `=tempname()` | setf <args>
" open location list
nnoremap <Leader>f <Cmd>lopen<CR>
autocmd vimrc CmdwinEnter * map <buffer> <CR> <CR>
" open vimrc quickly
nnoremap <silent> <leader>v <Cmd>e $MYVIMRC<CR>
nnoremap <silent> <Leader>sv <Cmd>source $MYVIMRC<CR>
" source opening vim script
nnoremap <Leader>ss <Cmd>call <SID>source_script('%')<CR>
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
"}}}
"Key map - editting {{{
" emacs like mapping on insert mode
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-a> <HOME>
inoremap <C-e> <END>
" yank to end of line
nnoremap Y y$
xnoremap Y y$`]
xnoremap y y`]
" shoot chars deleted by x to blackhole register
" nnoremap x "_x
" Create a blank line above/below current line
nnoremap <leader>j o<ESC>k
nnoremap <leader>k O<ESC>j
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
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-a> <C-b>
cnoremap <C-q> <C-f>
cnoremap <silent> <S-Tab> <C-p>
tnoremap <expr> <C-n> fnamemodify(b:term_title, ':t') == "cmd.exe" ? "\<Down>" : "\<C-n>"
tnoremap <expr> <C-p> fnamemodify(b:term_title, ':t') == "cmd.exe" ? "\<UP>" : "\<C-p>"
"}}}
"Key map - terminal {{{
"terminal
" if using iTerm2, map option key to Meta
" Preference -> Profile -> Keys
tnoremap <Esc> <C-\><C-n>
"}}}
"Key map - folding {{{
" open folding
nnoremap <silent>gl zo
" smart folding closer
nnoremap <silent>gh <Cmd>silent! call <SID>smart_foldcloser()<CR>
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
nnoremap  z[     <Cmd>call <SID>put_foldmarker(0)<CR>
nnoremap  z]     <Cmd>call <SID>put_foldmarker(1)<CR>
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
nnoremap <silent> \ <Cmd>cd %:h<Bar>echo 'current directory is changed to ' . getcwd()<CR>
nnoremap <silent> \| <Cmd>cd ..<Bar>echo 'current directory is changed to ' . getcwd()<CR>
" nnoremap gQ gq
autocmd FileType help nnoremap <buffer> q <C-w>c
" don't close window when closing buffer
nnoremap <silent> Q <Cmd>Bclose<CR>
xnoremap <silent> Q <Cmd>Bclose<CR>
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
" spliting windows
nnoremap <leader>ws <Cmd>sp<CR>:bprev<CR>
nnoremap <leader>wv <Cmd>vsp<CR>:bprev<CR>
nnoremap <leader>wc <Cmd>close<CR>
nnoremap <leader>wn <Cmd>vne<CR>
nnoremap <leader>wo <Cmd>only<CR>
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
      \ <Cmd>call <SID>toggle_window_zoom()<CR>
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
     nnoremap <silent><buffer> q <Cmd>close<CR>
     call <SID>is_loc()
     noremap <buffer> p  <CR>zz<C-w>p
 endfunction
 function! s:is_loc()
 let wi = getwininfo(win_getid())[0]
 if wi.loclist
     nnoremap <silent><buffer> <CR> <Cmd>.ll<CR><C-w>p
 elseif wi.quickfix
     nnoremap <silent><buffer> <CR> <Cmd>.cc<CR><C-w>p
 else
     echom 'here is not quickfix and location list.'
 endif
 endfunction
"}}}
" Syntax (for vim) {{{
" Vim syntax support file
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	2001 Sep 04

" This file is used for ":syntax on".
" It installs the autocommands and starts highlighting for all buffers.

if !has('nvim')
if !has("syntax")
  finish
endif

" If Syntax highlighting appears to be on already, turn it off first, so that
" any leftovers are cleared.
if exists("syntax_on") || exists("syntax_manual")
  so <sfile>:p:h/nosyntax.vim
endif

" Load the Syntax autocommands and set the default methods for highlighting.
runtime syntax/synload.vim

" Load the FileType autocommands if not done yet.
if exists("did_load_filetypes")
  let s:did_ft = 1
else
  filetype on
  let s:did_ft = 0
endif

" Set up the connection between FileType and Syntax autocommands.
" This makes the syntax automatically set when the file type is detected.
augroup syntaxset
  au! FileType *	exe "set syntax=" . expand("<amatch>")
augroup END


" Execute the syntax autocommands for the each buffer.
" If the filetype wasn't detected yet, do that now.
" Always do the syntaxset autocommands, for buffers where the 'filetype'
" already was set manually (e.g., help buffers).
doautoall syntaxset FileType
if !s:did_ft
  doautoall filetypedetect BufRead
endif
endif
" }}}
" +GUI {{{
if has('GUI')
     let &guioptions = substitute(&guioptions, '[mTrRlLbeg]', '', 'g')
    set guioptions+=Mc!
    """Nm秒後にカーソル点滅開始
    "set guicursor=n:blinkwait2000
    "let no_buffers_menu = 1
    " set lines=60 "ウィンドウの縦幅
    " set columns=120 " ウィンドウの横幅
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
    "autodate 'Last Change: .'
    let autodate_format ='%Y/%m/%d-%H:%M:%S'
    let autodate_lines = 10
    " fullscreen
    nnoremap <C-CR> <Cmd>ScreenMode 6<CR>
    nnoremap <S-CR> <Cmd>ScreenMode 1<CR>
    " background transparency
    " autocmd vimrc GUIEnter * set transparency=235
    " insert date
    inoremap <F3> Last Change: .
    set ambiwidth=auto
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
command! -range LineCharVCount <line1>,<line2>call g:LineCharVCount()
xnoremap<silent> <C-o> <Cmd>LineCharVCount<CR>
"}}}
" Neovim {{{
if !has('nvim')
    finish
endif
    " show complettion popup in commandline.
    set display+=lastline,msgsep
    set nrformats+=unsigned
    set wildoptions=pum
    set winblend=20
    set termguicolors
    " remove end of buffer ~~~~~~~~~
    set fillchars+=eob:\ 
    "transparent completions menu
    set pumblend=15
    set inccommand=nosplit
    au vimrc TextYankPost * silent! lua vim.highlight.on_yank()
"}}}
" yank searched results
function! s:search(pat)
let l:cache = []
execute '%s/' . a:pat . '/\=add(l:cache, submatch(0))/n'
call setreg(v:register,join(l:cache, "\n"))
endfunction
command! -nargs=* SearchYank call s:search(<q-args>)
" set colorscheme
try
    exe 'colorscheme ' . g:colors_name
catch /^Vim\%((\a\+)\)\=:E185:/
    echom "colorscheme '"  . g:colors_name .  "' is not found. Using 'peachpuff' instead"
    exe 'colorscheme peachpuff'
endtry
"}}}
if !has('nvim')
    finish
endif
" for neovide initialize hook
if exists('neovide')
    set guifont:HackGenNerd:h11
    let g:neovide_refresh_rate=100
    let g:neovide_transparency=0.96
    let g:neovide_transparency=0.90
    let g:neovide_cursor_trail_length=0
    let g:neovide_cursor_animation_length=0
    let g:neovide_cursor_antialiasing=v:true
    cd ~/
        " let g:neovide_extra_buffer_frames=4
endif
if exists('g:gonvim_running')
    " for goneovim bug(20/06/30)
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

set diffopt=internal,context:10,algorithm:minimal,vertical,foldcolumn:0,indent-heuristic,filler,hiddenoff,followwrap
autocmd FileType text syntax sync minlines=50
autocmd FileType markdown syntax sync minlines=50
nnoremap <silent><C-q> <Cmd>tabclose<CR>
nnoremap <MiddleMouse> <Cmd>close<CR>
nnoremap S :%s/
" /\v(①|②|③|④|⑤|⑥|⑦|⑧|⑨|⑩)/
set updatetime=1500
vnoremap y ygv<ESC>
let g:previm_enable_realtime = 1
autocmd BufReadPre gina://* set noswapfile
function! Mdpdf()
let path = expand('%:p')
let path = shellescape(path, 1)
let cmd = 'mdpdf --border=12.7mm ' . path
execute "!" . cmd
endfunction
function! g:Vimrc_select_a_last_modified() abort
    return ['v', getpos("'["), getpos("']")]
endfunction
vnoremap y ygv<ESC>
" g/\W*\ze \/\//s/^\(\W*\) \/\zs\ze\//\=jautil#convert(submatch(1),'hiragana')
set smartindent
syntax match JISX0208Space "　" display containedin=ALL
highlight link JISX0208Space Underlined
set conceallevel=2
set concealcursor=n
let s:macromode = 0
function! MacroModeOn() abort
if s:macromode ==# 1
    return
endif
    nnoremap q @q
    nnoremap w @w
    nnoremap e @e
let s:macromode = 1
endfunction
function! MacroModeOff() abort
if s:macromode ==# 0
    return
endif
    unmap q
    unmap w
    unmap e
let s:macromode = 0
endfunction
function! Set_Font(font) abort
  execute 'set guifont=' . a:font . ':h10'
endfunction
function! s:change_lf_dos() abort
execute('edit ++ff=dos %')
write
endfunction
function! s:change_lf_unix() abort
execute('edit ++ff=unix %')
execute('%substitute/$//')
write
endfunction
command! -nargs=0 -complete=command LFdos call s:change_lf_dos()
command! -nargs=0 -complete=command LFunix call s:change_lf_unix()
nnoremap <C-6> <C-^>
augroup lsp_setup
au!
augroup END

hi link LspDiagnosticsVirtualTextError Error
hi link LspDiagnosticsVirtualTextWarning Question
sign define LspDiagnosticsSignError text= texthl=LspDiagnosticsVirtualTextError linehl= numhl=
sign define LspDiagnosticsSignWarning text= texthl=LspDiagnosticsVirtualTextWarning linehl= numhl=
let s:highlight_id = v:false
function! s:gethighlight(hi, which) abort
    let bg = synIDattr(synIDtrans(hlID(a:hi)), a:which)
    return bg
endfunction
call execute('hi HighlightDict gui=bold guifg=' .. s:gethighlight('Error', 'fg'))
call execute('hi UnderlineSpace gui=underline guisp=' .. s:gethighlight('Error', 'fg'))
function! Highlight_dict() abort
if s:highlight_id
    call clearmatches()
    let s:highlight_id = v:false
    return
endif
let s:filename="dict.txt"
let s:dict = expand('%:p:h') .. '\dict.txt'
if !filereadable(s:dict)
    let s:dict = expand('~/') .. '\dict.txt'
    if !filereadable(s:dict)
        echom 'dict file is not found'
	return
    endif
endif
let s:dict = substitute(s:dict, '\\', '\/', 'g')
if filereadable(s:dict)
    let s:lines=readfile(s:dict,1000)
    for line in s:lines
	if line !=# ''
        let word = split(line)
        call matchadd('HighlightDict',word[0])
	endif
    endfor
    call matchadd('UnderlineSpace', ' ')
    call matchadd('UnderlineSpace', '　')
    let s:highlight_id = v:true
endif
endfunction
nnoremap <F1> <cmd>call Highlight_dict()<CR>
nnoremap  <Space>wc <cmd>lua vim.lsp.diagnostic.clear(0)<CR>
command! VimShowHlItem echo synIDattr(synID(line("."), col("."), 1), "name")
command! VimShowHlGroup echo synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
hi link TSFunction Title
hi link TSConstant Constant
hi link TSConstructor Define
hi link TSLavel Number
hi link TSLabel Number
hi link TSNamespace Number
hi link TSOperator Number
hi link TSKeyword Keyword
hi link TSType Define
hi link LspDiagnosticsUnderlineError Error
hi link LspDiagnosticsUnderlineWarning Warning
" abbrev の自動生成を行う
" ref:https://zenn.dev/monaqa/articles/2020-12-22-vim-abbrev
function! s:make_abbrev_rule(rules)
  let keys = uniq(sort(map(copy(a:rules), "v:val['from']")))
  for key in keys
    let rules_with_key = filter(copy(a:rules), "v:val['from'] ==# '" .. key .. "'")
    let dict = {}
    for val in rules_with_key
      if has_key(val, 'prepose')
        let dict[val['prepose'] .. ' ' .. key] = (val['to'])
      else
        let dict[key] = val['to']
      endif
    endfor
    exec 'cnoreabbrev <expr> ' .. key .. ' '
    \ .. '(getcmdtype() !=# ":")? "' .. key .. '" : '
    \ .. 'get(' .. string(dict) .. ', getcmdline(), "' .. key .. '")'
  endfor
endfunction
call s:make_abbrev_rule([
\   {'from': 'gi', 'to': 'Gina'},
\   {'from': 'gc', 'to': 'Gina! commit -am'},
\   {'from': 'gf', 'to': 'Gina! commit --fixup HEAD'},
\   {'from': 'gp', 'to': 'Gina push'},
\   {'prepose': 'Gina commit', 'from': 'a', 'to': '--amend'},
\ ])
"
let g:vimsyn_embed='lPr'
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
function! NumCheckZen()
g/\v(１|２|３|４|５|６|７|８|９|０)/
endfunction
function! NumZentohan() abort
%s/１/1/eg
%s/２/2/eg
%s/３/3/eg
%s/４/4/eg
%s/５/5/eg
%s/６/6/eg
%s/７/7/eg
%s/８/8/eg
%s/９/9/eg
%s/０/0/eg
endfunction
"(１|２|３|４|５|６|７|８|９|０)
set packpath=
" ++once supported in Nvim 0.4+ and Vim 8.1+
if has('win32')
let g:migemodict = "C:/tools/cmigemo/dict/utf-8/migemo-dict"
endif
function! MdToText()
%s/^#\s/■/
%s/^##\s/■■/
" %s/\v^$\n\zs[^■]/　\0
%s/\v。\zs$\n\ze[^][$]//
%s/\v(^\s*)[-*]/\1・/
endfunction
" set noswapfile
nnoremap q <nop>
nnoremap Q q
" for ahk workaround
nmap <BS> <C-h>
if has('nvim')
    lua require('lsp_settings')
    lua require('telescope_config')
endif
let g:terminal_scrollback_buffer_size = 3000
set title
set titlestring=NVIM\ \[\ %{LLcd()}\ \]
" au dein VimResized * :wincmd =<CR>
"!pandoc % --pdf-engine=lualatex -V documentclass=jlreq --template=latex_template.tex -s -t latex
"!pandoc % --pdf-engine=lualatex -V documentclass=jlreq --template=latex_template.tex -s -t pdf --wrap=preserve --filter=./converter.py -o test.pdf
" autocmd vimrc Filetype markdown,text,txt call s:my_efm_config()
" function! s:my_efm_config() abort
" endfunction

hi CursorBlink guibg=#84a0c6 guifg=#161821
" au vimrc FocusGained * call s:blink(1, 'CursorBlink', '.*\%#.*')
function! s:blink(count, color, pattern)
  for i in range(a:count)
    let id = matchadd(a:color, a:pattern)
    redraw
    sleep 80m
    call matchdelete(id)
    redraw
    sleep 80m
  endfor
endfunction
" lua <<EOF
" require("mark-radar").setup()
" local opts = {
"     set_default_mappings = true,
" 	highlight_group = "RadarMark",
" 	background_highlight = true,
"     background_highlight_group = "RadarBackground",
" }
" EOF
" default
" call termopen('pandoc -f markdown -t json %|python' .. expand('~/.config/pandoc/converter.py') .. '|pandoc -f json -V documentclass=jlreq --template=template/latex_template.tex -s -t latex -o test.tex |lualatex test.tex')
" terminal pandoc -f markdown -t json %|python converter.py|pandoc -f json -V documentclass=jlreq --template=latex_template.tex -s -t latex -o test.tex |lualatex test.tex

lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {"c"},  -- list of language that will be disabled
  },
}
EOF
let s:lsptoggle_switch = v:false
command! -nargs=0 -complete=command LspToggle call s:lspdefinetoggleaucmd()
function! s:lspdefinetoggleaucmd() abort
    if !s:lsptoggle_switch
        let s:lsptoggle_switch = v:true
        augroup lsptoggle
            au!
            au BufEnter * LspStop
        augroup END
        edit %
        echom "Lsp OFF"
    else
        augroup lsptoggle
            au!
        augroup END
        let s:lsptoggle_switch = v:false
        echom "Lsp ON"
    endif
endfunction

" ウィンドウを閉じた時一つ前のウィンドウに戻る
" seems buggy
" let g:prev_win = [0, 0]
" function! g:Goto_prev_win()
" 	call win_gotoid(g:prev_win[1])
" endfunction
" function! g:Save_prev_win()
"     let g:prev_win[1] = g:prev_win[0]
" 	let g:prev_win[0] = win_getid()
" endfunction

" autocmd WinLeave * call g:Goto_prev_win()
" autocmd WinEnter * call g:Save_prev_win()
au VimEnter * call s:remove_focus_event()
function! s:remove_focus_event()
au! gitgutter FocusLost *
au! gitgutter FocusGained *
au! ConflictMarkerDetect FocusLost *
au! ConflictMarkerDetect FocusGained *
endfunction
" Customize global settings

" Use around source.
" https://github.com/Shougo/ddc-around

" Use matcher_head and sorter_rank.
" https://github.com/Shougo/ddc-matcher_head
" https://github.com/Shougo/ddc-sorter_rank
call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \   'matchers': ['matcher_head'],
      \   'sorters': ['sorter_rank']},
      \ 'eskk': {'mark': 'eskk', 'matchers': [], 'sorters': []},
      \ })

" Change source options
call ddc#custom#patch_global('sourceOptions', {
      \ 'around': {'mark': 'A'},
      \ })
call ddc#custom#patch_global('sourceParams', {
      \ 'around': {'maxSize': 500},
      \ })
" Customize settings on a filetype
call ddc#custom#patch_global('sources', ['eskk','around','buffer','nvim-lsp'])

call ddc#enable()
" vim:set foldmethod=marker:

