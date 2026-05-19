return {
  "Wansmer/symbol-usage.nvim",
  event = "LspAttach",
  keys = {
    {
      "<leader>uy",
      function()
        require("symbol-usage").toggle()
      end,
      desc = "Toggle symbol usage",
    },
  },
  config = function()
    local api = vim.api

    local function hl(name)
      return api.nvim_get_hl(0, { name = name })
    end

    api.nvim_set_hl(0, "SymbolUsageRounding", { fg = hl("CursorLine").bg, italic = true })
    api.nvim_set_hl(0, "SymbolUsageContent", {
      bg = hl("CursorLine").bg,
      fg = hl("Comment").fg,
      italic = true,
    })
    api.nvim_set_hl(0, "SymbolUsageRef", {
      fg = hl("Function").fg,
      bg = hl("CursorLine").bg,
      italic = true,
    })
    api.nvim_set_hl(0, "SymbolUsageDef", {
      fg = hl("Type").fg,
      bg = hl("CursorLine").bg,
      italic = true,
    })
    api.nvim_set_hl(0, "SymbolUsageImpl", {
      fg = hl("@keyword").fg or hl("Keyword").fg,
      bg = hl("CursorLine").bg,
      italic = true,
    })

    require("symbol-usage").setup {
      references = { enabled = true, include_declaration = false },
      definition = { enabled = true },
      implementation = { enabled = true },
    }
  end,
}
