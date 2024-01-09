local vim = vim

local nvim_lsp = require('lspconfig')

-- require("lsp-inlayhints").setup()
-- vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = "LspAttach_inlayhints",
--   callback = function(args)
--     if not (args.data and args.data.client_id) then
--       return
--     end

--     local bufnr = args.buf
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     require("lsp-inlayhints").on_attach(client, bufnr, true)
--   end,
-- })

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

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

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
      -- Use a sharp border with `FloatBorder` highlights
      border = "single"
    })

  client.server_capabilities.semanticTokensProvider = nil

  vim.cmd([[
         augroup My_group
           autocmd!
         augroup END
       ]])
  -- autocmd CursorHold * lua vim.diagnostic.open_float()
  vim.api.nvim_exec2([[
  hi! link DiagnosticError Error
  hi! link DiagnosticWarning Warning
  ]], { output = false })

  -- if client.supports_method "textDocument/inlayHint" then
  --   vim.lsp.buf.inlay_hint(bufnr, true)
  -- -- else
  -- --   vim.notify(
  -- --     ("%s(%d) does not support textDocument/inlayHint"):format(client.name, client.id),
  -- --     vim.log.levels.DEBUG
  -- --   )
  -- end
end

local lspinstaller = require("mason")
lspinstaller.setup {}
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- local capabilities = require("ddc_source_lsp").make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true;

require("ddc_source_lsp_setup").setup()

local default_config = {
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = function(fname)
    return vim.fn.fnamemodify(fname, ':h')
  end
}
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup({
  automatic_installation = true
})
mason_lspconfig.setup_handlers({ function(server_name)
  local config = default_config
  local node_root_dir = nvim_lsp.util.root_pattern("package.json")
  local is_node_repo = node_root_dir(vim.api.nvim_buf_get_name(0)) ~= nil

  -- if server_name == "tsserver" then
  --   print(is_node_repo)
  --   if not is_node_repo then
  --     return
  --   end
  --   end

  --  config.root_dir = node_root_dir
  if server_name == "denols" then
    if is_node_repo then
      return
    end
    config.root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc", "deps.ts", "import_map.json")
    config = vim.tbl_extend('force', default_config,
      {
        single_file_support = true,
        root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc", "deps.ts", "import_map.json"),
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
      })
  end
  if server_name == 'marksman' then
    config = vim.tbl_extend('force', default_config,
      {
        init_options = {
          enable = false,
          lint = false,
        },
      })
  end
  if server_name == 'tsserver' then
    config = vim.tbl_extend('force', default_config,
      {
        settings = {
          typescript = {
            format = {
              enable = false,
            },
            validate = false,
            suggest = {
              enabled = false
            },
            preferences = {
              importModuleSpecifierEnding = "minimal",
            },
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            }
          },
        },
        filetypes = {
          'javascript',
        }
      })
  end
  local root_files = {
    -- Single-module projects
    {
      'build.xml',           -- Ant
      'pom.xml',             -- Maven
      'settings.gradle',     -- Gradle
      'settings.gradle.kts', -- Gradle
    },
    -- Multi-module projects
    { 'build.gradle', 'build.gradle.kts' },
  }

  if server_name == 'jdtls' then
    config = vim.tbl_extend('force', default_config,
      {
        root_dir = function(fname)
          for _, patterns in ipairs(root_files) do
            local root = nvim_lsp.util.root_pattern(unpack(patterns))(fname)
            if root then
              return root
            end
          end
        end
      })
  end

  local root_files = {
    'settings.gradle',     -- Gradle (multi-project)
    'settings.gradle.kts', -- Gradle (multi-project)
    'build.xml',           -- Ant
    'pom.xml',             -- Maven
  }

  local fallback_root_files = {
    'build.gradle',     -- Gradle
    'build.gradle.kts', -- Gradle
  }

  if server_name == 'kotlin_language_server' then
    config = vim.tbl_extend('force', default_config,
      {
        get_root_dir = function(fname)
          for _, patterns in ipairs(root_files) do
            local root = nvim_lsp.util.root_pattern(unpack(root_files))(fname) or
                nvim_lsp.util.root_pattern(unpack(fallback_root_files))(fname)
            if root then
              return root
            end
          end
        end
      })
  end

  if server_name == 'efm' then
    config = vim.tbl_extend('force', default_config,
      {
        init_options = { documentFormatting = true },
        settings = {
          python = { pythonPath = 'python3' }
        }
      })
  end

  if server_name == 'vimls' then
    config = vim.tbl_extend('force', default_config,
      {
        isNeovim = true,
        diagnostic = { enable = true },
        suggest = {
          fromRuntimepath = true
        }
      })
  end

  -- ファイル名に日本語が入ると動かなくなる
  if server_name == 'efm' then
    config = vim.tbl_extend('force', default_config,
      {
        autostart = false,
        debounce_text_changes = 1500,
        get_root_dir = function(fname)
          return vim.fn.fnamemodify(fname, ':h')
        end,
        single_file_support = true,
        filetypes = {
          'markdown',
          'text',
          'txt',
          'json',
          'html',
          'typescript',
          'css',
        }
      })
  end
  if server_name == 'lua_ls' then
    config = vim.tbl_extend('force', default_config,
      {
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = 'Lua 5.1',
            },
            completion = {
              callSnippet = "Enable"
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
            },
            hint = {
              enable = true,
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              -- library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        }
      })
  end

  nvim_lsp[server_name].setup(
    config
  )
end })
