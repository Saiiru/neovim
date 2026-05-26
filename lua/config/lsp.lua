local M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_blink, blink = pcall(require, "blink.cmp")
if ok_blink then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

M.capabilities = capabilities

local function supports_inlay_hints(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client:supports_method("textDocument/inlayHint") then
      return true
    end
  end
  return false
end

M.on_attach = function(client, bufnr)
  -- Keymaps locais do LSP: entram apenas quando um servidor conecta no buffer.
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  local has_fzf = pcall(require, "fzf-lua")

  local function diagnostic_float()
    vim.diagnostic.open_float(nil, {
      border = "rounded",
      source = "if_many",
      focusable = true,
      header = "",
      prefix = "",
    })
  end

  local function format_buffer()
    local ok_conform, conform = pcall(require, "conform")
    if ok_conform then
      conform.format({
        async = true,
        bufnr = bufnr,
        lsp_format = "fallback",
      })
    else
      vim.lsp.buf.format({ async = true, bufnr = bufnr })
    end
  end

  map("n", "K", vim.lsp.buf.hover, "Hover")
  map("n", "gd", vim.lsp.buf.definition, "Definition")
  map("n", "gD", vim.lsp.buf.declaration, "Declaration")
  map("n", "gr", function()
    if has_fzf then
      vim.cmd("FzfLua lsp_references")
    else
      vim.lsp.buf.references()
    end
  end, "References")
  map("n", "gt", vim.lsp.buf.type_definition, "Type Definition")
  map("n", "<leader>la", vim.lsp.buf.code_action, "Code Action")
  map("n", "<leader>lr", vim.lsp.buf.rename, "Rename")
  map("n", "<leader>lf", format_buffer, "Format")
  map("n", "<leader>ld", diagnostic_float, "Diagnostic Float")
  map("n", "<leader>ln", vim.diagnostic.goto_next, "Next diagnostic")
  map("n", "<leader>lp", vim.diagnostic.goto_prev, "Previous diagnostic")
  map("n", "<leader>li", function()
    if vim.lsp.inlay_hint and vim.lsp.inlay_hint.is_enabled then
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
    end
  end, "Toggle Inlay Hints")

  if client:supports_method("textDocument/documentHighlight") then
    local group = vim.api.nvim_create_augroup("sairu_lsp_highlight_" .. bufnr, { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
      desc = "Highlight symbol under cursor",
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
      desc = "Clear LSP symbol highlights",
    })
  end

  if supports_inlay_hints(bufnr) then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end

  -- Hooks por linguagem/servidor (sem custo para outros buffers)
  if client and client.name == "clangd" then
    map("n", "<leader>cH", "<cmd>ClangdSwitchSourceHeader<cr>", "C/C++ Switch Source/Header")
  end

  if client and client.name == "gopls" then
    map("n", "<leader>co", function()
      vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" }, diagnostics = {} },
        apply = true,
        bufnr = bufnr,
      })
    end, "Go Organize Imports")
  end

  if client and (client.name == "basedpyright" or client.name == "pyright") then
    map("n", "<leader>co", function()
      vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" }, diagnostics = {} },
        apply = true,
        bufnr = bufnr,
      })
    end, "Python Organize Imports")
  end
end

function M.setup(server, opts)
  opts = opts or {}
  opts.capabilities = vim.tbl_deep_extend("force", {}, M.capabilities, opts.capabilities or {})
  opts.on_attach = opts.on_attach or M.on_attach
  vim.lsp.config(server, opts)
  vim.lsp.enable(server)
end

return M
