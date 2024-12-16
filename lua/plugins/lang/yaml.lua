return {
  -- Importing the YAML plugin extras for LazyVim
  { import = "lazyvim.plugins.extras.lang.yaml" },

  -- YAML Companion Plugin
  {
    "someone-stole-my-name/yaml-companion.nvim",
    ft = { "yaml" },
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    opts = {},
    config = function(_, opts)
      local cfg = require("yaml-companion").setup(opts)
      require("lspconfig")["yamlls"].setup(cfg)

      -- Load YAML schema extension in Telescope when it's available
      LazyVim.on_load("telescope.nvim", function()
        require("telescope").load_extension "yaml_schema"
      end)
    end,
    keys = {
      { "<leader>cy", "<cmd>Telescope yaml_schema<cr>", desc = "YAML Schema" },
    },
  },

  -- Lualine configuration with YAML schema
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      -- Function to display the YAML schema in the lualine section
      local function yaml_schema()
        local schema = require("yaml-companion").get_buf_schema(0)
        -- Return the schema name or an empty string if no schema is found
        return schema.result[1].name ~= "none" and schema.result[1].name or ""
      end

      -- Add the YAML schema display to the lualine_x section
      table.insert(opts.sections.lualine_x, 1, yaml_schema)
    end,
  },
}
