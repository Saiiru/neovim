-- lua/langs/shared.lua
local M = {}

local nvim_010 = vim.fn.has("nvim-0.10") == 1

-- Preferir capabilities do Blink.cmp; fallback para cmp-nvim-lsp
function M.capabilities()
  local caps = vim.lsp.protocol.make_client_capabilities()
  local ok_blink, blink = pcall(require, "blink.cmp")
  if ok_blink and blink.get_lsp_capabilities then
    caps = blink.get_lsp_capabilities(caps)
  else
    local ok_cmp, cmp = pcall(require, "cmp_nvim_lsp")
    if ok_cmp and cmp.default_capabilities then
      caps = cmp.default_capabilities(caps)
    end
  end
  return caps
end

function M.on_attach(client, bufnr)
  -- Inlay hints NVIM 0.10+
  local ih = vim.lsp.inlay_hint
  if nvim_010 and client.server_capabilities and client.server_capabilities.inlayHintProvider and ih then
    pcall(ih.enable, true, { bufnr = bufnr })
  end

  local function map(mode, lhs, rhs, desc, extra)
    local o = { buffer = bufnr, silent = true, desc = desc }
    if extra then for k, v in pairs(extra) do o[k] = v end end
    vim.keymap.set(mode, lhs, rhs, o)
  end

  -- Glance se existir, fallback LSP/Telescope
  if pcall(require, "glance") then
    map("n", "gd", "<cmd>Glance definitions<cr>", "Goto Definition")
    map("n", "gr", "<cmd>Glance references<cr>", "Goto References")
    map("n", "gy", "<cmd>Glance type_definitions<cr>", "Goto Type")
    map("n", "gI", "<cmd>Glance implementations<cr>", "Goto Impl")
  else
    local ok_tb, tb = pcall(require, "telescope.builtin")
    if ok_tb then
      map("n", "gd", tb.lsp_definitions, "Goto Definition")
      map("n", "gr", tb.lsp_references, "Goto References")
      map("n", "gy", tb.lsp_type_definitions, "Goto Type")
      map("n", "gI", tb.lsp_implementations, "Goto Impl")
    else
      map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
      map("n", "gr", vim.lsp.buf.references, "Goto References")
      map("n", "gy", vim.lsp.buf.type_definition, "Goto Type")
      map("n", "gI", vim.lsp.buf.implementation, "Goto Impl")
    end
  end

  map({ "n", "v" }, "<leader>ca", function() require("actions-preview").code_actions() end, "Code Action")
  map("n", "<leader>cr", function() return ":IncRename " .. vim.fn.expand("<cword>") end, "Rename", { expr = true })
  map("n", "K", vim.lsp.buf.hover, "Hover")
  map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
  map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
  map("n", "gl", vim.diagnostic.open_float, "Line diagnostics")
end

function M.setup_diagnostics()
  vim.diagnostic.config({
    virtual_text = true,
    severity_sort = true,
    float = { border = "rounded", source = "if_many" },
    signs = true,
    underline = true,
    update_in_insert = false,
  })
end

return M