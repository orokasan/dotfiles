#!/usr/bin/perl
$latex = 'uplatex -kanji=utf-8 -halt-on-error -synctex=1 -interaction=nonstopmode -file-line-error %S';
$pdf_update_method = 2;
# $makeindex = 'mendex -r -c -s jind.ist';
$max_repeat       = 5;
# # Prevent latexmk from removing PDF after typeset.
# $pvc_view_file_via_temporary = 0;

# $latex = 'uplatex %O -synctex=1 -interaction=nonstopmode %S';
$pdflatex = 'pdflatex %O -synctex=1 -interaction=nonstopmode %S';
$lualatex = 'lualatex %O -synctex=1 -interaction=nonstopmode %S';
$xelatex = 'xelatex %O -synctex=1 -interaction=nonstopmode %S';
$biber = 'biber %O --bblencoding=utf8 -u -U --output_safechars %B';
$bibtex = 'upbibtex %O %B';
$dvipdf = 'dvipdfmx %O -o %D %S';
$dvips = 'dvips %O -z -f %S | convbkmk -u > %D';

# $makeindex = 'upmendex %O -o %D %S';
$ps2pdf = 'ps2pdf %O %S %D';
$pdf_mode = 3;
if ($^O eq 'darwin') {
$pvc_view_file_via_temporary = 0;
$pdf_previewer = 'open -ga /Applications/Skim.app';
} else {
$pdf_previewer = 'xdg-open';
}

