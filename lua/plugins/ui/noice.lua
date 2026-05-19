-- lua/plugins/ui/noice.lua

-- function for simplifying the views options
local function getviews()
  local views = {}
  local all_views = {
    "notify",
    "split",
    "vsplit",
    "popup",
    "mini",
    "cmdline",
    "cmdline_popup",
    "cmdline_output",
    "messages",
    "confirm",
    "hover",
    "popupmenu",
  }
  for _, view in ipairs(all_views) do
    -- disable the scrollbar for all views
    views[view] = { scrollbar = false }
  end
  -- extra options
  views["split"].enter = true
  return views
end

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      opts = {
        -- Evita warning: "NotifyBackground has no background highlight"
        background_colour = "#0A0E14",
      },
    },
  },
  opts = function()
    local p = vim.g.noctis_palette or require("config.theme.palette").colors
    return {
      -- views options
      views = getviews(),
      cmdline = {
        -- Wilder assume a UI de autocomplete de :, / e ?.
        -- Noice continua cuidando de mensagens, notify e rotas.
        enabled = false,
        format = {
          cmdline = { icon = ":", title = " Command " },
          search_down = { icon = "/", title = " Search " },
          search_up = { icon = "?", title = " Search " },
        },
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
        signature = {
          enabled = false,
        },
        hover = {
          enabled = false,
        },
      },
      routes = {
        {
          filter = {
            any = {
              {
                event = { "notify", "msg_show" },
                find = "No information available",
              },
              {
                event = { "notify", "msg_show" },
                find = "minifiles is not supported",
              },
              {
                event = "msg_show",
                kind = "",
                find = "written",
              },
            },
          },
          opts = {
            skip = true,
          },
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
      notify = {
        enabled = true,
        view = "notify",
      },
      noctis_palette = p,
    }
  end,
  config = function(_, opts)
    local map = vim.keymap.set
    local p = opts.noctis_palette
    opts.noctis_palette = nil
    if p then
      vim.api.nvim_set_hl(0, "NotifyBackground", { bg = p.bg })
    end
    if vim.o.filetype == "lazy" then
      vim.cmd([[messages clear]])
    end
    require("noice").setup(opts)
    -- keymaps
    map("n", "<leader>nh", ":Noice history<cr>", { desc = "History", noremap = true, silent = true })
    map("n", "<leader>nl", ":Noice last<cr>", { desc = "Last Msg", noremap = true, silent = true })
    map("n", "<leader>na", ":Noice all<cr>", { desc = "All Msg", noremap = true, silent = true })
    map("n", "<leader>nd", ":Noice dismiss<cr>", { desc = "Dismiss", noremap = true, silent = true })
    map("n", "<leader>np", ":Noice pick<cr>", { desc = "Pick", noremap = true, silent = true })
  end,
}
