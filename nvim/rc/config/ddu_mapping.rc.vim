function! s:ddu_mapping() abort
  nnoremap <silent> sn <cmd>Ddu
      \ -name=default
      \ mr<CR>
  nnoremap <silent> sr <cmd>Ddu
      \ -resume
      \ -ui-param-startFilter=v:false<CR>
  nnoremap <silent> sh <cmd>Ddu
      \ -name=default
      \ help -ui-param-startFilter=v:true<CR>
  nnoremap <silent> sN <cmd>Ddu
      \ -name=default
      \ mr -source-param-kind='mrw'<CR>
  nnoremap <silent> sb <cmd>Ddu
      \ -name=select
      \ buffer<CR>
  nnoremap <silent> sd <cmd>Ddu
      \ -ui-param-split=floating
      \ -ui-param-autoResize
      \ jump<CR>
  nnoremap <silent> ss <cmd>call ddu#start({'sources': [{'name': 'file', 'options': {'path': expand('%:p:h')}}]})<CR>
  nnoremap <silent> <Leader>s <cmd>call ddu#start({'sources': [{'name': 'file', 'options': {'path': expand('%:p:h')}}], 'searchPath': expand('%:p')})<CR>
  nnoremap <silent> sS <cmd>call ddu#start({'sources': [{'name': 'file', 'options': {'path': getcwd()}}]})<CR>
  nnoremap <silent> s/ <cmd>Ddu
      \ searchres<CR>
  nnoremap <silent> sy <cmd>Ddu
      \ -name=word
      \ -name=float
      \ miniyank<CR>

  nnoremap <silent> se <cmd>Ddu
      \ -name=word
      \ -ui-param-split=floating
      \ -source-option-path=`expand('~/GoogleDrive/SD/work/template/editor_symbols.txt')`
      \ word_line<CR>

  nnoremap <silent> sg <cmd>call ddu#start({'sources': [{'name': 'grep', 'params': {'path': <SID>find_gitdir(),'input': input('Pattern: ')}}]})<CR>
  " nnoremap <silent> sg <cmd>call ddu#start({'sources': [{'name': 'jvgrep', 'params': {'path': <SID>find_gitdir(),'input': input('Pattern: ')}}]})<CR>
  nnoremap <silent> s* <cmd>call ddu#start({'sources': [{'name': 'grep', 'params': {'path': <SID>find_gitdir(),'input': expand('<cword>')}}]})<CR>
  nnoremap <silent> sG <cmd>call ddu#start({'sources': [{'name': 'grep', 'params': {'path': getcwd(),'input': input('Pattern: ')}}]})<CR>
  " nnoremap <silent> sG <cmd>call ddu#start({'sources': [{'name': 'grep_all', 'params': {'input': input('Pattern: ')}}]})<CR>
  nnoremap <silent> sf <cmd>call ddu#start({'sources': [{'name': 'file_external', 'options': {'path': <SID>find_gitdir()}}]})<CR>
  nnoremap <silent> sF <cmd>call ddu#start({'sources': [{'name': 'file_external', 'options': {'path': getcwd()}}]})<CR>
  nnoremap <silent> sp <cmd>call ddu#start({'name': 'default', 'sources': [{'name': 'file', 'options': {'path': expand(input('Input target path: '),'%:p:h')}, 'params':{}}]})<CR>
  nnoremap <silent> sj <cmd>Ddu dirmark<CR>
  nnoremap <silent> s- <cmd>Ddu -ui-param-startFilter=v:true dein<CR>
  nnoremap <silent> s_ <cmd>Ddu dein_update<CR>

  nnoremap <silent> sv <cmd>Ddu junkfile -name=prev -ui-param-cursorPos=1<CR>
  nnoremap <silent> sV <cmd>call ddu#start({'sources': [{'name': 'grep', 'params': {'path': expand('~/.cache/junkfile/' .. strftime('%Y')),'input': input('Pattern: ')}}]})<CR>

  nnoremap <silent> sc <cmd>call ddu#start({'sources': [{'name': 'lsp_codeAction'}]})<CR>
  nnoremap <silent> sC <cmd>call ddu#start({'name':'prev', 'sources': [{'name': 'lsp_references'},{'name': 'lsp_definition'},{'name': 'lsp_documentSymbol'},{'name': 'lsp_typeHierarchy'},{'name': 'lsp_callHierarchy'},{'name': 'lsp_codeAction'}]})<CR>
  nnoremap <silent> sk <cmd>call ddu#start({'sources': [{'name': 'lsp_diagnostic', 'params':{'buffer': 0}}]})<CR>
  autocmd dein FileType txt,markdown nnoremap <silent><buffer> sk <cmd>Ddu -name=textlint textlint<CR>

  nnoremap <silent> <Leader>e <cmd>call ddu#start({'ui': 'filer', 'sources': [{'name': 'file', 'options': {'path': expand('%:p:h')}}], 'searchPath': expand('%:p')})<CR>
  nnoremap <silent> <space>E <cmd>call ddu#start({'name': 'filer', 'sources': [{'name': 'file', 'options': {'path': expand(input('Input target path: '),'%:p:h')}}]})<CR>
  " nnoremap <silent> <space>e <cmd>Ddu -name=filer -path=`expand('%:h:p')` file<CR>
  nnoremap <silent> st <cmd> call ddu#start({'name': 'tree',  'options':{'searchPath': ''}, 'sources': [{'name': 'text'}],'resume': v:true, 'refresh':v:true}})<CR>

  nnoremap <silent> <C-e> <cmd> call ddu#start({'name': 'filer', 'resume': v:true})<CR>

  inoremap <C-q> <Cmd>call ddu#start(#{
  \   name: 'file',
  \   ui: 'ff',
  \   input: matchstr(getline('.')[: col('.') - 1], '\f*$'),
  \   sources: [
  \     #{ name: 'file', options: #{ defaultAction: 'feedkeys' } },
  \   ],
  \   uiParams: #{
  \     ff: #{
  \       startFilter: v:true,
  \       replaceCol: match(getline('.')[: col('.') - 1], '\f*$') + 1,
  \     },
  \   },
  \ })<CR>

endfunction

function! s:find_gitdir() abort
  if finddir('.git', '.;') != ''
    let path = (empty(bufname('%')) || &buftype =~# '^\%(nofile\|acwrite\|quickfix\|terminal\)$') ? getcwd() : expand('%:p')
    let dir = finddir('.git', path.';')
    if empty(dir) | return '' | endif
    let files = findfile('.git', path.';',-1)
    if empty(files) | return fnamemodify(dir, ':p:h:h') | endif
    let path = fnamemodify(files[-1], ':p:h')
  else
    let path = expand('%:p:h')
    return path
  endif
endfunction
nnoremap <silent> sl :Ddu
    \ -name=file
    \ file_external<CR>
nnoremap <silent> sH :Ddu
    \ -name=default
    \ help<CR>

call s:ddu_mapping()

