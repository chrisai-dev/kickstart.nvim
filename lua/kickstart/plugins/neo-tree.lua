-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':lua require("utils.gitutils").cleanup_git_buffers()<CR>:Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
      follow_current_file = {
        enabled = false,  -- disables following the current file
        leave_dirs_open = false,  -- don't auto-close parent folders
      }, 
    },
    event_handlers = {
      {
        event = 'file_opened',
        handler = function(_)
          -- auto close Neo-tree when a file is opened
          require('neo-tree.command').execute { action = 'close' }
        end,
      },
    },
  },
}
