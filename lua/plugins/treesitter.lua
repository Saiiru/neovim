return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      local ok, ts = pcall(require, "nvim-treesitter.configs")
      if ok then ts.setup(opts) end
    end,
  },
}
