return {
  {
    "epwalsh/obsidian.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local ok, obs = pcall(require, "config.obsidian")
      if ok then
        obs.setup()
      end
    end,
  },
  {
    "renerocksai/telekasten.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
