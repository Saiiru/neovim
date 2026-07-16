local M = {}

M.languages = {
  clang = {
    label = "C/C++/Arduino",
    lsp = { "clangd" },
    markers = { "compile_commands.json", "compile_flags.txt", "CMakeLists.txt", "Makefile", "meson.build", "platformio.ini", "sketch.yaml" },
    quickfix = { "build", "test", "lint", "typecheck", "arduino-compile" },
    terminal = { "dev", "run", "monitor", "arduino-monitor" },
    notes = "clangd is correct only when compile_commands.json or compile_flags.txt exists; CMake/Bear/arduino-cli/PIO should generate it.",
  },
  java = {
    label = "Java",
    lsp = { "jdtls" },
    markers = { "pom.xml", "build.gradle", "settings.gradle", "mvnw", "gradlew" },
    quickfix = { "build", "test", "lint" },
    terminal = { "run", "dev" },
    notes = "jdtls needs a per-project workspace; Maven/Gradle own build/test tasks.",
  },
  rust = {
    label = "Rust",
    lsp = { "rust_analyzer" },
    markers = { "Cargo.toml", "Cargo.lock", "rust-project.json" },
    quickfix = { "build", "test", "lint", "typecheck", "check", "clippy" },
    terminal = { "run", "dev" },
    notes = "rust-analyzer should use cargo metadata; project mise tasks should wrap cargo build/test/check/clippy/fmt.",
  },
  go = {
    label = "Go",
    lsp = { "gopls" },
    markers = { "go.mod", "go.work" },
    quickfix = { "build", "test", "lint", "typecheck" },
    terminal = { "run", "dev" },
    notes = "gopls handles go.mod/go.work; mise tasks should wrap go test/build/run and optional golangci-lint.",
  },
  node = {
    label = "JavaScript/TypeScript/Node",
    lsp = { "vtsls", "ts_ls", "eslint", "vue_ls", "svelte", "astro" },
    markers = { "package.json", "tsconfig.json", "jsconfig.json", "vite.config.*", "next.config.*", "nuxt.config.*", "svelte.config.*", "astro.config.*" },
    quickfix = { "build", "test", "lint", "typecheck" },
    terminal = { "dev", "run", "serve" },
    notes = "Prefer workspace TypeScript. vtsls is closest to VSCode TS behavior when installed; ts_ls remains safe fallback.",
  },
  python = {
    label = "Python",
    lsp = { "basedpyright", "ruff" },
    markers = { "pyproject.toml", "uv.lock", "requirements.txt", "manage.py" },
    quickfix = { "test", "lint", "typecheck", "build" },
    terminal = { "run", "dev" },
    notes = "mise/uv own environment and tasks; Neovim should not create venvs.",
  },
}

M.frameworks = {
  ["arduino-cli"] = { language = "clang", type = "embedded", expected = { "arduino-compile", "arduino-compile-db", "arduino-monitor", "arduino-upload", "arduino-flash" } },
  platformio = { language = "clang", type = "embedded", expected = { "build", "test", "monitor", "upload", "compile-db" } },
  ["compile-db"] = { language = "clang", type = "native", expected = { "build", "test", "lint", "typecheck" } },
  cmake = { language = "clang", type = "native", expected = { "build", "test", "run" } },
  make = { language = "clang", type = "native", expected = { "build", "test", "run" } },
  meson = { language = "clang", type = "native", expected = { "build", "test", "run" } },
  ["maven/java"] = { language = "java", type = "backend", expected = { "build", "test", "run" } },
  ["gradle/java"] = { language = "java", type = "backend", expected = { "build", "test", "run" } },
  go = { language = "go", type = "backend", expected = { "build", "test", "run", "lint" } },
  rust = { language = "rust", type = "backend", expected = { "build", "test", "run", "check", "clippy", "fmt" } },
  vite = { language = "node", type = "frontend", expected = { "dev", "build", "test", "lint", "typecheck" } },
  next = { language = "node", type = "frontend", expected = { "dev", "build", "test", "lint", "typecheck" } },
  react = { language = "node", type = "frontend", expected = { "dev", "build", "test", "lint", "typecheck" } },
  vue = { language = "node", type = "frontend", expected = { "dev", "build", "test", "lint", "typecheck" } },
  nuxt = { language = "node", type = "frontend", expected = { "dev", "build", "test", "lint", "typecheck" } },
  sveltekit = { language = "node", type = "frontend", expected = { "dev", "build", "test", "lint", "typecheck" } },
  astro = { language = "node", type = "frontend", expected = { "dev", "build", "test", "lint", "typecheck" } },
  nestjs = { language = "node", type = "backend", expected = { "dev", "build", "test", "lint", "typecheck" } },
  express = { language = "node", type = "backend", expected = { "dev", "build", "test", "lint" } },
  node = { language = "node", type = "node", expected = { "dev", "build", "test", "lint", "typecheck", "run" } },
  django = { language = "python", type = "backend", expected = { "dev", "test", "lint", "typecheck" } },
  python = { language = "python", type = "backend", expected = { "test", "lint", "typecheck", "run" } },
}

function M.for_framework(framework)
  return M.frameworks[framework or ""] or { language = "unknown", type = "unknown", expected = {} }
end

function M.language(name)
  return M.languages[name or ""] or { label = "Unknown", lsp = {}, markers = {}, quickfix = {}, terminal = {}, notes = "" }
end

return M
