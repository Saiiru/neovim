return {
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      italic_comments = true,
      borderless_telescope = false,
      terminal_colors = true,
      cache = true,
      theme = { variant = "default", saturation = 1.0 },
    },
    config = function(_, opts)
      require("cyberdream").setup(opts)
      vim.cmd.colorscheme "cyberdream"

      -- CyberSynth: toggles de transparência/contraste p/ Kitty
      local function HL(n, o)
        vim.api.nvim_set_hl(0, n, o)
      end
      local P = {
        bg = "#0B0A12",
        surf = "#141127",
        neon_pink = "#FF2D95",
        neon_cyan = "#00F0FF",
        neon_blue = "#00CFFF",
        neon_purple = "#9A6CFF",
        neon_yellow = "#FFD166",
        neon_green = "#7CFF00",
        text = "#F8F8F2",
        muted = "#6C7086",
        dim = "#262533",
      }

      local function transparent()
        vim.o.winblend = 10
        vim.o.pumblend = 10
        vim.o.termguicolors = true
        HL("NormalFloat", { fg = P.text, bg = "NONE" })
        HL("FloatBorder", { fg = P.neon_purple, bg = "NONE", bold = true })
        HL("Pmenu", { fg = P.text, bg = "NONE" })
        HL("PmenuSel", { fg = "#000000", bg = P.neon_blue, bold = true })
      end

      local function contrast()
        vim.o.winblend = 0
        vim.o.pumblend = 0
        vim.o.termguicolors = true
        HL("NormalFloat", { fg = P.text, bg = P.surf })
        HL("FloatBorder", { fg = P.neon_purple, bg = P.surf, bold = true })
        HL("Pmenu", { fg = P.text, bg = P.surf })
        HL("PmenuSel", { fg = "#000000", bg = P.neon_blue, bold = true })
        HL("CursorLine", { bg = "#101421" })
        HL("CursorColumn", { bg = "#101421" })
        HL("ColorColumn", { bg = "#12182A" })
      end

      transparent()

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("CyberSynthOverlay", { clear = true }),
        callback = transparent,
      })

      vim.api.nvim_create_user_command("KoraTransparent", transparent, {})
      vim.api.nvim_create_user_command("KoraContrast", contrast, {})
    end,
  },
}
