local M = {}

local markers = {
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
  { file = "go.mod", type = "backend", framework = "go" },
  { file = "Cargo.toml", type = "backend", framework = "rust" },
  { file = "manage.py", type = "backend", framework = "django" },
  { file = "pyproject.toml", type = "backend", framework = "python" },
  { file = "package.json", type = "node", framework = "node" },
}

local function exists(root, name)
  return vim.uv.fs_stat(root .. "/" .. name) ~= nil
end

function M.root()
  return vim.fs.root(0, { "pde.toml", ".mise.toml", "sketch.yaml", "platformio.ini", "package.json", "go.mod", "Cargo.toml", "pyproject.toml", ".git" }) or vim.uv.cwd()
end

function M.detect()
  local root = M.root()
  local info = { root = root, type = "unknown", framework = "unknown", has_mise = exists(root, ".mise.toml"), has_pde = exists(root, "pde.toml") }
  for _, marker in ipairs(markers) do
    if exists(root, marker.file) then
      info.type = marker.type
      info.framework = marker.framework
      info.marker = marker.file
      return info
    end
  end
  return info
end

return M
