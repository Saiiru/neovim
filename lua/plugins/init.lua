local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  error("lazy.nvim missing at " .. lazypath .. "; install/sync is intentionally not run during Neovim startup")
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "plugins.coding" },
  { import = "plugins.lang" },
  { import = "plugins.editor" },
  { import = "plugins.ui" },
  { import = "plugins.devel" },
  { import = "plugins.vega" },
  -- { import = "plugins.extras" },
}, {
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
    -- Plugin/tool installs are explicit operator actions, not startup side effects.
    missing = false,
    colorscheme = { "carbonfox" },
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
