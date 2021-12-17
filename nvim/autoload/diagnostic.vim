function! diagnostic#get_diagnostic(bufnr) abort
lua <<EOF
tbl = vim.diagnostic.get(a:bufnr)
for key, val in pairs(tbl) do
vim.sval.range.start.line)
print(val.message)
end
EOF
" let result = luaeval('vim.lsp.diagnostic.get_all()')
" echo result
endfunction
