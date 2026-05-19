-- ================================================================================================
-- TITLE : LSP Diagnostics (Global)
-- ABOUT : Configuração global de diagnósticos com foco em clareza visual e baixo ruído.
-- NOTE  : Mantém performance (sem update agressivo em insert) e ícones legíveis.
-- ================================================================================================

local signs = {
  [vim.diagnostic.severity.ERROR] = "✘",
  [vim.diagnostic.severity.WARN] = "",
  [vim.diagnostic.severity.INFO] = "",
  [vim.diagnostic.severity.HINT] = "✹",
}

vim.diagnostic.config({
  virtual_text = {
    source = true,
    spacing = 4,
    prefix = " ",
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
    focusable = false,
    header = "",
    prefix = "",
  },
  signs = {
    text = signs,
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
    },
  },
})
