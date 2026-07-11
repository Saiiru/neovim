return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
    },
    config = function()
      vim.diagnostic.config({
        underline = true,
        virtual_text = false,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = true },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          },
        },
      })

      local caps = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then caps = cmp_lsp.default_capabilities(caps) end

      local lspconfig = require("lspconfig")
      local function exe(cmd) return vim.fn.executable(cmd) == 1 end
      local function has(root, rel) return root and vim.uv.fs_stat(root .. "/" .. rel) ~= nil end
      local function root(patterns)
        return vim.fs.root(0, patterns) or vim.uv.cwd()
      end
      local function setup(server, cfg)
        if cfg.cmd and not exe(cfg.cmd[1]) then return end
        if lspconfig[server] then lspconfig[server].setup(cfg) end
      end

      setup("lua_ls", {
        cmd = { "lua-language-server" },
        capabilities = caps,
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })

      setup("clangd", {
        cmd = { "clangd", "--background-index", "--clang-tidy" },
        capabilities = caps,
        root_dir = function(fname)
          return lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")(fname)
        end,
      })

      setup("gopls", { cmd = { "gopls" }, capabilities = caps })
      setup("rust_analyzer", { cmd = { "rust-analyzer" }, capabilities = caps })
      setup("basedpyright", { cmd = { "basedpyright-langserver", "--stdio" }, capabilities = caps })

      -- TS/JS only starts after the project actually installs TypeScript.
      if has(root({ "package.json", ".git" }), "node_modules/typescript/lib/typescript.js") then
        setup("ts_ls", {
          cmd = { "typescript-language-server", "--stdio" },
          capabilities = caps,
        })
      end
    end,
  },
}
