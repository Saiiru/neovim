return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				theme = "tokyonight", -- Mantenha o tema que você gosta
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				icons_enabled = true,
			},
			sections = {
				lualine_a = {
					{
						"mode",
						icons_enabled = true,
						color = { fg = "#50fa7b", bg = "#282a36" }, -- Verde neon
					},
				},
				lualine_b = {
					{
						"branch",
						icon = "",
						color = { fg = "#8be9fd", bg = "#282a36" }, -- Azul neon
					},
					{
						"diff",
						colored = true,
						diff_color = {
							added = { fg = "#50fa7b" }, -- Verde neon
							modified = { fg = "#ff79c6" }, -- Rosa neon
							removed = { fg = "#ff5555" }, -- Vermelho neon
						},
					},
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = "✖", warn = "⚠", info = "ℹ", hint = "➤" },
					},
				},
				lualine_c = {
					{
						"filename",
						path = 1,
						shorting_target = 40,
						symbols = {
							modified = " ✎",
							readonly = " ",
						},
					},
				},
				lualine_x = {
					{
						"filetype",
						icon_only = true,
						color = { fg = "#bd93f9", bg = "#282a36" }, -- Roxo neon
					},
					{
						"fileformat",
						symbols = { unix = "LF", dos = "CRLF", mac = "CR" },
					},
					{
						"encoding",
						color = { fg = "#ff79c6", bg = "#282a36" }, -- Rosa neon
					},
				},
				lualine_y = {
					{
						"progress",
						color = { fg = "#8be9fd", bg = "#282a36" },
					},
				},
				lualine_z = {
					{
						"location",
						color = { fg = "#8be9fd", bg = "#282a36" },
					},
				},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			extensions = { "fugitive", "quickfix", "fzf", "lazy", "mason", "nvim-dap-ui", "oil", "trouble" },
		})
	end,
}
