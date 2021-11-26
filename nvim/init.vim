"ork's vimrc
set fileformats=unix,dos,mac
set encoding=utf-8
set fileencodings=utf-8,ucs2le,ucs-2,iso-2022-jp,euc-jp,sjis,cp932
runtime! C:\Users\t_kuriki\Downloads\nvui-win64\nvui\vim\plugin\*.vim
" ------------------------------------------------------------------------------
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

if executable('win32yank.exe')
if has('wsl') && getftype(exepath('win32yank.exe')) == 'link'
  let win32yank = resolve(exepath('win32yank.exe'))
else
  let win32yank = 'win32yank.exe'
endif
let g:clipboard = {
      \   'name': 'myClipboard',
      \   'copy': {
      \      '+': [win32yank, '-i', '--crlf'],
      \      '*': [win32yank, '-i', '--crlf'],
      \    },
      \   'paste': {
      \      '+': [win32yank, '-o', '--lf'],
      \      '*': [win32yank, '-o', '--lf'],
      \   },
      \   'cache_enabled': 0,
      \ }
else
call  provider#clipboard#Executable()
endif
"---------------------------------------------------------------------
if has('win32')
    let g:python3_host_prog = expand('~\AppData\Local\Programs\Python\Python39\python.exe')
   " let g:python3_host_prog = 'C:\Python39\python.exe'
    let g:migemodict = "C:/tools/cmigemo/dict/utf-8/migemo-dict"
endif
let mapleader = "\<Space>"
if has('nvim')
"}}}
" dein.vim {{{
" let g:dein#auto_recache = 1
let g:dein#lazy_rplugins=1
let g:dein#default_options = { 'merged': v:true }
let g:dein#install_max_processes = 8
let g:dein#install_process_timeout = 300
" let g:dein#inline_vimrcs=[expand('~/dotfiles/nvim/config.vim')]
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let s:dein_is_initializing = 0
if &runtimepath !~# '/dein.vim'
      if !isdirectory(s:dein_repo_dir)
        if !executable('git')
          echo 'Please install git or update your path to include the git executable!'
        endif
        echo 'install dein.vim ...'
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
        let s:dein_is_initializing = 1
      endif
endif
let s:dein_path =  fnamemodify(s:dein_repo_dir, ':p')
execute 'set runtimepath+=' . s:dein_path

let s:toml      = '~/dotfiles/nvim/rc/dein.toml'
let s:lazy_toml = '~/dotfiles/nvim/rc/dein_lazy.toml'
let s:lua_toml = '~/dotfiles/nvim/rc/dein_lua.toml'
let s:exp_toml = '~/dotfiles/nvim/rc/dein_experimental.toml'
let s:denops_toml = '~/dotfiles/nvim/rc/dein_denops.toml'
let s:cmp_toml = '~/dotfiles/nvim/rc/dein_cmp.toml'
let s:no_dependency_toml = '~/dotfiles/nvim/rc/dein_no_dependency.toml'
let s:lsp_toml = '~/dotfiles/nvim/rc/dein_nvim_lsp.toml'
let s:myvimrc = expand('$MYVIMRC')
if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir,[s:myvimrc,s:toml,s:lazy_toml, s:denops_toml])
    if has('nvim')
    call dein#load_toml(s:toml,      {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})
    call dein#load_toml(s:lsp_toml,  {'merged': 0})
    call dein#load_toml(s:lua_toml,  {'merged': 0})
    endif
    " call dein#load_toml(s:exp_toml, {'merged': 0})
    call dein#load_toml(s:denops_toml, {'merged': 0})
    " call dein#load_toml(s:cmp_toml, {'merged': 0})
    call dein#end()
    call dein#save_state()
    if !has('vim_starting')
        call dein#call_hook('source')
        call dein#call_hook('post_source')
    endif
endif
command! -nargs=? -complete=command DeinInstall  call dein#install()
command! -nargs=? -complete=command DeinUpdate call dein#update()
command! -nargs=? -complete=command DeinRecache call dein#recache_runtimepath() |echo "Recache Done"
" for dein dein#util#_check_vimrcs() bug workaround

au! dein BufWritePost
if s:dein_is_initializing
    call dein#install()
    let s:dein_is_initializing = 0
    source $myvimrc
endif

endif
filetype plugin indent on
syntax on

set notermguicolors
set swapfile
set undofile
if !has('nvim')
    set directory=~/.backup/vim/swap
    set undodir=~/.backup/vim/undo " put together undo files
    set backupdir=~/.backup/vim/backup " put together undo files
else
    set directory=~/.backup/nvim/swap
    set undodir=~/.backup/nvim/undo " put together undo files
    set backupdir=~/.backup/nvim/backup " put together undo files
endif
set autoread                " reload editing file if the file changed externally
set backup
"}}}
" Visual  {{{
" language C
set ambiwidth=double
set shortmess=aAcTtF
set showtabline=2   " always show tabline
set number
set signcolumn=number  " show signcolumn
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
autocmd vimrc ColorScheme * highlight! Underlined cterm=underline gui=underline guifg=NONE guisp=#84a0c6
"}}}
" Editing {{{
set virtualedit=block     "move cursor to one more char than end of line
set wrap
" Scroll
set scrolloff=5
set sidescrolloff=5
set sidescroll=1
" add japanese matchpairs
set noshowmatch       " highlight matched pairs
set matchtime=1     " highlighting long
set matchpairs+=<:>,（:）,「:」,『:』,【:】,［:］,＜:＞,〔:〕
set nojoinspaces
set textwidth=0             " don't let insert auto indentation
set updatecount=50
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
    setlocal signcolumn=no
    " delete useless commands
    silent g/^qa\?!\?$/d
    silent g/^e\?!\?$/d
    silent g/^wq\?a\?!\?$/d
    " move to nice position
    " CmdwinEnter seems not to fire below commands
    " setlocal signcolumn=no
    " setlocal scrolloff=0
    nnoremap <buffer><silent>q <Cmd>close<CR>
    norm $
    norm G
    map <buffer> <CR> <CR>
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
vnoremap <silent>j gj
vnoremap <silent>k gk
" moving tip/end of a line
nnoremap <S-l> $
nnoremap <S-h> ^
vnoremap <S-l> g_
vnoremap <S-h> ^
onoremap <S-l> $
onoremap <S-h> ^
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
nnoremap , @q
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
" }}}
" +GUI {{{
if has('GUI')
     let &guioptions = substitute(&guioptions, '[mTlLbeg]', '', 'g')
    set guioptions+=Mc!
    """Nm秒後にカーソル点滅開始
    "set guicursor=n:blinkwait2000
    "let no_buffers_menu = 1
    set lines=45 "ウィンドウの縦幅
    set columns=150 " ウィンドウの横幅
    winpos 500 10 " ウィンドウの起動時の位置
    set guifont:HackGenNerd:h12
    set renderoptions=type:directx,renmode:5,geom:1
    set imsearch=0
    set statusline=%<%F\ %h%m%r%=%-14.(%l,%c%V%)\ %P
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

if !has('nvim')
    set runtimepath+=~\.cache\dein\repos\github.com\thinca\vim-singleton
    set runtimepath+=~\.cache\dein\repos\github.com\mattn\webapi-vim
	call singleton#enable()
    finish
endif
" highlight {{{
" for foldcolumn
" hi! link SpecialKey Comment

" edit fold column
set background=dark
colorscheme iceberg
let g:lightline.colorscheme = 'iceberg'
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
if has('nvim')

lua require('lsp_settings')
  set shada=!,'200,<100,s10,h
    autocmd vimrc TermOpen term://* setlocal nonumber scrolloff=0 signcolumn=no nobuflisted
  autocmd vimrc TermOpen * startinsert
    hi! PmenuSel blend=0
else
  set viminfo=!,'200,<100,s10,h,n~/.vim/.viminfo
set rtp+=$VIM/vim82
    autocmd vimrc TerminalOpen term://* setlocal nonumber scrolloff=0 signcolumn=no nobuflisted
  autocmd vimrc WinEnter * if &buftype ==# 'terminal' | normal i | endif
endif
    " show complettion popup in commandline.
    set display=lastline,msgsep,truncate
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
"}}}
" for neovide initialize hook
if exists('neovide') || exists('nvy')
    " フォント変更後に画面を再描画
set guifont:HackGenNerd:h12
    let g:neovide_refresh_rate=100
    let g:neovide_transparency=0.90
    " let g:neovide_cursor_antialiasing=v:true
    " cd ~/
    " let g:neovide_extra_buffer_frames=4
    let g:neovide_cursor_trail_size=0
endif

au BufRead,BufNew * ++once let g:neovide_cursor_trail_length=0 | let g:neovide_cursor_animation_length=0
set diffopt=internal,context:10,algorithm:minimal,vertical,foldcolumn:0,indent-heuristic,filler,hiddenoff,followwrap
autocmd FileType text syntax sync minlines=50
autocmd FileType markdown syntax sync minlines=50
autocmd FileType lua setlocal tabstop=2
autocmd FileType typescript setlocal tabstop=2
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
" syntax match JISX0208Space "　" display containedin=ALL
" highlight link JISX0208Space Underlined
" set conceallevel=2
" set concealcursor=n
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
command! -nargs=? -complete=command LFdos call s:change_lf_dos()
command! -nargs=? -complete=command LFunix call s:change_lf_unix()
nnoremap <C-6> <C-^>
augroup lsp_setup
au!
augroup END

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

" ++once supported in Nvim 0.4+ and Vim 8.1+
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
let g:terminal_scrollback_buffer_size = 3000
" set titlestring=NVIM\ \[\ %{LLcd()}\ \]

"!pandoc % --pdf-engine=lualatex -V documentclass=jlreq --template=latex_template.tex -s -t latex
"!pandoc % --pdf-engine=lualatex -V documentclass=jlreq --template=latex_template.tex -s -t pdf --wrap=preserve --filter=./converter.py -o test.pdf

    " lua require('lsp_settings')
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
" set packpath+=C:/Users/ork/AppData/Local/nvim-data/site
" lua <<EOF
" vim.cmd [[packadd packer.nvim]]


" au BufRead * call s:remove_focus_event()
" function! s:remove_focus_event()
" au! gitgutter FocusLost *
" au! gitgutter FocusGained *
" au! ConflictMarkerDetect FocusLost *
" au! ConflictMarkerDetect FocusGained *
" endfunction
autocmd CmdWinEnter [:>] syntax sync minlines=1 maxlines=1

" imap <C-j> <Plug>(eskk:toggle)
" cmap <C-j> <Plug>(eskk:toggle)

hi! link DiagnosticsVirtualTextError Error
hi! link DiagnosticsVirtualTextWarning Question
sign define DiagnosticSignError text= texthl=DiagnosticVirtualTextError linehl= numhl=
sign define DiagnosticSignWarn text= texthl=DiagnosticVirtualTextWarn linehl= numhl=

" autocmd CmdlineLeave [:>/?=@] if get(g:, 'skkeleton#enabled', v:false) | call skkeleton#request('disable', []) | endif

if exists("g:nvui")
set guicursor=n-v-c:Cursor-blinkon0,i-ci:ver20-Cursor,r-cr:hor20
NvuiAnimationsEnabled 0
set guifont:HackGenNerd:h12
NvuiOpacity 0.93
NvuiCursorFrametime 0
NvuiFrameless 1
NvuiTitlebarFontFamily RockWell
NvuiTitlebarFontSize 11
NvuiTitlebarSeparator ' - '
set shortmess+=I
set notitle
nnoremap <F1> <cmd>NvuiToggleFullscreen<CR>
let g:nvui_tb_separator = ' - '
" NvuiFrameless 1
" NvuiTitlebarFontFamily Arial
" NvuiTitlebarFontSize 11
" NvuiTitlebarFg #5e6482
" NvuiTitlebarBg #0f1117
endif
let g:jupytext_enable = 0

" lua require('gitsigns').setup()
" lua require('nvim-autopairs').setup{}
" lua <<EOF
" require('telescope').setup{
"   defaults = {
"       border = false,
"     -- Default configuration for telescope goes here:
"     -- config_key = value,
"     -- ..
"   },
"   pickers = {
"     -- Default configuration for builtin pickers goes here:
"     -- picker_name = {
"     --   picker_config_key = value,
"     --   ...
"     -- }
"     -- Now the picker_config_key will be applied every time you call this
"     -- builtin picker
"   },
"   extensions = {
"     -- Your extension configuration goes here:
"     -- extension_name = {
"     --   extension_config_key = value,
"     -- }
"     -- please take a look at the readme of the extension you want to configure
"   }
" }
" EOF
" hi! link TelescopeNormal Pmenu

set inccommand=

function! GetRaw()
let isbn = expand('<cword>')
let raw = system(['curl', '-s', 'https://api.openbd.jp/v1/get?isbn=' . isbn])
let s = json_decode(raw)[0]
echom s
endfunction
function! Isbn()
let hankei = {
\ 'B108': 'A5',
\ 'B109': 'B5',
\ 'B110': 'B6',
\ 'B111': '文庫',
\ 'B112': '新書',
\ 'B119': '46',
\ 'B120': '46変形',
\ 'B121': 'A4',
\ 'B122': 'A4変形',
\ 'B123': 'A5変形',
\ 'B124': 'B5変形',
\ 'B125': 'B6変形',
\ 'B126': 'AB',
\ 'B127': 'B7',
\ 'B128': '菊',
\ 'B129': '菊変形',
\ 'B130': 'B4',
\ }

let output = {}
let isbn = expand('<cword>')
let raw = system(['curl', '-s', 'https://api.openbd.jp/v1/get?isbn=' . isbn])
let s = json_decode(raw)[0]
if type(s) != v:t_dict
    echom 'no data'
    return
endif
for i in keys(s.summary)
    let output[i] = s.summary[i]
endfor
try
let output['Price'] = s.onix.ProductSupply.SupplyDetail.Price[0].PriceAmount
let output['hankei'] = hankei[s.onix.DescriptiveDetail.ProductFormDetail]
let output['PageNum'] = s.onix.DescriptiveDetail.Extent[0].ExtentValue
let output['AuthorBio'] = s.onix.DescriptiveDetail.Contributor[0].BiographicalNote
catch
endtry
try
let output['見出し'] = s.onix.CollateralDetail.TextContent[0].Text
let output['概要'] = s.onix.CollateralDetail.TextContent[1].Text
let output['目次'] = s.onix.CollateralDetail.TextContent[2].Text
catch
endtry
let isbn10 = substitute(isbn,'^978','','')
let output['Amazon'] = 'https://amazon.co.jp/dp/' .. isbn10
let koumoku = [
    \ 'isbn',
    \ 'title',
    \ 'author',
    \ 'publisher',
    \ 'pubdate',
    \ 'PageNum',
    \ 'Price',
    \ 'hankei',
    \ 'Amazon',
    \ '概要',
    \ '見出し',
    \ '目次',
    \ 'AuthorBio',
    \ 'cover',
    \ 'series',
    \ ]

" if exists('s:id')
    " call win_gotoid(s:id)
    " edit `=tempname()`
" else
split
edit `=tempname()`
" let s:id = win_getid()
" endif
setlocal filetype=isbn
  setlocal bufhidden=hide
  setlocal buftype=nofile
  setlocal nobuflisted
  setlocal nofoldenable
  setlocal nolist
  setlocal nomodeline
  setlocal nospell
  setlocal noswapfile
nnoremap <buffer> q :quit<CR>
for k in koumoku
    if has_key(output, k)
        if match(output[k], '\n') > -1
            call append(line('$'), '')
            call append(line('$'), k .. ': -----')
            let o = split(output[k], '\n')
            for l in o
                call append(line('$'), l)
            endfor
            call append(line('$'), '-----')
            call append(line('$'), '')
        else
            call append(line('$'), k . ': ' . output[k])
        endif
    endif
endfor
endfunction
nmap <silent> gm <cmd>call Isbn()<CR>
" vim:set foldmethod=marker:
