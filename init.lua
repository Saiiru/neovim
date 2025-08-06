-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                    KORA NEURAL DEVELOPMENT MATRIX                        ║
-- ║          Neural Personal Development Environment :: SYSTEM ONLINE        ║
-- ╚══════════════════════════════════════════════════════════════════════════╝
-- Performance optimization matrix
vim.loader.enable()
-- Disable built-in plugins for maximum performance
local disabled_built_ins = {
  "2html_plugin",
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
  "ftplugin",
}
for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

-- Leader key assignment - Command center access
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core module initialization
require("kora.core.options")
require("kora.core.keymaps")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out =
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Plugin management system
require("lazy").setup({
  spec = {
    { import = "kora.plugins" },
    { import = "kora.plugins.lsp" },
    { import = "kora.plugins.ui.colorscheme" },
    { import = "kora.plugins.ui" },
    { import = "kora.plugins.editor" },
    { import = "kora.plugins.completion" },
    { import = "kora.plugins.ai" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = {
    colorscheme = { "cyberdream", "tokyonight", "habamax" },
  },
  checker = {
    enabled = true,
    notify = false, -- DISABLED: Reduce notification spam
  },
  change_detection = {
    enabled = true,
    notify = false, -- DISABLED: Reduce notification spam
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    border = "rounded",
    backdrop = 60,
    title = "󰓩  KORA NEURAL MATRIX",
    title_pos = "center",
    icons = {
      cmd = "",
      config = "",
      event = "",
      ft = "",
      init = "",
      keys = "",
      plugin = "",
      runtime = "櫓",
      require = "",
      source = "",
      start = "",
      task = "",
      lazy = "鈴",
    },
  },
})

-- Autocommands initialization
require("kora.core.autocmds")

-- REMOVED: All startup notifications that were causing spam
-- The autocmds.lua file now handles the single startup notification properly

-- -- Optional: ASCII BANNER (only in CLI, not in GUI) - SIMPLIFIED
-- if vim.fn.has("gui_running") == 0 and os.getenv("TERM") ~= "dumb" then
-- 	-- Only show banner in appropriate terminals
-- 	local banner_lines = {
-- 		"",
-- 		"    󰓩  KORA NEURAL MATRIX :: SYSTEM ONLINE",
-- 		"    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
-- 		"    [KORA]: Neural subsystems initialized.",
-- 		"",
-- 	}

-- 	-- Print banner without vim.notify to avoid notification spam
-- 	for _, line in ipairs(banner_lines) do
-- 		print(line)
-- 	end
-- end

-- Add a command to manually show system status if needed
-- vim.api.nvim_create_user_command("KoraStatus", function()
--   local lazy_stats = require("lazy").stats()
--   local message = string.format(
--     "󰓩 KORA Neural Matrix\n" .. "📦 Plugins: %d loaded, %d total\n" .. "⚡ Startup: %.2fms",
--     lazy_stats.loaded,
--     lazy_stats.count,
--     lazy_stats.startuptime or 0
--   )
--   vim.notify(message, vim.log.levels.INFO, {
--     title = "KORA System Status",
--     timeout = 3000,
--   })
-- end, { desc = "Show KORA system status" })

-- Add keybind for manual status check
vim.keymap.set("n", "<leader>uk", "<cmd>KoraStatus<cr>", { desc = "󰓩 KORA Status" })
-- ASCII BANNER (prints only in CLI, not in GUI)
-- if vim.fn.has("gui_running") == 0 then
--   print([[
--     󰓩  KORA SYSTEM STATUS: ONLINE
--     ██╗  ██╗ ██████╗ ██████╗  █████╗     ███╗   ██╗███████╗██╗   ██╗██████╗  █████╗ ██╗
--     ██║ ██╔╝██╔═══██╗██╔══██╗██╔══██╗    ████╗  ██║██╔════╝██║   ██║██╔══██╗██╔══██╗██║
--     █████╔╝ ██║   ██║██████╔╝███████║    ██╔██╗ ██║█████╗  ██║   ██║██████╔╝███████║██║
--     ██╔═██╗ ██║   ██║██╔══██╗██╔══██║    ██║╚██╗██║██╔══╝  ██║   ██║██╔══██╗██╔══██║██║
--     ██║  ██╗╚██████╔╝██║  ██║██║  ██║    ██║ ╚████║███████╗╚██████╔╝██║  ██║██║  ██║███████╗
--     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝    ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝

--     [KORA]: All neural subsystems initialized. Awaiting your instructions, operator.
--   ]])
-- end
