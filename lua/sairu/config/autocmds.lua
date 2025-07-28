-- Autocommands Configuration - BATMAN VEGA Response Matrix
-- =========================================================
-- Setup our JDTLS server any time we open up a java file
vim.cmd [[
    augroup jdtls_lsp
        autocmd!
        autocmd FileType java lua require'config.jdtls'.setup_jdtls()
    augroup end
]]
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Run-on-Save Protocol Group - Execution Automation
local RunOnSave = augroup("RunOnSave", { clear = true })

-- Helper Function - Command Mapping Matrix
local function map_run(ft, cmd)
  autocmd("FileType", {
    pattern = ft,
    group = RunOnSave,
    callback = function()
      vim.keymap.set("n", "<leader>R", function()
        local filename = vim.fn.expand("%")
        local full_cmd = cmd:gsub("%%f", filename):gsub("%%r", vim.fn.expand("%:r"))
        vim.cmd("split")
        vim.cmd("terminal " .. full_cmd)
        vim.cmd("resize 10")
      end, { buffer = true, desc = "Run " .. ft .. " file" })
    end,
  })
end

-- Language-Specific Execution Protocols
map_run("c", "gcc %f -o %r && ./%r")
map_run("cpp", "g++ %f -o %r && ./%r")
map_run("java", "javac %f && java %r")
map_run("go", "go run %f")
map_run("python", "python3 %f")
map_run("lua", "lua %f")

-- Markdown Enhancement Protocol
local MarkdownGroup = augroup("MarkdownSettings", { clear = true })
autocmd("FileType", {
  pattern = "markdown",
  group = MarkdownGroup,
  callback = function()
    vim.opt_local.conceallevel = 2
    vim.opt_local.wrap = false
    vim.opt_local.linebreak = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- CSV Enhancement Protocol
local CSVGroup = augroup("CSVSettings", { clear = true })
autocmd("FileType", {
  pattern = "csv",
  group = CSVGroup,
  callback = function()
    vim.cmd("CsvViewEnable")
    vim.opt_local.wrap = false
  end,
})

-- Text Yank Highlight Protocol - Visual Feedback System
local YankGroup = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = YankGroup,
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 300,
    })
  end,
})

-- Help Window Management - Documentation Interface
local HelpGroup = augroup("HelpSettings", { clear = true })
autocmd("FileType", {
  pattern = "help",
  group = HelpGroup,
  callback = function()
    vim.keymap.set("n", "<C-S-L>", "<C-w>L", { buffer = true, desc = "Move help to right side" })
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

-- Diagnostics Exclusion Protocol - Error Filter Matrix
local DiagnosticsGroup = augroup("DiagnosticsControl", { clear = true })
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*/node_modules/*", "*.env*" },
  group = DiagnosticsGroup,
  callback = function()
    vim.diagnostic.disable(0)
  end,
})

-- Auto-close FileTypes - Specialized Buffer Protocol
local auto_close_filetypes = {
  "qf", "help", "man", "notify", "lspinfo", "spectre_panel", "startuptime",
  "tsplayground", "PlenaryTestPopup", "checkhealth", "neotest-output",
  "neotest-summary", "neotest-output-panel", "dbout", "gitsigns.blame"
}

local AutoCloseGroup = augroup("auto_close_filetypes", { clear = true })
for _, ft in pairs(auto_close_filetypes) do
  autocmd("FileType", {
    pattern = ft,
    group = AutoCloseGroup,
    callback = function()
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true, silent = true, desc = "Close buffer" })
      vim.keymap.set("n", "<esc>", "<cmd>close<cr>", { buffer = true, silent = true, desc = "Close buffer" })
      
      -- Unbind leader key for these filetypes
      vim.keymap.set("n", "<space>", "<space>", { buffer = true, desc = "Space" })
    end,
  })
end

-- Terminal Enhancement Protocol
local TerminalGroup = augroup("TerminalSettings", { clear = true })
autocmd("TermOpen", {
  group = TerminalGroup,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.spell = false
  end,
})

-- Number Toggle Protocol - Focus-Responsive Interface
local NumberToggleGroup = augroup("numbertoggle", { clear = true })

autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  pattern = "*",
  group = NumberToggleGroup,
  callback = function()
    if vim.opt.number:get() and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})

autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  pattern = "*",
  group = NumberToggleGroup,
  callback = function()
    if vim.opt.number:get() then
      vim.opt.relativenumber = false
    end
  end,
})

-- Auto Directory Creation Protocol - File System Intelligence
local DirectoryGroup = augroup("auto_create_dir", { clear = true })
autocmd("BufWritePre", {
  group = DirectoryGroup,
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- File Type Detection Enhancement
local FileTypeGroup = augroup("FileTypeSettings", { clear = true })
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.templ" },
  group = FileTypeGroup,
  callback = function()
    vim.bo.filetype = "templ"
  end,
})

-- LSP Attachment Optimization Protocol
local LspGroup = augroup("LspAttach", { clear = true })
autocmd("LspAttach", {
  group = LspGroup,
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }
    
    -- Enhanced LSP Keymaps
    vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", vim.tbl_extend("force", opts, { desc = "Show references" }))
    vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
    vim.keymap.set("n", "gy", "<cmd>Telescope lsp_type_definitions<cr>", vim.tbl_extend("force", opts, { desc = "Go to type definition" }))
    
    -- Enable inlay hints if available
    if event.data and event.data.client_id then
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
      end
    end
  end,
})

-- For shell scripts: set filetype to sh for *.conf files.
vim.api.nvim_create_autocmd("BufRead", {
  pattern = { "*.conf" },
  callback = function()
    vim.cmd("set filetype=sh")
  end,
})

-- For config files: set filetype to toml when the filename is 'config'.
vim.api.nvim_create_autocmd("BufRead", {
  pattern = { "config" },
  callback = function()
    vim.cmd("set filetype=toml")
  end,
})

-----------------------------------------------------------
-- UI Enhancements & Visual Feedback
-----------------------------------------------------------
-- Highlight on Yank: provide immediate visual feedback when yanking text.
local yank_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Auto-Split Help Windows: when opening help buffers, allow a quick keymapping to move the window to the right.
vim.api.nvim_create_augroup("HelpSplitRight", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = "HelpSplitRight",
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "help" then
      vim.keymap.set("n", "<C-S-L>", function()
        vim.cmd("wincmd L") -- Move the current window to the right
      end, { noremap = true, silent = true })
    end
  end,
})

-----------------------------------------------------------
-- Diagnostics & Linter Control
-----------------------------------------------------------
-- Disable diagnostics for .env files.
vim.api.nvim_create_autocmd("BufRead", {
  pattern = ".env",
  callback = function()
    vim.diagnostic.enable(false)
  end,
})

-- Disable eslint diagnostics for any files in node_modules directories.
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = vim.api.nvim_create_augroup("DisableEslintOnNodeModules", { clear = true }),
  pattern = { "**/node_modules/**", "node_modules", "/node_modules/*" },
  callback = function()
    vim.diagnostic.enable(false)
  end,
})

-----------------------------------------------------------
-- Window Management & Leader Key Behavior
-----------------------------------------------------------
-- Automatically close windows for specific filetypes (e.g. lazy, mason, lspinfo, etc.).
local auto_close_filetypes = {
  "lazy", "mason", "lspinfo", "toggleterm", "null-ls-info", "TelescopePrompt", "notify",
}
vim.api.nvim_create_autocmd("BufLeave", {
  group = vim.api.nvim_create_augroup("lazyvim_auto_close_win", { clear = true }),
  callback = function(event)
    local ft = vim.bo[event.buf].filetype
    if vim.fn.index(auto_close_filetypes, ft) ~= -1 then
      local winids = vim.fn.win_findbuf(event.buf)
      for _, win in ipairs(winids) do
        vim.api.nvim_win_close(win, true)
      end
    end
  end,
})

-- Disable <leader> and <localleader> keybindings for specific filetypes.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("lazyvim_unbind_leader_key", { clear = true }),
  pattern = { "lazy", "mason", "lspinfo", "toggleterm", "null-ls-info", "neo-tree-popup", "TelescopePrompt", "notify", "floaterm" },
  callback = function(event)
    vim.keymap.set("n", "<leader>", "<nop>", { buffer = event.buf })
    vim.keymap.set("n", "<localleader>", "<nop>", { buffer = event.buf })
  end,
})

-----------------------------------------------------------
-- Terminal & Buffer Formatting
-----------------------------------------------------------
-- For terminal windows: disable number column, relative numbering, and spell checking.
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.cmd("setlocal listchars= nonumber norelativenumber nospell")
  end,
})

-- Disable automatic comment continuation for new lines.
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.cmd("set formatoptions-=cro")
    vim.cmd("setlocal formatoptions-=cro")
  end,
})

-----------------------------------------------------------
-- Number Toggle: Relative vs. Absolute Line Numbers
-----------------------------------------------------------
local numbertoggle = vim.api.nvim_create_augroup("numbertoggle", { clear = true })
-- Enable relative numbers when entering a buffer or gaining focus (and not in insert mode).
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  pattern = "*",
  group = numbertoggle,
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})
-- Disable relative numbers when leaving a buffer, losing focus, or entering insert mode.
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  pattern = "*",
  group = numbertoggle,
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false
      vim.cmd.redraw()
    end
  end,
})

-----------------------------------------------------------
-- Miscellaneous: Auto Create Directories on Save
-----------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
  callback = function(args)
    -- Skip URLs (e.g. "http://")
    if args.match:match("^%w%w+://") then return end
    local file = vim.uv.fs_realpath(args.match) or args.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
