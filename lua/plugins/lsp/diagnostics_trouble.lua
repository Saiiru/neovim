-- lua/plugins/lsp/diagnostics_trouble.lua :: UI para diagnósticos e listas.

return {
  -- UI para exibir diagnósticos, referências, etc.
  {
    "folke/trouble.nvim",
    version = "*",
    cmd = { "Trouble" },
    opts = {
      focus = true,
      warn_no_results = false,
      open_no_results = false,
      icons = true,
      preview = { type = "float", border = "rounded" },
      modes = {
        diagnostics = { win = { position = "bottom", size = 12 } },
        symbols = { win = { position = "right", size = 0.35 } },
      },
    },
    config = function(_, opts)
      local ok_colors, C = pcall(require, "utils.colors")
      if ok_colors and C.diagnostics then
        vim.api.nvim_set_hl(0, "DiagnosticError", { fg = C.diagnostics.error })
        vim.api.nvim_set_hl(0, "DiagnosticWarn",  { fg = C.diagnostics.warn })
        vim.api.nvim_set_hl(0, "DiagnosticInfo",  { fg = C.diagnostics.info })
        vim.api.nvim_set_hl(0, "DiagnosticHint",  { fg = C.diagnostics.hint })
      end

      local ok_utils, UL = pcall(require, "utils.lsp")
      local signs = (ok_utils and UL.signs) or {
        Error = "", Warn = "", Info = "", Hint = "󰌶",
      }
      for sev, icon in pairs(signs) do
        local name = "DiagnosticSign" .. sev
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end

      require("trouble").setup(opts)

      local trouble = require("trouble")
      vim.keymap.set("n", "<leader>xx", function() trouble.open("diagnostics") end,         { desc = "Trouble: Project Diagnostics" })
      vim.keymap.set("n", "<leader>xd", function() trouble.open("diagnostics", { filter = { buf = 0 } }) end, { desc = "Trouble: Buffer Diagnostics" })
      vim.keymap.set("n", "<leader>xq", function() trouble.open("quickfix") end,            { desc = "Trouble: Quickfix" })
      vim.keymap.set("n", "<leader>xl", function() trouble.open("loclist") end,             { desc = "Trouble: Loclist" })
      vim.keymap.set("n", "<leader>xs", function() trouble.open("symbols") end,             { desc = "Trouble: Document Symbols" })
    end,
  },

  -- Mostra diagnósticos virtualmente nas linhas.
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = "LspAttach",
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config({ virtual_text = false }) -- Prefere lsp_lines

      local on = true
      vim.keymap.set("n", "<leader>lv", function()
        on = not on
        vim.diagnostic.config({ virtual_text = not on })
        require("lsp_lines").toggle()
        vim.notify(on and "lsp_lines ON" or "lsp_lines OFF")
      end, { desc = "Diagnostics: toggle virtual lines" })
    end,
  },
}

