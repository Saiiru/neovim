return {
  -- Instalar o plugin de diagnósticos de workspace
  "artemave/workspace-diagnostics.nvim",
  event = "LspAttach",
  dependencies = {
    "neovim/nvim-lspconfig", -- Para o suporte LSP
    "nvim-lua/plenary.nvim", -- Necessário para o workspace-diagnostics
  },
  opts = {
    -- Configurações iniciais para o plugin `workspace-diagnostics.nvim`
    enable_virtual_text = true, -- Habilita texto virtual
    virtual_text_prefix = "●", -- Prefixo para os textos virtuais
    signs = true, -- Habilita sinais no gutter
    severity_sort = true, -- Ordena os diagnósticos por severidade
  },
  config = function()
    -- Define o nível inicial dos diagnósticos
    vim.g.diagnostics_level = "all" -- "all" por padrão

    -- Função para alternar entre os níveis de diagnóstico
    function _G.toggle_diagnostics_level()
      if vim.g.diagnostics_level == "all" then
        set_diagnostics_level "error"
      else
        set_diagnostics_level "all"
      end
    end

    -- Função para configurar o nível de diagnóstico
    ---@param level 'all' | 'error'
    function _G.set_diagnostics_level(level)
      vim.g.diagnostics_level = level
      vim.notify("info", "Diagnostics level: " .. level, { title = "Diagnostics" })

      -- Configurações de diagnóstico baseadas no nível
      if level == "error" then
        vim.diagnostic.config {
          severity_sort = true,
          underline = { severity = vim.diagnostic.severity.ERROR },
          signs = { severity = vim.diagnostic.severity.ERROR },
          virtual_text = {
            prefix = "●", -- Usado para diagnósticos de erro
            spacing = 2,
            severity = vim.diagnostic.severity.ERROR,
          },
        }
      else
        vim.diagnostic.config {
          severity_sort = true,
          underline = true,
          signs = true,
          virtual_text = {
            prefix = "●",
            spacing = 2,
          },
        }
      end
    end
  end,
}
