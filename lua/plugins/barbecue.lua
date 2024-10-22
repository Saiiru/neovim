return {
	"utilyre/barbecue.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"neovim/nvim-lspconfig",
		"SmiteshP/nvim-navic",
	},
	config = function()
		require("barbecue").setup({
			theme = "tokyonight", -- Mantenha o mesmo tema do lualine
			attach_navic = true, -- Habilita o suporte ao nvim-navic
			show_dirname = false, -- Não mostrar nome do diretório
			show_basename = true, -- Mostrar apenas o nome do arquivo
			symbols = {
				modified = "✎", -- Símbolos personalizados
				ellipsis = "…",
				separator = "",
			},
			highlights = {
				modified = { fg = "#00ffcc", bg = "#1e1f29" }, -- Cor do símbolo modificado
				basename = { fg = "#f8f8f2", bg = "#282a36" }, -- Cor do nome do arquivo
				separator = { fg = "#bfbfbf", bg = "#1e1f29" }, -- Cor do separador
			},
		})

		-- Cria autocmds para atualizar o barbecue em eventos relevantes
		vim.api.nvim_create_autocmd({
			"WinScrolled",
			"BufWinEnter",
			"CursorHold",
			"InsertLeave",
			"BufWritePost",
			"TextChanged",
			"TextChangedI",
		}, {
			group = vim.api.nvim_create_augroup("barbecue", {}),
			callback = function()
				require("barbecue.ui").update()
			end,
		})
	end,
}
