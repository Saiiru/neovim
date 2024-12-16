local prefix = "<leader>A"

return {
  -- Import Neogen extras from LazyVim
  { import = "lazyvim.plugins.extras.coding.neogen" },

  -- Neogen: Annotation and documentation generator
  {
    "danymat/neogen",
    keys = {
      {
        prefix .. "d",
        function()
          require("neogen").generate()
        end,
        desc = "Default Annotation",
      },
      {
        prefix .. "C",
        function()
          require("neogen").generate { type = "class" }
        end,
        desc = "Class Annotation",
      },
      {
        prefix .. "f",
        function()
          require("neogen").generate { type = "func" }
        end,
        desc = "Function Annotation",
      },
      {
        prefix .. "t",
        function()
          require("neogen").generate { type = "type" }
        end,
        desc = "Type Annotation",
      },
      {
        prefix .. "F",
        function()
          require("neogen").generate { type = "file" }
        end,
        desc = "File Annotation",
      },
      { "<leader>cn", false }, -- Disable conflicting mapping
    },
  },

  -- Dooku: Generate HTML documentation
  {
    "Zeioth/dooku.nvim",
    cmd = { "DookuGenerate", "DookuOpen", "DookuAutoSetup" },
    opts = {}, -- Configure options here if needed
    keys = {
      { prefix .. "g", "<Cmd>DookuGenerate<CR>", desc = "Generate HTML Docs" },
      { prefix .. "o", "<Cmd>DookuOpen<CR>", desc = "Open HTML Docs" },
    },
  },

  -- Which-Key: Improve discoverability of keybindings
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { prefix, group = "Annotation/Snippets", icon = " " },
      },
    },
  },
}
