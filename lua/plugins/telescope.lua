return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "benfowler/telescope-luasnip.nvim", module = "telescope._extensions.luasnip" },
		{ "nvim-telescope/telescope-file-browser.nvim" },
		{ "debugloop/telescope-undo.nvim" },
		{ "nvim-telescope/telescope-live-grep-args.nvim" },
		{ "nvim-telescope/telescope-media-files.nvim" },
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "aaronhallaert/advanced-git-search.nvim" },
		{ "uga-rosa/ccc.nvim" },
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<esc>"] = actions.close,
						["<tab>"] = actions.toggle_selection + actions.move_selection_next,
						["<S-tab>"] = actions.toggle_selection + actions.move_selection_previous,
						["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<C-S-d>"] = actions.delete_buffer,
						["<C-s>"] = actions.cycle_previewers_next,
						["<C-a>"] = actions.cycle_previewers_prev,
						["<CR>"] = actions.select_default,
					},
					n = {
						["<esc>"] = actions.close,
						["<tab>"] = actions.toggle_selection + actions.move_selection_next,
						["<S-tab>"] = actions.toggle_selection + actions.move_selection_previous,
						["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
				file_ignore_patterns = { "node_modules", "%.git/", "*.png", "*.jpg" },
				prompt_prefix = " ",
				sorting_strategy = "ascending",
				selection_caret = "  ",
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.5,
						results_width = 0.75,
					},
					vertical = {
						mirror = false,
					},
					width = 0.85,
					height = 0.85,
					preview_cutoff = 80,
				},
				border = {},
				set_env = { ["COLORTERM"] = "truecolor" },
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
				file_browser = {
					theme = "dropdown",
					hijack_netrw = true,
				},
				live_grep_args = {
					auto_quoting = false,
				},
				media_files = {
					filetypes = { "png", "jpg", "jpeg", "mp4", "webm", "pdf" },
					find_cmd = "rg",
				},
				undo = {
					use_delta = true,
					vim_diff_opts = { ctxlen = vim.o.scrolloff },
					entry_format = "state #$ID, $STAT, $TIME",
					mappings = {
						i = {
							["<C-cr>"] = require("telescope-undo.actions").yank_additions,
							["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
							["<cr>"] = require("telescope-undo.actions").restore,
						},
					},
				},
			},
			pickers = {
				git_files = {
					show_untracked = true,
				},
				live_grep = {
					additional_args = function(opts)
						return { "--hidden" }
					end,
				},
				find_files = {
					hidden = true,
					find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
				},
			},
		})

		-- Carregando extensões
		telescope.load_extension("fzf")
		telescope.load_extension("luasnip")
		telescope.load_extension("file_browser")
		telescope.load_extension("live_grep_args")
		telescope.load_extension("media_files")
		telescope.load_extension("ui-select")
		telescope.load_extension("undo")
		telescope.load_extension("advanced_git_search")

		-- Configurando as teclas no formato solicitado
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
		vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
		vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

		vim.keymap.set("n", "<leader>/", function()
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzily search in current buffer" })

		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch [/] in Open Files" })

		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })
	end,
}
