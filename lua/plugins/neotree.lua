return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  config = function()
    -- Define os ícones diretamente para cada tipo de arquivo
    local icons = {
      FolderClosed = "",
      FolderOpen = "",
      FolderEmpty = "",
      DefaultFile = "",
      GitAdd = "",
      GitDelete = "",
      GitChange = "",
      GitRenamed = "➜",
      GitUntracked = "★",
      GitIgnored = "◌",
      GitUnstaged = "✗",
      GitStaged = "✓",
      GitConflict = "",
      FileModified = "●",
    }

    require("neo-tree").setup({
      auto_clean_after_session_restore = true,
      close_if_last_window = true,
      buffers = { show_unloaded = true },
      sources = { "filesystem", "buffers", "git_status" },
      source_selector = {
        winbar = true,
        content_layout = "center",
        sources = {
          { source = "filesystem", display_name = icons.FolderClosed .. " File" },
          { source = "buffers", display_name = icons.DefaultFile .. " Bufs" },
          { source = "git_status", display_name = icons.GitAdd .. " Git" },
          { source = "diagnostics", display_name = "🔍 Diagnostic" },
        },
      },
      default_component_configs = {
        indent = { padding = 0 },
        icon = {
          folder_closed = icons.FolderClosed,
          folder_open = icons.FolderOpen,
          folder_empty = icons.FolderEmpty,
          folder_empty_open = icons.FolderEmpty,
          default = icons.DefaultFile,
        },
        modified = { symbol = icons.FileModified },
        git_status = {
          symbols = {
            added = icons.GitAdd,
            deleted = icons.GitDelete,
            modified = icons.GitChange,
            renamed = icons.GitRenamed,
            untracked = icons.GitUntracked,
            ignored = icons.GitIgnored,
            unstaged = icons.GitUnstaged,
            staged = icons.GitStaged,
            conflict = icons.GitConflict,
          },
        },
      },
      commands = {
        system_open = function(state)
          local path = state.tree:get_node():get_id()
          vim.fn.jobstart({ "xdg-open", path }, { detach = true })
        end,
        parent_or_close = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" and node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
        child_or_open = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" then
            if not node:is_expanded() then
              state.commands.toggle_node(state)
            else
              require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
            end
          else
            state.commands.open(state)
          end
        end,
        copy_selector = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local options = {
            e = { val = vim.fn.fnamemodify(filename, ":e"), msg = "Extension" },
            f = { val = filename, msg = "Filename" },
            F = { val = vim.fn.fnamemodify(filename, ":r"), msg = "Filename w/o extension" },
            h = { val = vim.fn.fnamemodify(filepath, ":~"), msg = "Path relative to Home" },
            p = { val = vim.fn.fnamemodify(filepath, ":."), msg = "Path relative to CWD" },
            P = { val = filepath, msg = "Absolute path" },
          }
          local msg = { { "\nChoose to copy to clipboard:\n", "Normal" } }
          for k, v in pairs(options) do
            table.insert(msg, { k .. ".", "Identifier" })
            table.insert(msg, { " " .. v.msg .. ": " })
            table.insert(msg, { v.val .. "\n", "String" })
          end
          vim.api.nvim_echo(msg, false, {})
          local choice = options[vim.fn.getcharstr()]
          if choice and choice.val then
            vim.fn.setreg("+", choice.val)
            vim.notify("Copied: " .. choice.val)
          end
        end,
      },
      window = {
        width = 35,
        mappings = {
          ["<space>"] = false,
          ["<S-CR>"] = "system_open",
          ["[b"] = "prev_source",
          ["]b"] = "next_source",
          F = "find_in_dir",
          O = "system_open",
          Y = "copy_selector",
          h = "parent_or_close",
          l = "child_or_open",
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = { "node_modules" },
          never_show = { ".DS_Store", "thumbs.db" },
        },
      },
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function(_) vim.opt_local.signcolumn = "auto" end,
        },
      },
    })
  end
}


