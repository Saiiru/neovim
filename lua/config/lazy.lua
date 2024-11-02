-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup({
	{ import = "plugins" },
	{ import = "plugins.lsp" },
}, {
	defaults = { lazy = false },
	install = { colorscheme = { "tokyonight" } },
	checker = { enabled = true },
	concurrency = 5,
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"netrwPlugin",
				"tarPlugin",
				"tutor",
				"zipPlugin",
			},
		},
	},
	debug = false,
	ui = {
		border = "rounded",
	},
})

-- Key mapping for Lazy.nvim
vim.keymap.set("n", "<leader>/l", "<cmd>Lazy<cr>", { desc = "Open Lazy.nvim" })
