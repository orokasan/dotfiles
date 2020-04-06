scriptencoding utf-8

if version < 700
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

syntax match TodoDate '^\d\+\/\d\+$'
syntax match   TodoBullet       '^\s*[-*・]\ze.*$'
syntax match   TodoRuler       '^-----*$'

highlight link TodoBullet       Identifier
highlight link TodoDate       Title
highlight link TodoRuler       Statement

finish
