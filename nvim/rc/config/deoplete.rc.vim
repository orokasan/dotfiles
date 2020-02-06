function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction "}}}
imap <silent><expr> <TAB>
    \ neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" :
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#manual_complete()
inoremap <silent><expr> <C-n>
    \ pumvisible() ? "\<C-n>" :
    \ deoplete#manual_complete()
inoremap <silent><expr><C-h>
    \ deoplete#smart_close_popup()."\<C-h>"
inoremap <silent><expr><BS>
    \ deoplete#smart_close_popup()."\<C-h>"
inoremap <silent><expr><C-l>
    \ deoplete#complete_common_string()
inoremap <expr><silent> <C-g> deoplete#undo_completion()
    " \ pumvisible() ? deoplete#undo_completion() : "\<C-g>"
"" <CR>: close popup and save indent.
" call deoplete#custom#source('_', 'max_info_width',150)
call deoplete#custom#source('_', 'matchers',
      \ ['matcher_fuzzy'])
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
if has('nvim')
call deoplete#custom#option({ 'refresh_always': v:true})
else
call deoplete#custom#option({ 'refresh_always': v:false})
endif
call deoplete#custom#option({
    \ 'auto_refresh_delay': 100,
    \ 'skip_multibyte': v:false,
    \ 'min_pattern_length': 2,
    \ 'prev_completion_mode': 'filter',
    \ 'ignore_sources': {
    \ 'vim': [],
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
