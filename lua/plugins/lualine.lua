-- Statusline: JetBrains-style, legível, funcional
-- Separado do tmux — cada um faz sua parte

local ok_icons, icons = pcall(require, "config.icons")
if not ok_icons then
  icons = {
    misc = {
      branch = "󰘖",
      error = "󰅚",
      warning = "󰀪",
      info = "󰋽",
      hint = "󰌶",
      file = "󰈙",
      modified = "●",
      readonly = "󰌾",
      position = "󰇚",
      encoding = "󰈙",
      lsp = "󰒋",
      session = "󰓪",
      time = "",
      zoom = "󰁌",
      neovim = "",
    },
    lsp_labels = {
      ["lua-language-server"] = "lua",
      ["basedpyright-langserver"] = "py",
      ["typescript-language-server"] = "ts",
      ["gopls"] = "go",
      ["rust-analyzer"] = "rs",
      ["ts_ls"] = "ts",
      ["vtsls"] = "ts",
      ["ruff"] = "ruff",
    },
    filetype_labels = {
      lua = "LUA",
      python = "PY",
      typescript = "TS",
      typescriptreact = "TSX",
      javascript = "JS",
      javascriptreact = "JSX",
      go = "GO",
      rust = "RS",
      c = "C",
      cpp = "CPP",
      json = "JSON",
      yaml = "YML",
      markdown = "MD",
      dockerfile = "DKR",
      toml = "TOML",
      html = "HTML",
      css = "CSS",
      scss = "SCSS",
      sh = "SH",
      zsh = "ZSH",
      fish = "FISH",
      sql = "SQL",
      make = "MK",
      vim = "VIM",
      query = "QUERY",
      text = "TXT",
    },
  }
end

-- Paleta DedSec/Eviline
local c = {
  bg = "#0a0e14",
  panel = "#131a24",
  surface = "#1b2433",
  edge = "#2d3f76",
  fg = "#d7e2f0",
  muted = "#7f8cab",
  red = "#ff5d73",
  green = "#7ee787",
  yellow = "#ffd76e",
  blue = "#82aaff",
  magenta = "#c792ea",
  cyan = "#86e1fc",
  orange = "#ff9e64",
  magenta2 = "#ff2bd6",
}

local function filetype_label()
  local ft = vim.bo.filetype
  if ft == nil or ft == "" then
    return "TEXT"
  end
  return icons.filetype_labels[ft] or ft:upper()
end

local function current_lsp()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if clients == nil or vim.tbl_isempty(clients) then
    return "No LSP"
  end
  local names, seen = {}, {}
  for _, client in ipairs(clients) do
    if not seen[client.name] then
      seen[client.name] = true
      table.insert(names, icons.lsp_labels[client.name] or client.name)
    end
  end
  table.sort(names)
  return #names > 0 and table.concat(names, ", ") or "No LSP"
end

local function mode_icon()
  local map = {
    n = "NORMAL",
    i = "INSERT",
    v = "VISUAL",
    V = "V-LINE",
    ["\22"] = "V-BLOCK",
    c = "COMMAND",
    t = "TERMINAL",
    R = "REPLACE",
    s = "SELECT",
  }
  return map[vim.fn.mode()] or "NORMAL"
end

local function mode_hl()
  local mode = vim.fn.mode()
  local color_map = {
    n = c.blue,
    i = c.green,
    v = c.magenta,
    V = c.magenta,
    ["\22"] = c.magenta,
    c = c.yellow,
    t = c.red,
    R = c.red,
    s = c.cyan,
  }
  return { fg = c.bg, bg = color_map[mode] or c.blue, gui = "bold" }
end

local function filetype_component()
  return {
    function()
      return filetype_label()
    end,
    icon = icons.misc.file .. " ",
    color = { fg = c.cyan, bg = c.panel, gui = "bold" },
  }
end

local function lsp_component()
  return {
    current_lsp,
    icon = icons.misc.lsp .. " ",
    color = { fg = c.fg, bg = c.panel, gui = "bold" },
  }
end

local function encoding_component()
  return {
    "o:encoding",
    fmt = string.upper,
    icon = icons.misc.encoding .. " ",
    color = { fg = c.muted, bg = c.panel },
  }
end

local function formatter_status()
  local ok, formatting = pcall(require, "config.formatting")
  if not ok or type(formatting.status) ~= "function" then
    return ""
  end
  return formatting.status()
end

local function branch_component()
  return {
    "branch",
    icon = icons.misc.branch .. " ",
    fmt = function(branch)
      return branch:sub(1, 28)
    end,
    color = { fg = c.magenta, bg = c.panel, gui = "bold" },
  }
end

local function filename_component()
  return {
    "filename",
    path = 1,
    symbols = {
      modified = " " .. icons.misc.modified,
      readonly = " " .. icons.misc.readonly,
      unnamed = "[No Name]",
      newfile = "[New]",
    },
    color = { fg = c.fg, bg = c.surface },
  }
end

local function diagnostics_component()
  return {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = {
      error = icons.misc.error .. " ",
      warn = icons.misc.warning .. " ",
      info = icons.misc.info .. " ",
      hint = icons.misc.hint .. " ",
    },
    colored = true,
    update_in_insert = false,
    color = { bg = c.surface },
  }
end

local function diff_component()
  return {
    "diff",
    symbols = { added = "+", modified = "~", removed = "-" },
    colored = true,
    color = { bg = c.surface },
  }
end

local function position_component()
  return {
    "location",
    icon = icons.misc.position .. " ",
    color = { fg = c.muted, bg = c.panel },
  }
end

local function progress_component()
  return {
    "progress",
    color = { fg = c.fg, bg = c.panel, gui = "bold" },
  }
end

local function neovim_component()
  return {
    function()
      return " " .. icons.misc.neovim .. " "
    end,
    color = { fg = c.bg, bg = c.cyan, gui = "bold" },
    padding = 0,
  }
end

-- Tema completo por modo
local theme = {
  normal = {
    a = { fg = c.bg, bg = c.blue, gui = "bold" },
    b = { fg = c.fg, bg = c.panel },
    c = { fg = c.fg, bg = c.surface },
    x = { fg = c.fg, bg = c.panel },
    y = { fg = c.fg, bg = c.surface },
    z = { fg = c.bg, bg = c.cyan, gui = "bold" },
  },
  insert = {
    a = { fg = c.bg, bg = c.green, gui = "bold" },
    b = { fg = c.fg, bg = c.panel },
    c = { fg = c.fg, bg = c.surface },
    x = { fg = c.fg, bg = c.panel },
    y = { fg = c.fg, bg = c.surface },
    z = { fg = c.bg, bg = c.cyan, gui = "bold" },
  },
  visual = {
    a = { fg = c.bg, bg = c.magenta, gui = "bold" },
    b = { fg = c.fg, bg = c.panel },
    c = { fg = c.fg, bg = c.surface },
    x = { fg = c.fg, bg = c.panel },
    y = { fg = c.fg, bg = c.surface },
    z = { fg = c.bg, bg = c.cyan, gui = "bold" },
  },
  replace = {
    a = { fg = c.bg, bg = c.red, gui = "bold" },
    b = { fg = c.fg, bg = c.panel },
    c = { fg = c.fg, bg = c.surface },
    x = { fg = c.fg, bg = c.panel },
    y = { fg = c.fg, bg = c.surface },
    z = { fg = c.bg, bg = c.cyan, gui = "bold" },
  },
  command = {
    a = { fg = c.bg, bg = c.yellow, gui = "bold" },
    b = { fg = c.fg, bg = c.panel },
    c = { fg = c.fg, bg = c.surface },
    x = { fg = c.fg, bg = c.panel },
    y = { fg = c.fg, bg = c.surface },
    z = { fg = c.bg, bg = c.cyan, gui = "bold" },
  },
  inactive = {
    a = { fg = c.muted, bg = c.bg },
    b = { fg = c.muted, bg = c.bg },
    c = { fg = c.muted, bg = c.bg },
    x = { fg = c.muted, bg = c.bg },
    y = { fg = c.muted, bg = c.bg },
    z = { fg = c.muted, bg = c.bg },
  },
}

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function(_, opts)
    opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
      icons_enabled = true,
      theme = theme,
      globalstatus = true,
      always_divide_middle = true,
      component_separators = { left = "│", right = "│" },
      section_separators = { left = "█", right = "█" },
      disabled_filetypes = {
        statusline = { "dashboard", "alpha", "starter", "lazy", "mason", "snacks_dashboard" },
        winbar = {},
      },
      refresh = {
        statusline = 500,
        tabline = 1000,
        winbar = 1000,
      },
    })

    opts.sections = {
      lualine_a = { neovim_component(), { mode_icon, color = mode_hl, padding = { left = 1, right = 1 } } },
      lualine_b = { branch_component() },
      lualine_c = { filename_component(), diagnostics_component() },
      lualine_x = {
        diff_component(),
        {
          formatter_status,
          color = { fg = c.green, bg = c.panel, gui = "bold" },
          cond = function()
            return formatter_status() ~= ""
          end,
        },
        lsp_component(),
        filetype_component(),
        encoding_component(),
      },
      lualine_y = { position_component() },
      lualine_z = { progress_component() },
    }

    opts.inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { { "filename", path = 1, color = { fg = c.muted, bg = c.bg } } },
      lualine_x = { { "location", color = { fg = c.muted, bg = c.bg } } },
      lualine_y = {},
      lualine_z = {},
    }

    opts.extensions = vim.list_extend(opts.extensions or {}, {
      "lazy",
      "mason",
      "quickfix",
      "man",
      "oil",
      "trouble",
      "fzf",
    })
  end,
}
