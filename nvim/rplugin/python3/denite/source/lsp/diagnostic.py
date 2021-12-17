from denite.base.source import Base
from denite.util import debug, clear_cmdline, strwidth

HIGHLIGHT_SYNTAX = [
    {'name': 'lnum',     'link': 'Comment',  're': r'\d\+\s*:\d\+\s'},
    {'name': 'error',     'link': 'Error',  're': r'\[error\]'},
    {'name': 'warning',     'link': 'Warning',  're': r'\[warning\]'},
    {'name': 'line',     'link': 'Comment',  're': r'|.*'},
]


class Source(Base):
    def __init__(self, vim):
        super().__init__(vim)
        self.name = 'lsp/diagnostic'
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
        candidates = []
        tbl = self.vim.call(
            'luaeval', 'vim.diagnostic.get(' + str(context['__bufnr']) + ')')
        for i in tbl:
            lnum = i['lnum'] + 1
            col = i['col'] + 1
            line = self.vim.call('getbufline', context['__bufnr'], lnum)
            severity = i['severity']
            if 'source' in i:
                source = '(' + i['source'] + ')'
            else:
                source = ''
            mes = ''
            word = i['message']
            if severity == 1:
                mes = 'error'
            elif severity == 2:
                mes = 'warning'
            elif severity == 3:
                mes = 'information'
            elif severity == 4:
                mes = 'hint'
            candidates.append({
                'word': word,
                'abbr': '{}:{} [{}] {} {}'.format(
                    str(lnum).ljust(3), str(col).ljust(3), mes, word, source),
                'action__path': self.vim.call('bufname', context['__bufnr']),
                'action__line': lnum,
                'action__col': col,
                'action__text': line
            })
        return candidates
