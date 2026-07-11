return {
 {
    "toppair/peek.nvim",
    lazy = true,
    build = "deno task --quiet build:fast",
    enabled = false,
    keys = {
      {
        "<leader>op",
        function()
          local peek = require("peek")
          if peek.is_open() then
            peek.close()
          else
            peek.open()
          end
        end,
        desc = "Peek (Markdown Preview)",
      },
    },
    opts = { theme = "light" },
  },
  {
    "ellisonleao/glow.nvim",
    lazy = true,
    opts = {
      glow_path = "/opt/homebrew/bin/glow"
    },
    cmd = "Glow"
  },
  {
    -- Live markdown preview
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    lazy = true,
  },
  {
    "epwalsh/obsidian.nvim",
    lazy = true,
    event = {
      "BufReadPre .. vim.fn.expand '~' .. '/Obsidian/**.md'",
      "BufNewFile .. vim.fn.expand '~' .. '/Obsidian/**.md'"
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      dir = "~/Obsidian",

    },
  }
}
