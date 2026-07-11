local function pde_component()
  local ok, detect = pcall(require, "pde.detect")
  if not ok then return "PDE" end
  local info = detect.detect(0)
  if info.framework == "unknown" then
    return "PDE"
  end
  return info.type .. ":" .. info.framework
end

local function lsp_component()
  local names = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    table.insert(names, client.name)
  end
  if #names == 0 then return "LSP:-" end
  table.sort(names)
  return "LSP:" .. table.concat(names, ",")
end

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = {
          normal = {
            a = { fg = "#1a1b26", bg = "#7aa2f7", gui = "bold" },
            b = { fg = "#c0caf5", bg = "#292e42" },
            c = { fg = "#c0caf5", bg = "#1a1b26" },
          },
          insert = { a = { fg = "#1a1b26", bg = "#9ece6a", gui = "bold" } },
          visual = { a = { fg = "#1a1b26", bg = "#bb9af7", gui = "bold" } },
          replace = { a = { fg = "#1a1b26", bg = "#f7768e", gui = "bold" } },
          command = { a = { fg = "#1a1b26", bg = "#e0af68", gui = "bold" } },
          inactive = { a = { fg = "#565f89", bg = "#1a1b26" }, b = { fg = "#565f89", bg = "#1a1b26" }, c = { fg = "#565f89", bg = "#1a1b26" } },
        },
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
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
