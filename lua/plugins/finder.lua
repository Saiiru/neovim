return {
  {
    "echasnovski/mini.pick",
    version = false,
    lazy = false,
    config = function()
      require("mini.pick").setup({
        window = {
          config = function()
            local height = math.floor(0.70 * vim.o.lines)
            local width = math.floor(0.80 * vim.o.columns)
            return {
              anchor = "NW",
              height = height,
              width = width,
              row = math.floor(0.15 * vim.o.lines),
              col = math.floor(0.10 * vim.o.columns),
              border = "single",
            }
          end,
        },
      })
    end,
  },
}
