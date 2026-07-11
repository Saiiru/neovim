local select_any_word = function()
  require("flash").jump({
    pattern = ".", -- initialize pattern with any char
    search = {
      mode = function(pattern)
        -- remove leading dot
        if pattern:sub(1, 1) == "." then
          pattern = pattern:sub(2)
        end
        -- return word pattern and proper skip pattern
        return ([[\<%s\w*\>]]):format(pattern), ([[\<%s]]):format(pattern)
      end,
    },
    -- select the range
    jump = { pos = "range" },
  })
end


local jump_to_line = function()
  require("flash").jump({
    search = { mode = "search", max_length = 0 },
    label = { after = { 0, 0 } },
    pattern = "^"
  })
end

local jump_to_word_under_cursor = function()
  require("flash").jump({
    pattern = vim.fn.expand("<cword>"),
  })
end


return {
  
  {
    "folke/flash.nvim",
    enabled = true,
    lazy = true,
    event = "VeryLazy",
    opts = {
      modes = {
        char = {
          jump_labels = true
        },
      },
      jump = {
        nohlsearch = true,
        autojump = true
      },
      search = {
        multi_window = true
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "o", "x" },
        function() require("flash").jump() end,
        desc = "Flash"
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function() require("flash").treesitter() end,
        desc = "Flash Treesitter"
      },
      {
        "r",
        mode = "o",
        function() require("flash").remote() end,
        desc = "Remote Flash"
      },
      {
        "R",
        mode = { "o", "x" },
        function() require("flash").treesitter_search() end,
        desc = "Treesitter Search"
      },
      {
        "<leader>*",
        mode = { "n" },
        jump_to_word_under_cursor,
        desc = "Jump To Word Under Cursor"
      },
      {
        "<leader>ll",
        mode = { "n" },
        jump_to_line,
        desc = "Jump To Line"
      },
      {
        "<leader>ww",
        mode = { "n" },
        select_any_word,
        desc = "Select Any Word"
      },
    },
  },
{
    'echasnovski/mini.bracketed',
    version = false,
    lazy = true,
    opts = {},
    event = "VeryLazy"
  }
}
