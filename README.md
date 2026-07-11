# Tiny Neovim PDE

Neovim configuration rebuilt for Sairu's mise-first PDE.

## Architecture

```txt
mise      = runtimes / SDKs / CLIs / LSP servers / formatters / linters / tasks
Neovim    = editor / LSP client / diagnostics / quickfix / navigation / git / task invocation
Project   = declares stack locally via .mise.toml, pde.toml, sketch.yaml when embedded
Hermes    = audit / briefing / manifest / documentation
```

## Rules

- Neovim does not install toolchains.
- Neovim does not run Mason as the primary installer.
- Project actions go through `mise run <task>`.
- Build/lint/test output goes to quickfix.
- LSP diagnostics stay separate from compiler output.
- Hardware flash/monitor only happens by explicit command.
- No AI, dashboard, Obsidian, auto-session, remote-dev or plugin sprawl in v0.

## Structure

```txt
init.lua
lua/core/
  options.lua
  diagnostics.lua
  autocmds.lua
  lazy.lua
  lsp.lua
  keymaps.lua
  quickfix.lua
lua/plugins/
  completion.lua
  finder.lua
  format.lua
  git.lua
  lsp.lua
  statusline.lua
  theme.lua
  treesitter.lua
  whichkey.lua
lua/pde/
  detect.lua
  tasks.lua
  commands.lua
  arduino.lua
```

## PDE Commands

```txt
:PDEStatus
:PDEFramework
:PDEToolchain
:PDEOpenMise
:PDEOpenProjectConfig
:PDEDoctor
:PDEVersion
:PDEDev
:PDEBuild
:PDETest
:PDELint
:PDEFormat
:PDETypecheck
:PDERun
:PDEQuickfix
:PDEBoards
:PDEArduinoProfile
:PDEArduinoCompileDB
:PDEArduinoCompile
:PDEArduinoUpload
:PDEArduinoFlash
:PDEArduinoMonitor
:PDEArduinoRestartLSP
```

## Project detection

```txt
sketch.yaml       -> Arduino CLI
platformio.ini    -> PlatformIO
vite.config.*     -> Vite
next.config.*     -> Next.js
angular.json      -> Angular
nuxt.config.*     -> Nuxt
svelte.config.*   -> SvelteKit
astro.config.*    -> Astro
nest-cli.json     -> NestJS
pom.xml           -> Maven/Java
build.gradle      -> Gradle/Java
go.mod            -> Go
Cargo.toml        -> Rust
manage.py         -> Django
pyproject.toml    -> Python
package.json      -> Node
```

## Arduino / embedded

Arduino projects should declare metadata in:

```txt
sketch.yaml
pde.toml
.mise.toml
```

Flow:

```txt
mise run arduino:compile-db -> generate compile_commands.json
clangd reads compile_commands.json
Neovim shows real diagnostics
mise run arduino:compile -> compiler output to quickfix
mise run arduino:upload/flash/monitor -> explicit only
```

## Validation

```bash
nvim --headless '+qa'
nvim --headless '+PDEStatus' '+qa'
nvim --headless '+PDEFramework' '+qa'
```

## Backup

Previous accumulated config is preserved at:

```txt
backup/current-nvim-before-tiny-pde-2026-07-11
```

Commit:

```txt
be966cc backup: preserve current nvim before tiny pde rebuild
```
