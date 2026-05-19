-- ================================================================================================
-- TITLE : obsidian.nvim
-- ABOUT : Integração do Neovim com o vault Obsidian local.
-- LINKS :
--   > github : https://github.com/obsidian-nvim/obsidian.nvim
-- ================================================================================================

return {
  "obsidian-nvim/obsidian.nvim",
  cmd = {
    "Obsidian",
    "ObsidianToday",
    "ObsidianNew",
    "ObsidianSearch",
    "ObsidianQuickSwitch",
  },
  ft = "markdown",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    legacy_commands = false,
    workspaces = {
      { name = "Leveling", path = "~/Documents/leveling" },
    },
    picker = {
      name = "fzf-lua",
    },
  },
  keys = {
    { "<leader>nn", "<cmd>Obsidian new<cr>", desc = "Obsidian New Note" },
    { "<leader>nf", "<cmd>Obsidian quick_switch<cr>", desc = "Obsidian Find Note" },
    { "<leader>ns", "<cmd>Obsidian search<cr>", desc = "Obsidian Search" },
    { "<leader>nt", "<cmd>Obsidian today<cr>", desc = "Obsidian Today" },
  },
}
