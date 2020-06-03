import re
from .base import Base

HIGHLIGHT_SYNTAX = [
    {'name': 'Level1',     'link': 'Title',  're': r'■\s'},
    {'name': 'Level2',     'link': 'Function',  're': r'■■\s'},
    {'name': 'Level3',     'link': 'Statement',  're': r'■■■\s'},
    {'name': 'Level4',     'link': 'Constant',  're': r'■■■■\s'},
    {'name': 'Level5',     'link': 'PreProc',  're': r'■■■■■\s'},
    # {'name': 'Prefix',   'link': 'Constant',  're': r'\d\+\s[\ ahu%#]\+\s'},
    # {'name': 'Info',     'link': 'PreProc',   're': r'\[.\{-}\] '},
    # {'name': 'Modified', 'link': 'Statement', 're': r'+\s'},
    # {'name': 'NoFile',   'link': 'Function',  're': r'\[nofile\]'},
    # {'name': 'Time',     'link': 'Statement', 're': r'(.\{-})'},
]

class Source(Base):
    def __init__(self, vim):
        super().__init__(vim)
        self.name = 'text'
        self.kind = 'file'

    def on_init(self, context):
        context['__bufnr'] = str(self.vim.call('bufnr', '%'))

    def highlight(self) -> None:
        for syn in HIGHLIGHT_SYNTAX:
            self.vim.command(
                'syntax match {0}_{1} /{2}/ contained containedin={0}'.format(
                    self.syntax_name, syn['name'], syn['re']))
            self.vim.command(
                'highlight default link {}_{} {}'.format(
                    self.syntax_name, syn['name'], syn['link']))

    def gather_candidates(self, context):
        if self.vim.eval('&filetype') != 'text':
            self.vim.call('denite#util#print_error', 'This file is not a gihyo text file.')
            return []
        else:
            return [self._convert(context, header) for header in self._find_headers()]

    def _convert(self, context, header):
        level = len(header['level'])
        return {
                'abbr': '■' * level + '  ' + header['text'],
                'word': header['text'],
                'action__path': self.vim.call('bufname', context['__bufnr']),
                'action__line': header['lnum']
                }

    def _find_headers(self):
        headers = []
        codeblock = r'^`{3,}.*$'
        in_codeblock = False
        for i in range(1, self.vim.call('line', '$') + 1):
            line = self.vim.call('getline', i)
            if re.match(codeblock, line):
                in_codeblock = not in_codeblock
            match = re.match(r'^(■+)\s*(.+)$', line)
            if match and not in_codeblock:
                level = match.group(1)
                text = (len(level) - 1) * '  ' + match.group(2)
                headers.append({
                    'level': level,
                    'text': text,
                    'lnum': i
                    })
        return headers
