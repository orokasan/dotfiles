function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction "}}}
imap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ "\<TAB>"
imap <silent><expr> <S-TAB>
      \ pumvisible() ? "\<C-p>" :
      \ "\<S-TAB>"
inoremap <silent><expr> <C-p>
    \ pumvisible() ? "\<C-p>" :
    \ deoplete#manual_complete()
inoremap <silent><expr> <C-n>
    \ pumvisible() ? "\<C-n>" :
    \ deoplete#manual_complete()
" inoremap <silent><expr><C-h>
"     \ deoplete#smart_close_popup()."\<C-h>"
" inoremap <silent><expr><BS>
"     \ deoplete#smart_close_popup()."\<C-h>"
inoremap <silent><expr><C-l>
    \ pumvisible() ?  deoplete#complete_common_string()
    \<C-l>" :
" inoremap <expr><silent> <C-g> deoplete#undo_completion()

    " \ pumvisible() ? deoplete#undo_completion() : "\<C-g>"
"" <CR>: close popup and save indent.
" call deoplete#custom#source('_', 'max_info_width',150)

call deoplete#custom#source('eskk', 'mark' , '▼')
call deoplete#custom#source('file', 'force_completion_length' , '3')
call deoplete#custom#source('vim', 'rank' , 200)
call deoplete#custom#source('file', 'rank', 1000)
call deoplete#custom#source('neosnippet', 'rank', 250)
call deoplete#custom#source('buffer', 'rank', 200)
call deoplete#custom#source('look', 'rank', 50)

call deoplete#custom#var('around', {
    \   'range_above': 20,
    \   'range_below': 20,
    \   'mark_above': '[↑]',
    \   'mark_below': '[↓]',
    \   'mark_changes': '[c]',
    \})
call deoplete#custom#option('sources', {
    \ 'denite-filter': [''],
    \ })
call deoplete#custom#option({ 'refresh_always': v:true})

call deoplete#custom#option({
    \ 'auto_refresh_delay': 0,
    \ 'skip_multibyte': v:false,
    \ 'min_pattern_length': 2,
    \ 'prev_completion_mode': 'filter',
    \ })

call deoplete#custom#source('_', 'converters', [
    \ 'converter_remove_paren',
    \ 'converter_remove_overlap',
    \ 'converter_truncate_abbr',
    \ 'converter_truncate_menu',
    \ 'converter_truncate_kind',
    \ ])
call deoplete#custom#option('keyword_patterns', {
\ '_': '[a-zA-Z_]\k*',
\ 'text': '[a-zA-Z_-]*',
\ 'markdown': '[a-zA-Z_-]*|[\u2E80-\u2FDF\u3005-\u3007\u3400-\u4DBF\u4E00-\u9FFF\uF900-\uFAFF\U00020000-\U0002EBEF]*',
\ 'txt': '[a-zA-Z_-]*|[\u2E80-\u2FDF\u3005-\u3007\u3400-\u4DBF\u4E00-\u9FFF\uF900-\uFAFF\U00020000-\U0002EBEF]*',
\ 'ruby': '[a-zA-Z_]\w*[!?]?',
\})
" call deoplete#custom#option({'ignore_sources': {'_': ['eskk']}})
" deoplete-lsp should not be lazy loaded
" if dein#is_sourced('deoplete-lsp')
"     let lsp_enabled_filetype = ['vim', 'python', 'go', 'tex', '']
"     let ignore_source = ['around', 'look', 'member', 'buffer', 'syntax']
"     let config = {}
"     for ft in lsp_enabled_filetype
"         let config[ft] = ignore_source
"     endfor
"     call deoplete#custom#option({'ignore_sources': config})
" endif
call deoplete#enable()
