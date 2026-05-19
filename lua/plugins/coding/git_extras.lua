-- ================================================================================================
-- TITLE : Git Extras
-- ABOUT : Extras de produtividade para Git sem substituir fugitive/gitsigns.
-- LINKS :
--   > git-messenger : https://github.com/rhysd/git-messenger.vim
--   > committia     : https://github.com/rhysd/committia.vim
-- ================================================================================================

return {
  {
    "rhysd/git-messenger.vim",
    cmd = "GitMessenger",
    keys = {
      { "<leader>gm", "<cmd>GitMessenger<cr>", desc = "Git Messenger (linha atual)" },
    },
    init = function()
      vim.g.git_messenger_no_default_mappings = true
    end,
  },
  {
    "rhysd/committia.vim",
    ft = { "gitcommit", "gitrebase" },
    init = function()
      vim.g.committia_min_window_width = 120
      vim.g.committia_edit_window_width = 55
    end,
    keys = {
      { "<leader>gC", "<cmd>call committia#open('git')<cr>", desc = "Open Committia" },
    },
  },
}
