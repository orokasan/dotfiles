function! vimrc#getRaw()
  let isbn = expand('<cword>')
  let raw = system(['curl', '-s', 'https://api.openbd.jp/v1/get?isbn=' . isbn])
  let s = json_decode(raw)[0]
endfunction

function! vimrc#isbn()
  let hankei = {
      \ 'B108': 'A5判',
      \ 'B109': 'B5判',
      \ 'B110': 'B6判',
      \ 'B111': '文庫',
      \ 'B112': '新書判',
      \ 'B119': '四六判',
      \ 'B120': '四六変形判',
      \ 'B121': 'A4判',
      \ 'B122': 'A4変形判',
      \ 'B123': 'A5変形判',
      \ 'B124': 'B5変形判',
      \ 'B125': 'B6変形判',
      \ 'B126': 'AB判',
      \ 'B127': 'B7判',
      \ 'B128': '菊判',
      \ 'B129': '菊変形判',
      \ 'B130': 'B4判',
      \ }

  let output = {}
  let isbn = expand('<cword>')
  let raw = system(['curl', '-s', 'https://api.openbd.jp/v1/get?isbn=' . isbn])

  let s = json_decode(raw)[0]
  if type(s) != v:t_dict
    echom 'no data'
    return
  endif
  for i in keys(s.summary)
    let output[i] = s.summary[i]
  endfor

  try
    let output['Price'] = s.onix.ProductSupply.SupplyDetail.Price[0].PriceAmount
    let output['hankei'] = s.hanmoto.hankeidokuji
    let output['PageNum'] = s.onix.DescriptiveDetail.Extent[0].ExtentValue
    let output['AuthorBio'] = s.onix.DescriptiveDetail.Contributor[0].BiographicalNote
  catch
  endtry

  try
    let output['見出し'] = s.onix.CollateralDetail.TextContent[0].Text
    let output['概要'] = s.onix.CollateralDetail.TextContent[1].Text
    let output['目次'] = s.onix.CollateralDetail.TextContent[2].Text
  catch
  endtry

  let isbn10 = substitute(s.summary.isbn,'^978','','')
  let output['Amazon'] = 'https://amazon.co.jp/dp/' .. isbn10
  let koumoku = [
      \ 'title',
      \ 'author',
      \ 'hankei',
      \ 'PageNum',
      \ 'isbn',
      \ 'Price',
      \ 'publisher',
      \ 'pubdate',
      \ 'Amazon',
      \ '概要',
      \ '見出し',
      \ '目次',
      \ 'AuthorBio',
      \ 'cover',
      \ 'series',
      \ ]
  if !bufexists('書誌情報')
    split
  endif

  drop 書誌情報
  let bufnr = winbufnr(0)
  call deletebufline(bufnr, 1, '$')
  setlocal filetype=isbn
  setlocal bufhidden=hide
  setlocal buftype=nofile
  setlocal nobuflisted
  setlocal nofoldenable
  setlocal nolist
  setlocal nomodeline
  setlocal nospell
  setlocal noswapfile
  nnoremap <buffer> q :quit<CR>

  let c = [ 'title',
  \ 'author',
  \ 'hankei',
  \ 'PageNum',
  \ 'Price',
  \ 'publisher',
  \ 'isbn',
  \ ]
  let l =  map(c, {i,v -> has_key(output, v) ?
        \ v ==# 'author' ? substitute(output[v], "／", ' ', 'g') :
        \ v ==# 'hankei' ? output[v] .. '判／' :
        \ v ==# 'PageNum' ? substitute(output[v], '\v(\d)(\d{3})', {m -> m[1] .. ',' .. m[2]}, '') .. 'ページ' :
      \ v ==# 'isbn' ? "ISBN＝" ..  vimrc#isbn_add_hyphen(output[v]):
        \ v ==# 'Price' ? substitute(output[v], '\v(\d+)(\d{3})', {m -> m[1] .. ',' .. m[2]}, '') ..  '円＋税' : output[v] : ''
      \ })
  call filter(l, {i,v -> append(line('$'), v)})
  for k in koumoku
    if has_key(output, k)
      if match(output[k], '\n') > -1
        call append(line('$'), '')
        call append(line('$'), k .. ': -----')
        call append(line('$'), split(output[k], '\n'))
        call append(line('$'), '-----')
        call append(line('$'), '')
      else
        call append(line('$'), k . ': ' . output[k])
      endif
    endif
  endfor
  if !getline(0)
    call deletebufline(bufnr, 1)
  endif
endfunction

function! vimrc#PostIsbnNotion() abort
  let arg = input('ISBN:')
  execute("python sys.argv = ['', " .. arg .. "]")
  pyfile ~/temp/bookpost.py
  redraw
  echom 'Posted ISBN data succesfully: ' ..  arg
endfunction
function! vimrc#PostIsbnFromClipboard() abort
  let arg = substitute(getreg('*'), '-', '', 'g')
  if len(arg) < 9 || len(arg) > 13
    echom 'invalid text in clipboard'
    return
  endif
  execute("python sys.argv = ['', " .. arg .. "]")
  pyfile ~/temp/bookpost.py
  redraw
  echom 'Posted ISBN data succesfully: ' ..  arg 
endfunction

  function! vimrc#ToShiftJisDos() abort
      let cwd = getcwd()
      execute "cd " .. expand('%:p:h')
      if has('win32')
          execute "!wsl nkf -sc --overwrite --fb-java " .. shellescape(expand('%'))
      else
          execute "!nkf -sc --overwrite --fb-java " .. shellescape(expand('%'))
      endif
      edit
      execute "cd " .. cwd
  endfunction

  function! vimrc#ToUtf8Unix() abort
      let cwd = getcwd()
      execute "cd " .. expand('%:p:h')
      if has('win32')
          execute "!wsl nkf -wd --overwrite --fb-java " .. shellescape(expand('%'))
      else
          execute "!nkf -wd --overwrite --fb-java " .. shellescape(expand('%'))
      endif
      edit
      execute "cd " .. cwd
  endfunction

function! vimrc#textobject_outline(...) abort
  let from_parent = index(a:000, 'from_parent') >= 0
  let with_blank = index(a:000, 'with_blank') >= 0

  " get current line and indent
  let from = line('.')
  let indent = indent(from)
  if indent < 0
    return
  endif
  let to = from

  " search first parent
  if from_parent && from > 1 && indent > 0
    let lnum = from - 1
    while indent <= indent(lnum) || (with_blank && getline(lnum) =~ '^\s*$')
      let lnum -= 1
    endwhile

    " update current line and indent
    let from = lnum
    call cursor(from, 0)
    let indent = indent(from)
  endif

  " search last child
  let lnum = to + 1
  while indent < indent(lnum) || (with_blank && getline(lnum) =~ '^\s*$')
    let to = lnum
    let lnum += 1
  endwhile

  " exit visual mode
  let m = mode()
  if m ==# 'v' || m ==# 'V' || m == "\<C-v>"
    execute 'normal! ' .. m
  endif

  " select with line-visual mode
  normal! V
  call cursor(to, 0)
  normal! o
endfunction

  function! vimrc#Highlight_dict() abort
    if s:highlight_id
      call clearmatches()
      let s:highlight_id = v:false
      return
    endif
    let s:filename="dict.txt"
    let s:dict = expand('%:p:h') .. '\dict.txt'
    if !filereadable(s:dict)
      let s:dict = expand('~/') .. '\dict.txt'
      if !filereadable(s:dict)
        echom 'dict file is not found'
        return
      endif
    endif
    let s:dict = substitute(s:dict, '\\', '\/', 'g')
    if filereadable(s:dict)
      let s:lines=readfile(s:dict,1000)
      for line in s:lines
        if line !=# ''
          let word = split(line)
          call matchadd('HighlightDict',word[0])
        endif
      endfor
      call matchadd('UnderlineSpace', ' ')
      call matchadd('UnderlineSpace', '　')
      let s:highlight_id = v:true
    endif
  endfunction

function! vimrc#yanky_history() abort
let g:vimrc_yank_history = {}
lua <<EOF
local value = {}
local history = {}
for index, value in pairs(require("yanky.history").all()) do
  value.history_index = index
  history[index] = value
end
vim.g.vimrc_yank_history = history
EOF
return g:vimrc_yank_history
endfunction

function vimrc#isbn_add_hyphen(isbn)
let isbn = a:isbn
return substitute(isbn,
      \ isbn[4:5] < 20 ? '\v(\d{3})(\d)(\d{2})(\d{6})(\d{1})' :
      \ isbn[4:5] < 70 ? '\v(\d{3})(\d)(\d{3})(\d{5})(\d{1})' :
      \ isbn[4:5] < 85 ? '\v(\d{3})(\d)(\d{4})(\d{4})(\d{1})' :
      \ isbn[4:5] < 90 ? '\v(\d{3})(\d)(\d{5})(\d{3})(\d{1})' :
      \ '\v(\d{3})(\d)(\d{6})(\d{2})(\d{1})',
    \ {m -> m[1] .. '-' .. m[2] ..'-'.. m[3] ..'-' .. m[4] .. '-' .. m[5]}, '')
endfunction
