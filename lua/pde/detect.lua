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
  "compile_flags.txt",
  "CMakeLists.txt",
  "Makefile",
  "meson.build",
  "vite.config.ts",
  "vite.config.js",
  "vite.config.mts",
  "vite.config.mjs",
  "next.config.js",
  "next.config.mjs",
  "next.config.ts",
  "angular.json",
  "nuxt.config.ts",
  "nuxt.config.js",
  "svelte.config.js",
  "svelte.config.ts",
  "astro.config.mjs",
  "astro.config.ts",
  "nest-cli.json",
  "pom.xml",
  "build.gradle",
  "build.gradle.kts",
  "settings.gradle",
  "settings.gradle.kts",
  "go.work",
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
  { file = "compile_commands.json", type = "native", framework = "compile-db" },
  { file = "CMakeLists.txt", type = "native", framework = "cmake" },
  { file = "meson.build", type = "native", framework = "meson" },
  { file = "Makefile", type = "native", framework = "make" },
  { file = "vite.config.ts", type = "frontend", framework = "vite" },
  { file = "vite.config.js", type = "frontend", framework = "vite" },
  { file = "vite.config.mts", type = "frontend", framework = "vite" },
  { file = "vite.config.mjs", type = "frontend", framework = "vite" },
  { file = "next.config.js", type = "frontend", framework = "next" },
  { file = "next.config.mjs", type = "frontend", framework = "next" },
  { file = "next.config.ts", type = "frontend", framework = "next" },
  { file = "angular.json", type = "frontend", framework = "angular" },
  { file = "nuxt.config.ts", type = "frontend", framework = "nuxt" },
  { file = "nuxt.config.js", type = "frontend", framework = "nuxt" },
  { file = "svelte.config.js", type = "frontend", framework = "sveltekit" },
  { file = "svelte.config.ts", type = "frontend", framework = "sveltekit" },
  { file = "astro.config.mjs", type = "frontend", framework = "astro" },
  { file = "astro.config.ts", type = "frontend", framework = "astro" },
  { file = "nest-cli.json", type = "backend", framework = "nestjs" },
  { file = "pom.xml", type = "backend", framework = "maven/java" },
  { file = "build.gradle", type = "backend", framework = "gradle/java" },
  { file = "build.gradle.kts", type = "backend", framework = "gradle/java" },
  { file = "settings.gradle", type = "backend", framework = "gradle/java" },
  { file = "settings.gradle.kts", type = "backend", framework = "gradle/java" },
  { file = "go.work", type = "backend", framework = "go" },
  { file = "go.mod", type = "backend", framework = "go" },
  { file = "Cargo.toml", type = "backend", framework = "rust" },
  { file = "manage.py", type = "backend", framework = "django" },
  { file = "pyproject.toml", type = "backend", framework = "python" },
  { file = "package.json", type = "node", framework = "node" },
  { file = ".git", type = "git", framework = "generic" },
}

local function exists(path)
  return path and uv.fs_stat(path) ~= nil
end

function M.exists(root, name)
  return exists(root and (root .. "/" .. name))
end

local function read(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local text = f:read("*a")
  f:close()
  return text
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

local function package_manager(root)
  if M.exists(root, "pnpm-lock.yaml") then return "pnpm" end
  if M.exists(root, "yarn.lock") then return "yarn" end
  if M.exists(root, "bun.lockb") or M.exists(root, "bun.lock") then return "bun" end
  if M.exists(root, "package-lock.json") then return "npm" end
  if M.exists(root, "package.json") then return "npm" end
  return nil
end

local function package_framework(root, fallback)
  local text = read(root .. "/package.json") or ""
  local function has_pkg(name)
    return text:find('"' .. vim.pesc(name) .. '"', 1, false) ~= nil
  end
  if has_pkg("next") then return "next", "frontend" end
  if has_pkg("@nestjs/core") then return "nestjs", "backend" end
  if has_pkg("nuxt") then return "nuxt", "frontend" end
  if has_pkg("svelte") or has_pkg("@sveltejs/kit") then return "sveltekit", "frontend" end
  if has_pkg("astro") then return "astro", "frontend" end
  if has_pkg("vue") then return "vue", "frontend" end
  if has_pkg("react") or has_pkg("react-dom") then return fallback == "vite" and "vite" or "react", "frontend" end
  if has_pkg("express") or has_pkg("fastify") then return "express", "backend" end
  return fallback, nil
end

function M.detect(bufnr)
  local root = M.root(bufnr)
  local has_mise_toml = M.exists(root, ".mise.toml")
  local has_mise_tasks = M.exists(root, "mise/tasks")
  local info = {
    root = root,
    type = "unknown",
    framework = "unknown",
    language = "unknown",
    package_manager = package_manager(root),
    marker = nil,
    has_mise = has_mise_toml,
    has_pde = M.exists(root, "pde.toml"),
    has_compile_db = M.exists(root, "compile_commands.json") or M.exists(root, "build/compile_commands.json"),
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

  if info.framework == "node" or info.marker == "package.json" or info.package_manager then
    local fw, kind = package_framework(root, info.framework)
    info.framework = fw or info.framework
    if kind then info.type = kind end
  end

  local catalog = require("pde.catalog").for_framework(info.framework)
  if catalog.language ~= "unknown" then info.language = catalog.language end
  if catalog.type ~= "unknown" and (info.type == "unknown" or info.type == "node") then info.type = catalog.type end
  info.expected_tasks = catalog.expected or {}

  return info
end

return M
