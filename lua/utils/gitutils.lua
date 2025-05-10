
local M = {}

function M.cleanup_git_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      if name:match('^fugitive://') or name:match('^.*//diff') then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end
  vim.cmd('only')
end

return M
