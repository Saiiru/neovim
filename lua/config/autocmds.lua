-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*tmux.conf" },
  command = "execute 'silent !tmux source <afile> --silent'",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "config.fish" },
  command = "execute 'silent !source <afile> --silent'",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufFilePre", "BufRead" }, {
  pattern = { "*.mdx", "*.md" },
  callback = function()
    vim.cmd([[set filetype=markdown wrap linebreak nolist nospell]])
  end,
})

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*tmux.conf" },
  command = "execute 'silent !tmux source <afile> --silent'",
})

-- Clear Yazi cache after saving yazi.toml
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "yazi.toml" },
  command = "execute 'silent !yazi --clear-cache'",
})

-- Source fish config file after saving config.fish
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "config.fish" },
  command = "execute 'silent !source <afile> --silent'",
})

-- Reload Aerospace config after saving aerospace.toml
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "aerospace.toml" },
  command = "execute 'silent !aerospace reload-config'",
})

-- Reload Aerospace config after saving aerospace.toml (duplicate)
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "aerospace.toml" },
  command = "!aerospace reload-config",
})

-- Restart sketchybar service after saving sketchybarrc
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "sketchybarrc" },
  command = "!brew services restart sketchybar",
})

-- Set markdown filetype and enable line wrapping for *.mdx and *.md files
vim.api.nvim_create_autocmd({ "BufNewFile", "BufFilePre", "BufRead" }, {
  pattern = { "*.mdx", "*.md" },
  callback = function()
    vim.cmd([[set filetype=markdown wrap linebreak nolist nospell]])
  end,
})

-- Set shell script filetype for *.conf files
vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = { "*.conf" },
  callback = function()
    vim.cmd([[set filetype=sh]])
  end,
})

-- Set TOML filetype for config files
vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = { "config" },
  callback = function()
    vim.cmd([[set filetype=toml]])
  end,
})

-- Auto split help windows to the right when opening
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

-- Disable diagnostics in .env files
vim.api.nvim_create_autocmd("BufRead", {
  pattern = ".env",
  callback = function()
    vim.diagnostic.enable(false)
  end,
})

-- Automatically close certain filetype windows (e.g. lazyvim, mason)
local auto_close_filetype = {
  "lazy",
  "mason",
  "lspinfo",
  "toggleterm",
  "null-ls-info",
  "TelescopePrompt",
  "notify",
}

-- Close windows when leaving certain filetypes
vim.api.nvim_create_autocmd("BufLeave", {
  group = vim.api.nvim_create_augroup("lazyvim_auto_close_win", { clear = true }),
  callback = function(event)
    local ft = vim.bo[event.buf].filetype -- Use vim.bo to get the filetype
    if vim.fn.index(auto_close_filetype, ft) ~= -1 then
      local winids = vim.fn.win_findbuf(event.buf)
      for _, win in pairs(winids) do
        vim.api.nvim_win_close(win, true)
      end
    end
  end,
})

-- Disable leader and localleader keybindings for specific filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("lazyvim_unbind_leader_key", { clear = true }),
  pattern = {
    "lazy",
    "mason",
    "lspinfo",
    "toggleterm",
    "null-ls-info",
    "neo-tree-popup",
    "TelescopePrompt",
    "notify",
    "floaterm",
  },
  callback = function(event)
    vim.keymap.set("n", "<leader>", "<nop>", { buffer = event.buf })
    vim.keymap.set("n", "<localleader>", "<nop>", { buffer = event.buf })
  end,
})

-- Disable number column and spell checking for terminal windows
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.cmd("setlocal listchars= nonumber norelativenumber")
    vim.cmd("setlocal nospell")
  end,
})

-- Disable automatic comment continuation for new lines
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.cmd("set formatoptions-=cro")
    vim.cmd("setlocal formatoptions-=cro")
  end,
})

-- Disable eslint diagnostics for node_modules folder
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = vim.api.nvim_create_augroup("DisableEslintOnNodeModules", { clear = true }),
  pattern = { "**/node_modules/**", "node_modules", "/node_modules/*" },
  callback = function()
    vim.diagnostic.enable(false)
  end,
})

-- Toggle between relative and absolute line numbers
local numbertoggle = vim.api.nvim_create_augroup("numbertoggle", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  pattern = "*",
  group = numbertoggle,
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})

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

-- Create missing directories when saving a file
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
  callback = function(args)
    if args.match:match("^%w%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(args.match) or args.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
