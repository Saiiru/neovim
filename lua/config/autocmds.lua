-- lua/config/autocmds.lua

local function augroup(name)
  return vim.api.nvim_create_augroup("sairu_" .. name, { clear = true })
end

-- ── General Behavior ─────────────────────────────────────────────────────────

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.api.nvim_get_current_tabpage()
    vim.cmd("tabdo wincmd =")
    vim.api.nvim_set_current_tabpage(current_tab)
  end,
})

-- Go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function()
    local exclude = { "gitcommit" }
    local buf = vim.api.nvim_get_current_buf()
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(buf, "\"")
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- ── User Requested Autocmds ──────────────────────────────────────────────────

-- Keep cursor unchanged after quitting (Set back to beam)
vim.api.nvim_create_autocmd("ExitPre", {
  group = augroup("Exit"),
  command = "set guicursor=a:ver90",
  desc = "Set cursor back to beam when leaving Neovim.",
})

-- Options for markdown
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("markdown_options"),
  pattern = { "markdown", "mdx", "quarto" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = "nc"
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

-- Options for CSS-like files
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("css_options"),
  pattern = { "css", "scss", "sass", "less" },
  callback = function()
    vim.opt_local.wrap = false
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
    vim.opt_local.colorcolumn = "100"
  end,
})

-- Disable commenting next line
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("no_comment_newline"),
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

-- Hide cursor in SnacksDashboardOpened
vim.api.nvim_create_autocmd("User", {
  group = augroup("snacks_dashboard_hide_cursor"),
  pattern = "SnacksDashboardOpened",
  callback = function()
    vim.cmd([[hi Cursor blend=100]])
    vim.cmd("set guicursor+=a:Cursor/lCursor")
  end,
})

-- Unhide cursor in SnacksDashboardClosed
vim.api.nvim_create_autocmd("User", {
  group = augroup("snacks_dashboard_show_cursor"),
  pattern = "SnacksDashboardClosed",
  callback = function()
    vim.cmd([[hi Cursor blend=0]])
    vim.cmd("set guicursor+=a:Cursor/lCursor")
  end,
})

-- Autosave leve:
-- - usa `:update`, então só escreve se o buffer realmente mudou.
-- - ignora terminais, quickfix, prompts, buffers temporários e arquivos sem nome.
-- - evita escrever a cada tecla, que pesa em projetos grandes e ferramentas LSP.
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave", "InsertLeave" }, {
  group = augroup("auto_save"),
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then
      return
    end
    if not vim.bo[args.buf].modifiable or vim.bo[args.buf].readonly then
      return
    end
    if vim.api.nvim_buf_get_name(args.buf) == "" then
      return
    end
    vim.cmd("silent! update")
  end,
})
pcall(require, "config.kora-workflow")
