function! s:startfilter()
  let chars = ''
  while v:true
    let chars ..= getcharstr(0)
    sleep 1m
    if exists('w:ddu_ui_ff_status') && get(w:ddu_ui_ff_status, 'done', v:false)
      break
    endif
  endwhile
  call feedkeys("\<Cmd>call ddu#ui#sync_action('openFilterWindow')\<CR>" .. chars, 'it')
endfunction
" autocmd User Ddu:uiDone ++nested call ddu#ui#async_action('openFilterWindow')

function! s:ddu_mapping() abort
  nnoremap <silent> sn <cmd>Ddu
      \ -name=default
      \ mr<CR>
  nnoremap <silent> sr <cmd>Ddu
      \ -resume<CR>
  nnoremap <silent> sh <cmd>Ddu
      \ -name=default
      \ help
      \ \| call <SID>startfilter()<CR>
  nnoremap <silent> s- <cmd>Ddu
      \ -name=default
      \ dein
      \ \| call <SID>startfilter()<CR>
  nnoremap <silent> sN <cmd>Ddu
      \ -name=default
      \ mr -source-param-kind='mrw'<CR>
  nnoremap <silent> sb <cmd>Ddu
      \ -name=default
      \ buffer<CR>
  nnoremap <silent> - <cmd>Ddu
      \ -name=side
      \ -input=
      \ aerial<CR>
  " nnoremap <silent> sd <cmd>Ddu
  "     \ -ui-param-ff-split=floating
  "     \ -ui-param-ff-autoResize
  "     \ jump<CR>
  if exists('*isabsolutepath')
  nnoremap <silent> ss <cmd>call ddu#start({'sources': [{'name': 'file', 'options': {'path': isabsolutepath(expand('%:p:h')) ? expand('%:p:h') : expand('~') }}],'sync': v:false})<CR>
  else
  nnoremap <silent> ss <cmd>call ddu#start({'sources': [{'name': 'file', 'options': {'path': expand('%:p:h') }}],'sync': v:false})<CR>
  endif
  nnoremap <silent> <Leader>s <cmd>call ddu#start({'sources': [{'name': 'file', 'options': {'path': expand('%:p:h')}}], 'searchPath': expand('%:p')})<CR>
  nnoremap <silent> sS <cmd>call ddu#start({'sources': [{'name': 'file', 'options': {'path': getcwd()}}]})<CR>
  nnoremap <silent> s/ <cmd>Ddu
      \ -resume
      \ -refresh
      \ -ui-option-ff-persist
      \ -ui-option-ff-restoreCursor
      \ searchres<CR>
  nnoremap <silent> sy <cmd>Ddu
      \ -name=word
      \ -name=float
      \ yank-history<CR>
  nnoremap <silent> sl <cmd>Ddu
      \ ddu_history<CR>

    nnoremap <silent> sL <cmd>call ddu#start({'sync': v:true, 'sources': [{'name': 'ddu_history'}], 'uiParams': {'ff': {'startAutoAction': v:true,'cursorPos': -1, 'autoAction': {'name': 'itemAction','param':{'name': 'start'}}}}})<CR>
  nnoremap <silent> se <cmd>Ddu
      \ -name=word
      \ -ui-param-ff-split=floating
      \ -source-option-path=`expand('~/GoogleDrive/SD/work/template/editor_symbols.txt')`
      \ word_line<CR>

  nnoremap <silent> sd <Cmd>call ddu#start(#{sources: [#{name: 'himalaya', }], resume: v:true, name: 'mail'})<CR>
  " nnoremap <silent> sd <Cmd>call ddu#start(#{sources: [#{name: 'himalaya', }], resume: v:true, name: 'mail'})\|call ddu#redraw('mail', {'input': '', 'method': 'refreshItems' })<CR>
  nnoremap <silent> sD <Cmd>call ddu#start(#{sources: [#{name: 'himalaya', }], sync: v:true, resume: v:false, name: 'mail' })<CR>
  " nnoremap <silent> g/ <Cmd>call ddu#start(#{sources: [#{name: 'himalaya', params: #{args: [ input('query: ')], folder: "[Gmail]/すべてのメール", page:100} }], name: 'mail'})<CR>
  nnoremap <silent> g/ <Cmd>call ddu#start(#{sources: [#{name: 'himalaya', params: #{ folder: "[Gmail]/送信済みメール", page:100} }], name: 'mail'})<CR>
  nnoremap <silent> sg <cmd>call ddu#start({'sources': [{'name': 'grep', 'params': {'path': <SID>find_gitdir(),'input': input('Pattern: ')}}]})<CR>
  " nnoremap <silent> sg <cmd>call ddu#start({'sources': [{'name': 'jvgrep', 'params': {'path': <SID>find_gitdir(),'input': input('Pattern: ')}}]})<CR>
  nnoremap <silent> s* <cmd>call ddu#start({'sources': [{'name': 'grep', 'params': {'path': <SID>find_gitdir(),'input': expand('<cword>')}}]})<CR>
  nnoremap <silent> sG <cmd>call ddu#start({'sources': [{'name': 'grep', 'params': {'path': getcwd(),'input': input('Pattern: ')}}]})<CR>
  " nnoremap <silent> sG <cmd>call ddu#start({'sources': [{'name': 'grep_all', 'params': {'input': input('Pattern: ')}}]})<CR>
  nnoremap <silent> sf <cmd>call ddu#start({'sources': [{'name': 'file_external', 'options': {'path': <SID>find_gitdir()}}]})<CR>
  nnoremap <silent> sF <cmd>call ddu#start({'sources': [{'name': 'file_external', 'options': {'path': getcwd()}}]})\|call <SID>startfilter()<CR>
  nnoremap <silent> sp <cmd>call ddu#start({'name': 'default', 'sources': [{'name': 'file', 'options': {'path': expand(input('Input target path: '),'%:p:h')}, 'params':{}}]})<CR>
  nnoremap <silent> sj <cmd>Ddu dirmark<CR>
  nnoremap <silent> sm <cmd>call ddu#start({'sources': [{'name': 'dirmark', 'params': {'group': 'temp'}}]})<CR>
  nnoremap <silent> s_ <cmd>Ddu dein_update<CR>

  nnoremap <silent> sv <cmd>call ddu#start({'sources': [{'name': 'tree', 'options': {'path': expand(g:junkfile#directory)}}], 'name': 'prev'})<CR>
  nnoremap <silent> sV <cmd>call ddu#start({'sources': [{'name': 'grep', 'params': {'path': expand('~/.cache/junkfile/' .. strftime('%Y')),'input': input('Pattern: ')}}]})<CR>

  nnoremap <silent> sc <cmd>call ddu#start({'sources': [{'name': 'lsp_codeAction'}]})<CR>
  nnoremap <silent> sC <cmd>call ddu#start({'name':'prev', 'sources': [{'name': 'lsp_references'},{'name': 'lsp_definition'},{'name': 'lsp_documentSymbol'},{'name': 'lsp_typeHierarchy'},{'name': 'lsp_callHierarchy'},{'name': 'lsp_codeAction'}]})<CR>
  nnoremap <silent> sk <cmd>call ddu#start({'sources': [{'name': 'lsp_diagnostic', 'params':{'buffer': 0}}]})\|set splitkeep=cursor<CR>
augroup dduconf
  au!
  autocmd FileType txt,markdown nnoremap <silent><buffer> sk <cmd>Ddu -name=textlint textlint<CR>
  augroup END
  nnoremap <silent> <Leader>e <cmd>call ddu#start({'name': 'filer', 'sources': [{'name': 'file', 'options': {'path': expand('%:p:h')}}], 'searchPath': expand('%:p')})<CR>
  nnoremap <silent> <space>E <cmd>call ddu#start({'name': 'filer', 'sources': [{'name': 'file', 'options': {'path': expand(input('Input target path: '),'%:p:h')}}]})<CR>
  " nnoremap <silent> <space>e <cmd>Ddu -name=filer -path=`expand('%:h:p')` file<CR>
  nnoremap <silent> st <cmd> call ddu#start({'name': 'tree',  'options':{'searchPath': ''}, 'sources': [{'name': 'text'}],'resume': v:true, 'refresh':v:true}})<CR>
  nnoremap <silent> <C-e> <cmd> if ddu#ui#visible('filer') \| call execute(['wincmd',  win_id2win(ddu#ui#winids('filer')[0]),  'w']->join(' ')) \| else \|
  \ call ddu#start({'name': 'filer', 'sources': [{'name': 'file'}]}) \| endif<CR>

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

