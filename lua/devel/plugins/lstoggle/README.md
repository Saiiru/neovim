# List Toggles


## Installation


### Lazy

```lua
-- ~/.config/nvim/lua/devel/plugins/lstoggle/
local plugin_path = vim.fn.stdpath("config") .. "/lua/devel/plugins/lstoggle"

return {
  dir = plugin_path,
  lazy = true,
  cmd = { "ToggleLocList", "ToggleQFList" },
    config = function()
      require("lstoggle")
    end
  }
```

