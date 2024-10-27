return {
  "numToStr/FTerm.nvim",
  config = function()
    local fTerm = require("FTerm")

    -- Define cores diretamente
    local bg_color = '#171717' -- Cor de fundo do terminal
    local normal_color = { bg = bg_color }

    -- Mapeia as teclas para alternar o terminal
    vim.keymap.set("n", "<C-z>", function()
      fTerm.toggle()
      local ns = vim.api.nvim_create_namespace(vim.bo.filetype)
      vim.api.nvim_win_set_hl_ns(0, ns)
      vim.api.nvim_set_hl(ns, "Normal", normal_color)
    end, {})

    vim.keymap.set("t", "<C-z>", function()
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<C-\\><C-n>:lua require('FTerm').toggle()<CR>", false, true, true), "n", false)
    end)

    -- Configurações do FTerm
    fTerm.setup({
      border     = 'none',
      ft         = 'terminal',
      dimensions = {
        height = 0.5,
        width = 1,
        x = 0, -- Eixo X da janela do terminal
        y = 1, -- Eixo Y da janela do terminal
      },
    })

    -- Autocomando para definir a cor de fundo do terminal
    vim.api.nvim_create_autocmd('FileType', {
      pattern = "terminal",
      callback = function()
        local ns = vim.api.nvim_create_namespace(vim.bo.filetype)
        vim.api.nvim_win_set_hl_ns(0, ns)
        vim.api.nvim_set_hl(ns, "Normal", normal_color)
      end,
    })

    -- Autocomando para desligar o terminal ao receber uma requisição de edição
    vim.api.nvim_create_autocmd("User", {
      pattern = "UnceptionEditRequestReceived",
      callback = function()
        fTerm.toggle()
      end
    })
  end
}
