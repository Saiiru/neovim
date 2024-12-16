return {
  -- Treesitter for Bash syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "bash" },
    },
  },

  -- LSP configuration for Bash
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {}, -- Setup for Bash LSP server
      },
    },
  },

  -- Mason for managing tools like bash-language-server and shellcheck
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "bash-language-server", -- LSP for Bash
        "shellcheck", -- Linter for Bash scripts
      },
    },
  },

  -- Linters configuration using nvim-lint
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- Add shellcheck linter for bash files if not already present
      opts.linters_by_ft.bash = opts.linters_by_ft.bash or {}
      table.insert(opts.linters_by_ft.bash, "shellcheck")
      return opts
    end,
  },

  -- Optional: Neotest setup for Bash testing
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = { "rcasia/neotest-bash" },
    opts = {
      adapters = {
        ["neotest-bash"] = {}, -- Adapter for Bash testing
      },
    },
  },

  -- Optional: Devdocs integration for easy access to Bash documentation
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = { "bash" }, -- Install Bash documentation
    },
  },
}
