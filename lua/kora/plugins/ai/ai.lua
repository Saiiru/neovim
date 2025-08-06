-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                    KORA AI INTEGRATION MATRIX                           ║
-- ║                      NEURAL ASSISTANT PROTOCOLS                         ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
	-- ═════════════════════════════════════════════════════════════════════════
	--  GITHUB COPILOT - NEURAL CODE ASSISTANT
	-- ═════════════════════════════════════════════════════════════════════════
	{
		"github/copilot.vim",
		event = "InsertEnter",
		config = function()
			-- Disable default tab mapping
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true
			vim.g.copilot_tab_fallback = ""

			-- Enable for specific filetypes
			vim.g.copilot_filetypes = {
				["*"] = false,
				javascript = true,
				typescript = true,
				javascriptreact = true,
				typescriptreact = true,
				lua = true,
				rust = true,
				c = true,
				["c#"] = true,
				["c++"] = true,
				cpp = true,
				go = true,
				python = true,
				java = true,
				html = true,
				css = true,
				scss = true,
				json = true,
				yaml = true,
				markdown = true,
				sh = true,
				zsh = true,
				fish = true,
				vue = true,
				svelte = true,
				php = true,
				dart = true,
				kotlin = true,
				scala = true,
				swift = true,
				ruby = true,
				elixir = true,
				haskell = true,
				ocaml = true,
				dockerfile = true,
				makefile = true,
				toml = true,
				ini = true,
				conf = true,
				gitcommit = true,
				gitconfig = true,
				gitignore = true,
			}

			-- Key mappings for Copilot
			local keymap = vim.keymap.set
			local opts = { silent = true, expr = true, replace_keycodes = false }

			-- Accept suggestion with Ctrl+J (main accept key)
			keymap("i", "<C-J>", 'copilot#Accept("\\<CR>")', opts)

			-- Alternative accept with Ctrl+; (easier to reach)
			keymap("i", "<C-;>", 'copilot#Accept("\\<CR>")', opts)

			-- Accept word/line with Ctrl+L/H
			keymap("i", "<C-L>", "<Plug>(copilot-accept-word)", { silent = true })
			keymap("i", "<C-H>", "<Plug>(copilot-accept-line)", { silent = true })

			-- Navigate suggestions
			keymap("i", "<M-]>", "<Plug>(copilot-next)", { silent = true })
			keymap("i", "<M-[>", "<Plug>(copilot-previous)", { silent = true })

			-- Trigger and dismiss
			keymap("i", "<C-\\>", "<Plug>(copilot-suggest)", { silent = true })
			keymap("i", "<M-\\>", "<Plug>(copilot-dismiss)", { silent = true })

			-- Status and commands
			vim.api.nvim_create_user_command("CopilotStatus", function()
				vim.cmd("Copilot status")
			end, { desc = "Show Copilot status" })

			vim.api.nvim_create_user_command("CopilotEnable", function()
				vim.cmd("Copilot enable")
				vim.notify("󰚩 Copilot Enabled", vim.log.levels.INFO)
			end, { desc = "Enable Copilot" })

			vim.api.nvim_create_user_command("CopilotDisable", function()
				vim.cmd("Copilot disable")
				vim.notify("󰚩 Copilot Disabled", vim.log.levels.WARN)
			end, { desc = "Disable Copilot" })

			-- REMOVED: Auto notifications that were spamming
			-- Only notify on manual enable/disable commands now
		end,
	},

	-- ═════════════════════════════════════════════════════════════════════════
	--  COPILOT CHAT - INTERACTIVE AI ASSISTANT
	-- ═════════════════════════════════════════════════════════════════════════
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim" },
		},
		cmd = "CopilotChat",
		opts = {
			debug = false,
			proxy = nil,
			allow_insecure = false,

			system_prompt = [[
You are an AI programming assistant integrated into the KORA Neural Development Matrix.
When asked for your name, you must respond with "KORA AI Assistant".
Follow the user's requirements carefully & to the letter.
Your expertise includes:
- All programming languages and frameworks
- Code optimization and debugging
- Architecture and design patterns
- Best practices and conventions
- Performance optimization
- Security considerations

Always provide clear, concise, and practical solutions.
Use neural network terminology when appropriate to maintain the cyberpunk aesthetic.
]],

			model = "gpt-4",
			temperature = 0.1,

			question_header = "##  KORA Query ",
			answer_header = "##  Neural Response ",
			error_header = "## ⚠️ System Error ",

			separator = " ─── ",

			show_folds = true,
			show_help = false,
			auto_follow_cursor = true,
			auto_insert_mode = false,
			insert_at_end = false,
			clear_chat_on_new_prompt = false,
			highlight_selection = true,
			highlight_headers = true,

			context = nil,
			history_path = vim.fn.stdpath("data") .. "/copilot_chat_history",
			callback = nil,

			selection = function(source)
				local select = require("CopilotChat.select")
				return select.visual(source) or select.buffer(source)
			end,

			prompts = {
				Explain = {
					prompt = "/COPILOT_EXPLAIN Analyze and explain this code in detail, including its purpose, logic, and any potential improvements.",
					mapping = "<leader>ce",
					description = " AI Code Explanation",
				},
				Review = {
					prompt = "/COPILOT_REVIEW Review this code for potential issues, bugs, performance problems, and suggest improvements following best practices.",
					mapping = "<leader>cr",
					description = " AI Code Review",
				},
				Fix = {
					prompt = "/COPILOT_GENERATE There is a problem in this code. Rewrite the code to fix the problem.",
					mapping = "<leader>cF",
					description = " AI Fix Code",
				},
				Optimize = {
					prompt = "/COPILOT_GENERATE Optimize this code for better performance, readability, and maintainability.",
					mapping = "<leader>co",
					description = " AI Optimize Code",
				},
				Docs = {
					prompt = "/COPILOT_GENERATE Please add documentation comments to this code. Use appropriate documentation format for the language.",
					mapping = "<leader>cd",
					description = " AI Generate Docs",
				},
				Tests = {
					prompt = "/COPILOT_GENERATE Please generate comprehensive unit tests for this code. Include edge cases and error scenarios.",
					mapping = "<leader>ct",
					description = " AI Generate Tests",
				},
				Refactor = {
					prompt = "/COPILOT_GENERATE Please refactor this code to improve its structure, readability, and maintainability while preserving functionality.",
					mapping = "<leader>cR",
					description = " AI Refactor Code",
				},
				BugHunt = {
					prompt = "Analyze this code for potential bugs, security vulnerabilities, and logical errors. Provide detailed explanations and solutions.",
					mapping = "<leader>cb",
					description = " AI Bug Analysis",
				},
				Performance = {
					prompt = "Analyze this code for performance bottlenecks and suggest optimizations. Consider time and space complexity.",
					mapping = "<leader>cp",
					description = " AI Performance Analysis",
				},
				Architecture = {
					prompt = "Review this code's architecture and design patterns. Suggest improvements for scalability and maintainability.",
					mapping = "<leader>ca",
					description = " AI Architecture Review",
				},
			},

			window = {
				layout = "vertical",
				width = 0.4,
				height = 0.6,
				row = nil,
				col = nil,
				relative = "editor",
				border = "rounded",
				title = " KORA AI Chat",
				footer = nil,
				zindex = 1,
			},

			mappings = {
				complete = {
					detail = "Use @<Tab> or /<Tab> for options.",
					insert = "<Tab>",
				},
				close = {
					normal = "q",
					insert = "<C-c>",
				},
				reset = {
					normal = "<C-r>",
					insert = "<C-r>",
				},
				submit_prompt = {
					normal = "<CR>",
					insert = "<C-s>",
				},
				accept_diff = {
					normal = "<C-y>",
					insert = "<C-y>",
				},
				yank_diff = {
					normal = "gy",
					register = '"',
				},
				show_diff = {
					normal = "gd",
				},
				show_system_prompt = {
					normal = "gp",
				},
				show_user_selection = {
					normal = "gs",
				},
			},
		},

		config = function(_, opts)
			local chat = require("CopilotChat")
			chat.setup(opts)

			-- Custom user commands
			vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
				chat.ask(args.args, { selection = require("CopilotChat.select").visual })
			end, { nargs = "*", range = true, desc = "CopilotChat - Ask with visual selection" })

			vim.api.nvim_create_user_command("CopilotChatInline", function(args)
				chat.ask(args.args, {
					selection = require("CopilotChat.select").visual,
					window = {
						layout = "float",
						title = " KORA AI Inline Chat",
						width = 0.8,
						height = 0.6,
						border = "rounded",
					},
				})
			end, { nargs = "*", range = true, desc = "CopilotChat - Inline chat" })

			vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
				chat.ask(args.args, { selection = require("CopilotChat.select").buffer })
			end, { nargs = "*", desc = "CopilotChat - Ask about buffer" })

			-- Key mappings
			local keymap = vim.keymap.set

			-- Main chat commands
			keymap("n", "<leader>cc", "<cmd>CopilotChat<cr>", { desc = " Open Copilot Chat" })
			keymap("n", "<leader>cq", function()
				local input = vim.fn.input("Quick Chat: ")
				if input ~= "" then
					chat.ask(input, { selection = require("CopilotChat.select").buffer })
				end
			end, { desc = " Quick Chat" })

			-- Visual mode mappings
			keymap("v", "<leader>cc", "<cmd>CopilotChatVisual<cr>", { desc = " Chat with selection" })
			keymap("v", "<leader>ci", "<cmd>CopilotChatInline<cr>", { desc = " Inline chat" })

			-- Additional utility mappings
			keymap("n", "<leader>ch", function()
				local actions = require("CopilotChat.actions")
				require("CopilotChat.integrations.telescope").pick(actions.help_actions())
			end, { desc = " Chat Help Actions" })

			keymap("n", "<leader>cm", function()
				local actions = require("CopilotChat.actions")
				require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
			end, { desc = " Chat Prompt Actions" })

			-- Reset chat
			keymap("n", "<leader>cx", function()
				chat.reset()
				vim.notify("󰚩 KORA AI Chat Reset", vim.log.levels.INFO)
			end, { desc = " Reset Chat" })

			-- Save chat
			keymap("n", "<leader>cs", function()
				chat.save()
				vim.notify("󰚩 KORA AI Chat Saved", vim.log.levels.INFO)
			end, { desc = " Save Chat" })

			-- Auto-complete for chat buffers
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-*",
				callback = function()
					vim.opt_local.relativenumber = true
					vim.opt_local.number = true
				end,
			})

			-- REMOVED: Success notification that was spamming
			-- Only show notifications on manual actions now
		end,

		keys = {
			{ "<leader>cc", "<cmd>CopilotChat<cr>", desc = " Copilot Chat", mode = "n" },
			{ "<leader>cc", "<cmd>CopilotChatVisual<cr>", desc = " Copilot Chat", mode = "v" },
			{ "<leader>ci", "<cmd>CopilotChatInline<cr>", desc = " Inline Chat", mode = "v" },
			{
				"<leader>cq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
					end
				end,
				desc = " Quick Chat",
			},
		},
	},
}
-- ══════════════════════════════════════════════════════════════════════════
-- EXEMPLOS DE USO - AI.LUA
-- ══════════════════════════════════════════════════════════════════════════
-- Este arquivo configura a integração com IA (GitHub Copilot):
--
-- GITHUB COPILOT (SUGESTÕES DE CÓDIGO):
-- <C-J>                        -- Aceitar sugestão principal
-- <C-;>                        -- Aceitar sugestão (alternativo)
-- <C-L>                        -- Aceitar apenas a palavra
-- <C-H>                        -- Aceitar apenas a linha
-- <M-]>                        -- Próxima sugestão
-- <M-[>                        -- Sugestão anterior
-- <C-\>                        -- Forçar sugestão
-- <M-\>                        -- Dispensar sugestão
--
-- COMANDOS COPILOT:
-- :Copilot status              -- Status da conexão
-- :Copilot enable              -- Ativar Copilot
-- :Copilot disable             -- Desativar Copilot
-- :CopilotStatus               -- Comando customizado de status
-- :CopilotEnable               -- Ativar com notificação
-- :CopilotDisable              -- Desativar com notificação
--
-- LINGUAGENS SUPORTADAS:
-- JavaScript, TypeScript, React, Vue, Svelte
-- Python, Go, Rust, C/C++, Java, C#
-- HTML, CSS, SCSS, JSON, YAML, Markdown
-- Shell scripts, Dockerfile, Makefile
-- Git config files, TOML, INI
--
-- COPILOT CHAT (ASSISTENTE CONVERSACIONAL):
-- <leader>cc                   -- Abrir chat principal
-- <leader>cq                   -- Chat rápido com input
-- <leader>cc (visual)          -- Chat com seleção
-- <leader>ci (visual)          -- Chat inline (popup)
-- <leader>cx                   -- Reset do chat
-- <leader>cs                   -- Salvar histórico do chat
-- <leader>ch                   -- Ações de ajuda
-- <leader>cm                   -- Menu de prompts
--
-- PROMPTS PRÉ-DEFINIDOS:
-- <leader>ce                   -- Explicar código selecionado
-- <leader>cr                   -- Review de código
-- <leader>cF                   -- Corrigir código
-- <leader>co                   -- Otimizar código
-- <leader>cd                   -- Gerar documentação
-- <leader>ct                   -- Gerar testes
-- <leader>cR                   -- Refatorar código
-- <leader>cb                   -- Análise de bugs
-- <leader>cp                   -- Análise de performance
-- <leader>ca                   -- Review de arquitetura
--
-- NO CHAT WINDOW:
-- <CR>                         -- Enviar mensagem
-- <C-s>                        -- Enviar (insert mode)
-- q                            -- Fechar chat
-- <C-c>                        -- Fechar (insert mode)
-- <C-r>                        -- Reset conversa
-- <C-y>                        -- Aceitar diff sugerido
-- gy                           -- Copiar diff
-- gd                           -- Mostrar diff
-- gp                           -- Mostrar system prompt
-- gs                           -- Mostrar seleção do usuário
--
-- COMANDOS CUSTOMIZADOS:
-- :CopilotChat                 -- Abrir chat principal
-- :CopilotChatVisual           -- Chat com seleção visual
-- :CopilotChatInline           -- Chat em popup
-- :CopilotChatBuffer           -- Chat sobre buffer inteiro
--
-- EXEMPLOS DE USO DO CHAT:
-- "Explique esta função"       -- Análise de código
-- "Como otimizar este código?" -- Sugestões de melhoria
-- "Gere testes para isso"      -- Criação de testes
-- "Tem algum bug aqui?"        -- Detecção de problemas
-- "Refatore esta classe"       -- Reestruturação
-- "Documente este módulo"      -- Geração de docs
-- "Como implementar X?"        -- Ajuda com implementação
-- "Qual o padrão melhor?"      -- Sugestões de design patterns
--
-- INTEGRAÇÃO COM TELESCOPE:
-- <leader>ch                   -- Menu de ações com Telescope
-- <leader>cm                   -- Menu de prompts com Telescope
--
-- FLUXO DE TRABALHO TÍPICO:
-- 1. Escrever código com sugestões do Copilot
-- 2. Selecionar código problemático (visual mode)
-- 3. <leader>cc para abrir chat com seleção
-- 4. Fazer pergunta específica sobre o código
-- 5. Aplicar sugestões ou usar <C-y> para aceitar diff
-- 6. Continuar desenvolvimento com assistência IA
--
-- HISTÓRICO E PERSISTÊNCIA:
-- O chat salva automaticamente em ~/.local/share/nvim/copilot_chat_history
-- Use <leader>cs para salvar manualmente
-- Use <leader>cx para limpar conversa atual
