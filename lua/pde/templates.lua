local M = {}

local function task(body)
  return "#!/usr/bin/env bash\nset -euo pipefail\n" .. body
end

M.catalog = {
  node = {
    label = "Node/TypeScript",
    language = "TypeScript/Node",
    runtime = "node via mise/project PATH",
    files = {
      ["package.json"] = [[{"scripts":{"dev":"node src/main.js","build":"node --check src/main.js","test":"node --test","lint":"node --check src/main.js"},"devDependencies":{}}]],
      ["src/main.js"] = [[console.log("vega node ready");
]],
      ["mise/tasks/build"] = task([[npm run build
]]),
      ["mise/tasks/test"] = task([[npm test
]]),
      ["mise/tasks/lint"] = task([[npm run lint
]]),
      ["mise/tasks/dev"] = task([[npm run dev
]]),
      ["README.md"] = [[# Node PDE project

Commands:

```sh
mise run build
mise run test
mise run lint
mise run dev
```
]],
    },
  },
  vite = {
    label = "Vite TypeScript",
    language = "TypeScript/browser",
    runtime = "node/npm via mise/project PATH",
    files = {
      ["package.json"] = [[{"scripts":{"dev":"vite --host 127.0.0.1","build":"tsc --noEmit && vite build","test":"node --test","lint":"tsc --noEmit","typecheck":"tsc --noEmit"},"dependencies":{},"devDependencies":{"@vitejs/plugin-react":"latest","typescript":"latest","vite":"latest"}}]],
      ["index.html"] = [[<div id="app"></div><script type="module" src="/src/main.ts"></script>
]],
      ["src/main.ts"] = [[const app = document.querySelector<HTMLDivElement>("#app");
if (app) app.textContent = "VEGA Vite ready";
]],
      ["tsconfig.json"] = [[{"compilerOptions":{"target":"ES2022","module":"ESNext","moduleResolution":"Bundler","strict":true,"jsx":"react-jsx"},"include":["src"]}]],
      ["mise/tasks/build"] = task([[npm run build
]]),
      ["mise/tasks/test"] = task([[npm test
]]),
      ["mise/tasks/lint"] = task([[npm run lint
]]),
      ["mise/tasks/typecheck"] = task([[npm run typecheck
]]),
      ["mise/tasks/dev"] = task([[npm run dev
]]),
      ["README.md"] = [[# Vite PDE project

Install dependencies explicitly when ready. VEGA does not install automatically.
]],
    },
  },
  next = {
    label = "Next.js TypeScript",
    language = "TypeScript/React",
    runtime = "node/npm via mise/project PATH",
    files = {
      ["package.json"] = [[{"scripts":{"dev":"next dev -H 127.0.0.1","build":"next build","test":"node --test","lint":"npm run typecheck","typecheck":"tsc --noEmit"},"dependencies":{"next":"latest","react":"latest","react-dom":"latest"},"devDependencies":{"typescript":"latest","@types/node":"latest","@types/react":"latest","@types/react-dom":"latest"}}]],
      ["app/page.tsx"] = [[export default function Page() {
  return <main>VEGA Next ready</main>;
}
]],
      ["tsconfig.json"] = [[{"compilerOptions":{"target":"ES2022","lib":["dom","dom.iterable","esnext"],"allowJs":true,"skipLibCheck":true,"strict":true,"noEmit":true,"module":"esnext","moduleResolution":"bundler","jsx":"preserve"},"include":["next-env.d.ts","**/*.ts","**/*.tsx"],"exclude":["node_modules"]}]],
      ["mise/tasks/build"] = task([[npm run build
]]),
      ["mise/tasks/test"] = task([[npm test
]]),
      ["mise/tasks/lint"] = task([[npm run lint
]]),
      ["mise/tasks/typecheck"] = task([[npm run typecheck
]]),
      ["mise/tasks/dev"] = task([[npm run dev
]]),
      ["README.md"] = [[# Next PDE project

Local-first Next template. Run installs manually when ready.
]],
    },
  },
  go = {
    label = "Go CLI/service",
    language = "Go",
    runtime = "go via mise/project PATH",
    files = {
      ["go.mod"] = [[module example.local/vega-go

go 1.22
]],
      ["main.go"] = [[package main

import "fmt"

func main() { fmt.Println("vega go ready") }
]],
      ["mise/tasks/build"] = task([[go build ./...
]]),
      ["mise/tasks/test"] = task([[go test ./...
]]),
      ["mise/tasks/lint"] = task([[go vet ./...
]]),
      ["mise/tasks/dev"] = task([[go run .
]]),
      ["README.md"] = [[# Go PDE project
]],
    },
  },
  rust = {
    label = "Rust crate",
    language = "Rust",
    runtime = "cargo/rustc via mise/project PATH",
    files = {
      ["Cargo.toml"] = [[[package]
name = "vega_rust"
version = "0.1.0"
edition = "2021"

[dependencies]
]],
      ["src/main.rs"] = [[fn main() {
    println!("vega rust ready");
}
]],
      ["mise/tasks/build"] = task([[cargo build
]]),
      ["mise/tasks/test"] = task([[cargo test
]]),
      ["mise/tasks/lint"] = task([[cargo clippy -- -D warnings
]]),
      ["mise/tasks/check"] = task([[cargo check
]]),
      ["mise/tasks/dev"] = task([[cargo run
]]),
      ["README.md"] = [[# Rust PDE project
]],
    },
  },
  c = {
    label = "C/CMake",
    language = "C/C++",
    runtime = "cc/cmake/ninja via mise/project PATH",
    files = {
      ["CMakeLists.txt"] = [[cmake_minimum_required(VERSION 3.20)
project(vega_c C)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
add_executable(vega_c src/main.c)
]],
      ["src/main.c"] = [[#include <stdio.h>

int main(void) {
  puts("vega c ready");
  return 0;
}
]],
      ["mise/tasks/build"] = task([[cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build build
]]),
      ["mise/tasks/test"] = task([[ctest --test-dir build --output-on-failure
]]),
      ["mise/tasks/lint"] = task([[cc -fsyntax-only src/main.c
]]),
      ["mise/tasks/dev"] = task([[./build/vega_c
]]),
      ["README.md"] = [[# C/CMake PDE project

`compile_commands.json` is generated by CMake in `build/`.
]],
    },
  },
  arduino = {
    label = "Arduino sketch",
    language = "Arduino/C++",
    runtime = "arduino-cli explicit compile/upload tasks",
    files = {
      ["sketch.yaml"] = [[default_profile: default
profiles:
  default:
    fqbn: esp32:esp32:esp32
]],
      ["src/main.ino"] = [[void setup() {
}

void loop() {
}
]],
      ["compile_commands.json"] = [[[]
]],
      ["mise/tasks/arduino-compile"] = task([[arduino-cli compile --profile default .
]]),
      ["mise/tasks/arduino-compile-db"] = task([[arduino-cli compile --profile default --only-compilation-database .
]]),
      ["mise/tasks/arduino-upload"] = task([[echo "Hardware explicit: edit board/port first, then run upload manually." >&2
exit 1
]]),
      ["README.md"] = [[# Arduino PDE project

Compile only by default. Upload/flash remains explicit.
]],
    },
  },
  java = {
    label = "Java Maven",
    language = "Java",
    runtime = "java/maven via mise/project PATH",
    files = {
      ["pom.xml"] = [[<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>local.vega</groupId>
  <artifactId>vega-java</artifactId>
  <version>0.1.0</version>
  <properties><maven.compiler.release>21</maven.compiler.release></properties>
</project>
]],
      ["src/main/java/local/vega/App.java"] = [[package local.vega;

public class App {
  public static void main(String[] args) { System.out.println("vega java ready"); }
}
]],
      ["mise/tasks/build"] = task([[mvn package
]]),
      ["mise/tasks/test"] = task([[mvn test
]]),
      ["mise/tasks/lint"] = task([[mvn -q -DskipTests compile
]]),
      ["mise/tasks/dev"] = task([[mvn exec:java -Dexec.mainClass=local.vega.App
]]),
      ["README.md"] = [[# Java Maven PDE project
]],
    },
  },
}

M.aliases = { cpp = "c", cmake = "c", ts = "node", typescript = "node", react = "vite", maven = "java" }

function M.names()
  local names = {}
  for name in pairs(M.catalog) do table.insert(names, name) end
  table.sort(names)
  return names
end

function M.get(name)
  name = name and name:lower() or nil
  name = M.aliases[name] or name
  return name and M.catalog[name] or nil, name
end

function M.lines()
  local lines = { "PDE Templates", "" }
  for _, name in ipairs(M.names()) do
    local spec = M.catalog[name]
    table.insert(lines, string.format("- %s — %s [%s]", name, spec.label, spec.language))
    table.insert(lines, "  runtime: " .. spec.runtime)
  end
  table.insert(lines, "")
  table.insert(lines, "Use: :PDENewProject <template> <path>")
  return lines
end

function M.open()
  local lines = M.lines()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "markdown"
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local width = math.min(100, math.max(64, vim.o.columns - 8))
  local height = math.min(#lines + 2, math.max(16, vim.o.lines - 6))
  vim.api.nvim_open_win(buf, true, { relative = "editor", style = "minimal", border = "rounded", title = " PDE Templates ", title_pos = "center", width = width, height = height, row = math.floor((vim.o.lines - height) / 2), col = math.floor((vim.o.columns - width) / 2) })
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
end

return M
