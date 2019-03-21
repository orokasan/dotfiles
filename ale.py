# -*- coding: utf-8 -*-
#~/vimfiles/dein/repo/github.com/iyuuya/denite-ale/rplugin/python3/denite/source/ale.py
from .base import Base


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
#modified to output same txt message to Denite
    def _convert(self, info):
        abbr = '[%d:%d] %s' % (info['lnum'], info['col'], info['text'])
        myword = '[%d:%d] %s' % (info['lnum'], info['col'], info['text'])
        return {
                'word': myword,
                'abbr': abbr,
                'action__path': self.vim.call('bufname', info['bufnr']),
                'action__line': info['lnum'],
                'action__col': info['col']
                }
