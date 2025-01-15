return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "kyazdani42/nvim-web-devicons" },
  opts = {
    options = {
      icons_enabled = true,
      theme = "tokyonight", -- Cyberpunk-inspired theme
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { "NvimTree", "dashboard", "packer", "lsp-installer" },
      always_divide_middle = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "encoding", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = { "filename" },
      lualine_b = {},
      lualine_c = {},
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    extensions = { "fugitive", "quickfix" },
  },
  config = function(_, opts)
    -- Apply configuration for lualine
    require("lualine").setup(opts)

    -- Fix for Trouble plugin: Ensure 'icons' is not a boolean
    local trouble = require("trouble")
    if trouble then
      trouble.setup({
        icons = true, -- Ensures icons are enabled (change this to a table of icons if needed)
      })
    end
  end,
}
