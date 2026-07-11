local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
      { import = "plugins.coding" },
      { import = "plugins.lang" },
      { import = "plugins.editor" },
      { import = "plugins.ui" },
      { import = "plugins.devel" },
      { import = "plugins.vega" },
      -- { import = "plugins.extras" },
    },
  },
  {
    profiling = {
      loader = true,
      require = true,
    },
    checker = { enabled = false },
    dev = {
      path = vim.fn.stdpath("config") .. "/lua/devel/plugins",
      pattern = "NickCrew",
      fallback = false,
    },
    install = {
      -- Plugin install is OK; toolchains/SDKs/LSP servers are not installed by Neovim.
      missing = true,
      colorscheme = "tokyonight-night",
    },
    rocks = {
      enabled = false,
      hererocks = false,
    },
    performance = {
      rtp = {
        disabled_plugins = {
          "2html_plugin",
          "tohtml",
          "getscript",
          "getscriptPlugin",
          "gzip",
          "logipat",
          "netrw",
          "netrwPlugin",
          "netrwSettings",
          "netrwFileHandlers",
          "matchit",
          "tar",
          "tarPlugin",
          "rrhelper",
          "spellfile_plugin",
          "vimball",
          "vimballPlugin",
          "zip",
          "zipPlugin",
          "tutor",
          "rplugin",
          "syntax",
          "synmenu",
          "optwin",
          "compiler",
          "bugreport",
        },
      },
    },
  })
