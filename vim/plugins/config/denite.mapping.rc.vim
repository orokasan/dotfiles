nmap s [denite]
nnoremap [denite] <Nop>
nnoremap <silent> [denite]- :<C-u>DeniteBufferDir
    \ -start-filter
    \  source<CR>
"現在開いているファイルのディレクトリ下のファイル一覧。
nnoremap <silent> [denite]s :<C-u>Denite
    \ -start-filter
    \ -path=`<SID>denite_gitdir()`
    \  file/rec file:new<CR>
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
nnoremap <silent> [denite]S :<C-u>DeniteBufferDir
    \ -start-filter
    \  file/rec file:new<CR>
nnoremap <silent> [denite]f :<C-u>DeniteProjectDir
    \ -start-filter
    \  file/rec file:new<CR>
"現在開いているファイルのディレクトリ下のファイル一覧。
nnoremap <silent> [denite]F :<C-u>DeniteProjectDir
    \ -start-filter
    \  file file:new<CR>

"プロジェクトディレクトリ下のファイル一覧。
nnoremap <silent> [denite]t :<C-u>DeniteProjectDir
    \ -start-filter
    \ file/rec file:new<CR>
"プロジェクトディレクトリ下のファイル一覧。
nnoremap <silent> [denite]T :<C-u>DeniteProjectDir
    \ -start-filter
    \ file file:new<CR>
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
nnoremap <silent> [denite]b :<C-u>Denite
    \ -buffer-name=float
    \ -start-filter
    \ buffer<CR>
nnoremap <silent> \ :<C-u>Denite
    \ -winheight=5
    \ -start-filter
    \ -buffer-name=command
    \ command command_history<CR>
nnoremap <silent> [denite]/ :<C-u>Denite
    \ -buffer-name=search
    \ anzu<CR>
"neoyank
nnoremap <silent> [denite]y :<C-u>Denite
    \ -buffer-name=search
    \ neoyank register<CR>
"コマンド履歴
nnoremap <silent> [denite]c :<C-u>Denite
    \ -buffer-name=command
    \ -winheight=5
    \ -start-filter
    \ command_history<CR>
"バッファディレクトリからgrep
nnoremap <silent> [denite]g :<C-u>Denite
    \ -start-filter
    \ -path=`<SID>denite_gitdir()`
    \ `finddir('.git', '.;') != '' ? 'grep/git:::!' : 'grep'`<CR>
"メニュー
nnoremap <silent> [denite]u :<C-u>Denite
    \ -buffer_name=menu
    \ -winheight=5
    \ menu<CR>
"ヘルプ
nnoremap <silent> [denite]h :<C-u>Denite
    \ -buffer-name=search
    \ -start-filter
    \ help<CR>
" MRU
nnoremap <silent> [denite]n :<C-u>Denite
    \ -buffer-name=normal
    \ file/old<CR>
"mark一覧
nnoremap <silent> [denite]m :<C-u>Denite
    \ -buffer-name=normal
    \ mark<CR>
":change
nnoremap <silent> [denite]k :<C-u>Denite change<CR>
":jump
nnoremap <silent> [denite]j :<C-u>Denite jump <CR>
"resumeして開く
nnoremap <silent> [denite]r :<C-u>Denite
    \ -buffer-name=search
    \ -refresh
    \ -resume<CR>
nnoremap <silent> [denite]R :<C-u>Denite
    \ -buffer-name=default
    \ -refresh
    \ -resume<CR>
""open ale message
"nnoremap <silent> [denite]a :<C-u>Denite
"    \ -buffer-name=float
"    \ -resume
"    \ ale<CR>
"コマンド結果をdeniteに出力
nnoremap [denite]p :<C-u>Denite
    \ -buffer-name=search
    \ output:
" markdown TOC
" nnoremap <silent> [denite]o :<C-u>Denite
"     \ -buffer-name=float
"     \ -resume -auto-resume -refresh
"     \ markdown<CR>
nnoremap <silent> [denite]d :<C-u>Denite
    \ dirmark<CR>
"bookmark by "add"action
nnoremap <silent> [denite]D :<C-u>DeniteBufferDir
    \ dirmark/add<CR>
" move next candidate
nnoremap <silent> [denite]. :<C-u>Denite
    \ -buffer-name=float
    \ -resume
    \ -cursor-pos=+1
    \ -immediately
    \ <CR>
nnoremap <silent> [denite], :<C-u>Denite
    \ -resume
    \ -buffer-name=float
    \ -cursor-pos=-1
    \ -immediately
    \ <CR>

function! s:denite_lsp_diagnostics() abort
let command = 'Denite -buffer-name=float -resume -auto-resume -refresh location_list'
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
