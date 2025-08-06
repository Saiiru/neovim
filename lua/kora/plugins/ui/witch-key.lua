 -- ═════════════════════════════════════════════════════════════════════════
  --  WHICH-KEY - COMMAND NEURAL CENTER
  -- ═════════════════════════════════════════════════════════════════════════
 
-- WHICH-KEY (GUIA DE COMANDOS):
-- <leader>                     -- Mostra todos os comandos disponíveis
-- <Space>                      -- Mesmo que leader, mostra guia

  return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      preset = "helix",
      spec = {
        { "<leader>b", group = " Buffer", icon = " " },
        { "<leader>c", group = " Copilot", icon = " " },
        { "<leader>f", group = " Find", icon = " " },
        { "<leader>g", group = " Git", icon = " " },
        { "<leader>l", group = " LSP", icon = " " },
        { "<leader>s", group = " Split", icon = " " },
        { "<leader>t", group = " Tab", icon = " " },
        { "<leader>u", group = " Utils", icon = " " },
        { "<leader>x", group = " Execute", icon = " " },
        { "<leader>e", group = " Explorer", icon = " " },
        { "<leader>h", group = " Hunk", icon = " " },
      },
      win = {
        border = "rounded",
        title = " KORA COMMAND MATRIX ",
        title_pos = "center",
        padding = { 1, 2 },
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "center",
      },
      show = {
        help = true,
        keys = true,
      },
    },
  }
