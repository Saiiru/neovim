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
  { file = ".git", type = "git", framework = "generic" },
}

local function exists(root, name)
  return vim.uv.fs_stat(root .. "/" .. name) ~= nil
end

local function buffer_dir(bufnr)
  bufnr = bufnr or 0
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return vim.uv.cwd()
  end
  return vim.fs.dirname(name) or vim.uv.cwd()
end

function M.root(bufnr)
  bufnr = bufnr or 0
  local start = buffer_dir(bufnr)
  local root = vim.fs.root(start, {
    "pde.toml",
    ".mise.toml",
    "sketch.yaml",
    "platformio.ini",
    "package.json",
    "go.mod",
    "Cargo.toml",
    "pyproject.toml",
    "compile_commands.json",
    ".git",
  })
  return root or start
end

function M.detect(bufnr)
  local root = M.root(bufnr)
  local info = {
    root = root,
    type = "unknown",
    framework = "unknown",
    has_mise = exists(root, ".mise.toml"),
    has_pde = exists(root, "pde.toml"),
    has_compile_db = exists(root, "compile_commands.json"),
  }
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
