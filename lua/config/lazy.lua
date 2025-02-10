
-----------------------------------------------------------
-- Load Additional Configuration Modules
-----------------------------------------------------------
-- Ensure you have corresponding Lua files in your nvim/lua/ directory.
require("config.keymaps")   -- Key mappings configuration.
require("config.autocmds")  -- Autocmds configuration.
require("config.options")   -- General options.
-----------------------------------------------------------
-- init.lua
-- Main Initialization File for Neovim
--
-- - Enables the experimental loader (if available)
-- - Defines a global debug function (_G.dd) and alias (vim.print)
-- - Bootstraps lazy.nvim (if not already installed)
-- - Loads additional configuration modules (keymaps, autocmds, options, etc.)
-- - Configures lazy.nvim for plugin management.
-----------------------------------------------------------

-- Enable the experimental loader (improves startup performance)
if vim.loader then
  vim.loader.enable()
end

-----------------------------------------------------------
-- Global Debug Utility
-----------------------------------------------------------
-- Shortcut for dumping values using your util.debug module.
_G.dd = function(...)
  require("util.debug").dump(...)
end
vim.print = _G.dd

-----------------------------------------------------------
-- Bootstrap and Load lazy.nvim
-----------------------------------------------------------
-- Optionally load an external lazy config file if you prefer.
-- require("config.lazy")  -- Uncomment if you want to load a separate lazy config

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",  -- use the latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------
-- Plugin Management with lazy.nvim
-----------------------------------------------------------
require("lazy").setup({
  spec = {
    -- Import your plugin modules here.
    -- Uncomment and adjust the LazyVim block if needed:
    --
    -- {
    --   "LazyVim/LazyVim",
    --   import = "lazyvim.plugins",
    --   opts = {
    --     colorscheme = "solarized-osaka",
    --     news = {
    --       lazyvim = true,
    --       neovim = true,
    --     },
    --   },
    -- },
    --
    -- You can also import additional extra modules:
    -- { import = "lazyvim.plugins.extras.linting.eslint" },
    -- { import = "lazyvim.plugins.extras.formatting.prettier" },
    -- etc.

    -- In your case, import your custom plugins:
    { import = "plugins" },
  },
  defaults = {
    -- By default, your custom plugins will load during startup.
    lazy = false,
    -- Disable versioning to always use the latest commit.
    version = false,
  },
  change_detection={
    notify = false
  },
  -- (Optional) Uncomment and adjust these sections as needed:
  -- dev = { path = "~/.ghq/github.com" },
  -- checker = { enabled = true }, -- Auto-check for plugin updates.
  -- performance = { ... },
  -- ui = { ... },
  -- debug = false,
})

