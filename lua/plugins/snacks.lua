-- Snacks.nvim Visual Configuration
-- Picker, Notifier, Dashboard, Git, Terminal, etc.

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- ───────────────────────────────────────────────────────────────────────
    -- BIGFILE - Handle large files
    -- ───────────────────────────────────────────────────────────────────────
    bigfile = {
      enabled = true,
      notify = true,
      size = 1.5 * 1024 * 1024, -- 1.5MB
    },

    -- ───────────────────────────────────────────────────────────────────────
    -- DASHBOARD - Start screen (Stealth Cockpit — DedSec/VEGA Ops)
    -- ───────────────────────────────────────────────────────────────────────
    dashboard = {
      enabled = true,
      width = 70,
      pane_gap = 4,
      preset = {
        header = [[
    ██████╗ ██████╗  █████╗ ████████╗███████╗ ██████╗ ██╗  ██╗
    ██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██╔═══██╗██║  ██║
    ██████╔╝██████╔╝███████║   ██║   ███████╗██║   ██║███████║
    ██╔══██╗██╔═══╝ ██╔══██║   ██║   ╚════██║██║   ██║██╔══██║
    ██████╔╝██║     ██║  ██║   ██║   ███████║╚██████╔╝██║  ██║
    ╚═════╝ ╚═╝     ╚═╝  ╚═╝   ╚═╝   ╚══════╝ ╚═════╝ ╚═╝  ╚═╝
    
    ▄▄▄▄· ▄• ▄▌▄▄▄  ▄▄▄ . ▄▄▄▄· ▄▄▄▄▄     • ▌ ▄ ·. ▪  ▄▄▌  
    ▐█ ▀█▪█▪██▌▀▄ █·▀▄.▀·▐█ ▀█▪•██  ▪     ·██ ▐███▪██ ██•  
    ▐█▀▀█▄█▌▐█▌▐▀▀▄ ▐▀▀▪▄▐█▀▀█▄ ▐█.▪ ▄█▀▄ ▐█ ▌▐▀▐█·██ ██▪  
    ██▄▪▐█▐█▄█▌▐█•█▌▐█▄▄▌██▄▪▐█ ▐█▌·▐█▌.▐▌██ ██▌▐█▌██ ▐█▌▐▌
    ·▀▀▀▀  ▀▀▀ .▀  ▀ ▀▀▀ ·▀▀▀▀  ▀▀▀ ▀▀▀ ·▀▀  █▪▀▀▀▀▀ ▀▀█ ▀▀▀·
    
    ░▒▓█ DEDSEC // VEGA OPS █▓▒░]],
        keys = {
          { icon = "█ ", key = "f", desc = "FILES", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = "█ ", key = "g", desc = "TRACE TEXT", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = "█ ", key = "r", desc = "RECENT INTEL", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = "█ ", key = "p", desc = "PROJECTS", action = ":lua Snacks.dashboard.pick('projects')" },
          {
            icon = "█ ",
            key = "c",
            desc = "CONFIG",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          {
            icon = "█ ",
            key = "w",
            desc = "WALLPAPER",
            action = ":lua Snacks.image.open('/home/sairu/dotfiles/config/kitty/assets/dedsec-stealth-cockpit-bg.png')",
          },
          { icon = "█ ", key = "s", desc = "RESTORE SESSION", section = "session" },
          { icon = "█ ", key = "a", desc = "ARDUINO/ESP32", action = ":lua Snacks.dashboard.pick('files', {cwd = '~/Lab'})" },
          { icon = "█ ", key = "l", desc = "LAZY", action = ":Lazy" },
          { icon = "█ ", key = "u", desc = "UPDATE", action = ":Lazy update" },
          { icon = "█ ", key = "q", desc = "QUIT", action = ":qa" },
        },
      },
      sections = {
        { section = "header", padding = 1 },
        { section = "keys", gap = 0, padding = 1 },
        { section = "startup", padding = 1 },
      },
    },

    -- ───────────────────────────────────────────────────────────────────────
    -- EXPLORER - File explorer (disabled, using oil.nvim)
    -- ───────────────────────────────────────────────────────────────────────
    explorer = { enabled = false },

    -- ───────────────────────────────────────────────────────────────────────
    -- GIT - Git integrations
    -- ───────────────────────────────────────────────────────────────────────
    git = {
      enabled = true,
      configure = true,
    },

    -- ───────────────────────────────────────────────────────────────────────
    -- GITBROWSE - Open GitHub/GitLab URLs
    -- ───────────────────────────────────────────────────────────────────────
    gitbrowse = { enabled = true },

    -- ───────────────────────────────────────────────────────────────────────
    -- IMAGE - Image preview
    -- ───────────────────────────────────────────────────────────────────────
    image = {
      enabled = true,
      doc = {
        enabled = true,
        inline = true,
        float = true,
        max_width = 80,
        max_height = 35,
      },
      wo = {
        number = false,
        relativenumber = false,
        signcolumn = "no",
        foldcolumn = "0",
        statuscolumn = "",
      },
    },

    -- ───────────────────────────────────────────────────────────────────────
    -- INDENT - Indent guides
    -- ───────────────────────────────────────────────────────────────────────
    indent = {
      enabled = true,
      indent = { char = "│", priority = 1 },
      scope = { char = "│", priority = 1024, underline = false, only_current = true },
      chunk = { enabled = false },
      animate = { enabled = true, style = "out", duration = 150 },
      filter = function(buf)
        return vim.bo[buf].buftype == "" and vim.bo[buf].filetype ~= "help"
      end,
    },

    -- ───────────────────────────────────────────────────────────────────────
    -- INPUT - Better vim.ui.input
    -- ───────────────────────────────────────────────────────────────────────
    input = {
      enabled = true,
      win = {
        style = "input",
        border = "single",
        title_pos = "center",
        zindex = 100,
      },
    },

    -- ───────────────────────────────────────────────────────────────────────
    -- LAYOUT - Window layouts
    -- ───────────────────────────────────────────────────────────────────────
    layout = { enabled = true },

    -- ───────────────────────────────────────────────────────────────────────
    -- LAZYGIT - Terminal-based Git UI
    -- ───────────────────────────────────────────────────────────────────────
    lazygit = {
      enabled = true,
      configure = true,
      win = {
        style = "lazygit",
        border = "single",
      },
    },

    -- ───────────────────────────────────────────────────────────────────────
    -- NOTIFIER - Notification system
    -- ───────────────────────────────────────────────────────────────────────
    notifier = {
      enabled = true,
      timeout = 3000,
      width = { min = 40, max = 80 },
      height = { min = 1, max = 10 },
      margin = { top = 1, right = 1, bottom = 1 },
      padding = true,
      sort = { "level", "added" },
      level = vim.log.levels.TRACE,
      icons = {
        error = "󰅚 ",
        warn = "󰀪 ",
        info = "󰋽 ",
        debug = "󰃮 ",
        trace = "󰌽 ",
      },
      style = "compact",
      top_down = true,
      date_format = "%H:%M:%S",
      more_format = " ↓ %d lines ",
      refresh = 50,
      notify = function(msg, level, opts)
        return msg
      end,
    },

    -- ───────────────────────────────────────────────────────────────────────
    -- PICKER - Telescope replacement
    -- ───────────────────────────────────────────────────────────────────────
    picker = {
      enabled = true,
      layout = {
        preset = "ivy",
        layout = {
          backdrop = false,
          row = 1,
          width = 0.9,
          height = 0.45,
          border = "single",
          title = " {title} ",
          title_pos = "center",
          box = "vertical",
          {
            win = "input",
            height = 1,
            border = "single",
            title = " {title} {live} {flags} ",
            title_pos = "center",
          },
          {
            win = "list",
            border = "single",
          },
          {
            win = "preview",
            title = " {preview} ",
            border = "single",
            height = 0.5,
          },
        },
      },
      sources = {
        files = { layout = { preset = "ivy" } },
        grep = { layout = { preset = "ivy" } },
        buffers = { layout = { preset = "ivy" } },
        recent = { layout = { preset = "ivy" } },
        lsp_definitions = { layout = { preset = "ivy" } },
        lsp_references = { layout = { preset = "ivy" } },
        lsp_implementations = { layout = { preset = "ivy" } },
        lsp_type_definitions = { layout = { preset = "ivy" } },
        diagnostics = { layout = { preset = "ivy" } },
        commands = { layout = { preset = "ivy" } },
        keymaps = { layout = { preset = "ivy" } },
        help = { layout = { preset = "ivy" } },
        man = { layout = { preset = "ivy" } },
      },
      win = {
        input = {
          keys = {
            ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" }, desc = "Preview Up" },
            ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" }, desc = "Preview Down" },
            ["<c-h>"] = { "toggle_hidden", mode = { "i", "n" }, desc = "Toggle Hidden" },
            ["<c-i>"] = { "toggle_ignored", mode = { "i", "n" }, desc = "Toggle Ignored" },
            ["<c-f>"] = { "toggle_follow", mode = { "i", "n" }, desc = "Toggle Follow" },
            ["<c-w>"] = { "cycle_win", mode = { "i", "n" }, desc = "Cycle Window" },
          },
        },
      },
      formatters = {
        file = { filename_first = true, truncate = 80 },
        severity = { icons = true },
      },
    },

    -- ───────────────────────────────────────────────────────────────────────
    -- PROFILER - Startup profiling
    -- ───────────────────────────────────────────────────────────────────────
    profiler = { enabled = true },

    -- ───────────────────────────────────────────────────────────────────────
    -- QUICKFILE - Fast file operations
    -- ───────────────────────────────────────────────────────────────────────
    quickfile = { enabled = true },

    -- ───────────────────────────────────────────────────────────────────────
    -- RENAME - LSP rename with preview
    -- ───────────────────────────────────────────────────────────────────────
    rename = { enabled = true },

    -- ───────────────────────────────────────────────────────────────────────
    -- SCOPE - Scope detection
    -- ───────────────────────────────────────────────────────────────────────
    scope = { enabled = true },

    -- ───────────────────────────────────────────────────────────────────────
    -- SCROLL - Smooth scrolling
    -- ───────────────────────────────────────────────────────────────────────
    scroll = {
      enabled = true,
      animate = { duration = 60, easing = "outCubic" },
      animate_repeat = { delay = 100, duration = 60, easing = "outCubic" },
      filter = function(buf)
        return vim.bo[buf].buftype == ""
      end,
    },

    -- ───────────────────────────────────────────────────────────────────────
    -- SPLIT - Better split management
    -- ───────────────────────────────────────────────────────────────────────
    split = { enabled = true },

    -- ───────────────────────────────────────────────────────────────────────
    -- STATUSCOLUMN - Custom statuscolumn
    -- ───────────────────────────────────────────────────────────────────────
    statuscolumn = {
      enabled = true,
      left = { "mark", "sign" },
      right = { "fold", "git" },
      folds = {
        open = false,
        git_hl = true,
      },
      git = {
        patterns = { "GitSign" },
      },
    },

    -- ───────────────────────────────────────────────────────────────────────
    -- STYLING - Global styling
    -- ───────────────────────────────────────────────────────────────────────
    styles = {
      notification = {
        wo = {
          wrap = true,
        },
      },
      notification_history = {
        border = "single",
        zindex = 100,
      },
      input = {
        border = "single",
        title_pos = "center",
        wo = {
          winblend = 0,
        },
      },
      minimal = {
        border = "single",
      },
      lazygit = {
        width = 0.9,
        height = 0.9,
        border = "single",
      },
      terminal = {
        width = 0.9,
        height = 0.8,
        border = "single",
        win = {
          wo = {
            winblend = 0,
          },
        },
      },
      scratch = {
        border = "single",
        width = 0.8,
        height = 0.6,
      },
      zen = {
        border = "none",
        backdrop = { transparent = true },
        width = 120,
      },
    },

    -- ───────────────────────────────────────────────────────────────────────
    -- TERMINAL - Integrated terminal
    -- ───────────────────────────────────────────────────────────────────────
    terminal = {
      enabled = true,
      win = {
        style = "terminal",
        border = "single",
        wo = {
          winblend = 0,
          number = false,
          relativenumber = false,
        },
      },
      shell = vim.o.shell,
    },

    -- ───────────────────────────────────────────────────────────────────────
    -- TOGGLE - Toggle helpers
    -- ───────────────────────────────────────────────────────────────────────
    toggle = {
      map = function(mode, lhs, rhs, opts)
        local keys = require("lazy.core.handler").handlers.keys
        if not keys.parse({ lhs, mode = mode }) then
          vim.keymap.set(mode, lhs, rhs, opts)
        end
      end,
    },

    -- ───────────────────────────────────────────────────────────────────────
    -- WORDS - LSP references highlighting
    -- ───────────────────────────────────────────────────────────────────────
    words = {
      enabled = true,
      debounce = 200,
      notify_end = true,
      notify_jump = true,
      modes = { "n", "i", "c" },
    },

    -- ───────────────────────────────────────────────────────────────────────
    -- ZEN - Zen mode
    -- ───────────────────────────────────────────────────────────────────────
    zen = {
      enabled = true,
      toggles = {
        dim = true,
        git_signs = true,
        mini_diff_signs = true,
        diagnostics = true,
        inlay_hints = true,
      },
      show = {
        statusline = true,
        tabline = true,
      },
      win = {
        style = "zen",
        zindex = 90,
        border = "none",
        wo = {
          winblend = 0,
          number = false,
          relativenumber = false,
          cursorline = false,
          cursorcolumn = false,
        },
      },
    },
  },
  keys = {
    -- Picker
    {
      "<leader><space>",
      function()
        Snacks.picker.files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent()
      end,
      desc = "Recent Files",
    },
    {
      "<leader>fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.grep()
      end,
      desc = "Live Grep",
    },
    {
      "<leader>fh",
      function()
        Snacks.picker.help()
      end,
      desc = "Help Tags",
    },
    {
      "<leader>fk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "Keymaps",
    },
    {
      "<leader>fc",
      function()
        Snacks.picker.commands()
      end,
      desc = "Commands",
    },
    {
      "<leader>f/",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep",
    },
    {
      "<leader>f.",
      function()
        Snacks.picker.recent()
      end,
      desc = "Recent Files",
    },
    {
      "<leader>f:",
      function()
        Snacks.picker.command_history()
      end,
      desc = "Command History",
    },
    {
      "<leader>fm",
      function()
        Snacks.picker.marks()
      end,
      desc = "Marks",
    },
    {
      "<leader>fj",
      function()
        Snacks.picker.jumps()
      end,
      desc = "Jumps",
    },
    {
      "<leader>fl",
      function()
        Snacks.picker.loclist()
      end,
      desc = "Location List",
    },
    {
      "<leader>fq",
      function()
        Snacks.picker.qflist()
      end,
      desc = "Quickfix List",
    },
    {
      "<leader>fd",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "Diagnostics",
    },
    {
      "<leader>fs",
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "LSP Symbols",
    },
    {
      "<leader>fS",
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = "Workspace Symbols",
    },
    {
      "<leader>ft",
      function()
        Snacks.picker.todo_comments()
      end,
      desc = "Todo Comments",
    },
    {
      "<leader>fz",
      function()
        Snacks.picker.zoxide()
      end,
      desc = "Zoxide",
    },

    -- LSP
    {
      "gd",
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = "Goto Definition",
    },
    {
      "gD",
      function()
        Snacks.picker.lsp_declarations()
      end,
      desc = "Goto Declaration",
    },
    {
      "gr",
      function()
        Snacks.picker.lsp_references()
      end,
      desc = "References",
    },
    {
      "gi",
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = "Goto Implementation",
    },
    {
      "gy",
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = "Goto Type Definition",
    },

    -- Git
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>gb",
      function()
        Snacks.picker.git_branches()
      end,
      desc = "Git Branches",
    },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log()
      end,
      desc = "Git Log",
    },
    {
      "<leader>gL",
      function()
        Snacks.picker.git_log_line()
      end,
      desc = "Git Log Line",
    },
    {
      "<leader>gs",
      function()
        Snacks.picker.git_status()
      end,
      desc = "Git Status",
    },
    {
      "<leader>gf",
      function()
        Snacks.picker.git_log_file()
      end,
      desc = "Git Log File",
    },

    -- Notifications
    {
      "<leader>un",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },
    {
      "<leader>ud",
      function()
        Snacks.notifier.hide_all()
      end,
      desc = "Dismiss All Notifications",
    },

    -- Terminal
    {
      "<leader>tt",
      function()
        Snacks.terminal()
      end,
      desc = "Terminal",
    },
    {
      "<leader>tf",
      function()
        Snacks.terminal.toggle()
      end,
      desc = "Toggle Terminal",
    },
    {
      "<leader>tl",
      function()
        Snacks.terminal.last()
      end,
      desc = "Last Terminal",
    },

    -- Zen
    {
      "<leader>z",
      function()
        Snacks.zen()
      end,
      desc = "Zen Mode",
    },
    {
      "<leader>Z",
      function()
        Snacks.zen.zoom()
      end,
      desc = "Zoom",
    },

    -- Scratch
    {
      "<leader>.",
      function()
        Snacks.scratch()
      end,
      desc = "Scratch Buffer",
    },
    {
      "<leader>,",
      function()
        Snacks.scratch.select()
      end,
      desc = "Select Scratch Buffer",
    },

    -- Profiler
    {
      "<leader>pp",
      function()
        Snacks.profiler.start()
      end,
      desc = "Start Profiling",
    },
    {
      "<leader>ps",
      function()
        Snacks.profiler.stop()
      end,
      desc = "Stop Profiling",
    },
    {
      "<leader>pr",
      function()
        Snacks.profiler.report()
      end,
      desc = "Profile Report",
    },

    -- Picker toggle
    {
      "<c-p>",
      function()
        Snacks.picker.files()
      end,
      mode = { "n", "i", "t" },
      desc = "Find Files",
    },
    {
      "<c-b>",
      function()
        Snacks.picker.buffers()
      end,
      mode = { "n", "i", "t" },
      desc = "Buffers",
    },
  },
}
