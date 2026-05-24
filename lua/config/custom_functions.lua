-- lua/config/custom_functions.lua

-- Toggle conceallevel between 0 and 2
function ToggleConcealLevel()
  if vim.wo.conceallevel == 0 then
    vim.wo.conceallevel = 2
  else
    vim.wo.conceallevel = 0
  end
end

-- Automatically create a file if it does not exist when opening it
function OpenFile()
  local filepath = vim.fn.expand("<cfile>")
  local escaped = vim.fn.fnameescape(filepath)
  if vim.fn.filereadable(filepath) == 0 then
    -- Create and open the file
    vim.cmd("edit " .. escaped)
    print("Created new file: " .. filepath)
  else
    -- Open the existing file
    vim.cmd("edit " .. escaped)
  end
end

-- Remove espaços no fim das linhas do buffer atual.
-- Uso manual:
--   :FixWhitespace
vim.api.nvim_create_user_command("FixWhitespace", [[%s/\s\+$//e]], {})

-- Formatação nativa: tenta Conform primeiro e cai para LSP se necessário.
-- Substitui o antigo `call CocAction('format')`.
vim.api.nvim_create_user_command("Format", function()
  local ok, conform = pcall(require, "conform")
  if ok then
    conform.format({
      async = true,
      lsp_format = "fallback",
      timeout_ms = 1500,
    })
  else
    vim.lsp.buf.format({ async = true })
  end
end, { desc = "Format current buffer with Conform/LSP" })

local severity_name = {
  [vim.diagnostic.severity.ERROR] = "ERROR",
  [vim.diagnostic.severity.WARN] = "WARN",
  [vim.diagnostic.severity.INFO] = "INFO",
  [vim.diagnostic.severity.HINT] = "HINT",
}

-- Lista de diagnósticos nativa, equivalente ao diagnosticList do Coc.
-- Uso:
--   :DiagnosticsQuickfix
--   :DiagnosticQuickfix
vim.api.nvim_create_user_command("DiagnosticsQuickfix", function(opts)
  local scope = opts.bang and 0 or nil
  local diagnostics = vim.diagnostic.get(scope)
  if vim.tbl_isempty(diagnostics) then
    vim.notify("No diagnostics found.", vim.log.levels.INFO, { title = "Diagnostics" })
    return
  end

  local items = vim.diagnostic.toqflist(diagnostics)
  for index, item in ipairs(items) do
    local diag = diagnostics[index]
    local level = severity_name[diag.severity] or "INFO"
    local code = diag.code and tostring(diag.code) or nil
    local msg = (diag.message or item.text or ""):match("([^\n]+)") or ""
    item.text = code and ("[%s|%s] %s"):format(level, code, msg) or ("[%s] %s"):format(level, msg)
  end

  vim.fn.setqflist({}, " ", {
    title = opts.bang and "Buffer Diagnostics" or "Workspace Diagnostics",
    items = items,
  })
  vim.cmd("botright copen")
end, {
  bang = true,
  desc = "Send native diagnostics to quickfix. Use bang for current buffer.",
})

vim.api.nvim_create_user_command("DiagnosticQuickfix", function(opts)
  vim.cmd(opts.bang and "DiagnosticsQuickfix!" or "DiagnosticsQuickfix")
end, { bang = true, desc = "Alias for DiagnosticsQuickfix" })

function SpellToggle(lang)
  lang = lang or "en_us,pt_br"
  local enabled = vim.wo.spell
  vim.opt_local.spell = not enabled
  vim.opt_local.spelllang = lang
  vim.notify(
    vim.opt_local.spell:get() and ("Spell enabled: " .. lang) or "Spell disabled",
    vim.log.levels.INFO,
    { title = "Spell" }
  )
end

local function set_ltex_language(lang)
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if client.name == "ltex" or client.name == "ltex_plus" then
      client.config.settings = client.config.settings or {}
      client.config.settings.ltex = client.config.settings.ltex or {}
      client.config.settings.ltex.language = lang
      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end
  end
  vim.notify("LTeX language: " .. lang, vim.log.levels.INFO, { title = "LTeX" })
end

vim.api.nvim_create_user_command("LtexEnglish", function()
  set_ltex_language("en-US")
end, { desc = "Set LTeX language to English" })

vim.api.nvim_create_user_command("LtexPortuguese", function()
  set_ltex_language("pt-BR")
end, { desc = "Set LTeX language to Portuguese" })

vim.api.nvim_create_user_command("LtexAuto", function()
  set_ltex_language("auto")
end, { desc = "Set LTeX language to auto" })

-- LSP floating window options helper
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
--- @diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "bold"
  opts.max_width = opts.max_width or 80
  opts.max_height = opts.max_height or 20
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
