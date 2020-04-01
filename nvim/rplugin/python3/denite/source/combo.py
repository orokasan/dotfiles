from denite.kind.word import Kind as Word
from .base import Base

class Source(Base):

    def __init__(self, vim):
        super().__init__(vim)
        self.name = 'combo'
        self.kind = Kind(vim)

    def on_init(self, context):
        pass

    def on_close(self, context):
        pass

    def gather_candidates(self, context):
        candidates = []
        normal = ['5', '2','6', 'j', 'j6','j2', 'D']
        special = ['236', '214', 'j236', '63214']
        tech = normal + special
        for l in tech:
             candidates += [{
                    'word': l,
                    'action__text': l,
                    }]
        return candidates

class Kind(Word):
    def __init__(self, vim):
        super().__init__(vim)

        self.persist_actions += [] #pylint: disable=E1101
        self.redraw_actions += [] #pylint: disable=E1101
        self.default_action = 'next'
        self.name = 'combo'
        self.space = ' -> '

    def action_A(self, context):
        target = context['targets'][0]
        target['action__text'] = target['word'] + 'A' + self.space
        self.action_append(context)
    def action_B(self, context):
        target = context['targets'][0]
        target['action__text'] = target['word'] + 'B' + self.space
        self.action_append(context)
    def action_C(self, context):
        target = context['targets'][0]
        target['action__text'] = target['word'] + 'C' + self.space
        self.action_append(context)

    def action_prefix(self, context):
        prefix = str(self.vim.call('denite#util#input',
                                  'Input prefix:',
                                  '',
                                  ''))
        button = str(self.vim.call('denite#util#input',
                                  'Input button:',
                                  '',
                                  ''))
        target = context['targets'][0]
        target['action__text'] = prefix + target['word'] + button + self.space
        self.action_append(context)

    def action_any(self, context):
        button = str(self.vim.call('denite#util#input',
                                  'Input button:',
                                  '',
                                  ''))
        target = context['targets'][0]
        target['action__text'] = target['word'] + button + self.space
        self.action_append(context)

    def action_undo(self, context):
        self.vim.command('undo')

