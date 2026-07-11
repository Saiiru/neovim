local M = {}

local uv = vim.uv or vim.loop

local markers = {
  { file = "pde.toml", type = "pde", framework = "explicit" },
  { file = ".mise.toml", type = "toolchain", framework = "mise" },
  { file = "mise.toml", type = "toolchain", framework = "mise" },
  { file = "sketch.yaml", type = "embedded", framework = "arduino-cli" },
  { file = "platformio.ini", type = "embedded", framework = "platformio" },
  { file = "compile_commands.json", type = "native", framework = "compile-db" },
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
  { file = ".git", type = "git", framework = "generic" },
}

local root_markers = {}
for _, marker in ipairs(markers) do
  table.insert(root_markers, marker.file)
end

table.insert(root_markers, "mise/tasks")

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

function M.root(bufnr)
  local start = buffer_start(bufnr)
  return vim.fs.root(start, root_markers) or start or uv.cwd()
end

function M.detect(bufnr)
  local root = M.root(bufnr)
  local info = {
    root = root,
    type = "unknown",
    framework = "unknown",
    marker = nil,
    has_mise = M.exists(root, ".mise.toml") or M.exists(root, "mise.toml") or M.exists(root, "mise/tasks"),
    has_pde = M.exists(root, "pde.toml"),
    has_compile_db = M.exists(root, "compile_commands.json"),
    has_local_tasks = M.exists(root, ".mise.toml") or M.exists(root, "mise.toml") or M.exists(root, "mise/tasks"),
  }

  for _, marker in ipairs(markers) do
    if M.exists(root, marker.file) then
      info.type = marker.type
      info.framework = marker.framework
      info.marker = marker.file
      break
    end
  end

  if info.framework == "mise" then
    if M.exists(root, "sketch.yaml") then
      info.type = "embedded"
      info.framework = "arduino-cli"
      info.marker = "sketch.yaml"
    elseif M.exists(root, "platformio.ini") then
      info.type = "embedded"
      info.framework = "platformio"
      info.marker = "platformio.ini"
    end
  end

  return info
end

return M
