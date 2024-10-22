-- LSP Support
return {
	-- LSP Configuration
	-- https://github.com/neovim/nvim-lspconfig
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	dependencies = {
		-- LSP Management
		-- https://github.com/williamboman/mason.nvim
		{ "williamboman/mason.nvim" },
		-- https://github.com/williamboman/mason-lspconfig.nvim
		{ "williamboman/mason-lspconfig.nvim" },

		-- Auto-Install LSPs, linters, formatters, debuggers
		-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
		{ "WhoIsSethDaniel/mason-tool-installer.nvim" },

		-- Useful status updates for LSP
		-- https://github.com/j-hui/fidget.nvim
		{ "j-hui/fidget.nvim", opts = {} },
		{ "ray-x/lsp_signature.nvim" },
		-- Additional lua configuration, makes nvim stuff amazing!
		-- https://github.com/folke/neodev.nvim
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup({
			-- Install these LSPs automatically
			ensure_installed = {
				"bashls",
				"cssls",
				"html",
				"gradle_ls",
				"groovyls",
				"lua_ls",
				"jdtls",
				"jsonls",
				"lemminx",
				"marksman",
				"quick_lint_js",
				"yamlls",
			},
		})

		require("mason-tool-installer").setup({
			-- Install these linters, formatters, debuggers automatically
			ensure_installed = {
				"java-debug-adapter",
				"java-test",
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"isort", -- python formatter
				"black", -- python formatter
				"pylint", -- python linter
				"eslint_d", -- js linter
			},
		})

		-- There is an issue with mason-tools-installer running with VeryLazy, since it triggers on VimEnter which has already occurred prior to this plugin loading so we need to call install explicitly
		-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim/issues/39
		vim.api.nvim_command("MasonToolsInstall")

		local lspconfig = require("lspconfig")
		local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
		local lsp_attach = function(client, bufnr)
			-- Create your keybindings here...
		end

		-- Call setup on each LSP server
		require("mason-lspconfig").setup_handlers({
			function(server_name)
				-- Don't call setup for JDTLS Java LSP because it will be setup from a separate config
				if server_name ~= "jdtls" then
					lspconfig[server_name].setup({
						on_attach = lsp_attach,
						capabilities = lsp_capabilities,
					})
				end
			end,
		})

		-- Lua LSP settings
		lspconfig.lua_ls.setup({
			settings = {
				Lua = {
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = { "vim" },
					},
				},
			},
		})
		-- Set vim motion for <Space> + c + h to show code documentation about the code the cursor is currently over if available
		vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { desc = "[C]ode [H]over Documentation" })
		-- Set vim motion for <Space> + c + d to go where the code/variable under the cursor was defined
		vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "[C]ode Goto [D]efinition" })
		-- Set vim motion for <Space> + c + a for display code action suggestions for code diagnostics in both normal and visual mode
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ctions" })
		-- Set vim motion for <Space> + c + r to display references to the code under the cursor
		vim.keymap.set(
			"n",
			"<leader>cr",
			require("telescope.builtin").lsp_references,
			{ desc = "[C]ode Goto [R]eferences" }
		)
		-- Set vim motion for <Space> + c + i to display implementations to the code under the cursor
		vim.keymap.set(
			"n",
			"<leader>ci",
			require("telescope.builtin").lsp_implementations,
			{ desc = "[C]ode Goto [I]mplementations" }
		)
		-- Set a vim motion for <Space> + c + <Shift>R to smartly rename the code under the cursor
		vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, { desc = "[C]ode [R]ename" })
		-- Set a vim motion for <Space> + c + <Shift>D to go to where the code/object was declared in the project (class file)
		vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, { desc = "[C]ode Goto [D]eclaration" })
		-- Globally configure all LSP floating preview popups (like hover, signature help, etc)
		local open_floating_preview = vim.lsp.util.open_floating_preview
		function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
			opts = opts or {}
			opts.border = opts.border or "rounded" -- Set border to rounded
			return open_floating_preview(contents, syntax, opts, ...)
		end
	end,
}
