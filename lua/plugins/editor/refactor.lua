return {
{
    -- Code refactoring
    "ThePrimeagen/refactoring.nvim",
    lazy = true,
    enabled = true,
    keys = {
      -- stylua:ignore
      { "e", mode = { "v" }, " <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>",         desc = "Extract Function" },
      { "f", mode = { "v" }, " <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>", desc = "Extract Function To File" },
      { "v", mode = { "v" }, " <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>",         desc = "Extract Variable" },
      { "i", mode = { "v" }, " <Esc><Cmd>lua require('refactoring').refactor('Extract Inline Variable')<CR>",  desc = "Extract Inline Variable" },
      -- stylua:ignore end
    },
    config = true
  }
  }
