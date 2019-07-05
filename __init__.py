# ============================================================================
# FILE: file.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================
#~/.cache/dein/repos/github.com/Shougo/denite.nvim/rplugin/python3/denite/source/file/__init__.py

import glob
import os

from denite.base.source import Base
from denite.util import abspath, expand


FILE_HIGHLIGHT_SYNTAX = [
    {'name': 'Name',     'link': 'Function',  're': r'[^/]\+.\ze\/'},
    {'name': 'NoFile',   'link': 'Constant', 're': r'\[new\]'}
]
class Source(Base):

    def __init__(self, vim):
        super().__init__(vim)

        self.name = 'file'
        self.kind = 'file'
        self.matchers = ['matcher/fuzzy', 'matcher/hide_hidden_files']

    def highlight(self):
        for syn in FILE_HIGHLIGHT_SYNTAX:
            self.vim.command(
                'syntax match {0}_{1} /{2}/ contained containedin={0}'.format(
                    self.syntax_name, syn['name'], syn['re']))
            self.vim.command(
                'highlight default link {}_{} {}'.format(
                    self.syntax_name, syn['name'], syn['link']))

    def gather_candidates(self, context):
        context['is_interactive'] = True
        candidates = []
        path = (context['args'][1] if len(context['args']) > 1
                else context['path'])
        path = abspath(self.vim, path)
        inp = expand(context['input'])
        filename = (inp if os.path.isabs(inp) else os.path.join(path, inp))
        if context['args'] and context['args'][0] == 'new':
            candidates.append({
                'word': filename,
                'abbr': '[new] ' + filename,
                'action__path': abspath(self.vim, filename),
            })
        else:
            glb = os.path.dirname(filename) if os.path.dirname(
                filename) != '/' else ''
            glb += '/.*' if os.path.basename(
                filename).startswith('.') else '/*'
            for f in glob.glob(glb):
                fullpath = abspath(self.vim, f)
                candidates.append({
                    'word': f,
                    'abbr': (os.path.relpath(f, path) if fullpath != path
                             else os.path.normpath(f)) + (
                                 '/' if os.path.isdir(f) else ''),
                    'kind': ('directory' if os.path.isdir(f) else 'file'),
                    'action__path': fullpath,
                })
        return candidates