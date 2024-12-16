return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    close_if_last_window = true, -- Close Neo-tree if it is the last window
    window = {
      width = 35, -- Set the width to make it more like an IDE sidebar
      mappings = {
        ["e"] = "open", -- Open selected file
        ["E"] = function()
          vim.cmd "Neotree focus filesystem left"
        end,
        ["b"] = function()
          vim.cmd "Neotree focus buffers left"
        end,
        ["g"] = function()
          vim.cmd "Neotree focus git_status left"
        end,
        ["<c-/>"] = "fuzzy_finder_directory", -- Quick directory fuzzy search
        ["D"] = function(state)
          local node = state.tree:get_node()
          local log = require "neo-tree.log"
          state.clipboard = state.clipboard or {}
          if diff_Node and diff_Node ~= tostring(node.id) then
            local current_Diff = node.id
            require("neo-tree.utils").open_file(state, diff_Node, "open")
            vim.cmd("vert diffs " .. current_Diff)
            log.info("Diffing " .. state.clipboard[node.id].node.name .. " against " .. node.name)
            diff_Node = nil
            current_Diff = nil
            state.clipboard = {}
            require("neo-tree.ui.renderer").redraw(state)
          else
            local existing = state.clipboard[node.id]
            if existing and existing.action == "diff" then
              state.clipboard[node.id] = nil
              diff_Node = nil
              require("neo-tree.ui.renderer").redraw(state)
            else
              state.clipboard[node.id] = { action = "diff", node = node }
              local diff_Name = state.clipboard[node.id].node.name
              local diff_Node = tostring(state.clipboard[node.id].node.id)
              log.info("Diff source file " .. diff_Name)
              require("neo-tree.ui.renderer").redraw(state)
            end
          end
        end,
      },
    },
    filesystem = {
      hijack_netrw_behavior = "open_default", -- Override default netrw behavior
      use_libuv_file_watcher = true, -- Enable file watching
      filtered_items = {
        visible = true, -- Make hidden files visible
        hide_dotfiles = false,
      },
      window = {
        mappings = {
          ["o"] = "open", -- Open file on Enter
          ["C"] = "close_node", -- Close the selected node
          ["r"] = "rename", -- Rename file
          ["d"] = "delete", -- Delete file
        },
      },
    },
    git_status = {
      window = {
        mappings = {
          ["s"] = "stage_file", -- Stage file in git status view
          ["u"] = "unstage_file", -- Unstage file in git status view
          ["p"] = "preview_file", -- Preview file in git status
        },
      },
    },
    -- Icons (for VSCode-like UI)
    icons = {
      error = "",
      warning = "",
      info = "",
      hint = "",
      kind = {
        file = "", -- File icon
        folder = "", -- Folder icon
        git = "", -- Git icon
        symlink = "", -- Symlink icon
      },
    },
  },
  -- Use the 'nvim-web-devicons' for better file icons
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
