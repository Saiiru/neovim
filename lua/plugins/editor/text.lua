return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    priority = 900,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      local ok_ts, ts = pcall(require, "nvim-treesitter")
      if ok_ts and ts.setup then
        ts.setup({ install_dir = vim.fn.stdpath("data") .. "/site" })
      end

      local language_by_ft = {
        javascriptreact = "tsx",
        typescriptreact = "tsx",
        jsonc = "json",
        sh = "bash",
        zsh = "bash",
        arduino = "cpp",
      }

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("vega-treesitter-start", { clear = true }),
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          local lang = language_by_ft[ft] or ft
          if lang == "" then return end
          local ok_parser = pcall(vim.treesitter.language.add, lang)
          if not ok_parser then return end
          pcall(vim.treesitter.start, args.buf, lang)
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = {
      enable = true,
      max_lines = 3,
      multiline_threshold = 1,
      trim_scope = "outer",
      mode = "cursor",
      separator = nil,
    },
  },
  {
    "echasnovski/mini.ai",
    keys = {
      { "a", mode = { "x", "o" } },
      { "i", mode = { "x", "o" } },
    },
    event = "VeryLazy",
    dependencies = { "nvim-treesitter-textobjects" },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      }
    end,
  },
}
