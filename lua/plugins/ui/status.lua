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

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
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
}
