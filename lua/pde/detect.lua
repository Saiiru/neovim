local M = {}

local uv = vim.uv or vim.loop

-- Root markers are ordered by project-contract priority. Metadata/task files
-- participate in root detection, but they do not override the real project type.
local root_markers = {
  "pde.toml",
  ".mise.toml",
  "mise/tasks",
  "sketch.yaml",
  "platformio.ini",
  "compile_commands.json",
  "vite.config.ts",
  "vite.config.js",
  "next.config.js",
  "next.config.mjs",
  "angular.json",
  "nuxt.config.ts",
  "svelte.config.js",
  "astro.config.mjs",
  "nest-cli.json",
  "pom.xml",
  "build.gradle",
  "settings.gradle",
  "go.mod",
  "Cargo.toml",
  "manage.py",
  "pyproject.toml",
  "package.json",
  ".git",
}

local type_markers = {
  { file = "sketch.yaml", type = "embedded", framework = "arduino-cli" },
  { file = "platformio.ini", type = "embedded", framework = "platformio" },
  { file = "vite.config.ts", type = "frontend", framework = "vite" },
  { file = "vite.config.js", type = "frontend", framework = "vite" },
  { file = "next.config.js", type = "frontend", framework = "next" },
  { file = "next.config.mjs", type = "frontend", framework = "next" },
  { file = "angular.json", type = "frontend", framework = "angular" },
  { file = "nuxt.config.ts", type = "frontend", framework = "nuxt" },
  { file = "svelte.config.js", type = "frontend", framework = "sveltekit" },
  { file = "astro.config.mjs", type = "frontend", framework = "astro" },
  { file = "nest-cli.json", type = "backend", framework = "nestjs" },
  { file = "pom.xml", type = "backend", framework = "maven/java" },
  { file = "build.gradle", type = "backend", framework = "gradle/java" },
  { file = "settings.gradle", type = "backend", framework = "gradle/java" },
  { file = "go.mod", type = "backend", framework = "go" },
  { file = "Cargo.toml", type = "backend", framework = "rust" },
  { file = "manage.py", type = "backend", framework = "django" },
  { file = "pyproject.toml", type = "backend", framework = "python" },
  { file = "package.json", type = "node", framework = "node" },
  { file = "compile_commands.json", type = "native", framework = "compile-db" },
  { file = ".git", type = "git", framework = "generic" },
}

local function exists(path)
  return path and uv.fs_stat(path) ~= nil
end

function M.exists(root, name)
  return exists(root and (root .. "/" .. name))
end

local function buffer_start(bufnr)
  bufnr = bufnr or 0
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name ~= "" then
    local stat = uv.fs_stat(name)
    if stat and stat.type == "directory" then return name end
    return vim.fs.dirname(name)
  end
  return uv.cwd()
end

local function parent(path)
  if not path or path == "/" then return nil end
  local next_parent = vim.fs.dirname(path)
  if next_parent == path then return nil end
  return next_parent
end

local function marker_in(dir)
  for _, marker in ipairs(root_markers) do
    if M.exists(dir, marker) then return marker end
  end
  return nil
end

-- Walk upward from the current buffer directory. The closest project root wins;
-- marker order only breaks ties in the same directory.
function M.root(bufnr)
  local dir = buffer_start(bufnr) or uv.cwd()
  while dir do
    if marker_in(dir) then return dir end
    dir = parent(dir)
  end
  return buffer_start(bufnr) or uv.cwd()
end

function M.detect(bufnr)
  local root = M.root(bufnr)
  local has_mise_toml = M.exists(root, ".mise.toml")
  local has_mise_tasks = M.exists(root, "mise/tasks")
  local info = {
    root = root,
    type = "unknown",
    framework = "unknown",
    marker = nil,
    has_mise = has_mise_toml,
    has_pde = M.exists(root, "pde.toml"),
    has_compile_db = M.exists(root, "compile_commands.json"),
    has_local_tasks = has_mise_toml or has_mise_tasks,
    task_source = has_mise_toml and ".mise.toml" or (has_mise_tasks and "mise/tasks" or nil),
  }

  for _, marker in ipairs(type_markers) do
    if M.exists(root, marker.file) then
      info.type = marker.type
      info.framework = marker.framework
      info.marker = marker.file
      break
    end
  end

  return info
end

return M
