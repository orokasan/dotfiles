# -*- coding: utf-8 -*-

from .base import Base
import re

class Source(Base):

    def __init__(self, vim):
        super().__init__(vim)
        self.name = 'runtimepath'
        self.kind = 'file'
        self.default_action = 'dexf'

    # def on_init(self, context):
    #     context['__bufnr'] = str(self.vim.call('bufnr', '%'))

    def gather_candidates(self, context):
        rtp = self.vim.eval('&rtp')
        rtp = rtp.split(',')
        for x in rtp:
            candidate = {'word': x, 'action_path': x}
        return candidate
