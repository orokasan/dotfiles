call ddc#custom#patch_global('ui', 'pum')
" call ddc#custom#patch_global('ui', 'inline')
" inoremap <expr><C-t>       ddc#map#insert_item(0, "\<C-e>")
call ddc#custom#patch_global({
\ 'backspaceCompletion': v:true,
\})
call ddc#custom#patch_global('sourceOptions', {
\ '_': {
\ 'matchers': ['matcher_fuzzy'],
\     'sorters': ['sorter_fuzzy'],
\ 'ignoreCase': v:true,
\ 'converters': ['converter_remove_overlap']
\ },
\ 'skkeleton': {'mark': 'skk', 'matchers': [], 'sorters': [], 'isVolatile': v:true,'minAutoCompleteLength' :1},
\ 'vsnip': {'matchers': ['matcher_head'], 'minAutoCompleteLength' :2},
\ })

call ddc#custom#patch_global(#{
      \ sourceOptions: #{
      \   lsp: #{
      \     dup: 'keep',
      \     keywordPattern: '\k+',
      \   },
      \ },
      \ sourceParams: #{
      \   lsp: #{
      \     snippetEngine: denops#callback#register({
      \           body -> vsnip#anonymous(body)
      \     }),
      \     enableResolveItem: v:true,
      \     enableAdditionalTextEdit: v:true,
      \     confirmBehavior: 'replace',
      \   }
    \ }})
" Change source options
call ddc#custom#patch_global('sourceOptions', {
\ 'around': {'mark': 'A'},
\ 'buffer': {'mark': 'B'},
\ 'vsnip': {'dup': 'keep'}
\ })

call ddc#custom#patch_global('sourceParams', {
\ 'buffer': {'requireSameFiletype': v:false,
\ 'fromAltBuf': v:true,
\ 'bufNameStyle': 'basename'},
\ })
call ddc#custom#patch_global('sourceParams', {
\ 'around': {'maxSize': 500},
\ })

" Customize settings on a filetype
call pum#set_option({
\ 'use_setline': v:false,
\ 'scrollbar_char': '|',
\ 'highlight_scrollbar': 'Title',
\ 'highlight_selected': 'PmenuSelected',
\ 'item_orders': ['abbr', 'space', 'kind', 'space', 'menu', 'info']
\ })

if has('nvim')
call ddc#custom#patch_global('sources', [
\ 'vsnip',
\ 'lsp',
\ 'buffer',
\ ])
else
call ddc#custom#patch_global('sources', [
\ 'buffer',
\ 'around',
\ ])
endif

" autocmd dein User skkeleton-enable-pre call s:skkeleton_pre()
" function! s:skkeleton_pre() abort
"   " Overwrite sources
"   let s:prev_buffer_config = ddc#custom#get_buffer()
"   call ddc#custom#patch_buffer('sources', ['skkeleton'])
" endfunction
" autocmd User dein skkeleton-disable-pre call s:skkeleton_post()
" function! s:skkeleton_post() abort
"   " Restore sources
"   call ddc#custom#set_buffer(s:prev_buffer_config)
" endfunction

inoremap <silent><expr> <CR> <SID>my_cr_function()

function! s:my_cr_function() abort "{{{
  return pum#visible() ? pum#map#confirm() : "\<CR>"
endfunction

" inoremap <silent> <BS> <C-r>=<SID>my_bs_function()<CR>
" inoremap <silent> <C-h> <C-r>=<SID>my_bs_function()<CR>

" function! s:my_bs_function() abort "{{{
" return lexima#expand('<BS>', 'i')
" endfunction "}}}
" <TAB>: completion.
imap <expr> <C-k>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-k>'
smap <expr> <C-k>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-k>'
snoremap <silent><expr> <TAB> pum#visible() ?
\ vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : pum#map#insert_relative(+1) : lexima#expand('<TAB>', 'i')
snoremap <silent><expr> <S-TAB>
\ pum#visible()  ?  vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : pum#map#insert_relative(-1) : "\<BS>"

" inoremap <silent><expr> <TAB> pum#visible() ? '<Cmd> call pum#map#insert_relative(+1)<CR>' : '<TAB>'
" inoremap <silent><expr> <S-TAB> pum#visible() ? '<Cmd> call pum#map#insert_relative(-1)<CR>' : '<S-TAB>'
inoremap <silent><expr> <C-n> pum#visible() ? '<Cmd> call pum#map#insert_relative(+1)<CR>' : '<C-n>'
inoremap <silent><expr> <C-p> pum#visible() ? '<Cmd> call pum#map#insert_relative(-1)<CR>' : '<C-p>'

inoremap <C-n>   <Cmd>call pum#map#insert_relative(+1)<CR>
inoremap <C-p>   <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
inoremap <C-e>   <Cmd>call pum#map#cancel()<CR>

call pum#set_option({
\ 'min_width': 30,
\ 'padding': v:true,
\ 'reversed': v:false,
\ })

" au User PumClose if pum#entered() | echom 'opened' | doautocmd CompleteDone  | endif

call ddc#custom#patch_global('filterParams', {
\ 'converter_truncate': {
    \ 'maxMenuWidth': 35,
  \ 'maxAbbrWidth': 60,
    \ },
\   'matcher_fuzzy': {
\     'splitMode': 'character'
\   }
\ })
call ddc#custom#patch_global('sourceOptions', {
    \ 'file': {
    \   'mark': 'F',
    \   'isVolatile': v:true,
    \   'forceCompletionPattern': '\S/\S*',
    \ }})
call ddc#custom#patch_filetype(
    \ ['ps1', 'dosbatch', 'autohotkey', 'registry'], {
    \ 'sourceOptions': {
    \   'file': {
    \     'forceCompletionPattern': '\S\\\S*',
    \   },
    \ },
    \ 'sourceParams': {
    \   'file': {
    \     'mode': 'win32',
    \   },
    \ }})
call ddc#custom#patch_global('sourceParams', {
\ 'file': {
\   'trailingSlashAbbr': v:true,
\ }})
call ddc#custom#patch_filetype(
\['ddu-ff-filter'],
\{'sources':[]})
call ddc#custom#patch_filetype(
\['vim', 'toml'],
\{'sources': ['necovim', 'lsp', 'buffer']}
\)

let g:popup_preview_config = { "border": v:false ,
	      \ 'maxWidth': 60,
	      \ 'maxHeight': 30,
	      \ }
" call popup_preview#enable()
	" Use cmdline source.
	" call ddc#custom#patch_global('autoCompleteEvents', [
	" \ 'InsertEnter', 'TextChangedI', 'TextChangedP', 'CmdlineChanged'])
	" nnoremap :       <Cmd>call CommandlinePre()<CR>:
	" nnoremap /       <Cmd>call CommandlinePre()<CR>/
	" nnoremap ?       <Cmd>call CommandlinePre()<CR>?
	" nnoremap g/    <Cmd>call CommandlineUnmap()<CR>
  " function! CommandlineUnmap() abort
    " nunmap :
    " nunmap /
    " nunmap ?
  " endfunction
	
	" function! CommandlinePre() abort
" call ddc#custom#patch_global('ui', 'pum')
" cnoremap <silent><expr> <TAB> pum#visible() ? pum#map#insert_relative(+1) : ddc#map#manual_complete()
" cnoremap <silent><expr> <S-TAB> pum#visible() ? pum#map#insert_relative(-1) : ddc#map#manual_complete()
" cnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
  " call pum#set_option({
  " \ 'padding': v:false,
  " \ 'reversed': v:true,
  " \ })
	"   " Overwrite sources
	"   if !exists('b:prev_buffer_config')
	"     let b:prev_buffer_config = ddc#custom#get_buffer()
	"   endif
	"   call ddc#custom#patch_buffer('cmdlineSources',
	"   \ ['cmdline'])
    " call ddc#custom#patch_buffer('sourceOptions',{
    " \ '_': {
        " \ 'minAutoCompleteLength': 1,
        " \ 'sorters': ['sorter_fuzzy'],
        " \ 'converters': ['converter_fuzzy'],
        " \}
	"   \} )
	
	"   autocmd User DDCCmdlineLeave ++once call CommandlinePost()
	"   autocmd InsertEnter <buffer> ++once call CommandlinePost()
	
	"   " Enable command line completion
	"   call ddc#enable_cmdline_completion()
	" endfunction

	" function! CommandlinePost() abort
	"   silent! cunmap <Tab>
	"   silent! cunmap <S-Tab>
	"   silent! cunmap <C-y>
	"   silent! cunmap <C-e>
  " call pum#set_option({
  " \ 'padding': v:false,
  " \ 'reversed': v:false,
  " \ })
	
	"   " Restore sources
	"   if exists('b:prev_buffer_config')
	"     call ddc#custom#set_buffer(b:prev_buffer_config)
	"     unlet b:prev_buffer_config
	"   else
	"     call ddc#custom#set_buffer({})
	"   endif
	" endfunction
	
	" Change source options
	call ddc#custom#patch_global('sourceOptions', {
	\   'cmdline': {
	\     'mark': '',
    \   'forceCompletionPattern': '\S[\\/]\S*|^e\s+',
	\   }
	\ })
" call signature_help#enable()
call ddc#enable()


" let s:backup = ddc#custom#get_global()
" function! Restore_ddc_config()
"   call ddc#custom#patch_global(s:backup)
" endfunction
