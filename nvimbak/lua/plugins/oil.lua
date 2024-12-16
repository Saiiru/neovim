local git_ignored = setmetatable({}, {
  __index = function(self, key)
    local proc = vim.system({ "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" }, {
      cwd = key,
      text = true,
    })
    local result = proc:wait()
    local ret = {}
    if result.code == 0 then
      for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
        -- Remove trailing slash
        line = line:gsub("/$", "")
        table.insert(ret, line)
      end
    end

    rawset(self, key, ret)
    return ret
  end,
})
local function max_height()
  local height = vim.fn.winheight(0)
  if height >= 40 then
    return 30
  elseif height >= 30 then
    return 20
  else
    return 10
  end
end

local M = {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  config = function()
    require("oil").setup({
      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
        natural_order = true,
        is_always_hidden = function(name, _)
          return name == ".." or name == ".git"
        end,
        -- Show files and directories that start with "."
        show_hidden = false,
        -- This function defines what is considered a "hidden" file
        is_hidden_file = function(name, _)
          -- dotfiles are always considered hidden
          if vim.startswith(name, ".") then
            return true
          end
          local dir = require("oil").get_current_dir()
          -- if no local directory (e.g. for ssh connections), always show
          if not dir then
            return false
          end
          -- Check if file is gitignored
          return vim.list_contains(git_ignored[dir], name)
        end,
      },
      float = {
        padding = 2,
        max_width = 90,
        max_height = max_height(),
        border = "rounded",
        win_options = {
          winblend = 0,
        },
      },
      win_options = {
        wrap = true,
        winblend = 0,
      },
      keymaps = {
        ["<C-c>"] = false,
        ["q"] = "actions.close",
        ["<C-s>"] = {
          desc = "Save all changes",
          callback = function()
            require("oil").save({ confirm = false })
          end,
        },
        ["<C-y>"] = "actions.copy_entry_path",
      },
    })
  end,
  -- Use g? to see default key mappings
  keys = {
    {
      "<leader>e",
      function()
        require("oil").toggle_float()
      end,
      desc = "Open file explorer",
    },
  },
}

return M
