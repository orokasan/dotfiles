autocmd dein User eskk-initialize-pre call s:eskk_initial_pre()
" let g:eskk#log_cmdline_level = 4
" let g:eskk#log_file_level = 4
function! s:eskk_initial_pre() abort
    let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
    call t.add_map('va', 'ゔぁ')
    call t.add_map('vi', 'ゔぃ')
    call t.add_map('vu', 'ゔ')
    call t.add_map('ve', 'ゔぇ')
    call t.add_map('vo', 'ゔぉ')
    call t.add_map('ca', 'か')
    call t.add_map('ci', 'し')
    call t.add_map('cu', 'く')
    call t.add_map('ce', 'せ')
    call t.add_map('co', 'こ')
    call t.add_map('xn', 'ん')
    call t.add_map('z ', '　')
    call t.add_map('~', '〜')
    call t.add_map('zc', '©')
    call t.add_map('zr', '®')
    call t.add_map('zk', '■')
    call t.add_map('zm', '●')
    call t.add_map('zH', '←')
    call t.add_map('zJ', '↑')
    call t.add_map('zK', '↓')
    call t.add_map('zL', '→')
    call t.add_map('zss', '▼')
    call t.add_map('zsu', '▲')
    call t.add_map('zds', '◇')
    call t.add_map('zdk', '◆')
    call t.add_map('z1', '１')
    call t.add_map('z2', '２')
    call t.add_map('z3', '３')
    call t.add_map('z4', '４')
    call t.add_map('z5', '５')
    call t.add_map('z6', '６')
    call t.add_map('z7', '７')
    call t.add_map('z8', '８')
    call t.add_map('z9', '９')
    call t.add_map('z-', '-')
    call t.add_map('z%', '％')
    call t.add_map('z.', '…')
    call t.add_map('z/', '・')
    call t.add_map('z,', '●')
      " "1." のように数字の後のドットはそのまま入力
    for n in range(10)
      call t.add_map(n . '.', n . '.')
    endfor
    call eskk#register_mode_table('hira', t)
    " lでeskkを終了
    EskkMap -type=disable l
    " guicursorの値を保存
    let s:default_guicursor = &guicursor

endfunction
" eskk_keep_stateがうまく動かないので自前で設定
nnoremap <silent><M-j> :call <SID>eskk_keep_enable_toggle()<CR>

let g:eskk_keep_enable = 0
let s:eskk_status = 0
"TODO :qitta

augroup myeskk
    autocmd!
    autocmd InsertLeave * call <SID>eskk_save_status()
    autocmd InsertEnter * call <SID>eskk_insert_status()
    "In neovim inccommand substitute, if statement seems not evaluated. (20210421)
    autocmd CmdlineLeave [:/?] if exists('*eskk#enable') && eskk#is_enabled() | call eskk#disable() | endif
    " autocmd CmdlineLeave [:/?] call <SID>eskk_cmdleave_off()
    " autocmd CmdlineLeave [:/?@-] call eskk#disable()
    " autocmd CmdlineLeave * call s:eskk_restore_cursor()
augroup END
function! s:eskk_cmdleave_off() abort
    if exists('*eskk#is_enable') && eskk#is_enable() && !pumvisible()
        call eskk#disable()
    endif
endfunction

" ノーマルモードでもeskkの状態を操作する
function! s:eskk_keep_enable_toggle() abort
    if s:eskk_status || g:eskk_keep_enable
        let s:eskk_status = 0
        let g:eskk_keep_enable = 0
        " call s:eskk_restore_cursor()
    else
        " eskkがオフの時に呼ぶと常にeskk onでインサートモードに入る状態になる
        let g:eskk_keep_enable = 1
        " call s:eskk_highlight_cursor()
    endif
endfunction

function! s:eskk_save_status() abort
    if g:eskk_keep_enable
        " call s:eskk_highlight_cursor()
        return
    endif
    " let s:eskk_status = eskk#is_enabled() ? 1 : 0
endfunction

function! s:eskk_insert_status() abort
    if &filetype ==# 'denite-filter' | return | endif
    " if g:eskk_keep_enable | s:eskk_status
    if g:eskk_keep_enable
        call eskk#enable()
    endif
endfunction

" lightline用の関数
function! LLmyeskk() abort
    let status = 'aA'
    if exists('*eskk#enable') && eskk#is_enabled()
        let status = printf(get(a:000, 0, '%s'),
            \ get(g:eskk#statusline_mode_strings,
            \ eskk#get_current_instance().mode, '??'))
    elseif mode() !=# 'i'
        let status = (g:eskk_keep_enable || s:eskk_status) ? 'あ' : 'aA'
    endif
    return '[' . status . ']'
endfunction

""IME/skkの状態に応じてsigncolumnの色を変える（WIP）
" autocmd vimrc User eskk-enable-post call s:eskk_highlight_cursor()
"" InsertLeaveの前に発生するイベントであることに注意する
" autocmd vimrc User eskk-disable-post call s:eskk_restore_highlight_nicely()

function! s:eskk_restore_highlight_nicely()
    " if exists('g:neovide')
    "     return
    " endif
    if mode() is# 'ic'
        call s:eskk_restore_cursor()
    else
        " statusが1のときは戻さない
        if g:eskk_keep_enable || s:eskk_status
            return
        else
            call s:eskk_restore_cursor()
        endif
    endif
endfunction

function! s:eskk_highlight_cursor()
" guicursorのハイライトをeskkCursorに変更する
highlight CursorLineNr guifg=#e2a478 gui=bold
    " set guicursor=n-v-c:eskkCursor-blinkon0,i-ci:ver25-eskkCursor,r-cr:hor20
endfunction
set guicursor=n-v-c:Cursor-blinkon0,i-ci:ver25-Cursor,r-cr:hor20
function! s:eskk_restore_cursor()
    let higroup = 'CursorLineNr'
" guicursorのハイライトを元に戻す
    " execute('set guicursor=' . s:default_guicursor)
    execute('highlight ' . higroup .' ' . s:eskk_default_linenr_hi)
endfunction
highlight eskkCursor guibg=#e2a478
" set guicursor=n-v-c:block-Cursor-blinkon0,i-ci:Cursor,r-cr:hor20

"もともとのhighlightを保存
function! s:gethighlight(hi) abort
let bg = synIDattr(synIDtrans(hlID(a:hi)), "bg")
" let fg = synIDattr(synIDtrans(hlID(a:hi)), "fg")
    return ' guibg=' . bg
endfunction
" eskkのsource時に設定
let s:eskk_default_linenr_hi =s:gethighlight('CursorLineNr')
" ColorSchemeが変わった時に読み込み直す
autocmd ColorScheme * let s:eskk_default_linenr_hi =s:gethighlight('CursorLineNr')

let g:eskk#server = { 'host': 'localhost', 'port': 55100, 'type': 'dictionary' }
