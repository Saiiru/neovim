require("config")

-- Helper functions and autocommands
require("config.functions")
require("config.autocommands")
require("config.commands")

-- Plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("plugins", {
	change_detection = {
		enabled = true,
		notify = false,
	},
})

-- Mappings
require("config.keymaps")

-- Language Servers
-- require("plugins.lsp")

-- Git helpers
require("util.git-helpers")