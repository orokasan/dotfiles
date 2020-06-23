let g:lightline = {
    \ 'active': {
        \ 'left': [ ['mode', 'paste'],['eskk','git'], [ 'readonly', 'path'] ],
        \ 'right': [
            \ ['lineinfo'],
            \ ['charcount'],
            \ [ 'linter_errors', 'linter_warnings', 'quickrun', 'percent', 'filetype', 'denitebuffer', 'IMEstatus']
        \ ]
    \ },
    \ 'inactive': {
        \ 'left': [['inactivefn']],
        \ 'right': [[ 'percent' ], [], ['filetype','denitefilter']]
    \ },
    \ 'tabline' : {
        \ 'left': [['buffers'], ['tabdenitesource']],
        \ 'right': [['tab'], ['fileencoding', 'fileformat'] ]
    \ },
    \ 'component':{
        \ 'lineinfo':'%{LLruler()}%<'
    \},
    \ 'component_function': {
        \ 'percent' : 'LLpercent',
        \ 'readonly':'LLReadonly',
        \ 'filetype':'LLfiletype',
        \ 'inactivefn':'LLInactiveFilename',
        \ 'path':'LLMyFilepath',
        \ 'mode': 'LLMode',
        \ 'charcount':'LLCharcount',
        \ 'eskk': 'LLeskk',
        \ 'tab': 'LLtabnr',
        \ 'git':'LLgit',
        \ 'denitebuffer' : 'LLDeniteBuffer',
        \ 'denitefilter' : 'LLDeniteFilter',
        \ 'quickrun': 'LL_quickrun_running',
    \ },
    \ 'component_expand': {
        \ 'buffers': 'lightline#bufferline#buffers',
        \ 'linter_warnings': 'LLLspWarning',
        \ 'linter_errors': 'LLLspError',
    \ },
   \ 'component_type' : {
        \ 'buffers': 'tabsel',
        \ 'linter_warnings': 'warning',
        \ 'linter_errors': 'error',
    \ }
\ }

" workaround for nvim bug
" https://github.com/neovim/neovim/issues/8796
autocmd dein User LspDiagnosticsChanged if mode() is# 'n' | call lightline#update() | endif

autocmd dein ColorScheme,VimEnter * call <SID>lightline_set_colorscheme()
function! s:lightline_set_colorscheme() abort
" if !exists('g:loaded_lightline')
" return
" endif
try
if g:colors_name ==# 'seagull'
  let g:lightline.colorscheme = 'snow_light'
elseif g:colors_name =~# 'iceberg\|wombat\|solarized\|landscape\|jellybeans\|seoul256\|Tomorrow'
  let g:lightline.colorscheme =
        \ substitute(substitute(g:colors_name, '-', '_', 'g'), '256.*', '', '')
endif
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
catch
endtry
endfunction

" let g:lightline.subseparator= { 'left': '', 'right': '' }
" let g:lightline.separator= { 'left': '', 'right': '' }
" let g:lightline.tabline_subseparator= { 'left': '', 'right': '' }
" let g:lightline.tabline_separator= { 'left': '', 'right': '' }
let g:component_function_visible_condition = {
        \ 'readonly': 1,
        \ 'denitebuf': 1,
        \ 'inactivefn': 1,
        \ 'path': 1,
        \ 'mode': 1,
        \ 'charcount': 1,
        \ 'git': 1,
        \ 'lineinfo': 1
        \ }

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

let s:threshold = 120
function! s:threshold(n) abort
    let s = s:threshold
    let w = winwidth(0)
    return a:n == 0 ? w > s :
        \ a:n == 1 ? w > s*2/3 :
        \ a:n == 2 ? w > s/3 : w > s/4
endfunction

function! LLLspError() abort
" workaround
" gopls is crashed by calling vim.lsp.buf.server_ready()
if &filetype ==# 'go'
    return ''
endif

if luaeval('vim.lsp.buf.server_ready()')
    let e = luaeval("vim.lsp.util.buf_diagnostics_count(\"Error\")")
    return e ? '' . e : ''
else
    return ''
endif
endfunction

function! LLLspWarning() abort
if &filetype ==# 'go'
    return ''
endif
if luaeval('vim.lsp.buf.server_ready()')
    let w = luaeval("vim.lsp.util.buf_diagnostics_count(\"Warning\")")
    return  w ? '' . w : ''
else
    return ''
endif
endfunction

function! LL_quickrun_running()
    if !exists('*quickrun#is_running')
        return ''
    elseif quickrun#is_running()
        return "QuickRunning..."
    else
        return ""
    endif
endfunction

function! LLMode()
    return &filetype is# 'unite' ? 'Unite' :
        \ &filetype is# 'help' ? 'Help' :
        \ &filetype is# 'defx' ? 'Defx' :
        \ &filetype is# 'denite' ? LLDeniteMode() :
        \ &filetype is# 'undotree' ? 'undotree' :
        \ &filetype is# 'tweetvim' ? 'Tweetvim' :
        \ &previewwindow ? 'preview' :
        \ lightline#mode()
endfunction

function! LLMyFilepath()
    if &filetype =~# s:ignore_filetype
        return ''
    " elseif exists('*anzu#search_status') && strwidth(s:llanzu())
    "     return s:llanzu()
    else
        if exists('g:loaded_webdevicons')
            let icon = WebDevIconsGetFileTypeSymbol()
        else
            let icon = ''
        endif

        let l:filepath = expand('%:~')
        let l:filename = expand('%:t')
        if s:threshold(0)
            let l:fn =  strwidth(l:filepath) < s:threshold/2 ? l:filepath :
            \ l:filename
        elseif s:threshold(2)
            let l:fn = l:filename
        else
            return ''
        endif
            let l:modified = &modified ? '[+]' : ''
            return  l:fn . l:modified . ' ' . icon
    endif
endfunction

"例外filetype
let s:ignore_filetype = '\v(vimfiler|gundo|defx|tweetvim|denite|denite-filter)'
function! s:ignore_window() abort
    return &filetype =~# s:ignore_filetype || &previewwindow
endfunction

function! LLInactiveFilename()
    return s:ignore_window() ? expand('%:t') : &filetype is# 'denite' ? '': LLMode()
endfunction

function! LLeskk() abort
    if s:ignore_window() || !s:threshold(2)
        return ''
    elseif !exists('*LLmyeskk')
        return '[aA]'
    else
        return LLmyeskk()
    endif
endfunction

function! LLfiletype() abort
    return s:ignore_window() ? &filetype : ''
endfunction

function! LLruler() abort
    let info = {'c': col('.'), 'l': line('.') }
    let l:fcol =
        \ info['c'] < 10 ? '  ' . info['c'] :
        \ info['c'] < 100 ? ' ' . info['c'] : info['c']
    let l:fline = info['l'] < 10 ? ' ' . info['l'] : info['l']

    if s:ignore_window()
        return s:threshold(0) ? printf('%s:%s«%d', fcol , fline , line('$') ) :
            \  s:threshold(1) ? printf('%s:%s', fcol , fline ) : ''
    else
        return ''
    endif
endfunction

function! LLCharcount()
    if s:ignore_window()
        let abbr = s:threshold(0) ? '' . s:llcharcount . '|' . s:llcharallcount:
            \ s:threshold(1) ? '' . s:llcharcount : ''
        return abbr
    else
        return ''
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

function! s:llvarCharAllCount()
    let l:count = 0
    for l in range(0, line('$'))
        let l:count += strchars(getline(l))
    endfor
    let s:llcharallcount = l:count <10 ? '   ' . l:count :
        \ l:count <100 ? '  ' . l:count :
        \ l:count <1000 ? ' ' . l:count : l:count
endfunction

function! s:llvarCharCount()
    let l:count = strchars(getline('.'))
    let s:llcharcount = l:count < 10 ? '  ' . l:count :
        \ l:count <100 ? ' ' . l:count :
        \ l:count
endfunction
"}}}

function! LLpercent() abort
    return &filetype !=# 'denite' ? 100 * line('.') / line('$') . '%' : ''
endfunction

function! LLReadonly()
"    return &readonly ? '⭤' : ''
    return &readonly ? '' : ''
endfunction

function! LLtabnr() abort
    return tabpagenr('$') > 1 ? tabpagenr().':'.tabpagenr('$').'«' : '«'
endfunction

call get(s:, 'llgitbranch', '')
function! LLgit() abort
    if s:ignore_window() 
        return ''
    else
        return s:threshold(1) ? ' '. s:llgitbranch :
       \ s:threshold(2) ? '' :''
    endif
endfunction

"重いのでキャッシュする
autocmd dein BufEnter,CmdlineLeave,FileWritePre * call <SID>llgitcache()
autocmd dein SourcePost $MYVIMRC call <SID>llgitcache()
function! s:llgitcache() abort
    let s:llgitbranch = ''
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

function! LLDeniteMode() abort
    if len(denite#get_status('input')) > 0
        return ''
    else
        return '# Denite'
    endif
endfunction

function! s:denite_statusline() abort
    if &filetype isnot# 'denite'
        return ''
    else
        return s:denitesource()
   endif
endfunction

function! s:deniteinput() abort
    return denite#get_status('input')
endfunction

function! s:denitebuf()
    return denite#get_status('buffer_name')
endfunction

function! s:denitesource()
    let l:sources = denite#get_status('sources')
    let l:sources = substitute(l:sources, " file:\\['new'\\](\\d\\+/\\d\\+)", '','g')
    let l:p = denite#get_status('path')
    let l:path = matchstr(l:p, "\\[\\zs.*\\ze\\]", 'g')
    let l:path = fnamemodify(l:path,':~')
    if strwidth(l:path) > 40
        let path = '.../' . fnamemodify(path,':h:h:t'). '/'
            \ . fnamemodify(path,':h:t'). '/'. fnamemodify(path, ':t')
    endif
    let l:path =  '[' . l:path . ']'
    let l:sources = substitute(l:sources, "\:\\[.*\\]", '','g')
    return l:sources . l:path
endfunction
