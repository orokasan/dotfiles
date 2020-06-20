scriptencoding utf-8

if             version <                700
  syntax       clear
elseif         exists('b:current_syntax')
  finish
endif

" pattern match
" syntax         match   gihyoSubTitle    '^◎[^◎]*$'
" syntax         match   gihyoHead        '^◆\ze[^◆]*$'
" syntax         match   gihyoLead        '^▲（リード）$'
" syntax         match   gihyoBullet      '^・\ze.*$'
" syntax         match   gihyoPoint       '^●\ze.*$'


" syntax match   gihyoDStrong      '\"..\{-}\"'
" syntax match   gihyoSStrong      '\'..\{-}\''

syntax         match   gihyoRuler       "\(=\|-\|+\)\{50,120}"
syntax         match   gihyoURL         "\(http\|https\|ftp\):[-!#%&+,./0-9:;=?@A-Za-z_~]\+"
syntax         match   gihyoTodo        '^TODO.*'
syntax         match   gihyoNotUseChar  '[Ａ-Ｚａ-ｚ０-９]'

syntax         match   gihyoSubTitle    '^◎[^◎]*$'
syn region  gihyoHeader1    start='^■[^■]' end='$'
syn region  gihyoHeader2    start='^■■[^■]' end='$'
syn region  gihyoHeader3    start='^■■■[^■]' end='$'
syn region  gihyoHeader4    start='^■■■■[^■]' end='$'
syn region  gihyoBullet    start='^・' end='$'
syntax         region   gihyoPoint       start='^●' end='$'
syntax         region   gihyoHead        start='^◆' end='$'
syntax         region   gihyoLead        start='^▲' end='$'

syntax         region  gihyoList        start=/\n====リスト/    end=/\n====\n\n/
syntax         region  gihyoTable       start=/^▼表-----$/     end=/^\{-}-----\n/
syntax         region  gihyoCode        start=/^▼コード-----$/ end=/^\{-}-----\n/
syntax         region  gihyoCode        start=/\n▼リスト/      end=/\n.\{-}\n\n/
syntax         region  gihyoCommand     start=/\n==コマンド\n/  end=/\n==.\{-}\n\n/

syntax         region  gihyoTable       start=/^▼構文-----$/   end=/^\{-}-----\n/

" highlight link
highlight      link    gihyoHeader1 Title
highlight      link    gihyoHeader2    Title
highlight      link    gihyoHeader3 Statement
highlight      link    gihyoHeader4 Statement
highlight      link    gihyoSubTitle    Title
highlight      link    gihyoLead        Special
highlight      link    gihyoHead        Statement
highlight      link    gihyoList        Special
highlight      link    gihyoTable       Special
highlight      link    gihyoCode        Statement
highlight      link    gihyoCommand     PreProc
highlight      link    gihyoBullet      Identifier
highlight      link    gihyoPoint       Identifier

highlight      link    gihyoRuler       Special
highlight      link    gihyoURL         Underlined
highlight      link    gihyoTodo        Todo
highlight      link    gihyoNotUseChar  Error

highlight      link    gihyoDStrong     PreProc
highlight      link    gihyoSStrong     PreProc
" syntax region txtDialog matchgroup=Normal start=+「+ end=+」+ contains=txtDialog
" hi link txtDialog Constant
hi!            link    NonText          Comment

finish

==============================================================================
技術評論社 記事執筆用 シンタックスハイライトファイル ちょっと変更板
------------------------------------------------------------------------------
$VIMRUNTIMEPATH/syntax/gihyo.vim
==============================================================================
author  : 小見 拓
url     : http://nanasi.jp/
email   : mail@nanasi.jp
version : 2011/02/17 13:00:00
==============================================================================
技術評論社の記事用のシンタックスファイル．


・見出しのレベルは■■■を使用する。最大3段階。
■■■ 見出し大
■■ 見出し中
■ 見出し小


・リード線
▲（リード）


・テーブル
▼表
A   B   C   D
A   B   C   D
A   B   C   D
A   B   C   D


・コード 書き方その1
====リスト
- AAAAAAAA
- BBBBBBBB
- CCCCCCCC
====


・コード 書き方その2
▼リスト
$a = mt_rand(0, 8);
$a = mt_rand(0, 8);
$a = mt_rand(0, 8);


・コマンド
==コマンド
tar cf - foo var | (cd bk; tar xpf -)
:write book.txt
==


・箇条書き
* 項目1
* 項目2
* 項目3
- 項目1
- 項目2
- 項目3
・ 項目1
・ 項目2
・ 項目3


・URL
http://example.com/
https://example.com/
ftp://example.com/


・TODO
TODO 何々する


・使ってはいけない文字（追加削除は適当に）
[Ａ-Ｚａ-ｚ０-９]


・文字列
"a text"
'b text'


・区切り線（ドキュメント、非ドキュメント分離用）
==================================================

--------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++


==============================================================================
" vim:set et syntax=vim nowrap :
s
