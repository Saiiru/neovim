-- ~/.config/nvim/lua/plugins/lualine.lua
--
-- Evil Line — Tokyo Dark edition
-- Designed to pair with tmux (tabs at top, this bar at bottom).
--
-- Shared visual language with tmux.conf:
--   • Background #1a1b26 — same as tmux status bg (frames terminal content)
--   • Palette:  blue #7aa2f7  green #9ece6a  violet #bb9af7
--               cyan #7dcfff  yellow #e0af68  dim #565f89
--   • Icons:    Nerd Fonts throughout, same density as tmux
--
-- Bottom bar layout:
--   ▊ 󰋜 NOR  │ branch +1~2 │ file.rs 4K 42:10 78% ⚠2    ≡    󰒋 lsp │ 󱁐2 │ 󰌀 rust │ 󱂬 session ▊
--   └─ pill ─┘└────────────────── left ───────────────────────┘  └──────────── right ──────────┘
--
-- vim-tpipeline: this bar is mirrored into tmux status-right when focused.
--   tpipeline.lua should have: vim.g.tpipeline_clearstatus = 1

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    local lualine = require("lualine")

    -- ── Palette (Tokyo Dark — identical to tmux.conf) ─────────────────────
    local c = {
      bg1     = "#1a1b26",  -- bar background (matches tmux status bg)
      bg2     = "#16161e",  -- inactive window bg
      fg      = "#c0caf5",
      dim     = "#565f89",
      blue    = "#7aa2f7",  -- normal mode / session
      cyan    = "#7dcfff",  -- terminal / clock / study xp
      green   = "#9ece6a",  -- insert / git added
      yellow  = "#e0af68",  -- command / git modified
      orange  = "#ff9e64",
      red     = "#f7768e",  -- replace / error
      violet  = "#bb9af7",  -- visual / git branch
      teal    = "#73daca",
      white   = "#c0caf5",
    }

    -- ── Mode → accent (matches the ▊ pill color, mirrors image style) ─────
    local mode_colors = {
      n  = c.blue,    i  = c.green,
      v  = c.violet,  V  = c.violet,  ["\22"] = c.violet,
      c  = c.yellow,
      s  = c.orange,  S  = c.orange,  ["\19"] = c.orange,
      R  = c.red,     r  = c.red,
      t  = c.cyan,    -- matches tmux cyan (terminal context)
      ["!"] = c.red,
      ic = c.yellow,  no = c.blue,
      cv = c.red,     ce = c.red,
      rm = c.cyan,    ["r?"] = c.cyan,
    }

    local function accent()
      return mode_colors[vim.fn.mode()] or c.blue
    end

    -- ── Conditions ────────────────────────────────────────────────────────
    local cond = {
      not_empty = function() return vim.fn.empty(vim.fn.expand("%:t")) ~= 1 end,
      wide      = function() return vim.fn.winwidth(0) > 80  end,
      wider     = function() return vim.fn.winwidth(0) > 110 end,
      in_tmux   = function() return os.getenv("TMUX") ~= nil end,
      in_git    = function()
        local fp  = vim.fn.expand("%:p:h")
        local git = vim.fn.finddir(".git", fp .. ";")
        return git and #git > 0 and #git < #fp
      end,
    }

    -- ── LSP helper (nvim 0.10+ / 0.11+) ──────────────────────────────────
    local function lsp_clients(opts)
      return (vim.lsp.get_clients or vim.lsp.get_active_clients)(opts)
    end

    -- ── Tmux session name (cached — avoids repeated shell calls) ─────────
    local _tmux_session = nil
    local function tmux_session()
      if not cond.in_tmux() then return "" end
      if not _tmux_session then
        local h = io.popen("tmux display-message -p '#S' 2>/dev/null")
        if h then
          _tmux_session = (h:read("*a") or ""):gsub("%s+$", "")
          h:close()
        end
        _tmux_session = _tmux_session or ""
      end
      return _tmux_session
    end

    -- ── Evil-line config shell ─────────────────────────────────────────────
    local cfg = {
      options = {
        component_separators = "",
        section_separators   = "",
        globalstatus         = true,
        theme = {
          normal   = { c = { fg = c.fg,  bg = c.bg1 } },
          inactive = { c = { fg = c.dim, bg = c.bg2 } },
        },
        disabled_filetypes = {
          statusline = {
            "alpha", "dashboard", "starter",
            "NvimTree", "neo-tree", "oil",
            "Trouble", "trouble",
            "lazy", "mason",
            "help", "man", "qf",
          },
        },
      },
      sections = {
        lualine_a = {}, lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {}, lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {}, lualine_b = {},
        lualine_c = { { "filename", color = { fg = c.dim } } },
        lualine_x = { { "location", color = { fg = c.dim } } },
        lualine_y = {}, lualine_z = {},
      },
    }

    local L = cfg.sections.lualine_c
    local R = cfg.sections.lualine_x

    -- ══════════════════════════════════════════════════════════════════════
    -- LEFT
    -- ══════════════════════════════════════════════════════════════════════

    -- ▊ opening edge — accent color mirrors image's left colored block
    table.insert(L, {
      function() return "▊" end,
      color   = function() return { fg = accent(), bg = c.bg1 } end,
      padding = { left = 0, right = 0 },
    })

    -- Mode pill (accent bg, dark fg) + powerline arrow exit
    table.insert(L, {
      function()
        local icons = {
          n  = "󰋜 NOR",   i  = "󰏫 INS",
          v  = "󰆗 VIS",   V  = "󰆗 VLN",   ["\22"] = "󰆗 VBL",
          c  = " CMD",   R  = " REP",
          s  = "󰒅 SEL",   S  = "󰒅 SLN",   ["\19"] = "󰒅 SBL",
          t  = " TRM",   ["!"] = " SHL",
          ic = "󰏫 INS",  no = "󰋜 NOR",
        }
        vim.api.nvim_set_hl(0, "LualineMode", {
          fg = c.bg1, bg = accent(), bold = true,
        })
        return " " .. (icons[vim.fn.mode()] or vim.fn.mode():upper()) .. " "
      end,
      color   = "LualineMode",
      padding = 0,
    })

    -- Powerline arrow leaving the pill
    table.insert(L, {
      function() return "" end,
      color   = function() return { fg = accent(), bg = c.bg1 } end,
      padding = { left = 0, right = 1 },
    })

    -- Dim separator
    table.insert(L, {
      function() return "│" end,
      color = { fg = c.dim },
    })

    -- Git branch — violet, matches tmux left git color concept
    table.insert(L, {
      "branch",
      icon  = { "", color = { fg = c.violet } },
      color = { fg = c.violet, gui = "bold" },
      cond  = cond.in_git,
    })

    -- Git diff
    table.insert(L, {
      "diff",
      symbols    = { added = " ", modified = " ", removed = " " },
      diff_color = {
        added    = { fg = c.green  },
        modified = { fg = c.yellow },
        removed  = { fg = c.red   },
      },
      cond    = cond.in_git,
      padding = { left = 0, right = 1 },
    })

    -- Dim separator
    table.insert(L, {
      function() return "│" end,
      color = { fg = c.dim },
      cond  = cond.in_git,
    })

    -- Filename
    table.insert(L, {
      "filename",
      file_status    = true,
      newfile_status = true,
      path           = 1,
      shorting_target = 25,
      symbols = {
        modified = "  ",
        readonly = "  ",
        unnamed  = "󰡯 untitled",
        newfile  = " new",
      },
      cond  = cond.not_empty,
      color = { fg = c.white, gui = "bold" },
    })

    -- File size
    table.insert(L, {
      function()
        local file = vim.fn.expand("%:p")
        if file == "" then return "" end
        local size = vim.fn.getfsize(file)
        if size <= 0 then return "" end
        local units, i = { "B", "K", "M", "G" }, 1
        while size > 1024 and i < 4 do size = size / 1024; i = i + 1 end
        return string.format("%.0f%s", size, units[i])
      end,
      color = { fg = c.dim },
      cond  = cond.wide,
    })

    -- Location + progress
    table.insert(L, { "location", color = { fg = c.dim } })
    table.insert(L, { "progress", color = { fg = c.dim, gui = "bold" }, cond = cond.wide })

    -- Diagnostics
    table.insert(L, {
      "diagnostics",
      sources        = { "nvim_lsp", "nvim_diagnostic" },
      symbols        = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
      diagnostics_color = {
        error = { fg = c.red    },
        warn  = { fg = c.yellow },
        info  = { fg = c.cyan   },
        hint  = { fg = c.teal   },
      },
      always_visible = false,
    })

    -- Spacer
    table.insert(L, { function() return "%=" end })

    -- Macro recording
    table.insert(L, {
      function()
        local reg = vim.fn.reg_recording()
        return reg ~= "" and ("󰑋 @" .. reg) or ""
      end,
      color = { fg = c.orange, gui = "bold" },
    })

    -- Search count
    table.insert(L, {
      function()
        if vim.v.hlsearch == 0 then return "" end
        local ok, r = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 50 })
        if not ok or r.total == 0 then return "" end
        return string.format("󰍉 %d/%d", r.current, r.total)
      end,
      color = { fg = c.cyan },
    })

    -- ══════════════════════════════════════════════════════════════════════
    -- RIGHT
    -- ══════════════════════════════════════════════════════════════════════

    -- Active LSP
    table.insert(R, {
      function()
        local clients = lsp_clients({ bufnr = 0 })
        if #clients == 0 then return "" end
        local names = {}
        for _, cl in ipairs(clients) do
          if cl.name ~= "null-ls" and cl.name ~= "copilot" then
            table.insert(names, cl.name)
          end
        end
        return #names > 0 and ("󰒋 " .. table.concat(names, "+")) or ""
      end,
      color = { fg = c.dim, gui = "italic" },
      cond  = cond.wide,
    })

    -- Lazy.nvim pending updates
    table.insert(R, {
      function()
        local ok, lazy = pcall(require, "lazy.status")
        return (ok and lazy.has_updates()) and ("󰒲 " .. lazy.updates()) or ""
      end,
      color = { fg = c.orange },
    })

    -- Separator
    table.insert(R, { function() return "│" end, color = { fg = c.dim } })

    -- Indent style
    table.insert(R, {
      function()
        return (vim.bo.expandtab and "󱁐 " or "󰌒 ") ..
               (vim.bo.expandtab and vim.bo.shiftwidth or vim.bo.tabstop)
      end,
      color = { fg = c.dim },
      cond  = cond.wide,
    })

    -- Encoding (only when not utf-8)
    table.insert(R, {
      function()
        local enc = vim.opt.fileencoding:get()
        return (enc ~= "" and enc ~= "utf-8") and enc:upper() or ""
      end,
      color = { fg = c.yellow },
    })

    -- Filetype + icon (nvim-web-devicons: 200+ types, each with a color)
    -- Python  Rust 󰀘  Lua   Go   TS   Zig ⚡  Docker 󰡨  Shell  ...
    table.insert(R, {
      "filetype",
      colored   = true,
      icon_only = false,
      icon      = { align = "right" },
      color     = { fg = c.fg },
      padding   = { left = 1, right = 1 },
    })

    -- Spell
    table.insert(R, {
      function()
        return vim.wo.spell and ("󰓆 " .. vim.bo.spelllang) or ""
      end,
      color = { fg = c.cyan },
    })

    -- Separator
    table.insert(R, { function() return "│" end, color = { fg = c.dim } })

    -- Tmux session — 󱂬 session (blue) — bridges top and bottom bars visually
    -- Cached to avoid repeated shell calls on every statusline update.
    table.insert(R, {
      function()
        local s = tmux_session()
        return s ~= "" and ("󱂬 " .. s) or ""
      end,
      color = { fg = c.blue, gui = "bold" },
      cond  = cond.in_tmux,
    })

    -- ▊ closing edge
    table.insert(R, {
      function() return "▊" end,
      color   = function() return { fg = accent(), bg = c.bg1 } end,
      padding = { left = 1, right = 0 },
    })

    lualine.setup(cfg)
  end,
}
