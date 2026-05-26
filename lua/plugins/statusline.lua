-- Statusline.
-- Dense, angular, powerline-aware. Neovim should complement tmux, not compete with it.

local ok_icons, icons = pcall(require, "config.icons")
if not ok_icons then
  icons = {
    misc = {
      branch = "",
      error = "",
      warning = "",
      info = "󰋼",
      hint = "󰌶",
      file = "󰈙",
      modified = "●",
      readonly = "󰌾",
      position = "󰇚",
      encoding = "󰈙",
      lsp = "󰄲",
      session = "󰓪",
      time = "",
      zoom = "󰁌",
    },
    lsp_labels = {},
    filetype_labels = {},
  }
end

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
  return #names > 0 and table.concat(names, ",") or "No LSP"
end

local function mode_icon()
  local map = {
    n = "",
    i = "",
    v = "󰈈",
    V = "󰈈",
    ["\22"] = "󰈈",
    c = "",
    t = "",
    R = "󰛔",
    s = "󰒲",
  }

  return map[vim.fn.mode()] or ""
end

local function formatter_status()
  local ok, formatting = pcall(require, "config.formatting")
  if not ok or type(formatting.status) ~= "function" then
    return ""
  end

  return formatting.status()
end

local function buf_name_status()
  local name = vim.api.nvim_buf_get_name(0)
  if name == nil or name == "" then
    return "[No Name]"
  end

  return vim.fn.fnamemodify(name, ":~:.")
end

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

local function mode_component()
  return {
    mode_icon,
    color = function()
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
    end,
  }
end

local function diagnostics_component()
  return {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = {
      error = icons.misc.error .. " ",
      warn = icons.misc.warning .. " ",
      info = (icons.misc.info or "󰋼") .. " ",
      hint = icons.misc.hint .. " ",
    },
    colored = true,
    update_in_insert = false,
  }
end

local function branch_component()
  return {
    "branch",
    icon = icons.misc.branch .. " ",
    fmt = function(branch)
      return branch:sub(1, 24)
    end,
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
    fmt = function(name)
      return name ~= "" and name or buf_name_status()
    end,
  }
end

local function filetype_component()
  return {
    function()
      return filetype_label()
    end,
    icon = icons.misc.file .. " ",
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
  }
end

local function buffers_component()
  return {
    "buffers",
    mode = 2,
    use_mode_colors = true,
    symbols = {
      modified = " " .. icons.misc.modified,
      alternate_file = "",
      directory = "",
    },
    filetype_names = {
      NvimTree = " Files",
      TelescopePrompt = " Telescope",
      dashboard = " Dashboard",
      lazy = "󰒲 Lazy",
      mason = "󰸈 Mason",
      snacks_picker_input = " Picker",
      spectre_panel = " Spectre",
      trouble = " Trouble",
    },
  }
end

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function(_, opts)
      opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
        icons_enabled = true,
        theme = theme,
        globalstatus = true,
        always_divide_middle = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "starter", "lazy", "mason" },
          winbar = {},
        },
        refresh = {
          statusline = 500,
          tabline = 1000,
          winbar = 1000,
        },
      })

      opts.sections = {
        lualine_a = { mode_component() },
        lualine_b = { branch_component() },
        lualine_c = { filename_component() },
        lualine_x = {
          diagnostics_component(),
          { formatter_status, color = { fg = c.green, bg = c.panel, gui = "bold" } },
          lsp_component(),
          filetype_component(),
          encoding_component(),
        },
        lualine_y = {
          { "diff", symbols = { added = "+", modified = "~", removed = "-" } },
        },
        lualine_z = {
          { "progress" },
          { "location", icon = icons.misc.position .. " " },
        },
      }

      opts.tabline = {
        lualine_a = {},
        lualine_b = { buffers_component() },
        lualine_c = {},
        lualine_x = {
          { "branch", icon = icons.misc.branch .. " " },
          { "diff", symbols = { added = "+", modified = "~", removed = "-" } },
          { "searchcount" },
          { "selectioncount" },
        },
        lualine_y = {},
        lualine_z = {},
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
      })
    end,
  },
}
