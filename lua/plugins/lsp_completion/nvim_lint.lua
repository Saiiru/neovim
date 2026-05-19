return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require "lint"

    lint.linters_by_ft = {
      python = { "ruff", "pylint" },
      lua = { "selene" },

      javascript = { "biomejs", "eslint_d", "eslint" },
      javascriptreact = { "biomejs", "eslint_d", "eslint" },
      typescript = { "biomejs", "eslint_d", "eslint" },
      typescriptreact = { "biomejs", "eslint_d", "eslint" },
      vue = { "eslint_d", "eslint" },
      svelte = { "eslint_d", "eslint" },
      astro = { "eslint_d", "eslint" },

      json = { "biomejs" },
      jsonc = { "biomejs" },
      css = { "biomejs" },
      scss = { "biomejs" },

      markdown = { "markdownlint-cli2" },
      ["markdown.mdx"] = { "markdownlint-cli2" },

      yaml = { "yamllint" },
      ghaction = { "actionlint", "yamllint" },
      ["yaml.ghaction"] = { "actionlint", "yamllint" },

      dockerfile = { "hadolint" },

      sh = { "shellcheck" },
      bash = { "shellcheck" },
      zsh = { "shellcheck" },

      go = { "golangcilint" },
      rust = { "clippy" },
      java = { "checkstyle" },
      kotlin = { "ktlint" },
      c = { "clangtidy" },
      cpp = { "clangtidy" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("nvim-lint", { clear = true })

    local linter_commands = {
      actionlint = "actionlint",
      biomejs = "biome",
      checkstyle = "checkstyle",
      clangtidy = "clang-tidy",
      clippy = "cargo",
      ["editorconfig-checker"] = "editorconfig-checker",
      eslint_d = "eslint_d",
      eslint = "eslint",
      golangcilint = "golangci-lint",
      hadolint = "hadolint",
      ktlint = "ktlint",
      ["markdownlint-cli2"] = "markdownlint-cli2",
      pylint = "pylint",
      ruff = "ruff",
      selene = "selene",
      shellcheck = "shellcheck",
      yamllint = "yamllint",
    }

    local function buf_dir(bufnr)
      local name = vim.api.nvim_buf_get_name(bufnr)
      if name == "" then
        return nil
      end
      return vim.fs.dirname(name)
    end

    local function find_upward(bufnr, names, kind)
      local path = buf_dir(bufnr)
      if not path then
        return nil
      end
      return vim.fs.find(names, {
        upward = true,
        path = path,
        type = kind or "file",
      })[1]
    end

    local function has_upward(bufnr, names, kind)
      return find_upward(bufnr, names, kind) ~= nil
    end

    local function has_exec(linter_name)
      local cmd = linter_commands[linter_name] or linter_name
      return vim.fn.executable(cmd) == 1
    end

    local function has_biome_config(bufnr)
      return has_upward(bufnr, { "biome.json", "biome.jsonc", ".biome.json", ".biome.jsonc" })
    end

    local function has_editorconfig(bufnr)
      return has_upward(bufnr, { ".editorconfig" })
    end

    local function has_eslint_config(bufnr)
      return has_upward(bufnr, {
        "eslint.config.js",
        "eslint.config.cjs",
        "eslint.config.mjs",
        "eslint.config.ts",
        ".eslintrc",
        ".eslintrc.js",
        ".eslintrc.cjs",
        ".eslintrc.json",
        ".eslintrc.yaml",
        ".eslintrc.yml",
      })
    end

    local function has_java_project(bufnr)
      return has_upward(bufnr, {
        "pom.xml",
        "build.gradle",
        "build.gradle.kts",
        "settings.gradle",
        "settings.gradle.kts",
        "gradlew",
        "mvnw",
      })
    end

    local function has_pylint_config(bufnr)
      return has_upward(bufnr, {
        ".pylintrc",
        "pylintrc",
        "pyproject.toml",
        "setup.cfg",
        "tox.ini",
      })
    end

    local function has_selene_config(bufnr)
      return has_upward(bufnr, { "selene.toml", ".selene.toml" })
    end

    local function has_c_project(bufnr)
      return has_upward(bufnr, {
        "compile_commands.json",
        "compile_flags.txt",
        "CMakeLists.txt",
        "Makefile",
        "meson.build",
      })
    end

    local function in_go_project(bufnr)
      return has_upward(bufnr, {
        "go.mod",
        "go.work",
        ".golangci.yml",
        ".golangci.yaml",
        ".golangci.toml",
        ".golangci.json",
      })
    end

    local function in_rust_project(bufnr)
      return has_upward(bufnr, { "Cargo.toml" })
    end

    local function in_github_workflow(bufnr)
      local path = vim.api.nvim_buf_get_name(bufnr)
      return path:match("/%.github/workflows/") ~= nil
    end

    local function preferred_checkstyle_config(bufnr)
      return find_upward(bufnr, {
        "checkstyle.xml",
        ".checkstyle.xml",
        "sun_checks.xml",
        "google_checks.xml",
      }) or "/google_checks.xml"
    end

    if lint.linters.checkstyle then
      lint.linters.checkstyle.args = {
        "-f",
        "sarif",
        "-c",
        function()
          return preferred_checkstyle_config(vim.api.nvim_get_current_buf())
        end,
      }
    end

    local function enabled_linters(bufnr)
      local ft = vim.bo[bufnr].filetype
      local linters = vim.deepcopy(lint.linters_by_ft[ft] or {})
      local out = {}

      local biome_enabled = has_biome_config(bufnr)
      local eslint_enabled = has_eslint_config(bufnr)
      local eslint_selected = false

      for _, linter_name in ipairs(linters) do
        if has_exec(linter_name) then
          local keep = true

          if linter_name == "biomejs" then
            keep = biome_enabled
          elseif linter_name == "eslint_d" or linter_name == "eslint" then
            keep = (not biome_enabled) and eslint_enabled and not eslint_selected
            eslint_selected = eslint_selected or keep
          elseif linter_name == "pylint" then
            keep = has_pylint_config(bufnr)
          elseif linter_name == "selene" then
            keep = has_selene_config(bufnr)
          elseif linter_name == "golangcilint" then
            keep = in_go_project(bufnr)
          elseif linter_name == "actionlint" then
            keep = in_github_workflow(bufnr)
          elseif linter_name == "clippy" then
            keep = in_rust_project(bufnr)
          elseif linter_name == "clangtidy" then
            keep = has_c_project(bufnr)
          elseif linter_name == "checkstyle" then
            keep = has_java_project(bufnr)
          end

          if keep then
            table.insert(out, linter_name)
          end
        end
      end

      local editorconfig_fts = {
        astro = true,
        bash = true,
        c = true,
        cpp = true,
        css = true,
        dockerfile = true,
        graphql = true,
        go = true,
        html = true,
        java = true,
        javascript = true,
        javascriptreact = true,
        json = true,
        jsonc = true,
        kotlin = true,
        lua = true,
        markdown = true,
        ["markdown.mdx"] = true,
        nix = true,
        python = true,
        rust = true,
        scss = true,
        less = true,
        sh = true,
        svelte = true,
        toml = true,
        typescript = true,
        typescriptreact = true,
        vue = true,
        yaml = true,
        ["yaml.ghaction"] = true,
        zsh = true,
        liquid = true,
      }

      if editorconfig_fts[ft] and has_editorconfig(bufnr) and has_exec "editorconfig-checker" then
        table.insert(out, "editorconfig-checker")
      end

      return out
    end

    local function try_lint(bufnr)
      bufnr = bufnr or vim.api.nvim_get_current_buf()
      local linters = enabled_linters(bufnr)
      if #linters == 0 then
        return
      end
      lint.try_lint(linters)
    end

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function(args)
        try_lint(args.buf)
      end,
    })

    vim.keymap.set("n", "<leader>ll", function()
      try_lint(0)
    end, { desc = "Lint current file" })
  end,
}
