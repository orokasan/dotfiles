nmap s [denite]
nnoremap [denite] <Nop>
nnoremap <silent> [denite]- :<C-u>DeniteBufferDir
    \ -start-filter
    \  source<CR>
"現在開いているファイルのgit配下のファイルを開く
nnoremap <silent> [denite]f :<C-u>Denite
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
nnoremap <silent> [denite]<Space> :<C-u>DeniteProjectDir
    \ -start-filter
    \  file/rec file:new<CR>
nnoremap <silent> [denite]F :<C-u>DeniteBufferDir
    \ -start-filter
    \ file file:new<CR>
nnoremap <silent> [denite]s :<C-u>DeniteProjectDir
    \ -start-filter
    \  file/rec file:new<CR>
nnoremap <silent> [denite]S :<C-u>DeniteProjectDir
    \ -start-filter
    \  file file:new<CR>
""ホームディレクトリ下のファイル一覧。
"nnoremap <silent> [denite]t :<C-u>Denite
"    \ -start-filter
"    \ -path=$HOME
"    \ file/rec file:new<CR>
""ホームディレクトリ下のファイル一覧。
"nnoremap <silent> [denite]T :<C-u>Denite
"    \ -start-filter
"    \ -path=$HOME
"    \ file file:new<CR>
"バッファ一覧
nnoremap <silent> [denite]B :<C-u>DeniteProjectDir
    \ -buffer-name=default
    \ buffer<CR>
nnoremap <silent> [denite]b :<C-u>Denite
    \ -buffer-name=default
    \ buffer<CR>
nnoremap <silent> s; :<C-u>Denite
    \ -winheight=10
    \ -start-filter
    \ menu:shortcut command_history<CR>
nnoremap <silent> [denite]/ :<C-u>Denite
    \ line
"neoyank
nnoremap <silent> [denite]y :<C-u>Denite
    \ -buffer-name=relative
    \ neoyank<CR>
"コマンド履歴
nnoremap <silent> [denite]c :<C-u>Denite
    \ -buffer-name=command
    \ -winheight=5
    \ -start-filter
    \ command_history<CR>
nnoremap <silent> [denite]G :<C-u>DeniteProjectDir
    \ -no-empty
    \ grep<CR>
nnoremap <silent> [denite]g :<C-u>DeniteProjectDir
    \ -path=`expand('%:h')`
    \ -no-empty
    \ grep<CR>
" nnoremap <silent> [denite]G :<C-u>Denite
"     \ -start-filter
"     \ -path=`<SID>denite_gitdir()`
"     \ `finddir('.git', '.;') != '' ? 'grep/git:::!' : 'grep'`<CR>
"メニュー
nnoremap <silent> [denite]u :<C-u>Denite
    \ -buffer_name=relative
    \ -winheight=5
    \ menu<CR>
nnoremap <silent> [denite]a :<C-u>Denite
    \ -buffer_name=normal
    \ -winheight=5
    \ menu:gina<CR>
"ヘルプ
nnoremap <silent> [denite]h :<C-u>Denite
    \ -start-filter
    \ help<CR>
" MRU
nnoremap <silent> [denite]n :<C-u>DeniteProjectDir
    \ -buffer-name=normal
    \ file/old file<CR>
    " \ -unique
"mark一覧
nnoremap <silent> [denite]m :<C-u>Denite
    \ -auto-action=highlight
    \ mark <CR>
":change
nnoremap <silent> [denite]k :<C-u>Denite
    \ -no-empty
    \ lsp/diagnostic<CR>
":jump
nnoremap <silent> [denite]d :<C-u>Denite
    \ -auto-action=preview
    \ jump <CR>
"resumeして開く
nnoremap <silent> [denite]r :<C-u>Denite
    \ -buffer-name=default
    \ -resume<CR>
"コマンド結果をdeniteに出力
nnoremap [denite]p :<C-u>Denite
    \ output:
" markdown TOC
nnoremap <silent> [denite]o :<C-u>Denite
    \ -buffer-name=float
    \ outline<CR>
    " \ markdown<CR>
nnoremap <silent> [denite]j :<C-u>Denite
    \ dirmark<CR>
"bookmark by "add"action
nnoremap <silent> [denite]J :<C-u>Denite
    \ -path=`expand('%:p:h:h')`
    \ -default_action=add
    \ dirmark/add<CR>
" move next candidate
nnoremap <silent> [denite]. :<C-u>Denite
    \ -buffer-name=float
    \ -resume
    \ -cursor-pos=+1
    \ -immediately
    \ <CR>
nnoremap <silent> [denite]c :<C-u>Denite
    \ -resume
    \ -refresh
    \ -buffer-name=quickfix
    \ quickfix<CR>
nnoremap <silent> ,n :<C-u>Denite
    \ -resume
    \ -cursor-pos=+1
    \ -immediately
    \ <CR>
nnoremap <silent> ,p :<C-u>Denite
    \ -resume
    \ -cursor-pos=-1
    \ -immediately
    \ <CR>
nnoremap <silent> [denite], :<C-u>Denite
    \ -resume
    \ -buffer-name=quickfix
    \ -cursor-pos=-1
    \ -immediately
    \ <CR>
" nnoremap <silent> [denite]c :<C-u>Denite
"     \ -buffer-name=combo
"     \ combo<CR>
nnoremap <silent> [denite]t :<C-u>Denite
    \ -buffer-name=text`bufnr()`
    \ -refresh
    \ -resume
    \ text<CR>
nnoremap <silent> [denite]T :<C-u>Denite
    \ -buffer-name=vtext`bufnr()`
    \ -refresh
    \ -resume
    \ -split=vertical
    \ -direction=topleft
    \ -winwidth=60
    \ -post-action=remain
    \ -default-action=highlight
    \ text:1<CR>
nnoremap <silent> [denite]/ :<C-u>Denite
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
nnoremap <silent> sl :<C-u>call <SID>denite_lsp_diagnostics()<CR>

" some other options
" au dein BufEnter * if &ft !~# '\v(denite|denite-filter)' | setlocal scroll=3 | endif
