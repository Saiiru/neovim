local lazypath = vim.fn.stdpath("data") .. "/lazy"
return {
   {
    "folke/lazydev.nvim",
    enabled = true,
    ft = "lua",
    opts = {
      library = {
        { path = "snacks.nvim", words = { "Snacks" } },
        lazypath
      },
    },
  },
{
    "folke/neoconf.nvim",
    lazy = true,
    config = true,
    enabled = false
  },
}
