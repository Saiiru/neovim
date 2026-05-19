# ~/.config/zsh/.zshrc
# Interactive shell bootstrap.  Sources conf.d modules in order.
# Nothing lives here directly – keep it as a thin loader.

[[ $- != *i* ]] && return   # bail if non-interactive

# ── Load modules ───────────────────────────────────────────────────────────────
for _mod in \
  "10-options" \
  "20-completion" \
  "25-keybinds" \
  "30-integrations" \
  "40-aliases" \
  "50-workflow"
do
  _f="${ZDOTDIR}/conf.d/${_mod}.zsh"
  [[ -r "$_f" ]] && source "$_f"
done
unset _mod _f

# ── Prompt (starship) ─────────────────────────────────────────────────────────
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# ── opam (OCaml) – auto-generated, safe to keep ───────────────────────────────
[[ -r "${HOME}/.opam/opam-init/init.zsh" ]] \
  && source "${HOME}/.opam/opam-init/init.zsh" &>/dev/null || true
