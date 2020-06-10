call denite#custom#option('_', {
    \ 'winheight': 15,
    \ 'short_source_names': v:true,
    \ 'prompt': ' #',
    \ 'highlight_matched_char': 'Title',
    \ 'highlight_preview_line': 'Underlined',
    \ 'max_dynamic_update_candidates': 50000,
    \ 'vertical_preview': v:false,
    \ 'source_names': 'short',
    \ 'statusline': v:false,
    \ 'direction': 'botright',
    \ 'match_highlight': v:true,
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
call denite#custom#option('search', {'winheight': 9})
call denite#custom#option('float',{
    \ 'split': 'floating',
    \ 'wincol': 0,
    \ 'winwidth': &columns,
    \ 'winheight': 10,
    \ 'winrow' : &lines - 12
    \ })
call denite#custom#option('relative',{
    \ 'split': 'floating_relative',
    \ 'auto_resize': v:true,
    \ 'wincol': &columns * 1/3,
    \ 'winwidth': &columns*2/3,
    \ 'winheight': 11,
    \ 'winrow' : &lines *1/3,
    \ })

""need rg for grep/file-rec
call denite#custom#source('grep', 'args', ['', '', '!'])
" when filtering multibyte char interactivelly, should insert space at fist. 
if executable('jvgrep')
    call denite#custom#var('grep', {
            \ 'command': ['jvgrep'],
            \ 'default_opts': ['-i'],
            \ 'recursive_opts': ['-R'],
            \ 'pattern_opt': [],
            \ 'separator': [],
            \ 'final_opts': [],
            \ })
elseif executable('rg')
    call denite#custom#var('grep', {
            \ 'command': ['rg'],
            \ 'default_opts': ['-i', '--vimgrep', '--no-heading'],
            \ 'recursive_opts': [],
            \ 'pattern_opt': ['--regexp'],
            \ 'separator': ['--'],
            \ 'final_opts': [],
            \ })
endif
if executable('rg')
    call denite#custom#var('file/rec', 'command',
        \ ['rg', '--files', '--no-messages','--hidden',
        \ '--glob', '!**/.git/*', '--glob','!*.tmp','-g','!AppData/*'])
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
" call denite#custom#source('_', 'matchers', ['matcher/fzf'])
" else
call denite#custom#source('_', 'matchers', ['matcher/fuzzy'])
" endif
call denite#custom#source('help', 'matchers', ['matcher/fuzzy'])
" call denite#custom#source('file/old', 'converters', ['converter/tail_path'])
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
    \ '*.aux', '*.dvi', '*.bbl', '*.out', '*.fdb_latexmk', '*.bst', '*.blg', '*.toc',
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
        let fdir = fnamemodify(dir, ':h:~')
    else
        let fdir = fnamemodify(dir, ':~')
    endif
    " let fdir = '\"' . sdir. '\"'
    execute('Denite
        \ -path=' . fdir .
        \ ' file/rec')
endfunction

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
