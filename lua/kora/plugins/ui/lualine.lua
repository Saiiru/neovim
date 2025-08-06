-- ═════════════════════════════════════════════════════════════════════════
--  STATUS LINE - NEURAL HUD DISPLAY
-- ═════════════════════════════════════════════════════════════════════════
-- LUALINE (BARRA DE STATUS):
-- Mostra automaticamente:
-- - Modo atual (N/I/V/C)
-- - Branch do git
-- - Diagnósticos (erros/avisos)
-- - Tipo de arquivo
-- - Nome do arquivo (com path)
-- - LSP servers ativos
-- - Diff do git (+/~/-)
-- - Posição do cursor
-- - Horário atual
--
-- COMANDOS ÚTEIS:
-- :Lazy                        -- Gerenciar plugins
-- :Mason                       -- Gerenciar LSP servers
-- :checkhealth                 -- Verificar saúde do sistema
-- :LspInfo                     -- Status dos LSP servers
-- :NvimTreeFindFile           -- Localizar arquivo no explorador
-- :Telescope commands         -- Ver todos comandos disponíveis
-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║            KORA NEURAL STATUS HUD - LUALINE CONFIGURATION               ║
-- ╚══════════════════════════════════════════════════════════════════════════╝
return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	init = function()
		vim.g.lualine_laststatus = vim.o.laststatus
		if vim.fn.argc(-1) > 0 then
			vim.o.statusline = " "
		else
			vim.o.laststatus = 0
		end
	end,
	opts = function()
		vim.o.laststatus = vim.g.lualine_laststatus

		local icons = {
			diagnostics = {
				Error = "", -- NF: x-filled
				Warn = "", -- NF: warning triangle
				Hint = "󰌶", -- NF: lightbulb/hint
				Info = "", -- NF: info circle
			},
			git = {
				added = "", -- plus
				modified = "", -- pencil
				removed = "", -- minus
			},
			evil = "", -- evil eye
			lsp = "󰒋", -- LSP icon
			clock = "󱑎",
			separator_left = "",
			separator_right = "",
		}

		-- Get current LSP clients for buffer
		local function lsp_clients()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if #clients == 0 then
				return ""
			end
			local names = {}
			for _, client in ipairs(clients) do
				table.insert(names, client.name)
			end
			return icons.lsp .. " " .. table.concat(names, " ")
		end

		-- Show evil eye if insert/replace/visual mode
		local function evil_eye()
			local mode = vim.fn.mode()
			if mode:find("[iRvVsS]") then
				return icons.evil
			end
			return ""
		end

		return {
			options = {
				theme = "auto",
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
				component_separators = { left = "", right = "" },
				section_separators = { left = icons.separator_left, right = icons.separator_right },
			},
			sections = {
				lualine_a = {
					{
						function()
							return evil_eye()
						end,
						color = { fg = "#FF79C6", gui = "bold" },
						padding = { left = 1, right = 0 },
					},
					{
						"mode",
						fmt = function(str)
							return " " .. str:sub(1, 1) .. " "
						end,
						separator = "",
						color = { fg = "#1E1E2E", bg = "#7B68EE", gui = "bold" },
						padding = { left = 0, right = 1 },
					},
				},
				lualine_b = {
					{
						"branch",
						icon = "",
						color = { fg = "#8BE9FD", gui = "bold" },
					},
					{
						"diff",
						symbols = {
							added = icons.git.added,
							modified = icons.git.modified,
							removed = icons.git.removed,
						},
						source = function()
							local gitsigns = vim.b.gitsigns_status_dict
							if gitsigns then
								return {
									added = gitsigns.added,
									modified = gitsigns.changed,
									removed = gitsigns.removed,
								}
							end
						end,
						color = { fg = "#FFB86C" },
					},
				},
				lualine_c = {
					{
						"diagnostics",
						symbols = {
							error = icons.diagnostics.Error .. " ",
							warn = icons.diagnostics.Warn .. " ",
							info = icons.diagnostics.Info .. " ",
							hint = icons.diagnostics.Hint .. " ",
						},
						always_visible = false,
					},
					{
						"filetype",
						icon_only = true,
						separator = "",
						padding = { left = 1, right = 0 },
					},
					{
						"filename",
						path = 1,
						symbols = {
							modified = " ●",
							readonly = " ",
							unnamed = "[No Name]",
						},
						color = { fg = "#F8F8F2", gui = "bold" },
						padding = { left = 1, right = 1 },
					},
				},
				lualine_x = {
					{
						lsp_clients,
						color = { fg = "#8BE9FD" },
						separator = "",
						padding = { left = 1, right = 1 },
					},
				},
				lualine_y = {
					{
						"progress",
						separator = " ",
						color = { fg = "#FFB86C", gui = "bold" },
						padding = { left = 1, right = 0 },
					},
					{
						"location",
						color = { fg = "#7B68EE" },
						padding = { left = 0, right = 1 },
					},
				},
				lualine_z = {
					{
						function()
							return icons.clock .. " " .. os.date("%H:%M")
						end,
						color = { fg = "#FF79C6", gui = "bold" },
						separator = { right = icons.separator_right },
						padding = { left = 1, right = 2 },
					},
				},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					{
						"filename",
						path = 1,
						symbols = {
							modified = " ●",
							readonly = " ",
							unnamed = "[No Name]",
						},
						color = { fg = "#6C7086" },
					},
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			extensions = { "nvim-tree", "lazy", "trouble", "quickfix" },
		}
	end,
}
