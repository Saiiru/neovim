-- NOTE: Notification
return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  opts = {
    level = 2,
    minimum_width = 50,
    render = "minimal", -- Clean, cyberpunk-style rendering
    stages = "fade_in_slide_out",
    timeout = 3000,
    top_down = false,
    background_colour = "#1e1e2e", -- Dark background color
    icons = {
      ERROR = " ",
      WARN = " ",
      INFO = " ",
      DEBUG = " ",
      TRACE = "✎ ",
    },
  },
  config = function(_, opts)
    -- Configure the 'notify' plugin
    require("notify").setup(opts)
    vim.notify = require("notify")

    -- Motivational messages at startup
    local motivational_messages = {
      "Keep pushing forward!",
      "The game's afoot!",
      "Code like the wind, Sairu!",
      "Don't stop until you're proud!",
      "The future is yours to script!",
    }

    -- Show a random motivational message if 'startup_message' is enabled
    if vim.g.startup_message then
      math.randomseed(os.time())
      local message = motivational_messages[math.random(#motivational_messages)]
      vim.notify(message, vim.log.levels.INFO, { title = "Startup Message" })
    end
  end,
}
