-- Remote Python LSP client configuration
-- Connects to pylsp running in Docker container on port 2087
return {
  'neovim/nvim-lspconfig',
  config = function()
    local lspconfig = require 'lspconfig'
    local configs = require 'lspconfig.configs'

    -- Define custom remote pylsp configuration
    if not configs.remote_pylsp then
      configs.remote_pylsp = {
        default_config = {
          cmd = vim.lsp.rpc.connect('127.0.0.1', 2087),
          filetypes = { 'python' },
          root_dir = function(fname)
            return lspconfig.util.root_pattern('.git', 'setup.py', 'pyproject.toml', 'setup.cfg')(fname)
              or lspconfig.util.path.dirname(fname)
          end,
          settings = {},
        },
      }
    end

    -- Format on save
    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

    -- Setup the remote pylsp
    lspconfig.remote_pylsp.setup {
      on_attach = function(client, bufnr)
        if client.supports_method 'textDocument/formatting' then
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { async = false }
            end,
          })
        end
      end,
      settings = {
        pylsp = {
          plugins = {
            ruff = {
              executable = '/usr/local/bin/ruff',
            },
            pylsp_mypy = {
              enabled = true,
              live_mode = true,
            },
          },
        },
      },
    }
  end,
}
