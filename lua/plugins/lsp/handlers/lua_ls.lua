local lspconfig = require("lspconfig")
local lsp_handlers = require("plugins.lsp.handlers")

lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
	on_attach = lsp_handlers.on_attach,
	capabilities = lsp_handlers.capabilities,
})
