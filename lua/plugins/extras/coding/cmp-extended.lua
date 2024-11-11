local cmp = require("cmp")

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lua",
  },
  keys = {
    { "<leader>ciC", "<cmd>CmpStatus<CR>", desc = "Cmp Status" },
  },
  opts = function(_, opts)
    -- Key mappings for navigation and control in cmp
    opts.mapping = cmp.mapping.preset.insert({
      ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
      ["<C-CR>"] = function(fallback)
        cmp.abort()
        fallback()
      end,
    })

    -- Customize window appearance: transparent with greysish background and rounded borders
    opts.window = {
      completion = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }, -- Custom border characters
        winhighlight = "Normal:NormalFloat,FloatBorder:CmpBorder,CursorLine:Visual,Search:None",
        side_padding = 1,
        scrollbar = true, -- Scrollbar enabled to mimic VSCode behavior
        transparency = true, -- For Neovim/terminal transparency support
      },
      documentation = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        winhighlight = "Normal:NormalFloat,FloatBorder:CmpBorder,CursorLine:Visual,Search:None",
        scrollbar = true, -- Scrollbar enabled here as well
        transparency = true,
      },
    }

    -- Set the background to black outside the completion window
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e1e", fg = "#f8f8f2" }) -- Black outside the completion area
    vim.api.nvim_set_hl(0, "CmpBorder", { fg = "#ff79c6", bg = "NONE" }) -- Border color
    vim.api.nvim_set_hl(0, "CmpDocumentation", { bg = "#1e1e1e", fg = "#f8f8f2" }) -- Black outside documentation window
    vim.api.nvim_set_hl(0, "CmpScrollbar", { fg = "#ff79c6", bg = "NONE" }) -- Scrollbar color (neon pink)

    -- Performance optimization
    opts.performance = {
      debounce = 20,
      throttle = 50,
      fetching_timeout = 30,
      confirm_resolve_timeout = 30,
      async_budget = 2,
      max_view_entries = 80,
    }

    -- Source configuration for general usage
    opts.sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "buffer" },
      { name = "path" },
      { name = "nvim_lua" },
    })

    -- Cmdline-specific configuration
    cmp.setup.cmdline({ "/", "?", ":" }, {
      mapping = cmp.mapping.preset.cmdline({
        ["<C-j>"] = {
          c = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end,
        },
        ["<C-k>"] = {
          c = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end,
        },
      }),
      sources = {
        { name = "buffer" },
        { name = "path" },
        { name = "cmdline" },
        { name = "nvim_lua" },
      },
    })

    -- Additional configuration for JSON and Lua filetypes
    cmp.setup.filetype({ "json", "lua" }, {
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
        { name = "nvim_lua" },
      }, {
        { name = "path" },
      }),
    })
  end,
}
