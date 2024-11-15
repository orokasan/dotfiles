local vim = vim

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(ev.buf, ...) end

    local opts = { noremap = true, silent = true }
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
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

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
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
require("mason-lspconfig").setup {}

-- local capabilities = require("ddc_source_lsp").make_client_capabilities()
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require("ddc_source_lsp").make_client_capabilities()
-- capabilities.general.positionEncodings = true
local default_config = {
  capabilities = capabilities,
}

local lspconfig = require("lspconfig")
for _, server in pairs(require('mason-lspconfig').get_installed_servers()) do
  if server == 'efm' then
    lspconfig[server].setup {
      filetypes = { 'markdown',
        'text',
        'txt',
        'json',
        'html',
        'typescript',
        'css',
      },
      cmd = { 'efm-langserver', '-q' },
      root_dir = function(fname)
        return vim.fn.fnamemodify(fname, ':h')
      end,
      init_options = {
        documentFormatting = false,
        documentRangeFormatting = false,
        hover = true,
        documentSymbol = false,
        codeAction = true,
        completion = false
      },
      single_file_support = true,
      autostart = false,
      settings = {
        -- debounce_text_changes = 1500,
        languages = {
          markdown = { {
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
            } } },
          txt = { {
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
          } }
        }
      }
    }
  elseif server == 'lua_ls' then
    lspconfig[server].setup {
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
    }
  elseif server == 'vimls' then
    lspconfig[server].setup {
      isNeovim = true,
      diagnostic = { enable = true },
      suggest = {
        fromRuntimepath = true
      }
    }
  elseif server == 'denols' then
    lspconfig[server].setup {
      single_file_support = true,
      root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deps.ts", "import_map.json"),
      init_options = {
        enable = true,
        lint = true,
        unstable = true,
        codeLens = {
          implementations = true,
          preferences = true,
        },
        suggest = {
          imports = {
            hosts = {
              ["https://deno.land"] = true,
              ["https://cdn.nest.land"] = true,
              ["https://crux.land"] = true
            }
          }
        },
        inlayHints = {
          variableTypes = { enabled = true },
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          -- parameterNames= { enabled = 'all' },
        },
      },
      filetypes = {
        'typescript'
      }
    }
  else
    lspconfig[server].setup { default_config }
  end
end


-- require("ddc_source_lsp_setup").setup()
