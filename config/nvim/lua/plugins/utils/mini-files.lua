return {
  "echasnovski/mini.files",
  version = "*",
  event = "VeryLazy",
  keys = function()
    local MiniFiles = require("mini.files")

    local function open_path(path)
      return function()
        MiniFiles.open(vim.fn.expand(path), true)
      end
    end

    local function open_current()
      local buf = vim.api.nvim_buf_get_name(0)
      local target = vim.loop.cwd()
      if buf ~= "" then
        local stat = vim.uv.fs_stat(buf)
        target = stat and stat.type == "directory" and buf or vim.fs.dirname(buf)
      end
      MiniFiles.open(target, true)
    end

    local function open_cwd()
      MiniFiles.open(vim.loop.cwd(), true)
    end

    return {
      { "<leader>em", open_cwd, desc = "MiniFiles CWD" },
      { "<leader>eM", open_current, desc = "MiniFiles Current" },
      {
        "<leader>er",
        function()
          MiniFiles.refresh()
        end,
        desc = "MiniFiles Refresh",
      },

      { "<leader>eH", open_path("~"), desc = "Home" },
      { "<leader>ew", open_path("~/workstation"), desc = "Workstation" },
      { "<leader>ep", open_path("~/workspace"), desc = "Workspace" },
      { "<leader>eC", open_path("~/.config"), desc = "Configs" },
      { "<leader>ec", open_path("~/.config/nvim"), desc = "Nvim Config" },
      { "<leader>et", open_path("~/.config/tmux"), desc = "Tmux Config" },
      { "<leader>ek", open_path("~/.config/kitty"), desc = "Kitty Config" },
      { "<leader>eq", open_path("~/.config/quickshell"), desc = "Quickshell" },
      { "<leader>ey", open_path("~/.config/yazi"), desc = "Yazi Config" },

      {
        "<leader>eY",
        function()
          vim.fn.jobstart({ "bash", "-lc", "~/.config/tmux/scripts/tmux-popup-actions.sh yazi" }, {
            detach = true,
          })
        end,
        desc = "Yazi Popup",
      },
      {
        "<leader>eg",
        function()
          vim.fn.jobstart({ "bash", "-lc", "~/.config/tmux/scripts/tmux-popup-actions.sh lazygit" }, {
            detach = true,
          })
        end,
        desc = "Lazygit Popup",
      },
      {
        "<leader>eb",
        function()
          vim.fn.jobstart({ "bash", "-lc", "~/.config/tmux/scripts/tmux-popup-actions.sh btop" }, {
            detach = true,
          })
        end,
        desc = "Btop Popup",
      },
    }
  end,
  opts = {
    options = {
      permanent_delete = false,
      use_as_default_explorer = false,
    },
    mappings = {
      close = "q",
      go_in = "l",
      go_in_plus = "L",
      go_out = "h",
      go_out_plus = "H",
      mark_goto = "'",
      mark_set = "m",
      reset = "<BS>",
      reveal_cwd = ".",
      show_help = "g?",
      synchronize = "s",
      trim_left = "<",
      trim_right = ">",
    },
    windows = {
      max_number = 5,
      preview = true,
      width_nofocus = 26,
      width_focus = 32,
      width_preview = 48,
    },
  },
  config = function(_, opts)
    local MiniFiles = require("mini.files")
    MiniFiles.setup(opts)

    local set_hl = vim.api.nvim_set_hl

    local palette = {
      bg = "#0A0E14",
      panel = "#111826",
      panel2 = "#182132",
      border = "#22304A",
      fg = "#F2F7FF",
      fg_muted = "#98A9C2",
      blue = "#2AC3FF",
      violet = "#A77DFF",
      yellow = "#FFD000",
      red = "#FF3B5C",
      green = "#39FF14",
    }

    set_hl(0, "MiniFilesBorder", { fg = palette.border, bg = palette.bg })
    set_hl(0, "MiniFilesBorderModified", { fg = palette.yellow, bg = palette.bg })
    set_hl(0, "MiniFilesCursorLine", { bg = palette.panel2 })
    set_hl(0, "MiniFilesDirectory", { fg = palette.blue, bold = true })
    set_hl(0, "MiniFilesFile", { fg = palette.fg })
    set_hl(0, "MiniFilesNormal", { fg = palette.fg, bg = palette.bg })
    set_hl(0, "MiniFilesTitle", { fg = palette.violet, bg = palette.bg, bold = true })
    set_hl(0, "MiniFilesTitleFocused", { fg = palette.bg, bg = palette.blue, bold = true })
    set_hl(0, "MiniFilesTitleModified", { fg = palette.yellow, bg = palette.bg, bold = true })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        local buf_id = args.data.buf_id

        vim.keymap.set("n", "<Esc>", function()
          MiniFiles.close()
        end, { buffer = buf_id, desc = "Close MiniFiles" })

        vim.keymap.set("n", "<CR>", function()
          MiniFiles.go_in({ close_on_file = true })
        end, { buffer = buf_id, desc = "Open file and close" })

        vim.keymap.set("n", "Y", function()
          MiniFiles.close()
          vim.fn.jobstart({ "bash", "-lc", "~/.config/tmux/scripts/tmux-popup-actions.sh yazi" }, {
            detach = true,
          })
        end, { buffer = buf_id, desc = "Open Yazi popup" })

        vim.keymap.set("n", "G", function()
          MiniFiles.close()
          vim.fn.jobstart({ "bash", "-lc", "~/.config/tmux/scripts/tmux-popup-actions.sh lazygit" }, {
            detach = true,
          })
        end, { buffer = buf_id, desc = "Open Lazygit popup" })
      end,
    })
  end,
}
