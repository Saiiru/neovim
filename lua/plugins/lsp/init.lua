-- LSP Support Configuration for Neovim
return {
	-- LSP Configuration Plugin
	"neovim/nvim-lspconfig",
	event = "VeryLazy",

	-- Dependencies for LSP Management
	dependencies = {
		-- Mason for managing LSP installations
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
		"j-hui/fidget.nvim", -- Status updates for LSP
		"folke/neodev.nvim", -- Additional Lua configuration
		"ray-x/lsp_signature.nvim", -- Function signature help
		"hrsh7th/cmp-emoji", -- Emoji completion
		"hrsh7th/cmp-nvim-lua", -- Lua completion
		"smjonas/inc-rename.nvim", -- Incremental renaming
		"onsails/lspkind.nvim", -- VSCode-like icons
		"jay-babu/mason-nvim-dap.nvim", -- DAP integration
		"mfussenegger/nvim-dap", -- Debug Adapter Protocol
		"mfussenegger/nvim-jdtls", -- Java LSP
		"kosayoda/nvim-lightbulb", -- Lightbulb for code actions
		"SmiteshP/nvim-navic", -- Navigation icons
		"folke/todo-comments.nvim", -- TODO comments highlighting
		"folke/trouble.nvim", -- Trouble diagnostics
		"utilyre/barbecue.nvim", -- Status line component
	},

	-- LSP Setup Function
	config = function()
		local lspconfig = require("lspconfig")
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")

		-- Ensure Mason is set up
		mason.setup()

		-- Automatically install language servers
		mason_lspconfig.setup({
			ensure_installed = {
				"ts_ls", -- TypeScript
				"pyright", -- Python
				"gopls", -- Go
				"clangd", -- C/C++
				"sumneko_lua", -- Lua
				"html", -- HTML
				"cssls", -- CSS
				"jsonls", -- JSON
				"jdtls", -- Java
			},
		})
		-- Mason Tool Installer Setup
		require("mason-tool-installer").setup({
			ensure_installed = {
				"java-debug-adapter",
				"java-test",
				"prettier", -- Formatter for JavaScript/TypeScript
				"stylua", -- Lua formatter
				"isort", -- Python formatter
				"black", -- Python formatter
				"pylint", -- Python linter
				"eslint_d", -- JavaScript linter
			},
		})

		-- LSP configuration for each language server
		lspconfig.ts_ls.setup({})
		lspconfig.pyright.setup({})
		lspconfig.gopls.setup({})
		lspconfig.clangd.setup({})
		lspconfig.sumneko_lua.setup({})
		lspconfig.html.setup({})
		lspconfig.cssls.setup({})
		lspconfig.jsonls.setup({})
		lspconfig.jdtls.setup({})

		-- Optional: Set up additional configurations here as needed
	end,
}
