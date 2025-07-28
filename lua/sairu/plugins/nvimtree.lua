-- ~/.config/nvim/lua/sairu/plugins/nvim-tree.lua

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- Disable built‑in netrw
    vim.g.loaded_netrw       = 1
    vim.g.loaded_netrwPlugin = 1

    -- Define diagnostic signs for NvimTree
    vim.fn.sign_define("NvimTreeDiagnosticError",  { text = "", texthl = "DiagnosticError" })
    vim.fn.sign_define("NvimTreeDiagnosticWarn",   { text = "", texthl = "DiagnosticWarn" })
    vim.fn.sign_define("NvimTreeDiagnosticInfo",   { text = "", texthl = "DiagnosticInfo" })
    vim.fn.sign_define("NvimTreeDiagnosticHint",   { text = "", texthl = "DiagnosticHint" })

    -- Setup
    require("nvim-tree").setup({
      view = {
        width            = 35,
        side             = "left",
        relativenumber   = true,
        number           = false,
      },

      renderer = {
        indent_markers = {
          enable       = true,
          inline_arrows = true,
          icons = {
            corner = "└",
            edge   = "│",
            item   = "│",
            bottom = "─",
            none   = " ",
          },
        },
        icons = {
          glyphs = {
            default  = "",
            symlink  = "",
            folder = {
              default         = "",
              open            = "",
              empty           = "",
              empty_open      = "",
              symlink         = "",
              symlink_open    = "",
              arrow_closed    = "",
              arrow_open      = "",
            },
            git = {
              unstaged = "✗",
              staged   = "✓",
              unmerged = "",
              renamed  = "➜",
              untracked= "★",
              deleted  = "",
              ignored  = "◌",
            },
          },
        },
        highlight_git = true,
        highlight_opened_files = "name",
        root_folder_modifier   = ":~",
      },

      diagnostics = {
        enable            = true,
        show_on_dirs      = true,
        show_on_open_dirs = true,
        debounce_delay    = 50,
        severity = {
          min = vim.diagnostic.severity.HINT,
          max = vim.diagnostic.severity.ERROR,
        },
        icons = {
          error   = "",
          warning = "",
          info    = "",
          hint    = "",
        },
      },

      git = {
        enable        = true,
        ignore        = false,
        show_on_dirs  = true,
        show_on_open_dirs = true,
        timeout       = 400,
      },

      filters = {
        dotfiles  = false,
        custom    = { "^.git$" },
        exclude   = { ".gitignore" },
      },

      actions = {
        open_file = {
          quit_on_open    = false,
          resize_window   = true,
          window_picker   = {
            enable  = true,
            picker  = "default",
            chars   = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
            exclude = {
              filetype = { "notify", "packer", "qf", "diff", "fugitive", "help" },
              buftype  = { "terminal", "help", "nofile" },
            },
          },
        },
        remove_file = {
          close_window = true,
        },
      },

      filesystem_watchers = {
        enable        = true,
        debounce_delay = 50,
        ignore_dirs    = { "node_modules", ".git", ".cache" },
      },

      tab = {
        sync = {
          open  = false,
          close = false,
          ignore= {},
        },
      },

      notify = {
        threshold = vim.log.levels.INFO,
      },

      ui = {
        confirm = {
          remove = true,
          trash  = true,
        },
      },
    })

    -- NvimTree Keymaps - File System Control Matrix
    local function nvim_tree_keymaps()
      local api = require("nvim-tree.api")
      
      vim.keymap.set("n", "<leader>e", api.tree.toggle, { desc = "Toggle file explorer" })
      vim.keymap.set("n", "<leader>ef", api.tree.focus, { desc = "Focus file explorer" })
      vim.keymap.set("n", "<leader>ec", api.tree.collapse_all, { desc = "Collapse file explorer" })
      vim.keymap.set("n", "<leader>er", api.tree.reload, { desc = "Refresh file explorer" })
    end

    -- FileType-specific keymaps for NvimTree
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "NvimTree",
      callback = function(event)
        local opts = { buffer = event.buf, silent = true }
        
        vim.keymap.set("n", "t", function()
          local api = require("nvim-tree.api")
          api.node.open.tab()
        end, vim.tbl_extend("force", opts, { desc = "Open in new tab" }))
        
        vim.keymap.set("n", "<leader>e", function()
          local api = require("nvim-tree.api")
          api.tree.toggle()
        end, vim.tbl_extend("force", opts, { desc = "Toggle explorer" }))
        
        vim.keymap.set("n", "<leader>f", function()
          local api = require("nvim-tree.api")
          api.tree.focus()
        end, vim.tbl_extend("force", opts, { desc = "Focus explorer" }))
        
        vim.keymap.set("n", "<leader>c", function()
          local api = require("nvim-tree.api")
          api.tree.collapse_all()
        end, vim.tbl_extend("force", opts, { desc = "Collapse all" }))
        
        vim.keymap.set("n", "<leader>r", function()
          local api = require("nvim-tree.api")
          api.tree.reload()
        end, vim.tbl_extend("force", opts, { desc = "Refresh tree" }))
      end,
    })

    -- Initialize keymaps
    nvim_tree_keymaps()
  end,
}
