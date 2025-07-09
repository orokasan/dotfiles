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
      himalaya         = {
        defaultAction = 'open',
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
      github_issue     = {
        defaultAction = 'open'
      }
    },
    kindParams = {
      file = {
        trashCommand = vim.call("has", "Win32") and { 'cmd', '/c', 'npx', 'trash' } or { 'gio', 'trash' }
      }
    },
    sourceOptions = {
      _ = {
        matchers = { 'merge' },
        ignoreCase = true,
        columns = {},
        converters = { 'converter_no_empty', 'converter_highlight_filename', 'converter_nerdfont' },
      },
      action = {
        matchers = { 'matcher_fzy' },
      },
      ddu_history = {
        defaultAction = 'start',
      },
      line = {
        defaultAction = 'open',
      },
      dein_update = {
        matchers = { 'matcher_dein_update' },
      },
      jump = {
        defaultAction = 'jump'
      },
      textlint = { defaultAction = 'highlight', converters = {} },
      markdown = {
        defaultAction = 'open',
      },
      junkfile = { matchers = { 'matcher_fzy', 'filter_hidden' } },
      file_external = { matchers = { 'merge' } },
      file = {
        matchers = { 'filter_hidden', 'merge' },
        sorters = { 'sorter_time', 'sorter_reversed' },
      },
      buffer = { converters = { 'converter_highlight_filename', 'converter_nerdfont' } },
      grep = { converters = {}, },
      dirmark = { sorters = { { name = 'sorter_time', params = { force = true } }, { name = 'sorter_reversed' } }, converters = {}, },
      tree = { sorters = { }, converters = { { name = 'converter_highlight_filename' }, { name = 'converter_nerdfont' }, { name = 'filter_hidden', params = { hiddenPath = { 'NTUSER', 'ntuser', 'desktop.ini', 'prh' } } } } },
      dein = { sorters = {} },
      text = { converters = {} },
      aerial = {
        converters = {},
        defaultAction = 'highlight',
      },
      git_status = {
        matchers = { 'git_status_highlight' },
        converters = {}
      },
      git_ref = {
        matchers = { 'git_ref_set_remote_state', 'git_ref_highlight' },
        converters = {}
      },
      miniyank = { converters = {} },
      searchres = { matchers = { 'highlight_searchres', 'merge' } },
      file_old = { matchers = { 'converter_unique', 'matcher_fzy', }, converters = { 'converter_highlight_filename', }, },
      mr = {
        matchers = { 'merge' },
        converters = { 'converter_relative', 'converter_unique', 'converter_highlight_filename', 'converter_nerdfont' },
        sorters = {},
      },
    },
    actionParams = {
      executeSystem = {
        method = "windows-rundll32"
      }
    },
    profile = false,
    ui = 'ff',
    sync = false,
    sourceParams = {
      mr = {
        current = false
      },
      tab = {
        format = "tab|%n:%w",
      },
      buffer = {
        orderby = 'desc'
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
    uiOptions = {
      _ = {
        filterPrompt = '  # ',
      },
    },
    uiParams = {
      ff = {
        previewFloating = true,
        filterFloatingPosition = 'top',
        floatingBorder = 'none',
        highlights = {
          prompt = 'Function',
          selected = 'Visual',
          filterText = 'Title'
        },
        winwidth = vim.o.columns - 1,
        prompt = '# ',
        direction = 'botright',
        displaySourceName = 'no',
        statusline = false,
        previewWidth = math.ceil(vim.o.columns / 2),
        previewCol = math.ceil(vim.o.columns / 2),
        previewHeight = 20,
        previewSplit = "vertical",
        ignoreEmpty = false,
        displayTree = false,
        autoAction = {
          name = 'preview'
        },
        focus = true,
      },
      filer = {
        previewFloating = true,
        split = 'vertical',
        direction = 'botright',
        winWidth = 40,
        displaySourceName = 'no',
        statusline = false,
        previewVertical = true,
        previewWidth = vim.o.columns / 2,
        previewHeight = 20,
        focus = true,
      },
      filer_tab = {
        previewFloating = true,
        split = 'tab',
        direction = 'botright',
        displaySourceName = 'no',
        statusline = false,
        previewVertical = true,
        previewWidth = vim.o.columns / 2,
        previewHeight = 20,
      },
    },
    filterParams = {
      matcher_kensaku = { highlightMatched = 'Title' },
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
      filter_hidden = {
        hiddenPath = { 'NTUSER', 'ntuser', 'desktop.ini' }
      }
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
      unzip = {
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
      rename = { quit = false },
      newFile = { quit = false },
      newDirectory = { quit = false },
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
  'filer',
  {
    ui = 'filer',
    resume = true,
    sources = { {
      name = 'file'
    } },
    uiOptions = {
      filer = {
        persist = true,
        restoreCursor = true,
      }
    },
    uiParams = {
      filer = {
        sort = 'filename',
        sortTreesFirst = true,
        focus = true,
      }
    },
    sourceOptions = {
      _ = {
        columns = { 'icons' },
        converters = {}
      }
    },
    columnParams = {
      icons = {
        isTree = true,
        padding = 2,
      }
    },
    actionOptions = {
      _ = {
        quit = true,
      },
      narrow = {
        quit = false
      },
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
      },
    },
    uiParams = {
      ff = {
        split = 'vertical',
        splitDirection = 'belowright',
        winRow = 2,
        winWidth = 45,
        winHeight = vim.o.lines - 5,
        winCol = vim.o.columns - 50,
        focus = true,
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
        hlGroup = ''
      }
    },
    actionOptions = {
      _ = {
        quit = true,
      },
    }
  }
)
