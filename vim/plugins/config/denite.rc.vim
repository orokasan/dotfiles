call denite#custom#option('_', {
    \ 'winheight': 15,
    \ 'short_source_names': v:true,
    \ 'highlight_mode_normal': 'Visual',
    \ 'highlight_mode_insert': 'Visual',
    \ 'prompt': '#',
    \ 'highlight_matched_char' : 'Title',
    \ 'max_dynamic_update_candidates' : '50000',
    \ 'vertical_preview': v:false,
    \ 'statusline': v:true,
    \ 'direction': 'botright',
    \ 'quick_move_table': {
        \   'a' : 0, 's' : 1, 'd' : 2, 'f' : 3, 'g' : 4,
        \   'h' : 5, 'l' : 6, ';' : 7,
        \   'q' : 8, 'w' : 9, 'e' : 10, 'r' : 11, 't' : 12,
        \ }
    \ })
if has('nvim')
    call denite#custom#option('_',{
        \ 'filter_split_direction' : 'floating'
        \ })
endif
call denite#custom#option('normal', {
    \ 'winheight': 9
    \})
call denite#custom#option('search', {
    \ 'winheight': 9
    \ })
" call denite#custom#option('command', {
"     \ 'winheight': 5,
"     \ 'split': 'floating',
"     \ 'wincol': &columns/2,
"     \ 'winrow' : &lines/2
"     \ })
call denite#custom#option('stay',{
    \ 'split': 'floating',
    \ 'wincol': &columns/2-2,
    \ 'winwidth': &columns-5,
    \ 'winheight': 10,
    \ 'winrow' : &lines - 12
    \ })

""need rg for grep/file-rec
call denite#custom#var('file/rec', 'command',
    \ ['rg', '--files', '--no-messages','--hidden',
    \ '--glob', '!**/.git/*', '--glob','!*.tmp','-g','!AppData/*'])

call denite#custom#source('grep', 'args', ['', '', '!'])
call denite#custom#var('grep', 'command', ['rg', '--threads', '1'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'final_opts', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'default_opts',
      \ ['--vimgrep', '--no-heading'])

" Add custom menus
let s:menus = {
    \ }
let s:vimtex_commands = ['VimtexClean', 'VimtexTocOpen', 'VimtexTocToggle',
    \ 'VimtexCompileSS', 'VimtexRefreshFolds', 'VimtexReloadState', 'VimtexStop',
    \ 'VimtexStatus', 'VimtexCompile', 'VimtexStopAll', 'VimtexErrors', 'VimtexLog',
    \ 'VimtexCompileOutput', 'VimtexClean!', 'VimtexView', 'VimtexCountWords!',
    \ 'VimtexReload', 'VimtexDocPackage', 'VimtexCountLetters', 'VimtexCountWords',
    \ 'VimtexToggleMain', 'VimtexInfo', 'VimtexInfo!', 'VimtexCompileSelected',
    \ 'VimtexStatus!', 'VimtexRSearch', 'VimtexImapsList', 'VimtexCountLetters!']
let s:menus.tex = {'description': 'vimtex commands' }
let s:menus.tex.command_candidates = []
for v in range(len(s:vimtex_commands))
    let s:menus.tex.command_candidates += [[s:vimtex_commands[v], s:vimtex_commands[v]]]
endfor

let s:dein_commands = ['DeinInstall', 'DeinRecache', 'DeinUpdate']
let s:menus.dein = {'description': 'dein.vim commands' }
let s:menus.dein.command_candidates = []
for v in range(len(s:dein_commands))
    let s:menus.dein.command_candidates += [[s:dein_commands[v], s:dein_commands[v]]]
endfor
let s:menus.string = {'description': 'string utilities.'}
let s:menus.string.command_candidates = [
      \ ['format: reverse lines', 'g/^/m0'],
      \ ['format: remove ^M', '%s///g'],
      \ ['format: querystring', 'silent! %s/&amp;/\&/g | silent! %s/&/\r&/g | silent! %s/=/\r=/g'],
      \ ['format: to smb', 'silent! %s/\\/\//g | silent! %s/^\(smb:\/\/\|\/\/\)\?/smb:\/\//g']
      \ ]

call denite#custom#var('menu', 'menus', s:menus)

" call denite#custom#kind('file', 'default_action', 'drop')
" call denite#custom#source('file', 'matchers', ['matcher/fruzzy'])
" call denite#custom#source('file/rec', 'matchers', ['matcher/fruzzy'])
" Define alias
call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#alias('source', 'grep/git', 'grep')
call denite#custom#var('grep/git', 'command', ['git', 'grep'])
" call denite#custom#source('_', 'sorters', ['sorter/reverse'])
call denite#custom#var('file/rec/git', 'command',
    \ ['git', 'ls-files', '-co', '--exclude-standard'])

"Change ignore_globs

call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
    \ [ '.git/', '.ropeproject/', '__pycache__/',
    \ 'venv/', 'images/','img/', 'fonts/',
    \ '*~', '*.o', '*.exe', '*.bak',
    \ '.DS_Store', '*.pyc', '*.sw[po]', '*.class',
    \ '.hg/', '.git/*', '.bzr/', '.svn/',
    \ 'tags', 'tags-*'])

" 現在いるDeniteDirでgrep
function! s:candidate_grep(context) abort
    let path = a:context['targets'][0]['action__path']
    let dir = denite#util#substitute_path_separator(path)
    if isdirectory(dir)
        let sdir = fnamemodify(dir, ':p:h')
    else
        let sdir = fnamemodify(dir, ':p')
    endif
    let sources_queue = a:context['sources_queue'] + [[
          \ {'name': 'grep', 'args': [sdir, '', '!']},
          \ ]]
    return {'is_interactive': v:false, 'sources_queue': sources_queue}
endfunction

function! s:denite_rec(context)
    let path = a:context['targets'][0]['action__path']
    let dir = denite#util#substitute_path_separator(path)
    if isdirectory(dir)
        let sdir = fnamemodify(dir, ':p:h')
    else
        let sdir = fnamemodify(dir, ':p')
    endif
    let fdir = '\"' . sdir. '\"'
    execute('Denite file/rec:' . sdir)
endfunction

function! s:denite_directory_rec(context)
    let path = a:context['targets'][0]['action__path']
    let dir = denite#util#substitute_path_separator(path)
    " if isdirectory(dir)
    "     let sdir = fnamemodify(dir, ':p:h:h')
    " else
        let sdir = fnamemodify(dir, ':p:h')
    " endif
    let fdir = '\"' . sdir . '\"'
    execute('Denite directory_rec:' . sdir)
endfunction

call denite#custom#action(
    \ 'buffer,directory,file,openable,dirmark', 'directory/rec',
    \ function('s:denite_directory_rec')
    \ )

call denite#custom#action(
    \ 'buffer,directory,file,openable,dirmark', 'grep',
    \ function('s:candidate_grep')
    \ )
call denite#custom#action(
    \ 'buffer,directory,file,openable,dirmark,dirmark', 'file/rec',
    \ function('s:denite_rec')
    \ )

"Defxで開く
function! s:defx_open(context)
    let path = a:context['targets'][0]['action__path']
    let file = fnamemodify(path, ':p')
    let file_search = filereadable(expand(file)) ? ' -search=' . file : ''
    let dir = denite#util#path2directory(path)
    if &filetype ==# 'defx'
      call defx#call_action('cd', [dir])
      call defx#call_action('search', [path])
    else
      execute('Defx ' . dir . file_search)
    endif
endfunction

"action:defxを定義
call denite#custom#action(
    \ 'directory,file,openable,dirmark',
    \ 'defx',
    \  function('s:defx_open'))

"sorter定義
function! ToggleSorter(sorter) abort
   let sorters = split(b:denite_context.sorters, ',')
   let idx = index(sorters, a:sorter)
   if idx < 0
       call add(sorters, a:sorter)
   else
       call remove(sorters, idx)
   endif
   let b:denite_new_context = {}
   let b:denite_new_context.sorters = join(sorters, ',')
   return '<denite:nop>'
endfunction
