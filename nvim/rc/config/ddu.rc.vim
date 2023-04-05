function! s:ddu_change_to_filer(context)
  let action = a:context.items[0].action
  let config = {}
  let path = fnamemodify(action.path, ':p')
  if !isdirectory(path)
    let dir = fnamemodify(path, ':h:p')
  else
    let dir = path
  endif
  let config.uiParams = {'filer':{'search': path}}
  let config.sources = [{'name':'file','options':{'path': dir}}]
  let config.name = 'filer'
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
  if isdirectory(action.path)
    if config.sources[0].name ==# 'file'
      call ddu#ui#do_action('itemAction', {'name' : 'narrow'})
    else
      call ddu#ui#do_action('updateOptions',{'sources':[{'name':'file','options':{'path': expand(action.path,':p')}}]})
      return
    endif
  else
    call ddu#ui#do_action('itemAction', {'name' : 'open'})
  endif
endfunction

call ddu#custom#action('kind', 'file', 'my_open',
    \  function('s:ddu_my_open'))

call ddu#custom#patch_global({
    \ 'actionOptions': {
    \ 'file_rec': {'quit': v:false},
    \ 'get_context': {'quit': v:false},
    \ 'to_filer': {'quit': v:true},
    \ 'my_open': {'quit': v:false},
    \ 'narrow': {'quit': v:false},
    \ 'cd': {'quit': v:false},
    \ 'replace': {'quit': v:false},
    \ }
    \ })
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
      call ddu#ui#do_action('updateOptions',{'sources':[{'name':'file_external','options':{'path': expand(action.path,':p')}}]})
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
function! s:ddu_get_context(context) abort
  let b:ddu_cursor_candidate = a:context
endfunction
call ddu#custom#action('kind', 'file', 'get_context',
    \  function('s:ddu_get_context'))

call ddu#custom#alias('source', 'jvgrep', 'grep')
call ddu#custom#alias('source', 'grep_all', 'grep')
let s:ddu_winheight = 20
call ddu#custom#patch_global({
    \ 'profile': v:false,
    \ 'ui': 'ff',
    \ 'sync': v:false,
    \ 'kindOptions': {
    \ 'file': {
    \ 'defaultAction': 'my_open',
    \},
    \ 'word': {'defaultAction': 'append'},
    \ 'action': {'defaultAction': 'do'},
    \ 'help': {'defaultAction': 'open'},
    \     'dein_update': {
    \       'defaultAction': 'viewDiff',
    \     },
    \ },
    \ 'sourceOptions': {
    \ '_': {
    \ 'matchers': ['merge'],
    \ 'ignoreCase': v:true,
    \ 'columns': ['icons'],
    \ },
    \ 'action': {
    \ 'matchers': ['matcher_fzy'],
    \},
    \     'dein_update': {
    \       'matchers': ['matcher_dein_update'],
    \     },
    \ 'jump': {
    \ 'defaultAction': 'jump'
    \ },
    \ 'textlint': {'defaultAction': 'preview'},
    \ 'markdown':{
    \'defaultAction':'open',
    \},
    \ 'junkfile': {'matchers': ['matcher_fzy','matcher_hidden']},
    \ 'file_external': {'matchers': ['merge'], 'converters':['converter_highlight_filename']},
    \ 'file': {'matchers': ['matcher_hidden','merge'],'converters':['converter_no_empty', 'converter_highlight_filename'], 'sorters':['sorter_time'],},
    \ 'buffer': {'matchers': ['merge'],'converters':['converter_highlight_filename']},
    \ 'grep': {'matchers': ['matcher_substring'],},
    \ 'dein': {'sorters':[]},
    \ 'text': {'columns':[]},
    \ 'file_old': {'matchers': ['converter_unique','matcher_fzy',],'converters':['converter_highlight_filename',],},
    \ 'mr': {'matchers': ['merge',], 'converters':['converter_relative','converter_unique','converter_highlight_filename'],'sorters': ['sorter_oldfiles'],},
    \ },
    \ 'sourceParams': {
    \ 'mr': {
    \ 'current': v:false
    \ },
    \ 'buffer': {
    \ 'orderby': 'desc'
    \},
    \ 'grep': {
    \ 'highlights':{'path':'Comment', 'lineNr': 'LineNr', 'word': 'Function'},
    \ 'args': ["rg", "--column", "--no-heading", "--color", "never", '--json', '--smart-case' ],
    \ },
    \ 'grep_all': {
    \ 'highlights':{'path':'Comment', 'lineNr': 'LineNr', 'word': 'Function'},
    \ 'args': ["rga", "--column", "--no-heading", "--color", "never", '--json', '--smart-case' ],
    \ },
    \ 'jvgrep': {
    \ 'highlights':{'path':'Comment', 'lineNr': 'LineNr', 'word': 'Function'},
    \ 'args': ["jvgrep", "-i", "--no-color", "-r", "-I", '-R' ],
    \ },
    \ 'file_external': {
    \ 'cmd': ['rg', '--files', '--color', 'never', '--no-binary'],
    \ 'updateItems': 20000,
    \ },
    \ },
    \ 'uiParams': {
    \ 'ff': {
    \ 'previewFloating': v:true,
    \ 'filterSplitDirection': 'floating',
    \ 'filterFloatingPosition': 'top',
    \ 'winHeight': s:ddu_winheight,
    \ 'winRow': 13,
    \ 'highlights': {
    \ 'prompt': 'Function',
    \ 'selected': 'Title'
    \ },
    \ 'prompt': '# ',
    \ 'direction': 'botright',
    \ 'displaySourceName': 'no',
    \ 'filterUpdateTime': 0,
    \ 'statusline': v:false,
    \ 'previewVertical': v:true,
    \ 'previewWidth': &columns/2,
    \ 'previewHeight': s:ddu_winheight,
    \ 'cursorPos': -1,
    \ 'ignoreEmpty': v:true,
    \ },
    \ 'filer': {
    \ 'previewFloating': v:true,
    \ 'filterSplitDirection': 'floating',
    \ 'split': 'vertical',
    \ 'highlights': {
    \ 'prompt': 'Function'
    \ },
    \ 'prompt': ' #',
    \ 'direction': 'botright',
    \ 'winWidth': 40,
    \ 'displaySourceName': 'no',
    \ 'filterUpdateTime': 0,
    \ 'statusline': v:false,
    \ 'previewVertical': v:true,
    \ 'previewWidth': &columns/2,
    \ 'previewHeight': s:ddu_winheight,
    \ },
    \ },
    \ 'filterParams': {
    \ 'matcher_migemo': {'highlightMatched': ''},
    \  'merge': {
    \    'filters': [
    \      {'name': 'matcher_kensaku', 'weight': 5.0},
    \      'matcher_fzy',
    \    ],
    \    'unique': v:true,
    \  },
    \   'filterParams': {
    \     'matcher_fzy': {
    \       'threshold': 0.1,
    \     },
    \   }
    \ },
    \ 'columnParams': {
    \ 'filename': {
    \ 'highlights': {'directoryName':'Function', 'directoryIcon': 'Constant'},
    \ 'collapsedIcon': '+', 'expandedIcon': '-', 'iconWidth': 1},
    \ 'icons':{
    \ 'filer': v:false,
    \ 'ignoreMatcherHighlight': ["hl_dirname"],
    \} ,
    \},
    \   'actionOptions': {
    \     '_': {
    \       'quit': v:true,
    \     },
    \     'echo': {
    \       'quit': v:false,
    \     },
    \     'echoDiff': {
    \       'quit': v:false,
    \     },
    \     'preview': {
    \       'previewCmds': ['less', '+%b', '%s'],
    \     },
    \   },
    \ })
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

call ddu#custom#patch_local( 'ff-filer',{
    \'ui': 'ff',
    \ 'uiParams': {
    \ 'ff': {
    \ 'split': 'vertical',
    \ 'previewFloating': v:true,
    \ 'filterSplitDirection': 'floating',
    \ 'highlights': {
    \ 'prompt': 'Function'
    \ },
    \ 'direction': 'botright',
    \ 'winWidth': 40,
    \ },
    \},
    \})
call ddu#custom#patch_local( 'nocolumn',{
    \'ui': 'ff',
    \ 'sourceOptions': {
    \ '_': {
    \ 'columns':['icons'],
    \ },}
    \})
call ddu#custom#patch_local('filer',{
    \'ui': 'filer',
    \ 'uiOptions': {'filer':{'persist': v:true,}},
    \'sources': [{'name': 'file'}],
    \'resume': v:true,
    \ 'sync': v:false,
    \ 'uiParams':{
    \ 'filer':{
    \ 'sort': "filename",
    \'sortTreesFirst': v:true,
    \'focus': v:true,
    \},
    \},
    \   'actionOptions': {
    \ '_':{
    \ 'quit': v:true
    \},
    \     'narrow': {
    \       'quit': v:false,
    \     },
    \     'open': {
    \       'quit': v:true,
    \     },
    \},
    \ 'columnParams': {
    \'icons':{
    \ 'filer': v:true,
    \ 'padding': 2,
    \} ,
    \} ,
    \ 'sourceOptions': {
    \ '_': {
    \ 'columns':['icons'],
    \ },
    \ 'file': {
    \ 'sorters': []
    \}
    \ },
    \})
call ddu#custom#patch_local('prev', {
    \ 'ui': 'ff',
    \ 'uiParams': {
    \ 'ff': {
    \ 'autoAction':{'name': 'preview', 'params': {}}
    \}
    \}})
call ddu#custom#patch_local('select', {
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
  if getline('.') == ''
    call ddu#ui#do_action('itemAction', {'name' : 'narrow', 'params': { 'path': '..'}})
  else
    let key = nvim_replace_termcodes("<C-h>", v:true, v:false, v:true)
    call nvim_feedkeys(key, 'n', v:false)
  endif
endfunction

au! BufEnter,BufReadPost,WinClosed *  call s:ddu_set_cursorline(v:false)
autocmd FileType ddu-ff call s:ddu_my_settings()

function! s:ddu_my_settings() abort
  if has('nvim')
    setlocal winbar=%!MyDduWinbarInput()
  endif

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

  call s:ddu_set_cursorline(v:true)
  setlocal scrolloff=5
  nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
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
      \ <Cmd>call ddu#ui#filer#do_action('inputAction')<CR>
  nnoremap <buffer><silent><nowait> T
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'open', 'params': {'command': 'tabedit'}})<CR>
  nnoremap <buffer><silent> a
      \ <Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>
  nnoremap <buffer><silent> A
      \ <Cmd>call ddu#ui#do_action('toggleAllItems')<CR>
  nnoremap <buffer><silent> \
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'cd'})<CR>
  nnoremap <buffer> h <Cmd>call ddu#ui#do_action('itemAction', {'name': 'narrow', 'params': {'path': ".."}})<CR>
  nnoremap <nowait><buffer><silent> m
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'move'})<CR>
  nnoremap <nowait><buffer><silent> C
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'copy'})<CR>
  nnoremap <buffer><silent> p
      \ <Cmd>call ddu#ui#do_action('preview')<CR>
  " nnoremap <buffer><silent> P
  " \ <Cmd>call ddu#ui#do_action('preview', { 'previewCmds': ['git', '-C', '%s', 'log', '--pretty=reference', '-' .. '%h' , '--abbrev-commit']})<CR>
  " !git -C    dotfiles\nvim\rc\config\ log --pretty=format:"%h %s" --grap
  " nnoremap <buffer><silent> p
  " \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'preview', 'params':{ 'previewCmds':['less', '+%b', '%s']}})<CR>
  nnoremap <buffer><silent> x
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'executeSystem'})<CR>
  nnoremap <buffer><silent><nowait> m
      \ <Cmd>call ddu#ui#do_action('updateOptions',{'sourceOptions': {ddu#custom#get_current(b:ddu_ui_name).sources[0].name :{'matchers':['matcher_kensaku']}}})<CR>
  nnoremap <buffer><silent> l
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'default'})<CR>
  nnoremap <buffer><silent> e
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'to_filer'})<CR>
  nnoremap <buffer><silent><nowait> r
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'file_rec'})<CR>
  nnoremap <buffer><silent><nowait> <C-g>
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'grep'})<CR>
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
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'delete'})<CR>
  nnoremap <buffer> M
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'move'})<CR>
  nnoremap <buffer> R
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'rename'})<CR>
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
  nnoremap <buffer><silent> .
      \ <Cmd>call <SID>swap_converter('matchers','matcher_hidden', '')<CR>
  nnoremap <buffer> W
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'replace'})<CR>

  " name specific configs
  if b:ddu_ui_name ==# 'word'
    nnoremap <buffer><silent> p
        \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'append'})<CR>
    nnoremap <buffer><silent> P
        \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'insert'})<CR>
  endif

endfunction

function! s:execute(expr) abort
  if !exists('g:ddu#ui#ff#_filter_parent_winid')
    return
  endif
  call win_execute(g:ddu#ui#ff#_filter_parent_winid, a:expr)
endfunction

autocmd FileType ddu-ff-filter call s:ddu_my_filter_settings()
function! s:ddu_my_filter_settings() abort
  if has('nvim')
    setlocal winblend=100
  endif
  call s:ddu_set_cursorline(v:true)
  inoremap <buffer><silent> <C-o>
      \ <Esc><Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>
  inoremap <buffer><silent> <C-l>
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'default'})<CR>
  inoremap <buffer><silent> <C-h> <cmd>call <SID>ddu_ff_back()<CR>
  inoremap <silent><buffer> <C-i> <Plug>(skkeleton-enable)
  inoremap <silent><buffer> <CR>
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'default'})<CR>
  inoremap <silent><buffer> <C-CR>
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'default'})<CR>
  inoremap <silent><buffer> <tab>
      \ <Cmd>call ddu#ui#do_action('chooseAction') \| call ddu#ui#do_action('openFilterWindow')<CR>
  inoremap <silent><buffer> <C-r>
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'file_rec'})<CR>
  nnoremap <buffer><silent> <CR>
      \ <Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>
  nnoremap <buffer><silent> q
      \ <C-w>c
  inoremap <buffer><silent><nowait> <c-t>
      \ <Cmd>call <SID>swap_converter('matchers','matcher_fzy', 'matcher_kensaku')<CR>
  inoremap <buffer><silent> <C-c>
      \ <Cmd>call ddu#ui#do_action('quit')<CR>
  inoremap <buffer><silent> <ESC>
      \ <Cmd>call ddu#ui#do_action('quit')<CR>
  inoremap <buffer><silent> <C-[>
      \ <Cmd>call ddu#ui#do_action('quit')<CR>
  inoremap <buffer><silent><nowait> <C-g>
      \ <Cmd>call ddu#ui#do_action('chooseAction')<CR>
  inoremap <buffer> <C-j>
      \ <Cmd>call ddu#ui#ff#execute(
      \ "call cursor(line('.')+1,0)<Bar>redraw")<CR>
  inoremap <buffer> <C-k>
      \ <Cmd>call ddu#ui#ff#execute(
      \ "call cursor(line('.')-1,0)<Bar>redraw")<CR>
endfunction

autocmd FileType ddu-filer call s:ddu_filer_my_settings()
function! s:ddu_filer_my_settings() abort
  if has('nvim')
    setlocal winbar=
  endif
  nnoremap <silent><buffer> <C-e> <C-w>p
  nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
  nnoremap <buffer> a
      \ <Cmd>call ddu#ui#filer#do_action('toggleSelectItem')<CR>j
  nnoremap <buffer> A
      \ <Cmd>call ddu#ui#filer#do_action('toggleAllItems')<CR>j
  nnoremap <buffer> q
      \ <Cmd>call ddu#ui#filer#do_action('quit')<CR>
  nnoremap <buffer><silent><nowait> <tab>
      \ <Cmd>call ddu#ui#filer#do_action('inputAction')<CR>
  nnoremap <buffer> o
      \ <Cmd>call ddu#ui#filer#do_action('expandItem',{'mode': 'toggle', 'maxLevel': 0})<CR>
  nnoremap <buffer> O
      \ <Cmd>call ddu#ui#filer#do_action('expandItem',{ 'maxLevel': -1})<CR>
  nnoremap <buffer><silent><nowait> <C-r>
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'file_rec'})<CR>
  nnoremap <buffer> C
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'copy'})<CR>
  nnoremap <buffer> D
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'delete'})<CR>
  nnoremap <buffer> yy
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'yank'})<CR>
  nnoremap <buffer> M
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'move'})<CR>
  nnoremap <buffer> R
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'rename'})<CR>
  nnoremap <buffer> x
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ {'name': 'executeSystem'})<CR>
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
      \ <Cmd>call ddu#ui#do_action('itemAction', {'name' : 'to_ff'})<CR>
  nnoremap <buffer><silent> .
      \ <Cmd>call <SID>swap_converter('matchers','matcher_hidden', '')<CR>
  nnoremap <buffer><expr> <CR>
      \ ddu#ui#get_item()->get('isTree', v:false) ?
      \ "<Cmd>call ddu#ui#do_action('itemAction', {'name': 'narrow'})<CR>" :
      \ "<Cmd>call ddu#ui#do_action('itemAction', {'name': 'open', 'params': {'command': 'drop'}})<CR>"
  nnoremap <buffer><expr> l
      \ ddu#ui#get_item()->get('isTree', v:false) ?
      \ "<Cmd>call ddu#ui#do_action('itemAction', {'name': 'narrow'})<CR>" :
      \ "<Cmd>call ddu#ui#do_action('itemAction', {'name': 'open'})<CR>"
endfunction

function! s:swap_converter(type, before, after) abort
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
endfunction

highlight! DduUnderlined cterm=underline gui=underline guifg=NONE
au ColorScheme * highlight! DduUnderlined cterm=underline gui=underline guifg=NONE
"
" iceberg
function! s:ddu_set_cursorline(enter) abort
  if a:enter
    hi! link CursorLine DduUnderlined
  else
    if &ft !~# 'ddu-*'
      hi! link CursorLine SvCursorLine
    endif
  endif

endfunction

function! s:gethighlight(hi) abort
let bg = synIDattr(synIDtrans(hlID(a:hi)), "bg")
    execute('hi! default SvCursorLine gui=NONE guibg=' .. bg)
    return
endfunction
au dein ColorScheme * let s:SvCursorLine =s:gethighlight('CursorLine')
