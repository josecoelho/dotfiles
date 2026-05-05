require "nvchad.options"

local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
o.number = true
o.relativenumber = true

-- Sho nvdash on last buffer close
vim.api.nvim_create_autocmd("BufDelete", {
  callback = function()
    local bufs = vim.t.bufs
    if bufs and #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" then
      vim.cmd "Nvdash"
    end
  end,
})

-- Delete all buffers except those in the current tab
vim.api.nvim_create_user_command("BufOnly", function()
  local current_tab = vim.api.nvim_get_current_tabpage()
  local tab_buffers = {}

  -- Get all buffers in the current tab
  local windows = vim.api.nvim_tabpage_list_wins(current_tab)
  for _, win in ipairs(windows) do
    local buf = vim.api.nvim_win_get_buf(win)
    tab_buffers[buf] = true
  end

  -- Delete all buffers not in the current tab
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and not tab_buffers[buf] then
      -- Try to delete the buffer, with force=false to prevent losing unsaved changes
      pcall(vim.api.nvim_buf_delete, buf, { force = false })
    end
  end
end, { desc = "Keep only buffers in the current tab" })
