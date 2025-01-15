local M = {}

-- Set initial state for diagnostic level
vim.g.diagnostics_level = "all"

-- Function to toggle diagnostic level
function M.toggle_diagnostics_level()
  if vim.g.diagnostics_level == "all" then
    M.set_diagnostics_level("error")
  else
    M.set_diagnostics_level("all")
  end
end

--- Change diagnostic level
---@param level 'all' | 'error'
function M.set_diagnostics_level(level)
  vim.g.diagnostics_level = level
  vim.notify("Diagnostics level: " .. level, "info", { title = "Diagnostics" })

  local severity = {
    all = vim.diagnostic.severity.HINT,
    error = vim.diagnostic.severity.ERROR,
    warning = vim.diagnostic.severity.WARN,
    information = vim.diagnostic.severity.INFO,
  }

  local virtual_text_severity = severity[level] or vim.diagnostic.severity.HINT

  vim.diagnostic.config({
    severity_sort = true,
    underline = true,
    signs = true,
    virtual_text = {
      prefix = "●", -- More visible prefix for diagnostics
      spacing = 3, -- Increase spacing for better visibility
      severity = virtual_text_severity,
      source = "always", -- Show the source of the diagnostics in virtual text
    },
    float = {
      source = "always", -- Show source in floating window
      header = "Diagnostics:", -- Header for the floating window
    },
    signs = {
      error = "✘", -- Custom error sign
      warn = "⚠️", -- Custom warning sign
      info = "ℹ️", -- Custom info sign
      hint = "💡", -- Custom hint sign
    },
  })

  -- Use a custom icon for each severity
  local icons = {
    [vim.diagnostic.severity.ERROR] = "✘",
    [vim.diagnostic.severity.WARN] = "⚠️",
    [vim.diagnostic.severity.INFO] = "ℹ️",
    [vim.diagnostic.severity.HINT] = "💡",
  }

  -- Update the signs for each severity level
  vim.fn.sign_define(
    "DiagnosticSignError",
    { text = icons[vim.diagnostic.severity.ERROR], texthl = "DiagnosticSignError" }
  )
  vim.fn.sign_define(
    "DiagnosticSignWarn",
    { text = icons[vim.diagnostic.severity.WARN], texthl = "DiagnosticSignWarn" }
  )
  vim.fn.sign_define(
    "DiagnosticSignInfo",
    { text = icons[vim.diagnostic.severity.INFO], texthl = "DiagnosticSignInfo" }
  )
  vim.fn.sign_define(
    "DiagnosticSignHint",
    { text = icons[vim.diagnostic.severity.HINT], texthl = "DiagnosticSignHint" }
  )

  -- Update highlighting for different severity levels
  vim.cmd("highlight DiagnosticSignError guifg=#E06C75") -- Red
  vim.cmd("highlight DiagnosticSignWarn guifg=#E5C07B") -- Yellow
  vim.cmd("highlight DiagnosticSignInfo guifg=#61AFEF") -- Blue
  vim.cmd("highlight DiagnosticSignHint guifg=#98C379") -- Green
end

return M
