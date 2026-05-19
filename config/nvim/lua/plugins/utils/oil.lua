return {
  "stevearc/oil.nvim",
  dependencies = { "echasnovski/mini.icons" },
  cmd = "Oil",
  keys = {
    {
      "<leader>ee",
      function()
        require("oil").open(vim.uv.cwd())
      end,
      desc = "Oil CWD",
    },
    {
      "<leader>eo",
      function()
        local buf = vim.api.nvim_buf_get_name(0)
        if buf == "" then
          require("oil").open(vim.uv.cwd())
          return
        end
        local stat = vim.uv.fs_stat(buf)
        if stat and stat.type == "directory" then
          require("oil").open(buf)
        else
          require("oil").open(vim.fs.dirname(buf))
        end
      end,
      desc = "Oil Current",
    },
    { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
  },
  opts = {
    default_file_explorer = true,
    columns = { "icon", "permissions", "size", "mtime" },
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
      is_hidden_file = function(name, _)
        return name == ".."
      end,
    },
    float = {
      padding = 2,
      max_width = 0.9,
      max_height = 0.9,
      border = "single",
    },
    keymaps = {
      ["q"] = "actions.close",
      ["<Esc>"] = "actions.close",
      ["<CR>"] = "actions.select",
      ["-"] = "actions.parent",
      ["<C-r>"] = "actions.refresh",
      ["g."] = "actions.toggle_hidden",
      ["<C-s>"] = false,
    },
  },
}
