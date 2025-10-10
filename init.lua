vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- opções/básico
pcall(require, "core.options")
pcall(require, "core.keymaps")
pcall(require, "core.autocmds")
-- bootstrap lazy.nvim (padrão)
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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
		{ import = "plugins" },
		{ import = "plugins.lsp" },
	},
	defaults = { lazy = false, version = false },
	ui = { border = "rounded" },
	checker = { enabled = false },
})

pcall(function()
	local C = require("lua.utils.colors")
	C.setup()
	C.set(vim.g.neosairu_theme or "cyberdream")
	C.transparent(true)
	C.boost(1)
end)

-- extras opcionais
pcall(require, "current-theme")
pcall(require, "terminalpop")
