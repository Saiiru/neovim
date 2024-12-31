return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" }, -- Ensure Plenary is loaded for Harpoon's functionality
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4, -- Dynamic width adjustment based on window size
    },
    settings = {
      save_on_toggle = true, -- Save file list when toggling the Harpoon menu
    },
  },
  config = function()
    local harpoon = require("harpoon")

    -- Key mappings for Harpoon functionality
    vim.keymap.set("n", "<leader>a", function()
      -- Add current file to Harpoon
      harpoon:list():add()
    end, { desc = "Add current file to Harpoon" })

    harpoon:setup({})

    -- basic telescope configuration
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers")
        .new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({
            results = file_paths,
          }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
        })
        :find()
    end

    vim.keymap.set("n", "<leader>h", function()
      toggle_telescope(harpoon:list())
    end, { desc = "Open harpoon window" })

    -- Key mappings to navigate between files in Harpoon list
    for i = 1, 5 do
      vim.keymap.set("n", "<leader>" .. i, function()
        -- Navigate to the corresponding Harpoon file
        require("harpoon"):list():select(i)
      end, { desc = "Navigate to Harpoon file " .. i })
    end
  end,
  keys = function()
    local keys = {
      -- Add file to Harpoon
      {
        "<leader>a",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon File",
      },
    }

    -- Add mappings for Harpoon navigation
    for i = 1, 5 do
      table.insert(keys, {
        "<leader>" .. i,
        function()
          require("harpoon"):list():select(i)
        end,
        desc = "Navigate to Harpoon File " .. i,
      })
    end

    return keys
  end,
}
