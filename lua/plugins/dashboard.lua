return {
  "nvimdev/dashboard-nvim",
  enabled = true, -- Habilitar o plugin
  config = function()
    local db = require("dashboard")

    -- Customizando o cabeçalho com um estilo cyberpunk (ASCII Art ou logo da Afterlife)
    db.custom_header = {
      "    ____    ____  __      __ ______ _    _ ______ _    _ ",
      "   / __ \\  / __ \\|  \\    /  |  ____| |  | |  ____| |  | |",
      "  | |  | || |  | ||   \\  /   | |__  | |  | | |__  | |__| |",
      "  | |  | || |  | || |\\ \\/ /| |  __| | |  | |  __| |  __  |",
      "  | |__| || |__| || | \\  / | |_____| |__| | |____| |  | |",
      "   \\____/  \\____/ |_| \\/  |______|______|______|_|  |_|",
      "",
      "    __        ______    __    __       __    __  ______ _    _",
      "   |   | |    |    |   | |    |__|    | |  |   |      |   |",
      "   |____| |____|____|__| |____|____   |  |  |____|_____  |____|",
    }

    -- Configurando a seção de atalhos personalizados
    db.custom_center = {
      { icon = "  ", desc = "Find File", action = "Telescope find_files" },
      { icon = "  ", desc = "Recent Files", action = "Telescope oldfiles" },
      { icon = "  ", desc = "New File", action = "enew" },
      { icon = "  ", desc = "Find Word", action = "Telescope live_grep" },
    }

    -- Ajustes de estilo cyberpunk
    vim.cmd([[highlight DashboardHeader guifg=#FF79C6 guibg=NONE]]) -- Cor de destaque para o cabeçalho
    vim.cmd([[highlight DashboardCenter guifg=#50FA7B guibg=NONE]]) -- Cor verde para os atalhos
    vim.cmd([[highlight DashboardFooter guifg=#6272A4 guibg=NONE]]) -- Cor azul para o rodapé

    -- Função para frases aleatórias
    local quotes = {
      -- Sherlock Holmes
      "There is nothing more deceptive than an obvious fact.",
      "My mind rebels at stagnation. Give me work. The sooner the better.",
      "I never guess. It is a shocking habit destructive to the logical faculty.",
      "You see, but you do not observe.",
      "When you have eliminated the impossible, whatever remains, however improbable, must be the truth.",
      "Education never ends, It is a series of lessons, with the greatest for the last.",
      "Crime is common. Logic is rare: Therefore it is upon the logic rather than upon the crime that you should dwell.",

      -- Doctor Who
      "The Doctor: You want weapons? We're in a library! Books are the best weapon in the world.",
      "The Doctor: Time travel is like visiting Paris. You can't just read the guidebook. You've got to throw yourself in.",
      "The Doctor: I am the Doctor, and this is my spoon.",
      "The Doctor: We're all stories, in the end. Just make it a good one, eh?",
      "The Doctor: Never cruel or cowardly. Never give up. Never give in.",
      "The Doctor: You can't rewrite history, not one line!",
      "The Doctor: I’m sorry. I’m so sorry.",
    }

    -- Função para escolher uma frase aleatória
    local function get_random_quote()
      math.randomseed(os.time()) -- Semente para gerar números aleatórios
      return quotes[math.random(1, #quotes)] -- Seleciona uma frase aleatória
    end

    -- Rodapé com frase aleatória
    db.custom_footer = {
      get_random_quote(), -- Adiciona uma frase aleatória do array
    }
  end,
}
