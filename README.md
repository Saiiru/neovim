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
:PDEStatus                 read project/root/framework/LSP/tasks
:PDEFramework              show detected project type/framework
:PDEToolchain              show mise active tools
:PDEOpenMise               open project .mise.toml
:PDEOpenProjectConfig      open project pde.toml
:PDEDoctor                 mise run pde-doctor
:PDEVersion                mise run pde-version
:PDEDev                    mise run dev
:PDEBuild                  mise run build -> quickfix
:PDETest                   mise run test -> quickfix
:PDELint                   mise run lint -> quickfix
:PDEFormat                 mise run format
:PDETypecheck              mise run typecheck -> quickfix
:PDERun                    mise run run
:PDEQuickfix               open quickfix
:PDEBoards                 mise run arduino-boards
:PDEArduinoProfile         show sketch/pde Arduino profile
:PDEArduinoCompileDB       mise run arduino-compile-db
:PDEArduinoCompile         mise run arduino-compile -> quickfix
:PDEArduinoUpload          mise run arduino-upload
:PDEArduinoFlash           mise run arduino-flash
:PDEArduinoMonitor         mise run arduino-monitor
:PDEArduinoRestartLSP      restart Arduino language server
```

Task names use hyphenated form by default because unquoted TOML keys do not accept `:`. Quoted task names with `:` are still resolved as fallback when present.

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

## Keymaps

Core:

```txt
<C-s>           save
<leader>w       save
<leader>q       quit window
<leader>Q       quit all
<esc>           clear search highlight
<S-h>/<S-l>     previous/next buffer
<leader>bd      delete buffer
<leader><tab>   alternate buffer
<leader>sv/sh   vertical/horizontal split
```

Finder:

```txt
<leader>ff      find files
<leader>fg      live grep
<leader>fb      buffers
<leader>fh      help
<leader>fr      resume picker
```

Code/LSP:

```txt
gd              go to definition
gD              go to declaration
gi              go to implementation
gr              references
K               hover
[d / ]d         previous/next diagnostic
<leader>cd      line diagnostic
<leader>cl      diagnostics to loclist
<leader>ca      code action
<leader>cr      rename
<leader>cf      format buffer
```

Quickfix:

```txt
[q / ]q         previous/next quickfix
<leader>qo      open quickfix
<leader>qc      close quickfix
[l / ]l         previous/next loclist
```

PDE:

```txt
<leader>ps      PDE status
<leader>pd      PDE doctor
<leader>pv      PDE version
<leader>pb      PDE build -> quickfix
<leader>pt      PDE test -> quickfix
<leader>pl      PDE lint -> quickfix
<leader>pf      PDE format
<leader>pm      open .mise.toml
<leader>pc      open pde.toml
```

Arduino:

```txt
<leader>ab      boards
<leader>ap      profile
<leader>ac      compile -> quickfix
<leader>aC      compile database
<leader>au      upload
<leader>af      flash
<leader>am      monitor
```

## Snippets

This config uses Neovim 0.12 native snippets, not LuaSnip. No snippet engine is installed by Neovim.

Commands:

```vim
:PDESnippets          list snippets for current filetype
:PDESnippet           pick snippet via vim.ui.select
:PDESnippet main      insert snippet named main
```

Keymaps:

```txt
<leader>si      pick snippet
<leader>sl      list snippets
<leader>sm      insert main snippet
<C-j>           jump forward through snippet placeholders
<C-k>           jump backward through snippet placeholders
```

Completion:

```txt
<Tab>/<S-Tab>   handled by blink.cmp for completion menu and snippet movement
<C-space>       open completion
<CR>            accept completion
```

Available built-in snippets:

```txt
c:          checknull, fprintf, fori, guard, inc, incl, main, printf
cpp:        cerr, class, cout, inc, incl, main, try
lua:        autocmd, fn, mod, pcall, req, usercmd
python:     cls, dataclass, fastapi, fn, from, imp, main, pytest, try, trylog, withopen
javascript: afn, async, awaittry, error, fn, imp, imn, log, try, warn
typescript: afn, awaittry, fn, iface, imp, imn, react, try, type, typeimp
go:         deferclose, err, errnil, errwrap, fn, http, httperr, im, ims, main, tabletest, test
rust:       derive, fn, iflet, main, matcherr, resultfn, test, use
java:       class, imp, main, method, pkg, serr, sout, try, tryres
arduino:    debounce, digital, pinin, pinout, serial, sketch
```

Example:

```vim
:PDESnippet main
```

When called from normal mode, the snippet opens a new line below the cursor before expanding. Then use `<C-j>` / `<C-k>` to move through placeholders.

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
