import re
from .base import Base
# from denite.kind.file import Kind as File

HIGHLIGHT_SYNTAX = [
    {'name': 'Level1',     'link': 'Title',  're': r'■\s'},
    {'name': 'Level2',     'link': 'Constant',  're': r'■■\s'},
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
        context['__bufnr'] = self.vim.call('bufnr', '%')
        context['__init_pos'] = self.vim.call('line', '.')

    def highlight(self) -> None:
        for syn in HIGHLIGHT_SYNTAX:
            self.vim.command(
                'syntax match {0}_{1} /{2}/ contained containedin={0}'.format(
                    self.syntax_name, syn['name'], syn['re']))
            self.vim.command(
                'highlight default link {}_{} {}'.format(
                    self.syntax_name, syn['name'], syn['link']))

    def gather_candidates(self, context):
        # if self.vim.eval('&filetype') != 'text':
        #     self.vim.call('denite#util#print_error', 'This file is not a gihyo text file.')
        #     return []
        # else:
        candidate = [self._convert(context, header) for header in self._find_headers(context)]
        self.vim.vars['denite_text_pos'] = context['cursor']
        return  candidate

    def _convert(self, context, header):
        level = len(header['level'])
        return {
                'abbr': '■' * level + '  ' + header['text'],
                'word': header['text'],
                'action__path': self.vim.call('bufname', context['__bufnr']),
                'action__line': header['lnum']
                }

    def _find_headers(self, context):
        headers = []
        codeblock = r'^`{3,}.*$'
        in_codeblock = False
        context['cursor'] = 0
        number = 0
        t = 1
        for i in range(1, self.vim.call('line', '$') + 1):
            line = self.vim.call('getline', i)
            if re.match(codeblock, line):
                in_codeblock = not in_codeblock
            match = re.match(r'^(■+)\s*(.+)$', line)
            if match and not in_codeblock:
                number += 1
                level = match.group(1)
                text = match.group(2)
                # text = (len(level) - 1) * ' ' + match.group(2)
                headers.append({
                    'level': level,
                    'text': text,
                    'lnum': i,
                    'number': number
                    })
                if i < context['__init_pos'] and number:
                    context['cursor'] = number
                else:
                    t = 0
        return headers

# class Kind(File):
#     def __init__(self, vim):
#         super().__init__(vim)

#         self.name = 'text'
#         self.persist_actions += [] #pylint: disable=E1101
#         self.redraw_actions += ['move'] #pylint: disable=E1101
#         self.default_action = 'move'

#     def action_move(self, context):
#         target = context['targets'][0]
#         if 'action__bufnr' in target:
#             bufnr = target['action__bufnr']
#         else:
#             bufnr = self.vim.call('bufnr', target['action__path'])
#         self._jump(context, target)

#     def _jump(self, context, target):
#         if 'action__pattern' in target:
#             self.vim.call('search', target['action__pattern'], 'w')

#         line = int(target.get('action__line', 0))
#         col = int(target.get('action__col', 0))

#         try:
#             if line > 0:
#                 self.vim.call('cursor', [line, 0])
#                 if 'action__col' not in target:
#                     pos = self.vim.current.line.lower().find(
#                         context['input'].lower())
#                     if pos >= 0:
#                         self.vim.call('cursor', [0, pos + 1])
#             if col > 0:
#                 self.vim.call('cursor', [0, col])
#         except Exception:
#             pass

#         # Open folds
#         self.vim.command('normal! zv')
