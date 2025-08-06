return {
	"tris203/precognition.nvim",
	event = "VeryLazy",
	opts = {
		startVisible = true,
		showBlankVirtLine = true,
		highlight = { "IncSearch" }, -- ou qualquer grupo de highlight válido
		hints = {
			["w"] = { text = "→w", prio = 10 },
			["b"] = { text = "←b", prio = 10 },
			["e"] = { text = "→e", prio = 8 },
			["ge"] = { text = "←ge", prio = 8 },
			["f"] = { text = "f", prio = 6 },
			["F"] = { text = "F", prio = 6 },
			["t"] = { text = "t", prio = 5 },
			["T"] = { text = "T", prio = 5 },
		},
		disableInDiff = true,
		disableInMacro = true,
		disableInVisualBlock = true,
		disableInInsert = true,
		disableInReplace = true,
		disableInCmdline = true,
		showNumbers = false,
		showMarks = false,
		showRegisters = false,
	},
	config = function(_, opts)
		require("precognition").setup(opts)
		vim.keymap.set(
			"n",
			"<leader>up",
			"<cmd>PrecognitionToggle<cr>",
			{ noremap = true, silent = true, desc = "Toggle Precognition" }
		)
	end,
}
