return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
    'jayp0521/mason-null-ls.nvim',
  },
  config = function()
    local null_ls = require 'null-ls'
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    -- Set up mason-null-ls to install tools used by null-ls
    require('mason-null-ls').setup {
      ensure_installed = {
        'black',
        'isort',
        'flake8',
        'checkmake',
        'prettier',
        'stylua',
        'eslint_d',
        'shfmt',
      },
      automatic_installation = true,
    }

    local sources = {
      -- 🔧 Python tools from pre-commit
      formatting.black.with { extra_args = { '--fast' } },
      formatting.isort.with { extra_args = { '--settings-path=pyproject.toml' } },
      diagnostics.flake8,

      -- Other formatters/linters you already use
      formatting.stylua,
      formatting.prettier.with { filetypes = { 'html', 'json', 'yaml', 'markdown' } },
      formatting.shfmt.with { args = { '-i', '4' } },
      formatting.terraform_fmt,
      diagnostics.checkmake,
    }

    -- Format on save
    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    null_ls.setup {
      sources = sources,
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
    }
  end,
}
