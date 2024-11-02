return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- Compilação com `make`
			"debugloop/telescope-undo.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-telescope/telescope-live-grep-args.nvim",
			"nvim-telescope/telescope-project.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-telescope/telescope-dap.nvim",
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			-- Configuração do Telescope
			telescope.setup({
				defaults = {
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = { width = 0.95, height = 0.85, preview_width = 0.6, prompt_position = "top" },
					},
					find_command = {
						"rg",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
					},
					prompt_prefix = "  ",
					selection_caret = "  ",
					initial_mode = "insert",
					sorting_strategy = "ascending",
					file_sorter = require("telescope.sorters").get_fuzzy_file,
					path_display = { "smart" },
					winblend = 10,
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					color_devicons = true,
					set_env = { ["COLORTERM"] = "truecolor" },
					mappings = {
						i = {
							["<C-n>"] = actions.move_selection_next,
							["<C-p>"] = actions.move_selection_previous,
							["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
							["<esc>"] = actions.close,
							["<CR>"] = actions.select_default + actions.center,
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({ previewer = false }),
					},
				},
			})

			-- Carregar as extensões do Telescope
			pcall(function()
				telescope.load_extension("fzf")
				telescope.load_extension("undo")
				telescope.load_extension("file_browser")
				telescope.load_extension("live_grep_args")
				telescope.load_extension("projects")
				telescope.load_extension("ui-select")
			end)
		end,
	},
}
