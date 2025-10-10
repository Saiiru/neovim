-- lua/plugins/ui/whichkey.lua :: Mostra um popup com os keymaps disponíveis.

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		plugins = {
			spelling = { enabled = true, suggestions = 12 },
			presets = {
				operators = true,
				motions = true,
				text_objects = true,
				windows = true,
				nav = true,
				z = true,
				g = true,
			},
		},
		icons = {
			breadcrumb = "»",
			separator = "➜",
			group = " ",
		},
		win = {
			border = "rounded",
			no_overlap = true,
			title = true,
			title_pos = "center",
			zindex = 60,
			padding = { 1, 2 },
		},
		layout = {
			height = { min = 4, max = 30 },
			width = { min = 20, max = 50 },
			spacing = 4,
			align = "center",
		},
		show_help = true,
		show_keys = true,

		-- Grupos semânticos para organizar os keymaps.
		spec = {
			{ "<leader>f", group = "Find / Telescope  " },
			{ "<leader>g", group = "Git  " },
			{ "<leader>l", group = "LSP  " },
			{ "<leader>x", group = "Diagnostics / Lists  " },
			{ "<leader>b", group = "Buffers  " },
			{ "<leader>t", group = "Tabs / Tests  " },
			{ "<leader>w", group = "Windows / Splits  󰕮" },
			{ "<leader>e", group = "Explorer / Files  " },
			{ "<leader>d", group = "Debug  " },
			{ "<leader>s", group = "Session / Workspace  " },
			{ "<leader>;", group = "Terminal  " },
			{ "<leader>c", group = "Code / Format  󰆴" },
			{ "<leader>u", group = "UI Toggles  " },
			{ "<leader>a", group = "AI  " },
		},
	},
}
