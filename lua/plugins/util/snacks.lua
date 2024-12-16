return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        header = [[
                                                                   
      ████ ██████           █████      ██                    
     ███████████             █████                            
     █████████ ███████████████████ ███   ███████████  
    █████████  ███    █████████████ █████ ██████████████  
   █████████ ██████████ █████████ █████ █████ ████ █████  
 ███████████ ███    ███ █████████ █████ █████ ████ █████ 
██████  █████████████████████ ████ █████ █████ ████ ██████
        ]],
      },
    },
    lazygit = {
      configure = false, -- Keep this as false for a more manual approach to lazygit configuration
    },
    notifier = {
      style = "fancy", -- Fancy notifications add a great touch for cyberpunk vibes
    },
    terminal = {
      win = {
        position = "float", -- Keep terminal windows floating for sleekness and easy access
      },
    },
    scroll = {
      animate = {
        duration = { step = 10, total = 150 }, -- Smooth scrolling for a better user experience
      },
    },
  },
}
