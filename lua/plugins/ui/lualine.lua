local lsp = function()
  local buf_clients = vim.lsp.get_clients { bufnr = 0 }
  if #buf_clients == 0 then
    return ""
  end
  return " "
end

local formatter = function()
  local formatters = require("conform").list_formatters(0)
  if #formatters == 0 then
    return ""
  end
  return "󰌨 "
end

local linter = function()
  local linters = require("lint").linters_by_ft[vim.bo.filetype]
  if #linters == 0 then
    return ""
  end
  return "⚡"
end

return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    opts.options.component_separators = { left = "", right = "" } -- Sleek separator style
    opts.options.section_separators = { left = "", right = "" }

    opts.sections.lualine_a = {
      { "mode", icon = "", color = { fg = "#ff007c", bg = "#000000", gui = "bold" } }, -- Cyberpunk mode with pinkish color
    }
    opts.sections.lualine_c[4] = {
      LazyVim.lualine.pretty_path {
        filename_hl = "Bold",
        modified_hl = "Error", -- Red for modifications
        directory_hl = "Directory", -- Dimmed path for directories
      },
    }

    -- Add LSP, Formatter, and Linter indicators in a sleek, techy manner
    if vim.g.lualine_info_extras == true then
      table.insert(opts.sections.lualine_x, 2, lsp)
      table.insert(opts.sections.lualine_x, 2, formatter)
      table.insert(opts.sections.lualine_x, 2, linter)
    end

    opts.sections.lualine_y = { "progress" } -- Minimalistic progress bar
    opts.sections.lualine_z = {
      { "location", separator = "" },
      {
        function()
          return "⚙️" -- A gear icon to represent techy settings or customization
        end,
        padding = { left = 0, right = 1 },
        color = { fg = "#00ff00" }, -- Neon green
      },
    }

    opts.extensions = {
      "lazy",
      "man",
      "mason",
      "nvim-dap-ui",
      "overseer",
      "quickfix",
      "toggleterm",
      "trouble",
      "neo-tree",
      "symbols-outline",
    }
  end,
}
