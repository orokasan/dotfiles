# -*- coding: utf-8 -*-

from .base import Base
import unicodedata


MARK_HIGHLIGHT_SYNTAX = [
    {'name': 'Lint', 'link': 'Function',  're': r'\s\[\zs.\+\ze\]'},
    {'name': 'NR', 'link': 'Special',   're': r'\d\+\ze:.'},
]


class Source(Base):

    def __init__(self, vim):
        super().__init__(vim)
        self.name = 'ale'
        self.kind = 'file'

    def on_init(self, context):
        context['__bufnr'] = str(self.vim.call('bufnr', '%'))

    def gather_candidates(self, context):
        loclist = self.vim.call('ale#engine#GetLoclist', context['__bufnr'])
        return [self._convert(loc) for loc in loclist]

    def _convert(self, info):
        linter = info['code'] if 'code' in info else []
        if info['linter_name'] == 'textlint':
            linter = info['code'].split('/')
        else:
            linter = [info['linter_name']]
        mark = '■'
        line = self.vim.call('getline', info['lnum'])
        col = info['col']
        line = line[0:col] + mark + line[col:len(line)]
        r_col = self._len_checker(line)
        abbr = '{0[lnum]}: {0[text]} [{1}] '.format(info, linter[-1])
        return {
                'word': info['text'],
                'abbr': abbr,
                'action__path': self.vim.call('bufname', info['bufnr']),
                'action__line': info['lnum'],
                'action__col': r_col
                }

    def _len_checker(self, text):
        count = 0
        for c in text:
            if unicodedata.east_asian_width(c) in 'A':
                break
            elif unicodedata.east_asian_width(c) in 'FW':
                count += 3
            else:
                count += 1
        return count

    def highlight(self) -> None:
        for syn in MARK_HIGHLIGHT_SYNTAX:
            self.vim.command(
                'syntax match {0}_{1} /{2}/ contained containedin={0}'.format(
                    self.syntax_name, syn['name'], syn['re']))
            self.vim.command(
                'highlight default link {}_{} {}'.format(
                    self.syntax_name, syn['name'], syn['link']))

