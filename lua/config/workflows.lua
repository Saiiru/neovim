-- Project Workflows
-- Language-specific build/run/test workflows with mise integration
-- Smart project detection like JetBrains IDEs

local M = {}

M.detected_projects = {}
-- Tasks module integration
M.tasks = require("config.tasks")

-- Project detection patterns
M.project_patterns = {
  csharp = {
    files = { "*.sln", "*.csproj", "*.fsproj", "*.vbproj" },
    dirs = { "obj", "bin" },
    mise_tools = { "dotnet" },
    config_files = { "Directory.Build.props", "NuGet.config", "global.json" },
  },
  arduino = {
    files = { "*.ino", "*.pde", "platformio.ini", "CMakeLists.txt" },
    dirs = { ".pio", "build" },
    mise_tools = { "arduino-cli", "platformio" },
    config_files = { "platformio.ini", "arduino-cli.yaml" },
  },
  go = {
    files = { "go.mod", "go.work", "*.go" },
    dirs = { "vendor" },
    mise_tools = { "go" },
    config_files = { "go.mod", "go.sum", "Makefile" },
  },
  rust = {
    files = { "Cargo.toml", "*.rs" },
    dirs = { "target", ".cargo" },
    mise_tools = { "rust", "cargo" },
    config_files = { "Cargo.toml", "Cargo.lock", "rust-toolchain.toml" },
  },
  python = {
    files = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "poetry.lock", "*.py" },
    dirs = { ".venv", "venv", "__pycache__", ".pytest_cache" },
    mise_tools = { "python", "pipx", "poetry" },
    config_files = { "pyproject.toml", "requirements.txt", "Pipfile", "poetry.lock", "uv.lock" },
  },
  node = {
    files = { "package.json", "deno.json", "*.js", "*.ts", "*.jsx", "*.tsx" },
    dirs = { "node_modules", ".next", "dist", "build" },
    mise_tools = { "node", "pnpm", "yarn", "deno", "bun" },
    config_files = { "package.json", "pnpm-lock.yaml", "yarn.lock", "deno.json" },
  },
  cpp = {
    files = { "CMakeLists.txt", "meson.build", "Makefile", "*.cpp", "*.hpp", "*.c", "*.h" },
    dirs = { "build", "cmake-build-*" },
    mise_tools = { "cmake", "ninja", "ccache" },
    config_files = { "CMakeLists.txt", "meson.build", "conanfile.txt", "vcpkg.json" },
  },
  java = {
    files = { "pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle", "*.java" },
    dirs = { "target", "build", ".gradle" },
    mise_tools = { "java", "maven", "gradle" },
    config_files = { "pom.xml", "build.gradle", "gradle.properties" },
  },
  zig = {
    files = { "build.zig", "build.zig.zon", "*.zig" },
    dirs = { "zig-cache", "zig-out" },
    mise_tools = { "zig" },
    config_files = { "build.zig", "build.zig.zon" },
  },
  lua = {
    files = { "*.lua", "luarocks.toml", "lua-lock.json" },
    dirs = { "lua_modules", ".luarocks" },
    mise_tools = { "lua", "luarocks" },
    config_files = { "luarocks.toml", "stylua.toml", ".luarc.json" },
  },
  haskell = {
    files = { "*.cabal", "package.yaml", "stack.yaml", "*.hs", "*.lhs" },
    dirs = { ".stack-work", "dist-newstyle" },
    mise_tools = { "ghc", "cabal", "stack", "hlint" },
    config_files = { "*.cabal", "package.yaml", "stack.yaml", "hie.yaml" },
  },
  ocaml = {
    files = { "*.opam", "dune-project", "dune", "*.ml", "*.mli" },
    dirs = { "_build", ".opam" },
    mise_tools = { "ocaml", "opam", "dune", "ocaml-lsp" },
    config_files = { "*.opam", "dune-project", "dune" },
  },
  elixir = {
    files = { "mix.exs", "mix.lock", "*.ex", "*.exs" },
    dirs = { "_build", "deps" },
    mise_tools = { "elixir", "erlang", "mix", "iex" },
    config_files = { "mix.exs", "mix.lock" },
  },
  scala = {
    files = { "build.sbt", "build.sc", "*.scala", "*.sbt" },
    dirs = { "target", ".bloop", ".metals" },
    mise_tools = { "scala", "sbt", "coursier", "metals", "bloop" },
    config_files = { "build.sbt", "build.sc", "project/build.properties" },
  },
  kotlin = {
    files = { "build.gradle.kts", "settings.gradle.kts", "*.kt", "*.kts" },
    dirs = { "build", ".gradle" },
    mise_tools = { "kotlin", "gradle", "ktfmt" },
    config_files = { "build.gradle.kts", "settings.gradle.kts" },
  },
  dart = {
    files = { "pubspec.yaml", "pubspec.lock", "*.dart" },
    dirs = { ".dart_tool", "build" },
    mise_tools = { "dart", "flutter", "melos" },
    config_files = { "pubspec.yaml", "analysis_options.yaml" },
  },
  typescript = {
    files = { "tsconfig.json", "package.json", "*.ts", "*.tsx", "*.cts", "*.mts" },
    dirs = { "node_modules", "dist", "build", ".next" },
    mise_tools = { "node", "typescript", "tsx", "ts-node", "esbuild" },
    config_files = { "tsconfig.json", "package.json", "vitest.config.ts", "jest.config.ts" },
  },
  vue = {
    files = { "*.vue", "vite.config.ts", "nuxt.config.ts" },
    dirs = { "node_modules", ".output", ".nuxt" },
    mise_tools = { "node", "vue", "vite", "nuxt" },
    config_files = { "vite.config.ts", "nuxt.config.ts", "package.json" },
  },
  svelte = {
    files = { "*.svelte", "svelte.config.js", "vite.config.ts" },
    dirs = { "node_modules", ".svelte-kit", "build" },
    mise_tools = { "node", "svelte", "vite" },
    config_files = { "svelte.config.js", "vite.config.ts", "package.json" },
  },
  astro = {
    files = { "astro.config.mjs", "*.astro", "package.json" },
    dirs = { "node_modules", "dist", ".astro" },
    mise_tools = { "node", "astro" },
    config_files = { "astro.config.mjs", "package.json" },
  },
  solid = {
    files = { "*.tsx", "vite.config.ts", "package.json" },
    dirs = { "node_modules", "dist", ".solid" },
    mise_tools = { "node", "solid", "vite" },
    config_files = { "vite.config.ts", "package.json" },
  },
  qwik = {
    files = { "*.tsx", "vite.config.ts", "package.json" },
    dirs = { "node_modules", "dist", ".qwik" },
    mise_tools = { "node", "qwik", "vite" },
    config_files = { "vite.config.ts", "package.json" },
  },
  deno = {
    files = { "deno.json", "deno.jsonc", "import_map.json", "*.ts" },
    dirs = { ".deno" },
    mise_tools = { "deno" },
    config_files = { "deno.json", "deno.jsonc", "import_map.json" },
  },
  bun = {
    files = { "bun.lockb", "bunfig.toml", "package.json", "*.ts" },
    dirs = { "node_modules", ".bun" },
    mise_tools = { "bun" },
    config_files = { "bun.lockb", "bunfig.toml", "package.json" },
  },
  swift = {
    files = { "Package.swift", "*.swift", "*.xcodeproj", "*.xcworkspace" },
    dirs = { ".build", "DerivedData", ".swiftpm" },
    mise_tools = { "swift", "swiftformat", "swiftlint" },
    config_files = { "Package.swift", ".swiftlint.yml" },
  },
}

-- Detect project type in current directory and parents
function M.detect_project(start_dir)
  start_dir = start_dir or vim.fn.getcwd()
  local current = start_dir
  local detected = {}

  while current and current ~= "/" do
    for lang, patterns in pairs(M.project_patterns) do
      if not detected[lang] then
        -- Check files
        for _, pattern in ipairs(patterns.files) do
          local matches = vim.fn.glob(current .. "/" .. pattern, false, true)
          if #matches > 0 then
            detected[lang] = {
              root = current,
              type = lang,
              files = matches,
              config_files = {},
              tools = patterns.mise_tools,
            }
            break
          end
        end
        -- Check dirs
        if not detected[lang] then
          for _, dir in ipairs(patterns.dirs) do
            if vim.fn.isdirectory(current .. "/" .. dir) == 1 then
              detected[lang] = {
                root = current,
                type = lang,
                files = {},
                config_files = {},
                tools = patterns.mise_tools,
              }
              break
            end
          end
        end
        -- Check config files
        if not detected[lang] then
          for _, cf in ipairs(patterns.config_files) do
            if vim.fn.filereadable(current .. "/" .. cf) == 1 then
              detected[lang] = {
                root = current,
                type = lang,
                files = {},
                config_files = { cf },
                tools = patterns.mise_tools,
              }
              break
            end
          end
        end
      end
    end

    -- Move to parent
    local parent = vim.fn.fnamemodify(current, ":h")
    if parent == current then
      break
    end
    current = parent
  end

  return detected
end

-- Get mise tools for current project
function M.get_mise_tools()
  local detected = M.detect_project()
  local tools = {}
  for _, info in pairs(detected) do
    for _, tool in ipairs(info.tools) do
      tools[tool] = true
    end
  end
  return vim.tbl_keys(tools)
end

-- Check if mise tool is available
function M.has_mise_tool(tool)
  return vim.fn.executable("mise") == 1 and vim.fn.system("mise which " .. tool .. " 2>/dev/null"):match(tool) ~= nil
end

-- Execute mise command in project root
function M.mise_exec(project_root, cmd, args)
  local full_cmd = { "mise", "exec", "--cd", project_root, "--", cmd }
  if args then
    vim.list_extend(full_cmd, args)
  end
  return vim.fn.system(full_cmd)
end

-- Language-specific workflows
M.workflows = {
  csharp = {
    name = "C# (.NET)",
    icon = "󰌛",
    detect = function()
      return M.detect_project().csharp
    end,
    commands = {
      build = { "dotnet", "build", "--no-restore" },
      run = { "dotnet", "run", "--no-build" },
      test = { "dotnet", "test", "--no-build" },
      clean = { "dotnet", "clean" },
      restore = { "dotnet", "restore" },
      publish = { "dotnet", "publish", "-c", "Release" },
      watch = { "dotnet", "watch", "run" },
      format = { "dotnet", "format" },
      add_package = function(pkg)
        return { "dotnet", "add", "package", pkg }
      end,
      remove_package = function(pkg)
        return { "dotnet", "remove", "package", pkg }
      end,
      new_project = function(template, name)
        return { "dotnet", "new", template, "-n", name }
      end,
      list_templates = { "dotnet", "new", "list" },
    },
    lsp = "csharp_ls",
    debugger = "netcoredbg",
  },
  arduino = {
    name = "Arduino / ESP32",
    icon = "󰜺",
    detect = function()
      return M.detect_project().arduino
    end,
    commands = {
      -- PlatformIO
      pio_build = { "pio", "run" },
      pio_upload = { "pio", "run", "-t", "upload" },
      pio_monitor = { "pio", "device", "monitor" },
      pio_clean = { "pio", "run", "-t", "clean" },
      pio_test = { "pio", "test" },
      -- Arduino CLI (dynamic port/FQBN detection)
      arduino_compile = function()
        local board = M.detect_arduino_board()
        local fqbn = board and board.fqbn or "arduino:avr:uno"
        return { "arduino-cli", "compile", "--fqbn", fqbn }
      end,
      arduino_upload = function()
        local board = M.detect_arduino_board()
        if not board then
          vim.notify("No Arduino board detected", vim.log.levels.WARN)
          return {}
        end
        return { "arduino-cli", "upload", "-p", board.port, "--fqbn", board.fqbn }
      end,
      arduino_monitor = function()
        local board = M.detect_arduino_board()
        local port = board and board.port or "/dev/arduino"
        local baud = board and board.fqbn:match("esp32") and "115200" or "9600"
        return { "arduino-cli", "monitor", "-p", port, "-c", "baudrate=" .. baud }
      end,
      -- Quick compile/upload/monitor for current detected board
      build = function()
        return M.workflows.arduino.commands.arduino_compile()
      end,
      upload = function()
        return M.workflows.arduino.commands.arduino_upload()
      end,
      monitor = function()
        return M.workflows.arduino.commands.arduino_monitor()
      end,
      -- Board management
      arduino_core_update = { "arduino-cli", "core", "update-index" },
      arduino_lib_install = function(lib)
        return { "arduino-cli", "lib", "install", lib }
      end,
      arduino_lib_list = { "arduino-cli", "lib", "list" },
      arduino_board_list = { "arduino-cli", "board", "list", "--format", "json" },
      arduino_board_search = function(query)
        return { "arduino-cli", "board", "search", query }
      end,
      -- ESP32 specific FQBN helpers (for manual override)
      esp32_compile = function(variant)
        local fqbns = {
          dev = "esp32:esp32:esp32",
          cam = "esp32:esp32:esp32cam",
          s3 = "esp32:esp32:esp32s3",
          s2 = "esp32:esp32:esp32s2",
          c3 = "esp32:esp32:esp32c3",
          c6 = "esp32:esp32:esp32c6",
          h2 = "esp32:esp32:esp32h2",
          p4 = "esp32:esp32:esp32p4",
          m5stack = "esp32:esp32:m5stack-core-esp32",
          m5atom = "esp32:esp32:m5stack-atom",
          m5stamps3 = "esp32:esp32:m5stack-stamps3",
          xiao_c3 = "esp32:esp32:seeed-xiao-esp32c3",
          xiao_s3 = "esp32:esp32:seeed-xiao-esp32s3",
          wt32 = "esp32:esp32:wt32-eth01",
        }
        local fqbn = fqbns[variant or "dev"] or fqbns.dev
        return { "arduino-cli", "compile", "--fqbn", fqbn }
      end,
      esp32_upload = function(variant)
        local board = M.detect_arduino_board()
        if not board then
          vim.notify("No board detected for upload", vim.log.levels.WARN)
          return {}
        end
        local fqbns = {
          dev = "esp32:esp32:esp32",
          cam = "esp32:esp32:esp32cam",
          s3 = "esp32:esp32:esp32s3",
          s2 = "esp32:esp32:esp32s2",
          c3 = "esp32:esp32:esp32c3",
          c6 = "esp32:esp32:esp32c6",
          h2 = "esp32:esp32:esp32h2",
          p4 = "esp32:esp32:esp32p4",
          m5stack = "esp32:esp32:m5stack-core-esp32",
          m5atom = "esp32:esp32:m5stack-atom",
          m5stamps3 = "esp32:esp32:m5stack-stamps3",
          xiao_c3 = "esp32:esp32:seeed-xiao-esp32c3",
          xiao_s3 = "esp32:esp32:seeed-xiao-esp32s3",
          wt32 = "esp32:esp32:wt32-eth01",
        }
        local fqbn = fqbns[variant or "dev"] or fqbns.dev
        return { "arduino-cli", "upload", "-p", board.port, "--fqbn", fqbn }
      end,
      -- Serial monitor helpers
      monitor_esp32 = function()
        local board = M.detect_arduino_board()
        local port = board and board.port or "/dev/esp32"
        return { "arduino-cli", "monitor", "-p", port, "-c", "baudrate=115200" }
      end,
      monitor_uno = function()
        local board = M.detect_arduino_board()
        local port = board and board.port or "/dev/arduino"
        return { "arduino-cli", "monitor", "-p", port, "-c", "baudrate=9600" }
      end,
      detect_boards = { "arduino-cli", "board", "list", "--format", "json" },
      arduino_compiledb = function()
        if vim.fn.filereadable("platformio.ini") == 1 then
          return { "pio", "run", "-t", "compiledb" }
        else
          vim.notify("compile_commands.json only supported for PlatformIO projects", vim.log.levels.WARN)
          return {}
        end
      end,
    },
    lsp = "clangd",
    auto_detect_board = true,
  },
  go = {
    name = "Go",
    icon = "󰟓",
    detect = function()
      return M.detect_project().go
    end,
    commands = {
      build = { "go", "build", "./..." },
      run = { "go", "run", "." },
      test = { "go", "test", "-v", "./..." },
      test_cover = { "go", "test", "-coverprofile=coverage.out", "./..." },
      clean = { "go", "clean", "./..." },
      tidy = { "go", "mod", "tidy" },
      vendor = { "go", "mod", "vendor" },
      fmt = { "gofmt", "-w", "." },
      vet = { "go", "vet", "./..." },
      lint = { "golangci-lint", "run" },
      generate = { "go", "generate", "./..." },
      install = { "go", "install", "." },
    },
    lsp = "gopls",
  },
  rust = {
    name = "Rust",
    icon = "󱘗",
    detect = function()
      return M.detect_project().rust
    end,
    commands = {
      build = { "cargo", "build" },
      run = { "cargo", "run" },
      test = { "cargo", "test" },
      test_all = { "cargo", "test", "--all-targets" },
      clean = { "cargo", "clean" },
      check = { "cargo", "check" },
      clippy = { "cargo", "clippy", "--all-targets", "--all-features" },
      fmt = { "cargo", "fmt", "--all" },
      doc = { "cargo", "doc", "--no-deps", "--open" },
      update = { "cargo", "update" },
      bench = { "cargo", "bench" },
      release = { "cargo", "build", "--release" },
    },
    lsp = "rust_analyzer",
  },
  python = {
    name = "Python",
    icon = "󰌠",
    detect = function()
      return M.detect_project().python
    end,
    commands = {
      run = { "python", "-m" },
      test = { "pytest", "-v" },
      test_cov = { "pytest", "--cov=.", "--cov-report=term-missing" },
      lint = { "ruff", "check", "." },
      fmt = { "ruff", "format", "." },
      typecheck = { "mypy", "." },
      install = { "pip", "install", "-e", "." },
      install_dev = { "pip", "install", "-e", ".[dev]" },
      freeze = { "pip", "freeze", ">", "requirements.txt" },
      uv_sync = { "uv", "sync" },
      uv_add = function(pkg)
        return { "uv", "add", pkg }
      end,
      uv_remove = function(pkg)
        return { "uv", "remove", pkg }
      end,
      uv_run = function(...)
        return { "uv", "run", ... }
      end,
    },
    lsp = { "basedpyright", "ruff" },
  },
  node = {
    name = "Node.js / TypeScript",
    icon = "󰌞",
    detect = function()
      return M.detect_project().node
    end,
    commands = {
      dev = { "npm", "run", "dev" },
      build = { "npm", "run", "build" },
      preview = { "npm", "run", "preview" },
      test = { "npm", "test" },
      test_watch = { "npm", "run", "test:watch" },
      lint = { "npm", "run", "lint" },
      fmt = { "npm", "run", "format" },
      typecheck = { "npm", "run", "typecheck" },
      install = { "npm", "install" },
      update = { "npm", "update" },
      clean = { "rm", "-rf", "node_modules", "dist", "build", ".next" },
      pnpm_dev = { "pnpm", "dev" },
      pnpm_build = { "pnpm", "build" },
    },
    lsp = { "ts_ls", "vtsls", "biome", "oxlint" },
  },
  cpp = {
    name = "C/C++",
    icon = "󰙲",
    detect = function()
      return M.detect_project().cpp
    end,
    commands = {
      cmake_configure = { "cmake", "-B", "build", "-DCMAKE_BUILD_TYPE=Debug" },
      cmake_build = { "cmake", "--build", "build", "-j" },
      cmake_release = { "cmake", "-B", "build", "-DCMAKE_BUILD_TYPE=Release" },
      cmake_clean = { "rm", "-rf", "build" },
      make = { "make", "-j" },
      ninja = { "ninja", "-C", "build" },
      run = { "./build/main" },
      test = { "ctest", "--output-on-failure", "--test-dir", "build" },
      format = { "clang-format", "-i", "." },
      tidy = { "clang-tidy", "." },
    },
    lsp = "clangd",
  },
  java = {
    name = "Java",
    icon = "󰬷",
    detect = function()
      return M.detect_project().java
    end,
    commands = {
      maven_build = { "mvn", "clean", "compile" },
      maven_test = { "mvn", "test" },
      maven_package = { "mvn", "package", "-DskipTests" },
      maven_install = { "mvn", "install", "-DskipTests" },
      maven_clean = { "mvn", "clean" },
      gradle_build = { "./gradlew", "build" },
      gradle_test = { "./gradlew", "test" },
      gradle_run = { "./gradlew", "run" },
      gradle_clean = { "./gradlew", "clean" },
    },
    lsp = "jdtls",
  },
  haskell = {
    name = "Haskell",
    icon = "󰧑",
    detect = function()
      return M.detect_project().haskell
    end,
    commands = {
      build = { "cabal", "build" },
      run = { "cabal", "run" },
      test = { "cabal", "test" },
      repl = { "cabal", "repl" },
      clean = { "cabal", "clean" },
      lint = { "hlint", "." },
      format = { "ormolu", "-i", "." },
      stack_build = { "stack", "build" },
      stack_test = { "stack", "test" },
      stack_repl = { "stack", "repl" },
    },
    lsp = "hls",
  },
  ocaml = {
    name = "OCaml",
    icon = "󰘧",
    detect = function()
      return M.detect_project().ocaml
    end,
    commands = {
      build = { "dune", "build" },
      run = { "dune", "exec" },
      test = { "dune", "runtest" },
      clean = { "dune", "clean" },
      format = { "dune", "build", "@fmt", "--auto-promote" },
      utop = { "dune", "utop" },
      opam_install = { "opam", "install", "." },
    },
    lsp = "ocamllsp",
  },
  elixir = {
    name = "Elixir",
    icon = "󰭱",
    detect = function()
      return M.detect_project().elixir
    end,
    commands = {
      build = { "mix", "compile" },
      run = { "mix", "run" },
      test = { "mix", "test" },
      clean = { "mix", "clean" },
      deps_get = { "mix", "deps.get" },
      deps_update = { "mix", "deps.update", "--all" },
      format = { "mix", "format" },
      credo = { "mix", "credo" },
      dialyzer = { "mix", "dialyzer" },
      iex = { "iex", "-S", "mix" },
    },
    lsp = "elixirls",
  },
  scala = {
    name = "Scala",
    icon = "󰜊",
    detect = function()
      return M.detect_project().scala
    end,
    commands = {
      build = { "sbt", "compile" },
      test = { "sbt", "test" },
      run = { "sbt", "run" },
      clean = { "sbt", "clean" },
      fmt = { "scalafmt", "all" },
      scalafix = { "scalafix", "all" },
      metals_compile = { "bloop", "compile" },
    },
    lsp = "metals",
  },
  kotlin = {
    name = "Kotlin",
    icon = "󰬘",
    detect = function()
      return M.detect_project().kotlin
    end,
    commands = {
      build = { "./gradlew", "build" },
      test = { "./gradlew", "test" },
      run = { "./gradlew", "run" },
      clean = { "./gradlew", "clean" },
      ktfmt = { "ktfmt", "-i", "." },
      detekt = { "./gradlew", "detekt" },
    },
    lsp = "kotlin_lsp",
  },
  dart = {
    name = "Dart / Flutter",
    icon = "󰙥",
    detect = function()
      return M.detect_project().dart
    end,
    commands = {
      build = { "dart", "compile", "exe" },
      run = { "dart", "run" },
      test = { "dart", "test" },
      clean = { "dart", "clean" },
      pub_get = { "dart", "pub", "get" },
      pub_upgrade = { "dart", "pub", "upgrade" },
      format = { "dart", "format", "." },
      analyze = { "dart", "analyze" },
      flutter_build = { "flutter", "build" },
      flutter_run = { "flutter", "run" },
      flutter_test = { "flutter", "test" },
    },
    lsp = "dartls",
  },
  typescript = {
    name = "TypeScript",
    icon = "󰛦",
    detect = function()
      return M.detect_project().typescript
    end,
    commands = {
      build = { "tsc", "--noEmit" },
      check = { "tsc", "--noEmit" },
      test = { "vitest", "run" },
      test_watch = { "vitest" },
      lint = { "eslint", "." },
      format = { "prettier", "--write", "." },
      dev = { "tsx", "watch", "src/index.ts" },
    },
    lsp = { "ts_ls", "vtsls", "biome", "oxlint" },
  },
  vue = {
    name = "Vue",
    icon = "󰡄",
    detect = function()
      return M.detect_project().vue
    end,
    commands = {
      dev = { "npm", "run", "dev" },
      build = { "npm", "run", "build" },
      preview = { "npm", "run", "preview" },
      lint = { "npm", "run", "lint" },
      format = { "npm", "run", "format" },
      typecheck = { "npm", "run", "typecheck" },
    },
    lsp = { "ts_ls", "vtsls", "volar" },
  },
  svelte = {
    name = "Svelte",
    icon = "󰔷",
    detect = function()
      return M.detect_project().svelte
    end,
    commands = {
      dev = { "npm", "run", "dev" },
      build = { "npm", "run", "build" },
      preview = { "npm", "run", "preview" },
      check = { "svelte-check" },
      format = { "prettier", "--write", "." },
      lint = { "eslint", "." },
    },
    lsp = { "ts_ls", "vtsls", "svelte" },
  },
  astro = {
    name = "Astro",
    icon = "󱓟",
    detect = function()
      return M.detect_project().astro
    end,
    commands = {
      dev = { "npm", "run", "dev" },
      build = { "npm", "run", "build" },
      preview = { "npm", "run", "preview" },
      check = { "npm", "run", "check" },
      format = { "prettier", "--write", "." },
      lint = { "eslint", "." },
    },
    lsp = { "ts_ls", "vtsls", "astro" },
  },
  solid = {
    name = "SolidJS",
    icon = "󰘚",
    detect = function()
      return M.detect_project().solid
    end,
    commands = {
      dev = { "npm", "run", "dev" },
      build = { "npm", "run", "build" },
      preview = { "npm", "run", "preview" },
      check = { "npm", "run", "check" },
      format = { "prettier", "--write", "." },
    },
    lsp = { "ts_ls", "vtsls" },
  },
  qwik = {
    name = "Qwik",
    icon = "⚡",
    detect = function()
      return M.detect_project().qwik
    end,
    commands = {
      dev = { "npm", "run", "dev" },
      build = { "npm", "run", "build" },
      preview = { "npm", "run", "preview" },
      check = { "npm", "run", "check" },
      format = { "prettier", "--write", "." },
    },
    lsp = { "ts_ls", "vtsls" },
  },
  deno = {
    name = "Deno",
    icon = "",
    detect = function()
      return M.detect_project().deno
    end,
    commands = {
      run = { "deno", "run", "--allow-all" },
      test = { "deno", "test", "--allow-all" },
      fmt = { "deno", "fmt" },
      lint = { "deno", "lint" },
      check = { "deno", "check" },
      install = { "deno", "install" },
      compile = { "deno", "compile" },
    },
    lsp = "deno",
  },
  bun = {
    name = "Bun",
    icon = "󰴂",
    detect = function()
      return M.detect_project().bun
    end,
    commands = {
      run = { "bun", "run" },
      test = { "bun", "test" },
      build = { "bun", "build" },
      install = { "bun", "install" },
      lint = { "bunx", "eslint", "." },
      fmt = { "bunx", "prettier", "--write", "." },
    },
    lsp = { "ts_ls", "vtsls", "biome" },
  },
  swift = {
    name = "Swift",
    icon = "󰀵",
    detect = function()
      return M.detect_project().swift
    end,
    commands = {
      build = { "swift", "build" },
      run = { "swift", "run" },
      test = { "swift", "test" },
      clean = { "swift", "package", "clean" },
      format = { "swiftformat", "." },
      lint = { "swiftlint", "lint" },
      xcode = { "xcodebuild" },
    },
    lsp = "sourcekit",
  },
}

-- Run workflow command
function M.run_command(lang, command_name, ...)
  local workflow = M.workflows[lang]
  if not workflow then
    vim.notify("Workflow not found for " .. lang, vim.log.levels.ERROR)
    return
  end

  local cmd = workflow.commands[command_name]
  if not cmd then
    vim.notify("Command '" .. command_name .. "' not found for " .. lang, vim.log.levels.ERROR)
    return
  end

  local project = M.detect_project()
  local proj = project[lang]
  local root = proj and proj.root or vim.fn.getcwd()

  -- Handle function commands
  local final_cmd
  if type(cmd) == "function" then
    final_cmd = cmd(...)
  else
    final_cmd = vim.deepcopy(cmd)
  end

  -- Execute in terminal
  local term_cmd = table.concat(final_cmd, " ")
  vim.cmd("split | terminal cd " .. vim.fn.shellescape(root) .. " && " .. term_cmd)
  vim.notify("▶ " .. workflow.icon .. " " .. lang .. ": " .. term_cmd, vim.log.levels.INFO)
end

-- Quick command picker
function M.pick_command()
  local detected = M.detect_project()
  local items = {}

  for lang, workflow in pairs(M.workflows) do
    if detected[lang] then
      for name, cmd in pairs(workflow.commands) do
        local desc = type(cmd) == "function" and "<function>" or table.concat(vim.islist(cmd) and cmd or { "" }, " ")
        table.insert(items, {
          text = workflow.icon .. " " .. lang .. " › " .. name,
          desc = desc,
          lang = lang,
          cmd = name,
        })
      end
    end
  end

  if #items == 0 then
    vim.notify("No workflows detected for current project", vim.log.levels.WARN)
    return
  end

  vim.ui.select(items, {
    prompt = "Select workflow command:",
    format_item = function(item)
      return item.text
    end,
  }, function(choice)
    if choice then
      M.run_command(choice.lang, choice.cmd)
    end
  end)
end

-- Auto-detect and show project info
function M.show_project_info()
  local detected = M.detect_project()
  if vim.tbl_isempty(detected) then
    vim.notify("No project detected", vim.log.levels.INFO)
    return
  end

  local lines = {
    "╔══════════════════════════════════════════════════════════════════╗",
    "║                    PROJECT DETECTED                               ║",
    "╠══════════════════════════════════════════════════════════════════╣",
  }
  for lang, info in pairs(detected) do
    local wf = M.workflows[lang]
    table.insert(lines, "║  " .. (wf and wf.icon or "●") .. " " .. lang .. "  ›  " .. info.root)
    if #info.config_files > 0 then
      table.insert(lines, "║     Config: " .. table.concat(info.config_files, ", "))
    end
    if #info.files > 0 then
      table.insert(lines, "║     Files: " .. #info.files .. " matched")
    end
  end
  table.insert(
    lines,
    "╚══════════════════════════════════════════════════════════════════╝"
  )

  local win = vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
    relative = "editor",
    width = 70,
    height = #lines + 2,
    row = 2,
    col = vim.o.columns - 72,
    border = "rounded",
    title = " PROJECT INFO ",
    title_pos = "center",
    style = "minimal",
  })
  vim.api.nvim_buf_set_lines(vim.api.nvim_win_get_buf(win), 0, -1, false, lines)
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = vim.api.nvim_win_get_buf(win), silent = true })
  vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = vim.api.nvim_win_get_buf(win), silent = true })
end

-- Arduino board auto-detection (enhanced)
function M.detect_arduino_board()
  local output = vim.fn.system("arduino-cli board list --format json 2>/dev/null")
  local ok, data = pcall(vim.fn.json_decode, output)
  if ok and data and data.ports then
    for _, port in ipairs(data.ports) do
      if port.matching_boards and #port.matching_boards > 0 then
        local board = port.matching_boards[1]
        local fqbn = board.fqbn
        -- Extract ESP32 variant from FQBN
        local variant = nil
        if fqbn:match("^esp32:") then
          variant = fqbn:match("esp32:esp32:([^:]+)")
        end
        return {
          port = port.port.address,
          fqbn = fqbn,
          name = board.name,
          variant = variant,
          is_esp32 = fqbn:match("^esp32:") ~= nil,
          is_uno = fqbn:match("^arduino:avr:") ~= nil,
        }
      end
    end
  end
  return nil
end

-- List all detected boards with details
function M.list_arduino_boards()
  local output = vim.fn.system("arduino-cli board list --format json 2>/dev/null")
  local ok, data = pcall(vim.fn.json_decode, output)
  local boards = {}
  if ok and data and data.ports then
    for _, port in ipairs(data.ports) do
      if port.matching_boards and #port.matching_boards > 0 then
        for _, board in ipairs(port.matching_boards) do
          table.insert(boards, {
            port = port.port.address,
            fqbn = board.fqbn,
            name = board.name,
            variant = board.fqbn:match("^esp32:") and board.fqbn:match("esp32:esp32:([^:]+)") or nil,
          })
        end
      else
        -- Port with no matching board (maybe needs driver/core)
        table.insert(boards, {
          port = port.port.address,
          fqbn = "unknown",
          name = "Unknown Board",
          variant = nil,
        })
      end
    end
  end
  return boards
end

-- Project-specific keymaps (attached on project detection)
function M.setup_project_keymaps()
  local detected = M.detect_project()
  local maps = {}

  -- Universal workflow keymaps
  maps["<leader>pr"] = {
    function()
      M.pick_command()
    end,
    "🔧 Project commands",
  }
  maps["<leader>pi"] = {
    function()
      M.show_project_info()
    end,
    "📋 Project info",
  }

  -- Language-specific keymaps (only appear when relevant)
  if detected.csharp then
    maps["<leader>cb"] = {
      function()
        M.run_command("csharp", "build")
      end,
      "󰌛 Build .NET",
    }
    maps["<leader>cr"] = {
      function()
        M.run_command("csharp", "run")
      end,
      "󰌛 Run .NET",
    }
    maps["<leader>ct"] = {
      function()
        M.run_command("csharp", "test")
      end,
      "󰌛 Test .NET",
    }
    maps["<leader>cw"] = {
      function()
        M.run_command("csharp", "watch")
      end,
      "󰌛 Watch .NET",
    }
  end

  if detected.arduino then
    maps["<leader>ab"] = {
      function()
        M.run_command("arduino", "pio_build")
      end,
      "󰜺 Arduino Build",
    }
    maps["<leader>au"] = {
      function()
        M.run_command("arduino", "pio_upload")
      end,
      "󰜺 Arduino Upload",
    }
    maps["<leader>am"] = {
      function()
        M.run_command("arduino", "pio_monitor")
      end,
      "󰜺 Serial Monitor",
    }
    maps["<leader>ac"] = {
      function()
        M.run_command("arduino", "pio_clean")
      end,
      "󰜺 Clean",
    }
    maps["<leader>ad"] = {
      function()
        local board = M.detect_arduino_board()
        if board then
          vim.notify(
            "📟 Board: " .. board.name .. " (" .. board.port .. ") [" .. board.fqbn .. "]",
            vim.log.levels.INFO
          )
        else
          vim.notify("No Arduino board detected", vim.log.levels.WARN)
        end
      end,
      "󰜺 Detect Board",
    }
  end

  if detected.go then
    maps["<leader>gb"] = {
      function()
        M.run_command("go", "build")
      end,
      "󰟓 Go Build",
    }
    maps["<leader>gr"] = {
      function()
        M.run_command("go", "run")
      end,
      "󰟓 Go Run",
    }
    maps["<leader>gt"] = {
      function()
        M.run_command("go", "test")
      end,
      "󰟓 Go Test",
    }
  end

  if detected.rust then
    maps["<leader>rb"] = {
      function()
        M.run_command("rust", "build")
      end,
      "󱘗 Cargo Build",
    }
    maps["<leader>rr"] = {
      function()
        M.run_command("rust", "run")
      end,
      "󱘗 Cargo Run",
    }
    maps["<leader>rt"] = {
      function()
        M.run_command("rust", "test")
      end,
      "󱘗 Cargo Test",
    }
    maps["<leader>rc"] = {
      function()
        M.run_command("rust", "check")
      end,
      "󱘗 Cargo Check",
    }
    maps["<leader>rl"] = {
      function()
        M.run_command("rust", "clippy")
      end,
      "󱘗 Clippy",
    }
  end

  if detected.python then
    maps["<leader>py"] = {
      function()
        M.run_command("python", "run")
      end,
      "󰌠 Python Run",
    }
    maps["<leader>pt"] = {
      function()
        M.run_command("python", "test")
      end,
      "󰌠 Pytest",
    }
    maps["<leader>pl"] = {
      function()
        M.run_command("python", "lint")
      end,
      "󰌠 Ruff Lint",
    }
    maps["<leader>pf"] = {
      function()
        M.run_command("python", "fmt")
      end,
      "󰌠 Ruff Format",
    }
  end

  if detected.node then
    maps["<leader>nd"] = {
      function()
        M.run_command("node", "dev")
      end,
      "󰌞 Dev Server",
    }
    maps["<leader>nb"] = {
      function()
        M.run_command("node", "build")
      end,
      "󰌞 Build",
    }
    maps["<leader>nt"] = {
      function()
        M.run_command("node", "test")
      end,
      "󰌞 Test",
    }
  end

  if detected.cpp then
    maps["<leader>cb"] = {
      function()
        M.run_command("cpp", "cmake_configure")
      end,
      "CMake Configure",
    }
    maps["<leader>cm"] = {
      function()
        M.run_command("cpp", "cmake_build")
      end,
      "CMake Build",
    }
    maps["<leader>cr"] = {
      function()
        M.run_command("cpp", "run")
      end,
      "Run Binary",
    }
    maps["<leader>ct"] = {
      function()
        M.run_command("cpp", "test")
      end,
      "CTest",
    }
  end

  -- Apply keymaps only if project detected
  for lhs, rhs in pairs(maps) do
    vim.keymap.set("n", lhs, rhs[1], { desc = rhs[2], silent = true })
  end
end

-- Auto-detect on directory change
function M.setup_autocmds()
  vim.api.nvim_create_autocmd("DirChanged", {
    callback = function()
      vim.defer_fn(function()
        M.setup_project_keymaps()
      end, 100)
    end,
  })

  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      vim.defer_fn(function()
        M.setup_project_keymaps()
        M.show_project_info()
      end, 500)
    end,
    once = true,
  })
end

function M.setup()
  M.setup_autocmds()

  -- User commands
  vim.api.nvim_create_user_command("ProjectDetect", M.show_project_info, { desc = "Detect project" })
  vim.api.nvim_create_user_command("ProjectCommands", M.pick_command, { desc = "Pick project command" })
  vim.api.nvim_create_user_command("ProjectKeymaps", M.setup_project_keymaps, { desc = "Setup project keymaps" })
end

return M
