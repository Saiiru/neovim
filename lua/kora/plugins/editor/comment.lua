-- ═════════════════════════════════════════════════════════════════════════
--  COMMENTS - INTELLIGENT COMMENTING
-- ═════════════════════════════════════════════════════════════════════════
return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  opts = function()
    return {
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      padding = true,
      sticky = true,
      ignore = "^$",
      toggler = {
        line = "gcc",
        block = "gbc",
      },
      opleader = {
        line = "gc",
        block = "gb",
      },
      extra = {
        above = "gcO",
        below = "gco",
        eol = "gcA",
      },
      mappings = {
        basic = true,
        extra = true,
      },
    }
  end,
  config = function(_, opts)
    require("Comment").setup(opts)

    -- Additional keymaps
    local keymap = vim.keymap.set

    -- Toggle comment for current line in normal mode
    keymap("n", "<C-/>", function()
      require("Comment.api").toggle.linewise.current()
    end, { desc = "Toggle comment" })

    -- Toggle comment for selection in visual mode
    keymap("v", "<C-/>", function()
      local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
      vim.api.nvim_feedkeys(esc, "nx", false)
      require("Comment.api").toggle.linewise(vim.fn.visualmode())
    end, { desc = "Toggle comment" })
  end,
}
