-- Which-Key Conditional Configuration
-- Smart keymaps that only show when contextually relevant
-- Fast, no pills, pure ASCII/icons

local M = {}

-- Base always-available keymaps
M.base_spec = {
  -- Navigation
  { "<leader><tab>", group = "tabs", icon = "󰓩 " },
  { "<leader>b", group = "buffer", icon = "󰈔 " },
  { "<leader>e", group = "explorer", icon = "󰙅 " },
  { "<leader>f", group = "find", icon = "󰈞 " },
  { "<leader>g", group = "git", icon = "󰊢 " },
  { "<leader>gh", group = "hunks", icon = "󰊢 " },
  { "<leader>l", group = "lsp", icon = "󰘦 " },
  { "<leader>q", group = "quit/session", icon = "󰗼 " },
  { "<leader>s", group = "search", icon = "󰍉 " },
  { "<leader>t", group = "toggle", icon = "󰔡 " },
  { "<leader>u", group = "ui", icon = "󰙵 " },
  { "<leader>w", group = "windows", icon = " " },
  { "<leader>x", group = "diagnostics", icon = "󱖫 " },
  { "<leader>y", group = "yank", icon = "󰅍 " },

  { "[", group = "prev", icon = "󰒮 " },
  { "]", group = "next", icon = "󰒭 " },
  { "g", group = "goto", icon = "󰁔 " },
  { "gs", group = "surround", icon = "󰅪 " },
  { "z", group = "fold", icon = "󰘖 " },

  -- Buffer
  { "<leader>ba", "<cmd>bufdo bd<cr>", desc = "Close All", icon = "󰅖 " },
  { "<leader>bd", "<cmd>bd<cr>", desc = "Close Buffer", icon = "󰅖 " },
  { "<leader>bo", "<cmd>%bd|e#|bd#<cr>", desc = "Close Others", icon = "󰛌 " },

  -- Code
  { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", icon = "󰌶 " },
  { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", icon = "󰑕 " },
  {
    "<leader>cf",
    function()
      require("conform").format({ async = true })
    end,
    desc = "Format",
    icon = "󰉼 ",
  },

  -- Explorer
  { "<leader>ee", "<cmd>Oil<cr>", desc = "Explorer", icon = "󰙅 " },
  { "<leader>ef", "<cmd>Oil --float<cr>", desc = "Explorer Float", icon = "󰙅 " },

  -- Find
  { "<leader>ff", "<cmd>Fff<cr>", desc = "Find Files", icon = "󰈞 " },
  { "<leader>fg", "<cmd>Fff live_grep<cr>", desc = "Live Grep", icon = "󰍉 " },
  { "<leader>fr", "<cmd>Fff recent<cr>", desc = "Recent", icon = "󰁯 " },
  { "<leader>fb", "<cmd>Fff buffers<cr>", desc = "Buffers", icon = "󰈙 " },

  -- Git
  { "<leader>gb", "<cmd>Gitsigns blame_line<cr>", desc = "Blame Line", icon = "󰊢 " },
  { "<leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff This", icon = "󰣏 " },
  { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview Hunk", icon = "󰆊 " },
  { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk", icon = "󰜉 " },
  { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk", icon = "󰜥 " },
  { "<leader>gc", "<cmd>Neogit<cr>", desc = "Neogit", icon = "󰊢 " },

  -- Hunk nav
  { "<leader>ghn", "<cmd>Gitsigns next_hunk<cr>", desc = "Next Hunk", icon = "󰒭 " },
  { "<leader>ghp", "<cmd>Gitsigns prev_hunk<cr>", desc = "Prev Hunk", icon = "󰒮 " },

  -- LSP
  { "<leader>ld", "<cmd>Lspsaga show_line_diagnostics<cr>", desc = "Line Diagnostics", icon = "󱖫 " },
  { "<leader>la", "<cmd>Lspsaga code_action<cr>", desc = "Code Action", icon = "󰌶 " },
  { "<leader>lr", "<cmd>Lspsaga rename<cr>", desc = "Rename", icon = "󰑕 " },
  { "<leader>lf", "<cmd>Lspsaga lsp_finder<cr>", desc = "LSP Finder", icon = "󰈞 " },
  { "<leader>lh", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover Doc", icon = "󰍜 " },

  -- Quit/Session
  { "<leader>qq", "<cmd>qa<cr>", desc = "Quit All", icon = "󰗼 " },
  { "<leader>qw", "<cmd>wqa<cr>", desc = "Save & Quit", icon = "󰗼 " },
  { "<leader>qs", "<cmd>SessionSave<cr>", desc = "Save Session", icon = " " },
  { "<leader>qr", "<cmd>SessionRestore<cr>", desc = "Restore Session", icon = " " },

  -- Search
  { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics", icon = "󱖫 " },
  { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep", icon = "󰍉 " },
  { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Files", icon = "󰈞 " },
  { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume", icon = "󰑑 " },

  -- Toggle
  { "<leader>td", "<cmd>ToggleDiagnostics<cr>", desc = "Diagnostics", icon = "󰔡 " },
  { "<leader>tf", "<cmd>ToggleFormat<cr>", desc = "Format on Save", icon = "󰔡 " },
  { "<leader>th", "<cmd>set hlsearch!<cr>", desc = "Highlight", icon = "󰔡 " },
  { "<leader>ti", "<cmd>IBLToggle<cr>", desc = "Indent Guides", icon = "󰔡 " },
  { "<leader>tn", "<cmd>set number! relativenumber!<cr>", desc = "Numbers", icon = "󰔡 " },
  { "<leader>ts", "<cmd>set spell!<cr>", desc = "Spell", icon = "󰔡 " },
  { "<leader>tw", "<cmd>set wrap!<cr>", desc = "Wrap", icon = "󰔡 " },
  { "<leader>tz", "<cmd>ZenMode<cr>", desc = "Zen Mode", icon = "󰔡 " },

  -- UI
  { "<leader>uc", "<cmd>ThemeCycle<cr>", desc = "Cycle Theme", icon = "󰏘 " },
  { "<leader>uC", "<cmd>Theme<cr>", desc = "Select Theme", icon = "󰏘 " },

  -- Windows
  { "<leader>ws", "<C-w>s", desc = "Split H", icon = "󰁍 " },
  { "<leader>wv", "<C-w>v", desc = "Split V", icon = "󰁌 " },
  { "<leader>wc", "<C-w>c", desc = "Close", icon = "󰅖 " },
  { "<leader>wo", "<C-w>o", desc = "Only", icon = "󰛌 " },

  -- Diagnostics
  { "<leader>xd", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics", icon = "󱖫 " },
  { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Loclist", icon = "󱖫 " },
  { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix", icon = "󱖫 " },

  -- Yank
  { "<leader>yp", "<cmd>let @+ = expand('%:p')<cr>", desc = "Full Path", icon = "󰅍 " },
  { "<leader>yr", "<cmd>let @+ = expand('%')<cr>", desc = "Relative Path", icon = "󰅍 " },
  { "<leader>yf", "<cmd>let @+ = expand('%:t')<cr>", desc = "Filename", icon = "󰅍 " },
}

-- Context-specific keymaps (loaded conditionally)
M.context_specs = {
  python = {
    {
      "<leader>py",
      function()
        require("config.workflows").run_command("python", "run")
      end,
      desc = "Run",
      icon = "󰌠 ",
    },
    {
      "<leader>pt",
      function()
        require("config.workflows").run_command("python", "test")
      end,
      desc = "Test",
      icon = "󰌠 ",
    },
    {
      "<leader>pl",
      function()
        require("config.workflows").run_command("python", "lint")
      end,
      desc = "Lint",
      icon = "󰌠 ",
    },
    {
      "<leader>pf",
      function()
        require("config.workflows").run_command("python", "fmt")
      end,
      desc = "Format",
      icon = "󰌠 ",
    },
  },
  csharp = {
    {
      "<leader>cb",
      function()
        require("config.workflows").run_command("csharp", "build")
      end,
      desc = "Build",
      icon = "󰌛 ",
    },
    {
      "<leader>cr",
      function()
        require("config.workflows").run_command("csharp", "run")
      end,
      desc = "Run",
      icon = "󰌛 ",
    },
    {
      "<leader>ct",
      function()
        require("config.workflows").run_command("csharp", "test")
      end,
      desc = "Test",
      icon = "󰌛 ",
    },
    {
      "<leader>cw",
      function()
        require("config.workflows").run_command("csharp", "watch")
      end,
      desc = "Watch",
      icon = "󰌛 ",
    },
  },
  arduino = {
    -- Arduino CLI (primary, lightweight)
    {
      "<leader>ab",
      function()
        require("config.workflows").run_command("arduino", "build")
      end,
      desc = "Build (CLI)",
      icon = "󰜺 ",
    },
    {
      "<leader>au",
      function()
        require("config.workflows").run_command("arduino", "upload")
      end,
      desc = "Upload (CLI)",
      icon = "󰜺 ",
    },
    {
      "<leader>am",
      function()
        require("config.workflows").run_command("arduino", "monitor")
      end,
      desc = "Monitor (CLI)",
      icon = "󰜺 ",
    },
    -- PlatformIO (full project, libs, test, CI)
    {
      "<leader>aB",
      function()
        require("config.workflows").run_command("arduino", "pio_build")
      end,
      desc = "Build (PIO)",
      icon = "󰍢 ",
    },
    {
      "<leader>aU",
      function()
        require("config.workflows").run_command("arduino", "pio_upload")
      end,
      desc = "Upload (PIO)",
      icon = "󰍢 ",
    },
    {
      "<leader>aM",
      function()
        require("config.workflows").run_command("arduino", "pio_monitor")
      end,
      desc = "Monitor (PIO)",
      icon = "󰍢 ",
    },
    {
      "<leader>aX",
      function()
        require("config.workflows").run_command("arduino", "pio_clean")
      end,
      desc = "Clean (PIO)",
      icon = "󰍢 ",
    },
    -- Board detection & info
    {
      "<leader>ad",
      function()
        local board = require("config.workflows").detect_arduino_board()
        if board then
          local variant = board.variant and (" [" .. board.variant .. "]") or ""
          vim.notify(
            "📟 " .. board.name .. variant .. " @ " .. board.port .. " (" .. board.fqbn .. ")",
            vim.log.levels.INFO
          )
        else
          vim.notify("No board detected", vim.log.levels.WARN)
        end
      end,
      desc = "Detect Board",
      icon = "󰜺 ",
    },
    {
      "<leader>aD",
      function()
        local boards = require("config.workflows").list_arduino_boards()
        if #boards > 0 then
          local lines = { "Detected boards:" }
          for _, b in ipairs(boards) do
            local v = b.variant and (" [" .. b.variant .. "]") or ""
            table.insert(lines, "  " .. b.port .. " → " .. b.name .. v .. " (" .. b.fqbn .. ")")
          end
          vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
        else
          vim.notify("No boards detected", vim.log.levels.WARN)
        end
      end,
      desc = "List All Boards",
      icon = "󰜺 ",
    },
    -- ESP32 variant quick compiles (manual override)
    {
      "<leader>ae",
      function()
        require("config.workflows").run_command("arduino", "esp32_compile", "dev")
      end,
      desc = "Compile ESP32 DevKit",
      icon = "󰷝 ",
    },
    {
      "<leader>aE",
      function()
        require("config.workflows").run_command("arduino", "esp32_upload", "dev")
      end,
      desc = "Upload ESP32 DevKit",
      icon = "󰷝 ",
    },
    {
      "<leader>ac",
      function()
        require("config.workflows").run_command("arduino", "esp32_compile", "cam")
      end,
      desc = "Compile ESP32-CAM",
      icon = "󰄃 ",
    },
    {
      "<leader>aC",
      function()
        require("config.workflows").run_command("arduino", "esp32_upload", "cam")
      end,
      desc = "Upload ESP32-CAM",
      icon = "󰄃 ",
    },
    {
      "<leader>as",
      function()
        require("config.workflows").run_command("arduino", "esp32_compile", "s3")
      end,
      desc = "Compile ESP32-S3",
      icon = "󰷝 ",
    },
    {
      "<leader>aS",
      function()
        require("config.workflows").run_command("arduino", "esp32_upload", "s3")
      end,
      desc = "Upload ESP32-S3",
      icon = "󰷝 ",
    },
    -- Monitor helpers
    {
      "<leader>amE",
      function()
        require("config.workflows").run_command("arduino", "monitor_esp32")
      end,
      desc = "Monitor ESP32 (115200)",
      icon = "󰜺 ",
    },
    {
      "<leader>amu",
      function()
        require("config.workflows").run_command("arduino", "monitor_uno")
      end,
      desc = "Monitor Uno (9600)",
      icon = "󰜺 ",
    },
    -- Library management
    {
      "<leader>al",
      function()
        require("config.workflows").run_command("arduino", "arduino_lib_list")
      end,
      desc = "List Libraries",
      icon = "󰜺 ",
    },
    {
      "<leader>aL",
      function()
        local lib = vim.fn.input("Library to install: ")
        if lib ~= "" then
          require("config.workflows").run_command("arduino", "arduino_lib_install", lib)
        end
      end,
      desc = "Install Library",
      icon = "󰜺 ",
    },
    -- LSP / clangd setup
    {
      "<leader>aI",
      function()
        require("config.workflows").run_command("arduino", "arduino_compiledb")
      end,
      desc = "Generate compile_commands.json (LSP)",
      icon = "󰘦 ",
    },
  },
  go = {
    {
      "<leader>gb",
      function()
        require("config.workflows").run_command("go", "build")
      end,
      desc = "Build",
      icon = "󰟓 ",
    },
    {
      "<leader>gr",
      function()
        require("config.workflows").run_command("go", "run")
      end,
      desc = "Run",
      icon = "󰟓 ",
    },
    {
      "<leader>gt",
      function()
        require("config.workflows").run_command("go", "test")
      end,
      desc = "Test",
      icon = "󰟓 ",
    },
  },
  rust = {
    {
      "<leader>rb",
      function()
        require("config.workflows").run_command("rust", "build")
      end,
      desc = "Build",
      icon = "󱘗 ",
    },
    {
      "<leader>rr",
      function()
        require("config.workflows").run_command("rust", "run")
      end,
      desc = "Run",
      icon = "󱘗 ",
    },
    {
      "<leader>rt",
      function()
        require("config.workflows").run_command("rust", "test")
      end,
      desc = "Test",
      icon = "󱘗 ",
    },
    {
      "<leader>rc",
      function()
        require("config.workflows").run_command("rust", "check")
      end,
      desc = "Check",
      icon = "󱘗 ",
    },
    {
      "<leader>rl",
      function()
        require("config.workflows").run_command("rust", "clippy")
      end,
      desc = "Clippy",
      icon = "󱘗 ",
    },
  },
  cpp = {
    {
      "<leader>cm",
      function()
        require("config.workflows").run_command("cpp", "cmake_build")
      end,
      desc = "Build",
      icon = "󰙲 ",
    },
    {
      "<leader>cr",
      function()
        require("config.workflows").run_command("cpp", "run")
      end,
      desc = "Run",
      icon = "󰙲 ",
    },
    {
      "<leader>ct",
      function()
        require("config.workflows").run_command("cpp", "test")
      end,
      desc = "Test",
      icon = "󰙲 ",
    },
  },
  json = {
    {
      "<leader>jf",
      function()
        require("config.workflows").run_command("json", "fix")
      end,
      desc = "Format",
      icon = "󰘦 ",
    },
  },
  yaml = {
    {
      "<leader>yf",
      function()
        require("config.workflows").run_command("yaml", "fmt")
      end,
      desc = "Format",
      icon = "󰘦 ",
    },
  },
  haskell = {
    {
      "<leader>hb",
      function()
        require("config.workflows").run_command("haskell", "build")
      end,
      desc = "Build",
      icon = "󰧑 ",
    },
    {
      "<leader>hr",
      function()
        require("config.workflows").run_command("haskell", "run")
      end,
      desc = "Run",
      icon = "󰧑 ",
    },
    {
      "<leader>ht",
      function()
        require("config.workflows").run_command("haskell", "test")
      end,
      desc = "Test",
      icon = "󰧑 ",
    },
    {
      "<leader>hl",
      function()
        require("config.workflows").run_command("haskell", "lint")
      end,
      desc = "Lint",
      icon = "󰧑 ",
    },
    {
      "<leader>hf",
      function()
        require("config.workflows").run_command("haskell", "format")
      end,
      desc = "Format",
      icon = "󰧑 ",
    },
  },
  ocaml = {
    {
      "<leader>ob",
      function()
        require("config.workflows").run_command("ocaml", "build")
      end,
      desc = "Build",
      icon = "󰘧 ",
    },
    {
      "<leader>or",
      function()
        require("config.workflows").run_command("ocaml", "run")
      end,
      desc = "Run",
      icon = "󰘧 ",
    },
    {
      "<leader>ot",
      function()
        require("config.workflows").run_command("ocaml", "test")
      end,
      desc = "Test",
      icon = "󰘧 ",
    },
    {
      "<leader>of",
      function()
        require("config.workflows").run_command("ocaml", "format")
      end,
      desc = "Format",
      icon = "󰘧 ",
    },
  },
  elixir = {
    {
      "<leader>eb",
      function()
        require("config.workflows").run_command("elixir", "build")
      end,
      desc = "Build",
      icon = "󰭱 ",
    },
    {
      "<leader>er",
      function()
        require("config.workflows").run_command("elixir", "run")
      end,
      desc = "Run",
      icon = "󰭱 ",
    },
    {
      "<leader>et",
      function()
        require("config.workflows").run_command("elixir", "test")
      end,
      desc = "Test",
      icon = "󰭱 ",
    },
    {
      "<leader>ed",
      function()
        require("config.workflows").run_command("elixir", "deps_get")
      end,
      desc = "Deps Get",
      icon = "󰭱 ",
    },
    {
      "<leader>eu",
      function()
        require("config.workflows").run_command("elixir", "deps_update")
      end,
      desc = "Deps Update",
      icon = "󰭱 ",
    },
    {
      "<leader>ef",
      function()
        require("config.workflows").run_command("elixir", "format")
      end,
      desc = "Format",
      icon = "󰭱 ",
    },
    {
      "<leader>ec",
      function()
        require("config.workflows").run_command("elixir", "credo")
      end,
      desc = "Credo",
      icon = "󰭱 ",
    },
    {
      "<leader>ed",
      function()
        require("config.workflows").run_command("elixir", "dialyzer")
      end,
      desc = "Dialyzer",
      icon = "󰭱 ",
    },
    {
      "<leader>ei",
      function()
        require("config.workflows").run_command("elixir", "iex")
      end,
      desc = "IEx",
      icon = "󰭱 ",
    },
  },
  scala = {
    {
      "<leader>scb",
      function()
        require("config.workflows").run_command("scala", "build")
      end,
      desc = "Build",
      icon = "󰜊 ",
    },
    {
      "<leader>sct",
      function()
        require("config.workflows").run_command("scala", "test")
      end,
      desc = "Test",
      icon = "󰜊 ",
    },
    {
      "<leader>scr",
      function()
        require("config.workflows").run_command("scala", "run")
      end,
      desc = "Run",
      icon = "󰜊 ",
    },
    {
      "<leader>scf",
      function()
        require("config.workflows").run_command("scala", "fmt")
      end,
      desc = "Format",
      icon = "󰜊 ",
    },
    {
      "<leader>scx",
      function()
        require("config.workflows").run_command("scala", "scalafix")
      end,
      desc = "Scalafix",
      icon = "󰜊 ",
    },
  },
  kotlin = {
    {
      "<leader>kb",
      function()
        require("config.workflows").run_command("kotlin", "build")
      end,
      desc = "Build",
      icon = "󰬘 ",
    },
    {
      "<leader>kt",
      function()
        require("config.workflows").run_command("kotlin", "test")
      end,
      desc = "Test",
      icon = "󰬘 ",
    },
    {
      "<leader>kr",
      function()
        require("config.workflows").run_command("kotlin", "run")
      end,
      desc = "Run",
      icon = "󰬘 ",
    },
    {
      "<leader>kf",
      function()
        require("config.workflows").run_command("kotlin", "ktfmt")
      end,
      desc = "Format",
      icon = "󰬘 ",
    },
  },
  dart = {
    {
      "<leader>df",
      function()
        require("config.workflows").run_command("dart", "format")
      end,
      desc = "Format",
      icon = "󰙥 ",
    },
    {
      "<leader>da",
      function()
        require("config.workflows").run_command("dart", "analyze")
      end,
      desc = "Analyze",
      icon = "󰙥 ",
    },
    {
      "<leader>dt",
      function()
        require("config.workflows").run_command("dart", "test")
      end,
      desc = "Test",
      icon = "󰙥 ",
    },
    {
      "<leader>dp",
      function()
        require("config.workflows").run_command("dart", "pub_get")
      end,
      desc = "Pub Get",
      icon = "󰙥 ",
    },
    {
      "<leader>dF",
      function()
        require("config.workflows").run_command("dart", "flutter_build")
      end,
      desc = "Flutter Build",
      icon = "󰙥 ",
    },
    {
      "<leader>dR",
      function()
        require("config.workflows").run_command("dart", "flutter_run")
      end,
      desc = "Flutter Run",
      icon = "󰙥 ",
    },
  },
  typescript = {
    {
      "<leader>tc",
      function()
        require("config.workflows").run_command("typescript", "check")
      end,
      desc = "Type Check",
      icon = "󰛦 ",
    },
    {
      "<leader>tt",
      function()
        require("config.workflows").run_command("typescript", "test")
      end,
      desc = "Test",
      icon = "󰛦 ",
    },
    {
      "<leader>tl",
      function()
        require("config.workflows").run_command("typescript", "lint")
      end,
      desc = "Lint",
      icon = "󰛦 ",
    },
    {
      "<leader>tf",
      function()
        require("config.workflows").run_command("typescript", "format")
      end,
      desc = "Format",
      icon = "󰛦 ",
    },
    {
      "<leader>td",
      function()
        require("config.workflows").run_command("typescript", "dev")
      end,
      desc = "Dev",
      icon = "󰛦 ",
    },
  },
  vue = {
    {
      "<leader>vd",
      function()
        require("config.workflows").run_command("vue", "dev")
      end,
      desc = "Dev Server",
      icon = "󰡄 ",
    },
    {
      "<leader>vb",
      function()
        require("config.workflows").run_command("vue", "build")
      end,
      desc = "Build",
      icon = "󰡄 ",
    },
    {
      "<leader>vt",
      function()
        require("config.workflows").run_command("vue", "typecheck")
      end,
      desc = "Type Check",
      icon = "󰡄 ",
    },
    {
      "<leader>vl",
      function()
        require("config.workflows").run_command("vue", "lint")
      end,
      desc = "Lint",
      icon = "󰡄 ",
    },
    {
      "<leader>vf",
      function()
        require("config.workflows").run_command("vue", "format")
      end,
      desc = "Format",
      icon = "󰡄 ",
    },
  },
  svelte = {
    {
      "<leader>sv",
      function()
        require("config.workflows").run_command("svelte", "dev")
      end,
      desc = "Dev Server",
      icon = "󰔷 ",
    },
    {
      "<leader>sb",
      function()
        require("config.workflows").run_command("svelte", "build")
      end,
      desc = "Build",
      icon = "󰔷 ",
    },
    {
      "<leader>sc",
      function()
        require("config.workflows").run_command("svelte", "check")
      end,
      desc = "Svelte Check",
      icon = "󰔷 ",
    },
    {
      "<leader>sf",
      function()
        require("config.workflows").run_command("svelte", "format")
      end,
      desc = "Format",
      icon = "󰔷 ",
    },
  },
  astro = {
    {
      "<leader>ad",
      function()
        require("config.workflows").run_command("astro", "dev")
      end,
      desc = "Dev Server",
      icon = "󱓟 ",
    },
    {
      "<leader>ab",
      function()
        require("config.workflows").run_command("astro", "build")
      end,
      desc = "Build",
      icon = "󱓟 ",
    },
    {
      "<leader>ac",
      function()
        require("config.workflows").run_command("astro", "check")
      end,
      desc = "Check",
      icon = "󱓟 ",
    },
    {
      "<leader>af",
      function()
        require("config.workflows").run_command("astro", "format")
      end,
      desc = "Format",
      icon = "󱓟 ",
    },
  },
  solid = {
    {
      "<leader>sd",
      function()
        require("config.workflows").run_command("solid", "dev")
      end,
      desc = "Dev Server",
      icon = "󰘚 ",
    },
    {
      "<leader>sb",
      function()
        require("config.workflows").run_command("solid", "build")
      end,
      desc = "Build",
      icon = "󰘚 ",
    },
    {
      "<leader>sc",
      function()
        require("config.workflows").run_command("solid", "check")
      end,
      desc = "Check",
      icon = "󰘚 ",
    },
  },
  deno = {
    {
      "<leader>dr",
      function()
        require("config.workflows").run_command("deno", "run")
      end,
      desc = "Run",
      icon = " ",
    },
    {
      "<leader>dt",
      function()
        require("config.workflows").run_command("deno", "test")
      end,
      desc = "Test",
      icon = " ",
    },
    {
      "<leader>df",
      function()
        require("config.workflows").run_command("deno", "fmt")
      end,
      desc = "Format",
      icon = " ",
    },
    {
      "<leader>dl",
      function()
        require("config.workflows").run_command("deno", "lint")
      end,
      desc = "Lint",
      icon = " ",
    },
    {
      "<leader>dc",
      function()
        require("config.workflows").run_command("deno", "check")
      end,
      desc = "Check",
      icon = " ",
    },
  },
  bun = {
    {
      "<leader>br",
      function()
        require("config.workflows").run_command("bun", "run")
      end,
      desc = "Run",
      icon = "󰴂 ",
    },
    {
      "<leader>bt",
      function()
        require("config.workflows").run_command("bun", "test")
      end,
      desc = "Test",
      icon = "󰴂 ",
    },
    {
      "<leader>bb",
      function()
        require("config.workflows").run_command("bun", "build")
      end,
      desc = "Build",
      icon = "󰴂 ",
    },
    {
      "<leader>bi",
      function()
        require("config.workflows").run_command("bun", "install")
      end,
      desc = "Install",
      icon = "󰴂 ",
    },
  },
  swift = {
    {
      "<leader>swb",
      function()
        require("config.workflows").run_command("swift", "build")
      end,
      desc = "Build",
      icon = "󰀵 ",
    },
    {
      "<leader>swr",
      function()
        require("config.workflows").run_command("swift", "run")
      end,
      desc = "Run",
      icon = "󰀵 ",
    },
    {
      "<leader>swt",
      function()
        require("config.workflows").run_command("swift", "test")
      end,
      desc = "Test",
      icon = "󰀵 ",
    },
    {
      "<leader>swf",
      function()
        require("config.workflows").run_command("swift", "format")
      end,
      desc = "Format",
      icon = "󰀵 ",
    },
    {
      "<leader>swl",
      function()
        require("config.workflows").run_command("swift", "lint")
      end,
      desc = "Lint",
      icon = "󰀵 ",
    },
  },
  markdown = {
    { "<leader>om", "<cmd>MarkdownPreview<cr>", desc = "Preview", icon = "󰍔 " },
    { "<leader>ot", "<cmd>TableModeToggle<cr>", desc = "Table Mode", icon = "󰓫 " },
  },
}

-- Current active context keymaps
M.active_context = nil
M.context_group = vim.api.nvim_create_augroup("WhichKeyContext", { clear = true })

-- Update context based on filetype/project
function M.update_context()
  local ft = vim.bo.filetype
  local detected = require("config.workflows").detect_project()

  -- Determine primary context
  local context = ft
  if detected.csharp then
    context = "csharp"
  elseif detected.arduino then
    context = "arduino"
  elseif detected.go then
    context = "go"
  elseif detected.rust then
    context = "rust"
  elseif detected.cpp then
    context = "cpp"
  elseif detected.python then
    context = "python"
  elseif detected.node then
    context = "node"
  elseif detected.java then
    context = "java"
  elseif detected.haskell then
    context = "haskell"
  elseif detected.ocaml then
    context = "ocaml"
  elseif detected.elixir then
    context = "elixir"
  elseif detected.scala then
    context = "scala"
  elseif detected.kotlin then
    context = "kotlin"
  elseif detected.dart then
    context = "dart"
  elseif detected.typescript then
    context = "typescript"
  elseif detected.vue then
    context = "vue"
  elseif detected.svelte then
    context = "svelte"
  elseif detected.astro then
    context = "astro"
  elseif detected.solid then
    context = "solid"
  elseif detected.deno then
    context = "deno"
  elseif detected.bun then
    context = "bun"
  elseif detected.swift then
    context = "swift"
  elseif detected.deno then
    context = "deno"
  elseif detected.bun then
    context = "bun"
  elseif detected.swift then
    context = "swift"
  end

  if context ~= M.active_context then
    M.active_context = context
    M.refresh_whichkey()
  end
end

-- Refresh which-key with conditional specs
function M.refresh_whichkey()
  local wk = require("which-key")

  -- Remove old context keymaps
  if M.context_specs[M.active_context] then
    wk.add(M.context_specs[M.active_context], { mode = "n", prefix = "<leader>" })
  end
end

-- Setup autocmds for context switching
function M.setup_context_autocmds()
  vim.api.nvim_create_autocmd({ "FileType", "DirChanged", "BufEnter" }, {
    group = M.context_group,
    callback = function()
      vim.defer_fn(M.update_context, 50)
    end,
  })

  -- Show context in statusline
  _G.whichkey_context = function()
    return M.active_context and ("  " .. M.active_context .. " ") or ""
  end
end

function M.setup()
  local wk = require("which-key")

  wk.setup({
    preset = "modern",
    delay = 200,
    expand = 1,
    notify = false,
    icons = {
      breadcrumb = "›",
      separator = "▸",
      group = "+",
      mappings = true,
      rules = {},
      colors = true,
      keys = {
        Up = "▲",
        Down = "▼",
        Left = "◀",
        Right = "▶",
        C = "⌃",
        M = "⌥",
        S = "⇧",
        CR = "⏎",
        Esc = "⎋",
        Space = "␣",
        Tab = "⇥",
        BS = "⌫",
      },
    },
    win = {
      border = "rounded",
      padding = { 1, 2 },
      title = true,
      title_pos = "center",
      wo = { winblend = 0 },
    },
    layout = {
      width = { min = 20, max = 70 },
      height = { min = 4, max = 20 },
      spacing = 2,
      align = "center",
    },
    filter = function(mapping)
      return mapping.desc and mapping.desc ~= ""
    end,
  })

  -- Add base spec
  wk.add(M.base_spec)

  -- Add tasks keymaps for shell wrappers
  local tasks = require("config.tasks")
  tasks.setup_shell_wrapper_keymaps()

  -- Setup context system
  M.setup_context_autocmds()
  vim.defer_fn(M.update_context, 200)
end

return M
