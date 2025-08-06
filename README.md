# 🚀 KORA NEURAL DEVELOPMENT MATRIX

<div align="center">

![KORA Banner](https://via.placeholder.com/800x200/16213E/FF79C6?text=KORA+NEURAL+MATRIX)

**A quantum-enhanced Neovim ecosystem for professional development**

[![Neovim](https://img.shields.io/badge/Neovim-0.9+-brightgreen.svg?style=for-the-badge&logo=neovim)](https://neovim.io)
[![Lua](https://img.shields.io/badge/Lua-5.1+-blue.svg?style=for-the-badge&logo=lua)](https://lua.org)
[![License](https://img.shields.io/badge/License-MIT-purple.svg?style=for-the-badge)](LICENSE)

</div>

## 🧠 Neural Overview

KORA (Knowledge-Oriented Rapid Architecture) is a next-generation Neovim configuration designed for developers who demand **surgical precision**, **aesthetic excellence**, and **AI-enhanced productivity**. Built with a cyberpunk aesthetic and neural network terminology, KORA transforms your terminal into a command center worthy of Batman's cave.

### ⚡ Key Features

- 🤖 **AI Integration**: GitHub Copilot + Chat for intelligent code assistance
- 🎨 **Cyberdream Theme**: Sci-fi aesthetics with italic intelligence
- 🔧 **Universal LSP**: 20+ programming languages supported
- 🔍 **Quantum Search**: Telescope with neural-enhanced fuzzy finding
- 🌳 **File Neural Tree**: Advanced file exploration with git integration
- 📊 **HUD Status Line**: Real-time system monitoring
- 🎮 **Tmux Integration**: Seamless terminal multiplexing
- ⚡ **<50ms Startup**: Lightning-fast boot time
- 🗝️ **Command Discovery**: Which-key neural interface

## 📋 System Requirements

### Core Dependencies
```bash
# Required
neovim >= 0.9.0
git >= 2.19.0
curl
wget
unzip

# Language Servers (auto-installed via Mason)
node >= 18.0.0
python >= 3.8
go >= 1.19
rust >= 1.60
java >= 11
```

### Optional Enhancements
```bash
# Terminal & Tools
kitty terminal (recommended)
tmux >= 3.2
fzf
ripgrep (rg)
fd
lazygit
btop/htop

# Fonts (for icons)
Nerd Font (recommended: JetBrains Mono Nerd Font)
```

## 🛠️ Installation Guide

### 🚀 Quick Install (Recommended)

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)
mv ~/.tmux.conf ~/.tmux.conf.backup.$(date +%Y%m%d_%H%M%S)

# Clone KORA Matrix
git clone https://github.com/your-username/kora-nvim ~/.config/nvim

# Copy tmux config
cp ~/.config/nvim/.tmux.conf ~/

# Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Launch Neovim (plugins will auto-install)
nvim
```

### 🔧 Manual Installation

<details>
<summary>Click to expand manual installation steps</summary>

#### 1. Neovim Configuration

```bash
# Create directories
mkdir -p ~/.config/nvim/lua/kora/{core,plugins}

# Copy configuration files
# init.lua -> ~/.config/nvim/init.lua
# Core files -> ~/.config/nvim/lua/kora/core/
# Plugin files -> ~/.config/nvim/lua/kora/plugins/
```

#### 2. Tmux Configuration

```bash
# Copy tmux config
cp .tmux.conf ~/

# Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Reload tmux (if running)
tmux source-file ~/.tmux.conf
```

#### 3. Dependencies

```bash
# Install language servers (auto-handled by Mason)
# Install terminal tools
brew install fzf ripgrep fd lazygit btop  # macOS
sudo apt install fzf ripgrep fd-find lazygit btop  # Ubuntu
```

</details>

## 🎮 Quick Start Guide

### First Launch

1. **Start Neovim**: `nvim`
   - Lazy.nvim will automatically install all plugins
   - Wait for completion (1-2 minutes)
   
2. **Verify Installation**: 
   - `:checkhealth` - Verify system health
   - `:Mason` - Check language servers
   - `:Lazy` - View plugin status

3. **AI Setup** (Optional):
   - `:Copilot auth` - Authenticate GitHub Copilot
   - `:CopilotChat` - Test AI chat functionality

### Essential Keybindings

#### 🗝️ Leader Key: `<Space>`

| Category | Keybinding | Action |
|----------|------------|--------|
| **Files** | `<leader>ff` | Find files |
| | `<leader>fg` | Live grep |
| | `<leader>fb` | Browse buffers |
| | `<leader>fr` | Recent files |
| **AI** | `<leader>cc` | Copilot Chat |
| | `<leader>ce` | Explain code |
| | `<leader>cf` | Fix code |
| | `<leader>ct` | Generate tests |
| **Git** | `<leader>gs` | Git status |
| | `<leader>gc` | Git commits |
| | `]h` / `[h` | Next/prev hunk |
| **LSP** | `gd` | Go to definition |
| | `gr` | Find references |
| | `<leader>ca` | Code actions |
| | `<leader>cr` | Rename symbol |
| **Explorer** | `<leader>e` | Toggle file tree |
| | `<leader>ef` | Focus explorer |

#### 🤖 AI Assistant

| Mode | Keybinding | Action |
|------|------------|--------|
| Insert | `<C-J>` | Accept Copilot suggestion |
| Insert | `<C-L>` | Accept word |
| Insert | `<C-H>` | Accept line |
| Normal | `<leader>cc` | Open AI chat |
| Visual | `<leader>cv` | Chat with selection |

#### 📋 Completion & Snippets

| Mode | Keybinding | Action |
|------|------------|--------|
| Insert | `<Tab>` | Next completion |
| Insert | `<S-Tab>` | Previous completion |
| Insert | `<C-Space>` | Trigger completion |
| Insert | `<CR>` | Confirm selection |

## 🗂️ File Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lazy-lock.json          # Plugin lockfile
└── lua/kora/
    ├── core/               # Core configuration
    │   ├── options.lua     # Editor options
    │   ├── keymaps.lua     # Key mappings
    │   └── autocmds.lua    # Auto commands
    └── plugins/            # Plugin configurations
        ├── colorscheme.lua # Cyberdream theme
        ├── ui.lua          # UI components
        ├── ai.lua          # AI integration
        ├── lsp.lua         # Language servers
        ├── completion.lua  # Autocompletion
        └── editor.lua      # Editor enhancements
```

## 🎨 Customization

### 🎭 Changing Themes

KORA uses the Cyberdream theme by default, but you can easily switch:

```lua
-- In lua/kora/plugins/colorscheme.lua
{
  "folke/tokyonight.nvim",  -- Alternative theme
  -- or
  "rose-pine/neovim",       -- Another option
}
```

### 🔧 Custom Keybindings

Add your keybindings to `lua/kora/core/keymaps.lua`:

```lua
-- Custom mapping example
map("n", "cf", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format code" })
```

### 🤖 AI Configuration

Customize AI behavior in `lua/kora/plugins/ai.lua`:

```lua
-- Modify Copilot filetypes
vim.g.copilot_filetypes = {
  markdown = true,  -- Enable for markdown
  yaml = false,     -- Disable for yaml
}
```

## 🌍 Language Support

### Fully Supported Languages

| Language | LSP | Formatting | Linting | Debugging |
|----------|-----|------------|---------|-----------|
| **JavaScript/TypeScript** | ✅ | ✅ | ✅ | ✅ |
| **Python** | ✅ | ✅ | ✅ | ✅ |
| **Go** | ✅ | ✅ | ✅ | ✅ |
| **Rust** | ✅ | ✅ | ✅ | ✅ |
| **C/C++** | ✅ | ✅ | ✅ | ✅ |
| **Java** | ✅ | ✅ | ✅ | ✅ |
| **Lua** | ✅ | ✅ | ✅ | ❌ |
| **HTML/CSS** | ✅ | ✅ | ✅ | ❌ |
| **React/Vue** | ✅ | ✅ | ✅ | ✅ |

### Adding New Languages

1. **Add LSP Server**:
   ```lua
   -- In lua/kora/plugins/lsp.lua servers table
   your_language_ls = {
     settings = {
       -- Language-specific settings
     }
   }
   ```

2. **Add to Mason**:
   ```lua
   -- In ensure_installed table
   "your-language-server",
   "your-formatter",
   "your-linter",
   ```

## 🔧 Troubleshooting

### Common Issues

<details>
<summary><strong>🐛 Plugins not loading</strong></summary>

```bash
# Clear plugin cache
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
nvim  # Reinstall everything
```
</details>

<details>
<summary><strong>🤖 Copilot not working</strong></summary>

```bash
# Authenticate Copilot
nvim
:Copilot auth
:Copilot status
```
</details>

<details>
<summary><strong>🔍 LSP not starting</strong></summary>

```bash
# Check Mason installation
nvim
:Mason
:checkhealth mason
:LspInfo  # Check LSP status
```
</details>

<details>
<summary><strong>🎨 Colors not displaying correctly</strong></summary>

```bash
# Check terminal support
echo $TERM
# Should show: xterm-256color or similar

# In tmux
tmux info | grep Tc
# Should show Tc support
```
</details>

### Performance Issues

If experiencing slow startup:

1. **Profile startup**:
   ```bash
   nvim --startuptime startup.log
   ```

2. **Disable unused features**:
   ```lua
   -- In init.lua, add to disabled_built_ins
   "plugin_name",
   ```

3. **Lazy load more plugins**:
   ```lua
   -- Add event/cmd/keys to plugin specs
   event = "VeryLazy",
   ```

## 🔗 Tmux Integration

### KORA Neural Multiplexer

The included `.tmux.conf` provides:

- **🎨 Cyberdream Theme**: Matching Neovim colors
- **🧭 Seamless Navigation**: Shared keybindings with Neovim
- **📊 System Monitoring**: CPU, Memory, Time displays
- **🔍 FZF Integration**: Session/Window switching
- **⚡ Batman Mode**: Quick access to tools

### Key Tmux Bindings

| Prefix | Key | Action |
|--------|-----|--------|
| `C-a` | `h/j/k/l` | Navigate panes |
| `C-a` | `H/J/K/L` | Resize panes |
| `C-a` | `S` | Session switcher (FZF) |
| `C-a` | `W` | Window switcher (FZF) |
| `C-a` | `F1-F5` | Quick tools |
| `C-a` | `r` | Reload config |

### Sesh Integration

Install [sesh](https://github.com/joshmedeski/sesh) for enhanced session management:

```bash
# Install sesh
go install github.com/joshmedeski/sesh@latest

# Use enhanced last session
# C-a L now works better with closed sessions
```

## 🎯 Advanced Usage

### 🔬 Debugging

KORA includes full DAP (Debug Adapter Protocol) support:

```bash
# Set breakpoint: b
# Start debugging: F5
# Step over: F10
# Step into: F11
# Step out: F12
```

### 🧪 Testing Integration

```bash
# Generate tests with AI
ct

# Run tests (language-specific)
# Go: :TestNearest
# Python: :TestFile
```

### 📊 Code Analysis

```bash
# Trouble diagnostics
xx

# LSP symbols
ls

# Todo comments
st
```

## 🤝 Contributing

We welcome contributions! Here's how:

1. **Fork the repository**
2. **Create feature branch**: `git checkout -b feature/amazing-feature`
3. **Commit changes**: `git commit -m 'Add amazing feature'`
4. **Push to branch**: `git push origin feature/amazing-feature`
5. **Open Pull Request**

### Development Setup

```bash
# Clone your fork
git clone https://github.com/your-username/kora-nvim
cd kora-nvim

# Create test environment
./scripts/test-config.sh
```

## 📚 Learning Resources

### Neovim
- [Neovim Documentation](https://neovim.io/doc/)
- [Lua Guide](https://neovim.io/doc/user/lua-guide.html)
- [Plugin Development](https://github.com/nanotee/nvim-lua-guide)

### Tmux
- [Tmux Manual](https://man.openbsd.org/tmux.1)
- [Tmux Plugins](https://github.com/tmux-plugins)

### AI Development
- [GitHub Copilot Docs](https://docs.github.com/en/copilot)
- [OpenAI API](https://platform.openai.com/docs)

## 🎖️ Credits & Inspiration

KORA stands on the shoulders of giants:

- **[LazyVim](https://github.com/LazyVim/LazyVim)** - Configuration patterns
- **[AstroNvim](https://github.com/AstroNvim/AstroNvim)** - Plugin organization
- **[ThePrimeagen](https://github.com/ThePrimeagen)** - Neovim workflows
- **[TJ DeVries](https://github.com/tjdevries)** - Telescope creator
- **[Folke Lemaitre](https://github.com/folke)** - lazy.nvim and many plugins

### Community Plugins

Special thanks to all plugin authors:
- `nvim-treesitter` - Syntax highlighting
- `telescope.nvim` - Fuzzy finding
- `nvim-lspconfig` - LSP configuration
- `nvim-cmp` - Autocompletion
- And many more in our plugin list!

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🚀 Final Words

KORA isn't just a Neovim configuration - it's a **neural development environment** designed to enhance your coding experience through:

- **🧠 AI-Enhanced Intelligence**
- **⚡ Lightning-Fast Performance** 
- **🎨 Beautiful Aesthetics**
- **🔧 Professional Tools**
- **🤝 Community-Driven Development**

### Ready to Enter the Matrix?

```bash
nvim
```

**"In the darkness of code, I am your neural network. I am... KORA."** - *The Dark Code Knight*

---

<div align="center">

**[⭐ Star this repo](https://github.com/your-username/kora-nvim)** • **[🐛 Report issues](https://github.com/your-username/kora-nvim/issues)** • **[💬 Discussions](https://github.com/your-username/kora-nvim/discussions)**

Made with ❤️ by the KORA Neural Network

</div>
