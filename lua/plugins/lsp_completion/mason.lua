return {
  "mason-org/mason.nvim",
  cmd = "Mason",
  dependencies = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
        border = "rounded",
        width = 0.8,
        height = 0.8,
      },
    })

    require("mason-tool-installer").setup({
      ensure_installed = {
        "actionlint",
        "arduino-language-server",
        "black",
        "clang-format",
        "checkstyle",
        "editorconfig-checker",
        "gofumpt",
        "golangci-lint",
        "goimports",
        "google-java-format",
        "hadolint",
        "isort",
        "java-debug-adapter",
        "java-test",
        "jdtls",
        "ktlint",
        "ltex-ls-plus",
        "markdownlint-cli2",
        "nixfmt",
        "prettier",
        "prettierd",
        "pylint",
        "ruff",
        "selene",
        "shellcheck",
        "shfmt",
        "stylua",
        "yamlfmt",
        "yamllint",
      },
      auto_update = true,
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 5,
    })
  end,
}
