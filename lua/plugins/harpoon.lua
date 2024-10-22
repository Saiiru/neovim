 return {
  "ThePrimeagen/harpoon",
  config = function()
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    -- Função auxiliar para mapear teclas com descrições
    local function map_key(mode, keys, func, desc)
      vim.keymap.set(mode, keys, func, { desc = desc })
    end

    -- Marcar arquivo com Harpoon
    map_key("n", "<leader>a", mark.add_file, "Harpoon: Mark Current File")
    
    -- Abrir/fechar menu do Harpoon
    map_key("n", "<C-e>", ui.toggle_quick_menu, "Harpoon: Toggle Quick Menu")

    -- Navegação entre arquivos marcados
    local file_mappings = {
      { "<C-t>", 1, "Harpoon: Navigate to File 1" },
      { "<C-s>", 2, "Harpoon: Navigate to File 2" },
      { "<C-b>", 3, "Harpoon: Navigate to File 3" },
      { "<C-g>", 4, "Harpoon: Navigate to File 4" },
    }

    -- Mapear navegação pelos arquivos Harpoon
    for _, map in ipairs(file_mappings) do
      map_key("n", map[1], function() ui.nav_file(map[2]) end, map[3])
    end
  end,
}

