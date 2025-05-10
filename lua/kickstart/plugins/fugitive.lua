
return {
  'tpope/vim-fugitive',
  config = function()
    local cleanup_git_buffers = require('utils.gitutils').cleanup_git_buffers

    -- Keymaps
    vim.keymap.set('n', '<leader>gs', ':Git<CR>', { desc = '[G]it [S]tatus' })
    vim.keymap.set('n', '<leader>gc', ':Git commit<CR>', { desc = '[G]it [C]ommit' })
    vim.keymap.set('n', '<leader>gp', ':Git push<CR>', { desc = '[G]it [P]ush' })
    vim.keymap.set('n', '<leader>gl', ':Git pull<CR>', { desc = '[G]it [L]oad/Pull' })
    vim.keymap.set('n', '<leader>gb', ':Git blame<CR>', { desc = '[G]it [B]lame' })
    vim.keymap.set('n', '<leader>gq', cleanup_git_buffers, { desc = '[G]it [Q]uit and cleanup' })
    vim.keymap.set('x', '<C-r>', ':diffget<CR>', { desc = '[R]evert selected diff' })

    -- Diff open on Enter in :Git
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'fugitive',
      callback = function()
        vim.keymap.set('n', '<CR>', function()
          local line = vim.fn.getline('.')
          local file = line:match('%s+([^%s]+)$')
          if file then
            vim.cmd('Gedit ' .. file)
            vim.cmd('Gdiffsplit')
          end
        end, { buffer = true, desc = 'Open diff for file' })
      end,
    })
  end,
}
