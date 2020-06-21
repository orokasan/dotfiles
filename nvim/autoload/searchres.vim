function! searchres#getsearchresult(pattern)
  let old_pos = winsaveview()
  let result = []
  try
    call setpos(".", [0, line("$"), strlen(getline("$")), 0])
    while 1
      silent! let pos = searchpos(a:pattern, "w")
      if pos == [0, 0] || index(result, pos) != -1
        break
      endif
      call add(result, pos)
      if len(result) >= 1000
        break
      endif
    endwhile
  finally
    call winrestview(old_pos)
  endtry
  return result
endfunction
