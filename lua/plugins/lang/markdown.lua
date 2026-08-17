return {
	{
		-- Live markdown preview for README/case-study review.
		"iamcco/markdown-preview.nvim",
		ft = "markdown",
		lazy = true,
		keys = {
			{
				"<leader>mp",
				"<cmd>MarkdownPreviewToggle<cr>",
				desc = "Markdown preview",
			},
		},
		init = function()
			vim.g.mkdp_auto_start = 0
			vim.g.mkdp_auto_close = 1
		end,
	},
	{
		-- Terminal markdown render, only useful when `glow` is installed.
		"ellisonleao/glow.nvim",
		lazy = true,
		cmd = "Glow",
		opts = {
			glow_path = "glow",
		},
	},
}
