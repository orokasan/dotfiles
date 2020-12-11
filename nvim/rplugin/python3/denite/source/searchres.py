from .base import Base
from denite.util import abspath

LINE_NUMBER_SYNTAX = (
    'syntax match deniteSource_lineNumber '
    r'/\d\+:/ '
    'contained containedin=')
LINE_NUMBER_HIGHLIGHT = 'highlight default link deniteSource_lineNumber Constant'


class Source(Base):

    def __init__(self, vim):
        super().__init__(vim)
        self.name = 'searchres'
        self.kind = 'file'
        self.sorters = []
        self.matcher = ['matcher/regexp']

    def on_init(self, context):
        context['__bufnr'] = self.vim.current.buffer.number

    def gather_candidates(self, context):
        candidates = []
        bufnr = context['__bufnr']
        result = []
        pattern = self.vim.eval('@/')
        result = self.vim.call('searchres#getsearchresult', pattern)
        for res in result:
            word = self.vim.call('getline', res[0])
            line = [{
                    'word': word,
                    'abbr': "{0:>3}: {1}".format(res[0], word),
                    'action__bufnr': bufnr,
                    'action__path': abspath(self.vim,
                                            self.vim.current.buffer.name),
                    'action__line': res[0],
                    'action__col': res[1],
                    'action__text': word
                    }]
            candidates += line
        if not candidates:
            self.vim.call('denite#util#print_error', 'searchres: No matches.')
        return candidates

    def highlight(self) -> None:
        self.vim.command(LINE_NUMBER_SYNTAX + self.syntax_name)
        self.vim.command(LINE_NUMBER_HIGHLIGHT)

        MATCHED_WORD_SYNTAX = (
            'syntax match deniteSource_matchedWord '
            '/' + self.vim.eval('@/') + '/ '
            'contained containedin=')
        MATCHED_WORD_HIGHLIGHT = 'highlight default link deniteSource_matchedWord Function'
        self.vim.command(MATCHED_WORD_SYNTAX + self.syntax_name)
        self.vim.command(MATCHED_WORD_HIGHLIGHT)
