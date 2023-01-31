syn region gihyoHeader1 start='^■[^■]' end='$'
syn region gihyoHeader2 start='^■■[^■]' end='$'
syn region gihyoHeader3 start='^■■■[^■]' end='$'
syn region gihyoHeader4 start='^■■■■[^■]' end='$'
syn region gihyoSubHeader1 start='^□[^□]' end='$'
syn region gihyoSubHeader2 start='^□□[^□]' end='$'
syn region gihyoSubHeader3 start='^□□□[^□]' end='$'
syn region gihyoSubHeader4 start='^□□□□[^□]' end='$'
syntax match gihyoRuler "\(=\|-\|+\)\{50,120}"
syntax match gihyoURL "\(http\|https\|ftp\):[-!#%&+,./0-9:;=?@A-Za-z_~]\+"
syntax match gihyoNotUseChar '[Ａ-Ｚａ-ｚ０-９．，]'
syntax match gihyoUnderline '<s>.\{-}<\\s>'
syntax match gihyoUnderline '▽.\{-}▽'
syntax match gihyoUnderlineAlt '∨.\{-}∨'
syntax match gihyoItalic '◆.\{-}◆'
syntax match gihyoSup '▲.\{-}▲'
syntax match gihyoSub '▼.\{-}▼'
syntax match gihyoRed '●.\{-}●'

syntax match sdMarker '〓.\{-}〓'
syntax match sdTableWhite '〓リ白/〓'
syntax match sdTable '〓リ/〓'
syntax match sdBullet '〓箇条.〓'


syntax match sdMain '〓メイン〓'
syntax match sdSub '〓サブ〓'
syn region sdBold start='〓太〓' end='〓/太〓'
syn region sdRubi start='〓ルビ〓' end='〓/ルビ〓'
syn region sdMono start='〓等幅〓' end='〓/等幅〓'
syn region sdItalic start='〓斜体〓' end='〓/斜体〓'
syn region sdListFontWhite start='〓リ注白〓' end='〓/リ注白〓'
syn region sdListFontBlack start='〓リ注黒〓' end='〓/リ注黒〓'
syn region sdItalic start='〓斜体〓' end='〓/斜体〓'
" syn region sdBullet start='\(〓箇条中〓\|〓箇条太〓\)' end='$'
syn region sdComment start='^★' end='$'
syntax match sdCaptionChar '^○'
syn region sdCaption start=/^○[図表]\d\+　/ end=/$/ contains=ALL

" syntax region sdList start=/\n〓リ\/〓/ end=/〓\/リ〓$/ contains=ALL
" syntax region sdTable start=/^〓表〓$/ end=/^〓\/表〓$/ contains=ALL
" syntax region sdFigure start=/^▼図/ end=/$/ contains=ALL
" syntax region sdCommand start=/\n==コマンド\n/ end=/\n==.\{-}\n\n/ contains=ALL


" syntax match textUnderline '　'
syntax match gihyoSubTitle '^◎[^◎]*$'
syntax match gihyoSubTitle '^◎[^◎]*$'
" syntax match gihyoBullet '^・.\{-}$'
syntax match gihyoComment '^☆.\{-}$'
syn match gihyoComment '＠＠.\{-}＠＠'
" syntax match gihyoComment '^★.\{-}$'
syntax match gihyoHeader1 '^★[^★].\{-}$'
syn region gihyoBold start='◇' end='◇'
syn region gihyoInlineComment start='《' end='》'
" syn region gihyoBullet start='^・' end='$'
syn region gihyoBullet start='^●' end='$'
syn region gihyoComment start='^☆' end='$'
syntax match gihyoComment '^★★.\{-}$'
syntax region gihyoTodo start='^TODO' end='$'

syntax region gihyoList start=/\n====リスト/ end=/\n====\n\n/ contains=ALL
syntax region gihyoTable start=/^▼表/ end=/$/ contains=ALL
syntax region gihyoFigure start=/^▼図/ end=/$/ contains=ALL
" syntax region gihyoTable start=/^▼表-----$/ end=/^\{-}-----\n/ contains=ALL
" syntax region gihyoCode start=/^▼コード-----$/ end=/^\{-}-----\n/ contains=ALL
" syntax region gihyoCode start=/\n▼リスト/ end=/\n.\{-}\n\n/ contains=ALL
syntax region gihyoCommand start=/\n==コマンド\n/ end=/\n==.\{-}\n\n/ contains=ALL

" syntax region gihyoTable start=/^▼構文-----$/ end=/^\{-}-----\n/

syntax region gihyoBlockSyntax start=/\n<syntax>-----/ end=/\n-----<syntax>\n/ contains=ALL
syntax region gihyoBlockCode start=/<code:.*>-----/ end=/\n-----\n/ contains=ALL
syntax region gihyoBlockCode start=/----->/ end=/\n-----<\n/ contains=ALL
syntax region gihyoBlockMI start=/<MI>-----/ end=/-----<MI>\n/ contains=ALL
syntax region gihyoBlockTable start=/\n<table>-----/ end=/\n-----<table>\n/ contains=ALL
highlight link gihyoBlockSyntax Number
highlight link gihyoBlockCode Identifier
highlight link gihyoBlockMI Special
highlight link gihyoBlockTable Number

" highlight link
highlight link gihyoHeader1 Title
highlight link gihyoHeader2 Constant
highlight link gihyoHeader3 Statement
highlight link gihyoHeader4 Statement
highlight link gihyoSubHeader1 Function
highlight link gihyoSubHeader2 Function
highlight link gihyoSubHeader3 Statement
highlight link gihyoSubHeader4 Statement
highlight link gihyoSubTitle Title
highlight link gihyoLead Special
highlight link gihyoSup Number
highlight link gihyoSub Special
highlight link gihyoHead Statement
highlight link gihyoList Special
highlight link gihyoRed Error
highlight link gihyoUnderlineAlt Title
highlight link gihyoTable Special
highlight link gihyoFigure Special
highlight link gihyoMono Constant
highlight link gihyoUnderline Special
highlight link gihyoItalic String
highlight link gihyoCode Statement
highlight link gihyoBold Statement
highlight link gihyoCommand PreProc
highlight link gihyoComment Comment
highlight link gihyoBullet Identifier
highlight link gihyoInlineComment Function
highlight link gihyoPoint Identifier

highlight link sdMain Title
highlight link sdSub Special
highlight link sdCaption Todo
highlight link sdCaptionChar Todo
highlight link sdMarker Identifier
highlight link sdLead Special
highlight link sdSup Number
highlight link sdSub Special
highlight link sdHead Statement
highlight link sdList Special
highlight link sdRed Error
highlight link sdUnderlineAlt Title
highlight link sdFigure Special
highlight link sdUnderline Special
highlight link sdItalic String
highlight link sdCode Statement
highlight link sdMono Special
highlight link sdBold Statement
highlight link sdCommand PreProc
highlight link sdComment Comment
highlight link sdBullet String
highlight link sdInlineComment Function
highlight link sdPoint Identifier
highlight link sdListFontWhite WildMenu
highlight link sdListFontBlack Visual
highlight link sdTableWhite Visual
highlight link sdTable WildMenu

highlight link gihyoRuler Specia
highlight link gihyoURL Underlined
highlight link gihyoTodo Todo
highlight link gihyoNotUseChar Error

highlight link gihyoDStrong PreProc
highlight link gihyoSStrong PreProc
function! s:gethighlight(hi, which) abort
 let bg = synIDattr(synIDtrans(hlID(a:hi)), a:which)
 return bg
endfunction
highlight link gihyoZw Comment
call execute('hi textUnderline gui=underline guisp=' .. s:gethighlight('Comment', 'fg'))
hi! link NonText Comment
syntax sync minlines=100
" vim:set et syntax=vim nowrap :

