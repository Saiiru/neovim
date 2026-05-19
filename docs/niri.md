# Niri Automation & IPC

## Strategy
Niri provides a powerful IPC mechanism via Unix sockets. This repository leverages `niri msg` to perform atomic layout changes and state inspection.

Niri is the canonical compositor and should stay minimal:
- no legacy shell bindings or daemon startup
- no references to removed shell trees
- launcher fallback: `kora-launcher` then `fuzzel`

## Key Commands
- `bin/niri/actions`: A high-level wrapper for common tasks (focus, move, screenshot).
- `bin/niri/validate`: Validates the `config.kdl` and checks for broken script references.

## IPC Examples
```bash
# Get focused window app-id
niri msg --json focused-window | jq -r '.app_id'

# Switch to workspace 2
niri msg action focus-workspace 2
```
