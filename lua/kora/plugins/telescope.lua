-- ~/.config/nvim/lua/kora/plugins/telescope.lua
-- Telescope único, sem duplicatas. FZF nativo, themes, keymaps sob <leader>f.
return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "master",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			"nvim-tree/nvim-web-devicons",
			"andrew-george/telescope-themes",
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local builtin = require("telescope.builtin")

			-- extensões
			pcall(telescope.load_extension, "fzf")
			pcall(telescope.load_extension, "themes")
			pcall(telescope.load_extension, "harpoon") -- carrega se Harpoon estiver presente

			telescope.setup({
				defaults = {
					prompt_prefix = "   ",
					selection_caret = " ",
					path_display = { "smart" },
					file_ignore_patterns = { ".git/", "node_modules/", "%.lock" },
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous,
							["<C-j>"] = actions.move_selection_next,
							["<C-u>"] = false,
							["<C-d>"] = false,
						},
					},
					layout_strategy = "vertical",
					layout_config = { height = 0.95, width = 0.90, preview_cutoff = 15 },
				},
				pickers = {
					find_files = { hidden = true, no_ignore = false, follow = true },
					buffers = { sort_lastused = true, ignore_current_buffer = true },
				},
				extensions = {
					themes = {
						enable_previewer = true,
						enable_live_preview = true,
						persist = { enabled = true, path = vim.fn.stdpath("config") .. "/lua/colorscheme.lua" },
					},
				},
			})

			-- Keymaps (<leader>f*)
			local map = function(lhs, rhs, desc)
				vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
			end
			map("<leader>ff", builtin.find_files, "Find files")
			map("<leader>fg", builtin.live_grep, "Live grep")
			map("<leader>fw", function()
				builtin.grep_string({ search = vim.fn.expand("<cword>") })
			end, "Grep word")
			map("<leader>fW", function()
				builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
			end, "Grep WORD")
			map("<leader>fb", builtin.buffers, "Buffers")
			map("<leader>fo", builtin.oldfiles, "Recent files")
			map("<leader>fh", builtin.help_tags, "Help tags")
			map("<leader>fk", builtin.keymaps, "Keymaps")
			map("<leader>fd", builtin.diagnostics, "Diagnostics")
			map("<leader>fs", builtin.lsp_document_symbols, "LSP Symbols (doc)")
			map("<leader>fS", builtin.lsp_workspace_symbols, "LSP Symbols (ws)")
			map("<leader>ft", "<cmd>Telescope themes<CR>", "Theme Switcher")
			-- Git
			map("<C-p>", builtin.git_files, "Git files")
		end,
	},
}
