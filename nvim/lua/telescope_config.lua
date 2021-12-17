local telescope = require('telescope')
local action_layout = require('telescope.actions.layout')
local actions = require('telescope.actions')

require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    mappings = {
         n = {
           ['p'] = action_layout.toggle_preview,
           ['q'] = actions.close,
         },
         i = {
           -- ['<esc>'] = actions.close,
         },
       },
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    winblend = 10,
    border = {},
    borderchars = { '-', '|', '-', '|', '+', '+', '+', '+' },
    color_devicons = true,
    use_less = true,
    -- path_display = {"shorten"},
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
  }
}
-- local dropdown_theme = require('telescope.themes').get_dropdown({
--   results_height = 20;
--   winblend = 20;
--   width = 0.8;
--   prompt_title = '';
--   prompt_prefix = 'Files>';
--   previewer = false;
--   borderchars = {
--     prompt = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
--     results = {' ', '▐', '▄', '▌', '▌', '▐', '▟', '▙' };
--     preview = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
--   };
-- })
