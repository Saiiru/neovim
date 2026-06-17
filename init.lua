require("config.options")

-- Load project setting if available, e.g: .nvim-config.lua
-- This file is not tracked by git
-- It can be used to set project specific settings
local project_setting = vim.fn.getcwd() .. "/.nvim-config.lua"
if vim.loop.fs_stat(project_setting) then
  local ok, err = pcall(dofile, project_setting)
  if not ok then
    vim.notify("Error loading project setting: " .. err, vim.log.levels.ERROR)
  end
end

require("config.autocmds")
require("config.lazy")
require("config.startup")
require("config.keymaps")
require("config.project")
require("config.lsp")
require("config.preferences")
require("config.vim_conf")
require("config.theme")
require("config.lang")
require("config.obsidian")
require("config.dedsec_ui")
require("config.dedsec_ui")
require("config.workflows")
require("config.whichkey")

-- Setup LSP configs (registers all vim.lsp.config)
require("config.lsp").setup()

-- Enable all LSP servers globally (Neovim 0.11+ pattern)
-- Neovim will auto-start servers when buffer matches filetype + root_markers
local all_servers = {
  "lua_ls",
  "basedpyright",
  "ruff",
  "gopls",
  "rust_analyzer",
  "ts_ls",
  "vtsls",
  "biome",
  "oxlint",
  "tailwindcss",
  "jsonls",
  "yamlls",
  "marksman",
  "dockerls",
  "taplo",
  "sqls",
  "bashls",
}
for _, server in ipairs(all_servers) do
  vim.lsp.enable(server)
end

-- Window border style (must be set early)
vim.o.winborder = "single"

-- Only load the theme if not in VSCode
if vim.g.vscode then
  local pattern = "NvimIdeKeymaps"
  vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
else
  local theme = require("config.theme")
  theme.setup()
  theme.apply()
  local ok_lazy, lazy = pcall(require, "lazy")
  if ok_lazy then
    pcall(function()
      lazy.load({ plugins = { "lualine.nvim" } })
    end)
  end
end
