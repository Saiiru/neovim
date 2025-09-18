-- Persistência por projeto para format/lint (sem arquivos no repo)
local M = {}

local json = vim.json or vim.fn
local statefile = (vim.fn.stdpath "data" .. "/kora_project_prefs.json")

local function readfile(p)
  local fd = vim.uv.fs_open(p, "r", 438)
  if not fd then
    return nil
  end
  local stat = vim.uv.fs_fstat(fd)
  local data = vim.uv.fs_read(fd, stat.size, 0)
  vim.uv.fs_close(fd)
  return data
end

local function writefile(p, s)
  vim.fn.mkdir(vim.fn.fnamemodify(p, ":h"), "p")
  local fd = vim.uv.fs_open(p, "w", 420)
  if not fd then
    return
  end
  vim.uv.fs_write(fd, s, 0)
  vim.uv.fs_close(fd)
end

local function load_prefs()
  local s = readfile(statefile)
  if not s or s == "" then
    return {}
  end
  local ok, obj = pcall(function()
    return (json.decode and json.decode(s) or vim.fn.json_decode(s))
  end)
  return ok and obj or {}
end

local function save_prefs(tbl)
  local s = (json.encode and json.encode(tbl) or vim.fn.json_encode(tbl))
  writefile(statefile, s)
end

local function project_root()
  local buf = vim.api.nvim_get_current_buf()
  local start = vim.api.nvim_buf_get_name(buf)
  local dir = (start ~= "" and vim.fs.dirname(start)) or vim.uv.cwd()
  local markers = {
    ".git",
    "pom.xml",
    "build.gradle",
    "build.gradle.kts",
    "package.json",
    "go.mod",
    "pyproject.toml",
    "Cargo.toml",
    "composer.json",
    ".editorconfig",
  }
  local found = vim.fs.find(markers, { path = dir, upward = true })[1]
  return found and vim.fs.dirname(found) or (vim.uv.cwd() or dir)
end

local function apply(root, prefs)
  local pr = prefs[root] or {}
  -- defaults: OFF
  vim.g.kora_format_on_save = pr.format_on_save == true
  vim.g.kora_lint_on_save = pr.lint_on_save == true
end

local function set_and_persist(root, key, val)
  local prefs = load_prefs()
  prefs[root] = prefs[root] or {}
  prefs[root][key] = val and true or false
  save_prefs(prefs)
  apply(root, prefs)
end

function M.setup()
  local grp = vim.api.nvim_create_augroup("KoraProjectPrefs", { clear = true })
  vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged", "BufEnter" }, {
    group = grp,
    callback = function()
      local root = project_root()
      apply(root, load_prefs())
    end,
  })

  -- Comandos: ON/OFF por projeto (persistem); bang (!) = buffer-local temporário
  vim.api.nvim_create_user_command("FormatOn", function(opts)
    if opts.bang then
      vim.b.kora_format_on_save = true
    else
      set_and_persist(project_root(), "format_on_save", true)
    end
    vim.notify("Format on save: ON" .. (opts.bang and " (buffer)" or " (project)"))
  end, { bang = true })
  vim.api.nvim_create_user_command("FormatOff", function(opts)
    if opts.bang then
      vim.b.kora_format_on_save = false
    else
      set_and_persist(project_root(), "format_on_save", false)
    end
    vim.notify("Format on save: OFF" .. (opts.bang and " (buffer)" or " (project)"))
  end, { bang = true })
  vim.api.nvim_create_user_command("FormatToggle", function(opts)
    local b = vim.b.kora_format_on_save
    if b ~= nil and opts.bang then
      vim.b.kora_format_on_save = not b
      vim.notify("Format on save (buffer): " .. tostring(vim.b.kora_format_on_save))
      return
    end
    local root = project_root()
    local prefs = load_prefs()
    local cur = (prefs[root] and prefs[root].format_on_save) or false
    set_and_persist(root, "format_on_save", not cur)
    vim.notify("Format on save (project): " .. tostring(not cur))
  end, { bang = true })

  vim.api.nvim_create_user_command("LintOn", function(opts)
    if opts.bang then
      vim.b.kora_lint_on_save = true
    else
      set_and_persist(project_root(), "lint_on_save", true)
    end
    vim.notify("Lint on save: ON" .. (opts.bang and " (buffer)" or " (project)"))
  end, { bang = true })
  vim.api.nvim_create_user_command("LintOff", function(opts)
    if opts.bang then
      vim.b.kora_lint_on_save = false
    else
      set_and_persist(project_root(), "lint_on_save", false)
    end
    vim.notify("Lint on save: OFF" .. (opts.bang and " (buffer)" or " (project)"))
  end, { bang = true })
  vim.api.nvim_create_user_command("LintToggle", function(opts)
    local b = vim.b.kora_lint_on_save
    if b ~= nil and opts.bang then
      vim.b.kora_lint_on_save = not b
      vim.notify("Lint on save (buffer): " .. tostring(vim.b.kora_lint_on_save))
      return
    end
    local root = project_root()
    local prefs = load_prefs()
    local cur = (prefs[root] and prefs[root].lint_on_save) or false
    set_and_persist(root, "lint_on_save", not cur)
    vim.notify("Lint on save (project): " .. tostring(not cur))
  end, { bang = true })
end

return M
