-- Language Configuration
-- Language-specific editor settings (tabstop, shiftwidth, etc.)
-- Based on nvpunk's language configs

local M = {}

-- Language-specific settings
M.lang_configs = {
  lua = {
    formatter = "stylua",
    linter = "selene",
    indent = 2,
    tab_width = 2,
    expandtab = true,
    path_sep = ".",
  },
  python = {
    formatter = "ruff_format",
    linter = "ruff",
    type_checker = "mypy",
    indent = 2,
    tab_width = 2,
    expandtab = true,
    line_length = 100,
    path_sep = ".",
  },
  javascript = {
    formatter = "prettierd",
    linter = "oxlint",
    indent = 2,
    tab_width = 2,
    expandtab = true,
    path_sep = ".",
  },
  typescript = {
    formatter = "prettierd",
    linter = "oxlint",
    indent = 2,
    tab_width = 2,
    expandtab = true,
    path_sep = ".",
  },
  javascriptreact = {
    formatter = "prettierd",
    linter = "oxlint",
    indent = 2,
    tab_width = 2,
    expandtab = true,
  },
  typescriptreact = {
    formatter = "prettierd",
    linter = "oxlint",
    indent = 2,
    tab_width = 2,
    expandtab = true,
  },
  json = {
    formatter = "prettierd",
    linter = "jsonlint",
    indent = 2,
    tab_width = 2,
    expandtab = true,
  },
  jsonc = {
    formatter = "prettierd",
    linter = "jsonlint",
    indent = 2,
    tab_width = 2,
    expandtab = true,
  },
  yaml = {
    formatter = "prettierd",
    linter = "yamllint",
    indent = 2,
    tab_width = 2,
    expandtab = true,
  },
  markdown = {
    formatter = "prettierd",
    linter = "markdownlint",
    indent = 2,
    tab_width = 2,
    expandtab = true,
    line_length = 120,
  },
  rust = {
    formatter = "rustfmt",
    linter = "cargo",
    indent = 4,
    tab_width = 4,
    expandtab = true,
    edition = "2021",
  },
  go = {
    formatter = "goimports",
    linter = "golangcilint",
    indent = 4,
    tab_width = 4,
    expandtab = false, -- Go uses tabs
  },
  html = {
    formatter = "prettierd",
    linter = "htmlhint",
    indent = 2,
    tab_width = 2,
    expandtab = true,
  },
  css = {
    formatter = "prettierd",
    linter = "stylelint",
    indent = 2,
    tab_width = 2,
    expandtab = true,
  },
  scss = {
    formatter = "prettierd",
    linter = "stylelint",
    indent = 2,
    tab_width = 2,
    expandtab = true,
  },
  dockerfile = {
    formatter = "dockerfmt",
    linter = "hadolint",
    indent = 2,
    tab_width = 2,
    expandtab = true,
  },
  sql = {
    formatter = "sqlfmt",
    linter = "sqlfluff",
    indent = 2,
    tab_width = 2,
    expandtab = true,
  },
  bash = {
    formatter = "shfmt",
    linter = "shellcheck",
    indent = 2,
    tab_width = 2,
    expandtab = true,
  },
  sh = {
    formatter = "shfmt",
    linter = "shellcheck",
    indent = 2,
    tab_width = 2,
    expandtab = true,
  },
  c = {
    formatter = "clang-format",
    linter = "clang-tidy",
    indent = 4,
    tab_width = 4,
    expandtab = true,
  },
  cpp = {
    formatter = "clang-format",
    linter = "clang-tidy",
    indent = 4,
    tab_width = 4,
    expandtab = true,
  },
  csharp = {
    formatter = "csharpier",
    linter = "dotnet_format",
    indent = 4,
    tab_width = 4,
    expandtab = true,
    line_length = 120,
  },
  arduino = {
    formatter = "clang-format",
    linter = "cppcheck",
    indent = 2,
    tab_width = 2,
    expandtab = true,
    line_length = 100,
    defines = { "ARDUINO", "F_CPU=16000000L" },
  },
  java = {
    formatter = "google-java-format",
    linter = "checkstyle",
    indent = 4,
    tab_width = 4,
    expandtab = true,
  },
}

-- Language icons (for statusline, etc.)
M.lang_icons = {
  python = "󰌠",
  javascript = "󰌞",
  typescript = "󰛦",
  rust = "󱘗",
  go = "󰟓",
  lua = "󰢱",
  c = "󰙱",
  cpp = "󰙲",
  csharp = "󰌛",
  java = "󰬷",
  arduino = "󰜺",
  html = "󰌝",
  css = "󰌟",
  json = "󰘦",
  yaml = "󰈳",
  markdown = "󰍔",
  docker = "󰡨",
  sql = "󰆼",
  config = "󰒓",
  terminal = "󰆍",
}

-- Filetypes that should have relative numbers
M.relativenumber_filetypes = {
  "lua", "python", "javascript", "typescript", "go", "rust", "c", "cpp",
  "java", "cs", "arduino", "javascriptreact", "typescriptreact", "json",
  "yaml", "markdown", "html", "css", "scss", "rust", "toml", "sql",
  "bash", "sh", "zsh", "dockerfile",
}

-- Setup autocmds
function M.setup_autocmds()
  -- Language-specific editor settings
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
      local ft = vim.bo.filetype
      local config = M.lang_configs[ft]
      if config then
        vim.bo.tabstop = config.tab_width
        vim.bo.shiftwidth = config.indent
        vim.bo.expandtab = config.expandtab
        vim.bo.textwidth = config.line_length or 0
      end
    end,
    desc = "Apply language-specific editor settings",
  })

  -- Apply to current buffer if already opened
  vim.schedule(function()
    local ft = vim.bo.filetype
    local config = M.lang_configs[ft]
    if config then
      vim.bo.tabstop = config.tab_width
      vim.bo.shiftwidth = config.indent
      vim.bo.expandtab = config.expandtab
      vim.bo.textwidth = config.line_length or 0
    end
  end)

  -- Auto-enable relative numbers for code files
  vim.api.nvim_create_autocmd("FileType", {
    pattern = M.relativenumber_filetypes,
    callback = function()
      vim.opt_local.relativenumber = true
    end,
  })
end

-- Get config for current filetype
function M.get_current_config()
  local ft = vim.bo.filetype
  return M.lang_configs[ft]
end

-- Get icon for filetype
function M.get_icon(ft)
  ft = ft or vim.bo.filetype
  return M.lang_icons[ft] or "󰈚"
end

-- Setup
function M.setup()
  M.setup_autocmds()
  
  -- User command to show current language config
  vim.api.nvim_create_user_command("LangConfig", function()
    local config = M.get_current_config()
    if config then
      print(vim.inspect(config))
    else
      print("No language config for " .. vim.bo.filetype)
    end
  end, { desc = "Show current language config" })
end

return M