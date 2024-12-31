return {
  "b0o/incline.nvim",
  enabled = true,
  event = "BufEnter",
  config = function()
    local function get_diagnostic_label(props)
      local icons = require("config.icons").diagnostics
        or {
          error = " ",
          warning = " ",
          hint = " ",
          info = " ",
        }
      local label = {}
      for severity, icon in pairs(icons) do
        local count = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
        if count > 0 then
          table.insert(label, { icon .. count .. " ", group = "DiagnosticSign" .. severity })
        end
      end
      return label
    end

    local function get_git_diff(props)
      local icons = { added = "", changed = "", removed = "" }
      local label = {}
      local success, signs = pcall(vim.api.nvim_buf_get_var, props.buf, "gitsigns_status_dict")
      if success and signs then
        for name, icon in pairs(icons) do
          if tonumber(signs[name]) and signs[name] > 0 then
            table.insert(label, { icon .. signs[name] .. " ", group = "Diff" .. name })
          end
        end
      end
      return label
    end

    require("incline").setup({
      hide = {
        cursorline = true,
        focused_win = false,
        only_win = false,
      },
      window = {
        margin = { horizontal = 1, vertical = 2 },
        placement = { horizontal = "right", vertical = "top" },
      },
      render = function(props)
        local buf_name = vim.api.nvim_buf_get_name(props.buf)
        if buf_name == "" then
          return " [No Name] "
        end
        local filename = vim.fn.fnamemodify(buf_name, ":t")
        local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename, nil, { default = true })
        local modified = vim.bo[props.buf].modified and "bold,italic" or "normal"

        local buffer = {
          { get_git_diff(props) },
          { get_diagnostic_label(props) },
          { { ft_icon, guifg = ft_color } },
          { { " " .. filename, gui = modified } },
        }
        return buffer
      end,
    })
  end,
}
