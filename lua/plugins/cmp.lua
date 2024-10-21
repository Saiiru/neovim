--[[ 
	code completion

	plugins: 
		- https://github.com/hrsh7th/nvim-cmp
		- https://github.com/hrsh7th/cmp-nvim-lsp
		- https://github.com/L3MON4D3/LuaSnip
		- https://github.com/saadparwaiz1/cmp_luasnip
		- https://github.com/hrsh7th/cmp-nvim-lua
		- https://github.com/hrsh7th/cmp-buffer
		- https://github.com/hrsh7th/cmp-path
		- https://github.com/hrsh7th/cmp-cmdline
		- https://github.com/tzachar/cmp-tabnine
		- https://github.com/github/copilot.vim
]]

return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-cmdline",
		"saadparwaiz1/cmp_luasnip",
		"L3MON4D3/LuaSnip",
		"rafamadriz/friendly-snippets",
		"onsails/lspkind.nvim",
		"tzachar/cmp-tabnine",
		"github/copilot.vim",
	},

	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")
		local vscodesnippets = require("luasnip.loaders.from_vscode")

		-- Lazily load VSCode-like snippets
		vscodesnippets.lazy_load()

		-- Custom border style for completion window
		local border = {
			{ "┌", "FloatBorder" },
			{ "─", "FloatBorder" },
			{ "┐", "FloatBorder" },
			{ "│", "FloatBorder" },
			{ "└", "FloatBorder" },
			{ "─", "FloatBorder" },
			{ "┘", "FloatBorder" },
			{ "│", "FloatBorder" },
		}

		cmp.setup({
			completion = {
				completeopt = "menu,menuone,preview,noselect",
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "tabnine" },
				{ name = "copilot" },
				{ name = "buffer" },
				{ name = "path" },
			}),
			formatting = {
				format = lspkind.cmp_format({
					with_text = true,
					menu = {
						nvim_lsp = "[LSP]",
						luasnip = "[Snippet]",
						tabnine = "[Tabnine]",
						copilot = "[Copilot]",
						buffer = "[Buffer]",
						path = "[Path]",
					},
					-- Add icons to the items
					before = function(entry, vim_item)
						vim_item.kind = lspkind.icons[vim_item.kind] .. " " .. vim_item.kind
						return vim_item
					end,
				}),
			},
			window = {
				completion = {
					border = border,
					winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
				},
				documentation = {
					border = border,
					winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
				},
			},
		})

		-- Set up Tabnine
		require("cmp_tabnine.config"):setup({
			max_lines = 1000,
			max_num_results = 20,
			sort = true,
		})
	end,
}

