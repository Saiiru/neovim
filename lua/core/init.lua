-- init.lua (topo)
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- se tiver util de projeto:
pcall(function() require("utils.project").setup() end)

-- depois vem seu lazy, plugins etc.
require("lazy").setup("plugins", { ui = { border = "rounded" } })

