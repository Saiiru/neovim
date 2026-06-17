-- Enhanced UI Polish
-- Winbar, cursorline, indent guides, scrollbar, window behavior

local M = {}

function M.setup_winbar()
  local function get_winbar_content()
    local buf = vim.api.nvim_get_current_buf()
    local ft = vim.bo[buf].filetype
    local filename = vim.api.nvim_buf_get_name(buf)
    local relative = vim.fn.fnamemodify(filename, ":~:.")
    if relative == "" then
      relative = "[No Name]"
    end

    local modified = vim.bo[buf].modified and " ●" or ""
    local readonly = vim.bo[buf].readonly and " 󰌾" or ""

    -- Get LSP diagnostics count
    local diagnostics = vim.diagnostic.get(buf)
    local errors = 0
    local warnings = 0
    for _, d in ipairs(diagnostics) do
      if d.severity == vim.diagnostic.severity.ERROR then
        errors = errors + 1
      elseif d.severity == vim.diagnostic.severity.WARN then
        warnings = warnings + 1
      end
    end

    local diag_str = ""
    if errors > 0 then
      diag_str = diag_str .. " 󰅚 " .. errors
    end
    if warnings > 0 then
      diag_str = diag_str .. " 󰀪 " .. warnings
    end

    return string.format(" %s%s%s %s", relative, modified, readonly, diag_str)
  end

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "DiagnosticChanged", "FileType" }, {
    group = vim.api.nvim_create_augroup("WinbarUpdate", { clear = true }),
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      local ft = vim.bo[buf].filetype
      local bt = vim.bo[buf].buftype

      -- Skip special buffers
      local excluded_ft = {
        "alpha", "dashboard", "starter", "lazy", "mason", "TelescopePrompt",
        "noice", "notify", "Trouble", "qf", "help", "man", "srcery",
        "neotest-summary", "neotest-output-panel", "oil", "minifiles",
      }
      local excluded_bt = { "nofile", "prompt", "quickfix", "terminal" }

      if vim.tbl_contains(excluded_ft, ft) or vim.tbl_contains(excluded_bt, bt) then
        vim.opt_local.winbar = nil
        return
      end

      vim.opt_local.winbar = "%{%v:lua.require'config.ui_polish'.get_winbar()%}"
    end,
  })
end

function M.get_winbar()
  local buf = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(buf)
  local relative = vim.fn.fnamemodify(filename, ":~:.")
  if relative == "" then
    relative = "[No Name]"
  end

  local modified = vim.bo[buf].modified and " ●" or ""
  local readonly = vim.bo[buf].readonly and " 󰌾" or ""

  local diagnostics = vim.diagnostic.get(buf)
  local errors = 0
  local warnings = 0
  for _, d in ipairs(diagnostics) do
    if d.severity == vim.diagnostic.severity.ERROR then
      errors = errors + 1
    elseif d.severity == vim.diagnostic.severity.WARN then
      warnings = warnings + 1
    end
  end

  local diag_str = ""
  if errors > 0 then
    diag_str = diag_str .. " 󰅚 " .. errors
  end
  if warnings > 0 then
    diag_str = diag_str .. " 󰀪 " .. warnings
  end

  return string.format(" %s%s%s %s", relative, modified, readonly, diag_str)
end

function M.setup_cursorline()
  vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
    group = vim.api.nvim_create_augroup("CursorLineToggle", { clear = true }),
    callback = function()
      local bt = vim.bo.buftype
      local ft = vim.bo.filetype
      if not vim.tbl_contains({ "nofile", "prompt", "terminal" }, bt) then
        vim.opt_local.cursorline = true
      else
        vim.opt_local.cursorline = false
      end
    end,
  })

  vim.api.nvim_create_autocmd("WinLeave", {
    group = vim.api.nvim_create_augroup("CursorLineOff", { clear = true }),
    callback = function()
      vim.wo.cursorline = false
    end,
  })
end

function M.setup_indent_guides()
  -- Using mini.indentscope or nvim-treesitter indent
  -- This is handled by mini.indentscope plugin
end

function M.setup_scrollbar()
  -- Using mini.scrollbar or custom scrollbar
  local ok = pcall(require, "mini.scrollbar")
  if ok then
    require("mini.scrollbar").setup {
      handlers = {
        cursor = true,
        diagnostics = true,
        search = true,
      },
    }
  end
end

function M.setup_window_behavior()
  -- Window split preferences
  vim.opt.splitbelow = true
  vim.opt.splitright = true
  vim.opt.equalalways = false

  -- Floating window defaults
  vim.opt.winblend = 0
  vim.opt.pumblend = 0

  -- Border style
  vim.o.winborder = "rounded"

  -- Smooth scrolling
  if vim.fn.has("nvim-0.10") == 1 then
    vim.opt.smoothscroll = true
  end

  -- Window zoom/resize
  vim.keymap.set("n", "<leader>wz", "<C-w>|<C-w>_", { desc = "Zoom Window" })
  vim.keymap.set("n", "<leader>w=", "<C-w>=", { desc = "Equalize Windows" })
end

function M.setup()
  M.setup_winbar()
  M.setup_cursorline()
  M.setup_indent_guides()
  M.setup_scrollbar()
  M.setup_window_behavior()

  -- Signals for statusline/winbar updates
  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = vim.api.nvim_create_augroup("UIDiagUpdate", { clear = true }),
    callback = function()
      vim.cmd("redrawstatus")
    end,
  })
end

return M