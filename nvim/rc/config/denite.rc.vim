call denite#custom#option('_', {
    \ 'winheight': 15,
    \ 'short_source_names': v:true,
    \ 'prompt': ' #',
    \ 'highlight_matched_char': 'Title',
    \ 'highlight_preview_line': 'Underlined',
    \ 'max_dynamic_update_candidates': 100000,
    \ 'vertical_preview': v:true,
    \ 'source_names': 'short',
    \ 'statusline': v:false,
    \ 'direction': 'botright',
    \ 'preview_width': &columns/2,
    \ 'match_highlight': v:true,
    \ 'highlight_matched_range' : 'NONE',
    \ 'quick_move_table': {
        \   'a' : 0, 's' : 1, 'd' : 2, 'f' : 3, 'g' : 4,
        \   'h' : 5, 'l' : 6, ';' : 7,
        \   'q' : 8, 'w' : 9, 'e' : 10, 'r' : 11, 't' : 12,
        \ }
    \ })
if has('nvim')
    call denite#custom#option('_',{ 'filter_split_direction' : 'floating' })
else
    call denite#custom#option('_',{ 'filter_split_direction' : 'aboveleft' })
endif

call denite#custom#option('normal', {'winheight': 9})
call denite#custom#option('search', {'winheight': 15})
call denite#custom#option('float',{
    \ 'split': 'floating',
    \ 'wincol': 0,
    \ 'winwidth': &columns,
    \ 'winheight': 10,
    \ 'winrow' : &lines - 12
    \ })
call denite#custom#option('relative',{
    \ 'split': 'floating_relative_cursor',
    \ 'auto_resize': v:true,
    \ 'wincol': &columns * 1/3,
    \ 'winwidth': &columns*2/3,
    \ 'winheight': 11,
    \ 'winrow' : &lines *1/3,
    \ })

call denite#custom#kind('openable', 'default_action', 'switch')
call denite#custom#kind('file', 'default_action', 'switch')
call denite#custom#kind('buffer', 'default_action', 'switch')
call denite#custom#source('file/old', 'default_action', 'switch')
""need rg for grep/file-rec
" call denite#custom#source('grep', 'args', ['', '', '!'])
if executable('rg')
    call denite#custom#var('grep', {
            \ 'command': ['rg'],
            \ 'default_opts': ['-i', '--vimgrep', '--no-heading'],
            \ 'recursive_opts': [],
            \ 'pattern_opt': ['--regexp'],
            \ 'separator': ['--'],
            \ 'final_opts': [],
            \ })
	" call denite#custom#var('file/rec', 'command',
	" \ ['pt', '--follow', '--nocolor', '--nogroup','--ignore=','AppData**',
	" \  (has('win32') ? '-g:' : '-g='), ''])
    call denite#custom#var('file/rec', 'command',
     \ ['rg', '--files',  '--hidden', '--glob', '!**/.git/*', '--color', 'never'])
    call denite#custom#source('file/rec', 'converters', [])
    call denite#custom#var('file/rec', 'cache_threshold', 50000)
endif
if executable('jvgrep')
    call denite#custom#var('grep', {
            \ 'command': ['jvgrep'],
            \ 'default_opts': ['-i', '--no-color', '-r', '-I'],
            \ 'recursive_opts': ['-R'],
            \ 'pattern_opt': [],
            \ 'separator': [],
            \ 'final_opts': [],
            \ })
endif
" Add custom menus
let s:menus = {
    \ }

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
" call denite#custom#source('file/rec', 'matchers', ['matcher/fuzzy', 'matcher/ignore_globs'])
" if executable('fzf')
" call denite#custom#source('_', 'matchers', ['matcher/regexp'])
" else
call denite#custom#source('_', 'matchers', ['matcher/fuzzy'])
" endif
" call denite#custom#source('help', 'matchers', ['matcher/fuzzy'])
" call denite#custom#source('file/old', 'converters', ['converter/tail_path'])
" Define alias
call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#alias('source', 'grep/git', 'grep')
call denite#custom#alias('source', 'grep/jv', 'grep')
call denite#custom#alias('source', 'grep/junk', 'grep')
call denite#custom#var('grep/git', 'command', ['git', 'grep'])
call denite#custom#source('_', 'sorters', ['sorter/sublime'])
call denite#custom#var('file/rec/git', 'command',
    \ ['git', 'ls-files', '-co', '--exclude-standard'])

"Change ignore_globs
call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
    \ [ '.git/', '.ropeproject/', '__pycache__/',
    \ 'venv/', 'images/','img/', 'fonts/',
    \ '*~', '*.o', '*.exe', '*.bak',
    \ '.DS_Store', '*.pyc', '*.sw[po]', '*.class',
    \ '.hg/', '.git/*', '.bzr/', '.svn/',
    \ '*.aux', '*.dvi', '*.bbl', '*.out', '*.fdb_latexmk', '*.bst', '*.blg', '*.toc',
    \ 'tags', 'tags-*'])
call denite#custom#alias('filter', 'matcher/only_plaintxt', 'matcher/ignore_globs')
call denite#custom#filter('matcher/only_plaintxt', 'ignore_globs',
    \ [ '.git/', '.ropeproject/', '__pycache__/',
    \ 'venv/', 'images/','img/', 'fonts/',
    \ '*~', '*.o', '*.exe', '*.bak',
    \ '.DS_Store', '*.pyc', '*.sw[po]', '*.class',
    \ '.hg/', '.git/*', '.bzr/', '.svn/',
    \ '*.aux', '*.dvi', '*.bbl', '*.out', '*.fdb_latexmk', '*.bst', '*.blg', '*.toc',
    \ '*.pdf', '*.docx', '*.docs',
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
        let fdir = fnamemodify(dir, ':p:h')
    else
        let fdir = fnamemodify(dir, ':p')
    endif
    " let fdir = '\"' . sdir. '\"'
    execute('Denite
        \ -path=' . fdir .
        \ ' file/rec')
endfunction

call denite#custom#filter('matcher/clap',
  \ 'clap_path', expand('~/.cache/dein/repos/github.com/liuchengxu/vim-clap'))

function! s:denite_directory_rec(context)
    let path = a:context['targets'][0]['action__path']
    let dir = denite#util#substitute_path_separator(path)
        let sdir = fnamemodify(dir, ':~:h')
    " execute('Denite directory_rec:' . sdir)
    let fdir = '\"' . sdir. '\"'
    execute('Denite
        \ -path=' . fdir .
        \ ' directory_rec')
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
    \ 'buffer,directory,file,openable,dirmark', 'file/rec',
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

" autocmd dein CursorHold * if &filetype ==# 'denite' | call denite#call_map('do_action', 'highlight') | endif
" autocmd dein WinEnter * if &filetype ==# 'denite' && b:denite.buffer_name ==# 'text' | call g:Denite_set_cursor(context) | endif

function! g:Denite_set_cursor(context) abort
    let pos = a:context['target'][0]['__cursor']
    echo pos 
    return
    " cursor(pos, 0)
endfunction
