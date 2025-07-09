
function! sd#markdown_to_sd()
let s = &wrapscan
setlocal nowrapscan

let @a = "脚注本文----------------------------------\n"
let @b = "------------------------------------------\n"

call append(0, '■■■Markdown to format of Software Deisgn: ' .. strftime("%Y %b %d %X"))

if search('^#\s.*', '') == 1
  %s/^#//
endif

silent! %s/\v(？|！)$\ze\n^..*$/\1　/
silent! g/\v^\<!-- (.{-}) --\>/d

call sd#make_paragraph()

silent! %s/^###\s*/■/
silent! %s/^##\s*/■■/
silent! %s/^#\s*/■■■/

call sd#footnote_word_numbering()

norm gg
while search('^〓注\d\+〓', 'Wp') > 0
  norm! "aP
  if search('^[○■]', 'Wp') > 0
  norm! "bP
  else
  norm! G"bp
  break
  endif
endwhile

silent! %s/\v!\[(.*)\]\((.*)\)/\1\r\2
" silent! %s/\v\[\^(.{-})\]:*\s*/〓注1〓/g

silent! %s/\v\*\*(.{-})\*\*/〓太〓\1〓\/太〓/g
" silent! %s/^```\w*/〓リ\/〓/g
" silent! %s/^```/〓\/リ〓/g
silent! g/^```\w*/d
silent! g/^```/d

silent! %s/\v\s*`(.{-})`\s*/〓等幅〓\1〓\/等幅〓/g
silent! %s/\v《(.{-})》/〓ルビ〓\1〓\/ルビ〓/g

" silent! %s/```\w*//g
" silent! %s/^|//
" silent! %s/|$//
" silent! %s/|/\t/g
silent! %s/\v^(-|\*) /〓箇条中〓・/
silent! %s/\v^\s+(-|\*) /　〓箇条中〓・/

silent! %s/\v\[(.{-})\]/[\1]/

silent! %s/\v^　-----$/◆　◆　◆/

" /^\v[^〓■○]
" /^$
let &wrapscan = s
" call sd#deadlink()
endfunction

" function! WordFootnoteToSD()
" let @i = 1
" let res = matchbufline('%', '\v[^^]\zs\[\^(.{-})\]', '1', '$')
" for i in res
"   call setbufline('%', i['lnum'], substitute(getbufline('%', i['lnum'])[0], '\v[^^]\zs\[\^(.{-})\]', '〓注'..@i .. '〓', ''))
"   call search('\V'..i['text'] .. ':\*\s\*','sp')
"   call setbufline('%', line('.'), substitute(getbufline('%', line('.'))[0], '\V' .. i['text'] .. ':\*\s\*', '〓注'..@i .. '〓', ''))
"   let @i = @i + 1
" endfor
" endfunction

function! sd#footnote()
call cursor(1,1)
while search('^〓注1〓', 'sWp') > 0
  norm! }
  if getline(line('.') + 1) =~# '^〓注1〓'
    call deletebufline('%', line('.'), line('.'))
    norm! `'
    continue
  endif
  norm {"ap}"bP
endwhile
endfunction

function! sd#footnoteNumbering()
call cursor(1,1)
let @i = 1
while search('[^^].\{-\}〓注\zsx〓', 'Wp') > 0
norm! diw"iP
call search('^〓注\zsx〓', 'sWp')
norm! diw"iP
norm! `'
let @i = @i + 1
endwhile
endfunction

function! sd#footnote_word_numbering()
call cursor(1,1)
let i = 1
let @i = '〓注' .. i .. '〓'
while search('[^^].\{-\}\zs\(\[\^.\{-}]\)', 'Wsp') > 0
  let pos = getpos('.')
  norm! "oda["iP
  while search('\V'.. @o, 'Wp') > 0
    norm! da["iP
    silent! s/:\s*//
  endwhile
  call setpos('.', pos)
  let i = i + 1
  let @i = '〓注' .. i .. '〓'
endwhile
endfunction


function! sd#fig_numbering(word)
call cursor(1,1)
let @i = 1
while search('\*\*' .. a:word.. '\zsx\*\*', 'Wp') > 0
  norm! diw"iP
  if search('^○' .. a:word.. '\zsx', 'sWp') > 0
    norm! diw"iP
    echo getline('.')
    norm! `'
  else
    echoerr a:word .."：本文の参照が抜けている箇所があります。"
    echoerr getline('.')
    norm! `'
    return
  endif
    let @i = @i + 1
endwhile

if search('^○' .. a:word.. '\zsx', 'sWp') > 0
  let line = line('.') .. ':' .. getline('.')
  echoerr a:word .."：図版番号が抜けている箇所があります。"
  echoerr line
  undo
  norm! `'
  return
endif

endfunction

function! sd#numbering() abort
" call sd#footnoteNumbering()
for i in  ['図', 'リスト', '表']
call sd#fig_numbering(i)
endfor
endfunction

function! sd#make_paragraph()
let in_code_block = v:false
call cursor(1,1)
let emptyline = 1

while search('^$', 'sWp') > 0
  let emptyline = line('.')

  if emptyline + 1 ==# search('^$', 'nW')
    call deletebufline('%', emptyline, emptyline)
    norm! k
    continue
  endif

  if (emptyline - 1 ==# search('^[#|]\+\s*','Wnb'))
    norm! j
  elseif (emptyline - 1 ==# search('^\s*[\-\*]\s','Wnb')) || (emptyline + 1 ==# search('^\s*[\-\*]\s','Wn'))
    call setline(emptyline, '〓半改〓')
    norm! j
  else
    call deletebufline('%', emptyline, emptyline)
  endif

  let curline = line('.')

  if in_code_block
    if curline - 1 ==# search('^.*```', 'Wnb')
      let in_code_block = v:false
    else
      norm! j
      continue
    endif
  endif

  if curline ==# search('^○*\(リスト\|図\|表\)', 'Wnc')
    if curline + 1 ==# search('^.*```', 'Wnc')
      let in_code_block = v:true
    endif

    continue
  endif

  if curline ==# search('^.*```', 'Wnc')
    let in_code_block = v:true
    continue
  endif

  if curline ==# search('^\s*[#!\[|]\s*','Wnc')
    continue
  endif

  if curline ==# search('^\s*[\-\*]\s','Wnc')
    continue
  endif

  if curline ==# search('^\s*\d\+\.\s','nWc')
    continue
  endif

  if curline !=# search('^　', 'Wnc')
    norm! I　
  endif

  if curline + 1 !=# search('^$', 'Wnc')
    norm! v}kgJ
  endif

endwhile
endfunction

function! sd#pagecount() abort
if &filetype !=# 'markdown'
  return
endif

let file = expand('%')
let pos = getpos('.')

let text = getline(0,'$')
let tmpfile = tempname()
edit! `=tmpfile`
call setline(1, text)

silent MarkdonwToSD

silent! %s/\v〓(注\d+)〓/\1/g
silent! %s/\v〓.{-}〓(.{-})〓\/.{-}〓/\1/g
silent! g/^■■■/norm! o
silent! g/^〓赤〓/norm! dd
silent! g/----------------------------------/norm! dd

setlocal textwidth=42
silent! g/./norm! gqgq
let lineNr = line('$')
let SDpageNum = (lineNr + 13 * 2) / 2.0 / 40.0
echom SDpageNum .. 'ページ'

" bwipeout! %
edit `=file`
call setpos('.', pos)
endfunction

function! sd#deadlink()
  if search('\(https:\|http:\)', 'np') > 0
    echom system(['textlint', '--no-textlintrc', '-f', 'compact', '--rule', 'textlint-rule-no-dead-link', expand('%')])
  endif
endfunction
