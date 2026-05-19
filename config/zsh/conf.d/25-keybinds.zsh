# conf.d/25-keybinds.zsh – vi-mode + ergonomic overrides

bindkey -v
export KEYTIMEOUT=1

# ── Standard keys ─────────────────────────────────────────────────────────────
bindkey '^[[H'    beginning-of-line
bindkey '^[[F'    end-of-line
bindkey '^[[3~'   delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;3C' forward-word    # alt+right
bindkey '^[[1;3D' backward-word   # alt+left

# ── History search (prefix-aware up/down) ─────────────────────────────────────
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# ── Ctrl+R → history search ───────────────────────────────────────────────────
# Atuin owns Ctrl-R when installed. Keep fzf only as the fallback so the two
# widgets do not fight for the same keybinding.
if ! command -v atuin &>/dev/null; then
  bindkey '^R' fzf-history-widget 2>/dev/null || true
fi

# ── Edit command in $EDITOR (v in normal mode) ────────────────────────────────
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# ── Yank to system clipboard in vi normal mode ────────────────────────────────
function _vi_yank_to_clipboard() {
  zle vi-yank
  printf '%s' "$CUTBUFFER" | \
    (command -v wl-copy &>/dev/null && wl-copy \
     || command -v xclip &>/dev/null && xclip -sel clip \
     || pbcopy) 2>/dev/null
}
zle -N _vi_yank_to_clipboard
bindkey -M vicmd 'y' _vi_yank_to_clipboard

# ── Cursor shape: block in normal, beam in insert ────────────────────────────
function _set_cursor_beam()  { printf '\033[6 q' }
function _set_cursor_block() { printf '\033[2 q' }

zle -N zle-line-init     _set_cursor_beam
zle -N zle-keymap-select _cursor_mode
function _cursor_mode() {
  case "$KEYMAP" in
    vicmd)          _set_cursor_block ;;
    viins|main|*)   _set_cursor_beam  ;;
  esac
}
