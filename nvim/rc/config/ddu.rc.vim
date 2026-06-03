function! s:ddu_my_open(context) abort
  let mode = mode()
  let action = a:context.items[0].action
  let config = ddu#custom#get_current(a:context.options.name)
  let is_insert = mode ==# 'c'

  if !isdirectory(action.path)
    call ddu#ui#do_action('itemAction', {'name' : 'open'})
    if is_insert
      let key = nvim_replace_termcodes("<C-u><ESC>", v:true, v:false, v:true)
      call nvim_feedkeys(key, 'n', v:false)
    endif
  elseif config.sources[0].name ==# 'file'
    call ddu#ui#do_action('itemAction', {'name' : 'narrow'})
    if is_insert
      call ddu#ui#do_action('openFilterWindow' )
    endif
  else
    call ddu#start({'name': a:context.options.name, 'sources':[{'name':'file', 'options':{'path': expand(action.path,':p')}}] , 'input': '' })
  endif

  return

endfunction

function! MyDduChooseWin(args) abort
  let l:path = a:args.items[0].action.path
  let winid = win_gotoid(luaeval("require('window-picker').pick_window()"))
  execute 'edit ' . l:path
  call win_gotoid(winid)
endfunction

call ddu#custom#action('kind', 'file', 'choosewin', { args -> MyDduChooseWin(args) })

function! s:ddu_copy_current_instance()
  let item = ddu#ui#get_item()
  let path = get(ddu#get_context(b:ddu_ui_name), 'path', '')
  let source = path ? 'file' : ddu#ui#get_item().__sourceName
  let config = {'name': 'split', 'sources': [{'name': source, 'options': {'path': path }}] }
  call ddu#start(config)
  return
endfunction

function! s:ddu_change_to_filer(context)

  let item = a:context.items[0]
  let path = get(a:context, 'path', '')
  let source = path ? 'file' : item.__sourceName
  let config = {'name': 'split1', 'sources': [{'name': source, 'options': {'path': path }}], 'uiParams': {'ff': {'split': 'tab'} }}
  call ddu#start(config)
  let config = {'name': 'split2', 'sources': [{'name': source, 'options': {'path': path }}] }
  call ddu#start(config)
endfunction

call ddu#custom#action('kind', 'file', 'to_filer',
    \  function('s:ddu_change_to_filer'))

 call ddu#custom#alias('default', 'source', 'file_rec_hidden', 'file_external' )
 call ddu#custom#patch_global('sourceParams', {
	 \   'file_rec_hidden': {
	 \     'cmd': ['rg', '--files', '--color', 'never', '--no-binary', '--hidden']
	 \   },
	 \ })

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
      call ddu#start({'sources':[{'name':'file_external','options':{'path': fnamemodify(action.path,':p')}}]})
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
  let action = a:context.items[0].action
  if !isdirectory(action.path)
    return
  endif
  if &filetype =~# '\v(ddu-ff|ddu-ff-filter)'
      call ddu#start({'sources':[{'name':'directory_rec','options':{'path': fnamemodify(action.path,':p')}}]})
    return
  endif
endfunction

call ddu#custom#action('kind', 'file', 'directory_rec',
    \  function('s:ddu_directory_rec'))

function! s:ddu_git_log(context) abort
  let action = a:context.items[0].action
  if &filetype =~# '\v(ddu-ff|ddu-ff-filter)'
      call ddu#start({'sources':[{'name':'git_log','options':{'path':isdirectory(action.path) ? fnamemodify(action.path, ':p') : fnamemodify(action.path,':p:h')}}]})
    return
  endif
endfunction

call ddu#custom#action('kind', 'file', 'git_log',
    \  function('s:ddu_git_log'))

call ddu#custom#alias('default', 'source', 'jvgrep', 'grep' )
call ddu#custom#alias('default', 'source', 'grep_all', 'grep' )

function! s:restore_spk()
if &filetype !~# '^ddu'
  if exists('s:save_splitkeep')
  let &splitkeep=s:save_splitkeep
  unlet s:save_splitkeep
  endif
endif
endfunction

function! s:ddu_execute_mapping(context)
  let item = a:context.items[0]
  if fnamemodify(item.action.path, ':e') ==# 'zip'
     call ddu#ui#do_action('itemAction',{'name': 'unzip'})
  elseif item->get('isTree', v:false) && executable('TE64')
      call systemlist(['TE64', expand(item.action.path)])
  else
     call ddu#ui#do_action('itemAction',{'name': 'executeSystem'})
  endif
  return
endfunction

call ddu#custom#action('kind', 'file', 'my_execute',
    \  function('s:ddu_execute_mapping'))


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
      \ <Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>k
  nnoremap <buffer><silent> <C-a>
      \ <Cmd>call ddu#ui#do_action('toggleAllItems')<CR>
  nnoremap <buffer><silent> \
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'cd'})<CR>
  nnoremap <buffer> h
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'narrow', 'params': {'path': ".."}})<CR>
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
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'my_execute'})<CR>
  nnoremap <buffer><silent> u
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'undo'})<CR>
  nnoremap <buffer> X
      \ <Cmd>call ddu#ui#multi_actions([
      \ ['itemAction', {'name': 'narrow', 'params': {'path': ".."}}],
      \ ['itemAction', {'name': 'my_execute'}],
      \ ['itemAction', {'name': 'narrow'}]
      \ ])<CR>
  nnoremap <buffer><silent><nowait> m
      \ <Cmd>call ddu#ui#do_action('updateOptions',{'sourceOptions': {ddu#custom#get_current(b:ddu_ui_name).sources[0].name :{'matchers':['matcher_kensaku']}}})<CR>
  nnoremap <buffer><silent> l
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'default'})<CR>
  nnoremap <buffer><silent> <C-r>
  \ <cmd>call ddu#redraw(b:ddu_ui_name, {'method': 'refreshItems'})<CR>
  nnoremap <buffer><silent> e
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'to_filer'})<CR>
  nnoremap <buffer><silent> u
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'undo'})<CR>
  nnoremap <buffer><silent><nowait> r <Cmd>call <SID>myddu_mapping_r()<CR>
  function! s:myddu_mapping_r()
  if b:ddu_ui_name ==# 'mail' 
    call ddu#ui#do_action('itemAction', {'name' : 'reply'}) 
  else
    call ddu#ui#do_action('itemAction', {'name' : 'file_rec'})
  endif
  endfunction
  nnoremap <buffer><silent><nowait> <C-g>
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'grep'})<CR>
  nnoremap <buffer><silent> -
  \ <cmd>call ddu#redraw(b:ddu_ui_name, {'method': 'refreshItems'})<CR>
  " nnoremap <buffer><silent> <C-o> <NOP>
  nnoremap <buffer><silent> <C-o> <cmd>call ddu#start(ddu_history#get_history()[1]['option'])<CR>
  nnoremap <buffer><silent> q
      \ <Cmd>call ddu#ui#do_action('quit')<CR>
  nnoremap <buffer><silent> i
      \ gg<Cmd>call ddu#ui#do_action('openFilterWindow')<CR>
  nnoremap <buffer><silent> I
    \ <Cmd>call ddu#ui#do_action('openFilterWindow', {'input': ''} )<CR>
  nnoremap <buffer> o
      \ <Cmd>call ddu#ui#do_action('expandItem',{'mode': 'toggle', 'maxLevel': 0})<CR>
  nnoremap <buffer> O
      \ <Cmd>call ddu#ui#do_action('expandItem',{ 'maxLevel': -1})<CR>
  nnoremap <buffer> c
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'copy'})<CR>
  nnoremap <buffer> D
      \ <Cmd>call ddu#ui#async_action('itemAction', {'name': 'trash'})<CR>
  nnoremap <buffer> yy
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'yank'})\|echom 'yanked: '..getreg('*')<CR>
  nnoremap <buffer> M
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'move'})<CR>
  nnoremap <buffer> gl
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'git_log'})<CR>
  nnoremap <buffer> R
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'rename'})<CR>
nnoremap <buffer> P <Cmd>call ddu#ui#do_action('itemAction', {'name': 'paste'})<CR>
nnoremap <buffer> <leader>p <Cmd>call ddu#ui#do_action('itemAction', {'name': 'paste', 'params': {'path': input('Input target path:')}})<CR>
nnoremap <buffer> o <Cmd>call ddu#ui#async_action('itemAction', {'name': 'driveLink'})<CR>
nnoremap <buffer> O <Cmd>call ddu#ui#async_action('itemAction', {'name': 'driveLink', 'params': {'role': 1, 'permission': 1}})<CR>
nnoremap <buffer> so <Cmd>call ddu#ui#async_action('itemAction', {'name': 'driveOpenLink'})<CR>

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
  nnoremap <buffer> sg
      \ <Cmd>call ddu#start({'sources': [{'name': 'grep', 'params': {'path': ddu#get_context(b:ddu_ui_name).path, 'input': input('Pattern: ')}}]})<CR>
  nnoremap <buffer><silent><nowait> sf
      \ <Cmd>call ddu#ui#do_action('updateOptions',{'sources': [{'name': 'file_external', 'options': {'path': ddu#get_context(b:ddu_ui_name).sources[0].options.path}}]})<CR>
  nnoremap <buffer><silent><nowait> sv
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'to_filer'})<CR>j

  nnoremap <buffer><silent><nowait> d
      \ <Cmd>call ddu#ui#do_action('updateOptions',{'sources': [{'name': 'file', 'options': {'path': fnamemodify(<SID>check_valid_path(), ':h')}}]})\|call ddu#redraw(b:ddu_ui_name, {'method': 'refreshItems'})<CR>
function! s:check_valid_path()
  let item = ddu#ui#get_item()
  let path = len(item.action.path) > 0 ? item.action.path : ddu#custom#get_current(b:ddu_ui_name).sources[0].option.path
  return path
endfunction
  nnoremap <buffer><expr> Y
      \ ddu#ui#get_item().kind ==# 'file' ? setreg('*', fnamemodify(ddu#ui#get_item().action.path, ':t')) : "Y"
  nnoremap <buffer><silent> !
      \ <Cmd>call <SID>ddu_swap_converter('sorters','sorter_time', 'sorter_alpha')<CR>
endfunction

augroup ddu-user
  au!
  autocmd FileType ddu-ff call s:ddu_my_settings()
  autocmd FileType ddu-filer call s:ddu_my_settings()
  autocmd BufEnter * call s:restore_spk()
  autocmd BufLeave * if &filetype ==# 'ddu-ff' | echo ''
augroup END

" let s:ddu_save_cmap = {}
" let s:save_cmap_list = ['<CR>', '<C-j>', '<C-k>', '<C-o>', '<C-l>', '<C-R>', '<C-t>', '<C-d>', '<C-h>', '<BS>']
" call foreach(s:save_cmap_list, {_, v -> extend(s:ddu_save_cmap, {v : !empty(maparg(v, 'c', v:false, v:true)) ? maparg(v, 'c', v:false, v:true) : ""})})

" function! s:escape()
" let key = nvim_replace_termcodes("<C-u><ESC>", v:true, v:false, v:true)
" call nvim_feedkeys(key, 'n', v:false)
" endfunction

" function! s:ddu_ff_filter_my_settings() abort
"   setlocal cursorline
"   call foreach(s:save_cmap_list, {_, v -> extend(s:ddu_save_cmap, {v : maparg(v, 'c', v:false, v:true)})})
"   cnoremap  <C-j>
"         \ <Cmd>call ddu#ui#do_action('cursorNext', { 'loop': v:true })<CR>
"   cnoremap  <C-k>
"         \ <Cmd>call ddu#ui#do_action('cursorPrevious', {'loop': v:true })<CR>
"   cnoremap  <CR>
"       \ <Cmd>call <SID>escape()\|call ddu#ui#do_action('itemAction')\|mode<CR>
"   cnoremap  <C-t>
"       \ <Cmd>call <SID>escape()\|call ddu#ui#do_action('itemAction', {'name' : 'open', 'params': {'command': 'tabedit'}})\|mode<CR><ESC>
"   cnoremap  <C-r>
"       \ <Cmd>call <SID>escape()\|call ddu#ui#do_action('itemAction', {'name' : 'file_rec'})\|mode<CR>
"   cnoremap  <C-l>
"       \ <Cmd>call <SID>escape()\|call ddu#ui#do_action('itemAction')\|mode<CR>
"   " cnoremap <expr> <C-h>
"   "     \ len(w:ddu_ui_ff_status.input) > 0 ? "\<C-h>" : ddu#ui#do_action('itemAction', {'name': 'narrow', 'params': {'path': ".."}})
"   " cnoremap <expr> <BS>
"   "     \ len(w:ddu_ui_ff_status.input) > 0 ? "\<C-h>" : ddu#ui#do_action('itemAction', {'name': 'narrow', 'params': {'path': ".."}})
"   cnoremap <C-o> <ESC>
"   cnoremap <C-d> <ESC><Cmd>call ddu#ui#do_action('quit')<CR>
" endfunction

" function! s:ddu_ff_filter_cleanup() abort
"   call foreach(s:ddu_save_cmap, {k,v -> empty(v) ? mapcheck(k, "c") != "" ? nvim_del_keymap('c', k) : "" : mapset('c', 0, v)})
" endfunction

autocmd User Ddu:uiOpenFilterWindow
      \ call s:ddu_filter_my_settings()| echohl Constant
function! s:ddu_filter_my_settings() abort
  setlocal cursorline

  call ddu#ui#save_cmaps(nvim_get_keymap("c")->mapnew({_, val -> val.lhs}))
  cnoremap  <silent> <C-j>
        \ <Cmd>call ddu#ui#do_action('cursorNext', { 'loop': v:true })<CR>
  cnoremap <silent>  <C-k>
        \ <Cmd>call ddu#ui#do_action('cursorPrevious', {'loop': v:true })<CR>
  cnoremap <silent>  <CR>
      \ <Cmd>call ddu#ui#do_action('itemAction')<CR>
  cnoremap <silent>   <C-t>
      \ <ESC><Cmd>call ddu#ui#do_action('itemAction', {'name' : 'open', 'params': {'command': 'tabedit'}})<CR><ESC>
  cnoremap <silent>   <C-r>
      \ <ESC><Cmd>call ddu#ui#do_action('itemAction', {'name' : 'file_rec'})<CR>
  cnoremap <silent>  <C-l>
      \ <ESC><Cmd>call ddu#ui#do_action('itemAction')<CR>
  " cnoremap <silent> <expr> <C-h>
  "     \ len(w:ddu_ui_ff_status.input) > 0 ? "\<C-h>" : ddu#ui#do_action('itemAction', {'name': 'narrow', 'params': {'path': ".."}})
  cnoremap <silent> <C-o> <ESC>
  cnoremap <silent> <C-d> <ESC><Cmd>call ddu#ui#do_action('quit')<CR>

endfunction

autocmd User Ddu:uiCloseFilterWindow
      \ call s:ddu_filter_cleanup()| echohl NONE

function s:ddu_filter_cleanup() abort
  silent! call foreach(nvim_get_keymap("c"), {_, val -> nvim_del_keymap("c", val.lhs)})
  call ddu#ui#restore_cmaps()
  " echom ddu#custom#get_global().uiOptions._.filterPrompt .. w:ddu_ui_ff_status.input
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

function! DduDynamicFilter(context) abort
  return {"matchers": [], 'converters': []}
endfunction

	function! DduFilterCallback(input)
	  if a:input->stridx('@') != 0
	    return a:input
	  endif
	
	  " Use file source instead.
	  call ddu#ui#do_action('updateOptions', #{
	        \   sources: [
	        \     #{ action: '' },
	        \   ],
	        \ })
	  call ddu#ui#do_action('redraw', #{ method: 'refreshItems' })
	
	  return a:input[1:]
	endfunction

if has('win32')
  call ddu#custom#patch_global({'kindParams': {'file': {'trashCommand':['cmd', '/c', 'npx', 'trash']}}})
else
  call ddu#custom#patch_global({'kindParams': {'file': {'trashCommand':['gio', 'trash']}}})
endif

lua require("ddurc")
