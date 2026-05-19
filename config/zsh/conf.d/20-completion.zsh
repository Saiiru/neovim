# conf.d/20-completion.zsh

typeset -g ZCOMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${HOST}-${ZSH_VERSION}"

zmodload zsh/complist
autoload -Uz compinit
compinit -d "$ZCOMPDUMP" -i

zstyle ':completion:*'              menu              select
zstyle ':completion:*'              matcher-list      'm:{a-z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*'              list-colors       "${(s.:.)LS_COLORS}"
zstyle ':completion:*'              squeeze-slashes   true
zstyle ':completion:*:descriptions' format            '%F{blue}── %d ──%f'
zstyle ':completion:*:messages'     format            '%F{yellow}%d%f'
zstyle ':completion:*:warnings'     format            '%F{red}no matches%f'
zstyle ':completion:*'              completer         _extensions _complete _approximate
zstyle ':completion:*:approximate:*' max-errors       2

# ── plugins (system-installed first, then fallback locations) ─────────────────
_try_source() { [[ -r "$1" ]] && source "$1" && return 0; return 1; }

_try_source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh \
|| _try_source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
|| _try_source "${XDG_DATA_HOME}/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

_try_source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
|| _try_source "${XDG_DATA_HOME}/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

unfunction _try_source

# ── fzf / zoxide ──────────────────────────────────────────────────────────────
command -v fzf    &>/dev/null && source <(fzf --zsh)    2>/dev/null || true
command -v zoxide &>/dev/null && eval "$(zoxide init zsh --cmd cd)" || true
