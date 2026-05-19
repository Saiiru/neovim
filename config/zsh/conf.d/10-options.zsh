# conf.d/10-options.zsh – zsh behaviour options

setopt prompt_subst
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent

# History
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_verify
setopt hist_find_no_dups
setopt share_history
setopt extended_history        # timestamp in history file

# Globbing / misc
setopt no_beep
setopt no_case_glob
setopt interactive_comments
setopt glob_dots               # ls * matches dotfiles too
setopt numeric_glob_sort

# Completion
setopt auto_menu
setopt complete_in_word
setopt always_to_end
