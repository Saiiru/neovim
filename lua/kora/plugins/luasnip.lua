-- LuaSnip + friendly-snippets, pronto p/ blink.cmp
return {
	{
		"L3MON4D3/LuaSnip",
		event = { "InsertEnter", "CmdlineEnter" },
		-- build = "make install_jsregexp", -- opcional (regex avançado)
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			local ls = require("luasnip")

			ls.config.set_config({
				history = true,
				updateevents = "TextChanged,TextChangedI",
				enable_autosnippets = true,
			})

			-- Snippets VSCode (globais)
			require("luasnip.loaders.from_vscode").lazy_load()
			-- Snippets pessoais em ~/.config/nvim/snippets (se existir)
			require("luasnip.loaders.from_vscode").lazy_load({
				paths = { vim.fn.stdpath("config") .. "/snippets" },
			})

			-- Estender doc-snippets por linguagem (opcional)
			local fe = ls.filetype_extend
			fe("typescript", { "tsdoc" })
			fe("javascript", { "jsdoc" })
			fe("lua", { "luadoc" })
			fe("python", { "pydoc" })
			fe("rust", { "rustdoc" })
			fe("java", { "javadoc" })
			fe("c", { "cdoc" })
			fe("cpp", { "cppdoc" })
			fe("php", { "phpdoc" })
			fe("sh", { "shelldoc" })

			-- Keymaps de navegação em snippets
			vim.keymap.set({ "i", "s" }, "<C-j>", function()
				return ls.expand_or_jumpable() and "<Plug>luasnip-expand-or-jump" or "<C-j>"
			end, { expr = true, silent = true, desc = "LuaSnip expand/jump" })

			vim.keymap.set({ "i", "s" }, "<C-k>", function()
				return ls.jumpable(-1) and "<Plug>luasnip-jump-prev" or "<C-k>"
			end, { expr = true, silent = true, desc = "LuaSnip jump back" })
		end,
	},
}
