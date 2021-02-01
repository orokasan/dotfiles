import re
import unicodedata
from .base import Base

HIGHLIGHT_SYNTAX = [
    {'name': 'Level1',     'link': 'Title',  're': r'■\s'},
    {'name': 'Level2',     'link': 'Constant',  're': r'■■\s'},
    {'name': 'Level3',     'link': 'Statement',  're': r'■■■\s'},
    {'name': 'Level4',     'link': 'Constant',  're': r'■■■■\s'},
    {'name': 'Level5',     'link': 'PreProc',  're': r'■■■■■\s'},
    {'name': 'lnum',     'link': 'Comment',  're': r'\d\+\s*:\s'},
]

class Source(Base):
    def __init__(self, vim):
        super().__init__(vim)
        self.name = 'text'
        self.kind = 'file'

    def on_init(self, context):
        context['__bufnr'] = self.vim.current.buffer.number

    def highlight(self) -> None:
        for syn in HIGHLIGHT_SYNTAX:
            self.vim.command(
                'syntax match {0}_{1} /{2}/ contained containedin={0}'.format(
                    self.syntax_name, syn['name'], syn['re']))
            self.vim.command(
                'highlight default link {}_{} {}'.format(
                    self.syntax_name, syn['name'], syn['link']))

    def gather_candidates(self, context):
        header = self._find_headers(context)
        candidate = []
        for h in header:
            candidate.append(self._convert(context, h))
        return  candidate

    def _convert(self, context, header):
        abbr = '{}: {} {}'.format(str(header['lnum']).ljust(len(str(self.vim.call('line', '$'))), ' '),text_align(str('■'*header['level']), context['__max_level']*2),   header['text'])
        return {
                'abbr': abbr,
                'word': header['text'],
                'action__path': self.vim.call('bufname', context['__bufnr']),
                'action__line': header['lnum']
                }


    def _find_headers(self, context):
        headers = []
        # codeblock = r'^`{3,}.*$'
        in_codeblock = False
        max_level = 0
        limit_level = int(context['args'][0]) if context['args'] else 0
        for [i, x] in enumerate(self.vim.call('getbufline', context['bufnr'], 1, '$')):
            line = x
            # if re.match(codeblock, line):
            #     in_codeblock = not in_codeblock
            match = re.match(r'^(■+)\s*(.+)$', line)
            # if match and not in_codeblock:
            if match:
                level = len(match.group(1))
                if max_level < level:
                    max_level = level 
                text = match.group(2)
                if limit_level and level > limit_level:
                    continue
                headers.append({
                    'level': level,
                    'text': text,
                    'lnum': i,
                    })
        context['__max_level'] = max_level
        return headers

def get_han_count(text):
    count = 0
    for char in text:
        if unicodedata.east_asian_width(char) in 'FWA':
            count += 2
        else:
            count += 1
    return count

def text_align(text, width, *, align=-1, fill_char=' '):
    fill_count = width - get_han_count(text)
    if (fill_count <= 0): return text
    if align < 0:
        return text + fill_char*fill_count
    else:
        return fill_char*fill_count + text
