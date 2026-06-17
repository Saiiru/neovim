-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit...", },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local specs = { { import = "plugins" }, { import = "langs" } }
-- Load extra plugins base on vim.g.enable_extra_plugins and merge to specs
local extra_plugins = vim.g.enable_extra_plugins -- e.g: { "no-neck-pain", "codecompanion" }
if extra_plugins then
  for _, plugin in ipairs(vim.g.enable_extra_plugins) do
    table.insert(specs, {
      import = "plugins.extra." .. plugin,
    })
  end
end

-- Setup lazy.nvim with performance optimizations
require("lazy").setup {
  spec = specs,
  install = { colorscheme = { "noir" } },
  checker = { 
    enabled = true,
    frequency = 86400, -- Once per day
    notify = false,
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  performance = {
    cache = {
      enabled = true,
      path = vim.fn.stdpath("cache") .. "/lazy/cache",
    },
    reset_packpath = true,
    rtp = {
      reset = true,
      paths = {},
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
  -- Profiler
  profiling = {
    loader = true,
    require = true,
  },
}