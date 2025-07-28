-- Neovim Initialization - BATMAN VEGA System Bootstrap
-- =====================================================

-- UTF-8 Encoding Protocol
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- Interface Enhancement Matrix
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.termguicolors = true

-- Undo System - Persistent Memory Matrix
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.cache/nvim/undo"


vim.opt.listchars = {
  tab = "→ ",
  eol = "↲",
  nbsp = "␣",
  trail = "•",
  extends = "⟩",
  precedes = "⟨",
}

-- Cursor Behavior Matrix
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

-- Input Enhancement Systems
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

-- Disable Default File Explorer - Prepare for nvim-tree deployment
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Module Loading - Core System Components
require("sairu.config.options")
require("sairu.config.keymaps")

-- Lazy.nvim Bootstrap Protocol
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin Management System
require("lazy").setup("sairu.plugins", {
  ui = {
    border = "rounded",
    title = "PLUGIN MATRIX",
    title_pos = "center",
  },
  change_detection = {
    notify = false,
  },
})

-- Post-initialization Protocols
require("sairu.config.autocmds")
