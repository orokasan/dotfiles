
function! sd#markdown_to_sd()
let s = &wrapscan
setlocal nowrapscan

let @a = "\n脚注本文----------------------------------\n"
let @b = "------------------------------------------\n"

call append(0, '■■■Markdown to format of Software Deisgn: ' .. strftime("%Y %b %d %X"))

silent! %s/\v(？|！)$\ze\n^..*$/\1　/
silent! g/\v^\<!-- (.{-}) --\>/d
silent! %s/^##\+.*$\n\zs\ze\S/\r/

call sd#make_paragraph()

silent! %s/^○/\r\0/
silent! %s/^####\s\+/■/
silent! %s/^###\s\+/■■/
silent! %s/^##\s\+/■■■/

call sd#footnote_word_numbering()

norm gg

while search('^〓注\d\+〓', 'Wp') > 0
  call append(line('.') - 1, ["","脚注本文----------------------------------"])
  call search('^[^〓]', 'Wp')
  call append(line('.') - 1, ["------------------------------------------", ""])
endwhile

silent! %s/\v!\[(.*)\]\((.*)\)/\1\r\2

silent! %s/\v\*\*(.{-})\*\*/〓太〓\1〓\/太〓/g
silent! %s/\v\*(.{-})\*/〓斜〓\1〓\/斜〓/g

silent! %s/\v^```.*\n(\_.{-})```/〓リ\/〓\r\1〓\/リ〓

silent! %s/\v\s*`(.{-})`\s*/〓等幅〓\1〓\/等幅〓/g
silent! %s/\v《(.{-})》/〓ルビ〓\1〓\/ルビ〓/g

silent! %s/\v^(-|\*) /〓箇条中〓・/
silent! %s/\v^\s+(-|\*) /　〓箇条中〓・/

silent! %s/\v\[(.{-})\]/[\1]/

silent! %s/\v^　-----$/◆　◆　◆/

call setline('$', getline('$') .. '〓SD〓')

let &wrapscan = s
" echom sd#deadlink()
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

  if in_code_block
    if emptyline - 1 ==# search('^.*```', 'Wnb')
      let in_code_block = v:false
    else
      norm! j
      continue
    endif
  endif

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
silent! %s/\v〓.{-}〓//
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
  let mes = []
  if search('\(https:\|http:\)', 'np') > 0
      call insert(mes, system(['textlint', '--no-textlintrc', '-f', 'compact', '--rule', 'textlint-rule-no-dead-link', expand('%')]))
  endif
  return mes
endfunction
