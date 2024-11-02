local function ColorMyPencils(color)
	color = color or "tokyodark"
	vim.cmd.colorscheme(color)

	-- Transparência para o fundo
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

	-- Cores customizadas para NeoTree
	vim.cmd("highlight NeoTreeFolderIcon guifg=#FF8F1F") -- Laranja intenso
	vim.cmd("highlight NeoTreeFolderName guifg=#50fa7b") -- Verde neon
	vim.cmd("highlight NeoTreeFileIcon guifg=#8be9fd") -- Azul neon
	vim.cmd("highlight NeoTreeFileName guifg=#FF61FF") -- Rosa choque
end

return {
	-- Brightburn theme
	{
		"erikbackman/brightburn.vim",
		lazy = true, -- Carrega sob demanda
	},

	-- TokyoNight theme
	{
		"folke/tokyonight.nvim",
		lazy = false, -- Carregado imediatamente
		opts = {
			style = "night",
			transparent = vim.g.neovide and true or false,
			terminal_colors = true,
			styles = {
				comments = { italic = false },
				keywords = { italic = true },
				functions = "NONE",
				variables = "NONE",
			},
			sidebars = { "qf", "help" },
			hide_inactive_statusline = false,
			dim_inactive = false,
			lualine_bold = false,
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = "#FFA630", bg = "None" })
			vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "None", fg = "None" })
			vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "None", fg = "None" })
			vim.api.nvim_set_hl(0, "MsgArea", { fg = require("tokyonight.colors").setup().fg_dark })
		end,
	},

	-- TokyoDark theme
	{
		"tiagovla/tokyodark.nvim",
		lazy = false, -- Carregado imediatamente
		opts = {
			transparent_background = true,
			gamma = 1.0, -- Saturação ajustada
			styles = {
				comments = { italic = true },
				keywords = { italic = true, bold = true },
				identifiers = { italic = true },
				functions = { bold = true },
				variables = {},
			},
			terminal_colors = true,
			custom_highlights = function(highlights, palette)
				local function adjust_color(color, fallback)
					return type(color) == "string" and color or fallback
				end

				-- Definindo valores seguros e padrões
				highlights.Normal = { bg = "none", fg = adjust_color(palette.fg, "#D800FF") }
				highlights.Comment = { fg = adjust_color(palette.magenta, "#FF61FF"), italic = true }
				highlights.Keyword = { fg = adjust_color(palette.red, "#FF007F"), bold = true, italic = true }
				highlights.Function = { fg = adjust_color(palette.cyan, "#00F9FF"), bold = true }
				highlights.String = { fg = adjust_color(palette.green, "#50fa7b") }
				highlights.Error = { fg = adjust_color(palette.red, "#FF073A"), bold = true }
				highlights.Number = { fg = adjust_color(palette.yellow, "#FFFA65"), bold = true }
				highlights.Boolean = { fg = adjust_color(palette.orange, "#FF8F1F"), bold = true }
				return highlights
			end,
		},
		config = function(_, opts)
			require("tokyodark").setup(opts)
			-- Aplicar o tema tokyodark com configurações ajustadas
			ColorMyPencils("tokyodark")
		end,
	},

	-- Fluoromachine theme
	{
		"maxmx03/fluoromachine.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local fm = require("fluoromachine")

			fm.setup({
				theme = "retrowave", -- Tema retrowave para o visual neon
				glow = true, -- Habilita o efeito glow
				transparent = true, -- Transparência para fundo
				brightness = 0.1, -- Brilho adicional
				styles = {
					comments = { italic = true },
					keywords = { bold = true },
					functions = { bold = true },
				},
				colors = function(_, color)
					local darken = color.darken
					return {
						bg = "#0D0221", -- Fundo preto com toque roxo
						bgdark = darken("#0D0221", 20), -- Fundo ainda mais escuro
						cyan = "#00F9FF", -- Ciano neon vivo
						red = "#FF073A", -- Vermelho neon brilhante
						yellow = "#FFFA65", -- Amarelo neon que salta aos olhos
						orange = "#FF8F1F", -- Laranja intenso
						pink = "#FF61FF", -- Rosa choque mais intenso
						purple = "#D800FF", -- Roxo neon ainda mais forte
					}
				end,
				overrides = function(c, color)
					local darken = color.darken
					return {
						TelescopeResultsBorder = { fg = c.bg, bg = c.bg },
						TelescopeResultsNormal = { bg = darken(c.bg, 20) },
						TelescopePromptBorder = { fg = darken(c.pink, 5), bg = c.bg },
						TelescopeTitle = { fg = c.yellow, bg = darken(c.yellow, 10) },
						TelescopePromptPrefix = { fg = c.cyan },
					}
				end,
				plugins = {
					telescope = true,
					treesitter = true,
					lspconfig = true,
					bufferline = true,
					cmp = true,
					lazy = true,
					navic = true,
					gitsign = true,
					notify = true,
					neogit = true,
					noice = true,
				},
			})
			-- vim.cmd.colorscheme 'fluoromachine' -- Aplica o tema fluoromachine
		end,
	},

	-- Gruvbox theme
	{
		"ellisonleao/gruvbox.nvim",
		name = "gruvbox",
		lazy = true, -- Carrega sob demanda
		opts = {
			terminal_colors = true,
			undercurl = true,
			underline = true,
			bold = true,
			italic = {
				strings = false,
				emphasis = false,
				comments = false,
				operators = false,
				folds = false,
			},
			strikethrough = true,
			inverse = true,
			transparent_mode = false,
		},
		config = function(_, opts)
			require("gruvbox").setup(opts)
			-- ColorMyPencils("gruvbox") -- Troca para Gruvbox se preferido
		end,
	},
}
