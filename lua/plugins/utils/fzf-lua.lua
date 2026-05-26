-- ================================================================================================
-- TITLE : fzf-lua
-- ABOUT : Finder rápido e muito performático para arquivos, grep, símbolos e diagnósticos.
-- LINKS :
--   > github : https://github.com/ibhagwan/fzf-lua
-- NOTE  :
--   FzfLua é o picker principal: busca, buffers, LSP, diagnostics, vim.ui.select
--   e code actions. Telescope fica desativado enquanto o preview estiver quebrado.
-- ================================================================================================

return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = function()
    -- fzf-lua chama `serverstart()` no require. Em alguns ambientes restritos
    -- isso falha e quebra o startup/headless. Se der certo, usamos o server
    -- real; se não, marcamos como indisponível e evitamos crash.
    if not vim.g.fzf_lua_server then
      local ok, server = pcall(vim.fn.serverstart, "fzf-lua-" .. tostring(vim.fn.getpid()))
      vim.g.fzf_lua_server = ok and server or "disabled"
    end
  end,
  keys = {
    {
      "<leader>ff",
      function()
        require("fzf-lua").files({ cwd = vim.uv.cwd() })
      end,
      desc = "Find Files",
    },
    {
      "<leader>fF",
      function()
        local root = vim.fs.root(
          0,
          { ".git", "package.json", "tsconfig.json", "pyproject.toml", "go.mod", "Cargo.toml" }
        ) or vim.uv.cwd()
        require("fzf-lua").files({ cwd = root })
      end,
      desc = "Find Files Root",
    },
    {
      "<leader>fg",
      function()
        require("fzf-lua").live_grep({ cwd = vim.uv.cwd() })
      end,
      desc = "Grep Text",
    },
    {
      "<leader>fw",
      function()
        require("fzf-lua").grep_cword({ cwd = vim.uv.cwd() })
      end,
      desc = "Grep Word Under Cursor",
    },
    {
      "<leader>fk",
      function()
        require("fzf-lua").keymaps()
      end,
      desc = "Find Keymaps",
    },
    {
      "<leader>fm",
      function()
        require("fzf-lua").manpages()
      end,
      desc = "Find Man Pages",
    },
    {
      "<leader>fb",
      function()
        require("fzf-lua").buffers()
      end,
      desc = "Find Buffers",
    },
    {
      "<leader>fh",
      function()
        require("fzf-lua").help_tags()
      end,
      desc = "Help Tags",
    },
    {
      "<leader>fo",
      function()
        require("fzf-lua").oldfiles()
      end,
      desc = "Old Files",
    },
    {
      "<leader>fr",
      function()
        require("fzf-lua").resume()
      end,
      desc = "Resume Last Search",
    },
    {
      "<leader>Ff",
      function()
        require("fzf-lua").files()
      end,
      desc = "FzfLua Files",
    },
    {
      "<leader>Fg",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "FzfLua Live Grep",
    },
    {
      "<leader>Fb",
      function()
        require("fzf-lua").buffers()
      end,
      desc = "FzfLua Buffers",
    },
    {
      "<leader>Fh",
      function()
        require("fzf-lua").help_tags()
      end,
      desc = "FzfLua Help Tags",
    },
    {
      "<leader>Fx",
      function()
        require("fzf-lua").diagnostics_document()
      end,
      desc = "FzfLua Diagnostics (Buffer)",
    },
    {
      "<leader>FX",
      function()
        require("fzf-lua").diagnostics_workspace()
      end,
      desc = "FzfLua Diagnostics (Workspace)",
    },
    {
      "<leader>Fs",
      function()
        require("fzf-lua").lsp_document_symbols()
      end,
      desc = "FzfLua Symbols (Buffer)",
    },
    {
      "<leader>FS",
      function()
        require("fzf-lua").lsp_workspace_symbols()
      end,
      desc = "FzfLua Symbols (Workspace)",
    },
    {
      "<leader>Fo",
      function()
        require("fzf-lua").oldfiles()
      end,
      desc = "FzfLua Old Files",
    },
    {
      "<leader>Fp",
      function()
        require("fzf-lua").files({ cwd = "/home/sairu/Documents/Obsidian" })
      end,
      desc = "FzfLua Obsidian Files",
    },
  },
  opts = function()
    return {
      ui_select = true,
      winopts = {
        height = 0.90,
        width = 0.90,
        border = "single",
        preview = {
          vertical = "down:55%",
          layout = "vertical",
          border = "single",
        },
      },
      files = {
        fd_opts = table.concat({
          "--color=never",
          "--type f",
          "--hidden",
          "--follow",
          "--exclude .git",
          "--exclude node_modules",
          "--exclude target",
          "--exclude dist",
          "--exclude build",
        }, " "),
      },
      grep = {
        rg_opts = table.concat({
          "--column",
          "--line-number",
          "--no-heading",
          "--color=always",
          "--smart-case",
          "--hidden",
          "--glob !.git/*",
          "--glob !node_modules/*",
          "--glob !target/*",
          "--glob !dist/*",
          "--glob !build/*",
        }, " "),
      },
      previewers = {
        builtin = {
          -- Evita travar em binários/arquivos grandes durante preview.
          syntax_limit_b = 100 * 1024,
          limit_b = 1024 * 1024,
        },
      },
      fzf_colors = {
        ["fg"] = { "fg", "Normal" },
        ["bg"] = { "bg", "Normal" },
        ["hl"] = { "fg", "FzfLuaSearch" },
        ["fg+"] = { "fg", "CursorLine" },
        ["bg+"] = { "bg", "CursorLine" },
        ["hl+"] = { "fg", "IncSearch" },
        ["info"] = { "fg", "DiagnosticInfo" },
        ["border"] = { "fg", "FzfLuaBorder" },
        ["prompt"] = { "fg", "FzfLuaTitle" },
        ["pointer"] = { "fg", "DiagnosticError" },
        ["marker"] = { "fg", "DiagnosticWarn" },
        ["spinner"] = { "fg", "DiagnosticHint" },
        ["header"] = { "fg", "Comment" },
      },
      keymap = {
        fzf = {
          ["ctrl-q"] = "select-all+accept",
        },
      },
    }
  end,
}
