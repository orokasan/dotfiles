inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#manual_complete()
function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction "}}}
inoremap <silent><expr> <C-n>
    \ pumvisible() ? "\<C-n>" :
    \ deoplete#manual_complete()
inoremap <silent><expr><C-h>
    \ deoplete#smart_close_popup()."\<C-h>"
inoremap <silent><expr><BS>
    \ deoplete#smart_close_popup()."\<C-h>"
inoremap <silent><expr><C-l> 
    \ deoplete#complete_common_string()
inoremap <expr><silent> <C-g>
    \ pumvisible() ? deoplete#undo_completion() : "\<C-g>"
"" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort "{{{
  return pumvisible() ? deoplete#close_popup() : "\<CR>"
endfunction "}}}
" call deoplete#custom#source('_', 'max_info_width',150)
call deoplete#custom#source('_', 'matchers',
      \ ['matcher_fuzzy', 'matcher_length'])
"eskkにmatcherを指定してはいけない
call deoplete#custom#source('eskk', 'matchers', [])
call deoplete#custom#source('eskk', 'mark' , '▼')
call deoplete#custom#source('file', 'force_completion_length' , '3')
call deoplete#custom#source('vim', 'rank' , 200)
call deoplete#custom#source('file', 'rank', 1000)
call deoplete#custom#source('neosnippet', 'rank', 250)
call deoplete#custom#source('buffer', 'rank', 200)
call deoplete#custom#source('look', 'rank', 50)
call deoplete#custom#source('omni', 'functions' , {
    \ 'python': '',
    \ })

call deoplete#custom#var('around', {
    \   'range_above': 20,
    \   'range_below': 20,
    \   'mark_above': '[↑]',
    \   'mark_below': '[↓]',
    \   'mark_changes': '[*]',
    \})
call deoplete#custom#option('sources', {
    \ 'denite-filter': ['denite'],
    \ })

call deoplete#custom#option({
    \ 'refresh_always': v:true,
    \ 'auto_refresh_delay': 100,
    \ 'skip_multibyte': v:true,
    \ 'min_pattern_length': 2,
    \ 'prev_completion_mode': '',
    \ 'ignore_sources': {
    \ 'vim': ['lsp'],
    \ 'python': ['member']
    \    }
    \ })
call deoplete#custom#source('_', 'converters', [
    \ 'converter_remove_paren',
    \ 'converter_remove_overlap',
    \ 'converter_truncate_abbr',
    \ 'converter_truncate_menu',
    \ 'converter_truncate_kind',
    \ 'converter_auto_delimiter'
    \ ])

call deoplete#enable()
