return {
	{
		"folke/noice.nvim",
		event = "VeryLazy", -- Lê de forma preguiçosa para otimizar o desempenho
		opts = {
			routes = {
				{
					filter = {
						event = "notify", -- Filtra notificações
						find = "No information available", -- Ignora mensagens de informação ausente
					},
					opts = { skip = true }, -- Pula essa notificação
				},
				{
					filter = {
						event = "msg_show", -- Adiciona um filtro para mensagens normais
						find = "error", -- Filtra mensagens de erro
					},
					opts = {
						skip = false, -- Não pula mensagens de erro
						hl_group = "ErrorMsg", -- Destaca as mensagens de erro
					},
				},
			},
			presets = {
				bottom_search = false, -- Usa um cmdline clássico para busca
				command_palette = true, -- Posiciona o cmdline e o popupmenu juntos
				long_message_to_split = true, -- Mensagens longas serão enviadas para um split
				inc_rename = false, -- Habilita um diálogo de entrada para inc-rename.nvim
				lsp_doc_border = true, -- Adiciona uma borda em documentos LSP
				cmdline_output = "vertical", -- Saída do comando em modo vertical
			},
			messages = {
				enabled = true, -- Habilita mensagens personalizadas
			},
			lsp = {
				-- Override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = false,
					["vim.lsp.util.stylize_markdown"] = false,
					["cmp.entry.get_documentation"] = true,
				},
				progress = {
					enabled = false,
				},
				hover = {
					enabled = false,
				},
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim", -- Dependência para UI personalizada
			"rcarriga/nvim-notify", -- Notificações estilizadas
			{ "ray-x/lsp_signature.nvim" },
		},
	},
}
