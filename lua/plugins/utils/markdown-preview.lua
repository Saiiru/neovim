-- lua/plugins/utils/markdown-preview.lua

return {
	"iamcco/markdown-preview.nvim",
	ft = { "markdown" },
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	build = "cd app && yarn install",
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
	config = function()
		vim.keymap.set("n", "<leader>om", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown Preview" })
	end,
}
