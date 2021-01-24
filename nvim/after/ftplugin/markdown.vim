" if has('conceal')
"     setlocal conceallevel=0
" endif
inoremap <buffer><silent><expr> <C-d> getcurpos()[2] ==# 1 ? "* " :
    \ match(getline('.'), '^\*\s') >=0 ? "<C-u>" : "\<C-d>"
nnoremap <buffer><silent><expr> o match(getline('.'), '\*\s') >=0 ? "o* " : "o"
