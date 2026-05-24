local is_online = require("config.utils").is_online

return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  enabled = is_online(),
  opts = {
    panel = {
      enabled = false,
      auto_refresh = false,
    },
    -- Mantido desligado por padrão porque o Copilot já entra no `blink.cmp`.
    -- Se ligar as duas fontes ao mesmo tempo, a experiência duplica sugestões.
    suggestion = {
      enabled = false,
      auto_trigger = false,
      debounce = 75,
      keymap = {
        accept = "<C-v>",
        accept_word = false,
        accept_line = "<C-q>",
        next = false,
        prev = false,
        dismiss = "<C-]>",
      },
    },
    copilot_node_command = "node",
    filetypes = {
      ["*"] = false,
      avante = true,
      c = true,
      cpp = true,
      go = true,
      help = true,
      html = true,
      java = true,
      javascript = true,
      javascriptreact = true,
      lua = true,
      markdown = true,
      python = true,
      rust = true,
      typescript = true,
      typescriptreact = true,
    },
  },
  -- No direct keymaps: this plugin now serves as backend/completion support only.
}
