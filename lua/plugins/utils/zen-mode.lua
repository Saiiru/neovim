-- lua/plugins/utils/zen-mode.lua

return {
	"folke/zen-mode.nvim",
	cmd = "ZenMode",
	opts = {
		window = {
			backdrop = 0.95,
			width = 120,
			height = 1,
			options = {
				signcolumn = "no",
				number = false,
				relativenumber = false,
				cursorline = false,
				cursorcolumn = false,
				foldcolumn = "0",
				list = false,
			},
		},
		plugins = {
			gitsigns = { enabled = false },
			tmux = { enabled = false },
			twilight = { enabled = true },
		},
	},
	keys = {
		{ "<leader>zz", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
	},
}
