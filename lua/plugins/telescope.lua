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

		local select_one_or_multi = function(prompt_bufnr)
			local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
			local multi = picker:get_multi_selection()
			if not vim.tbl_isempty(multi) then
				require("telescope.actions").close(prompt_bufnr)
				for _, j in pairs(multi) do
					if j.path ~= nil then
						vim.cmd(string.format("%s %s", "edit", j.path))
					end
				end
			else
				require("telescope.actions").select_default(prompt_bufnr)
			end
		end

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
						["<CR>"] = select_one_or_multi,
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
		telescope.load_extension("neoclip")
		telescope.load_extension("ui-select")
		telescope.load_extension("undo")
		telescope.load_extension("advanced_git_search")
		-- telescope.load_extension("colors")
		telescope.load_extension("noice")
	end,
	keys = {
		{ "<C-g><C-e>", "<cmd>Telescope git_files<CR>", desc = "[F]uzzy find git files" },
		{ "<C-g><C-s>", "<cmd>Telescope live_grep<CR>", desc = "[L]ive grep" },
		{ "<C-g><C-b>", "<cmd>Telescope buffers<CR>", desc = "[L]ist buffers" },
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "[F]uzzy find files in cwd" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "[F]ind Old Files" },
		{ "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "[F]ind string in cwd" },
		{ "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "[F]ind string under cursor in cwd" },
		{ "<leader>fb", "<cmd>Telescope file_browser<cr>", desc = "[O]pen file browser" },
		{ "<leader>fma", "<cmd>Telescope media_files<cr>", desc = "[B]rowse media files" },
		{ "<leader>fi", "<cmd>AdvancedGitSearch<cr>", desc = "[A]dvanced Git Search" },
		{ "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "[F]ind Word under Cursor" },
		{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "[S]earch Git Commits" },
		{ "<leader>gb", "<cmd>Telescope git_bcommits<cr>", desc = "[S]earch Git Commits for Buffer" },
		{ "<leader>lw", "<cmd>Telescope diagnostics<CR>", desc = "[D]iagnostics " },

		{ "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "[F]ind Keymaps" },
		{
			"<leader>/",
			function()
				require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
					layout_config = { width = 0.7 },
				}))
			end,
			desc = "[/] Fuzzily search in current buffer",
		},
	},
	cmd = "Telescope",
}
