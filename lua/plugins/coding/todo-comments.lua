-- lua/plugins/coding/todo-comments.lua :: Destaque para comentários como TODO, FIXME, etc.

return {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim"},
	config = function()
		local todo_comments = require("todo-comments")

		todo_comments.setup({
			-- Palavras-chave para destacar.
			keywords = {
				FIX = {
					icon = " ",
					color = "error",
					alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
				},
				TODO = { icon = " ", color = "info" , alt = {"Personal"} },
				HACK = { icon = " ", color = "warning", alt = { "DON SKIP" } },
				WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
				PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
				NOTE = { icon = " ", color = "hint", alt = { "INFO", "READ", "COLORS", "Custom" } },
				TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
				FORGETNOT = { icon = " ", color = "hint" },
			},
            -- Configurações de highlight.
            highlight = {
                multiline = true,
                multiline_pattern = "^.",
                multiline_context = 10,
                before = "",
                keyword = "wide",
                after = "fg",
                pattern = {
                    [[.*<(KEYWORDS)\s*:]], -- Padrão padrão
                    [[<!--\s*(KEYWORDS)\s*:.*-->]], -- Comentários HTML com dois pontos
                    [[<!--\s*(KEYWORDS)\s*.*-->]], -- Comentários HTML sem dois pontos
                },
                comments_only = false,
            },
            -- Configurações de busca.
            search = {
                command = "rg",
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                },
                pattern = "\\b(KEYWORDS)\\b",
            },
		})

		-- Keymaps para navegar entre os TODOs.
		vim.keymap.set("n", "]t", function()
			todo_comments.jump_next()
		end, { desc = "Next todo comment" })

		vim.keymap.set("n", "[t", function()
			todo_comments.jump_prev()
		end, { desc = "Previous todo comment" })
	end,
}
