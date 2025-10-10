return {
     {
    "scottmckendry/cyberdream.nvim",
    name = "cyberdream",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      italic_comments = true,
      borderless_telescope = true,
      theme = { variant = "default", highlights = {} },
    },
    config = function(_, opts)
      require("cyberdream").setup(opts)
      require("lua.utils.colors").setup()
      require("lua.utils.colors").set(vim.g.neosairu_theme or "cyberdream")
    end,
  },


}
