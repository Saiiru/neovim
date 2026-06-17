-- DedSec Eviline statusline for lualine.
-- Source model: shadmansaleh Eviline + selected Nvpunk widgets/icons.

local M = {}

local colors = {
  bg = "#111111",
  fg = "#d7e2f0",
  muted = "#7f8cab",
  dim = "#2a3342",
  yellow = "#ffb800",
  cyan = "#00e5ff",
  green = "#00ff66",
  orange = "#ff8800",
  violet = "#ff5599",
  magenta = "#ff0055",
  blue = "#55ffff",
  red = "#ff0055",
}

local icons = {
  nvim = "VEGA",
  file = "󰈙",
  lock = "",
  modified = "󰏫",
  lsp = "󰒋",
  git = "",
  branch = "",
  add = " ",
  change = " ",
  remove = " ",
  error = "󰅙 ",
  warn = " ",
  info = "󰋼 ",
  hint = "󰌵 ",
  unix = "󰌽",
  clock = "",
  -- Mode indicators (DedSec eye)
  mode_normal = "👁 [SYSTEM_MONITOR]",
  mode_insert = "👁 [INSERTING_CODE]",
  mode_visual = "👁 [BREACHING_DATA]",
  mode_replace = "👁 [OVERWRITING]",
  mode_command = "👁 [EXECUTING]",
  mode_terminal = "👁 [SHELL]",
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand("%:p:h")
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local function file_size()
  local file = vim.fn.expand("%:p")
  if file == "" then
    return ""
  end
  local size = vim.fn.getfsize(file)
  if size <= 0 then
    return ""
  end
  local suffixes = { "b", "k", "m", "g" }
  local i = 1
  while size > 1024 and i < #suffixes do
    size = size / 1024
    i = i + 1
  end
  return string.format("%.1f%s", size, suffixes[i])
end

local function active_lsp()
  local clients = vim.lsp.get_clients and vim.lsp.get_clients({ bufnr = 0 })
    or vim.lsp.get_active_clients({ bufnr = 0 })
  if not clients or vim.tbl_isempty(clients) then
    return "no-lsp"
  end
  local names = {}
  local short = {
    ["typescript-language-server"] = "ts",
    ["basedpyright-langserver"] = "py",
    ["lua-language-server"] = "lua",
    ["rust-analyzer"] = "rs",
    ["csharp-ls"] = "cs",
  }
  for _, client in ipairs(clients) do
    table.insert(names, short[client.name] or client.name)
  end
  return table.concat(names, ",")
end

local function stl_hl(group)
  return "%#" .. group .. "#"
end

function M.tpipeline_line()
  local file = vim.fn.expand("%:t")
  if file == "" then
    file = "[no file]"
  end
  local modified = vim.bo.modified and " 󰏫" or ""
  local readonly = vim.bo.readonly and " " or ""
  local lsp = active_lsp()
  local branch = vim.b.gitsigns_head or ""
  if branch ~= "" then
    branch = "  " .. branch
  end
  local mode_indicator = M.mode_icon()
  -- tpipeline splits at %=, left goes to status-left, right to status-right
  -- Put mode indicator in left bridge (before first %=) so tmux left shows it
  return table.concat({
    stl_hl("LualineEvilineCyan"),
    "▊ ",
    stl_hl("LualineEvilineMode"),
    icons.nvim,
    " ",
    mode_indicator,
    " ",
    stl_hl("LualineEvilineFile"),
    file,
    modified,
    readonly,
    stl_hl("LualineEvilineMuted"),
    branch,
    " %l:%c %p%%",
    "%=",
    stl_hl("LualineEvilineLsp"),
    icons.lsp,
    " ",
    lsp,
    " ",
    stl_hl("LualineEvilineGreen"),
    vim.bo.fileformat:upper(),
    " ",
    stl_hl("LualineEvilineCyan"),
    "▊",
  })
end

local function mode_icon()
  local mode = vim.fn.mode()
  local mode_config = {
    n = { icon = icons.mode_normal, color = colors.green },
    i = { icon = icons.mode_insert, color = colors.magenta },
    v = { icon = icons.mode_visual, color = colors.red },
    V = { icon = icons.mode_visual, color = colors.red },
    ["\22"] = { icon = icons.mode_visual, color = colors.red },
    c = { icon = icons.mode_command, color = colors.yellow },
    s = { icon = icons.mode_visual, color = colors.orange },
    S = { icon = icons.mode_visual, color = colors.orange },
    R = { icon = icons.mode_replace, color = colors.violet },
    r = { icon = icons.mode_replace, color = colors.cyan },
    ["!"] = { icon = icons.mode_command, color = colors.red },
    t = { icon = icons.mode_terminal, color = colors.green },
  }
  local cfg = mode_config[mode] or { icon = icons.mode_normal, color = colors.cyan }
  vim.api.nvim_set_hl(0, "LualineEvilineMode", { fg = cfg.color, bg = colors.bg, bold = true })
  return cfg.icon
end

function M.mode_icon()
  return mode_icon()
end

function M.setup()
  _G.vega_tpipeline_statusline = function()
    return M.tpipeline_line()
  end

  vim.api.nvim_set_hl(0, "LualineEvilineMode", { fg = colors.red, bg = colors.bg, bold = true })
  vim.api.nvim_set_hl(0, "LualineEvilineCyan", { fg = colors.cyan, bg = colors.bg, bold = true })
  vim.api.nvim_set_hl(0, "LualineEvilineFile", { fg = colors.violet, bg = colors.bg, bold = true })
  vim.api.nvim_set_hl(0, "LualineEvilineMuted", { fg = colors.muted, bg = colors.bg })
  vim.api.nvim_set_hl(0, "LualineEvilineLsp", { fg = colors.fg, bg = colors.bg, bold = true })
  vim.api.nvim_set_hl(0, "LualineEvilineGreen", { fg = colors.green, bg = colors.bg, bold = true })

  local ok, lualine = pcall(require, "lualine")
  if not ok then
    return
  end

  local config = {
    options = {
      component_separators = "",
      section_separators = "",
      globalstatus = true,
      theme = {
        normal = { c = { fg = colors.fg, bg = colors.bg } },
        inactive = { c = { fg = colors.muted, bg = colors.bg } },
      },
    },
    sections = { lualine_a = {}, lualine_b = {}, lualine_c = {}, lualine_x = {}, lualine_y = {}, lualine_z = {} },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    winbar = {},
    inactive_winbar = {},
    extensions = { "lazy", "mason", "trouble", "quickfix" },
  }

  local function left(component)
    table.insert(config.sections.lualine_c, component)
  end
  local function right(component)
    table.insert(config.sections.lualine_x, component)
  end

  left({
    function()
      return "▊"
    end,
    color = { fg = colors.cyan, bg = colors.bg },
    padding = { left = 0, right = 1 },
  })
  left({ mode_icon, color = "LualineEvilineMode", padding = { left = 0, right = 1 } })
  left({ file_size, cond = conditions.buffer_not_empty, color = { fg = colors.muted, bg = colors.bg } })
  left({
    "filename",
    cond = conditions.buffer_not_empty,
    color = { fg = colors.violet, bg = colors.bg, gui = "bold" },
    symbols = {
      modified = " " .. icons.modified,
      readonly = " " .. icons.lock,
      unnamed = "[no file]",
      newfile = " 󰎔",
    },
  })
  left({ "location", color = { fg = colors.cyan, bg = colors.bg } })
  left({ "progress", color = { fg = colors.fg, bg = colors.bg, gui = "bold" } })
  left({
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = { error = icons.error, warn = icons.warn, info = icons.info, hint = icons.hint },
    color_error = colors.red,
    color_warn = colors.yellow,
    color_info = colors.cyan,
    color_hint = colors.green,
  })
  left({
    function()
      return "%="
    end,
  })
  left({ active_lsp, icon = icons.lsp .. " LSP", color = { fg = colors.fg, bg = colors.bg, gui = "bold" } })

  right({
    "o:encoding",
    fmt = string.upper,
    cond = conditions.hide_in_width,
    color = { fg = colors.green, bg = colors.bg, gui = "bold" },
  })
  right({
    "fileformat",
    fmt = string.upper,
    icons_enabled = false,
    color = { fg = colors.green, bg = colors.bg, gui = "bold" },
  })
  right({
    "branch",
    icon = icons.branch,
    cond = conditions.check_git_workspace,
    color = { fg = colors.violet, bg = colors.bg, gui = "bold" },
  })
  right({
    "diff",
    symbols = { added = icons.add, modified = icons.change, removed = icons.remove },
    color_added = colors.green,
    color_modified = colors.orange,
    color_removed = colors.red,
    cond = conditions.hide_in_width,
  })
  right({
    function()
      return "▊"
    end,
    color = { fg = colors.cyan, bg = colors.bg },
    padding = { left = 1, right = 0 },
  })

  lualine.setup(config)
end

return M
