call denite#custom#option('_', {
    \ 'winheight': 15,
    \ 'short_source_names': v:true,
    \ 'prompt': ' #',
    \ 'highlight_preview_line': 'Underlined',
    \ 'max_dynamic_update_candidates': 300000,
    \ 'vertical_preview': v:true,
    \ 'source_names': 'short',
    \ 'statusline': v:false,
    \ 'direction': 'botright',
    \ 'preview_width': &columns/2,
    \ 'match_highlight': v:true,
    \ 'smartcase': v:true,
    \ 'highlight_matched_range' : 'Title',
    \ 'quick_move_table': {
        \   'a' : 0, 's' : 1, 'd' : 2, 'f' : 3, 'g' : 4,
        \   'h' : 5, 'l' : 6, ';' : 7,
        \   'q' : 8, 'w' : 9, 'e' : 10, 'r' : 11, 't' : 12,
        \ }
    \ })
" call denite#custom#option('default', {
"     \ 'post_action' : 'open'
"     \ })

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
call denite#custom#var('buffer', 'date_format', '%Y/%m/%d %H:%M:%S')
call denite#custom#filter('matcher/migemo', 'dict_path', 'C:\tools\cmigemo\dict\utf-8\migemo-dict')
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
     \ ['rg', '--files', '--glob', '!.git"', '--color', 'never'])
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

let s:shortcut_commands = [
    \ 'LspDocumentDiagnostics',
    \ 'JunkfileOpen txt',
    \]
" function! s:denite_add_shortcut(arg) abort
"     let s:menus.shortcut.command_candidates += [[a:arg, a:arg]]
" endfunction
" command! -nargs=? -complete=command ShortcutAdd call s:denite_add_shortcut(<q-args>)
let s:menus.shortcut = {'description': 'shortcut to vim command' }
let s:menus.shortcut.command_candidates = []
for v in range(len(s:shortcut_commands))
    let s:menus.shortcut.command_candidates += [[s:shortcut_commands[v], s:shortcut_commands[v]]]
endfor

call denite#custom#var('menu', 'menus', s:menus)

" call denite#custom#kind('file', 'default_action', 'drop')
" call denite#custom#source('file/rec', 'matchers', ['matcher/fuzzy', 'matcher/ignore_globs'])
" if executable('fzf')
" call denite#custom#source('_', 'matchers', ['matcher/regexp'])
" else
" call denite#custom#source('_', 'matchers', ['matcher/fuzzy'])
" endif
" call denite#custom#source('help', 'matchers', ['matcher/fuzzy'])
" call denite#custom#source('file/old', 'converters', ['converter/tail_path'])
" Define alias
call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#alias('source', 'grep/git', 'grep')
call denite#custom#alias('source', 'grep/jv', 'grep')
call denite#custom#alias('source', 'grep/junk', 'grep')
call denite#custom#var('grep/git', 'command', ['git', 'grep'])
" call denite#custom#source('_', 'sorters', ['sorter/sublime'])
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
    \ 'tags', 'tags-*', 'junkfile/'])
" call denite#custom#alias('filter', 'matcher/only_plaintxt', 'matcher/ignore_globs')
" " call denite#custom#filter('matcher/only_plaintxt', 'ignore_globs',
"     \ [ '.git/', '.ropeproject/', '__pycache__/',
"     \ 'venv/', 'images/','img/', 'fonts/',
"     \ '*~', '*.o', '*.exe', '*.bak',
"     \ '.DS_Store', '*.pyc', '*.sw[po]', '*.class',
"     \ '.hg/', '.git/*', '.bzr/', '.svn/',
"     \ '*.aux', '*.dvi', '*.bbl', '*.out', '*.fdb_latexmk', '*.bst', '*.blg', '*.toc',
"     \ '*.pdf', '*.docx', '*.docs',
"     \ 'tags', 'tags-*'])
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
    let dir = substitute(dir, ' ', '\\ ', 'g')
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
" call denite#custom#source('_', 'matchers', ['matcher/substring'])
" call denite#custom#source('_', 'matchers', ['matcher/regexp'])
" call denite#custom#source('help', 'matchers', ['matcher/fuzzy'])
" call denite#custom#source('file_mru', 'matchers', ['matcher/regexp'])

function! s:denite_directory_rec(context)
    let path = a:context['targets'][0]['action__path']
    let dir = denite#util#substitute_path_separator(path)
    let dir = substitute(dir, ' ', '\\ ', 'g')
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
function! s:denite_my_cd(context)
let path = a:context['targets'][0]['action__path']
if isdirectory(path)
let path = fnamemodify(path, ':p')
else
let path = fnamemodify(path, ':p:h')
endif
call denite#util#cd(path)
echo 'current directory is changed to ' . getcwd()
endfunction
call denite#custom#action('directory,file,openable', 'cd', function('s:denite_my_cd'))
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
    let dir = substitute(dir, ' ', '\\ ', 'g')
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

" this snippet is from Shougo/defx.nvim
let s:is_windows = has('win32') || has('win64')
let s:is_mac = !s:is_windows && !has('win32unix')
  \ && (has('mac') || has('macunix') || has('gui_macvim') ||
  \   (!isdirectory('/proc') && executable('sw_vers')))

function! s:denite_execute(context)
    let path = a:context['targets'][0]['action__path']
  let filename = fnamemodify(path, ':p')
  " Detect desktop environment.
  if s:is_windows
    " For URI only.
    " Note:
    "   # and % required to be escaped (:help cmdline-special)
    silent execute printf(
          \ '!start rundll32 url.dll,FileProtocolHandler %s',
          \ escape(filename, '#%'),
          \)
  elseif has('win32unix')
    " Cygwin.
    call system(printf('%s %s', 'cygstart',
          \ shellescape(filename)))
  elseif executable('xdg-open')
    " Linux.
    call system(printf('%s %s &', 'xdg-open',
          \ shellescape(filename)))
  elseif exists('$KDE_FULL_SESSION') && $KDE_FULL_SESSION ==# 'true'
    " KDE.
    call system(printf('%s %s &', 'kioclient exec',
          \ shellescape(filename)))
  elseif exists('$GNOME_DESKTOP_SESSION_ID')
    " GNOME.
    call system(printf('%s %s &', 'gnome-open',
          \ shellescape(filename)))
  elseif executable('exo-open')
    " Xfce.
    call system(printf('%s %s &', 'exo-open',
          \ shellescape(filename)))
  elseif s:is_mac && executable('open')
    " Mac OS.
    call system(printf('%s %s &', 'open',
          \ shellescape(filename)))
  else
    " Give up.
    call defx#util#print_error('Not supported.')
  endif
endfunction

call denite#custom#action(
    \ 'directory,file,openable,dirmark',
    \ 'execute',
    \  function('s:denite_execute'))
" call denite#custom#source('file/rec', 'matchers', ['matcher/migemo'])
" call denite#custom#source('line', 'matchers', ['matcher/migemo'])
