-- ================================================================================================
-- TITLE : toggleterm.nvim
-- ABOUT : Terminais persistentes dentro do Neovim; tmux continua sendo preferido para servidores.
-- HOW   :
--   > <C-\>       alterna terminal padrão
--   > <leader>Tf  terminal flutuante no root
--   > <leader>Th  terminal horizontal no root
--   > <leader>Tv  terminal vertical no root
--   > <leader>lg  lazygit em popup tmux quando possível
-- ================================================================================================

local function root()
  return vim.fs.root(0, {
    ".git",
    "package.json",
    "pyproject.toml",
    "go.mod",
    "Cargo.toml",
    "pom.xml",
    "build.gradle",
    "Makefile",
  }) or vim.fn.getcwd()
end

return {
  "akinsho/toggleterm.nvim",
  cmd = { "ToggleTerm", "TermExec", "ToggleTermSetName", "TermSelect" },
  keys = {
    { [[<C-\>]], "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
    {
      "<leader>Tf",
      function()
        require("toggleterm").toggle(vim.v.count1, nil, root(), "float")
      end,
      desc = "Terminal Float Root",
    },
    {
      "<leader>Th",
      function()
        require("toggleterm").toggle(vim.v.count1, 15, root(), "horizontal")
      end,
      desc = "Terminal Horizontal Root",
    },
    {
      "<leader>Tv",
      function()
        require("toggleterm").toggle(vim.v.count1, math.floor(vim.o.columns * 0.4), root(), "vertical")
      end,
      desc = "Terminal Vertical Root",
    },
    { "<leader>Tn", "<cmd>ToggleTermSetName<cr>", desc = "Terminal Set Name" },
    { "<leader>Ts", "<cmd>TermSelect<cr>", desc = "Terminal Select" },
    {
      "<leader>lg",
      function()
        require("config.tmux").lazygit()
      end,
      desc = "Lazygit",
    },
  },
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      end
      if term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.4)
      end
    end,
    open_mapping = [[<C-\>]],
    hide_numbers = true,
    shade_terminals = false,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    persist_mode = true,
    close_on_exit = true,
    direction = "horizontal",
    float_opts = {
      border = "double",
      width = function()
        return math.floor(vim.o.columns * 0.9)
      end,
      height = function()
        return math.floor(vim.o.lines * 0.85)
      end,
      winblend = 0,
    },
  },
}
