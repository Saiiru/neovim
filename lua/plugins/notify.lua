return {
	{
		"rcarriga/nvim-notify",
		config = function()
			local icons = require("core.icons.icons")

			require("notify").setup({
				stages = "fade", -- Fade effect
				background_colour = "#1e222a", -- Change this to your preferred color
				timeout = 3000, -- Timeout in milliseconds
				icons = {
					ERROR = icons.BoldError or "✖️",
					WARN = icons.BoldWarning or "⚠️",
					INFO = icons.BoldInformation or "ℹ️",
					DEBUG = icons.Bug or "🐞",
					TRACE = icons.Trace or "✏️",
				},
			})

			-- Replace default notification handler
			vim.notify = require("notify")
		end,
		init = function()
			local banned_messages = {
				"No information available",
				"LSP[tsserver] Inlay Hints request failed. Requires TypeScript 4.4+.",
				"LSP[tsserver] Inlay Hints request failed. File not opened in the editor.",
			}
			vim.notify = function(msg, ...)
				for _, banned in ipairs(banned_messages) do
					if msg == banned then
						return
					end
				end
				return require("notify")(msg, ...)
			end
		end,
	},
}
