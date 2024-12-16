return {
  {
    "smoka7/multicursors.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "smoka7/hydra.nvim",
    },
    cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
    keys = {
      { mode = { "v", "n" }, "<leader>M", "<cmd>MCstart<CR>", desc = "Start Multicursor Mode" },
    },
    opts = function()
      local mc = require "multicursors"
      mc.setup {
        hint_config = {
          border = "rounded",
          position = "bottom-right",
        },
        generate_hints = {
          normal = true,
          insert = true,
          extend = true,
          config = {
            column_count = 1,
          },
        },
      }
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      local hydra_ok, hydra = pcall(require, "hydra.statusline")
      if hydra_ok then
        local function hydra_is_active()
          return hydra.is_active()
        end

        local function hydra_get_name()
          return hydra.get_name() or ""
        end

        table.insert(opts.sections.lualine_b, { hydra_get_name, cond = hydra_is_active })
      end
    end,
  },
}
