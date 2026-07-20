-- Enable the following language servers
--  Add any additional override configuration in the following tables. Available keys are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--  - settings (table): Override the default settings passed when initializing the server.
--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/

-- Ensure the servers and tools above are installed
--  To check the current status of installed tools and/or manually install
--  other tools, you can run
--    :Mason
--
--  You can press `g?` for help in this menu
require('mason').setup()
--
-- -- You can add other tools here that you want Mason to install
-- -- for you, so that they are available from within Neovim.
require('mason-tool-installer').setup({
  ensure_installed = {
    'yamlls',
    'vimls',
    'bashls',
    'intelephense',
    'gopls',
    'pyright',
    'lua_ls',
    --
    'stylua', -- Used to format lua code
    { 'black', version = '23.7.0' },
    { 'tree-sitter-cli', version = 'v0.25.10' },
    'goimports',
    'prettier',
  },
})
--
-- -- LSP servers and clients are able to communicate to each other what features they support.
-- --  By default, Neovim doesn't support everything that is in the LSP Specification.
-- --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
-- --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

-- Global default config for all LSP servers
vim.lsp.config('*', {
  capabilities = capabilities,
})

-- Initialize nvim-lspconfig to make its default configurations discoverable.
require('lspconfig')

local servers = {
  'yamlls',
  'vimls',
  'bashls',
  'intelephense',
  'gopls',
  'pyright',
  'lua_ls',
  'please',
}

for _, server in ipairs(servers) do
  local config = {}

  local ok, server_config = pcall(require, 'lsp-config.' .. server)
  if ok then
    config = server_config
  end

  if vim.lsp.config[server] then
    vim.lsp.config(server, config)
    vim.lsp.enable(server)
  else
    vim.notify('LSP server ' .. server .. ' not found in vim.lsp.config', vim.log.levels.WARN)
  end
end
