local options = {

  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    python = { "ruff_fix" },
    ruby = { "rubocop", "standardrb", stop_after_first = true },
  },

  format_after_save = {
    lsp_format = "fallback",
  },
}

require("conform").setup(options)
