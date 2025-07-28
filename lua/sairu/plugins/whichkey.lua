return {
	"folke/which-key.nvim",
	event = "CursorMoved",
	config = function()
		local wk = require("which-key")
		-- disable missing-fields warning using lua annotations
		---@diagnostic disable-next-line: missing-fields
		wk.setup({
			icons = {
				rules = false,
				separator = "➜",
				group = "",
			},
			show_keys = false,
			show_help = false, -- show a help message in the command line for using WhichKey
			layout = {
				align = "center",
			},
			win = {
				border = "bold",
				title = false,
				padding = { 1, 1 }, -- extra window padding [top/bottom, right/left]
				no_overlap = true,
			},
		})
	end,
}
