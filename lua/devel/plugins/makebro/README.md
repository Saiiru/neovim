# Makebro


## Installation

### Lazy

```lua
local plugin_path = vim.fn.stdpath("config") .. "/lua/devel/plugins/makebro"

return {
  dir = plugin_path,
  lazy = true,
  cmd = "Makebro",
  config = function()
    require("makebro")
  end
}
```
