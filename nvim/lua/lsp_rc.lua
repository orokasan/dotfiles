local vim = vim

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
    },
    -- linehl = {
    --     [vim.diagnostic.severity.ERROR] = 'Error',
    -- },
    -- numhl = {
    --     [vim.diagnostic.severity.WARN] = 'Question',
    -- },
  },
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    local buf = ev.buf

    -- デフォルトで設定されている言語サーバー用キーバインドに設定を追加する
    -- See https://neovim.io/doc/user/lsp.html#lsp-defaults
    -- 言語サーバーのクライアントがLSPで定められた機能を実装していたら設定を追加するという流れ

    if client:supports_method("textDocument/definition") then
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to definition" })
    end

    if client:supports_method("textDocument/hover") then
      vim.keymap.set("n", "K",
        function() vim.lsp.buf.hover({ border = "single" }) end,
        { buffer = buf, desc = "Show hover documentation" })
    end

    -- if client:supports_method("textDocument/completion") then
    --   vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    -- end

    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if not client:supports_method("textDocument/willSaveWaitUntil")
        and client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end

    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(ev.buf, ...) end

    local opts = { noremap = true, silent = true }
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references(nil, {on_list=on_list})<CR>', opts)
    buf_set_keymap('n', '<space>we', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.format({async = True})<CR>', opts)
  end
})

vim.diagnostic.config({ virtual_text = false })

vim.lsp.handlers["textDocument/hover"] = vim.lsp.buf.hover(
  {
    border = "single"
  })

for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
  vim.api.nvim_set_hl(0, group, {})
end

vim.api.nvim_exec2([[
  hi! link DiagnosticError Error
  hi! link DiagnosticWarning Warning
  ]], { output = false })

require("mason").setup {}

local servers = require('mason-lspconfig').get_installed_servers()
table.insert(servers, 'denols')

vim.lsp.semantic_tokens.enable(false)

for _, server in pairs(servers) do
  if server == 'efm' then
    vim.lsp.config(server, {
      autostart = false,
      filetypes = {
        'markdown',
        'text',
        'txt',
        'json',
        'html',
        'typescript',
        'css',
      },
      cmd = { 'efm-langserver', '-q' },
      root_markers = {
        ".textlintrc.json",
        ".textlintrc"
      },
      init_options = {
        autostart = false,
        documentFormatting = false,
        documentRangeFormatting = false,
        hover = false,
        documentSymbol = false,
        codeAction = true,
        completion = false,
      },
      settings = {
        -- debounce_text_changes = 1500,
        languages = {
          markdown = {
            {
              lintIgnoreExitCode = true,
              lintOnSave = false,
              lintStdin = true,
              lintCommand = [[textlint -f unix --stdin --stdin-filename ${INPUT}]],
              lintFormats = {
                '%f:%l:%c: %m [%trror/%r]',
                '%f:%l:%c: %m [%tarning/%r]',
                '%f:%l:%c: 【%r】 %m',
                '%E%f:%l:%c: %m',
                '%Z%m [%trror/%r]',
                '%Z%m [%tarning/%r]',
                '%C%m',
              }
            }
          },
          txt = {
            {
              lintIgnoreExitCode = true,
              lintOnSave = false,
              lintCommand = [[textlint -f unix --stdin --stdin-filename ${INPUT}]],
              -- lintCommand = [[textlint -f unix ${INPUT}]],
              lintStdin = true,
              lintFormats = {
                '%f:%l:%c: %m [%trror/%r]',
                '%f:%l:%c: %m [%tarning/%r]',
                '%f:%l:%c: 【%r】 %m',
                '%E%f:%l:%c: %m',
                '%Z%m [%trror/%r]',
                '%Z%m [%tarning/%r]',
                '%C%m',
              },
            }
          }
        }
      }
    })
  elseif server == 'lua_ls' then
    vim.lsp.config(server, {
      autostart = true,
      settings = {
        Lua = {
          runtime = {
            version = 'Lua 5.1',
          },
          completion = {
            callSnippet = "Enable"
          },
          diagnostics = {
            globals = { 'vim' },
          },
          hint = {
            enable = true,
          },
          workspace = {
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
        },
      }
    })
  elseif server == 'vimls' then
    vim.lsp.config(server, {
      isNeovim = true,
      diagnostic = { enable = true },
      suggest = {
        fromRuntimepath = false
      }
    })
  elseif server == 'denols' then
    vim.lsp.config(server, {
      single_file_support = true,
    })
  elseif server == 'ts_ls' then
    vim.lsp.config(server, {
      single_file_support = false,
      root_markers = {
        "package.json",
        "tsconfig.json",
        "node_modules/"
      },
      init_options = {
        autostart = false,
      },
    })
  end
end

local not_autostart = { 'efm' }

vim.lsp.enable(servers)
vim.lsp.enable(not_autostart, false)
