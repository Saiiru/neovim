local prefix = "<leader>dd"

return {
  {
    "andrewferrier/debugprint.nvim",
    opts = {
      create_keymaps = false,
    },
    -- stylua: ignore
    keys = {
      { prefix .. "l", function() return require("plugins.coding.debugprint").debugprint() end, desc = "Under Line", expr = true },
      { prefix .. "L", function() return require("plugins.coding.debugprint").debugprint({ above = true }) end, desc = "Above Line", expr = true },
      {
        prefix .. "v",
        function() return require("plugins.coding.debugprint").debugprint({ variable = true }) end,
        desc = "Variable Under Line",
        expr = true,
      },
      {
        prefix .. "V",
        function() return require("plugins.coding.debugprint").debugprint({ above = true, variable = true }) end,
        desc = "Variable Above Line",
        expr = true,
      },
      { prefix .. "d", function() return require("plugins.coding.debugprint").deleteprints() end, desc = "Delete All" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { prefix, group = "debugPrint", icon = "󰐪 " },
      },
    },
  },
}
