-- lua/plugins/utils/rainbow-delimiters.lua

return {
	"HiPhish/rainbow-delimiters.nvim",
	event = "VeryLazy",
	config = function()
		local rb = require("rainbow-delimiters")
		require("rainbow-delimiters.setup").setup({
			strategy = {
				[""] = rb.strategy["global"],
			},
			query = {
				[""] = "rainbow-delimiters",
			},
			highlight = {
				"RainbowDelimiter1",
				"RainbowDelimiter2",
				"RainbowDelimiter3",
				"RainbowDelimiter4",
				"RainbowDelimiter5",
				"RainbowDelimiter6",
				"RainbowDelimiter7",
			},
		})
	end,
}
