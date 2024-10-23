local lspconfig = require("lspconfig")
local lsp_handlers = require("plugins.lsp.handlers")

lspconfig.bashls.setup({
	on_attach = lsp_handlers.on_attach,
	capabilities = lsp_handlers.capabilities,
})
