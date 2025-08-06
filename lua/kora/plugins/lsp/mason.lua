-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                KORA MASON TOOLCHAIN - CLEAN VERSION                     ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
  -- ═══════════════════════════════════════════════════════════════════════════
  -- 🏗️ MASON BASE
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason Toolchain" } },
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- 🔧 MASON-LSPCONFIG
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "tsserver",
        "html",
        "cssls",
        "tailwindcss",
        "emmet_ls",
        "jsonls",
        "yamlls",
        "pyright",
        "ruff_lsp",
        "gopls",
        "rust_analyzer",
        "clangd",
        "jdtls",
        "omnisharp",
        "bashls",
        "marksman",
        "dockerls",
        "docker_compose_language_service",
      },
      automatic_installation = true,
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
    end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- 🛠️ MASON-TOOL-INSTALLER
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        -- Formatters
        "stylua",
        "prettier",
        "prettierd",
        "black",
        "isort",
        "gofumpt",
        "goimports",
        "rustfmt",
        "clang-format",
        "google-java-format",
        "shfmt",
        -- Linters
        "eslint_d",
        "stylelint",
        "flake8",
        "golangci-lint",
        "shellcheck",
        "markdownlint",
        "yamllint",
        "jsonlint",
        "hadolint",
        -- Debug Adapters
        "codelldb",
        "debugpy",
        "js-debug-adapter",
        "java-debug-adapter",
        "delve",
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 5,
    },
    config = function(_, opts)
      local mason_tool_installer = require("mason-tool-installer")
      mason_tool_installer.setup(opts)

      -- ═══════════════════════════════════════════════════════════════════════════
      -- 🔍 STATUS CHECK FUNCTION
      -- ═══════════════════════════════════════════════════════════════════════════
      local function check_tools()
        local installed, missing = {}, {}
        local registry = require("mason-registry")

        for _, tool in ipairs(opts.ensure_installed) do
          if registry.has_package(tool) then
            local package = registry.get_package(tool)
            if package:is_installed() then
              table.insert(installed, tool)
            else
              table.insert(missing, tool)
            end
          else
            table.insert(missing, tool .. " (invalid)")
          end
        end

        local msg = "🛠️ KORA Tools: "
          .. #installed
          .. "/"
          .. #opts.ensure_installed
          .. " installed"
        if #missing > 0 then
          msg = msg .. "\nMissing: " .. table.concat(missing, ", ")
        end
        print(msg)
      end

      -- ═══════════════════════════════════════════════════════════════════════════
      -- 🎮 COMMANDS
      -- ═══════════════════════════════════════════════════════════════════════════
      vim.api.nvim_create_user_command(
        "MasonToolsStatus",
        check_tools,
        { desc = "Check tool status" }
      )
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonToolsInstall")
      end, { desc = "Install all tools" })
      vim.api.nvim_create_user_command("MasonUpdateAll", function()
        vim.cmd("MasonToolsUpdate")
      end, { desc = "Update all tools" })

      -- Auto-install with status check
      vim.defer_fn(function()
        mason_tool_installer.run_on_start()
        vim.defer_fn(check_tools, 8000)
      end, opts.start_delay)
    end,
  },
}
--[[

# 🛠️ KORA MASON SYSTEM - NAMES REFERENCE

## 📋 LSP Server Names (mason-lspconfig)
THESE GO IN mason-lspconfig ensure_installed:

| Language | LSPConfig Name | Mason Package Name |
|----------|---------------|--------------------|
| Lua | lua_ls | lua-language-server |
| TypeScript | tsserver | typescript-language-server |
| HTML | html | html-lsp |
| CSS | cssls | css-lsp |
| Tailwind | tailwindcss | tailwindcss-language-server |
| Python | pyright | pyright |
| Go | gopls | gopls |
| Rust | rust_analyzer | rust-analyzer |
| C/C++ | clangd | clangd |
| Java | jdtls | jdtls |
| C# | omnisharp | omnisharp |
| Bash | bashls | bash-language-server |
| JSON | jsonls | json-lsp |
| YAML | yamlls | yaml-language-server |
| Markdown | marksman | marksman |
| Docker | dockerls | dockerfile-language-server |

## 🛠️ Tool Names (mason-tool-installer)  
THESE GO IN mason-tool-installer ensure_installed:

### Formatters:
- stylua (Lua)
- prettier, prettierd (JS/TS/HTML/CSS)
- black, isort (Python)
- gofumpt, goimports (Go)
- rustfmt (Rust)
- clang-format (C/C++)
- google-java-format (Java)
- shfmt (Shell)

### Linters:
- eslint_d (JS/TS)
- stylelint (CSS/SCSS)
- flake8 (Python)
- golangci-lint (Go)
- shellcheck (Shell)
- markdownlint (Markdown)
- yamllint (YAML)
- jsonlint (JSON)
- hadolint (Dockerfile)

### Debug Adapters:
- codelldb (C/C++/Rust)
- debugpy (Python)
- js-debug-adapter (JS/TS)
- java-debug-adapter (Java)
- delve (Go)

## 🎮 Commands:
- :Mason → Open Mason UI
- :MasonToolsStatus → Check installation status
- :MasonInstallAll → Install all tools
- :MasonUpdateAll → Update all tools
- <leader>cm → Quick Mason access

## ⚠️ IMPORTANT:
- mason-lspconfig uses LSPConfig names (lua_ls, tsserver, etc.)
- mason-tool-installer uses Mason package names (stylua, prettier, etc.)
- Never mix these naming conventions!

]]
