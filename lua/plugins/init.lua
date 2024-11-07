return {
  -- Add subdirectories here
  {
    import = "plugins.coding.ai",
  },
  {
    import = "plugins.coding.cmp",
  },
  {
    import = "plugins.coding",
  },
  {
    import = "plugins.util",
  },
  { import = "plugins.coding.treesitter" },

  { import = "plugins.dap" },
  { import = "plugins.editor" },
  -- {
  --   import = "plugins.languages",
  -- },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │ General plugins                                         │
  -- ╰─────────────────────────────────────────────────────────╯
  { "AndrewRadev/switch.vim", lazy = false },
  { "tpope/vim-repeat", lazy = false },
  { "tpope/vim-speeddating", lazy = false },
  {
    "airblade/vim-rooter",
    event = "VeryLazy",
    config = function()
      vim.g.rooter_patterns = { ".git", "package.json", "_darcs", ".bzr", ".svn", "Makefile" }
      vim.g.rooter_silent_chdir = 1
      vim.g.rooter_resolve_links = 1
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = true,
  },
}
