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
let s:is_windows = has('win32') || has('win64')
if has('win32')
    let g:python3_host_prog ='C:\Python38\python.exe'
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
let g:dein#lazy_rplugins=1
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
      " let path = fnamemodify(s:dein_repo_dir, ':p')
    " execute 'set runtimepath+=' . substitute(path, '\\$', '', '')
    execute 'set runtimepath+=' . fnamemodify(s:dein_repo_dir, ':p')
endif

let s:toml      = '~/dotfiles/nvim/rc/dein.toml'
let s:lazy_toml = '~/dotfiles/nvim/rc/dein_lazy.toml'
let s:no_dependency_toml = '~/dotfiles/nvim/rc/dein_no_dependency.toml'

" if has('nvim')
    let s:lsp_toml = '~/dotfiles/nvim/rc/dein_nvim_lsp.toml'
" else
    " let s:lsp_toml = '~/dotfiles/nvim/rc/dein_vim_lsp.toml'
" endif
    " let s:lsp_toml = '~/dotfiles/nvim/rc/dein_vim_lsp.toml'

let s:myvimrc = expand('$MYVIMRC')
if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir,s:myvimrc)
   call dein#load_toml(s:toml,      {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})
    call dein#load_toml(s:lsp_toml,  {'merged': 0})
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
set shortmess+=aAcTtI
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
set listchars=tab:^-,trail:-,extends:»,precedes:«,nbsp:%
set modelines=5
set termguicolors
" set lazyredraw
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
set pumheight=12 " default
set diffopt=internal,context:3,filler,algorithm:histogram,indent-heuristic,vertical
"}}}

" Editing {{{
set virtualedit=block     "move cursor to one more char than end of line
set display+=lastline,msgsep
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
set noexpandtab
set softtabstop=-1
let g:vim_indent_cont = 4
set autoindent
set shiftwidth=0
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
set completeopt+=menuone,longest
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
" moving around buffers
nnoremap <silent><Leader>h :bprev!<CR>
nnoremap <silent><Leader>l :bnext!<CR>
nnoremap <silent><Leader>l :bnext!<CR>
" moving around tabpages
nnoremap <silent> <C-L> :tabnext<CR>
nnoremap <silent> <C-H> :tabprevious<CR>
nnoremap <silent>gt :<C-u>call <SID>improved_gt()<CR>
function! s:improved_gt() abort
    if tabpagenr('$') == 1
        execute 'tabnew'
    else
        normal! gt
    endif
endfunction
nmap <C-j> <NOP>
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
" nnoremap x "_x
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
tnoremap <nowait> <C-f> <C-f>
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
nnoremap <silent>gl zo
" smart folding closer
nnoremap <silent>gh :silent! call <SID>smart_foldcloser()<CR>
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
nnoremap <silent> \ :cd %:h<Bar>echo 'current directory is changed to ' . getcwd()<CR>
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
" if exists('g:started_by_firenvim')
"   set showtabline=0
"     set laststatus=0
"   set signcolumn=no
"   set number
" finish
" endif
" function! s:IsFirenvimActive(event) abort
"   if !exists('*nvim_get_chan_info')
"     return 0
"   endif
"   let l:ui = nvim_get_chan_info(a:event.chan)
"   return has_key(l:ui, 'client') && has_key(l:ui.client, 'name') &&
"       \ l:ui.client.name =~? 'Firenvim'
" endfunction

" function! OnUIEnter(event) abort
"   if s:IsFirenvimActive(a:event)
"     set laststatus=0
"    set showtabline=0
"    set signcolumn=no
"    " set number
"   endif
" endfunction
" autocmd UIEnter * call OnUIEnter(deepcopy(v:event))
" let g:firenvim_config = { 
"     \ 'globalSettings': {
"         \ 'alt': 'all',
"     \  },
"     \ 'localSettings': {
"         \ '.*': {
"             \ 'cmdline': 'firenvim',
"             \ 'priority': 0,
"             \ 'selector': 'textarea',
"             \ 'takeover': 'never',
"         \ },
"     \ }
" \ }
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
"     if executable('wsl')
"         set wsl
"     endif
" endif
" set shell=\"C:\msys64\usr\bin\bash.exe\"\ -f
" set shellcmdflag=-c
" set shellquote=\"
" set shellxescape=
" set shellxquote=
" endif
"}}}
" hi! link NonText Comment
" for neovide initialize hook
if exists('neovide')
    " set guifont=:RictyDiminished\ NF:h16
    " set guifont=:Cica:h16
    set guifont:HackGenNerd:h15
    let g:neovide_refresh_rate=100
set linespace=10
let g:neovide_transparency=0.96
let g:neovide_transparency=0.90
let g:neovide_cursor_trail_length=0
let g:neovide_cursor_animation_length=0
let g:neovide_cursor_antialiasing=v:true
" let g:neovide_cursor_vfx_mode = "wireframe"
  cd ~/
    let g:neovide_extra_buffer_frames=4
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
vnoremap y ygv<ESC>

" function! s:IsFirenvimActive(event) abort
"   if !exists('*nvim_get_chan_info')
"     return 0
"   endif
"   let l:ui = nvim_get_chan_info(a:event.chan)
"   return has_key(l:ui, 'client') && has_key(l:ui.client, 'name') &&
"       \ l:ui.client.name =~? 'Firenvim'
" endfunction

" function! OnUIEnter(event) abort
"   if s:IsFirenvimActive(a:event)
"   set signcolumn=no
"   set number
"   set showtabline=0
"   endif
" endfunction
" autocmd UIEnter * call OnUIEnter(deepcopy(v:event))
	let g:previm_enable_realtime = 1
autocmd BufReadPre gina://* set noswapfile
" augroup MyCursorLineGroup
"     autocmd!
"     au WinEnter * setlocal cursorline
"     au WinLeave * setlocal nocursorline
" augroup end
"nnoremap <C-n> <cmd>call Nvim_lsp_showdiagnostics()<CR>
"nnoremap \ <cmd>lne<CR>zz
"nnoremap \| <cmd>lp<CR>zz
"let g:nvim_lsp_diagnostics = []
"function! Nvim_lsp_showdiagnostics() abort
"    call s:qf_to_loc()
"    if empty(g:nvim_lsp_diagnostics)
"        echom 'No diagnostics results found'
"    else
"        echo 'Retrieved diagnostics results'
"        botright lopen
"    endif
"endfunction
"autocmd dein User LspDiagnosticsChanged call <SID>qf_to_loc()
"function! s:qf_to_loc() abort
"    let callback = getqflist()
"    " echo callback
"    if !empty(callback)
"        let g:nvim_lsp_diagnostics = []
"        for i in callback
"        let i.col = s:to_col(i.bufnr, i.lnum, i.col)
"        " echo i
"        call add(g:nvim_lsp_diagnostics, i)
"        endfor  
"        " echo list
"        call setloclist(0, g:nvim_lsp_diagnostics, ' ')
"    endif
"endfunction
"function! s:to_col(expr, lnum, char) abort
"    let l:lines = getbufline(a:expr, a:lnum)
"    if l:lines == []
"        if type(a:expr) != v:t_string || !filereadable(a:expr)
"            " invalid a:expr
"            return a:char + 1
"        endif
"        " a:expr is a file that is not yet loaded as a buffer
"        let l:lines = readfile(a:expr, '', a:lnum)
"    endif
"    let l:linestr = l:lines[-1]
"    return strlen(strcharpart(l:linestr, 0, a:char))
"endfunction
"function! Nvim_lsp_result_to_quickfix() abort
"    let res = []
"    let i = bufnr('%')
"    let res = luaeval('vim.lsp.util.diagnostics_by_buf[' . i . ']')
"    for l in res[0]
"        let bufnr = l['bufnr']
"        let lnum = l['lnum']
"        let col = l['col']
"        let text = l['text']
"        call setqflist([bufnr,lnum,col,text], ' ')
"    endfor
"    " let result = g:res
"    " call setqflist(result, ' ')
"endfunction
lua << EOF 
require'lspconfig'.pyright.setup{}
require "lspconfig".efm.setup {
    init_options = {documentFormatting = true},
    settings = {
        rootMarkers = {".git/"},
        languages = {
            lua = {
                {formatCommand = "lua-format -i", formatStdin = true}
            }
        }
    }
}
require'lspconfig'.vimls.setup{}
require'lspconfig'.gopls.setup{}
EOF 
lua << EOF
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>we', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end
  
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    require('lspconfig').util.nvim_multiline_command [[
      :hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      :hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      :hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]]
  end
end

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
local servers = { "pyright", "rust_analyzer", "tsserver" ,'vimls','efm'}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
EOF
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
let twitvim_enable_python3 = 1
let twitvim_timestamp_format = '%H:%M-%m/%d'
let twitvim_count = 15

function! Mdpdf()
 " !mdpdf --border=12.7mm "%"
" if s:is_windows
let path = expand('%:p')
" let path = substitute(path, ' ', '\\ ', 'g')
let path = shellescape(path, 1)
" endif
let cmd = 'mdpdf --border=12.7mm ' . path
" call system(cmd)
execute "!" . cmd
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
" au vimrc TextYankPost * v:event.visual
" nnoremap v mvv
" au vimrc TextYankPost * if !v:event.visual && v:event.operator == 'y' | call timer_start(0, 'Move_prev_pos') | endif
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
    nmap w @w
    nmap e @e
let s:macromode = 1
endfunction
function! MacroModeOff() abort
if s:macromode ==# 0
    return
endif
    unmap q
    unmap w
    unmap e
    unmap r
let s:macromode = 0
endfunction

if exists('g:started_by_firenvim')
  set showtabline=0
  " set laststatus=0
   " call lightline#disable()
let g:firenvim_config = { 
    \ 'globalSettings': {
        \ 'alt': 'all',
    \  },
    \ 'localSettings': {
        \ '.*': {
            \ 'cmdline': 'neovim',
            \ 'content': 'text',
            \ 'priority': 0,
            \ 'selector': 'textarea',
            \ 'takeover': 'never',
        \ },
    \ }
\ }
augroup Firenvim
    au BufEnter * call Set_Font(g:firenvim_font)
    au BufEnter *     colorscheme iceberg
    au BufEnter *     set background=light
    au BufEnter github.com_*.txt set filetype=markdown
  au BufEnter github.com_*.txt set filetype=markdown | call Set_Font(g:firenvim_font)
  au BufEnter play.rust-lang.org_*.txt set filetype=rust | call Set_Font(g:firenvim_font)
  au BufEnter play.golang.org_*.txt set filetype=go |call Set_Font(g:firenvim_font)
augroup END
endif
let g:firenvim_font = 'HackGenNerd'
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
"!powershell start-process notepad c:\windows\system32\drivers\etc\hosts -verb runas
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
" vim:set foldmethod=marker:

