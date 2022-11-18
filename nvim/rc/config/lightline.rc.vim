let g:lightline = {
    \ 'active': {
    \ 'left': [ ['mode', 'paste'],['git'], [ 'readonly', 'path'] ],
    \ 'right': [
    \ ['lineinfo','lsp_status'],
    \ ['charcount','denitebuffer'],
    \ ['linter_errors', 'linter_warnings', 'quickrun', 'percent', 'progress','IMEstatus','searchcount', 'lsp_info', 'lsp_hints', 'lsp_errors', 'lsp_warnings', 'deniteinput','ddupath' ]
    \ ]
    \ },
    \ 'inactive': {
    \ 'left': [['inactivefn']],
    \ 'right': [[ 'percent' ], [], ['filetype']]
    \ },
    \ 'tabline' : {
    \ 'left': [['tab']],
    \ 'right': [['filetype'], ['fileencoding', 'fileformat'], [] ]
    \ },
    \ 'tab' : {
    \ 'active': [ 'tabnum', 'filename', 'modified' ],
    \ 'inactive': [ 'tabnum', 'filename', 'modified' ]
    \ },
    \ 'component':{
    \ 'lineinfo':'%{LLruler()}%<'
    \},
    \ 'component_function': {
    \ 'percent' : 'LLpercent',
    \ 'cd': 'LLcd',
    \ 'readonly':'LLReadonly',
    \ 'filetype':'LLfiletype',
    \ 'inactivefn':'LLInactiveFilename',
    \ 'path':'LLMyFilepath',
    \ 'mode': 'LLMode',
    \ 'charcount':'LLCharcount',
    \ 'eskk': 'LLeskk',
    \ 'tabnr': 'LLtabnr',
    \ 'git':'LLgit',
    \ 'searchres': 'LLsearchres',
    \ 'denitebuffer' : 'LLDeniteBuffer',
    \ 'deniteinput': 'Deniteinput',
    \ 'denitefilter' : 'LLDeniteFilter',
    \ 'progress': 'LLLspProgress',
    \ 'ddupath': 'LLddupath',
    \ 'quickrun': 'LL_quickrun_running',
    \ 'searchcount': 'LastSearchCount',
    \ },
    \ 'component_expand': {
    \ 'buffers': 'lightline#bufferline#buffers',
    \ 'tab': 'lightline#tabs',
    \ 'linter_warnings': 'LLLspWarning',
    \ 'linter_errors': 'LLLspError',
    \ },
    \ 'component_type' : {
    \ 'buffers': 'tabsel',
    \ 'tab': 'tabsel',
    \ 'linter_warnings': 'warning',
    \ 'linter_errors': 'error',
    \ }
    \ }

" workaround for nvim bug
" https://github.com/neovim/neovim/issues/8796
" autocmd dein User LspDiagnosticsChanged if mode() is# 'n' | call VimLspCacheDiagnosticsCounts() | call lightline#update() | endif

let g:lightline.colorscheme = 'iceberg'
" autocmd dein ColorScheme,VimEnter * call <SID>lightline_set_colorscheme()
let g:lightline.tab_component_function = {
    \ 'modified': 'LLModified',
    \ 'tabnum': 'LLtabnum' }

" let g:lightline.subseparator= { 'left': '', 'right': '' }
" let g:lightline.separator= { 'left': '', 'right': '' }
" let g:lightline.tabline_subseparator= { 'left': '', 'right': '' }
" let g:lightline.tabline_separator= { 'left': '', 'right': '' }
let g:component_function_visible_condition = {
    \ 'readonly': 1,
    \ 'inactivefn': 1,
    \ 'path': 1,
    \ 'mode': 1,
    \ 'charcount': 1,
    \ 'git': 1,
    \ 'lineinfo': 1
    \ }

function! LLModified(n) abort
    let winnr = tabpagewinnr(a:n)
    return gettabwinvar(a:n, winnr, '&modified') ? '+' : gettabwinvar(a:n, winnr, '&modifiable') ? '' : '<>'
endfunction
" if !exists('g:disable_IM_Control') && g:disable_IM_Control is 1
"     let g:lightline.component += {
"         \'IMEstatus':'%{IMStatus("-JP-")}'
"         \}
" endif
if has('nvim')
    let g:lightline#bufferline#clickable = 1
    let g:lightline.component_raw = {'buffers': 1}
endif
let g:lightline#bufferline#unnamed = ''
let g:lightline#bufferline#filename_modifier = ':t'
let g:lightline#bufferline#show_number = 2
let g:lightline#bufferline#more_buffers = '…'
let g:lightline#bufferline#number_separator = ''
let g:lightline#bufferline#number_map = {
    \ 0: '⁰', 1: '¹', 2: '²', 3: '³', 4: '⁴',
    \ 5: '⁵', 6: '⁶', 7: '⁷', 8: '⁸', 9: '⁹'}

nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)
nmap <Leader>c1 <Plug>lightline#bufferline#delete(1)
nmap <Leader>c2 <Plug>lightline#bufferline#delete(2)
nmap <Leader>c3 <Plug>lightline#bufferline#delete(3)
nmap <Leader>c4 <Plug>lightline#bufferline#delete(4)
nmap <Leader>c5 <Plug>lightline#bufferline#delete(5)
nmap <Leader>c6 <Plug>lightline#bufferline#delete(6)
nmap <Leader>c7 <Plug>lightline#bufferline#delete(7)
nmap <Leader>c8 <Plug>lightline#bufferline#delete(8)
nmap <Leader>c9 <Plug>lightline#bufferline#delete(9)
nmap <Leader>c0 <Plug>lightline#bufferline#delete(10)
let s:threshold = 130
function! s:threshold(n) abort
    let s = s:threshold
    let w = winwidth(0) - 40
    return a:n == 0 ? w > s :
        \ a:n == 1 ? w > s*2/3 :
        \ a:n == 2 ? w > s/3 : w > s/4
endfunction
let s:diagnostics_counts = {}
" autocmd User LspRequest lightline#update()

function! LL_quickrun_running()
    if !exists('*quickrun#is_running')
        return ''
    elseif quickrun#is_running()
        return exists("g:quickrun_config[&ft]['command']") ? "Running:" .. g:quickrun_config[&ft]['command'] : "Running.."
    else
        return ""
    endif
endfunction

let s:mode_map = {
    \     'n': 'NORMAL', 'i': 'INSERT', 'R': 'REPLACE', 'v': 'VISUAL', 'V': 'V-LINE', "\<C-v>": 'V-BLOCK',
    \     'c': 'COMMAND', 's': 'SELECT', 'S': 'S-LINE', "\<C-s>": 'S-BLOCK', 't': 'TERMINAL'
    \   }
function! LLMode()
    return &filetype is# 'unite' ? 'Unite' :
        \ &filetype is# 'help' ? 'Help' :
        \ &filetype is# 'defx' ? 'Defx' :
        \ &filetype is# 'fern' ? 'Fern' :
        \ &filetype is# 'denite' ? '' :
        \ &filetype =~# '^ddu' ? '' :
        \ &filetype is# 'undotree' ? 'undotree' :
        \ &filetype is# 'tweetvim' ? 'Tweetvim' :
        \ &previewwindow ? 'preview' :
        \ s:mode_map[mode()]
endfunction

function! LLMyFilepath()
    if &filetype =~# '^ddu' && exists('w:ddu_ui_ff_status')
        if len(w:ddu_ui_ff_status.input) > 0
            return '#' . w:ddu_ui_ff_status.input
        else
            return '#'
        endif
    elseif &filetype =~# s:ignore_filetype
        return ''
        " elseif exists('*anzu#search_status') && strwidth(s:llanzu())
        "     return s:llanzu()
    else
        " if exists('g:loaded_webdevicons')
        "     let icon = WebDevIconsGetFileTypeSymbol()
        " else
        "     let icon = ''
        " endif

        " let l:filepath = expand('%:~:.')
        " let width = winwidth(0) - 60
        " let len = strdisplaywidth(l:filepath)
        " if len > width
        "     let filepath = '...' .. strpart(filepath,  len - width)
        " endif
        " let l:modified = &modified ? '[+]' : ''
        " return  l:filepath . l:modified . ' ' . icon
        return fnamemodify(getcwd(),':~')
    endif
endfunction

"例外filetype
let s:ignore_filetype = '\v(vimfiler|gundo|defx|tweetvim|denite|denite-filter|fern|^ddu)'
function! s:ignore_window() abort
    return &filetype =~# s:ignore_filetype || &previewwindow
endfunction

function! LLInactiveFilename()
    if s:ignore_window()
        return LLMode()
    endif
    return ''
    " let l:modified = &modified ? '[+]' : ''
    " return  expand('%:~:.')..l:modified
endfunction

function! LLeskk() abort
    if s:ignore_window() || !s:threshold(2)
        return ''
    else
        if exists('*skkeleton#mode') && skkeleton#mode()
            return '[' .. skkeleton#mode() .. ']'
        else
            return '[]'
        endif
    endif
endfunction

function! LLfiletype() abort
    return !s:ignore_window() ? &filetype : ''
endfunction

function! LLruler() abort
    if &filetype =~# '^ddu' && exists('w:ddu_ui_ff_status')
        " let done = w:ddu_ui_ff_status.done ? '' : '[loading...]'
        " return '[' .. done .. ']' .. w:ddu_ui_ff_status.name .. ' ' .. w:ddu_ui_ff_status.maxItems
        return printf('%d/%d[%d]', line('.'), line('$'), w:ddu_ui_ff_status.maxItems)
    endif
    if !s:ignore_window()
        return printf('L%3s:C%3s', line('.'), col('.'))
    else
        return ''
    endif
endfunction

function! LLCharcount()
    if match(mode(),"[vV]") !=# -1
        let width = 0
        let [lnum1, col1] = getpos("v")[1:2]
        let [lnum2, col2] = getpos(".")[1:2]
        let [lnum1, lnum2] = lnum2 < lnum1 ? [lnum2, lnum1] :[lnum1, lnum2]
        if abs(lnum1 - lnum2) < 1000
        for l in range(lnum1, lnum2)
            let width += strwidth(getline(l))
        endfor
    else
        let width = strwidth(getline('.'))
        endif
    else
        let width = strwidth(getline('.'))
    endif
    let width = width/2
    if !s:ignore_window()
        " return abbr
        let ac =  s:llcharallcount > 10000 ? s:llcharallcount/1000 . 'k' : s:llcharallcount
        return ' ' . printf('%3S', width .. '| ' .. ac)
    else
        return ''
    endif
endfunction
" 文字数カウント {{{
" lightlineに渡す変数の設定
augroup CharCounter
    autocmd!
    " autocmd BufNew,BufEnter,TextChanged,CursorMoved,CursorMovedI * call <SID>llvarCharCount()
    autocmd BufNew,BufEnter,FileWritePre,BufWrite,InsertLeave * call <SID>llvarCharAllCount()
augroup END

let s:llcharcount = ''
let s:llcharallcount = ''

function! s:llvarCharAllCount()
    let l:count = wordcount().chars
    let s:llcharallcount = printf('%4S', l:count)
endfunction

function! s:llvarCharCount()
    let l:count = strwidth(getline('.'))
    let s:llcharcount = l:count < 10 ? '  ' . l:count :
        \ l:count <100 ? ' ' . l:count :
        \ l:count
endfunction
"}}}

function! LLpercent() abort
    return &filetype !~# '^ddu' ? 100 * line('.') / line('$') . '%«' . line('$') : ''
endfunction

function! LLReadonly()
    "    return &readonly ? '⭤' : ''
    " return &readonly ? '' : ''
    return &readonly ? '' : ''
endfunction

function! LLtabnr() abort
    return tabpagenr('$') > 1 ? tabpagenr().':'.tabpagenr('$').'«' : '«'
endfunction

let s:llgitbranch = ''
function! LLgit() abort
    if s:ignore_window()
        return ''
    else
        return len(s:llgitbranch) ? ''. s:llgitbranch : ''
        " return s:threshold(1) ? ' '. s:llgitbranch :
        " \ s:threshold(2) ? '' :''
    endif
endfunction

"重いのでキャッシュする
"本当は重くないはず…
autocmd dein BufEnter,CmdlineLeave,FileWritePre * call <SID>llgitcache()
autocmd dein SourcePost $MYVIMRC call <SID>llgitcache()

function! s:llgitcache() abort
    if !exists('*gitbranch#name')
        return
    else
        let s:llgitbranch = len(gitbranch#name()) ? gitbranch#name() : ''
    endif
endfunction

" 検索ステータスを表示 (vim-anzuを利用) {{{
" autocmd dein InsertEnter,BufEnter,CursorMoved,CmdlineEnter * if exists('*anzu#clear_search_status')
"     \| call anzu#clear_search_status() | endif


" autocmd dein CmdlineLeave /,\? :call timer_start(0, {-> execute('AnzuUpdateSearchStatus') } )
" autocmd dein User IncSearchExecute if exists(':AnzuUpdateSearchStatus') | call execute('AnzuUpdateSearchStatus') | endif

function! s:llanzu()
    let s:anzu = substitute(anzu#search_status(), '\v^(\\v|\\V)', "" , "")
    return strwidth(s:anzu) < 30 ? s:anzu : matchstr(s:anzu,'(\d\+\/\d\+)')
endfunction "}}}

" Deniteステータス {{{
function! LLDeniteFilter()
    return s:denite_statusline()
endfunction

function! LLDeniteBuffer() abort
    return s:denite_statusline()
endfunction

au FileType ddu-* call <SID>llddustatus()
let s:ddustatus = {}
function! s:llddustatus() abort
    let s:ddustatus = ddu#custom#get_current(b:ddu_ui_name)
endfunction
function! LLddupath() abort
    if &filetype =~# '^ddu' && exists('w:ddu_ui_ff_item') && exists('w:ddu_ui_ff_status')
        let path = ''
        if len(w:ddu_ui_ff_item.sources) <= 0
            return ''
        endif

        let options = get(w:ddu_ui_ff_item.sources[0],'options', {})
        let params = get(w:ddu_ui_ff_item.sources[0],'params',{})
        let path_o = len(options) ? get(options,'path','') : ''
        let path_p = len(params)  ? get(params,'path','') : ''
        let path = len(path_p) ? path_p : len(path_o) ? path_o : getcwd()

        let done = w:ddu_ui_ff_status.done ? '' : '[loading...] '
        return done .. fnamemodify(path, ':~')
    endif
    return ''
endfunction

function! s:denite_statusline() abort
    if &filetype =~# '^ddu' && exists('w:ddu_ui_ff_status')
        return printf('%s:%s', &filetype, w:ddu_ui_ff_status.name)
    else
        return ''
    endif
endfunction

function! Deniteinput() abort
    if &filetype =~# '^ddu' && exists('w:ddu_ui_ff_status') && w:ddu_ui_ff_status.done

        " return ddu#custom#get_current(w:ddu_ui_ff_status.name).sources[0].params.path
        " let path = get(ddu#custom#get_current(w:ddu_ui_ff_status.name).sources[0].params, 'path', '') ||
        " \ get(ddu#custom#get_current(w:ddu_ui_ff_status.name).sources[0].options.params, 'path', '')
        " let p = get(ddu#custom#get_current(b:ddu_ui_name).sources[0].options, 'path', '')
        return ''
    else
        return ''
    endif
    " return '[' .. done .. ']' .. w:ddu_ui_ff_status.name .. ' ' .. w:ddu_ui_ff_status.maxItems

endfunction

function! s:denitebuf()
    return denite#get_status('buffer_name')
endfunction

function! s:denitesource()
    " let l:sources = denite#get_status('sources')
    " let l:sources = substitute(l:sources, " file:\\['new'\\](\\d\\+/\\d\\+)", '','g')
    " let l:p = denite#get_status('path')
    " let l:path = matchstr(l:p, "\\[\\zs.*\\ze\\]", 'g')
    " let l:path = fnamemodify(l:path,':~')
    " if strwidth(l:path) > 40
    "     let path = '.../' . fnamemodify(path,':h:h:t'). '/'
    "         \ . fnamemodify(path,':h:t'). '/'. fnamemodify(path, ':t')
    " endif
    " let l:path =  '[' . l:path . ']'
    " let l:sources = substitute(l:sources, "\:\\[.*\\]", '','g')
    if &filetype =~# '^ddu' && exists('w:ddu_ui_ff_status')
        return printf('[%d/%d]', line('.'),line('$'))
    endif
endfunction

function! LLcd() abort
    let cwd = getcwd()
    return fnamemodify(cwd, ':~')
endfunction

function! LLtabnum(n)
    return a:n .. ':'
endfunction
" function! s:lastSearchCount() abort
"   let result = searchcount(#{recompute: 0})
"   if empty(result)
"     return ''
"   endif
"   if result.incomplete ==# 1     " timed out
"     let g:lightline_searchcount = printf(' /%s [?/??]', @/)
"   elseif result.incomplete ==# 2 " max count exceeded
"     if result.total > result.maxcount &&
"     \  result.current > result.maxcount
"       let g:lightline_searchcount = printf(' /%s [>%d/>%d]', @/,
"       \             result.current, result.total)
"     elseif result.total > result.maxcount
"       let g:lightline_searchcount = printf(' /%s [%d/>%d]', @/,
"       \             result.current, result.total)
"     endif
"   endif
"   let g:lightline_searchcount = printf(' /%s [%d/%d]', @/,
"   \             result.current, result.total)
" endfunction
let s:searchcount = {}
au dein User SearchxAcceptReturn let s:searchcount = searchcount()
function! LLsearchres() abort
    let result = s:searchcount
    if empty(result)
        return ''
    endif
    if result.incomplete ==# 2 " max count exceeded
        if result.total > result.maxcount &&
            \  result.current > result.maxcount
            return printf(' [>%d/>%d]',
                \             result.current, result.total)
        elseif result.total > result.maxcount
            return printf(' [%d/>%d]',
                \             result.current, result.total)
        endif
    endif
    return printf('  [%d/%d]',
        \             result.current, result.total)
endfunction
