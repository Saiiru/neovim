-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                KORA NEURAL FILE EXPLORER - NVIM-TREE                    ║
-- ╚══════════════════════════════════════════════════════════════════════════╝
-- Nerd Font icons, diagnostics, git integration, and HUD enhancements.

return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{ "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle Explorer" },
		{ "<leader>ef", "<cmd>NvimTreeFocus<cr>", desc = "Focus Explorer" },
		{ "<leader>ec", "<cmd>NvimTreeFindFile<cr>", desc = "Find Current File" },
		{ "<leader>er", "<cmd>NvimTreeRefresh<cr>", desc = "Refresh Explorer" },
	},
	opts = {
		disable_netrw = true,
		hijack_netrw = true,
		hijack_cursor = false,
		update_cwd = true,
		sort = { sorter = "case_sensitive" },
		view = {
			width = 35,
			side = "left",
			relativenumber = true,
			number = false,
			signcolumn = "yes",
		},
		renderer = {
			group_empty = true,
			highlight_git = true,
			highlight_opened_files = "name",
			root_folder_modifier = ":~",
			indent_markers = {
				enable = true,
				inline_arrows = true,
				icons = {
					corner = "└",
					edge = "│",
					item = "│",
					bottom = "─",
					none = " ",
				},
			},
			icons = {
				webdev_colors = true,
				git_placement = "before",
				modified_placement = "after",
				padding = " ",
				symlink_arrow = " ➛ ",
				show = {
					file = true,
					folder = true,
					folder_arrow = true,
					git = true,
					modified = true,
				},
				glyphs = {
					default = "",
					symlink = "",
					bookmark = "󰆤",
					modified = "●",
					folder = {
						arrow_closed = "",
						arrow_open = "",
						default = "",
						open = "",
						empty = "",
						empty_open = "",
						symlink = "",
						symlink_open = "",
					},
					git = {
						unstaged = "✗",
						staged = "✓",
						unmerged = "",
						renamed = "➜",
						untracked = "★",
						deleted = "",
						ignored = "◌",
					},
				},
			},
			special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
			symlink_destination = true,
		},
		filters = {
			dotfiles = false,
			git_clean = false,
			no_buffer = false,
			custom = { "^.git$" },
			exclude = { ".gitignore" },
		},
		diagnostics = {
			enable = true,
			show_on_dirs = true,
			show_on_open_dirs = true,
			debounce_delay = 50,
			severity = {
				min = vim.diagnostic.severity.HINT,
				max = vim.diagnostic.severity.ERROR,
			},
			icons = {
				hint = "󰌵",
				info = "",
				warning = "",
				error = "",
			},
		},
		git = {
			enable = true,
			ignore = false,
			show_on_dirs = true,
			show_on_open_dirs = true,
			timeout = 400,
		},
		actions = {
			use_system_clipboard = true,
			change_dir = {
				enable = true,
				global = false,
				restrict_above_cwd = false,
			},
			expand_all = {
				max_folder_discovery = 300,
				exclude = { ".git", "target", "build" },
			},
			open_file = {
				quit_on_open = false,
				resize_window = true,
				window_picker = {
					enable = true,
					picker = "default",
					chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
					exclude = {
						filetype = { "notify", "packer", "qf", "diff", "fugitive", "help" },
						buftype = { "nofile", "terminal", "help" },
					},
				},
			},
			remove_file = {
				close_window = true,
			},
		},
		trash = {
			cmd = "gio trash",
		},
		live_filter = {
			prefix = "[FILTER]: ",
			always_show_folders = true,
		},
		tab = {
			sync = {
				open = false,
				close = false,
				ignore = {},
			},
		},
		notify = {
			threshold = vim.log.levels.INFO,
		},
		ui = {
			confirm = {
				remove = true,
				trash = true,
			},
		},
	},
	config = function(_, opts)
		require("nvim-tree").setup(opts)
		local api = require("nvim-tree.api")
		-- Extra keymaps (buffer-local)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "NvimTree",
			callback = function(event)
				local opts = { buffer = event.buf, silent = true }
				vim.keymap.set("n", "t", function()
					api.node.open.tab()
				end, vim.tbl_extend("force", opts, { desc = "Open in new tab" }))
				vim.keymap.set("n", "<leader>e", function()
					api.tree.toggle()
				end, vim.tbl_extend("force", opts, { desc = "Toggle explorer" }))
				vim.keymap.set("n", "<leader>f", function()
					api.tree.focus()
				end, vim.tbl_extend("force", opts, { desc = "Focus explorer" }))
				vim.keymap.set("n", "<leader>c", function()
					api.tree.collapse_all()
				end, vim.tbl_extend("force", opts, { desc = "Collapse all" }))
				vim.keymap.set("n", "<leader>r", function()
					api.tree.reload()
				end, vim.tbl_extend("force", opts, { desc = "Refresh tree" }))
			end,
		})
	end,
}

--[[
# nvim-tree.lua USAGE GUIDE

- <leader>e      Toggle file explorer
- <leader>ef     Focus file explorer
- <leader>ec     Find current file in explorer
- <leader>er     Refresh explorer

NAVIGATION (inside NvimTree buffer):
- <CR>           Open file/folder
- o              Open file/folder
- t              Open in new tab
- a              Create new file/folder
- d              Delete
- r              Rename
- x              Cut
- c              Copy
- p              Paste
- s/v            Open in split/vsplit
- <Tab>          Preview file

GIT INTEGRATION:
- Git status icons appear next to files
- Use g? in tree for keybind help

DIAGNOSTICS:
- LSP diagnostics shown as icons (󰌵   )

ICONS:
- Nerd Font required (JetBrainsMono Nerd Font recommended)
- Folders:   Open:   Empty:   Symlink: 
- Files:    (default)   (symlink)
- Git: ✗ ✓ ➜ ★  ◌

--]]
