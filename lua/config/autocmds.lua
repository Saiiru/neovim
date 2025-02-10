-----------------------------------------------------------
-- init.lua – Autocmd Configuration (Loaded on VeryLazy)
-- Default autocmds are provided by LazyVim:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-----------------------------------------------------------

-----------------------------------------------------------
-- External Commands on File Save
-----------------------------------------------------------
-- Reload tmux config after saving any *tmux.conf file.
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*tmux.conf" },
  command = "execute 'silent !tmux source <afile> --silent'",
})

-- Source fish config file after saving config.fish.
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "config.fish" },
  command = "execute 'silent !source <afile> --silent'",
})

-- Clear Yazi cache after saving yazi.toml.
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "yazi.toml" },
  command = "execute 'silent !yazi --clear-cache'",
})

-- Reload Aerospace config after saving aerospace.toml.
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "aerospace.toml" },
  command = "execute 'silent !aerospace reload-config'",
})

-- Restart sketchybar service after saving sketchybarrc.
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "sketchybarrc" },
  command = "!brew services restart sketchybar",
})

-----------------------------------------------------------
-- Filetype Specific Settings
-----------------------------------------------------------
-- For Markdown files: set filetype to markdown and enable wrapping, linebreaks, etc.
vim.api.nvim_create_autocmd({ "BufNewFile", "BufFilePre", "BufRead" }, {
  pattern = { "*.mdx", "*.md" },
  callback = function()
    vim.cmd("set filetype=markdown wrap linebreak nolist nospell")
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

