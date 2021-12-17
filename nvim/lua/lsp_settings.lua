local vim = vim
local lsp_installer = require("nvim-lsp-installer")

local lsp_installer_servers = require'nvim-lsp-installer.servers'

local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    -- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
      -- Mappings.
    local opts = { noremap=true, silent=true }
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
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>we', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

    -- Code actions
      -- Set autocommands conditional on server_capabilities

    vim.api.nvim_exec([[
          hi! link DiagnosticError Error
          hi! link DiagnosticWarning Warning
        ]], false)
end
      -- augroup lsp_document_highlight
      --   autocmd!
      --   autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      --   autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      -- augroup END
-- some server names are different with vim-lsp's from nvim-lspconfig's

-- local function setup_servers()
--   require'lspinstall'.setup()
--   local servers = require'lspinstall'.installed_servers()
--   for _, server in pairs(servers) do
--     require'lspconfig'[server].setup{}
--   end
-- end

-- setup_servers()

-- -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
-- require'lspinstall'.post_install_hook = function ()
--   setup_servers() -- reload installed servers
--   vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
-- end

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
-- local efm_cpath = vim.fn.expand('~/AppData/Roaming/efm-langserver/config.yaml')
-- nvim_lsp['efm'].setup{
--     autostart = false,
--     on_attach = on_attach ,
--     -- cmd = { 'efm-langserver', '-c', efm_cpath },
--     init_options = {documentFormatting = true},
--     filetypes = {'markdown', 'text', 'txt','json','html', 'css'},
--     };

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true;

-- local servers = { 'pylsp', 'vimls', 'tsserver' }
-- for _, lsp in ipairs(servers) do
--   nvim_lsp[lsp].setup {
--     on_attach = on_attach,
--     flags = {
--       debounce_text_changes = 150,
--     }
--   }
-- end

lsp_installer.on_server_ready(function(server)
    local default_opts = {
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = function(fname)
          return vim.fn.fnamemodify(fname, ':h')
        end
    }
    local server_opts = {
        ["tsserver"] = function()
            default_opts.autostart = false
          end,
        ["denols"] = function()
            default_opts.autostart = false
          end,
        ["sumneko_lua"] = function()
            default_opts.settings = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim' }
                    }
                }
            }
          end,
        ["efm"] = function()
            capabilities.textDocument.completion.completionItem = {}
            default_opts.autostart = false
            default_opts.cmd = {
                vim.fn.stdpath("data") .. "/lsp_servers/efm/efm-langserver",
                "-c",
                vim.fn.expand('~/AppData/Roaming/efm-langserver/config.yaml'),
            }
            default_opts.root_dir = function(fname)
              return vim.fn.fnamemodify(fname, ':h')
            end
            default_opts.single_file_support = true
            default_opts.flags = {
                debounce_text_changes = 150,
            }
            default_opts.filetypes = {
                'markdown',
                'text',
                'txt',
                'json',
                'html',
                'css',
            }
            default_opts.init_options = {
                documentFormatting = true,
            }

            default_opts.on_attach = on_attach
            default_opts.capabilities = capabilities

            return default_opts
        end,
    }

    -- (optional) Customize the options passed to the server
    -- if server.name == "tsserver" then
    --     opts.root_dir = function() ... end
    -- end

    -- This setup() function is exactly the same as lspconfig's setup function.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

    -- We check to see if any custom server_opts exist for the LSP server, if so, load them, if not, use our default_opts
    server:setup(server_opts[server.name] and server_opts[server.name]() or default_opts)
end)

-- local servers = {"rls",  'vimls', 'gopls', "pyright", "jedi_language_server"}
-- -- "tsserver" ,
-- -- local servers = lsp_installer_servers.get_installed_server_names()

-- for _, lsp in ipairs(servers) do
--   nvim_lsp[lsp].setup {
--      capabilities = capabilities;
--      on_attach = on_attach,
--   }
-- end

-- nvim_lsp['texlab'].setup{
--     on_attach = on_attach ,
--     build = {
--           executable = 'lualatex',
--           args = {"%f"},
--           onSave = false,
--           forwardSearchAfter = false,
--         },
--     }
-- local efm_cpath = vim.fn.expand('~/AppData/Roaming/efm-langserver/config.yaml')
-- nvim_lsp['efm'].setup{
--     autostart = false,
--     on_attach = on_attach ,
--     -- cmd = { 'efm-langserver', '-c', efm_cpath },
--     init_options = {documentFormatting = true},
--     filetypes = {'markdown', 'text', 'txt','json','html', 'css'},
--     };

-- local textlint = {
--                     lintCommand = "npx --no-install textlint -f unix --stdin --stdin-filename ${INPUT}",
--                     lintStdin = true,
--                     lintFormats = {"%f:%l:%c: %m [%trror/%r]"},
--                 }
-- -- nvim_lsp['efm'].setup{
-- --     on_attach = on_attach ,
-- --     cmd = { 'efm-langserver'},
-- --      rootMarkers = {".git/"},
-- --     init_options = {documentFormatting = true},
-- --     settings = {
-- --         languages = {
-- --             text = {textlint},
-- --             markdown = {textlint},
-- --             txt = {textlint}
-- --         }
-- --     },
-- --   filetypes = { 'txt', 'text','markdown' }
-- -- };

-- -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
-- --     vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
-- -- )
