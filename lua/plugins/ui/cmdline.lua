return {
	{
		"VonHeikemen/fine-cmdline.nvim",
		-- Noice owns cmdline UI; keep fine-cmdline disabled to avoid duplicate command surfaces.
		enabled = false,
		lazy = true,
		event = "CmdlineEnter",
	},
	{
		"folke/noice.nvim",
		lazy = true,
		event = "VeryLazy",
		enabled = true,
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{
				"<leader>nd",
				mode = "n",
				"<esc><cmd>NoiceDismiss<cr>",
				desc = "Dismiss notifications",
			},
			{
				"<leader>ne",
				mode = "n",
				"<esc><cmd>NoiceErrors<cr>",
				desc = "Notification errors",
			},
			{
				"<leader>nh",
				mode = "n",
				"<esc><cmd>NoiceHistory<cr>",
				desc = "Notification history",
			},
		},
		opts = {
			cmdline = {
				enabled = true,
				view = "cmdline_popup",
				format = {
					cmdline = { pattern = "^:", icon = "CMD", lang = "vim" },
					search_down = {
						kind = "search",
						pattern = "^/",
						icon = " ",
						lang = "regex",
					},
					search_up = {
						kind = "search",
						pattern = "^%?",
						icon = " ",
						lang = "regex",
					},
					filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
					lua = {
						pattern = {
							"^:%s*lua%s+",
							"^:%s*lua%s*=%s*",
							"^:%s*=%s*",
						},
						icon = "",
						lang = "lua",
					},
					help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
				},
			},
			popupmenu = {
				enabled = true,
				backend = "cmp",
			},
			messages = {
				enabled = true,
				view = "mini",
				view_error = "notify",
				view_warn = "mini",
				view_history = "messages",
				view_search = false,
			},
			notify = {
				enabled = true,
				view = "mini",
			},
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				messages = {
					enabled = true,
					view = "mini",
				},
				documentation = {
					view = "hover",
					opts = {
						border = { style = "rounded" },
						win_options = {
							winblend = 0,
							winhighlight = "NormalFloat:NoiceLspFloat,FloatBorder:NoiceLspBorder",
						},
					},
				},
				progress = {
					enabled = true,
					throttle = 1000 / 30,
					format = "lsp_progress",
					format_done = "lsp_progress_done",
					view = "mini",
				},
				signature = {
					enabled = true,
					auto_open = {
						enabled = true,
						trigger = true,
						luasnip = true,
						throttle = 80,
					},
					opts = {
						border = { style = "rounded" },
						win_options = {
							winblend = 0,
							winhighlight = "NormalFloat:NoiceLspFloat,FloatBorder:NoiceLspBorder",
						},
					},
				},
				hover = {
					enabled = true,
					silent = false,
				},
			},
			presets = {
				bottom_search = false,
				command_palette = false,
				long_message_to_split = true,
				inc_rename = true,
				lsp_doc_border = true,
			},
			views = {
				cmdline_popup = {
					position = { row = "38%", col = "50%" },
					size = { width = 78, height = "auto" },
					border = {
						style = "rounded",
						padding = { 1, 2 },
					},
					filter_options = {},
					win_options = {
						winblend = 0,
						winhighlight = "NormalFloat:NoiceCmdlinePopup,FloatBorder:NoiceCmdlinePopupBorder",
					},
				},
				popupmenu = {
					relative = "editor",
					position = { row = "46%", col = "50%" },
					size = { width = 78, height = 10 },
					border = { style = "rounded", padding = { 1, 2 } },
					win_options = {
						winblend = 0,
						winhighlight = "Normal:NoicePopupmenu,FloatBorder:NoicePopupmenuBorder,CursorLine:NoicePopupmenuSelected",
					},
				},
				hover = {
					border = { style = "rounded" },
					size = { max_width = 88, max_height = 24 },
				},
				mini = {
					timeout = 2500,
					win_options = {
						winblend = 0,
						winhighlight = "Normal:NoiceMini",
					},
				},
			},
			routes = {
				{ filter = { find = "E21" }, skip = true },
				{ filter = { find = "E162" }, skip = true },
				{
					filter = { event = "msg_show", find = "search hit BOTTOM" },
					skip = true,
				},
				{
					filter = { event = "msg_show", find = "search hit TOP" },
					skip = true,
				},
				{
					filter = { event = "msg_show", find = "written" },
					view = "mini",
				},
				{ filter = { event = "emsg", find = "E23" }, skip = true },
				{ filter = { event = "emsg", find = "E20" }, skip = true },
				{ filter = { find = "No signature help" }, skip = true },
				{ filter = { find = "E37" }, skip = true },
			},
		},
	},
}
