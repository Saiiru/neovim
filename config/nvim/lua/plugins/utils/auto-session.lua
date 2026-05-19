-- lua/plugins/utils/auto-session.lua

return {
	"rmagatti/auto-session",
	event = "VimEnter",
	opts = {
		log_level = "error",
		auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
		auto_session_use_git_branch = true,
		session_lens = {
			load_on_setup = true,
			theme_conf = { border = true },
			previewer = false,
		},
	},
	keys = {
		{ "<leader>ss", "<cmd>SessionSave<cr>", desc = "Save Session" },
		{ "<leader>sl", "<cmd>SessionSearch<cr>", desc = "Search Session" },
		{ "<leader>sr", "<cmd>SessionRestore<cr>", desc = "Restore Session" },
		{ "<leader>sd", "<cmd>SessionDelete<cr>", desc = "Delete Session" },
	},
}
