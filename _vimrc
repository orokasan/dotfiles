"ork's _vimrc
"今夜使いたいkey mapping
"*t) =>前方の)の手前まで削除して*
"aw =>1単語の範囲
"ap =>段落の範囲
"vim正規表現
"https://qiita.com/kawaz/items/d0708a4ab08e572f38f3

" Basic setting {{{
set encoding=utf-8
if !has('nvim')
    scriptencoding utf-8,cp932
else
    scriptencoding utf-8
endif
set fileencoding=utf-8
set fileencodings=utf-8,ucs-bom,iso-2022-jp-3,euc-jisx0213,euc-jp,cp932
set runtimepath+=~/vimfiles
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
"---------------------------------------------------------------------
"Python,vimproc
" Memo
if has('win64')
    let g:python3_host_prog ='python.exe'
endif

" Backup
" making undo/swap dir automatically
autocmd vimrc VimEnter * call <SID>makeconfigdir()
"{{{
let s:initdir = {
    \ 'undo': expand('~/vimfiles/undo/'),
    \ 'swap': expand('~/vimfiles/swap/')
    \ }
function! s:makeconfigdir() abort
    for key in keys(s:initdir)
        let l:a = s:initdir[key]
        if !isdirectory(l:a)
            " call mkdir(s:initdir[key])
            let l:b = iconv(l:a, &encoding, &termencoding)
            call mkdir(l:b, 'p')
        endif
    endfor
endfunction
"}}}
set swapfile
set directory=~/vimfiles/swap
set undofile
set undodir=~/vimfiles/undo " put together undo files
set autoread                " reload editing file if the file changed externally
set nobackup                " no more backup file
"set backupdir=~/vimfiles/backup
"}}}

" Visual  {{{
set shortmess+=aAcsT
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
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%
set modelines=5
set termguicolors   " ターミナルでも True Color を使えるようにする。
set lazyredraw
set visualbell      " please stop noisy beep
set fillchars+=vert:\ 
set t_vb=
set noerrorbells
set hidden          " be able to open files when editing other files
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
set pumheight=10
set ambiwidth=double
"}}}

" Editing {{{
set virtualedit=onemore     "move cursor to one more char than end of line
set scrolloff=5
set display=lastline
" add japanese matchpairs
set showmatch       " highlight matched pairs
set matchtime=1     " highlighting long
set matchpairs+=（:）,「:」,『:』,【:】,［:］,＜:＞
set autochdir               " set current directory to editing file dir automatically
set textwidth=0             " don't let insert auto indentation
set tabstop=4               " number of spaces inserted by <TAB>
set expandtab
set softtabstop=4
let g:vim_indent_cont = 4
set autoindent
set shiftwidth=4            " number of spaces inserted when auto indentation by vim
set formatoptions+=mMj

" Searching
set ignorecase
set smartcase
set incsearch
"default global option on :substitute
"set gdefault
set wrapscan
set hlsearch

" for markdown
"autocmd! FileType markdown hi! def link markdownItalic Normal
autocmd vimrc FileType markdown set commentstring=<\!--\ %s\ -->

" Folding
setlocal foldmethod=marker

" viminfo
if has('nvim')
  set shada=!,:10,'300,<50,s10,h,@10
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
"ディレクトリが保存時無い場合に自動的に作成
"https://vim-jp.org/vim-users-jp/2011/02/20/Hack-202.html
augroup vimrc-auto-mkdir  " {{{
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)  " {{{
    if !isdirectory(a:dir) && (a:force ||
    \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction  " }}}
augroup END  " }}}
"}}}
"transparent completions menu
if has('nvim')
    set pumblend=15
    hi! PmenuSel blend=0
endif

"日本語入力固定モード
"IM-control.vimが必要
"https://sites.google.com/site/fudist/Home/vim-nihongo-ban/vim-japanese/ime-control
"eskk.vimと干渉するため停止している
let g:disable_IM_Control = 1
if !exists('g:disable_IM_Control')
    inoremap <silent> <C-k> <C-^><C-r>=IMState('FixMode')<CR>
endif
"}}}

"Key mapping {{{

let mapleader = "\<Space>"
" improved insert
nnoremap <expr>i len(getline('.')) == 0 ? "cc" : "i"
" moving visible lines by j/k
nnoremap <silent>j gj
nnoremap <silent>k gk
" moving tip/end of a line
nnoremap <S-l> $
nnoremap <S-h> ^
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
" yank to end of line
nnoremap Y y$
xnoremap Y y$
" 'v' behave more compatible with 'y'
nnoremap vv V
nnoremap V v$

nmap <Tab> %
vmap <Tab> %
xmap <Tab> %

" macro by 'Q'
nnoremap Q q
xnoremap Q q

nnoremap J gJ
nnoremap gJ J

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
tnoremap <C-[> <C-\><C-n>
tnoremap <Esc> <C-\><C-n>
" save like Word
inoremap <c-s> <Esc>:w<CR>a
" close window
nnoremap <silent><C-q> :bd<CR>
" close buffer
nnoremap <silent>q :close<CR>
" insert date
inoremap <expr><F2> strftime("%Y%m%d")
cnoremap <expr><F2> strftime("%Y%m%d")
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
noremap <silent> <leader>v :e ~/dotfiles/?vimrc<CR>
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

" spliting windows
nnoremap <leader>ws :sp<CR>:bprev<CR>
nnoremap <leader>wv :vsp<CR>:bprev<CR>
nnoremap <leader>wc :close<CR>
nnoremap <leader>wn :vne<CR>
nnoremap <leader>wo :only<CR>
"
" emacs like mapping on insert mode
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-h> <BS>
inoremap <C-a> <HOME>
inoremap <C-e> <END>
"
" move between windows
" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l
"
" change window size
nnoremap <S-Left>  <C-w><
nnoremap <S-Right> <C-w>>
nnoremap <S-Up>    <C-w>-
nnoremap <S-Down>  <C-w>+

" maximize buffer window size temporally
nmap <Leader>wz <Plug>(my-zoom-window)
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

" moving around between buffers
nnoremap <silent><Leader>h :bprev!<CR>|
nnoremap <silent><Leader>l :bnext!<CR>|

" commandline mapping
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>
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
nnoremap <silent><C-p> :Bclose<CR>
"}}}

" pandoc
if has('mac')
    "nnoremap <Leader>pd <C-u>:!pandoc -f markdown+ignore_line_breaks -t docx --reference-doc='/Users/ork/.pandoc/reference.docx' -o '%:p:r.docx' '%:p'<CR>
    nnoremap <Leader>pd <C-u>:!pandoc -f markdown+ignore_line_breaks -t docx --reference-doc=reference.docx -o '%:p:r.docx' '%:p'<CR>
else
    nnoremap <Leader>pd <C-u>:!start /min pandoc "%:p" -o "%:p:r.docx" --filter pandoc-crossref<CR>
endif
"}}}

" +GUI {{{
if has('GUI')
    let &guioptions = substitute(&guioptions, '[mTrRlLbeg]', '', 'g')
    set guioptions+=M
    set clipboard=unnamed
    ""Nm秒後にカーソル点滅開始
    set guicursor=n:blinkwait2000
    let no_buffers_menu = 1
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
        set lines=60 "ウィンドウの縦幅
        set columns=120 " ウィンドウの横幅
        winpos 2 10 " ウィンドウの起動時の位置
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
    set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
    set clipboard=unnamed
    "float windowで補完するための設定
    set completeopt-=preview
    set wildoptions=pum
endif
"}}}

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

" lightline.vim {{{
let g:lightline = {
\ 'colorscheme': 'quack',
    \ 'active': {
        \ 'left': [ ['mode', 'paste'],['eskk','denitebuf','git'], [ 'readonly', 'path'] ],
        \ 'right': [
            \ ['lineinfo'],
            \ ['charcount'],
            \ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok', 'percent','IMEstatus']
        \ ]
    \ },
    \ 'inactive': {
        \ 'left': [['inactivefn']],
        \ 'right': [[ 'percent' ]]
    \ },
    \ 'tabline' : {
    \ 'left': [['buffers'], ['denitesource']],
    \ 'right': [['winnr'],['fileencoding','filetype'] ]
    \ },
    \ 'component':{
    \},
    \ 'component_function': {
        \ 'readonly':'LLReadonly',
        \ 'inactivefn':'LLInactiveFilename',
        \ 'path':'LLMyFilepath',
        \ 'mode': 'LLMode',
        \ 'charcount':'LLCharcount',
        \ 'eskk': 'LLeskk',
        \ 'git':'LLgit',
        \ 'lineinfo':'LLlineinfo',
        \ 'denitebuf': 'LLDeniteBuffer',
        \ 'denitesource' : 'LLDeniteSource'
    \ },
    \ 'component_expand': {
        \ 'buffers': 'LLmybufferline',
        \ 'denitesource' : 'LLDeniteSource',
        \ 'linter_checking': 'lightline#ale#checking',
        \ 'linter_warnings': 'lightline#ale#warnings',
        \ 'linter_errors': 'lightline#ale#errors'
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
function! LLmybufferline() abort
    if &filetype ==# 'denite' || 'denite-filter'
        return LLDeniteBuffer()
    else
        return lightline#bufferline#buffers()
    endif
endfunction
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
        \'IMEstatus':'%{IMStatus("---------------------------------------------------------------------JP-")}'
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

" 文字数カウント {{{
" lightlineに渡す変数の設定
augroup CharCounter
    autocmd!
    autocmd BufNew,BufEnter,TextChanged,CursorMoved,CursorMovedI * call <SID>llvarCharCount()
    autocmd BufNew,BufEnter,FileWritePre,BufWrite,InsertLeave * call <SID>llvarCharAllCount()
augroup END

let s:llcharcount = ''
let s:llcharallcount = ''

"全体カウント
function! s:llvarCharAllCount()
    let l:count = g:CharAllCount()
    let s:llcharallcount = l:count == 0 ?   '***' :
        \ l:count <10 ? '   ' . l:count :
        \ l:count <100 ? '  ' . l:count :
        \ l:count <1000 ? ' ' . l:count : l:count
endfunction
function! g:CharAllCount() "{{{
    if &filetype ==# 'help' || 'denite'
        return
    endif
    let l:result = 0
    for l:linenum in range(0, line('$'))
        let l:line = getline(l:linenum)
        let l:result += strlen(substitute(l:line, '.', 'x','g'))
    endfor
    return l:result
endfunction "}}}

"1行カウント
function! s:llvarCharCount()
    let l:count = g:CharCount()
    let s:llcharcount = l:count < 10 ? '**' . l:count :
        \ l:count <100 ? '*' . l:count :
        \ l:count
endfunction
function! g:CharCount() "{{{
    let l:line = getline(line('.'))
    return strlen(substitute(l:line, '.', 'x','g'))
endfunction "}}}

function! LLCharcount()
    if &filetype !~# s:ignore_filetype
        return winwidth(0) > 70 ? '[' . s:llcharcount . ']' . s:llcharallcount . 'w' :
            \ winwidth(0) > 65 ? '[' . s:llcharcount . ']w' : ''
    else
        return ''
    endif
endfunction
"選択範囲の行をカウント {{{
function! g:LineCharVCount() range
    let l:result = 0
    for l:linenum in range(a:firstline, a:lastline)
        let l:line = getline(l:linenum)
        let l:result += strlen(substitute(l:line, '.', 'x','g'))
    endfor
    echo ' [WordCount] -- ' . l:result . ' : ' . g:CharAllCount() .
                \ ' -- [選択行の字数:全体の字数]'
endfunction "}}}
"呼び出せる
command! -range LineCharVCount <line1>,<line2>call g:LineCharVCount()
xnoremap<silent> <C-o> :LineCharVCount<CR>
"}}}

function! LLReadonly()
"    return &readonly ? '⭤' : ''
    return &readonly ? '' : ''
endfunction

function! LLgit() abort
        return s:llgitbranch
endfunction
" 重いのでキャッシュする
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

" 検索ステータスを表示 (vim-anzuを利用) {{{
autocmd vimrc InsertEnter,BufEnter,CursorMoved * if exists('*anzu#clear_search_status') 
    \| call anzu#clear_search_status() | endif

autocmd vimrc CmdlineLeave /,\? :call timer_start(0, {-> execute('AnzuUpdateSearchStatus') } )
autocmd vimrc User IncSearchExecute :call execute('AnzuUpdateSearchStatus')

function! s:llanzu()
    let s:anzu = anzu#search_status()
    "    if winwidth(0) > 100
            return strlen(s:anzu) < 30 ? s:anzu : matchstr(s:anzu,'(\d\+\/\d\+)')
    "    else
    "        return ''
    "    endif
endfunction "}}}

" Deniteステータス {{{
function! LLDeniteBuffer()
    if &filetype ==# 'denite' || 'denite-filter'
        let l:buffer = denite#get_status('buffer_name')
        return l:buffer
    else
        return ''
    endif
endfunction

function! LLDeniteSource()
    if &filetype !=# 'denite' || 'denite-filter'
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
"}}}

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

  for i in range(10000)
    call feedkeys('j')
    call feedkeys('j')
    call feedkeys('k')
  endfor
endfunction
"}}}
"}}}

" Colorscheme  {{{
"補完ポップアップメニューの色変更
autocmd vimrc ColorScheme iceberg highlight PmenuSel ctermbg=236 guibg=#3d425b
autocmd vimrc ColorScheme iceberg highlight Pmenu  ctermfg=252 ctermbg=236 guifg=#c6c8d1 guibg=#272c42
autocmd vimrc ColorScheme iceberg highlight NormalFloat ctermfg=252 ctermbg=236 guifg=#c6c8d1 guibg=#272c42
autocmd vimrc ColorScheme iceberg highlight clear Search
autocmd vimrc ColorScheme iceberg highligh Search gui=underline
autocmd vimrc ColorScheme solarized8 highlight! VertSplit guifg=#05252C guibg=#05252C
autocmd vimrc ColorScheme solarized8 highlight! link EndOfBuffer Comment
autocmd vimrc ColorScheme solarized8 highlight! NormalFloat guibg=#05252C
autocmd vimrc ColorScheme solarized8 highlight clear Underlined
autocmd vimrc ColorScheme solarized8 highlight! Underlined gui=underline,bold

set background=dark
colorscheme solarized8
"}}}

"vim:set foldmethod=marker:"
