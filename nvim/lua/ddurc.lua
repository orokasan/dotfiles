vim.fn["ddu#custom#patch_global"](
  {
    kindOptions = {
      file             = {
        defaultAction = 'my_open',
      },
      word             = { defaultAction = 'append' },
      action           = { defaultAction = 'do' },
      help             = { defaultAction = 'my_open' },
      dein_update      = {
        defaultAction = 'viewDiff',
      },
      git_tag          = {
        defaultAction = 'switch',
      },
      git_branch       = {
        defaultAction = 'switch',
      },
      git_working_tree = {
        defaultAction = 'add',
      },
      git_index        = {
        defaultAction = 'commitAll'
      },
      lsp              = {
        defaultAction = 'open'
      },
      lsp_codeAction   = {
        defaultAction = 'apply'
      },
    },
    sourceOptions = {
      _ = {
        matchers = { 'merge' },
        ignoreCase = true,
        columns = { 'icons' },
      },
      action = {
        matchers = { 'matcher_fzy' },
      },
      aerial = {
        matchers = { 'matcher_fzy' },
      },
      line = {
        defaultAction = 'open',
        matchers = { 'matcher_fzy' },
      },
      dein_update = {
        matchers = { 'matcher_dein_update' },
      },
      jump = {
        defaultAction = 'jump'
      },
      textlint = { defaultAction = 'highlight', columns = {} },
      markdown = {
        defaultAction = 'open',
      },
      junkfile = { matchers = { 'matcher_fzy', 'matcher_hidden' } },
      file_external = { matchers = { 'merge' }, converters = {} },
      file = {
        matchers = { 'matcher_hidden', 'merge' },
        converters = { 'converter_no_empty', 'converter_highlight_filename' },
        sorters = { 'sorter_time' },
      },
      buffer = { matchers = { 'merge' }, converters = { 'converter_highlight_filename' } },
      grep = { matchers = { 'merge' }, columns = {}, },
      dirmark = { sorters = { 'sorter_time' }, columns = {}, },
      dein = { sorters = {} },
      text = { columns = {} },
      git_status = {
        matchers = { 'git_status_highlight' },
        columns = {}
      },
      git_ref = {
        matchers = { 'git_ref_set_remote_state', 'git_ref_highlight' },
        columns = {}
      },
      miniyank = { columns = {} },
      searchres = { matchers = { 'highlight_searchres', 'merge' } },
      file_old = { matchers = { 'converter_unique', 'matcher_fzy', }, converters = { 'converter_highlight_filename', }, },
      mr = {
        matchers = { 'merge', },
        converters = { 'converter_relative', 'converter_unique', 'converter_highlight_filename' },
        sorters = {},
      },
    },
    profile = false,
    ui = 'ff',
    sync = false,
    sourceParams = {
      mr = {
        current = false
      },
      buffer = {
        orderby = 'asc'
      },
      grep = {
        highlights = { path = 'Comment', lineNr = 'LineNr', word = 'Function' },
        args = { "rg", "--column", "--no-heading", "--color", "never", '--json', '--smart-case' },
      },
      grep_all = {
        highlights = { path = 'Comment', lineNr = 'LineNr', word = 'Function' },
        args = { "rga", "--column", "--no-heading", "--color", "never", '--json', '--smart-case' },
      },
      jvgrep = {
        highlights = { path = 'Comment', lineNr = 'LineNr', word = 'Function' },
        args = { "jvgrep", "-i", "--no-color", "-r", "-I", '-R' },
      },
      file_external = {
        cmd = { 'rg', '--files', '--color', 'never', '--no-binary' },
        updateItems = 5000,
      },
      markdown = {
        style = '',
        chunkSize = 5,
        limit = 1000,
      },
    },
    uiParams = {
      ff = {
        previewFloating = true,
        filterSplitDirection = 'floating',
        filterFloatingPosition = 'top',
        floatingBorder = 'none',
        highlights = {
          prompt = 'Function',
          selected = 'Title',
          filterText = 'Normal'
        },
        winwidth = vim.o.columns - 1,
        prompt = '# ',
        direction = 'botright',
        displaySourceName = 'no',
        statusline = false,
        previewWidth = math.ceil(vim.o.columns / 2),
        previewCol = math.ceil(vim.o.columns / 2),
        previewHeight = 15,
        previewSplit = "vertical",
        ignoreEmpty = false,
        displayTree = false,
        autoAction = {
          name = 'preview'
        }
      },
      filer = {
        previewFloating = true,
        filterSplitDirection = 'floating',
        split = 'vertical',
        highlights = {
          prompt = 'Function'
        },
        prompt = ' #',
        direction = 'botright',
        winWidth = 40,
        displaySourceName = 'no',
        filterUpdateTime = 0,
        statusline = false,
        previewVertical = true,
        previewWidth = vim.o.columns / 2,
        previewHeight = 20,
      },
    },
    filterParams = {
      matcher_kensaku = { highlightMatched = 'Constant' },
      merge = {
        filters = {
          { name = 'matcher_kensaku', weight = 5.0 },
          { name = 'matcher_fzy',     weight = 1.0 },
        },
        unique = true,
      },
      matcher_fzy = {
        threshold = 0.1,
      },
      matcher_substring = {
        highlightMatched = 'Title',
      },
    },
    columnParams = {
      filename = {
        highlights = { directoryName = 'Function', directoryIcon = 'Constant' },
        collapsedIcon = '+',
        expandedIcon = '-',
        iconWidth = 1
      },
      icons = {
        isTree = true,
        ignoreMatcherHighlight = { "hl_dirname" },
        padding = 2,
      },
    },
    actionOptions = {
      _ = {
        quit = true,
      },
      echo = {
        quit = false,
      },
      echoDiff = {
        quit = false,
      },
      preview = {
        previewCmds = {},
      },
      file_rec = { quit = false },
      get_context = { quit = false },
      to_filer = { quit = true },
      my_open = { quit = false },
      narrow = { quit = false },
      cd = { quit = false },
      replace = { quit = false },
    },
  }
)

vim.fn["ddu#custom#patch_local"](
  'select',
  {
    ui = 'ff',
    uiParams = {
      ff = {
        split = 'floating',
        winRow = vim.o.lines - 20,
        winWidth = vim.o.columns - 10,
        winHeight = 15,
        winCol = 5,
      }
    }

  }
)
vim.fn["ddu#custom#patch_local"](
  'side',
  {
    ui = 'ff',
    refresh = true,
    resume = true,
    uiOptions = {
      ff = {
        persist = false,
        restoreCursor = true,
      }
    },
    uiParams = {
      ff = {
        split = 'vertical',
        winRow = 2,
        winWidth = 45,
        winHeight = vim.o.lines - 5,
        winCol = vim.o.columns - 50,
      }
    },
    sourceOptions = {
      _ = {
        columns = {},
        defaultAction = 'open'
      }
    },
    filterParams = {
      fzy = {
        hlEnable = false
      }
    },
    actionOptions = {
      _ = {
        quit = true,
      },
    }
  }
)
