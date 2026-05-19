-- lua/plugins/coding/comment.lua

return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = function()
		-- Set a vim motion to <Space> + / to comment the line under the cursor in normal mode
		vim.keymap.set("n", "<leader>/", "<Plug>(comment_toggle_linewise_current)", { desc = "Comment Line" })
		-- Set a vim motion to <Space> + / to comment all the lines selected in visual mode
		vim.keymap.set("v", "<leader>/", "<Plug>(comment_toggle_linewise_visual)", { desc = "Comment Selected" })

		local comment = require("Comment")
		local ts_context_comment_string = require("ts_context_commentstring.integrations.comment_nvim")

		comment.setup({
			pre_hook = ts_context_comment_string.create_pre_hook(),
		})
	end,
}
