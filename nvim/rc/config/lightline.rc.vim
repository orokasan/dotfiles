
set laststatus=2
let g:lightline = {
    \ 'active': {
    \ 'left': [ ['mode', 'paste'],['git', 'ddu_path', ], [ 'readonly', 'path'] ],
    \ 'right': [
    \ ['lineinfo','lsp_status'],
    \ ['charcount','denitebuffer'],
    \ ['linter_errors', 'linter_warnings', 'quickrun', 'percent', 'progress','IMEstatus','searchcount', 'lsp_info', 'lsp_hints', 'lsp_errors', 'lsp_warnings', 'deniteinput','ddu' ]
    \ ]
    \ },
    \ 'inactive': {
    \ 'left': [['inactivefn']],
    \ 'right': [[ 'percent' ], [], ['filetype','inactiveruler']]
    \ },
    \ 'tabline' : {
    \ 'left': [['tab']],
    \ 'right': [['filetype'], ['fileencoding', 'fileformat'], [] ]
    \ },
    \ 'tab' : {
    \ 'active': [ 'tabnum', 'icon', 'modified' ],
    \ 'inactive': [ 'tabnum', 'icon', 'modified' ]
    \ },
    \ 'component':{
    \ 'lineinfo':'%{LLruler()}%<',
    \},
    \ 'component_function': {
    \ 'percent' : 'LLpercent',
    \ 'icon': 'LLicon',
    \ 'cd': 'LLcd',
    \ 'readonly':'LLReadonly',
    \ 'filetype':'LLfiletype',
    \ 'inactivefn':'LLInactiveFilename',
    \ 'inactiveruler':'LLinactiveruler',
    \ 'path':'LLMyFilepath',
    \ 'mode': 'LLMode',
    \ 'charcount':'LLCharcount',
    \ 'ddu_path':'LLddupath',
    \ 'tabnr': 'LLtabnr',
    \ 'git':'LLgit',
    \ 'gittraffic': "LLgitUpstream",
    \ 'searchres': 'LLsearchres',
    \ 'denitebuffer' : 'LLDeniteBuffer',
    \ 'denitefilter' : 'LLDeniteFilter',
    \ 'progress': 'LLLspProgress',
    \ 'ddu': 'LLddu',
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
    \ 'gittraffic': "warning",
    \ 'linter_warnings': 'warning',
    \ 'linter_errors': 'error',
    \ }
    \ }

" workaround for nvim bug
" https://github.com/neovim/neovim/issues/8796
" autocmd dein User LspDiagnosticsChanged if mode() is# 'n' | call VimLspCacheDiagnosticsCounts() | call lightline#update() | endif

call lightline#lsp#register()
let g:lightline.colorscheme = 'iceberg'
" autocmd dein ColorScheme,VimEnter * call <SID>lightline_set_colorscheme()
let g:lightline.tab_component_function = {
    \ 'modified': 'LLModified',
    \ 'filename': 'lightline#tab#filename',
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

    return &filetype =~# '^ddu' && exists('w:ddu_ui_ff_status') ? printf('%d/%d[%d]', line('.'), line('$'), w:ddu_ui_ff_status.maxItems) :
        \ &filetype is# 'help' ? 'Help' :
        \ &filetype is# 'undotree' ? 'Undotree' :
        \ &previewwindow ? 'preview' :
        \ s:mode_map[mode()]
endfunction

function! LLMyFilepath()
    if &filetype =~# '^ddu' && exists('w:ddu_ui_ff_status')
        let done = !w:ddu_ui_ff_status.done ?  '[loading...] ' : fnamemodify(ddu#get_context(b:ddu_ui_name).path, ':~')
        return done
    endif

    if &filetype =~# s:ignore_filetype
        return ''
    else
        return fnamemodify(getcwd(),':~')
    endif
endfunction

"例外filetype
let s:ignore_filetype = '\v(^ddu)'
function! s:ignore_window() abort
    return &filetype =~# s:ignore_filetype || &previewwindow
endfunction

function! LLInactiveFilename()
    if s:ignore_window()
        return LLMode()
    endif
    return fnamemodify(getcwd(),':~')
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
    if !s:ignore_window()
        return printf('L%3s:C%3s', line('.'), col('.'))
    else
        return ''
    endif
endfunction

function! LLinactiveruler() abort
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
        return ' ' . printf('%2S| %S', width , ac)
    else
        return ''
    endif
endfunction
" 文字数カウント {{{
" lightlineに渡す変数の設定
augroup CharCounter
    autocmd!
    autocmd BufNew,BufEnter,FileWritePre,BufWrite,InsertLeave * call <SID>llvarCharAllCount()
augroup END

let s:llcharcount = ''
let s:llcharallcount = ''

function! s:llvarCharAllCount()
    let l:count = wordcount().chars
    let s:llcharallcount = printf('%4S', l:count)
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
let s:llgittrafic = ''
augroup my_gin_component
  autocmd!
  autocmd User GinComponentPost redrawstatus
  " Or if you use tabline instead
  "autocmd User GinComponentPost redrawtabline
augroup END
function! LLgit() abort
    if s:ignore_window()
        return ''
    else
  return s:llgitbranch
    endif
endfunction

function! LLgitUpstream()
    if s:ignore_window()
        return ''
    else
      return gin#component#traffic#unicode()
    endif
endfunction

"重いのでキャッシュする
"本当は重くないはず…
autocmd dein BufEnter,CmdlineLeave,FileWritePre * call <SID>llgitcache()
autocmd dein SourcePost $MYVIMRC call <SID>llgitcache()

function! s:llgitcache() abort
    if s:ignore_window()
        return ''
    else
        let s:llgitbranch = ''. gin#component#branch#unicode()
        " return s:threshold(1) ? ' '. s:llgitbranch :
        " \ s:threshold(2) ? '' :''
    endif
endfunction

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
function! LLddu() abort
    " if &filetype =~# '^ddu' && exists('w:ddu_ui_ff_status')
    "     " let options = get(w:ddu_ui_ff_item.sources[0],'options', {})
    "     " let path = len(options) ? get(options,'path','') : getcwd()

    "     let done = w:ddu_ui_ff_status.done ? '' : '[loading...] '
    "     return done
    " endif
    return ''
endfunction

au User Ddu:redraw call s:update_ddu_path()
let s:ddu_path = ''
function! s:update_ddu_path() abort
  if !exists('b:ddu_ui_name')
    return
  endif
  let s:ddu_path = ddu#get_context(b:ddu_ui_name).path
endfunction

function! LLddupath()
    if &filetype =~# '^ddu' && exists('w:ddu_ui_ff_status')
      return s:ddu_path
    else
       return ''
    endif
endfunction

function! s:denite_statusline() abort
    if &filetype =~# '^ddu' && exists('w:ddu_ui_ff_status')
        return printf('%s:%s', &filetype, w:ddu_ui_ff_status.name)
    else
        return ''
    endif
endfunction

" function! Deniteinput() abort
"     if &filetype =~# '^ddu' && exists('w:ddu_ui_ff_status') && w:ddu_ui_ff_status.done

"         " return ddu#custom#get_current(w:ddu_ui_ff_status.name).sources[0].params.path
"         " let path = get(ddu#custom#get_current(w:ddu_ui_ff_status.name).sources[0].params, 'path', '') ||
"         " \ get(ddu#custom#get_current(w:ddu_ui_ff_status.name).sources[0].options.params, 'path', '')
"         " let p = get(ddu#custom#get_current(b:ddu_ui_name).sources[0].options, 'path', '')
"         return ''
"     else
"         return ''
"     endif
"     " return '[' .. done .. ']' .. w:ddu_ui_ff_status.name .. ' ' .. w:ddu_ui_ff_status.maxItems

" endfunction

" function! s:denitebuf()
"     return denite#get_status('buffer_name')
" endfunction

function! s:denitesource()
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

function! LLicon(n) abort
let buflist = tabpagebuflist(a:n)
let winnr = tabpagewinnr(a:n)
let icon = nerdfont#find(expand('#'.buflist[winnr - 1].':t'))
return icon !=# '' ? ' ' .. icon : '[No Name]'
endfunction

let g:lightline.tab_component_function = {'icon': 'LLicon'}
