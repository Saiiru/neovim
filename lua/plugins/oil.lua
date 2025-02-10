-- Função para carregar arquivos ignorados pelo Git
local git_ignored = setmetatable({}, {
  __index = function(self, key)
    local proc = vim.system({ "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" }, {
      cwd = key,
      text = true,
    })
    local result = proc:wait()
    local ret = {}
    if result.code == 0 then
      for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
        -- Remove trailing slash de diretórios
        line = line:gsub("/$", "")
        table.insert(ret, line)
      end
    end

    rawset(self, key, ret)
    return ret
  end,
})

-- Função para definir a altura máxima da janela flutuante
local function max_height()
  local height = vim.fn.winheight(0)
  if height >= 40 then
    return 30
  elseif height >= 30 then
    return 20
  else
    return 10
  end
end

return {
  {
    "stevearc/oil.nvim",
    opts = {
      -- Ativa o explorador de arquivos como padrão
      default_file_explorer = true,
      -- Ignora o pop-up de confirmação para edições simples
      skip_confirm_for_simple_edits = true,
      -- Usar keymaps padrão
      use_default_keymaps = true,

      view_options = {
        -- Mostrar arquivos e diretórios ocultos
        show_hidden = false,
        -- Função para definir o que é considerado um arquivo oculto
        is_hidden_file = function(name, _)
          -- Arquivos com "." são sempre ocultos
          if vim.startswith(name, ".") then
            return true
          end
          local dir = require("oil").get_current_dir()
          -- Verifica se não há diretório local, por exemplo, em conexões SSH
          if not dir then
            return false
          end
          -- Verifica se o arquivo está ignorado pelo Git
          return vim.list_contains(git_ignored[dir], name)
        end,
      },

      -- Configuração para a janela flutuante
      float = {
        padding = 2,
        max_width = 120,
        max_height = max_height(),
        border = "rounded",
        win_options = {
          winblend = 0,
        },
      },

      -- Keymaps personalizados
      keymaps = {
        ["<C-c>"] = false,  -- Desabilita o keymap padrão para <C-c>
        ["<C-s>"] = {
          desc = "Salvar todas as alterações",
          callback = function()
            require("oil").save({ confirm = false })
          end,
        },
        ["q"] = "actions.close",  -- Fecha o explorador
        ["<C-y>"] = "actions.copy_entry_path",  -- Copia o caminho do arquivo
      },
    },

    -- Mapeamento de teclas para abrir o explorador de arquivos
    keys = {
      {
        "-",
        function()
          require("oil").toggle_float()  -- Alterna a janela flutuante do explorador
        end,
        desc = "Abrir explorador de arquivos",
      },
    },
  },
}

