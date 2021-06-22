" if has('conceal')
"     setlocal conceallevel=0
" endif
set tabstop=2
inoremap <buffer><silent><expr> <C-d> getcurpos()[2] ==# 1 ? "- " :
    \ match(getline('.'), '^-\s') >=0 ? "<C-u>" : "\<C-d>"
inoremap <buffer><silent><expr> <C-t> getcurpos()[2] ==# 1 ? "- " : "\<C-t>"
nnoremap <buffer><silent><expr> o match(getline('.'), '\*\s') >=0 ? "o- " : "o"
