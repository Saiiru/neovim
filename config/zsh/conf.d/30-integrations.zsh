# conf.d/30-integrations.zsh – tool hooks (mise, direnv, yazi, sesh…)

# ── Atuin (primary shell history) ──────────────────────────────────────────────
if command -v atuin &>/dev/null; then
  eval "$(atuin init zsh --disable-ai)"

  alias atuin-status='atuin status'
  alias atuin-import='atuin import auto'
  alias atuin-prune='atuin history prune'
  alias atuin-prune-dry='atuin history prune --dry-run'
  alias atuin-dedup='atuin history dedup --before now --dupkeep 1'
  alias atuin-dedup-dry='atuin history dedup --dry-run --before now --dupkeep 1'
fi

# ── mise (runtime version manager) ───────────────────────────────────────────
command -v mise &>/dev/null && eval "$(mise activate zsh)"

# ── direnv ────────────────────────────────────────────────────────────────────
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

# ── yazi – cd into last directory on exit ─────────────────────────────────────
function y() {
  local tmp cwd
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  cwd="$(cat "$tmp" 2>/dev/null)"
  [[ -n "$cwd" && "$cwd" != "$PWD" ]] && cd -- "$cwd"
  rm -f -- "$tmp"
}

# ── lazygit ───────────────────────────────────────────────────────────────────
function lg() { lazygit "$@" }

# ── sesh (session manager) ────────────────────────────────────────────────────
function sesh-fzf() {
  local session
  session=$(sesh list --icons 2>/dev/null \
    | fzf --no-sort --prompt="  sesh › " \
          --preview 'sesh preview {}' \
          --border-label=" Sessions " \
          --header "  Switch session") \
  && sesh connect "$session"
}
# Bind ctrl-f in tmux context (outside nvim)
[[ -n "$TMUX" ]] && bindkey -s '^f' 'sesh-fzf\n'

# ── zoxide alias override ─────────────────────────────────────────────────────
# Already initialised as `cd` in 20-completion.zsh; add `z` as shorthand too.
alias z='cd'

# ── functions file (helpers) ──────────────────────────────────────────────────
[[ -r "${ZDOTDIR}/functions/helpers.zsh"  ]] && source "${ZDOTDIR}/functions/helpers.zsh"
[[ -r "${ZDOTDIR}/functions/git.zsh"      ]] && source "${ZDOTDIR}/functions/git.zsh"
