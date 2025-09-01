-- ~/.config/nvim/lua/kora/plugins/which-key.lua
-- Which-key: descoberta de atalhos e grupos <leader>
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "classic",
    plugins = { spelling = true, registers = true, presets = true },
    window = { border = "rounded" },
    icons = { mappings = false },
  },
  config = function(_, opts)
    local ok, wk = pcall(require, "which-key")
    if not ok then return end
    wk.setup(opts)

    -- Grupos de navegação (não cria mapeamentos, só nomeia prefixos)
    local groups = {
      ["<leader>e"] = { name = "NvimTree" },
      ["<leader>r"] = { name = "Run" },
      ["<leader>b"] = { name = "Build" },
      ["<leader>t"] = { name = "Test/Tabs" }, -- Tabs já usam <leader>t*, coexistem
      ["<leader>l"] = { name = "LSP" },
      ["<leader>f"] = { name = "Format/Files" },
      ["<leader>s"] = { name = "Search/Replace" },
    }

    -- v3 (add) ou v2 (register)
    if wk.add then
      local spec = {}
      for k, v in pairs(groups) do spec[#spec+1] = { k, v } end
      wk.add(spec)
    else
      wk.register(groups)
    end
  end,
}

