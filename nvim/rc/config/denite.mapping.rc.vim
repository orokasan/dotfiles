nmap s [denite]
nnoremap [denite] <Nop>
nnoremap <silent> [denite]- <Cmd>Denite
    \ -start-filter
    \  dein<CR>
"現在開いているファイルのgit配下のファイルを開く
nnoremap <silent> [denite]f <Cmd>Denite
    \ -start-filter
    \ -path=`<SID>denite_gitdir()`
    \ file/rec file:new<CR>
function! s:denite_gitdir() abort
    if finddir('.git', '.;') != ''
        let path = (empty(bufname('%')) || &buftype =~# '^\%(nofile\|acwrite\|quickfix\|terminal\)$') ? getcwd() : expand('%:p')
        let dir = finddir('.git', path.';')
        if empty(dir) | return '' | endif
        let files = findfile('.git', path.';',-1)
        if empty(files) | return fnamemodify(dir, ':p:h:h') | endif
        let path = fnamemodify(files[-1], ':p:h')
    else
        let path = expand('%:p:h')
    return path
endif

endfunction

nnoremap <silent> [denite]k <cmd>DeniteBufferDir -input=`expand('%:t:r')`  file<CR>
nnoremap <silent> [denite]<Space> <Cmd>DeniteProjectDir
    \ -start-filter
    \  file/rec file:new<CR>
nnoremap <silent> [denite]s <Cmd>DeniteBufferDir
    \ file file:new<CR>
nnoremap <silent> [denite]F <Cmd>DeniteProjectDir
    \ -start-filter
    \  file/rec file:new<CR>
nnoremap <silent> [denite]S <Cmd>DeniteProjectDir
    \  file file:new<CR>
""ホームディレクトリ下のファイル一覧。
"nnoremap <silent> [denite]t <Cmd>Denite
"    \ -start-filter
"    \ -path=$HOME
"    \ file/rec file:new<CR>
""ホームディレクトリ下のファイル一覧。
"nnoremap <silent> [denite]T <Cmd>Denite
"    \ -start-filter
"    \ -path=$HOME
"    \ file file:new<CR>
"バッファ一覧
nnoremap <silent> [denite]B <Cmd>DeniteProjectDir
    \ -buffer-name=default
    \ buffer<CR>
nnoremap <silent> [denite]b <Cmd>Denite
    \ -buffer-name=default
    \ buffer<CR>
nnoremap <silent> s; <Cmd>Denite
    \ -winheight=10
    \ -start-filter
    \ menu:shortcut command_history<CR>
nnoremap <silent> [denite]/ <Cmd>Denite
    \ line
"miniyank
nnoremap <silent> [denite]y <Cmd>Denite
    \ -buffer-name=relative
    \ miniyank<CR>
"コマンド履歴
nnoremap <silent> [denite]c <Cmd>Denite
    \ -buffer-name=command
    \ -winheight=5
    \ -start-filter
    \ command_history<CR>
nnoremap <silent> [denite]G <Cmd>DeniteProjectDir
    \ -no-empty
    \ grep<CR>
nnoremap <silent> [denite]g <Cmd>DeniteProjectDir
    \ -path=`expand('%:h')`
    \ -no-empty
    \ grep<CR>
" nnoremap <silent> [denite]G <Cmd>Denite
"     \ -start-filter
"     \ -path=`<SID>denite_gitdir()`
"     \ `finddir('.git', '.;') != '' ? 'grep/git:::!' : 'grep'`<CR>
"メニュー
nnoremap <silent> [denite]u <Cmd>Denite
    \ -buffer_name=relative
    \ -winheight=5
    \ menu<CR>
nnoremap <silent> [denite]a <Cmd>Denite
    \ -buffer_name=normal
    \ -winheight=5
    \ menu:gina<CR>
"ヘルプ
nnoremap <silent> [denite]h <Cmd>Denite
    \ -start-filter
    \ help<CR>
" MRU
if has('nvim')
nnoremap <silent> [denite]n <Cmd>DeniteProjectDir
    \ -buffer-name=normal
    \ -unique
    \ file/old<CR>
endif
"mark一覧
nnoremap <silent> [denite]m <Cmd>Denite
    \ -auto-action=highlight
    \ mark <CR>
":change
nnoremap <silent> [denite]k <Cmd>Denite
    \ -no-empty
    \ lsp/diagnostic<CR>
":jump
nnoremap <silent> [denite]d <Cmd>Denite
    \ jump <CR>
"resumeして開く
nnoremap <silent> [denite]r <Cmd>Denite
    \ -buffer-name=default
    \ -resume<CR>
"コマンド結果をdeniteに出力
nnoremap [denite]p :Denite
    \ output:
" markdown TOC
nnoremap <silent> [denite]o <Cmd>Denite
    \ -buffer-name=float
    \ outline<CR>
    " \ markdown<CR>
nnoremap <silent> [denite]j <Cmd>Denite
    \ dirmark<CR>
nnoremap <silent> [denite]J <Cmd>Denite
    \ -start-filter
    \ dirmark<CR>

autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
nnoremap <buffer><silent> [denite]j <Cmd>Denite
    \ -default_action=my_defx
    \ dirmark<CR>
endfunction
"bookmark by "add"action
" nnoremap <silent> [denite]J <Cmd>Denite
"     \ -path=`expand('%:p:h:h')`
"     \ -default_action=add
"     \ dirmark/add<CR>
" move next candidate
nnoremap <silent> [denite]. <Cmd>Denite
    \ -buffer-name=float
    \ -resume
    \ -cursor-pos=+1
    \ -immediately
    \ <CR>
nnoremap <silent> [denite]c <Cmd>Denite
    \ -resume
    \ -refresh
    \ -buffer-name=quickfix
    \ quickfix<CR>
" nnoremap <silent> ,n <Cmd>Denite
"     \ -resume
"     \ -cursor-pos=+1
"     \ -immediately
"     \ <CR>
" nnoremap <silent> ,p <Cmd>Denite
"     \ -resume
"     \ -cursor-pos=-1
"     \ -immediately
"     \ <CR>
nnoremap <silent> [denite], <Cmd>Denite
    \ -resume
    \ -buffer-name=quickfix
    \ -cursor-pos=-1
    \ -immediately
    \ <CR>
" nnoremap <silent> [denite]c <Cmd>Denite
"     \ -buffer-name=combo
"     \ combo<CR>
nnoremap <silent> [denite]t <Cmd>Denite
    \ -buffer-name=text`bufnr()`
    \ -refresh
    \ -resume
    \ text<CR>
nnoremap <silent> [denite]T <Cmd>Denite
    \ -buffer-name=vtext`bufnr()`
    \ -refresh
    \ -resume
    \ -split=vertical
    \ -direction=topleft
    \ -winwidth=60
    \ -post-action=jump
    \ text:2:1<CR>
" nnoremap <silent> [denite]T <Cmd>Denite
"     \ -buffer-name=vtext`bufnr()`
"     \ -refresh
"     \ -resume
"     \ -default-action=highlight
"     \ text<CR>
nnoremap <silent> [denite]/ <Cmd>Denite
    \ -no-empty
    \ searchres<CR>
function! s:denite_lsp_diagnostics() abort
" let command = 'Denite -buffer-name=float location_list'
let command = 'Denite -buffer-name=float -auto-resume -refresh location_list'
if !exists('*lsp#ui#vim#diagnostics#get_diagnostics_result')
    silent! execute(command)
else
    let l:result = []
    silent let l:result = lsp#ui#vim#diagnostics#get_diagnostics_result()
    if !empty(l:result)
    call setloclist(0, l:result)
    endif
    silent! execute(command)
endif
endfunction
nnoremap <silent> sl <Cmd>call <SID>denite_lsp_diagnostics()<CR>

" some other options
" au dein BufEnter * if &ft !~# '\v(denite|denite-filter)' | setlocal scroll=3 | endif
