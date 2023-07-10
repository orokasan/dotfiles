call ddc#custom#patch_global('ui', 'native')
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
\ 'converters': ['converter_fuzzy']
\ },
\ 'skkeleton': {'mark': 'skk', 'matchers': ['skkeleton'], 'sorters': [], 'isVolatile': v:true, },
\ })
call ddc#custom#patch_global('sourceOptions', {
\ 'nvim-lsp': {
\   'mark': 'lsp',
\   'forceCompletionPattern': '\.\w*|:\w*|->\w*' },
\ })

call ddc#custom#patch_global('sourceParams', #{
      \   nvim-lsp: #{
      \     snippetEngine: denops#callback#register({
      \           body -> vsnip#anonymous(body)
      \     }),
      \ enableResolveItem: v:true,
      \ confirmBehavior: "insert"
      \   }
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
call pum#set_option({
\ 'use_complete': v:true,
\ 'scrollbar_char': '|',
\ 'highlight_scrollbar': 'Title',
\ 'highlight_selected': 'PmenuSelected',
\ 'item_orders': ['abbr', 'kind', 'menu', 'info']
\ })

if has('nvim')
call ddc#custom#patch_global('sources', [
\ 'skkeleton',
\ 'nvim-lsp',
\ 'vsnip',
\ 'around',
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

inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>

function! s:my_cr_function() abort "{{{
return pum#visible()  ? "\<CR>": lexima#expand('<CR>', 'i')
endfunction

" inoremap <silent> <BS> <C-r>=<SID>my_bs_function()<CR>
" inoremap <silent> <C-h> <C-r>=<SID>my_bs_function()<CR>

" function! s:my_bs_function() abort "{{{
" return lexima#expand('<BS>', 'i')
" endfunction "}}}
" <TAB>: completion.
imap <expr> <C-k>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-k>'
smap <expr> <C-k>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-k>'
" inoremap <silent><expr> <TAB> pum#visible() ? pum#map#insert_relative(+1) ): lexima#expand('<TAB>', 'i')
" inoremap <silent><expr> <S-TAB> pum#visible()  ? pum#map#insert_relative(-1) : "\<BS>"
snoremap <silent><expr> <TAB> pum#visible() ?
\ vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : pum#map#insert_relative(+1) : lexima#expand('<TAB>', 'i')
snoremap <silent><expr> <S-TAB>
\ pum#visible()  ?  vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : pum#map#insert_relative(-1) : "\<BS>"

inoremap <silent> <C-n> <Cmd>call <SID>my_pum_select('below', 0)<CR>
inoremap <silent> <C-p> <Cmd>call <SID>my_pum_select('above', 0)<CR>
inoremap <silent> <tab> <Cmd>call <SID>my_pum_select('below', 1)<CR>
inoremap <silent> <S-tab> <Cmd>call <SID>my_pum_select('above', 1)<CR>
function! s:my_pum_select(direction, tab) abort
if pum#visible()
  call pum#map#insert_relative(a:direction ==# 'below' ? +1 : -1)
else
  if a:tab
    call lexima#expand('<TAB>', 'i')
  endif
  if a:direction ==# 'below'
    call ddc#map#manual_complete()
  endif
endif
endfunction
" inoremap <C-n> <Cmd>call pum#map#insert_relative(+1)<CR>
" inoremap <silent><expr> <C-p> pum#map#insert_relative(-1)
inoremap <C-y>   <Cmd>call pum#map#cancel()<CR>
call pum#set_option({
\ 'padding': v:false,
\ 'reversed': v:false,
\ })

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

let g:popup_preview_config = { "border": v:false ,
	      \ 'maxWidth': 60,
	      \ 'maxHeight': 30,
	      \ }
" call popup_preview#enable()
	" Use cmdline source.
	call ddc#custom#patch_global('autoCompleteEvents', [
	\ 'InsertEnter', 'TextChangedI', 'TextChangedP', 'CmdlineChanged'])
	nnoremap :       <Cmd>call CommandlinePre()<CR>:
	nnoremap /       <Cmd>call CommandlinePre()<CR>/
	nnoremap ?       <Cmd>call CommandlinePre()<CR>?
	nnoremap g/    <Cmd>call CommandlineUnmap()<CR>
  function! CommandlineUnmap() abort
    nunmap :
    nunmap /
    nunmap ?
  endfunction
	
	function! CommandlinePre() abort
call ddc#custom#patch_global('ui', 'pum')
cnoremap <silent><expr> <TAB> pum#visible() ? pum#map#insert_relative(+1) : ddc#map#manual_complete()
cnoremap <silent><expr> <S-TAB> pum#visible() ? pum#map#insert_relative(-1) : ddc#map#manual_complete()
cnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
  call pum#set_option({
  \ 'padding': v:false,
  \ 'reversed': v:false,
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
	\     'mark': '',
    \   'forceCompletionPattern': '\S[\\/]\S*|^e\s+',
	\   }
	\ })
" call signature_help#enable()
call ddc#enable()

au User DenopsStarted call Restore_ddc_config()

let s:backup = ddc#custom#get_global()
function! Restore_ddc_config()
  call ddc#custom#patch_global(s:backup)
endfunction
" autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)
