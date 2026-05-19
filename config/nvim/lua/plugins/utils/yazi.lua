-- lua/plugins/utils/yazi.lua

return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		open_for_directories = true,
	},
	keys = {
		{
			"<leader>ey",
			"<cmd>Yazi<cr>",
			desc = "Yazi (File Manager)",
		},
		{
			"<leader>ec",
			"<cmd>Yazi cwd<cr>",
			desc = "Yazi (CWD)",
		},
	},
}
