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
      \ -name=buffer
      \ buffer<CR>
  nnoremap <silent> sd <cmd>Ddu
      \ -ui-param-split=floating
      \ -ui-param-autoResize
      \ jump<CR>
  nnoremap <silent> sS <cmd>Ddu
      \ -name=file
      \ file -source-option-path=`expand('%:p:h')`<CR>
  nnoremap <silent> ss <cmd>Ddu file -source-option-path=`getcwd()`<CR>
  nnoremap <silent> s/ <cmd>Ddu searchres<CR>
  nnoremap <silent> sy <cmd>Ddu
      \ -name=word
      \ -ui-param-split=floating
      \ miniyank<CR>

  nnoremap <silent> se <cmd>Ddu
      \ -name=word
      \ -ui-param-split=floating
      \ -source-option-path=`expand('~/GoogleDrive/SD/work/template/editor_symbols.txt')`
      \ word_line<CR>

  nnoremap <silent> sg <cmd>call ddu#start({'sources': [{'name': 'grep', 'params': {'path': <SID>find_gitdir(),'input': input('Pattern: ')}}]})<CR>
  " nnoremap <silent> sg <cmd>call ddu#start({'sources': [{'name': 'jvgrep', 'params': {'path': <SID>find_gitdir(),'input': input('Pattern: ')}}]})<CR>
  nnoremap <silent> s* <cmd>call ddu#start({'sources': [{'name': 'grep', 'params': {'path': <SID>find_gitdir(),'input': expand('<cword>')}}]})<CR>
  nnoremap <silent> sG <cmd>call ddu#start({'sources': [{'name': 'grep', 'params': {'input': input('Pattern: ')}}]})<CR>
  nnoremap <silent> sG <cmd>call ddu#start({'sources': [{'name': 'grep_all', 'params': {'input': input('Pattern: ')}}]})<CR>
  nnoremap <silent> sF <cmd>Ddu file_external -source-option-path=`<SID>find_gitdir()` -ui-param-startFilter=v:true<CR>
  nnoremap <silent> sf <cmd>Ddu file_external -source-option-path=`getcwd()`<CR>
  nnoremap <silent> sp <cmd>call ddu#start({'name': 'default', 'sources': [{'name': 'file', 'options': {'path': expand(input('Input target path: '),'%:p:h')}, 'params':{}}]})<CR>
  nnoremap <silent> sj <cmd>Ddu dirmark<CR>
  nnoremap <silent> s- <cmd>Ddu -ui-param-startFilter=v:true dein<CR>
  nnoremap <silent> s_ <cmd>Ddu dein_update<CR>

  nnoremap <silent> sv <cmd>Ddu junkfile -name=prev -ui-param-cursorPos=2<CR>
  nnoremap <silent> sV <cmd>call ddu#start({'sources': [{'name': 'file_external', 'option': {'path': '~/.cache/junkfile/' .. strftime('%Y/%m'),'input': ''}}]})<CR>
  " nnoremap <silent> sV <cmd>Ddu junkfile -name=prev<CR>

  nnoremap <silent> sK <cmd>Ddu nvim_lsp_diagnostic_all<CR>
  nnoremap <silent> sk <cmd>Ddu nvim_lsp_diagnostic_buffer<CR>
  autocmd dein FileType txt,markdown nnoremap <silent><buffer> sk <cmd>Ddu textlint<CR>

  nnoremap <silent> <space>e <cmd>call ddu#start({'name': 'filer', 'searchPath': expand('%:p'), 'sources': [{'name': 'file', 'options': {'path': expand('%:p:h')}}]})<CR>
  nnoremap <silent> <space>E <cmd>call ddu#start({'name': 'filer', 'sources': [{'name': 'file', 'options': {'path': expand(input('Input target path: '),'%:p:h')}}]})<CR>
  " nnoremap <silent> <space>e <cmd>Ddu -name=filer -path=`expand('%:h:p')` file<CR>
  nnoremap <silent> st <cmd> call ddu#start({'name': 'tree', 'focus': v:true, 'options':{'searchPath': ''}, 'sources': [{'name': 'text'}],'resume': v:true, 'refresh':v:true}})<CR>

  nnoremap <silent> <C-e> <cmd> call ddu#start({'name': 'filer', 'focus': v:true,'resume': v:true})<CR>
  " echom 'Denops Ready!'
endfunction


call s:ddu_mapping()
" let iconlist = defx_icons#get()
" let ext = iconlist.icons.extensions
" for i in keys(ext)
"   let color = ext[i].color[0] ==# '#' ? substitute(ext[i].color, '#', '', '') : ext[i].color
"   call execute('highlight! ' .. 'ddu_icon_hl_' .. i .. ' guifg=#' .. color)
" endfor


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
