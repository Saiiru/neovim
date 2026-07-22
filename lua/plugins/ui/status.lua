local function pde_component()
  local ok, detect = pcall(require, "pde.detect")
  if not ok then return "PDE" end
  local info = detect.detect(0)
  if info.framework == "unknown" then return "PDE" end
  return info.type .. ":" .. info.framework
end

local function lsp_component()
  local names = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    table.insert(names, client.name)
  end
  table.sort(names)
  return #names > 0 and ("LSP:" .. table.concat(names, ",")) or "LSP:-"
end

local function esc(value)
  value = tostring(value or "")
  value = value:gsub("%%", "%%%%")
  return value
end

local mode_names = {
  n = "NORMAL",
  no = "OP-PENDING",
  nov = "OP-PENDING",
  noV = "OP-PENDING",
  ["no\22"] = "OP-PENDING",
  niI = "NORMAL",
  niR = "NORMAL",
  niV = "NORMAL",
  nt = "NORMAL",
  v = "VISUAL",
  vs = "VISUAL",
  V = "V-LINE",
  Vs = "V-LINE",
  ["\22"] = "V-BLOCK",
  ["\22s"] = "V-BLOCK",
  s = "SELECT",
  S = "S-LINE",
  ["\19"] = "S-BLOCK",
  i = "INSERT",
  ic = "INSERT",
  ix = "INSERT",
  R = "REPLACE",
  Rc = "REPLACE",
  Rx = "REPLACE",
  Rv = "V-REPLACE",
  Rvc = "V-REPLACE",
  Rvx = "V-REPLACE",
  c = "COMMAND",
  cv = "EX",
  ce = "EX",
  r = "PROMPT",
  rm = "MORE",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  t = "TERMINAL",
}

local function diagnostics_summary(bufnr)
  local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }
  local severity = vim.diagnostic.severity
  for _, diagnostic in ipairs(vim.diagnostic.get(bufnr)) do
    if diagnostic.severity == severity.ERROR then counts.ERROR = counts.ERROR + 1 end
    if diagnostic.severity == severity.WARN then counts.WARN = counts.WARN + 1 end
    if diagnostic.severity == severity.INFO then counts.INFO = counts.INFO + 1 end
    if diagnostic.severity == severity.HINT then counts.HINT = counts.HINT + 1 end
  end
  local parts = {}
  if counts.ERROR > 0 then table.insert(parts, "E:" .. counts.ERROR) end
  if counts.WARN > 0 then table.insert(parts, "W:" .. counts.WARN) end
  if counts.INFO > 0 then table.insert(parts, "I:" .. counts.INFO) end
  if counts.HINT > 0 then table.insert(parts, "H:" .. counts.HINT) end
  return #parts > 0 and table.concat(parts, " ") or "diag:ok"
end

local function define_tpipeline_highlights()
  local groups = {
    VegaTpMode = { fg = "#050508", bg = "#37f8ff", bold = true },
    VegaTpModeInsert = { fg = "#050508", bg = "#8cff98", bold = true },
    VegaTpModeVisual = { fg = "#050508", bg = "#9b5cff", bold = true },
    VegaTpModeCommand = { fg = "#050508", bg = "#ffd166", bold = true },
    VegaTpFile = { fg = "#e6e6f0", bg = "#050508" },
    VegaTpSignal = { fg = "#37f8ff", bg = "#050508" },
    VegaTpWarn = { fg = "#ffd166", bg = "#050508" },
    VegaTpError = { fg = "#ff5c7a", bg = "#050508", bold = true },
    VegaTpDim = { fg = "#6f7488", bg = "#050508" },
    VegaTpPde = { fg = "#8cff98", bg = "#050508" },
    VegaTpLsp = { fg = "#7aa2ff", bg = "#050508" },
    VegaTpRight = { fg = "#ffd166", bg = "#050508" },
  }
  for name, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, name, spec)
  end
end

define_tpipeline_highlights()

_G.vega_tpipeline_statusline = function()
  define_tpipeline_highlights()
  local bufnr = vim.api.nvim_get_current_buf()
  local mode = mode_names[vim.fn.mode(1)] or vim.fn.mode(1):upper()
  local mode_group = "VegaTpMode"
  if mode == "INSERT" then mode_group = "VegaTpModeInsert" end
  if mode:find("VISUAL") or mode:find("V%-") then mode_group = "VegaTpModeVisual" end
  if mode == "COMMAND" then mode_group = "VegaTpModeCommand" end

  local file = vim.fn.expand("%:~:.")
  if file == "" then file = "[No Name]" end
  local modified = vim.bo.modified and " [+]" or ""
  local readonly = (vim.bo.readonly or not vim.bo.modifiable) and " [ro]" or ""
  local filetype = vim.bo.filetype ~= "" and vim.bo.filetype or "noft"
  local pde = pde_component()
  local lsp = lsp_component()
  local diagnostics = diagnostics_summary(bufnr)
  local diag_group = diagnostics:find("E:") and "VegaTpError" or (diagnostics:find("W:") and "VegaTpWarn" or "VegaTpSignal")

  return table.concat({
    "%#" .. mode_group .. "# ", esc(mode), " ",
    "%#VegaTpDim#▊ ",
    "%#VegaTpFile#", esc(file), esc(modified), esc(readonly), " ",
    "%#VegaTpDim#│ ",
    "%#VegaTpPde#", esc(pde), " ",
    "%#VegaTpDim#│ ",
    "%#VegaTpLsp#", esc(lsp),
    "%=",
    "%#" .. diag_group .. "#", esc(diagnostics), " ",
    "%#VegaTpDim#│ ",
    "%#VegaTpRight#", esc(filetype), " %l:%c %p%% ",
  })
end

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    cond = function()
      return vim.env.TMUX == nil or vim.env.TMUX == ""
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        globalstatus = true,
        theme = "tokyonight",
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = { "dashboard", "snacks_dashboard" },
          winbar = { "dashboard", "snacks_dashboard", "help", "quickfix" },
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { pde_component, lsp_component, "diagnostics", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
    },
  },
  {
    "vimpostor/vim-tpipeline",
    lazy = false,
    cond = function()
      return vim.env.TMUX ~= nil and vim.env.TMUX ~= ""
    end,
    init = function()
      vim.g.tpipeline_autoembed = 0
      vim.g.tpipeline_statusline = "%!v:lua.vega_tpipeline_statusline()"
      vim.g.tpipeline_clearstl = 1
      vim.g.tpipeline_fillcentre = 1
      vim.g.tpipeline_preservebg = 0
      vim.g.tpipeline_cursormoved = 0
      vim.g.tpipeline_focuslost = 1
    end,
    config = function()
      if vim.env.TMUX ~= nil and vim.env.TMUX ~= "" then
        vim.opt.laststatus = 0
        vim.opt.showmode = false
      end

      vim.api.nvim_create_autocmd("VimLeavePre", {
        group = vim.api.nvim_create_augroup("vega-tpipeline-cleanup", { clear = true }),
        callback = function()
          if vim.env.TMUX == nil or vim.env.TMUX == "" or vim.fn.executable("tmux") ~= 1 then return end
          vim.fn.system("tmux list-panes -a -F '#{pane_id}' | xargs -r -I {} tmux set -p -t {} -u status-left 2>/dev/null")
          vim.fn.system("tmux list-panes -a -F '#{pane_id}' | xargs -r -I {} tmux set -p -t {} -u status-right 2>/dev/null")
        end,
      })
    end,
  },
}
