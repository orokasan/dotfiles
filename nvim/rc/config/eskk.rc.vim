autocmd vimrc User eskk-initialize-pre call s:eskk_initial_pre()
" let g:eskk#log_cmdline_level = 4
" let g:eskk#log_file_level = 4
function! s:eskk_initial_pre() abort
    let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
    call t.add_map('va', 'ゔぁ')
    call t.add_map('vi', 'ゔぃ')
    call t.add_map('vu', 'ゔ')
    call t.add_map('ve', 'ゔぇ')
    call t.add_map('vo', 'ゔぉ')
    call t.add_map('z ', '　')
    call t.add_map('~', '〜')
    call t.add_map('zc', '©')
    call t.add_map('zr', '®')
    call t.add_map('z9', '（')
    call t.add_map('z0', '）')
    call t.add_map('z-', '-')
      " "1." のように数字の後のドットはそのまま入力
    for n in range(10)
      call t.add_map(n . '.', n . '.')
    endfor
    call eskk#register_mode_table('hira', t)
    " lでeskkを終了
    EskkMap -type=disable l
    " CursorLineNrを変数に保存
    let s:eskk_default_linenr_hi =s:gethighlight('CursorLineNr')
endfunction
" eskk_keep_stateがうまく動かないので自前で設定
nnoremap <silent><C-j> :call <SID>eskk_keep_enable_toggle()<CR>

let g:eskk_keep_enable = 0
let s:eskk_status = 0
"TODO :qitta
augroup myeskk
autocmd!
    autocmd InsertLeave * call <SID>eskk_save_status()
    autocmd InsertEnter * call <SID>eskk_insert_status()
augroup END

" ノーマルモードでもeskkの状態を操作する
function! s:eskk_keep_enable_toggle() abort
    if s:eskk_status || g:eskk_keep_enable
        let s:eskk_status = 0
        let g:eskk_keep_enable = 0
        call s:eskk_restore_highlight_linenr()
    else
        " eskkがオフの時に呼ぶと常にeskk onでインサートモードに入る状態になる
        let g:eskk_keep_enable = 1
        call s:eskk_highlight_linenr()
    endif
endfunction

function! s:eskk_save_status() abort
    if g:eskk_keep_enable
        call s:eskk_highlight_linenr()
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
        let status = g:eskk_keep_enable || s:eskk_status ? 'あ' : 'aA'
    endif
    return '[' . status . ']'
endfunction

"IME/skkの状態に応じてsigncolumnの色を変える（WIP）
autocmd vimrc User eskk-enable-post call s:eskk_enable_post()
" InsertLeaveの前に発生するイベントであることに注意する
autocmd vimrc User eskk-disable-post call s:eskk_restore_highlight_linenr()

function! s:eskk_enable_post()
    " ハイライトを有効化
    call s:eskk_highlight_linenr()
endfunction

function! s:eskk_restore_highlight_linenr()
    let l:hi = 'highlight! CursorLineNr ' . s:eskk_default_linenr_hi
    if mode() is# 'i'
        silent execute(l:hi)
    else
        " statusが1のときは戻さない
        if g:eskk_keep_enable || s:eskk_status
            return
        else
            silent execute(l:hi)
        endif
    endif
endfunction

"もともとのhighlightを保存
function! s:gethighlight(hi) abort
    redir => hl
    silent execute 'highlight ' . a:hi
    redir END
    let hl = substitute(hl, '\w*\ze\s\{3}', '', 'g')
    let hl = substitute(hl, '\(xxx\|\n\)', '', 'g')
    let hl = substitute(hl, 'links to .*', '', 'g')
    " bgが無い場合適当な色を埋め込む
    let hl = match(hl, 'guibg') == -1 ? 'guibg=#002b36 ' . hl : hl
    return hl
endfunction

function! s:eskk_highlight_linenr() abort
    " eskkがonの時のhighlightを指定
    let s:eskk_hl = 'highlight CursorLineNr guibg=#cb4b16 cterm=bold ctermfg=0 ctermbg=11 gui=bold guifg=#eee8d5 '
    silent execute(s:eskk_hl)
endfunction

" ColorSchemeが変わった時に読み込み直す
autocmd ColorScheme * let s:eskk_default_linenr_hi =s:gethighlight('CursorLineNr')