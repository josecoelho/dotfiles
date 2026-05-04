local M = {}

M.opts = function()
  local default_opts = require "nvchad.configs.cmp"

  local custom_opts = {
    sources = {
      { name = "supermaven" },
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "nvim_lua" },
      { name = "path" },
    },
    -- Add any other custom options here
  }

  return vim.tbl_deep_extend("force", default_opts, custom_opts)
end

return M
