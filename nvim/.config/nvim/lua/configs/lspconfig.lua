local nvlsp = require "nvchad.configs.lspconfig"

nvlsp.defaults() -- loads nvchad's defaults

local servers = { "html", "cssls", "ts_ls", "clangd", "pyright", "terraformls", "eslint", "solargraph" }

-- Configure all servers with NvChad defaults
for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  })
end

-- Enable all servers
vim.lsp.enable(servers)
