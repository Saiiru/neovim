function ColorMyPencils(color)
    color = color or "carbonfox"
    vim.cmd.colorscheme(color)

    -- Ajusta fundo transparente
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

    -- Forçando itálicos em comentários e palavras-chave
    vim.api.nvim_set_hl(0, "Comment", { italic = true })
    vim.api.nvim_set_hl(0, "Keyword", { italic = true, bold = true })
    vim.api.nvim_set_hl(0, "Function", { italic = true })
    vim.api.nvim_set_hl(0, "Variable", { italic = true })
    vim.api.nvim_set_hl(0, "String", { italic = false })
end

return {
    {
        "erikbackman/brightburn.vim",
    },

    {
        "folke/tokyonight.nvim",
        lazy = false,
        opts = {},
        config = function()
            ColorMyPencils()
        end,
    },

    {
        "ellisonleao/gruvbox.nvim",
        name = "gruvbox",
        config = function()
            require("gruvbox").setup({
                terminal_colors = true, -- adicionar cores ao terminal
                undercurl = true,
                underline = false,
                bold = true,
                italic = {
                    strings = false,
                    emphasis = false,
                    comments = false,
                    operators = false,
                    folds = false,
                },
                strikethrough = true,
                invert_selection = false,
                invert_signs = false,
                invert_tabline = false,
                invert_intend_guides = false,
                inverse = true, -- inverter fundo para pesquisa, diffs, etc.
                contrast = "", -- pode ser "hard", "soft" ou string vazia
                overrides = {},
                dim_inactive = false,
                transparent_mode = false,
            })
        end,
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
                disable_background = true,
                styles = {
                    italic = false,
                },
            })
        end,
    },

    -- Configuração do Nightfox com a paleta 'carbonfox'
{
	"EdenEast/nightfox.nvim",
	priority = 1000,
	config = function()
		require("nightfox").setup({
			options = {
				transparent = true,
				styles = {
					comments = "italic",
					keywords = "bold",
				},
			},
		})

		-- Definindo as cores neon personalizadas
		local colors = {
			bg = "#101010",          -- Fundo
			fg = "#ffffff",          -- Texto
			black = "#333333",       -- Preto
			red = "#ff4c4c",         -- Vermelho Neon
			green = "#00ff7f",       -- Verde Neon
			yellow = "#ffff00",      -- Amarelo Neon
			blue = "#00bfff",        -- Azul Neon
			magenta = "#ff00ff",     -- Magenta Neon
			cyan = "#00ffff",        -- Ciano Neon
			white = "#f1f1f1",       -- Branco
			gray = "#666666",        -- Cinza
		}

		-- Definindo os grupos de destaque
		vim.cmd("highlight Normal guibg=" .. colors.bg .. " guifg=" .. colors.fg)
		vim.cmd("highlight Comment guifg=" .. colors.gray .. " gui=italic")
		vim.cmd("highlight Keyword guifg=" .. colors.magenta .. " gui=bold")
		vim.cmd("highlight String guifg=" .. colors.green)
		vim.cmd("highlight Function guifg=" .. colors.blue)
		vim.cmd("highlight Variable guifg=" .. colors.white)

		-- Outras configurações de destaque...
		vim.cmd("highlight CursorLine guibg=#181818")
		vim.cmd("highlight LineNr guifg=" .. colors.gray)
		vim.cmd("highlight DiagnosticError guifg=" .. colors.red)
		vim.cmd("highlight DiagnosticWarn guifg=" .. colors.yellow)
		vim.cmd("highlight DiagnosticInfo guifg=" .. colors.blue)
		vim.cmd("highlight DiagnosticHint guifg=" .. colors.green)
		-- Adicione mais destaques conforme necessário
	end,
},


}


