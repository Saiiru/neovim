-- vim: set foldmethod=marker foldlevel=0 foldmarker={{{,}}} :
-- NickCrew/nvim-pde base + VEGA mise-first project layer.

require("global")
require("autocmds")
require("options")
require("plugins")
require("mappings")

pcall(function()
  vim.cmd.colorscheme("carbonfox")
end)

pcall(function()
  require("pde.commands").setup()
end)
