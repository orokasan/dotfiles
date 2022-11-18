call ddc#custom#patch_global('ui', 'pum')
call ddc#custom#patch_global({
\ 'backspaceCompletion': v:true,
\})
call ddc#custom#patch_global('sourceOptions', {
\ '_': {
\ 'matchers': ['matcher_fuzzy'],
\     'sorters': ['sorter_fuzzy'],
\ 'ignoreCase': v:true,
\ 'converters': ['converter_fuzzy']
\ },
\ 'skkeleton': {'mark': 'skk', 'matchers': ['skkeleton'], 'sorters': [], 'isVolatile': v:true, 'autoCompleteDelay': 0},
\ })
call ddc#custom#patch_global('sourceOptions', {
\ 'nvim-lsp': {
\   'mark': 'lsp',
\   'forceCompletionPattern': '\.\w*|:\w*|->\w*' },
\ })
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

if has('nvim')
call ddc#custom#patch_global('sources', [
\ 'nvim-lsp',
\ 'vsnip',
\ 'buffer',
\ 'around',
\ 'file',
\ ])
else
call ddc#custom#patch_global('sources', [
\ 'file',
\ 'buffer',
\ 'around',
\ ])
endif
autocmd dein User skkeleton-enable-pre call s:skkeleton_pre()
function! s:skkeleton_pre() abort
  " Overwrite sources
  let s:prev_buffer_config = ddc#custom#get_buffer()
  call ddc#custom#patch_buffer('sources', ['skkeleton'])
endfunction
autocmd User dein skkeleton-disable-pre call s:skkeleton_post()
function! s:skkeleton_post() abort
  " Restore sources
  call ddc#custom#set_buffer(s:prev_buffer_config)
endfunction

inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>

function! s:my_cr_function() abort "{{{
return pum#visible()  ? "\<CR>": lexima#expand('<CR>', 'i')
endfunction

inoremap <silent> <BS> <C-r>=<SID>my_bs_function()<CR>
inoremap <silent> <C-h> <C-r>=<SID>my_bs_function()<CR>

function! s:my_bs_function() abort "{{{
return lexima#expand('<BS>', 'i')
endfunction "}}}

" <TAB>: completion.
imap <expr> <C-k>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-k>'
smap <expr> <C-k>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-k>'
inoremap <silent><expr> <TAB> pum#visible() ?
\ (vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : pum#map#insert_relative(+1) ): lexima#expand('<TAB>', 'i')
inoremap <silent><expr> <S-TAB>
\ pum#visible()  ?  vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : pum#map#insert_relative(-1) : "\<BS>"
snoremap <silent><expr> <TAB> pum#visible() ? 
\ vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : pum#map#insert_relative(+1) : lexima#expand('<TAB>', 'i')
snoremap <silent><expr> <S-TAB>
\ pum#visible()  ?  vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : pum#map#insert_relative(-1) : "\<BS>"

inoremap <silent><expr> <C-n> pum#visible() ? pum#map#insert_relative(+1) : ddc#map#manual_complete()
inoremap <C-p>   <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
inoremap <C-e>   <Cmd>call pum#map#cancel()<CR>

call pum#set_option({
\ 'padding': v:false,
\ 'reversed': v:false,
\ })

call ddc#custom#patch_global('filterParams', {
\ 'converter_truncate': {'maxMenuWidth': 35},
\   'matcher_fuzzy': {
\     'splitMode': 'character'
\   }
\ })
call ddc#custom#patch_global('sourceOptions', {
\ 'vsnip': {
\   'minAutoCompleteLength': 2
\}
\})
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

" 
" let g:vsnip_filetypes.deno = ['typescript']
" let g:vsnip_snippet_dir = expand('~/GoogleDrive/config/.vsnip')
let g:popup_preview_config = { "border": v:false ,
	      \ 'maxWidth': 60,
	      \ 'maxHeight': 30,
	      \ }
" call popup_preview#enable()
	" Use cmdline source.
	call ddc#custom#patch_global('ui', 'pum')
	call ddc#custom#patch_global('autoCompleteEvents', [
	\ 'InsertEnter', 'TextChangedI', 'TextChangedP', 'CmdlineChanged'])
	nnoremap :       <Cmd>call CommandlinePre()<CR>:
	nnoremap /       <Cmd>call CommandlinePre()<CR>/
	nnoremap ?       <Cmd>call CommandlinePre()<CR>?
	
	function! CommandlinePre() abort
	  " cnoremap <C-n>   <Cmd>call pum#map#insert_relative(-1)<CR>
cnoremap <silent><expr> <TAB> pum#visible() ? pum#map#insert_relative(+1) : ddc#map#manual_complete()
cnoremap <silent><expr> <S-TAB> pum#visible() ? pum#map#insert_relative(-1) : ddc#map#manual_complete()
	  cnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
	  cnoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
  call pum#set_option({
  \ 'padding': v:false,
  \ 'reversed': v:true,
  \ })
	
	  " Overwrite sources
	  if !exists('b:prev_buffer_config')
	    let b:prev_buffer_config = ddc#custom#get_buffer()
	  endif
	  call ddc#custom#patch_buffer('cmdlineSources',
	  \ ['cmdline'])
    call ddc#custom#patch_buffer('sourceOptions',{
    \ '_': {
        \ 'minAutoCompleteLength': 1,
        \ 'sorters': ['sorter_fuzzy'],
        \ 'converters': ['converter_fuzzy'],
        \}
	  \} )
	
	  autocmd User DDCCmdlineLeave ++once call CommandlinePost()
	  autocmd InsertEnter <buffer> ++once call CommandlinePost()
	
	  " Enable command line completion
	  call ddc#enable_cmdline_completion()
	endfunction

	function! CommandlinePost() abort
	  silent! cunmap <Tab>
	  silent! cunmap <S-Tab>
	  silent! cunmap <C-n>
	  silent! cunmap <C-p>
	  silent! cunmap <C-y>
	  silent! cunmap <C-e>
  call pum#set_option({
  \ 'padding': v:false,
  \ 'reversed': v:false,
  \ })
	
	  " Restore sources
	  if exists('b:prev_buffer_config')
	    call ddc#custom#set_buffer(b:prev_buffer_config)
	    unlet b:prev_buffer_config
	  else
	    call ddc#custom#set_buffer({})
	  endif
	endfunction
	
	" Change source options
	call ddc#custom#patch_global('sourceOptions', {
	\   'cmdline': {
	\     'mark': 'cmdline',
	\   }
	\ })
" call signature_help#enable()
call ddc#enable()
