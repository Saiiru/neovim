-- General configuration for Spectre based on current Git repo
---@param default_opts table | nil
---@return table
function _G.get_spectre_options(default_opts)
  local Path = require("util.path")
  local opts = default_opts or {}

  -- Verifica se o diretório atual é um repositório Git e ajusta o caminho
  if Path.is_git_repo() then
    opts.cwd = Path.get_git_root()
  end

  return opts
end

return {
  -- Desabilita o plugin grug-far
  { "MagicDuck/grug-far.nvim", enabled = false },

  {
    -- Plugin para busca e substituição
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" }, -- Comando para abrir o painel sem swap
    keys = {
      {
        "<leader>sr", -- Substituir em arquivos
        function()
          require("spectre").open()
        end,
        desc = "Replace in files",
      },
      {
        "<leader>sp", -- Substituir na raiz do repositório
        ":lua require('spectre').open(_G.get_spectre_options())<CR>",
        desc = "Replace in files (Root dir)",
      },
      {
        "<leader>sP", -- Substituir a palavra selecionada na raiz
        ":lua require('spectre').open_visual(_G.get_spectre_options({ select_word = true }))<CR>",
        desc = "Replace current word (Root dir)",
      },
      {
        "<leader>sr", -- Substituir a palavra atual em modo visual
        ":lua require('spectre').open_visual(_G.get_spectre_options())<CR>",
        mode = "v",
        silent = true,
        desc = "Replace current word (Root dir)",
      },
      {
        "<leader>sf", -- Substituir no arquivo atual
        ":lua require('spectre').open_file_search(_G.get_spectre_options({ select_word = true }))<CR>",
        desc = "Replace in current file",
      },
    },
  },

  {
    "folke/edgy.nvim", -- Plugin opcional para gerenciamento de janelas
    optional = true,
    opts = function(_, opts)
      opts.left = opts.left or {}
      table.insert(opts.left, {
        title = "Spectre",      -- Título do painel
        ft = "spectre_panel",   -- Tipo de arquivo
        size = { width = 0.3 }, -- Largura do painel
      })
    end,
  },
}
