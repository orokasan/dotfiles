"ork's vimrc
lua if vim.loader then vim.loader.enable() end
augroup vimrc
  autocmd!
augroup END
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
let g:loaded_matchparen = 0
let g:loaded_node_provider = 1
let g:loaded_perl_provider = 1
let g:loaded_python_provider = 0
let g:loaded_ruby_provider = 1
let g:did_indent_on             = 1
let g:did_load_filetypes        = 1
" let g:loaded_2html_plugin       = 1
let g:loaded_man                = 1
let g:loaded_matchit            = 0
let g:loaded_remote_plugins     = 0
let g:loaded_shada_plugin       = 1
let g:loaded_spellfile_plugin   = 1
let g:loaded_tutor_mode_plugin  = 1

silent! call execute('source ' .. expand('~/local_vimrc'))

if exists('neovide')
  set guifont=PlemolJP\ Console\ NF:h13:#e-subpixelantialias
  " set guifont:HackGen\ Console\ NFJ:h11
  set linespace=0
  let g:neovide_padding_top = 0
  let g:neovide_padding_bottom = 0
  let g:neovide_padding_right = 0
  let g:neovide_padding_left = 0
  let g:neovide_refresh_rate=60
  let g:neovide_transparency=0.95
  let g:neovide_profiler = v:false
  let g:neovide_confirm_quit = v:true
  cd ~/
  let g:neovide_cursor_trail_size=0
  let g:neovide_remember_window_size=v:true
  let g:neovide_remember_window_position=v:true
  let g:neovide_cursor_animation_length=0
  " let g:neovide_scale_factor=1.0
  let g:neovide_refresh_rate_idle = 5
endif
let g:python3_host_prog = expand('AppData\Local\Programs\Python\Python39\python.EXE')

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
" if has('win32')
"   let g:migemo_dict = "C:/tools/cmigemo/dict/utf-8/migemo-dict"
"   let g:migemodict = "C:/tools/cmigemo/dict/utf-8/migemo-dict"
" endif
let mapleader = "\<Space>"

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

if has('nvim')
let g:dein#default_options = { 'merged': v:true }
else
let g:dein#default_options = { 'merged': v:false }
endif
let g:dein#install_max_processes = 8
let g:dein#install_process_timeout = 1000
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let s:dein_is_initializing = 0

let s:toml      = '~/dotfiles/nvim/rc/dein.toml'
let s:lazy_toml = '~/dotfiles/nvim/rc/dein_lazy.toml'
let s:lua_toml = '~/dotfiles/nvim/rc/dein_lua.toml'
let s:denops_toml = '~/dotfiles/nvim/rc/dein_denops.toml'
let g:dein#auto_remote_plugins = v:true
let s:myvimrc = expand('$MYVIMRC')
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir,[s:myvimrc,s:toml,s:lazy_toml, s:denops_toml])
  call dein#load_toml(s:denops_toml)
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})
  if has('nvim')
    call dein#load_toml(s:lua_toml, {'lazy': 1})
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

filetype plugin indent on
syntax on

set fileformats=unix,dos,mac
set fileencodings=utf-8,cp932,iso-2022-jp,euc-jp,sjis


colorscheme iceberg
set background=dark

set notermguicolors
set swapfile
set undofile
if !has('nvim')
  set directory=~/.backup/vim/swap
  set undodir=~/.backup/vim/undo
  set backupdir=~/.backup/vim/backup
else
  set directory=~/.backup/nvim/swap
  set undodir=~/.backup/nvim/undo
  set backupdir=~/.backup/nvim/backup
endif
set autoread
set backup

" language C
set ambiwidth=single
set shortmess=aActTFOoI
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
set listchars=tab:^-,trail:␣,extends:»,precedes:«,nbsp:%
set modelines=5
set termguicolors
set t_Co=256
set synmaxcol=1500
set belloff=all
set fillchars+=vert:\ ,fold:\ ,diff:\ ,eob:~
set diffopt=internal,context:10,algorithm:histogram,vertical,foldcolumn:0,indent-heuristic,filler,hiddenoff,followwrap,closeoff
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
set matchpairs+=<:>,（:）,「:」,『:』,【:】,［:］,＜:＞,〔:〕
set nojoinspaces
set textwidth=0
set updatecount=50
set tabstop=2
set expandtab
set softtabstop=-1
let g:vim_indent_cont = 4
set autoindent
set smartindent
set shiftwidth=0
set formatoptions=mjMcrql
au vimrc FileType * set fo-=o
set iskeyword+=-
set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
set complete=.,w,b,u
set history=1000
set clipboard+=unnamed,unnamedplus
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
nnoremap <silent><expr> l charcol('$') - 1 > 0 ? (charcol('.') ==# charcol('$') - 1 ? "j^" : "l") : "j^"
nnoremap <silent><expr> h col('.') ==# 1 ? "k$" : "h"
" moving tip/end of a line
nnoremap <S-l> $
nnoremap <S-h> ^
vnoremap <S-l> g_
vnoremap <S-h> ^
onoremap <S-l> $
onoremap <S-h> ^

nnoremap <C-f> <C-f>zz
nnoremap <C-b> <C-b>zz
nnoremap <C-d> <C-d>
nnoremap <C-u> <C-u>
nnoremap <C-o> <C-o>zz<CR>

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
" matchit mapping
nmap <TAB>  <plug>(matchup-%)
nmap g<TAB> <plug>(matchup-g%)
xmap <TAB>  <plug>(matchup-%)
xmap g<TAB> <plug>(matchup-g%)
omap <TAB>  <plug>(matchup-%)
omap g<TAB> <plug>(matchup-g%)
" native <TAB> is useful
nnoremap <C-p> <TAB>zz<CR>
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
nmap <BS> <C-h>
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
nnoremap <silent> <C-q> <cmd>tabclose<CR>
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

if has('GUI')
  let &guioptions = substitute(&guioptions, '[mTlLbeg]', '', 'g')
  set guioptions+=Mc!
  set renderoptions=type:directx,renmode:5,geom:1
  set guifont:HackGen\ Console\ NFJ:h11
  set imsearch=0
endif

if has('nvim')
  set shada=!,'200,<100,s10,h
  autocmd vimrc TermOpen term://* setlocal nonumber scrolloff=0 signcolumn=no nobuflisted
  autocmd vimrc TermOpen * startinsert
  autocmd vimrc TermOpen term://* nnoremap <buffer> q :quit<CR>
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
nnoremap <silent> ` :call OpenBrowserSearch(input('Search: '))<CR>
nnoremap gM :call vimrc#PostIsbnFromClipboard()<CR>

nnoremap <C-f> <C-f>z.<SID>zz_if_not_near_eof()<CR>
nnoremap <C-b> <C-b>z.<CR>
function! s:zz_if_not_near_eof() abort
  if line('$') - line('.') > winheight(0)/2
    norm G
  endif
endfunction

au vimrc FileType vim setlocal indentexpr=
au vimrc FileType vim setlocal tabstop=2
au dein FileType toml call dein#toml#syntax()
au vimrc FileType lua setlocal tabstop=2

command! -nargs=* TextobjectOutline call vimrc#textobject_outline(<f-args>)
xnoremap io <Cmd>TextobjectOutline<CR>
xnoremap ao <Cmd>TextobjectOutline from_parent<CR>
xnoremap iO <Cmd>TextobjectOutline with_blank<CR>
xnoremap aO <Cmd>TextobjectOutline from_parent with_blank<CR>
onoremap io <Cmd>TextobjectOutline<CR>
onoremap ao <Cmd>TextobjectOutline from_parent<CR>
onoremap iO <Cmd>TextobjectOutline with_blank<CR>
onoremap aO <Cmd>TextobjectOutline from_parent with_blank<CR>
" au vimrc BufRead,BufNewFile *.txt setfiletype txt
set imdisable
function! s:move_to_char_pos(char)
  if search(a:char, 'cW', line("w$"))
    norm! "_x
    startinsert
  endif
endfunction

inoremap <silent> <c-l> <C-g>u<ESC><cmd>call <SID>move_to_char_pos('★')<CR>

let g:denops#debug = v:false
let g:denops#trace = v:false
let g:denops_server_addr = '127.0.0.1:32123'

function! s:change_textwidth()
let &tw = input('Input textwidth value: ')
endfunction

nnoremap <leader>u <Cmd>call <SID>change_textwidth()<CR>
let g:markdown_recommended_style=0
function! AerialCall() abort
lua << EOF

local ext_config = {
  show_nesting = {
    ["_"] = false,
    json = true,
    yaml = true,
  },
}
  require("aerial").sync_load()
  local backends = require("aerial.backends")
  local config = require("aerial.config")
  local data = require("aerial.data")
  local highlight = require("aerial.highlight")
  local util = require("aerial.util")

  local bufnr = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(0)
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local show_nesting = ext_config.show_nesting[filetype]
  if show_nesting == nil then
    show_nesting = ext_config.show_nesting["_"]
  end
  local backend = backends.get()

  if not backend then
    backends.log_support_err()
    return
  elseif not data.has_symbols(0) then
    backend.fetch_symbols_sync(0, opts)
  end
  print(vim.inspect(data.get()))
EOF
endfunction

runtime! plugin/rplugin.vim

" vim:set foldmethod=marker:
