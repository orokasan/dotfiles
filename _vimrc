"ork's _vimrc for Windows
"========================================================================
""文字入力系
"========================================================================
"文字コードをUFT-8に設定
set encoding=utf-8
set fileencodings=utf-8,cp932
set shellslash
" バックアップファイルを作らない
"set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
"Undoファイルをまとめる
set undodir=~/vimfiles/undo
set backup
set backupdir=~/vimfiles/backup
" バッファが編集中でもその他のファイルを開けるように 
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd
"typo対策
iabbrev adn and
iabbrev teh the
set showmatch
set matchtime=1
"========================================================================
"ランタイムパスの設定
"========================================================================
"なぜかランタイム直下のプラグインが読み込まれないため、ワイルドカードで対応
set runtimepath+=~\vimfiles
set runtimepath+=~\vimfiles\dein\repos\github.com\Shougo\defx.nvim
set runtimepath+=~\AppData\Local\Programs\Python\Python35\Lib\site-packages
set runtimepath+=~/vimfiles/dein/repos/github.com/Shougo/neomru.vim
set runtimepath+=~/vimfiles/dein/repos/github.com/cocopon/vaffle.vim
set runtimepath+=~/vimfiles/dein/repos/github.com/Shougo/Unite.vim
set runtimepath+=~/vimfiles/dein/repos/github.com/vim-airline/vim-airline
set runtimepath+=~/vimfiles/dein/repos/github.com/vim-airline/vim-airline-themes
set runtimepath+=~\vimfiles\dein/repos\github.com\rhysd\vim-operator-surround
set runtimepath+=~\vimfiles\dein/repos\github.com\kana\vim-operator-user
set runtimepath+=~\vimfiles\dein/repos\github.com\deton\jasegment.vim
set runtimepath+=~\vimfiles\dein/repos\github.com\iwataka/minidown.vim
set runtimepath+=~\vimfiles\dein/repos\github.com\tpope/vim-fugitive
set runtimepath+=~\vimfiles\dein/repos\github.com\cohama/lexima.vim
"set runtimepath+=~\vimfiles\dein/repos\github.com\roxma\nvim-yarp
"set runtimepath+=~\vimfiles\dein/repos\github.com\roxma\vim-hug-neovim-rpc
set runtimepath+=~\vimfiles\dein/repos\github.com\kmnk\denite-dirmark
set runtimepath+=~\vimfiles\dein/repos\github.com\mattn\webapi-vim
set runtimepath+=~\vimfiles\dein/repos\github.com\basyura\twibill.vim
set runtimepath+=~\vimfiles\dein/repos\github.com\tyru\open-browser.vim
set runtimepath+=~\vimfiles\dein/repos\github.com\basyura\TweetVim
set runtimepath+=~\vimfiles\dein/repos\github.com\twitvim/twitvim.git
"kaoriya-VimのPython3.5と同時にDefx等で必要なPython3.6を指定する。
"3.5と3.6が両方必要
set pythonthreedll=~\AppData\Local\Programs\Python\Python36\python36.dll
let g:python3_host_prog = expand('~\AppData\Local\Programs\Python\Python36\python.exe')

"========================================================================
"Key mapping
"========================================================================
"数字のプラスマイナス
nnoremap + <C-a>
nnoremap - <C-x>
"LeaderをSpaceキーに
let mapleader = "\<Space>"
" Create a blank line above/below current line
nnoremap <leader>j o<ESC>k
nnoremap <leader>k O<ESC>j
" Convenience key for getting to command mode
nnoremap ; :
 " Enter normal mode
inoremap jk <esc>
"日本語の文章構造に対応するやつ
set matchpairs+=（:）,「:」,『:』,【:】,［:］,＜:＞
"句読点を強引に挿入
nnoremap <Leader>, a、<Esc>
nnoremap <Leader>. a。<Esc>
nnoremap <Leader>? a？<Esc>
nnoremap <Leader>! a！<Esc>
nnoremap <Leader>/ a/<Esc>
nnoremap <Leader>\ a\<Esc>
nnoremap <Leader><Space> a <Esc>
nnoremap <Leader><S-Space> a…<Esc>
" インサートモード中の^hに対応して^lで<del>させる様に
inoremap <C-l> <del>
"上書きペースト
nnoremap <silent>cp ve"8d"0p
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk
"IMEオンでinsertに入る
nnoremap <silent><C-i> i<C-^>
" 「日本語入力固定モード」の切替キー
inoremap <silent> <C-j> <C-^>
" <ESC>でのIME状態保存を無効化
inoremap <silent> <ESC> <ESC>
inoremap <silent> <C-[> <ESC>
inoremap <silent><C-c> <ESC>  
"CTRL-sで保存！
:nmap <c-s> :w<CR>
:imap <c-s> <Esc>:w<CR>a
"CTRL-qでclose
nnoremap <silent> <C-q> :close<CR>
" A better for me window management system... inspired by Spacemacs!
nnoremap <leader>wh <C-W>h
nnoremap <leader>wl <C-W>l
nnoremap <leader>wj <C-W>j
nnoremap <leader>wk <C-W>k
"画面分割マッピング
nnoremap <leader>ws :sp<CR>:bprev<CR>
nnoremap <leader>wv :vsp<CR>:bprev<CR>
nnoremap <leader>wc :close<CR>
nnoremap <leader>wn :vne<CR>
nnoremap <leader>w+ :res +2<CR>
nnoremap <leader>w- :res -2<CR>
nnoremap <leader>wo :only<CR>
"_vimrcを開く
noremap <silent> <leader>vme :e ~/dotfiles/?vimrc<CR>
"開いている_vimrcを読み込む
noremap <Leader>ss :<C-u>source %<CR>
"コマンドライン上のマッピング
cnoremap <C-a> <Home>
" 一文字戻る
cnoremap <C-b> <Left>
" カーソルの下の文字を削除
cnoremap <C-d> <Del>
" 行末へ移動
cnoremap <C-e> <End>
" 一文字進む
cnoremap <C-f> <Right>
" コマンドライン履歴を一つ進む
cnoremap <C-n> <Down>
" コマンドライン履歴を一つ戻る
cnoremap <C-p> <Up>
" 前の単語へ移動
cnoremap <M-b> <S-Left>
" 次の単語へ移動
cnoremap <M-f> <S-Right>
nnoremap <silent> <C-h> :bprev<CR>
nnoremap <silent> <C-l> :bnext<CR>
"バッファを閉じてもウィンドウが閉じないようにする
"プラグインが必要
"https://vim.fandom.com/wiki/Deleting_a_buffer_without_closing_the_window
nnoremap <silent> <C-p> :Bclose<CR>
" markdownをよく使うようになったので
noremap <leader>dm :<C-u>set ft=markdown<cr>
"Markdownの改行タグ
nnoremap <Leader>nr <C-u>A  <Esc>
"文字数カウント
nnoremap <Leader><CR> <C-u>:%s/./&/g<CR>:nohl<CR><C-o>:1messages<CR>
vnoremap <Leader><CR> :s/./&/g<CR>:nohl<CR><C-o>:1messages<CR>
"Minidown(Markdownプレビュー)
nnoremap <Leader>pmd <C-u>:Minidown<CR>
"Markdown Docx出力
nnoremap <Leader>dmd <C-u> :! pandoc "%:p" -o "%:p:r.docx"<CR>

"========================================================================
"dein Scripts-----------------------------
"========================================================================
if &compatible
  set nocompatible               
endif
set runtimepath+=~/vimfiles/dein/repos/github.com/Shougo/dein.vim
call dein#begin(expand('~/vimfiles/dein'))
call dein#add('Shougo/dein.vim')
"call dein#add('Shougo/vimproc.vim', {'build': 'make'})
call dein#add('Shougo/neosnippet-snippets')
call dein#add('Shougo/neocomplete.vim')
call dein#add('Shougo/neomru.vim')
call dein#add('Shougo/neosnippet')
call dein#add('Shougo/denite.nvim')
call dein#add('Shougo/unite.vim')
"call dein#add('cocopon/vaffle.vim')
"call dein#add('Shougo/vimfiler')
call dein#add('lambdalisue/vim-rplugin')
call dein#add('Shougo/vimproc.vim', {
      \ 'build': {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin'  : 'make -f make_cygwin.mak',
      \     'mac'     : 'make -f make_mac.mak',
      \     'linux'   : 'make',
      \     'unix'    : 'gmake',
      \    },
      \ })
call dein#add('NLKNguyen/papercolor-theme')
call dein#add('rakr/vim-one')
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')
call dein#add('deton/jasegment.vim')
call dein#add('rhysd/vim-operator-surround')
call dein#add('kana/vim-operator-user')
call dein#add('neoclide/denite-git')
call dein#add('iwataka/minidown.vim')
call dein#add('tpope/vim-fugitive')
call dein#add('cohama/lexima.vim')
"webapi-vim
call dein#add('mattn/webapi-vim')
call dein#add('basyura/twibill.vim')
call dein#add('tyru/open-browser.vim')
call dein#add('basyura/TweetVim')
"Python3.6が必要================================
call dein#add('Shougo/defx.nvim')
if !has('nvim')
  call dein#add('roxma/nvim-yarp')
  call dein#add('roxma/vim-hug-neovim-rpc')
call dein#add('kmnk/denite-dirmark')
endif
call dein#end()
filetype plugin indent on

"========================================================================
"Denite
"========================================================================
"Python関連メモ
"インストールはAll Userで
"pipからneovim, greenletを導入 Visual Studio C++ 14.0が必要
"greenletは同じpythonのバージョンでコンパイルする
"参考:https://gammasoft.jp/python/python-version-management/
"$VIMにインストールしたpythonと同じバージョンのdll(python3.dll, python35.dll, python35.zip)を入れる
"kaoriya-vimのpython3.5に揃える
"64bit版を使用する
"
set runtimepath+=~/vimfiles/dein/repos/github.com/Shougo/denite.nvim
nnoremap [denite] <Nop>
nmap <Leader>f [denite]
"現在開いているファイルのディレクトリ下のファイル一覧。
nnoremap <silent> [denite]f :<C-u>DeniteBufferDir
      \ file<CR>
"ホームディレクトリ下のファイル一覧。
nnoremap <silent> [denite]t :<C-u>DeniteProjectDir
      \ file<CR>
"バッファ一覧
nnoremap <silent> [denite]b :<C-u>Denite 
      \ -mode=normal
      \ buffer<CR>
"レジスタ一覧
nnoremap <silent> [denite]r :<C-u>Denite 
      \ -buffer-name=register -mode=normal 
      \ register<CR>
"メニュー
nnoremap <silent> [denite]u :Denite menu<CR>
nnoremap <silent> [denite]h :Denite help<CR>
"最近使用したファイル一覧
nnoremap <silent> [denite]n :<C-u>Denite 
      \ -mode=normal file_mru<CR>
"ブックマーク(Unite経由) 
"nnoremap <silent> [denite]m :Denite unite:bookmark<CR> 
"nnoremap <silent> [denite]a :Denite unite:BookmarkAdd<CR> 
""C-N,C-Pで上下移動
call denite#custom#option('_', {
      \ 'prompt': '»',
      \ 'cursor_wrap': v:true,
      \ 'winheight': 15,
      \ 'highlight_mode_insert': 'WildMenu'
      \ })
call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')
"C-J,C-Kでsplitで開く
call denite#custom#map('insert', '<C-j>', '<denite:do_action:split>', 'noremap')
call denite#custom#map('insert', '<C-k>', '<denite:do_action:vsplit>', 'noremap')
"C-h,C-lでディレクトリ移動
call denite#custom#map('insert', '<C-l>', '<denite:do_action:default>', 'noremap')
call denite#custom#map('insert', '<C-h>', '<denite:move_up_path>', 'noremap')
"h,lでディレクトリ上下移動
call denite#custom#map('normal', 'l', '<denite:do_action:default>', 'noremap')
call denite#custom#map('normal', 'h', '<denite:move_up_path>', 'noremap')
call denite#custom#var('file_rec', 'command',
\ ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', ''])
" Ag command on grep source
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts',
    \ ['-i', '--vimgrep'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])
" use rg"
" if executable('rg')
  " call denite#custom#var('file_rec', 'command',
        " \ ['rg', '--files', '--glob', '!.git'])
  " call denite#custom#var('grep', 'command', ['rg'])
" endif
call denite#custom#var('grep', 'default_opts', [])
call denite#custom#var('grep', 'recursive_opts', [])
 
call denite#custom#option('default', 'prompt', '>')
 
" customize ignore globs
call denite#custom#source('file_rec', 'matchers', ['matcher_fuzzy','matcher_ignore_globs'])
call denite#custom#source('directory_rec', 'matchers', ['matcher_fuzzy','matcher_ignore_globs'])
call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
      \ [
      \ '.git/', 'build/', '__pycache__/',
      \ 'images/', '*.o', '*.make',
      \ '*.min.*',
      \ 'img/', 'fonts/'])
""Dirmark設定
"Python3.6が必要
nmap <Leader>dd    <SID>(dirmark) 
nmap <Leader>da    <SID>(dirmark-add) 
nnoremap <silent> <SID>(dirmark) :<C-u>Denite -default-action=cd dirmark<CR> 
nnoremap <silent><expr> <SID>(dirmark-add) ':<C-u>Denite dirmark/add::' . expand('%:p:h') .  '<CR>' 
let g:vimproc#download_windows_dll = 1

"========================================================================
"vim-markdown設定
"========================================================================
augroup vimrc_markdown
  autocmd BufRead,BufNewFile *.{md} set filetype=markdown
  autocmd! FileType markdown hi! def link markdownItalic Normal
  autocmd FileType markdown set commentstring=<\!--\ %s\ -->
augroup END

"========================================================================
"TweetVim設定
"========================================================================
nnoremap <silent> <Leader>tws  :<C-u>TweetVimSay<CR>
nnoremap <silent> <Leader>twt  :TweetVimHomeTimeline<CR>:res -2<CR>
nnoremap <silent> <Leader>twm :TweetVimMentions<CR>
nnoremap <silent> <Leader>twu :Unite tweetvim<CR>
let g:tweetvim_include_rts    = 1
let g:tweetvim_config_dir = expand('~/vimfiles/.tweetvim')
let g:tweetvim_open_buffer_cmd = 'botright split'
let g:tweetvim_display_separator = 0
let g:tweetvim_empty_separator = 0
let g:tweetvim_async_post = 1
let g:tweetvim_display_username = 1
let g:tweetvim_tweet_limit = 560
augroup TweetVimSetting
    autocmd!
    " マッピング
    " 挿入・通常モードでsayバッファを閉じる
    autocmd FileType tweetvim_say nnoremap <buffer><silent><C-g>    :<C-u>q!<CR>
    autocmd FileType tweetvim_say inoremap <buffer><silent><C-g>    <C-o>:<C-u>q!<CR><Esc>
    " 各種アクション
    autocmd FileType tweetvim     nnoremap <buffer>s                :<C-u>TweetVimSay<CR>
    autocmd FileType tweetvim     nnoremap <buffer>m                :<C-u>TweetVimMentions<CR>
    autocmd FileType tweetvim     nnoremap <buffer><Leader>h        :<C-u>TweetVimHomeTimeline<CR>
    autocmd FileType tweetvim     nnoremap <buffer><Leader>u        :<C-u>:Unite tweetvim<CR>
    autocmd FileType tweetvim     nmap     <buffer>c                <Plug>(tweetvim_action_in_reply_to)
    autocmd FileType tweetvim     nnoremap <buffer>t                :<C-u>Unite tweetvim -no-start-insert -quick-match<CR>
    autocmd FileType tweetvim     nmap     <buffer><Leader>F        <Plug>(tweetvim_action_remove_favorite)
    autocmd FileType tweetvim     nmap     <buffer><Leader>d        <Plug>(tweetvim_action_remove_status)
    autocmd FileType tweetvim     nmap     <buffer>o        <Plug>(tweetvim_action_open_links)

    " リロード
    autocmd FileType tweetvim     nmap     <buffer><Tab>            <Plug>(tweetvim_action_reload)
    " ページの先頭に戻ったときにリロード
    autocmd FileType tweetvim     nmap     <buffer><silent>gg       gg<Plug>(tweetvim_action_reload)
    " ページ移動を ff/bb から f/b に
    autocmd FileType tweetvim     nmap     <buffer>f                <Plug>(tweetvim_action_page_next)
    autocmd FileType tweetvim     nmap     <buffer>b                <Plug>(tweetvim_action_page_previous)
  " 縦移動（カーソルを常に中央にする）
  "  autocmd FileType tweetvim     nnoremap <buffer><silent>j        :<C-u>call <SID>tweetvim_vertical_move("gj")<CR>zz
  " autocmd FileType tweetvim     nnoremap <buffer><silent>k        :<C-u>call <SID>tweetvim_vertical_move("gk")<CR>zz
    " 不要なマップを除去
    autocmd FileType tweetvim     nunmap   <buffer>ff
    autocmd FileType tweetvim     nunmap   <buffer>bb
    " tweetvim バッファに移動したときに自動リロード
    autocmd BufEnter * call <SID>tweetvim_reload()
augroup END

" セパレータを飛ばして移動する
" filetype が tweetvim ならツイートをリロード
function! s:tweetvim_reload()
    if &filetype ==# "tweetvim"
        call feedkeys("\<Plug>(tweetvim_action_reload)")
    endif
endfunction
"========================================================================
"Vaffle設定
"========================================================================
"nnoremap <leader>e :<C-u>Vaffle<CR>
"function! s:customize_vaffle_mappings() abort
"  " Customize key mappings here
"  nmap <buffer> <Bslash> <Plug>(vaffle-open-root)
"  nmap <buffer> L <Plug>(vaffle-open-selected-split)
"  nmap <buffer> C <Plug>(vaffle-fill-cmdline)
"  nmap <buffer> r <Plug>(vaffle-open-home)
"endfunction
"let g:vaffle_auto_cd = 1
"let g:vaffle_open_selected_split_position = 'rightbelow'
"augroup vimrc_vaffle
"  autocmd!
"  autocmd FileType vaffle call s:customize_vaffle_mappings()
"augroup END

"========================================================================
" defx Config: start -----------------
"========================================================================
nnoremap <silent> <C-e> :<C-u>Defx 
       \<CR>:set nonumber<CR>
"      \ -toggle
call defx#custom#option('_', {
            \ 'winwidth': 40,
            \ 'split': 'vertical',
            \ 'direction': 'botright',
            \ 'columns':'mark:filename:type:size:time',
            \ 'sort': 'TIME',
            \ })
"call defx#custom#column('filename', {
"      \ 'directory_icon': '▸',
"      \ 'opened_icon': '▾',
"      \ 'root_icon': ' ',
"      \ 'min_width': 45,
"      \ 'max_width': 45,
"      \ })
"call defx#custom#column('mark', {
"      \ 'readonly_icon': '✗',
"      \ 'selected_icon': '✓',
"      \ })
autocmd FileType defx call s:defx_my_settings()
    function! s:defx_my_settings() abort
     " Define mappings
      nnoremap <silent><buffer><expr> <CR>
     \ defx#do_action('drop')
      nnoremap <silent><buffer><expr> c
     \ defx#do_action('copy')
      nnoremap <silent><buffer><expr> m
     \ defx#do_action('move')
      nnoremap <silent><buffer><expr> p
     \ defx#do_action('paste')
      nnoremap <silent><buffer><expr> l
     \ defx#do_action('open')
      nnoremap <silent><buffer><expr> E
     \ defx#do_action('open', 'vsplit')
      nnoremap <silent><buffer><expr> P
     \ defx#do_action('open', 'pedit')
      nnoremap <silent><buffer><expr> K
     \ defx#do_action('new_directory')
      nnoremap <silent><buffer><expr> N
     \ defx#do_action('new_file')
      nnoremap <silent><buffer><expr> d
     \ defx#do_action('remove')
      nnoremap <silent><buffer><expr> r
     \ defx#do_action('rename')
      nnoremap <silent><buffer><expr> x
     \ defx#do_action('execute_system')
      nnoremap <silent><buffer><expr> f
     \ defx#do_action('open_or_close_tree')
      nnoremap <silent><buffer><expr> yy
     \ defx#do_action('yank_path')
      nnoremap <silent><buffer><expr> .
     \ defx#do_action('toggle_ignored_files')
      nnoremap <silent><buffer><expr> h
     \ defx#do_action('cd', ['..'])
      nnoremap <silent><buffer><expr> ~
     \ defx#do_action('cd')
      nnoremap <silent><buffer><expr> q
     \ defx#do_action('quit')
      nnoremap <silent><buffer><expr> i
     \ defx#do_action('toggle_select') . 'j'
      nnoremap <silent><buffer><expr> I
     \ defx#do_action('clear_select_all')
      nnoremap <silent><buffer><expr> *
     \ defx#do_action('toggle_select_all')
      nnoremap <silent><buffer><expr> j
     \ line('.') == line('$') ? 'gg' : 'j'
      nnoremap <silent><buffer><expr> k
     \ line('.') == 1 ? 'G' : 'k'
      nnoremap <silent><buffer><expr> <C-l>
     \ defx#do_action('redraw')
      nnoremap <silent><buffer><expr> <C-g>
     \ defx#do_action('print')
      nnoremap <silent><buffer><expr> cd
     \ defx#do_action('change_vim_cwd')
    endfunction
    
" defx Config: end -------------------

"========================================================================
""VimFiler
"========================================================================
""ファイル削除のためGnuWin32からいろいろ持ってくる必要がある
"nnoremap <leader>e :<C-u>VimFiler<CR>
"let g:vimfiler_as_default_explorer = 1
"let g:vimfiler_safe_mode_by_default = 0
"" Edit file by tabedit.
"let g:vimfiler_edit_action = 'edit'
"nmap <F2>  :VimFiler -split -horizontal -project -toggle -quit<CR>
"autocmd FileType vimfiler nnoremap <buffer><silent>/  :<C-u>Unite file -default-action=vimfiler<CR>
"========================================================================
"Twitvim設定
"========================================================================
let twitvim_browser_cmd = 'open' " for Mac
let twitvim_browser_cmd = 'C:¥Program Files¥Your_Browser_Path' " for Windows
let twitvim_force_ssl = 1 
let twitvim_count = 40
let twitvim_enable_python3 = 1

"========================================================================
"Unite設定
"========================================================================
"let g:unite_source_file_mru_limit = 200
"nnoremap <leader>f :<C-u>Unite file<CR>
"nnoremap <leader>r :<C-u>Unite file_rec<CR>
"nnoremap <leader>b :<C-u>Unite buffer<CR>
"nnoremap <leader>g :<C-u>Unite grep<CR>
"nnoremap <leader>a :<C-u>UniteBookmarkAdd<CR>
"nnoremap <leader>m :<C-u>Unite bookmark<CR>

"========================================================================
" Tab系
"========================================================================
" 不可視文字を可視化(タブが「?-」と表示される)
set list listchars=tab:\?\-
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=2
" 行頭でのTab文字の表示幅
set shiftwidth=2
"bufferの開き方指定
"set switchbuf=useopen,vsplit
" The prefix key.
nnoremap    [Tag]   <Nop>
nmap   t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ
map <silent> [Tag]p :tablast <bar> tabnew<CR>
" tp 新しいタブを一番右に作る
map <silent> [Tag]i :tabclose<CR>
" ti タブを閉じる
map <silent> [Tag]l :tabnext<CR>
" tl 次のタブ
map <silent> [Tag]h :tabprevious<CR>
" th 前のタブ

"=========================================================================================
"検索系
"=========================================================================================
"type S, then type what you're looking for, a /, and what to replace it with
nmap S :%s//g<LEFT><LEFT>
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
"日本語の行の連結時には空白を入力しない。
set formatoptions+=mMj
" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>
let g:jasegment#model='knbc_bunsetu'
let g:jasentence_endpat = '[。．？！]\+'
" operator mappings
map <silent>sa <Plug>(operator-surround-append)
map <silent>sd <Plug>(operator-surround-delete)
map <silent>sr <Plug>(operator-surround-replace)
let g:operator#surround#blocks = {}
let g:operator#surround#blocks['-'] = [
    \   { 'block' : ['（', '）'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['P'] },
    \   { 'block' : ['「', '」'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['B'] },
    \   { 'block' : ['『', '』'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['D'] },
    \ ]
"lexima
call lexima#add_rule({'char': '「', 'input': '「', 'input_after': '」'})
call lexima#add_rule({'char': '『', 'input': '『', 'input_after': '』'})
call lexima#add_rule({'char': '【', 'input': '【', 'input_after': '】'})
call lexima#add_rule({'char': '（', 'input': '（', 'input_after': '）'})
call lexima#add_rule({'char': '<BS>', 'at': '「', 'input': '<BS>', 'delete' : 1})
call lexima#add_rule({'char': '<BS>', 'at': '『', 'input': '<BS>', 'delete' : 1})
call lexima#add_rule({'char': '<BS>', 'at': '【', 'input': '<BS>', 'delete' : 1})
call lexima#add_rule({'char': '<BS>', 'at': '（', 'input': '<BS>', 'delete' : 1})
call lexima#add_rule({'char': '<TAB>', 'at': '\%#)', 'leave': 1})
call lexima#add_rule({'char': '<TAB>', 'at': '\%#"', 'leave': 1})
call lexima#add_rule({'char': '<TAB>', 'at': '\%#''', 'leave': 1})
call lexima#add_rule({'char': '<TAB>', 'at': '\%#]', 'leave': 1})
call lexima#add_rule({'char': '<TAB>', 'at': '\%#}', 'leave': 1})
