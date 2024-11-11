"ork's vimrc
let s:is_nvim = has('nvim')
if s:is_nvim
  lua if vim.loader then vim.loader.enable() end
endif
augroup vimrc
  autocmd!
augroup END
" language en_US
filetype plugin indent off
syntax off
" don't load unused default plugins
let g:did_load_ftplugin         = 1
let g:skip_loading_mswin        = 1
let g:did_install_default_menus = 1
let g:did_install_syntax_menu   = 1
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
let g:loaded_node_provider = 1
let g:loaded_perl_provider = 1
let g:loaded_python_provider = 1
let g:loaded_ruby_provider = 1
let g:did_indent_on             = 1
let g:did_load_filetypes        = 1
let g:loaded_2html_plugin       = 1
let g:loaded_man                = 1
let g:loaded_matchit            = 1
let g:loaded_remote_plugins     = 1
let g:loaded_shada_plugin       = 1
let g:loaded_spellfile_plugin   = 1
let g:loaded_tutor_mode_plugin  = 1

silent! call execute('source ' .. expand('~/local_vimrc'))

if exists('neovide')
  set guifont=PlemolJP\ Console\ NF:h13:#e-subpixelantialias
  set linespace=0
  let g:neovide_padding_top = 0
  let g:neovide_padding_bottom = 0
  let g:neovide_padding_right = 0
  let g:neovide_padding_left = 0
  let g:neovide_refresh_rate=60
  let g:neovide_scroll_animation_length = 0.05
  let g:neovide_unlink_border_highlights = v:true
  let g:neovide_transparency=0.93
  let g:neovide_profiler = v:false
  let g:neovide_scroll_animation_far_lines = 1
  let g:neovide_confirm_quit = v:true
  cd ~/
  let g:neovide_cursor_trail_size=0
  let g:neovide_remember_window_size=v:true
  let g:neovide_remember_window_position=v:true
  let g:neovide_cursor_animation_length=0
  let g:neovide_window_blurred=v:false
  " let g:neovide_scale_factor=1.0
  " let g:neovide_refresh_rate_idle = 5
endif

if executable('win32yank.exe')
  " if has('wsl') && getftype(exepath('win32yank.exe')) == 'link'
  "   let win32yank = resolve(exepath('win32yank.exe'))
  " else
    let win32yank = 'win32yank.exe'
  " endif
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
let mapleader = "\<Space>"

" const s:dpp_base = '~/.cache/dpp/'

" " Set dpp source path (required)
" const s:dpp_src = '~/.cache/dpp/repos/github.com/Shougo/dpp.vim'
" const s:dpp_ext = [
" \ 'Shougo/dpp-ext-installer',
" \ 'Shougo/dpp-ext-lazy',
" \ 'Shougo/dpp-ext-toml',
" \ 'Shougo/dpp-ext-local',
" \ 'Shougo/dpp-protocol-git',
" \ ]
" const s:denops_src = '~/.cache/dpp/repos/github.com/vim-denops/denops.vim'

" " Set dpp runtime path (required)
" execute 'set runtimepath^=' .. s:dpp_src
" for item in s:dpp_ext
"   execute 'set runtimepath+=~/.cache/dpp/repos/github.com/' . item
" endfor

" if dpp#min#load_state(s:dpp_base)
"   " NOTE: dpp#make_state() requires denops.vim
" endif
"   execute 'set runtimepath^=' .. s:denops_src
"   autocmd User DenopsReady
"   \ call dpp#make_state(s:dpp_base, expand('~/dotfiles/nvim/dpp_config.ts'))

" " Attempt to determine the type of a file based on its name and
" " possibly its " contents. Use this to allow intelligent
" " auto-indenting " for each filetype, and for plugins that are
" " filetype specific.
" filetype indent plugin on

" " Enable syntax highlighting
" if has('syntax')
"   syntax on
" endif

let $CACHE = expand('~/.cache')
if !isdirectory($CACHE)
  call mkdir($CACHE, 'p')
endif
if &runtimepath !~# '/dein.vim'
  let s:dein_dir = fnamemodify('dein.vim', ':p')
  if !isdirectory(s:dein_dir)
    let s:dein_dir = $CACHE .. '/dein/repos/github.com/Shougo/dein.vim'
    if !isdirectory(s:dein_dir)
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
    endif
    let s:dein_is_initializing = 1
  endif
  execute 'set runtimepath^=' .. substitute(
        \ fnamemodify(s:dein_dir, ':p') , '[/\\]$', '', '')
endif

let g:dein#install_progress_type = "floating"

if s:is_nvim
let g:dein#default_options = { 'merged': v:true }
else
let g:dein#default_options = { 'merged': v:false }
endif
let g:dein#install_max_processes = 8
let g:dein#install_process_timeout = 1000
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let s:dein_is_initializing = 0

let s:toml      = '~/GoogleDrive/config/dotfiles/nvim/rc/dein.toml'
let s:lazy_toml = '~/GoogleDrive/config/dotfiles/nvim/rc/dein_lazy.toml'
let s:lua_toml = '~/GoogleDrive/config/dotfiles/nvim/rc/dein_lua.toml'
let s:denops_toml = '~/GoogleDrive/config/dotfiles/nvim/rc/dein_denops.toml'

let s:myvimrc = expand('$MYVIMRC')
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir,[s:myvimrc,s:toml,s:lazy_toml, s:denops_toml])
  call dein#load_toml(s:toml,      {'lazy': 0})
  if s:is_nvim
    call dein#load_toml(s:denops_toml, {'if': executable('deno')})
    call dein#load_toml(s:lua_toml, {'lazy': 1})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})
  endif
  call dein#end()
  call dein#save_state()
endif
if !has('vim_starting')
  call dein#call_hook('source')
  call dein#call_hook('post_source')
endif
command! -nargs=? -complete=command DeinInstall  call dein#install()
command! -nargs=? -complete=command DeinUpdate call dein#update()
command! -nargs=? -complete=command DeinRecache call dein#recache_runtimepath() |echo "Recache Done"
command! -nargs=? -complete=command UpdateConflictPlugin Gin ++wait stash | Gin ++wait pull | Gin ++wait stash pop
if !v:vim_did_enter
  function! DeinLoader() abort
    source $MYVIMRC
    call dein#install()
    echo "Recache"
    call dein#recache_runtimepath()
  endfunction
endif

filetype plugin indent on
syntax on

" for dein dein#util#_check_vimrcs() bug workaround
au! dein BufWritePost
if s:dein_is_initializing
  call dein#install()
  let s:dein_is_initializing = 0
  source $myvimrc
endif
autocmd vimrc VimEnter * call s:vimrc_VimEnter_hook()
function! s:vimrc_VimEnter_hook() abort
call dein#call_hook('post_source')
endfunction
set fileformats=unix,dos,mac
set fileencodings=utf-8,cp932,iso-2022-jp,euc-jp,sjis,utf-16le

set notermguicolors
set swapfile
set undofile
set autoread
set nobackup
set nowritebackup
if !s:is_nvim
  set directory=~/.backup/vim/swap
  set undodir=~/.backup/vim/undo
  " set backupdir=~/.backup/vim/backup
else
  " set directory=~/.backup/nvim/swap
  " set undodir=~/.backup/nvim/undo
endif

" language C
set ambiwidth=single
set shortmess=ltToOCF
set showtabline=2
set number
set signcolumn=number
set laststatus=2
set cmdheight=1
set noshowcmd
set noshowmode
set cursorline
set cursorlineopt=screenline,number
set cinwords=
set list
set listchars=tab:^-,trail:␣,extends:\ ,precedes:«,nbsp:%
set modelines=5
set termguicolors
set t_Co=256
set synmaxcol=1500
set belloff=all
set fillchars+=vert:\ ,fold:\ ,diff:\ ,eob:~
set nrformats+=unsigned
set hidden
set splitright
set noruler
set wildmenu
set wildmode=longest:full,full
set previewheight=10
set helpheight=15
set helplang=en,ja
set pumheight=12
set updatetime=1000
set virtualedit=block
set wrap
" Scroll
set scrolloff=5
set sidescrolloff=5
set sidescroll=1
set noshowmatch
set matchtime=1
set matchpairs+=<:>,（:）,「:」,『:』,【:】,［:］,＜:＞,〔:〕,":",':',“”
set nojoinspaces
set textwidth=0
set updatecount=50
set tabstop=2
set expandtab
set softtabstop=-1
let g:vim_indent_cont = 4
set autoindent
set nosmartindent
set shiftwidth=2
set formatoptions=roqn2M1mj]
au vimrc FileType * set fo-=o
set iskeyword+=-,:
set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
set complete=.,w,b,u
set history=1000
set clipboard+=unnamed,unnamedplus
" set clipboard=
set mouse=a
set winheight=1
set winwidth=1
set cmdwinheight=8
set equalalways
" for cmdwin
autocmd vimrc CmdwinEnter * call <SID>cmdwin_settings()
function! s:cmdwin_settings() abort
  setlocal signcolumn=no
  " delete useless commands
  silent g/^qa\?!\?$/de
  silent g/^e\?!\?$/de
  silent g/^wq\?a\?!\?$/de
  nnoremap <buffer><silent>q <Cmd>close<CR>
  norm $
  norm G
  map <buffer> <CR> <CR>
endfunction
autocmd vimrc CmdwinLeave * call histdel('/', -1)

set completeopt=menuone,longest
set completeopt-=preview
set indentkeys=0{,0},0),0],:,0#,o,O,e
set backspace=indent,eol,start
let g:vimsyn_embed='lPr'
" nicely folding

function! s:is_view_available() abort
  if !&buflisted || &buftype !=# ''
    return 0
  endif
  return 1
endfunction

" au vimrc BufReadPost * silent! norm! '^
" augroup MyAutoCmd
"   autocmd!
"   autocmd MyAutoCmd BufWinLeave * if <SID>is_view_available() | mkview | echom expand('%') | endif
"   autocmd MyAutoCmd BufReadPost * if <SID>is_view_available() | loadview |  endif
" augroup END
" set viewoptions=cursor

nnoremap <CR> o<ESC>
" moving visible lines by j/k
nnoremap <silent>j gj
nnoremap <silent>k gk
vnoremap <silent>j gj
vnoremap <silent>k gk
" nnoremap <silent><expr> l charcol('$') - 1 > 0 ? (charcol('.') ==# charcol('$') - 1 ? "j^" : "l") : "j^"
" nnoremap <silent><expr> h col('.') ==# 1 ? "k$" : "h"
" moving tip/end of a line
nnoremap <S-l> $
nnoremap <S-h> ^
vnoremap <S-l> g_
vnoremap <S-h> ^
onoremap <S-l> $
onoremap <S-h> ^

nnoremap <C-f> <Cmd>call <SID>zz_if_not_near_eof()<CR>
nnoremap <C-b> <C-b><Cmd>call <SID>zz_C_B()<CR>
function! s:zz_C_B() abort
  if line('.') > winheight(0)
    norm! z.
  else
    norm! gg
  endif
endfunction
function! s:zz_if_not_near_eof() abort
  if line('$') - line('.') < winheight(0)/2
    norm! G
  else
    exe "normal! \<c-f>z."
  endif
endfunction

nnoremap <C-d> <C-d>
nnoremap <C-u> <C-u>
nnoremap <C-o> <C-o>zz

nnoremap m `
nnoremap M m
vnoremap m `
vnoremap M m
vnoremap <C-o> <ESC>m><C-O>m<gvo

nnoremap S :%s/
vnoremap S :s/
" moving around buffers
nnoremap <silent><Leader>h <Cmd>bprev!<CR>
nnoremap <silent><Leader>l <Cmd>bnext!<CR>
" moving around tabpages
nnoremap <silent> <C-L> <Cmd>tabnext<CR>
nnoremap <silent> <C-H> <Cmd>tabprevious<CR>
" native <TAB> is useful
nnoremap <C-p> <TAB>zz
vnoremap <C-p> <C-i>
xnoremap <C-p> <C-i>

nmap ; :
vmap ; :
xmap ; :
inoremap jk <esc>
nnoremap <silent> <leader>v <Cmd>e $MYVIMRC<CR>
nnoremap <silent> <Leader><leader>v <Cmd>source $MYVIMRC<bar>echom 'vimrc reloaded'<CR>
" source opening vim script
nnoremap <Leader><leader>s <Cmd>call <SID>source_script('%')<CR>
function! s:source_script(path) abort
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

nnoremap q <nop>
nnoremap Q q
" for ahk workaround
" nmap <BS> <C-h>
nnoremap , @q
xnoremap , @q
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-a> <HOME>
inoremap <C-e> <END>
inoremap <C-l> <NOP>
nnoremap Y y$
xnoremap Y y$`]
xnoremap y ygv<ESC>
nnoremap <leader>j o<ESC>k
nnoremap <leader>k O<ESC>j
nnoremap <silent> <C-q> <cmd>tabclose!<CR>
vnoremap < <gv
vnoremap > >gv
vnoremap > >gv
inoremap <expr><F2> strftime("%Y%m%d")
cnoremap <expr><F2> strftime("%Y%m%d")
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-a> <C-b>
cnoremap <C-q> <C-f>
cnoremap <C-p> <UP>
cnoremap <C-n> <Down>
cnoremap <silent> <S-Tab> <C-p>
tnoremap <expr> <C-n> fnamemodify(b:term_title, ':t') == "cmd.exe" ? "\<Down>" : "\<C-n>"
tnoremap <expr> <C-p> fnamemodify(b:term_title, ':t') == "cmd.exe" ? "\<UP>" : "\<C-p>"

inoremap zn 〓
inoremap zb ■
inoremap zm ●
inoremap zss ▼
inoremap zsu ▲
inoremap zha ☆
inoremap zv ★
inoremap zx ○
inoremap zds ◇
inoremap zdk ◆
inoremap z1 １
inoremap z2 ２
inoremap z3 ３
inoremap z4 ４
inoremap z5 ５
inoremap z6 ６
inoremap z7 ７
inoremap z8 ８
inoremap z9 ９
inoremap z0 ０
inoremap zz0 ⓪
inoremap zz1 ①
inoremap zz2 ②
inoremap zz3 ③
inoremap zz4 ④
inoremap zz5 ⑤
inoremap zz6 ⑥
inoremap zz7 ⑦
inoremap zz8 ⑧
inoremap zz9 ⑨
inoremap z( （
inoremap z) ）
inoremap z[ 「
inoremap z] 」
inoremap z. …
inoremap z/ ・
inoremap z, ●
inoremap z<space>  　

cnoremap zn 〓
cnoremap zb ■
cnoremap zm ●
cnoremap zha ☆
cnoremap zv ★
cnoremap zx ○
cnoremap zds ◇
cnoremap zdk ◆
cnoremap z1 １
cnoremap z2 ２
cnoremap z3 ３
cnoremap z4 ４
cnoremap z5 ５
cnoremap z6 ６
cnoremap z7 ７
cnoremap z8 ８
cnoremap z9 ９
cnoremap z0 ０
cnoremap zz0 ⓪
cnoremap zz1 ①
cnoremap zz2 ②
cnoremap zz3 ③
cnoremap zz4 ④
cnoremap zz5 ⑤
cnoremap zz6 ⑥
cnoremap zz7 ⑦
cnoremap zz8 ⑧
cnoremap zz9 ⑨
cnoremap z( （
cnoremap z) ）
cnoremap z[ 「
cnoremap z] 」
cnoremap z. …
cnoremap z/ ・
cnoremap z, ●
cnoremap z<space>  　
"terminal
tnoremap <Esc> <C-\><C-n>

nnoremap <silent> \ <Cmd>cd %:h<Bar>echo 'cd: ' . getcwd()<CR>
nnoremap <silent> \| <Cmd>cd ..<Bar>echo 'cd: ' . getcwd()<CR>
autocmd FileType help nnoremap <buffer> q <C-w>c
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
" mouse mapping
nmap <S-LeftMouse> <CR>
set mousetime=10
nmap <2-LeftMouse> <CR>

nnoremap <expr> i empty(getline('.')) ? '"_cc' : 'i'
nnoremap <expr> A empty(getline('.')) ? '"_cc' : 'A'

autocmd vimrc FileType qf call s:my_qf_setting()
function! s:my_qf_setting() abort
  set modifiable
  " nnoremap <buffer> <CR> :<C-u>.cc<CR>
  nnoremap <silent><buffer> q <Cmd>close<CR>
  setlocal errorformat=%f\|%l\ col\ %c\|\ %m
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

if has('GUI')
  let &guioptions = substitute(&guioptions, '[mTlLbeg]', '', 'g')
  set guioptions+=Mc!
  set renderoptions=type:directx,renmode:5,geom:1
  set guifont:HackGen\ Console\ NFJ:h11
  set imsearch=0
endif

if s:is_nvim
  set shada=!,'10,<100,s10,h
  set display=lastline,msgsep,truncate
  set wildoptions=pum
  set pumblend=5
  au vimrc TextYankPost * silent! lua vim.highlight.on_yank()
  set inccommand=nosplit
  set winblend=20
  function! s:gethighlight(hi, which) abort
    let bg = synIDattr(synIDtrans(hlID(a:hi)), a:which)
    return bg
  endfunction
  call execute('hi HighlightDict gui=bold guifg=' .. s:gethighlight('Error', 'fg'))
  call execute('hi UnderlineSpace gui=underline guisp=' .. s:gethighlight('Error', 'fg'))
  nnoremap <F1> <cmd>call vimrc#Highlight_dict()<CR>

  autocmd CmdWinEnter [:>] syntax sync minlines=1 maxlines=1
  hi! link DiagnosticsVirtualTextError Error
  hi! link DiagnosticsVirtualTextWarning Question
  sign define DiagnosticSignError text= texthl=DiagnosticVirtualTextError linehl= numhl=
  sign define DiagnosticSignWarn text= texthl=DiagnosticVirtualTextWarn linehl= numhl=
  set winbar=%F%m
else
  set viminfo=!,'200,<100,s10,h,n~/.vim/.viminfo
  set rtp+=C:/tools/vim/vim90
  packadd! editexisting
  autocmd vimrc TerminalOpen term://* setlocal nonumber scrolloff=0 signcolumn=no nobuflisted
  autocmd vimrc WinEnter * if &buftype ==# 'terminal' | normal i | endif
endif

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

function! s:change_lf_dos() abort
  execute('edit ++ff=dos %')
  write
endfunction

function! s:change_lf_unix() abort
  execute('edit ++ff=unix %')
  execute('%substitute/\r//')
  write
endfunction
command! -nargs=? -complete=command LFdos call s:change_lf_dos()
command! -nargs=? -complete=command LFunix call s:change_lf_unix()
nnoremap <C-6> <C-^>

let s:highlight_id = v:false

command! ShowHlItem echo synIDattr(synID(line("."), col("."), 1), "name")
command! ShowHlGroup echo synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
command! -nargs=? -complete=command ToUtf8Unix call vimrc#ToUtf8Unix()
command! -nargs=? -complete=command ToShiftJisDos call vimrc#ToShiftJisDos()
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

" g/\W*\ze \/\//s/^\(\W*\) \/\zs\ze\//\=jautil#convert(submatch(1),'hiragana')

function! MdToText()
  %s/^#\s/■/
  %s/^##\s/■■/
  " %s/\v^$\n\zs[^■]/　\0
  %s/\v。\zs$\n\ze[^][$]//
  %s/\v(^\s*)[-*]/\1・/
endfunction

let g:terminal_scrollback_buffer_size = 3000

nnoremap <silent> gm <cmd>call vimrc#isbn()<CR>
nnoremap gM :call vimrc#PostIsbnFromClipboard()<CR>

au vimrc FileType vim setlocal indentexpr=
au vimrc FileType vim setlocal tabstop=2
au dein FileType toml call dein#toml#syntax()
au vimrc FileType lua setlocal tabstop=2

function! s:move_to_char_pos(char)
  if search(a:char, 'cW', line("w$"))

    norm! "_xa
  endif
  startinsert
endfunction

inoremap <silent> <c-l> <C-g>u<ESC><cmd>call <SID>move_to_char_pos('★')<CR>

" let g:denops#debug = v:false
" let g:denops#trace = v:false
if !has('mac')
  " let g:denops_server_addr = '127.0.0.1:32123'
endif

nnoremap <leader>u <Cmd>call execute('Wrapwidth' .. (input({'prompt': 'Wrapwidth: ', 'cancelreturn': '0' }) ?? 0) )<CR>
" set smoothscroll
" カーソルがインデント内部ならtrue
function! s:in_indent() abort
  return col('.') <= indent('.')
endfunction
" カーソルがインデントとずれた位置ならtrue
function! s:not_fit_indent() abort
  return !!((col('.') - 1) % shiftwidth())
endfunction
function! s:quantized_h(cnt = 1) abort
  if a:cnt > 1
    execute printf('normal! %sh', a:cnt)
    return
  endif
  normal! h
  while s:in_indent() && s:not_fit_indent()
    normal! h
  endwhile
endfunction
function! s:quantized_l(cnt = 1) abort
  if a:cnt > 1
    execute printf('normal! %sl', a:cnt)
    return
  endif
  normal! l
  while s:in_indent() && s:not_fit_indent()
    normal! l
  endwhile
endfunction
nnoremap h <cmd>call <sid>quantized_h(v:count1)<cr>
nnoremap l <cmd>call <sid>quantized_l(v:count1)<cr>


let g:lastplace_ignore_buftype = "quickfix,nofile,help,mail"
hi! link SatelliteCursor Title
nmap gqq :Wrapwidth0<CR>\|g/.*/norm! gqgq/
nmap gu :Wrapwidth34<CR>

let s:count_display_line_is_enable = v:false

function! Toggle_count_display_line()
if s:count_display_line_is_enable
  augroup CDline
    autocmd!
  augroup END
  let s:count_display_line_is_enable = v:false
else
  augroup CDline
    autocmd!
    autocmd CursorMoved * noautocmd echo s:count_display_line()
  augroup END
  let s:count_display_line_is_enable = v:true
endif
endfunction
function! s:count_display_line()
  let lineNr = 1
  let start_pos = getcurpos('.')
  let lines = line('$')
  while line('.') !=# 1
  norm! gk
  let lineNr+=1
  endwhile
  call setpos('.', start_pos)
  return lineNr
endfunction

imap <C-h> <BS>
nmap g<c-g> <Cmd>call Toggle_count_display_line()<CR>
autocmd TabClosed * if tabpagenr('$') >= expand('<afile>') | execute('tabnext ' .. (expand('<afile>') -1 ? expand('<afile>') -1 : 1 )) | endif
set splitkeep=screen
let g:nerdfont#autofix_cellwidths = v:false

function! WASD() abort
if !exists('b:wasd_save_nmap')
let  b:wasd_save_nmap = nvim_buf_get_keymap(0,'n')
call nvim_buf_set_keymap(0, 'n', 'w', 'k', {'nowait': v:true})
call nvim_buf_set_keymap(0, 'n', 'a', 'h', {'nowait': v:true})
call nvim_buf_set_keymap(0, 'n', 's', 'j', {'nowait': v:true})
call nvim_buf_set_keymap(0, 'n', 'd', 'l', {'nowait': v:true})
else
  for i in b:wasd_save_nmap
    echom i
    call nvim_buf_set_keymap(0, i.mode, i.lhs, i.rhs, i.opts  )
    unlet b:wasd_save_nmap
  endfor
endif
endfunction

autocmd vimrc FileType gitcommit startinsert
autocmd vimrc FileType gitcommit nnoremap <buffer> q :close<CR>
set startofline
if s:is_nvim
set diffopt=internal,context:10,algorithm:histogram,vertical,foldcolumn:0,indent-heuristic,filler,hiddenoff,followwrap,closeoff,linematch:60
set jumpoptions=stack,view
endif
silent! iunmap <C-W>
nnoremap ` <cmd>call <SID>setqfhint()<CR>
nnoremap  <Leader>` <cmd>call <SID>saveqfhint()<CR>

function! s:setqfhint()
let input = input('Enter: ')
if input ==# ''
return
endif
call setqflist([{'lnum':line('.'), 'col':col('.'), 'text': input, 'filename': expand('%:p'),'type': 'H'}], 'a')
call quickfixsync#signs#update()
return
endfunction

function! s:saveqfhint()
let d = getqflist()
let l = []
for i in d
  if i.bufnr ==# bufnr('%')
    let i['filename'] = fnamemodify(bufname(i.bufnr), ':p')
    call remove(i, 'bufnr')
    call insert(l, i)
  endif
endfor
eval l->sort({i1, i2 ->i1.lnum - i2.lnum})
edit %:p:h\savehint.vim
call setline(1, 'call setqflist('.. string(l) .. ')')
call setline(2, 'call quickfixsync#signs#update()')
return l
endfunction

function! Loadqfhint()
let path = expand('%:h')
endfunction

nnoremap <silent> + :call OpenBrowserSearch(input('Search: '))<CR>
nnoremap <Leader>l <Cmd>echo getqflist()->filter({_,val -> val.lnum ==# line('.')})->map({_, val -> 'qf: ' .. val.text})->join("\n")<CR>
" echom call getqflist()
"  call denops_shared_server#runtray#_execute_script_command('start')
" autocmd vimrc WinClosed * if nvim_win_get_config(0).focusable && !nvim_win_get_config(0).relative | wincmd p | endif
" autocmd vimrc WinClosed * echom expand('<afile>')

command! -nargs=? -complete=command MarkdonwToSD  call sd#markdown_to_sd()
nnoremap <Space>g <cmd>call sd#pagecount()<CR>

au User Ddu:redraw call ddu_history#save_current()
call cmdline#set_option(#{
  \   highlight_prompt: 'Statement',
  \   highlight_window: 'None',
  \   border : 'none',
  \   col: 19,
  \   row: 1,
  \ })
" autocmd User Ddu:ui:ff:openFilterWindow call cmdline#enable()
" autocmd User Ddu:ui:ff:closeFilterWindow call cmdline#disable()

" vim:set foldmethod=marker:
