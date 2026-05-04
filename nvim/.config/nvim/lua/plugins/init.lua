return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown", "Avante" },
      code = { enabled = true },
    },
    ft = { "markdown", "Avante" },
  },

  -- Auto-fix code on save
  {
    "stevearc/conform.nvim",
    event = "BufWritePost", -- Trigger on buffer write
    config = function()
      require "configs.conform" -- Load the configuration for auto-fixing
    end,
  },

  -- Autocompletion plugin
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      return require("configs.cmp").opts() -- Load options for nvim-cmp
    end,
  },

  -- LSP configuration (provides server configs in lsp/ directory)
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Auto-install LSP dependencies
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Language servers and formatters for various languages
        "lua-language-server",
        "stylua",
        "css-lsp",
        "html-lsp",
        "typescript-language-server",
        "deno",
        "prettier",
        "terraform-ls",
        "clangd",
        "clang-format",
        "pyright",
        "ruff",
        "mypy",
        "ts_ls",
      },
    },
  },

  -- Alternative to GitHub Copilot
  {
    "supermaven-inc/supermaven-nvim",
    event = "VeryLazy",
    config = function()
      require("supermaven-nvim").setup {} -- Setup the supermaven plugin
    end,
  },

  -- Tab management plugin
  {
    "nanozuki/tabby.nvim",
    event = "VimEnter", -- Load on Vim enter
    dependencies = "nvim-tree/nvim-web-devicons", -- Requires web devicons
    config = function()
      require "configs.tabby" -- Load configuration for tabby
    end,
  },

  -- Tmux integration for seamless navigation
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
  },

  -- Treesitter for advanced syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "vimdoc",
        "lua",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "markdown",
        "markdown_inline",
      },
    },
  },

  -- Tmux focus events integration
  {
    "tmux-plugins/vim-tmux-focus-events",
    event = "VeryLazy",
  },

  -- Surrounding characters manipulation
  {
    "tpope/vim-surround",
    event = "VeryLazy",
  },

  -- Git wrapper for Neovim
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    config = function()
      -- Fix issue of missing netrw disabled by telescope.vim
      -- Reimplement :Browser command to open URLs
      vim.api.nvim_create_user_command("Browse", function(opts)
        vim.fn.system { "open", opts.fargs[1] } -- Open the URL in the default browser
      end, { nargs = 1 })
    end,
  },

  -- Git conflict resolution plugin
  {
    "akinsho/git-conflict.nvim",
    version = "*", -- Use the latest version
    config = true, -- Load the default configuration
    event = "VeryLazy",
  },

  -- Ruby on Rails support
  {
    "tpope/vim-rails",
    event = "VeryLazy",
  },

  -- Automatically add 'end' in Ruby
  {
    "tpope/vim-endwise",
    event = "VeryLazy",
  },

  -- Ruby syntax highlighting and formatting
  {
    "vim-ruby/vim-ruby",
    event = "VeryLazy",
  },

  -- Automatically add 'end' in Ruby
  {
    "tpope/vim-endwise",
    event = "VeryLazy",
  },

  -- GitHub integration for browsing
  {
    "tpope/vim-rhubarb",
    event = "VeryLazy",
  },

  -- Bitbucket integration for browsing
  {
    "tommcdo/vim-fubitive",
    event = "VeryLazy",
  },
}
