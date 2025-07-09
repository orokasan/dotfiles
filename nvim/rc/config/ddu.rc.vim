function! s:ddu_change_to_filer(context)
  let action = a:context.items[0].action
  let config = {}
  let path = fnamemodify(action.path, ':p')
  if !isdirectory(path)
    let dir = fnamemodify(path, ':h:p')
  else
    let dir = path
  endif
  let config.name = 'filer'
  let config.uiParams = {'filer':{'search': path}}
  let config.sources = [{'name':'file','options':{'path': dir}}]
  echom config
  call ddu#start(config)
endfunction

function! s:ddu_change_to_ff(context)
  let action = a:context.items[0].action
  let config = {}
  let path = action.path
  if !isdirectory(path)
    let dir = fnamemodify(path, ':h:h')
  else
    let dir = fnamemodify(path, ':h')
  endif
  let dir = substitute(dir, ' ', '\\ ', 'g')
  let dir = substitute(dir, '\\', '/', 'g')
  let config.sources = [{'name':'file','options':{'path': dir},'params':{}}]
  let config.name = 'ff'
  call ddu#start(config)
endfunction

call ddu#custom#action('kind', 'file', 'to_filer',
    \  function('s:ddu_change_to_filer'))
call ddu#custom#action('kind', 'file', 'to_ff',
    \  function('s:ddu_change_to_ff'))

function! s:ddu_my_open(context) abort
  let action = a:context.items[0].action
  let config = ddu#custom#get_current(a:context.options.name)

  if !isdirectory(action.path)
    call ddu#ui#do_action('itemAction', {'name' : 'open'})
  elseif config.sources[0].name ==# 'file'
    call ddu#ui#do_action('itemAction', {'name' : 'narrow'})
    let key = nvim_replace_termcodes("<C-u>", v:true, v:false, v:true)
    call nvim_feedkeys(key, 'n', v:false)
  else
    call ddu#start({'sources':[{'name':'file', 'options':{'path': expand(action.path,':p')}}],
    \ 'ui': config.ui,
    \ })
    let key = nvim_replace_termcodes("<C-u>", v:true, v:false, v:true)
    call nvim_feedkeys(key, 'n', v:false)
  endif
  redraw
  return

endfunction

function! s:ddu_unzip(context) abort
  let action = a:context.items[0].action
  let config = ddu#custom#get_current(a:context.options.name)

  if fnamemodify(action.path, ':e') !=# 'zip'
    echo 'this is not zip file'
    return
  endif
  let dir = fnamemodify(action.path, ':p:r')
  if has('win32')
    call mkdir(dir)
    call system(['tar', '-xf', action.path, '-C', dir])
    call ddu#redraw(b:ddu_ui_name, {'method': 'refreshItems'})
  endif
  return
endfunction

call ddu#custom#action('kind', 'file', 'unzip',
    \  function('s:ddu_unzip'))

call ddu#custom#action('kind', 'file', 'my_open',
    \  function('s:ddu_my_open'))
call ddu#custom#action('kind', 'help', 'my_open',
    \  function('s:ddu_my_open'))

" Define cd action for "ddu-ui-filer"
call ddu#custom#patch_global(#{
    \   sourceOptions: #{
    \     path_history: #{
    \       defaultAction: 'uiCd',
    \     },
    \   }
    \ })
call ddu#custom#action('kind', 'file', 'uiCd',
    \ { args -> s:uiCdAction(args) })
function! s:uiCdAction(args)
  let path = a:args.items[0].action.path
  let directory = path->isdirectory() ? path : path->fnamemodify(':h')

  call ddu#ui#filer#do_action('itemAction',
          \ #{ name: 'narrow', params: #{ path: directory } })
endfunction

function! s:ddu_grep(context) abort
  let action = a:context.items[0].action
  let path = action.path
  if !isdirectory(path)
    let dir = fnamemodify(path, ':h')
  else
    let dir = path
  endif
  let input = input('Pattern: ')
  call ddu#ui#do_action('closeFilterWindow')
  call ddu#start({
      \ 'sources':[
      \ {'name':'grep',
      \ 'params': {'path': dir, 'input': input},
      \ 'options': {}}
      \ ],
      \ 'name':a:context.options.name
      \})
endfunction

call ddu#custom#action('kind', 'file', 'grep',
    \  function('s:ddu_grep'))

function! s:ddu_file_rec(context) abort
  " echom a:context
  let action = a:context.items[0].action
  if !isdirectory(action.path)
    return
  endif
  if &filetype =~# '\v(ddu-ff|ddu-ff-filter)'
      call ddu#start({'sources':[{'name':'file_external','options':{'path': expand(action.path,':p')}}]})
    return
  endif
  if &filetype ==# 'ddu-filer'
    call ddu#ui#filer#do_action('quit')
    call ddu#start({
        \ 'input': '',
        \ 'sources':[
        \ {'name':'file_external',
        \ 'options': {'path': action.path},'params': {} },
        \ ],
        \ 'uiParams':{
        \ 'ff': {
        \ }
        \ }
        \})
    return
  endif
endfunction

call ddu#custom#action('kind', 'file', 'file_rec',
    \  function('s:ddu_file_rec'))

function! s:ddu_directory_rec(context) abort
  " echom a:context
  let action = a:context.items[0].action
  if !isdirectory(action.path)
    return
  endif
  if &filetype =~# '\v(ddu-ff|ddu-ff-filter)'
      call ddu#start({'sources':[{'name':'directory_rec','options':{'path': expand(action.path,':p')}}]})
    return
  endif
endfunction

call ddu#custom#action('kind', 'file', 'directory_rec',
    \  function('s:ddu_directory_rec'))

function! s:ddu_get_context(context) abort
  let b:ddu_cursor_candidate = a:context
endfunction
call ddu#custom#action('kind', 'file', 'get_context',
    \  function('s:ddu_get_context'))

call ddu#custom#alias('default', 'source', 'jvgrep', 'grep' )
call ddu#custom#alias('default', 'source', 'grep_all', 'grep' )
call ddu#custom#patch_global(#{
    \ kindOptions: #{
    \   lsp: #{
    \     defaultAction: 'open',
    \   },
    \   lsp_codeAction: #{
    \     defaultAction: 'apply',
    \   },
    \ },
    \ sourceOptions: #{
    \   lsp_diagnostic: #{
    \     defaultAction: 'open',
    \   },
    \}
    \})
let s:ddu_winheight = 20

call ddu#custom#patch_global({
    \   'sourceParams' : {
    \     'markdown' : {
    \       'style': '',
    \       'chunkSize': 5,
    \       'limit': 1000,
    \     },
    \   },
    \ })

call ddu#custom#patch_global(#{
    \   filterParams: #{
    \     matcher_substring: #{
    \       highlightMatched: 'Title',
    \     },
    \   }
    \ })

call ddu#custom#patch_local( 'nocolumn',{
    \'ui': 'ff',
    \ 'sourceOptions': {
    \ '_': {
    \ 'columns':['icons'],
    \ },}
    \})
call ddu#custom#patch_local('prev', {
    \ 'ui': 'ff',
    \ 'uiParams': {
    \ 'ff': {
    \ 'startAutoAction': v:true,
    \ 'autoAction':{'name': 'preview', 'sync': v:false}
    \}
    \}})
call ddu#custom#patch_local('textlint', {
    \ 'ui': 'ff',
    \ 'sourceOptions': {
      \ 'textlint':{
      \ 'defaultAction': 'open'
    \ }},
    \ 'actionParams' :{
      \ 'open': {'command': 'drop'}},
    \   'actionOptions': {
    \     'open': {
    \       'quit': v:false,
    \     },
    \},
    \ 'uiParams': {
    \ 'ff': {
    \ 'split': 'vertical',
    \ 'splitDirection': 'belowright',
    \ 'startAutoAction': v:true,
    \ 'autoAction':{'name': 'itemAction','params': {'name': 'highlight'}}
    \}
    \}})
call ddu#custom#patch_local('float', {
    \ 'ui': 'ff',
    \ 'uiParams': {
    \ 'ff': {
    \ 'split': 'floating',
    \ 'winWidth': &columns - 10,
  \ 'winCol': 5,
    \}
    \}})

call ddu#custom#patch_local('ui-select', {
    \ 'ui': 'ff',
    \ 'uiParams': {
    \ 'ff': {
    \ 'split': 'floating',
    \}
    \}})
call ddu#custom#patch_global({
    \   'kindOptions': {
    \     'ui_select': {
    \       'defaultAction': 'select',
    \     },
    \   }
    \ })

function! s:make_preview_git(s)   abort
  " echom globpath(a:s, '.git')
  if isdirectory(a:s) && len(globpath(a:s, '.git/*'))
    return a:s
  else
    return ''
  endif
endfunction

function! s:ddu_ff_back() abort
  if !exists('w:ddu_ui_ff_status')
    return
  endif
  let item = ddu#ui#get_item()
  let path = get(item.action, "path", "")
  let parent = fnamemodify(path, ':h')
  if len(path) == 0 || len(w:ddu_ui_ff_status.input) > 0
    let key = nvim_replace_termcodes("<C-h>", v:true, v:false, v:true)
    call nvim_feedkeys(key, 'n', v:false)
  else
    call ddu#ui#sync_action('itemAction', {'name' : 'narrow', 'params': { 'path': '..'}})
  endif
  " let parentItem = ddu#ui#get_item()
  " call ddu#redraw(b:ddu_ui_name, {'searchPath': parentItem})
endfunction

function! MyDduWinbarInput()
  if &filetype =~# '^ddu'
  let input = exists('w:ddu_ui_ff_status') ? w:ddu_ui_ff_status.input : ''
      if len(input) > 0
          return '# ' . input
      else
          return '# '
      endif
    endif
endfunction

function! s:restore_spk()
if &filetype !~# '^ddu'
  if exists('s:save_splitkeep')
  let &splitkeep=s:save_splitkeep
  unlet s:save_splitkeep
  endif
endif
endfunction

function! s:ddu_my_settings() abort
  if has('nvim')
    setlocal winbar=
  endif
  setlocal cursorline
  let save_winhighlight=&winhighlight
  set winhighlight+=CursorLine:DduUnderlined
  setlocal signcolumn=no
  setlocal nonumber

  setlocal scrolloff=5
  nnoremap <silent><buffer><expr> j
      \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
      \ line('.') == 1 ? 'G' : 'k'
  nnoremap <buffer><silent> <CR>
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'default'})<CR>
  nnoremap <buffer><silent><nowait> S
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'open', 'params': { 'command': 'split'}})<CR>
  nnoremap <buffer><silent><nowait> V
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'open', 'params': {'command': 'vsplit'}})<CR>
  nnoremap <buffer><silent><nowait> <tab>
      \ <Cmd>call ddu#ui#do_action('inputAction')<CR>
  nnoremap <buffer><silent><nowait> T
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'open', 'params': {'command': 'tabedit'}})<CR>
  nnoremap <buffer><silent> a
      \ <Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>j
  nnoremap <buffer><silent> A
      \ <Cmd>call ddu#ui#do_action('toggleAllItems')<CR>
  nnoremap <buffer><silent> \
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'cd'})<CR>
  nnoremap <buffer> h
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'narrow', 'params': {'path': ".."}})<CR>
      " \ <Cmd>call <SID>ddu_ff_back()<CR>

  " nnoremap <buffer> h <Cmd>call ddu#ui#do_action('itemAction', {'name': 'narrow', 'params': {'path': ".."}})<CR>
  nnoremap <nowait><buffer><silent> m
      \ <Cmd>call ddu#ui#multi_actions([
      \ ['itemAction', {'name' : 'move'}],
      \ ['clearSelectAllItems']
      \ ])<CR>
  nnoremap <nowait><buffer><silent> C
      \ <Cmd>call ddu#ui#multi_actions([
      \ ['itemAction', {'name' : 'copy'}],
      \ ['clearSelectAllItems']
      \ ])<CR>
  nnoremap <buffer><silent> p
      \ <Cmd>call ddu#ui#do_action('toggleAutoAction', {'name': 'preview'})<CR>
	nnoremap <buffer> <C-p>
	      \ <Cmd>call ddu#ui#do_action('previewExecute',
	      \ #{ command: 'execute "normal! \<C-y>"' })<CR>
	nnoremap <buffer> <C-n>
	      \ <Cmd>call ddu#ui#do_action('previewExecute',
	      \ #{ command: 'execute "normal! \<C-e>"' })<CR>

  nnoremap <buffer><silent> x
        \ <Cmd>call <SID>ddu_execute_mapping()<CR>

  function! s:ddu_execute_mapping()
    if fnamemodify(ddu#ui#get_item().action.path, ':e') ==# 'zip'
       call ddu#ui#do_action('itemAction',{'name': 'unzip'})
    else
       call ddu#ui#do_action('itemAction',{'name': 'executeSystem'})
    endif
  endfunction

  nnoremap <buffer><silent> u
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'undo'})<CR>
  nnoremap <buffer> X
      \ <Cmd>call ddu#ui#multi_actions([
      \ ['itemAction', {'name': 'narrow', 'params': {'path': ".."}}],
      \ ['itemAction', {'name': 'executeSystem'}],
      \ ['itemAction', {'name': 'narrow'}]
      \ ])<CR>
  nnoremap <buffer><silent><nowait> m
      \ <Cmd>call ddu#ui#do_action('updateOptions',{'sourceOptions': {ddu#custom#get_current(b:ddu_ui_name).sources[0].name :{'matchers':['matcher_kensaku']}}})<CR>
  nnoremap <buffer><silent> l
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'default'})<CR>
  nnoremap <buffer><silent> <C-r>
  \ <cmd>call ddu#redraw(b:ddu_ui_name, {'method': 'refreshItems'})<CR>
  nnoremap <buffer><silent> <c-l>
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'default'})<CR>
  nnoremap <buffer><silent> e
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'to_filer'})<CR>
  nnoremap <buffer><silent> u
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'undo'})<CR>
  nnoremap <buffer><silent><nowait> r
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'file_rec'})<CR>
  nnoremap <buffer><silent><nowait> <C-g>
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'grep'})<CR>
  nnoremap <buffer><silent> <C-o> <NOP>
  nnoremap <buffer><silent> q
      \ <Cmd>call ddu#ui#do_action('quit')<CR>
  nnoremap <buffer><silent> i
      \ <Cmd>call ddu#ui#do_action('openFilterWindow')<CR>
  nnoremap <buffer> o
      \ <Cmd>call ddu#ui#do_action('expandItem',{'mode': 'toggle', 'maxLevel': 0})<CR>
  nnoremap <buffer> O
      \ <Cmd>call ddu#ui#do_action('expandItem',{ 'maxLevel': -1})<CR>
  nnoremap <buffer> c
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'copy'})<CR>
  nnoremap <buffer> D
      \ <Cmd>call ddu#ui#sync_action('itemAction', {'name': 'trash'})<CR>
  nnoremap <buffer> yy
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'yank'})\|echom 'yanked: '..getreg('*')<CR>
  nnoremap <buffer> M
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'move'})<CR>
  nnoremap <buffer> R
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'rename'})<CR>
nnoremap <buffer> P <Cmd>call ddu#ui#do_action('itemAction', {'name': 'paste'})<CR>
nnoremap <buffer> <leader>p <Cmd>call ddu#ui#do_action('itemAction', {'name': 'paste', 'params': {'path': input('Input target path:')}})<CR>
  nnoremap <buffer> K
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'newDirectory'})<CR>
  nnoremap <buffer> N
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'newFile'})<CR>
  nnoremap <buffer> ~
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'narrow', 'params': {'path': expand('~')}})<CR>
  nnoremap <buffer><silent> .
      \ <Cmd>call <SID>ddu_swap_converter('matchers','matcher_hidden', '')<CR>
  nnoremap <buffer> w
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'replace'})<CR>j
  nnoremap <buffer><silent><nowait> sf
      \ <Cmd>call ddu#ui#do_action('updateOptions',{'sources': [{'name': 'file_external', 'options': {'path': ddu#custom#get_current(b:ddu_ui_name).sources[0].options.path}}]})<CR>
  nnoremap <buffer><expr> Y
      \ ddu#ui#get_item().kind ==# 'file' ? setreg('*', fnamemodify(ddu#ui#get_item().action.path, ':t')) : "Y"
  nnoremap <buffer><silent> !
      \ <Cmd>call <SID>ddu_swap_converter('sorters','sorter_time', 'sorter_alpha')<CR>
endfunction

function! s:execute(expr) abort
  if !exists('g:ddu#ui#ff#_filter_parent_winid')
    return
  endif
  call win_execute(g:ddu#ui#ff#_filter_parent_winid, a:expr)
endfunction

augroup ddu-user
  au!
  autocmd User Ddu:uiCloseFilterWindow
        \ call s:ddu_ff_filter_cleanup() | echohl NONE
  autocmd User Ddu:uiOpenFilterWindow
        \ call s:ddu_ff_filter_my_settings() | echohl Constant
  autocmd FileType ddu-ff call s:ddu_my_settings()
  autocmd BufEnter * call s:restore_spk()
  autocmd FileType ddu-ff-filter call s:ddu_my_filter_settings()
augroup END

let s:ddu_save_cmap = {}
let s:save_cmap_list = ['<CR>', '<C-j>', '<C-k>', '<C-o>', '<C-l>', '<C-R>', '<C-t>', '<C-d>']
call foreach(s:save_cmap_list, {_, v -> extend(s:ddu_save_cmap, {v : !empty(maparg(v, 'c', v:false, v:true)) ? maparg(v, 'c', v:false, v:true) : ""})})

function! s:escape()
let key = nvim_replace_termcodes("<ESC>", v:true, v:false, v:true)
call nvim_feedkeys(key, 'n', v:false)
endfunction

function! s:ddu_ff_filter_my_settings() abort
  setlocal cursorline
  call foreach(s:save_cmap_list, {_, v -> extend(s:ddu_save_cmap, {v : maparg(v, 'c', v:false, v:true)})})
  cnoremap  <C-j>
        \ <Cmd>call ddu#ui#do_action('cursorNext', { 'loop': v:true })<CR>
  cnoremap  <C-k>
        \ <Cmd>call ddu#ui#do_action('cursorPrevious', {'loop': v:true })<CR>
  cnoremap  <CR>
      \ <Cmd>call <SID>escape()\|call ddu#ui#do_action('itemAction')\|mode<CR>
  cnoremap  <C-t>
      \ <Cmd>call <SID>escape()\|call ddu#ui#do_action('itemAction', {'name' : 'open', 'params': {'command': 'tabedit'}})\|mode<CR><ESC>
  cnoremap  <C-r>
      \ <Cmd>call <SID>escape()\|call ddu#ui#do_action('itemAction', {'name' : 'file_rec'})\|mode<CR><C-u>
  cnoremap  <C-l>
      \ <Cmd>call <SID>escape()\|call ddu#ui#do_action('itemAction')\|mode<CR>
  " cnoremap <C-h>
  "     \ <Cmd>call <SID>ddu_ff_back()<CR>
  cnoremap <C-o> <ESC>
  cnoremap <C-d> <ESC><Cmd>call ddu#ui#do_action('quit')<CR>
endfunction

function! s:ddu_ff_filter_cleanup() abort
  call foreach(s:ddu_save_cmap, {k,v -> empty(v) ? mapcheck(k, "c") != "" ? nvim_del_keymap('c', k) : "" : mapset('c', 0, v)})
endfunction

autocmd FileType ddu-filer call s:ddu_filer_my_settings()
function! s:ddu_filer_my_settings() abort
  if has('nvim')
    setlocal winbar=
  endif
  set cursorline
  set winhighlight+=CursorLine:DduUnderlined
  nnoremap <silent><buffer> <C-e> <C-w>p
  nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
  nnoremap <buffer> a
      \ <Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>j
  nnoremap <buffer> A
      \ <Cmd>call ddu#ui#do_action('toggleAllItems')<CR>j
  nnoremap <buffer> q
      \ <Cmd>call ddu#ui#do_action('quit')<CR>
  nnoremap <buffer><silent><nowait> <tab>
      \ <Cmd>call ddu#ui#do_action('inputAction')<CR>
  nnoremap <buffer> o
      \ <Cmd>call ddu#ui#do_action('expandItem',{'mode': 'toggle', 'maxLevel': 0})<CR>
  nnoremap <buffer> O
      \ <Cmd>call ddu#ui#do_action('expandItem',{ 'maxLevel': -1})<CR>
  nnoremap <buffer><silent><nowait> <C-r>
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'file_rec'})<CR>
  nnoremap <buffer> C
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'copy'})<CR>
  nnoremap <buffer> D
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'trash'})<CR>
  nnoremap <buffer> yy
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'yank'})\|echom 'yanked: '..getreg('*')<CR>
  nnoremap <buffer> M
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'move'})<CR>
  nnoremap <buffer> R
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'rename'})<CR>
  nnoremap <buffer> x
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'executeSystem'})<CR>
  nnoremap <buffer> h
    \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'narrow', 'params': {'path': ".."}})<CR>
  nnoremap <buffer> P
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'paste'})<CR>
  nnoremap <buffer> K
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'newDirectory'})<CR>
  nnoremap <buffer> N
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'newFile'})<CR>
  nnoremap <buffer> ~
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'narrow', 'params': {'path': expand('~')}})<CR>

  nnoremap <buffer><silent><nowait> S
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'open', 'params': { 'command': 'split'}})<CR>
  nnoremap <buffer><silent><nowait> V
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'open', 'params': {'command': 'vsplit'}})<CR>
  nnoremap <buffer><silent><nowait> T
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'open', 'params': {'command': 'tabedit'}})<CR>
  nnoremap <buffer><silent> \
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'cd'})<CR>
  nnoremap <buffer><silent> h <Cmd>call ddu#ui#do_action('itemAction', {'name': 'narrow', 'params': {'path': ".."}})<CR>
  " \ ddu#ui#filer#get_item().__level > 0 ?
  nnoremap <silent><buffer> ss
      \ <Cmd>call ddu#ui#do_action('updateOptions', {'ui' : 'ff'})<CR>
  nnoremap <buffer><silent> .
      \ <Cmd>call <SID>ddu_swap_converter('matchers','matcher_hidden', '')<CR>
  nnoremap <buffer><silent> !
      \ <Cmd>call <SID>ddu_swap_converter('sorters','sorter_time', 'sorter_alpha')<CR>
  nnoremap <buffer><expr> <CR>
      \ ddu#ui#get_item()->get('isTree', v:false) ?
      \ "<Cmd>call ddu#ui#do_action('itemAction', {'name': 'narrow'})<CR>" :
      \ "<Cmd>call ddu#ui#do_action('itemAction', {'name': 'open', 'params': {'command': 'drop'}})<CR>"
  nnoremap <buffer><expr> l
      \ ddu#ui#get_item()->get('isTree', v:false) ?
      \ "<Cmd>call ddu#ui#do_action('itemAction', {'name': 'narrow'})<CR>" :
      \ "<Cmd>call ddu#ui#do_action('itemAction', {'name': 'open'})<CR>"
endfunction

function! s:ddu_swap_converter(type, before, after) abort
  let item = ddu#ui#get_item()
  let option = ddu#custom#get_current(b:ddu_ui_name)
  let type = a:type
  let name = item.__sourceName
  let llist = option.sourceOptions[name][type]

  if a:after ==# ''
    if index(llist, a:before) >= 0
      call remove(llist, index(llist, a:before))
    else
      let llist += [a:before]
    endif
  else
    call map(llist, {i,v -> v ==# a:before ? a:after : v ==# a:after ? a:before : v})
  endif
  call ddu#ui#do_action('updateOptions',option)
  call ddu#redraw(b:ddu_ui_name, {'method': 'refreshItems'})
  echo 'swap ' .. type
endfunction

highlight! DduUnderlined cterm=underline gui=underline guifg=NONE guisp=#84a0c6
highlight! DduFilter guifg=#ffffff guibg=#e27878
au ColorScheme * highlight! DduUnderlined cterm=underline gui=underline guifg=NONE guisp=#84a0c6
au ColorScheme * highlight! DduFilter guifg=#ffffff guibg=#e27878

call ddu#custom#patch_global(#{
    \   sourceOptions: #{
    \     lsp_documentSymbol: #{
    \       converters: [ 'converter_lsp_symbol' ],
    \     },
    \     lsp_workspaceSymbol: #{
    \       converters: [ 'converter_lsp_symbol' ],
    \     },
    \   }
    \ })


lua require("ddurc")
" Setup dps-yank-history

" Setup ddu.vim
call ddu#custom#patch_global('sources', [
      \   {'name': 'yank-history'},
      \ ])
call ddu#custom#patch_global('sourceParams', #{
      \ yank-history: #{
      \   headerHlGroup: 'Special',
      \   prefix: 'Hist:',
      \ }})
call ddu#custom#patch_global('sourceOptions', #{
      \ yank-history: #{
      \   sorters: ['sorter_reversed'],
      \ }})

 call ddu#custom#alias('default', 'source', 'file_rec_hidden', 'file_external' )
 call ddu#custom#patch_global('sourceParams', {
	 \   'file_rec_hidden': {
	 \     'cmd': ['rg', '--files', '--color', 'never', '--no-binary', '--hidden']
	 \   },
	 \ })
" Setup ddc.vim
" au dein WinResized * lua require("ddurc")
