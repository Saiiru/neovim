# conf.d/40-aliases.zsh

# ── Navigation ────────────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias dots='cd "$DOTFILES_REPO"'
alias dl='cd ~/Downloads'
alias dev='cd ~/dev'

# ── Listing ───────────────────────────────────────────────────────────────────
alias ls='eza --color=always --icons=always'
alias ll='eza -lah --icons=always --group-directories-first --git'
alias la='eza -a  --icons=always'
alias lt='eza --tree --level=2 --icons=always'
alias llt='eza --tree --level=3 -lah --icons=always'

# ── File ops ──────────────────────────────────────────────────────────────────
alias cat='bat --paging=never'
alias grep='rg'
alias fd='fd --hidden'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias mkdir='mkdir -pv'

# ── Editors ───────────────────────────────────────────────────────────────────
alias v='nvim'
alias vim='nvim'
alias vi='nvim'

# ── Git ───────────────────────────────────────────────────────────────────────
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend --no-edit'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpl='git pull --rebase'
alias gd='git diff'
alias gdc='git diff --cached'
alias glo='git log --graph --decorate --oneline --abbrev-commit'
alias gla='git log --graph --decorate --oneline --abbrev-commit --all'
alias gb='git branch'
alias gco='git checkout'
alias gsw='git switch'
alias grb='git rebase'
alias gst='git stash'
alias gstp='git stash pop'
alias groot='cd "$(git rev-parse --show-toplevel 2>/dev/null || echo .)"'

# ── tmux ──────────────────────────────────────────────────────────────────────
alias tm='tmux new-session -A -s main'
alias tma='tmux attach -t'
alias tml='tmux ls'
alias tmk='tmux kill-session -t'
alias tmr='tmux source ~/.config/tmux/tmux.conf && echo "tmux reloaded"'

# ── Apps ──────────────────────────────────────────────────────────────────────
alias ff='firefox'
alias browser='firefox'
alias desktop='systemctl --user restart quickshell.service'
alias uireload='niri msg action reload-config'

# ── Quality of life ───────────────────────────────────────────────────────────
alias c='clear'
alias q='exit'
alias which='command -v'
alias path='printf "%s\n" "${path[@]}"'
alias reload='exec zsh'

# ── Suffix aliases (open by extension) ───────────────────────────────────────
alias -s {md,txt,toml,yaml,yml,json,lua,py,ts,js,rs,go}=nvim
