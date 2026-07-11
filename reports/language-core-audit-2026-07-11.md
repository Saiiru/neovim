# Neovim PDE language-core audit

Date: 2026-07-11

Decision: keep `nvim-cmp + LuaSnip` for now. Do not migrate to `blink.cmp` in this pass.

Reasoning:

- `nvim-cmp` is already wired with `cmp-nvim-lsp`, `cmp_luasnip`, path, buffer, cmdline, and bordered docs.
- LuaSnip snippets are already visible through completion and cover Go, Python, TypeScript/JS, C/C++, Lua, and Arduino.
- No `blink.cmp` plugin is present in the active config. Adding it would require a plugin install/sync path, which is outside this pass.
- Running both cmp engines would create keymap/source ambiguity; do not mix them.

Audit summary:

- Treesitter: present through `nvim-treesitter`, textobjects, and context. Parser auto-install was disabled so startup does not download parsers. Existing parsers cover bash, c, go, javascript, lua, python, rust, toml, typescript, yaml, and more.
- LSP: present through `nvim-lspconfig`. Tool ownership remains external/mise; server setup is guarded by executable checks. TypeScript LSP starts only when the project has local `node_modules/typescript`.
- Completion: `nvim-cmp + LuaSnip` remains the active stack.
- Diagnostics: native `vim.diagnostic`, Trouble, tiny-inline-diagnostic, and Snacks diagnostic pickers are present.
- Format/lint: no conform.nvim or nvim-lint plugin is active. Format/lint remain project-local `mise run format` and `mise run lint` through PDE commands/quickfix. This keeps mise as toolchain/task owner.
- Tool installs: Neovim startup now avoids Lazy plugin installs and Treesitter parser auto-installs.
- Provider noise: optional Node/Perl/Ruby providers are disabled; Python provider is only enabled if the configured host exists.

Validation fixture:

- `tests/pde_fixture_smoke.lua` creates temporary fixtures for Lua, Python, JavaScript, TypeScript, C, Arduino, Go, and Rust.
- It verifies `pde.detect` and `pde.tasks` without installing language tools or touching real projects.

Known external/runtime watchpoints:

- Current tmux session may still expose `$TERM=xterm-kitty` until a new tmux window/session uses `default-terminal=tmux-256color`; config is correct for future panes.
- Snacks image health may still report optional PDF/LaTeX/graphics checks when running inside unsupported/headless terminal contexts even though image features are disabled.
