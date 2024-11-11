let s:ddu_save_current = []
function! ddu_history#save_current()
  let current = ddu#custom#get_current()
  if !(len(current) > 0)
    return
  endif
  let time = localtime()
  let item = {'timestamp': time, 'option': current}
  if len(s:ddu_save_current) == 0 || s:ddu_save_current[0].option != current
    let s:ddu_save_current = insert(s:ddu_save_current, item)
  endif
  if len(s:ddu_save_current) > 50
    call remove(s:ddu_save_current, 50, -1)
  endif
endfunction

function! ddu_history#get_history()
  return s:ddu_save_current
endfunction
