#!/bin/bash
# nvim-specific tool installations
# Everything else is managed by mise (see ~/.config/mise/config.toml)
# Run after: mise install

set -euo pipefail

echo "🔧 Installing nvim-specific tools..."

# ─────────────────────────────────────────────────────────────
# Tree-sitter CLI (required for nvim-treesitter on Neovim 0.11+)
# ══════════════════════════════════════════════════════════════
# Tenta via cargo (mise gerencia cargo:tree-sitter-cli), fallback npm
if command -v cargo &> /dev/null; then
    echo "📦 Installing tree-sitter-cli via cargo..."
    cargo install tree-sitter-cli --locked 2>/dev/null || true
elif command -v npm &> /dev/null; then
    echo "📦 Installing tree-sitter-cli via npm..."
    npm install -g tree-sitter-cli 2>/dev/null || true
else
    echo "⚠️  Neither cargo nor npm found. Install tree-sitter-cli manually."
fi

# ─────────────────────────────────────────────────────────────
# Go Language Server (gopls) — official channel
# ══════════════════════════════════════════════════════════════
if command -v go &> /dev/null; then
    echo "📦 Installing gopls..."
    go install golang.org/x/tools/gopls@latest
else
    echo "⚠️  Go not found (mise should provide it). Skipping gopls."
fi

# ─────────────────────────────────────────────────────────────
# Rust Analyzer — official channel
# ══════════════════════════════════════════════════════════════
if command -v rustup &> /dev/null; then
    echo "📦 Installing rust-analyzer via rustup..."
    rustup component add rust-analyzer
elif command -v cargo &> /dev/null; then
    echo "📦 Installing rust-analyzer via cargo..."
    cargo install rust-analyzer --locked 2>/dev/null || true
else
    echo "⚠️  rustup/cargo not found. Install rust-analyzer manually."
fi

# ─────────────────────────────────────────────────────────────
# NPM packages for LSPs (not in mise config — version pinned here)
# ══════════════════════════════════════════════════════════════
if command -v npm &> /dev/null; then
    echo "📦 Installing npm LSP packages..."
    # PUPPETEER_SKIP_DOWNLOAD evita download do chromium no mermaid-cli
    PUPPETEER_SKIP_DOWNLOAD=1 npm install -g --force \
        @antfu/ni \
        @fsouza/prettierd \
        @mermaid-js/mermaid-cli \
        @tailwindcss/language-server \
        @vtsls/language-server \
        cspell \
        npm-check-updates \
        oxlint \
        pnpm \
        prettier \
        rustywind \
        typescript \
        typescript-language-server \
        vscode-langservers-extracted \
        basedpyright
else
    echo "⚠️  npm not found. Skipping npm LSP packages."
fi

# ─────────────────────────────────────────────────────────────
# Python tools via uv (project-specific, not global mise)
# ══════════════════════════════════════════════════════════════
if command -v uv &> /dev/null; then
    echo "📦 Installing Python tools via uv..."
    uv tool install codespell
    uv tool install isort
    # ruff, mypy, pytest, jupyterlab, ipython, yt-dlp → já em mise/uv tools globais
else
    echo "⚠️  uv not found. Skipping uv tools."
fi

echo "✅ nvim-specific tools installation complete!"
echo "   Run ':Lazy sync' and ':TSInstallSync lua vim vimdoc json markdown python typescript go rust' in Neovim."