#!/usr/bin/env bash
# ~/.config/tmux/scripts/status-git.sh
# Outputs a compact git status for the tmux statusline.
# Matches the Neovim lualine vocabulary: branch + diff (+ ~ -) + sync state.
# Usage: status-git.sh [path]

path="${1:-$PWD}"
cd "$path" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree &>/dev/null || exit 0

branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null \
         || printf "detached@%s" "$(git rev-parse --short HEAD 2>/dev/null)")

# Ahead/behind. git prints: "<left> <right>" where left is behind and right is ahead.
ahead=0
behind=0
if ab=$(git rev-list --left-right --count "@{upstream}...HEAD" 2>/dev/null); then
  read -r behind ahead <<< "$ab"
fi

added=0
modified=0
removed=0
while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  x="${line:0:1}"
  y="${line:1:1}"
  [[ "$x$y" == "??" ]] && { (( added++ )); continue; }
  [[ "$x" == "A" || "$y" == "A" ]] && (( added++ ))
  [[ "$x" == "M" || "$y" == "M" || "$x" == "R" || "$y" == "R" || "$x" == "C" || "$y" == "C" ]] && (( modified++ ))
  [[ "$x" == "D" || "$y" == "D" ]] && (( removed++ ))
done < <(git status --porcelain --ignore-submodules=dirty 2>/dev/null)

flags=""
(( added    > 0 )) && flags+=" #[fg=#56D4DD,bold]+${added}"
(( modified > 0 )) && flags+=" #[fg=#FFD000,bold]~${modified}"
(( removed  > 0 )) && flags+=" #[fg=#FF3B5C,bold]-${removed}"
(( ahead    > 0 )) && flags+=" #[fg=#39FF14,bold]↑${ahead}"
(( behind   > 0 )) && flags+=" #[fg=#A77DFF,bold]↓${behind}"

if [[ -n "$flags" ]]; then
  printf " %s%s" "$branch" "$flags"
else
  printf " %s" "$branch"
fi
