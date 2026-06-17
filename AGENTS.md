# AGENTS.md - tiny-nvim + VEGA Fortress Ops

Guide for agentic coding agents working in this Neovim configuration repository.

---

## Project Overview

**tiny-nvim** is a minimal Neovim 0.11+ config that relies on built-in LSP and a curated set
of plugins managed by lazy.nvim. Most edits are Lua under `lua/` with optional extras
under `lua/plugins/extra/`.

**VEGA Fortress Ops** is the local operational intelligence layer — integrated Arduino/ESP32,
kitty terminal, shell wrappers, and dotfiles management via mise.

---

## Build, Lint, Test

### Setup

```bash
# Install required external tools
./scripts/install-tools.sh

# Plugin sync (run inside Neovim)
:Lazy sync
```

### Linting and Formatting

```bash
# Format all Lua
stylua .

# Format a single file
stylua lua/plugins/coding.lua

# Lint JS/TS/JSON (biome is linter only)
biome lint .
biome lint --write .
biome lint --write --unsafe .

# Spell check
cspell "**/*.{lua,md,txt}"
```

### Health Checks

```vim
:checkhealth
:check vim.lsp
:ConformInfo
```

### Tests (Single Test Focus)

This repo does not include unit tests itself. Testing is typically done through Neovim
plugins against external projects.

Within Neovim (vim-test):

- `:TestNearest` single test at cursor
- `:TestFile` tests in current file
- `:TestSuite` full suite
- `:JestRunner` or `:VitestRunner` for nearest test

Within Neovim (neotest):

- `<leader>ctr` run nearest test
- `<leader>ctt` run current file
- `<leader>ctT` run all test files
- `<leader>ctl` rerun last test

---

## Code Style Guidelines

### Lua Formatting

- Indentation: 2 spaces, no tabs
- Max line width: 120
- Quotes: prefer double quotes
- Call parens: omit for single string arg (`require "config.options"`)

### Imports and Requires

```lua
require "config.options"
local map = vim.keymap.set

local ok, mod = pcall(require, "module")
if not ok then
  return
end

local on_attach = require("utils.lsp").on_attach
```

### Naming

- Variables/functions: `snake_case`
- Modules/tables: `PascalCase`
- Globals: `_G.camelCase()` only when required for keymaps
- Private helpers: prefix with `_`

### Error Handling

- Prefer guard clauses and early returns
- Use `pcall` for optional modules or IO
- Notify errors via `vim.notify(..., vim.log.levels.ERROR)` when user-facing

### Comments

- Keep comments minimal; rely on clear names
- Comment only for non-obvious logic or user-facing behavior

### Types and Diagnostics

- Lua runtime is LuaJIT
- Allowed globals include `vim` and `Snacks` (from `.luarc.json`)
- Keep `workspace.checkThirdParty = false`

---

## Project Conventions

### Structure

```
lua/
  config/      core options, keymaps, autocmds, lazy
  plugins/     plugin specs
    extra/     optional/extra plugins
  langs/       language-specific configs
  utils/       shared helpers
lsp/           native Neovim 0.11+ LSP configs
scripts/       install/setup scripts
```

### Plugin Specs

- Files under `lua/plugins/` return plugin spec tables for lazy.nvim
- Use `optional = true` for extension plugins
- Keep plugin config close to its spec

### LSP and Project Overrides

- LSP configs live in `lsp/` and use native Neovim 0.11+ format
- Project-specific overrides go in `.nvim-config.lua` (gitignored)
- Global config toggles use `vim.g.*` (e.g., `vim.g.enable_extra_plugins`)

---

## VEGA Fortress Ops — Operational Layer

### Arduino/ESP32 Workflow

**Tools (via mise + pipx):**
- `arduino-cli` 1.5.1 (mise)
- `platformio` 6.1.19 (pipx)
- `clangd` system (`/usr/bin/clangd`)
- Cores: `arduino:avr`, `esp32:esp32` (all variants), `esp8266:esp8266`

**Neovim Keymaps (`<leader>a*`):**
| Key | Action |
|-----|--------|
| `<leader>ab` | Build (arduino-cli, auto-detect board) |
| `<leader>au` | Upload (auto-detect port/FQBN) |
| `<leader>am` | Monitor serial (auto baud: 115200 ESP32, 9600 Uno) |
| `<leader>aI` | Generate `compile_commands.json` (LSP) |
| `<leader>ad` | Detect current board |
| `<leader>aD` | List all detected boards |
| `<leader>ae`/`<leader>aE` | Compile/Upload ESP32 DevKit |
| `<leader>ac`/`<leader>aC` | Compile/Upload ESP32-CAM |
| `<leader>as`/`<leader>aS` | Compile/Upload ESP32-S3 |
| `<leader>al` / `<leader>aL` | List/Install libraries |

**Shell Wrappers (source `~/.config/zsh/conf.d/arduino.zsh`):**
```bash
ab, au, am, al, anew, aI, asetup
pio_build, pio_upload, pio_monitor
```

**Mise Tasks (run from project dir):**
```bash
mise run arduino:new esp32cam ~/Lab/meu_cam
mise run arduino:build / upload / monitor / list / compiledb / setup
```

**Templates (`~/dotfiles/templates/platformio/`):**
- `arduino_uno.ini`, `esp32_devkit.ini`, `esp32_cam.ini`, `esp32_s3.ini`
- `esp32_c3.ini`, `esp32_c6.ini`, `esp32_s2.ini`, `esp32_multi.ini`

**LSP / clangd:**
- Generates `compile_commands.json` via `pio run -t compiledb` (or `<leader>aI`)
- Provides autocomplete, goto definition, hover, diagnostics for Arduino/ESP32

---

### Shell / Terminal (Zsh + Kitty)

**Zsh Structure (`config/zsh/`):**
```
.zshenv, .zshrc, .zprofile
conf.d/
  01-options.zsh
  02-completion.zsh
  20-tools.zsh
  arduino.zsh          # Arduino/ESP32 shell wrappers
archive/
  ml4w-zshrc.zsh       # Legacy reference (not loaded)
```

**Loader (`.zshrc`):** Loads modules in fixed order, then `conf.d/*.zsh(N)` for domain modules.

**Kitty Config (`config/kitty/`):**
- Theme: `dedsec_eviline.conf` (HIGH CONTRAST for transparency)
- Background: DISABLED (focus on text contrast)
- Text rendering: LCD subpixel (`horizontal_lcd`), light load target
- Font: GeistMono Nerd Font Mono, 11pt, cell_height 102%

**Color Palette (High Contrast for transparency/blur):**
| Role | Color |
|------|-------|
| Background | `#050505` |
| Foreground | `#f0f8ff` (bright cyan-white) |
| Cursor | `#00ffaa` (mint) |
| Active Border | `#00ffaa` |
| Active Tab | `#00ffff` on `#050505` |
| Selection | `#00ccff` on `#050505` |

---

### Dotfiles Management

**Structure (`~/dotfiles/`):**
```
config/
  zsh/           # Zsh modular + conf.d loader
  arduino/       # arduino-cli.yaml
  nvim/          # Neovim config
  mise/          # tools + tasks
  kitty/         # kitty.conf + themes/
  quickshell/    # etc.
system/
  udev/rules.d/  # 99-arduino-esp32.rules → /etc/udev/rules.d/
templates/
  platformio/    # 8 templates .ini
install_scripts/
  install_udev_rules.sh
local/bin/       # Executable scripts (PATH)
```

**Symlink Strategy:** `config/*` → `~/.config/*` (except `udev/` which goes to `/etc/`)

---

## Rules and Agent Notes

### Editing Expectations

- Keep changes small and focused
- Avoid unnecessary new dependencies
- Do not auto-generate large blocks or rewrite unrelated files
- **Arduino/ESP32**: Use PlatformIO for full project, arduino-cli for quick scripts
- **LSP**: Always generate `compile_commands.json` after PlatformIO changes
- **Shell**: Follow `conf.d/` pattern for domain modules
- **Kitty**: Disable background for text contrast; uncomment when needed

---

## Quick Validation

After changes, run:

- `stylua .` for Lua formatting
- `:checkhealth` in Neovim to confirm config health

---

## Key Files for Agent Reference

| Domain | File |
|--------|------|
| Arduino workflows | `config/nvim/lua/config/workflows.lua` |
| Arduino keymaps | `config/nvim/lua/config/whichkey.lua` |
| clangd LSP | `config/nvim/lua/config/lsp.lua` |
| Snacks dashboard | `config/nvim/lua/plugins/snacks.lua` |
| Arduino CLI config | `config/arduino/arduino-cli.yaml` |
| Mise tasks | `config/mise/tasks/arduino-*` |
| PlatformIO templates | `templates/platformio/*.ini` |
| UDEV rules | `system/udev/rules.d/99-arduino-esp32.rules` |
| Shell wrappers | `config/zsh/conf.d/arduino.zsh` |
| Kitty theme | `config/kitty/themes/dedsec_eviline.conf` |
| Kitty config | `config/kitty/kitty.conf` |