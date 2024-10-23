local lspconfig = require("lspconfig")
local lsp_handlers = require("plugins.lsp.handlers")

lspconfig.yamlls.setup({
	on_attach = lsp_handlers.on_attach,
	capabilities = lsp_handlers.capabilities,
})
