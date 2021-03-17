"https://github.com/hallzy/lightline-iceberg/blob/master/autoload/lightline/colorscheme/iceberg.vim
" -----------------------------------------------------------------------------
" File: onedark.vim
" Description: Onedark colorscheme for Lightline (itchyny/lightline.vim)
" Author: hallzy <hallzy.18@gmail.com>
" Source: https://github.com/hallzy/lightline-onedark
" Last Modified: 18 Jun 2016
" -----------------------------------------------------------------------------



if exists('g:lightline')

  " These are the colour codes that are used in the original onedark theme
  let s:blue      = [ "#84a0c6", 110 ]
  let s:green     = [ "#98C379", 150 ]
  let s:lblue     = [ "#89b9c2", 109 ]
  let s:orange    = [ "#e2a578", 216 ]
  let s:purple    = [ "#a093c8", 140 ]
  let s:red       = [ "#e27878", 203 ]
  let s:normal_bg = [ "#161822", 234 ]
  let s:normal_fg = [ "#c7c9d1", 252 ]
  let s:grey      = [ '#6b7089', 238 ]
   let s:col_tabsel_bg   = ['#17171b', 234]
  let s:col_tabsel_fg = [ '#818596', 245]
    let s:col_tabfill_bg  = ['#0f1117', 238]
    let s:col_tabfill_fg  = ['#2e313f', 233]

  let s:p = {'normal':{}, 'inactive':{}, 'insert':{},'command':{}, 'replace':{}, 'visual':{}, 'tabline':{}}

  let s:p.normal.left     = [ [ s:normal_bg, s:green ], [ s:green, s:normal_bg ] ]
  let s:p.normal.right    = [ [ s:normal_bg, s:green ], [ s:green, s:normal_bg ] ]
  let s:p.normal.middle   = [ [ s:green, s:normal_bg ] ]


  let s:p.inactive.left   = [ [ s:normal_fg, s:normal_bg ], [ s:normal_fg, s:normal_bg ] ]
  let s:p.inactive.right  = [ [ s:normal_fg, s:normal_bg ], [ s:normal_fg, s:normal_bg ] ]
  let s:p.inactive.middle = [ [ s:normal_fg, s:normal_bg ] ]

  let s:p.insert.left     = [ [ s:normal_bg, s:blue ], [ s:blue, s:normal_bg ] ]
  let s:p.insert.right    = [ [ s:normal_bg, s:blue ], [ s:blue, s:normal_bg ] ]
  let s:p.insert.middle   = [ [ s:blue, s:normal_bg ] ]

  let s:p.command.left     = [ [ s:normal_bg, s:purple ], [ s:purple, s:normal_bg ] ]
  let s:p.command.right    = [ [ s:normal_bg, s:purple ], [ s:purple, s:normal_bg ] ]
  let s:p.command.middle   = [ [ s:purple, s:normal_bg ] ]

  let s:p.replace.left     = [ [ s:normal_bg, s:red ], [ s:red, s:normal_bg ] ]
  let s:p.replace.right    = [ [ s:normal_bg, s:red ], [ s:red, s:normal_bg ] ]
  let s:p.replace.middle   = [ [ s:red, s:normal_bg ] ]

  let s:p.visual.left     = [ [ s:normal_bg, s:orange ], [ s:orange, s:normal_bg ] ]
  let s:p.visual.right    = [ [ s:normal_bg, s:orange ], [ s:orange, s:normal_bg ] ]
  let s:p.visual.middle   = [ [ s:orange, s:normal_bg ] ]

  let s:p.tabline.tabsel  = [ [s:normal_bg, s:green] ]
  let s:p.tabline.left  = [ [s:grey, s:col_tabfill_bg] ]

  let s:p.tabline.right = copy(s:p.normal.right)

  let s:p.normal.error    = [ [ s:normal_bg, s:red ] ]
  let s:p.normal.warning  = [ [ s:normal_bg, s:orange ] ]


  let g:lightline#colorscheme#iceberg#palette = lightline#colorscheme#flatten(s:p)
endif
