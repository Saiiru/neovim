-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                 KORA NEURAL MESSAGES - NOICE CONFIGURATION              ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- Helper to generate views config for noice
local function getviews()
	local views = {}
	local all_views = {
		"notify",
		"split",
		"vsplit",
		"popup",
		"mini",
		"cmdline",
		"cmdline_popup",
		"cmdline_output",
		"messages",
		"confirm",
		"hover",
		"popupmenu",
	}
	for _, view in ipairs(all_views) do
		views[view] = { scrollbar = false }
	end
	views["split"].enter = true
	return views
end

return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	opts = {
		views = getviews(),
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
			},
			signature = { enabled = false },
			hover = { enabled = false },
		},
		routes = {
			{
				filter = {
					any = {
						{
							event = { "notify", "msg_show" },
							find = "No information available",
						},
						{
							event = { "notify", "msg_show" },
							find = "minifiles is not supported",
						},
						{
							event = "msg_show",
							kind = "",
							find = "written",
						},
					},
				},
				opts = { skip = true },
			},
		},
		presets = {
			bottom_search = false,
			command_palette = true,
			long_message_to_split = true,
			lsp_doc_border = true,
		},
	},
	config = function(_, opts)
		local map = vim.keymap.set
		require("noice").setup(opts)
		-- Keymaps for Noice management
		map("n", "<leader>nh", ":Noice history<cr>", { desc = "Noice: History", noremap = true, silent = true })
		map("n", "<leader>nl", ":Noice last<cr>", { desc = "Noice: Last Msg", noremap = true, silent = true })
		map("n", "<leader>na", ":Noice all<cr>", { desc = "Noice: All Msg", noremap = true, silent = true })
		map("n", "<leader>nd", ":Noice dismiss<cr>", { desc = "Noice: Dismiss", noremap = true, silent = true })
		map("n", "<leader>np", ":Noice pick<cr>", { desc = "Noice: Pick", noremap = true, silent = true })
	end,
}
