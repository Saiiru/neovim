return {
  {
    "echasnovski/mini.diff",
    version = false,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("mini.diff").setup({ view = { style = "sign" } })
    end,
  },
}
