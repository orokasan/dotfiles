local vim = vim
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
-- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
local opts = { noremap=true, silent=true }
buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
buf_set_keymap('n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
buf_set_keymap('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
buf_set_keymap('n', '<space>ss', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
buf_set_keymap('n', '<space>we', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
buf_set_keymap('n', '<space>wl', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
-- Set some keybinds conditional on server capabilities
if client.resolved_capabilities.document_formatting then
buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
elseif client.resolved_capabilities.document_range_formatting then
buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

  -- Set autocommands conditional on server_capabilities
-- vim.api.nvim_exec([[
--       hi link LspReferenceRead Underlined
--       hi link LspReferenceText Underlined
--       hi link LspReferenceWrite Underlined
--     ]], false)
end
      -- augroup lsp_document_highlight
      --   autocmd!
      --   autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      --   autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      -- augroup END
-- some server names are different with vim-lsp's from nvim-lspconfig's

-- local servers = {
--     "rust_analyzer",
--     "tsserver" ,
--     -- 'jedi_language_server',
--     'pyright',
--     'gopls',
--     'texlab',
-- }

-- for _, lsp in ipairs(servers) do
--     -- nvim_lsp[lsp].setup {
--     --   on_attach = on_attach,
--     -- };
-- -- settings for language server binary installed by `vim-lsp-settings`
--     local flsp = string.gsub(lsp, "_", "-")
--     -- if vim.fn.executable(lsp) ~= 1 then
--         -- nvim_lsp[lsp].setup{on_attach = on_attach}
--     -- end
--     local exe = vim.fn['lsp_settings#exec_path'](flsp)
--     if exe ~= '' then
--     nvim_lsp[lsp].setup {
--         on_attach = on_attach,
--         cmd = { exe },
--         on_init = function(client)
--             client.config.flags.allow_incremental_sync = false
--         end
--     };
--     end
-- end
local sumneko_binary = vim.fn['lsp_settings#exec_path']('sumneko-lua-language-server')
nvim_lsp.sumneko_lua.setup {
  cmd = {sumneko_binary};
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
-- nvim_lsp['jdtls'].setup{ cmd = {vim.fn['lsp_settings#exec_path']('eclipse-jdt-ls')}};
-- nvim_lsp['html'].setup{ cmd = {vim.fn['lsp_settings#exec_path']('html-languageserver')}};
-- nvim_lsp['vimls'].setup{ cmd = {vim.fn['lsp_settings#exec_path']('vim-language-server') ,'--stdio'} };
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true;

local servers = {"rust_analyzer", "tsserver" , 'vimls', 'gopls', "pyright", "jedi_language_server"}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
      capabilities = capabilities;
      on_attach = on_attach,
  }
end
local efm_cpath = vim.fn.expand('~/AppData/Roaming/efm-langserver/config.yaml')
nvim_lsp['efm'].setup{
    cmd = {'efm-langserver','-c',efm_cpath};
    filetypes = {'markdown', 'text', 'txt'};
    on_attach = on_attach,
    };

-- efm_cpath = vim.fn.expand('~/AppData/Roaming/efm-langserver/config.yaml')
-- nvim_lsp['efm'].setup{on_attach = on_attach };
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--     vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
-- )
