-- First load NvChad mappings
require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Change telescope to include hidden files of git repo
map("n", "<leader>ff", require("telescope.builtin").git_files)
map("n", "<leader>p", "<cmd>Telescope commands<cr>", { desc = "Command palette" })

-- LSP mappings with Telescope
map("n", "gd", function()
  require("telescope.builtin").lsp_definitions { jump_type = "vsplit" }
end, { desc = "LSP definitions" })
map("n", "gr", function()
  require("telescope.builtin").lsp_references()
end, { desc = "LSP references" })
map("n", "gi", function()
  require("telescope.builtin").lsp_implementations()
end, { desc = "LSP implementations" })
map("n", "gt", function()
  require("telescope.builtin").lsp_type_definitions()
end, { desc = "LSP type definitions" })
map("n", "<leader>ls", function()
  require("telescope.builtin").lsp_document_symbols()
end, { desc = "Document symbols" })
map("n", "<leader>lS", function()
  require("telescope.builtin").lsp_workspace_symbols()
end, { desc = "Workspace symbols" })
map("n", "<leader>ld", function()
  require("telescope.builtin").diagnostics()
end, { desc = "Diagnostics" })
