local M = {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    -- Snippet Engine and default snippets
    {
      "L3MON4D3/LuaSnip",
      build = (function()
        if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then
          return
        end
        return "make install_jsregexp"
      end)(),
      dependencies = {
        {
          "rafamadriz/friendly-snippets",
          config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
          end,
        },
      },
    },
    "saadparwaiz1/cmp_luasnip",

    -- LSP and completion sources
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-emoji",

    -- AI and advanced completions
    {
      "tzachar/cmp-tabnine",
      build = "./install.sh",
      config = function()
        require("cmp_tabnine.config"):setup {
          max_lines = 1000,
          max_num_results = 3,
          sort = true,
        }
      end,
    },
    {
      "zbirenbaum/copilot-cmp",
      config = function()
        require("copilot_cmp").setup()
      end,
    },

    -- Auto-pairing integration
    {
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup {}
        local cmp_autopairs = require "nvim-autopairs.completion.cmp"
        require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end,
    },
  },
}

function M.config()
  local cmp = require "cmp"
  local luasnip = require "luasnip"
  local icons = require "icons" -- Ensure this points to your icons setup

  require("luasnip.loaders.from_vscode").lazy_load()
  luasnip.config.setup {}

  -- Helper function to check for backspace
  local function check_backspace()
    local col = vim.fn.col "." - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
  end

  -- Custom comparators for sorting
  local function prefer_snippets(entry1, entry2)
    if entry1:get_kind() == cmp.lsp.CompletionItemKind.Snippet then
      return true
    elseif entry2:get_kind() == cmp.lsp.CompletionItemKind.Snippet then
      return false
    end
  end

  local function prefer_exact_matches(entry1, entry2)
    return cmp.config.compare.exact(entry1, entry2)
  end

  -- nvim-cmp setup
  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert {
      ["<C-j>"] = cmp.mapping.select_next_item(), -- Next suggestion
      ["<C-k>"] = cmp.mapping.select_prev_item(), -- Previous suggestion
      ["<C-b>"] = cmp.mapping.scroll_docs(-4), -- Scroll docs up
      ["<C-f>"] = cmp.mapping.scroll_docs(4), -- Scroll docs down
      ["<C-Space>"] = cmp.mapping.complete(), -- Show completions
      ["<C-e>"] = cmp.mapping.abort(), -- Close completion menu
      ["<CR>"] = cmp.mapping.confirm { select = true }, -- Confirm selection
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif check_backspace() then
          fallback()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    },
    formatting = {
      format = function(entry, vim_item)
        vim_item.kind = icons.kind[vim_item.kind] or vim_item.kind
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          luasnip = "[Snip]",
          buffer = "[Buffer]",
          path = "[Path]",
          cmp_tabnine = "[TabNine]",
          copilot = "[Copilot]",
          nvim_lua = "[Lua]",
          emoji = "[Emoji]",
        })[entry.source.name]
        return vim_item
      end,
    },
    sources = cmp.config.sources({
      { name = "copilot" },
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "cmp_tabnine" },
      { name = "nvim_lua" },
    }, {
      { name = "buffer", keyword_length = 3 }, -- Show only after typing 3 chars
      { name = "path" },
      { name = "emoji" },
    }),
    sorting = {
      priority_weight = 2,
      comparators = {
        prefer_snippets,
        prefer_exact_matches,
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        cmp.config.compare.locality,
        cmp.config.compare.offset,
        cmp.config.compare.order,
      },
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    experimental = {
      ghost_text = true,
    },
  }

  -- Cmdline completion
  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = "buffer" } },
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })
end

return M
