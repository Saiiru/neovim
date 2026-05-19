-- lua/config/init.lua

require("config.options")
require("config.custom_functions")
require("config.autocmds")
require("config.keymaps")
require("config.lsp_diagnostic")
require("config.tmux") -- Batman integration
require("config.arduino")
require("config.project_tasks")
require("config.cheatsheets").setup()
