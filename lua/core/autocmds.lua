-- lua/core/autocmds.lua
local api, fn = vim.api, vim.fn

-- ========= Helpers =========
local function term_run(cmd, opts)
  opts = opts or {}
  local height = opts.height or 12
  vim.cmd("w") -- salva antes de rodar
  vim.cmd("botright " .. height .. "split")
  vim.cmd("terminal bash -lc " .. fn.fnameescape(cmd))
  vim.cmd("resize " .. height)
  vim.cmd("startinsert")
end

local function has_file(root, names)
  local r = vim.fs.root(0, names)
  return r ~= nil
end

-- ========= Code Runners (buffer-local <leader>R) =========
local runners = {
  javascript = function() return "node " .. fn.shellescape(fn.expand("%:p")) end,
  typescript = function()
    if fn.executable("tsx") == 1 then
      return "tsx " .. fn.shellescape(fn.expand("%:p"))
    elseif fn.executable("ts-node") == 1 then
      return "ts-node " .. fn.shellescape(fn.expand("%:p"))
    else
      return "node --loader ts-node/esm " .. fn.shellescape(fn.expand("%:p"))
    end
  end,
  lua = function() return "lua " .. fn.shellescape(fn.expand("%:p")) end,
  python = function() return (fn.executable("python3")==1 and "python3 " or "python ") .. fn.shellescape(fn.expand("%:p")) end,
  sh = function() return "bash " .. fn.shellescape(fn.expand("%:p")) end,
  c = function()
    local src = fn.expand("%:p")
    local out = fn.expand("%:r")
    return ("gcc %s -O2 -Wall -Wextra -o %s && %s"):format(fn.shellescape(src), fn.shellescape(out), fn.shellescape(out))
  end,
  cpp = function()
    local src = fn.expand("%:p")
    local out = fn.expand("%:r")
    return ("g++ %s -std=c++20 -O2 -Wall -Wextra -o %s && %s"):format(fn.shellescape(src), fn.shellescape(out), fn.shellescape(out))
  end,
  go = function() return "go run " .. fn.shellescape(fn.expand("%:p")) end,
  rust = function()
    if has_file({ "Cargo.toml" }) then
      return "cargo run"
    else
      local src = fn.expand("%:p")
      local out = fn.expand("%:r")
      return ("rustc %s -O -o %s && %s"):format(fn.shellescape(src), fn.shellescape(out), fn.shellescape(out))
    end
  end,
  java = function()
    -- Preferir JDTLS se quiser depurar; aqui é runner simples para arquivos únicos.
    local file = fn.expand("%:p")
    local dir = fn.expand("%:h")
    local main = fn.expand("%:t:r")
    return ("javac %s && java -cp %s %s"):format(fn.shellescape(file), fn.shellescape(dir), fn.shellescape(main))
  end,
}

api.nvim_create_augroup("CodeRunnerMap", { clear = true })
api.nvim_create_autocmd("FileType", {
  group = "CodeRunnerMap",
  pattern = vim.tbl_keys(runners),
  callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    local make = runners[ft]
    if not make then return end
    vim.keymap.set("n", "<leader>R", function()
      local cmd = make()
      term_run(cmd, { height = 12 })
    end, { buffer = ev.buf, silent = true, desc = "Run current file" })
  end,
})

-- ========= Markdown options =========
api.nvim_create_augroup("MarkdownOpts", { clear = true })
api.nvim_create_autocmd("FileType", {
  group = "MarkdownOpts",
  pattern = { "markdown" },
  callback = function(ev)
    vim.bo[ev.buf].expandtab = true
    vim.bo[ev.buf].tabstop = 2
    vim.bo[ev.buf].shiftwidth = 2
    vim.bo[ev.buf].softtabstop = 2
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.conceallevel = 0
  end,
})

-- ========= Desabilitar continuação automática de comentário =========
api.nvim_create_augroup("NoAutoComment", { clear = true })
api.nvim_create_autocmd("FileType", {
  group = "NoAutoComment",
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

-- ========= Conceal baixo em json/jsonc/markdown =========
api.nvim_create_augroup("LowConceal", { clear = true })
api.nvim_create_autocmd("FileType", {
  group = "LowConceal",
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- ========= Restaurar posição do cursor =========
api.nvim_create_augroup("RestoreCursor", { clear = true })
api.nvim_create_autocmd("BufReadPost", {
  group = "RestoreCursor",
  callback = function()
    local mark = api.nvim_buf_get_mark(0, '"')
    local lcount = api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ========= Janelas auxiliares fecham com 'q' =========
api.nvim_create_augroup("QuickClose", { clear = true })
api.nvim_create_autocmd("FileType", {
  group = "QuickClose",
  pattern = { "help", "man", "lspinfo", "qf", "startuptime", "checkhealth" },
  callback = function(ev)
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true })
    vim.bo[ev.buf].buflisted = false
  end,
})

-- ========= Terminal UX =========
api.nvim_create_augroup("TermUX", { clear = true })
api.nvim_create_autocmd("TermOpen", {
  group = "TermUX",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd("startinsert")
  end,
})

-- ========= Cursor shape ao sair / Snacks dashboard =========
api.nvim_create_augroup("CursorShape", { clear = true })
api.nvim_create_autocmd("ExitPre", {
  group = "CursorShape",
  command = "set guicursor=a:ver90",
  desc = "Beam cursor when leaving Neovim",
})
api.nvim_create_autocmd("User", {
  group = "CursorShape",
  pattern = "SnacksDashboardOpened",
  callback = function()
    pcall(vim.cmd, "hi Cursor blend=100")
    pcall(vim.cmd, "set guicursor+=a:Cursor/lCursor")
  end,
})
api.nvim_create_autocmd("User", {
  group = "CursorShape",
  pattern = "SnacksDashboardClosed",
  callback = function()
    pcall(vim.cmd, "hi Cursor blend=0")
    pcall(vim.cmd, "set guicursor+=a:Cursor/lCursor")
  end,
})

-- ========= Auto-save (opcional, seguro) =========
-- Toggle com :AutoSaveToggle (default: off)
vim.g.auto_save = vim.g.auto_save or false
api.nvim_create_user_command("AutoSaveToggle", function()
  vim.g.auto_save = not vim.g.auto_save
  vim.notify("AutoSave: " .. (vim.g.auto_save and "ON" or "OFF"))
end, {})

api.nvim_create_augroup("AutoSave", { clear = true })
api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = "AutoSave",
  callback = function()
    if not vim.g.auto_save then return end
    if vim.bo.buftype ~= "" or vim.bo.readonly or not vim.bo.modifiable then return end
    if vim.api.nvim_buf_get_name(0) == "" then return end
    vim.cmd("silent! write")
  end,
})

