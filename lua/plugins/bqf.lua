local function toggleQf()
  -- Alterna a quickfix list aberta/fechada conforme o tipo de buffer
  if vim.bo.filetype == "qf" then
    vim.cmd.cclose()
  else
    vim.cmd.copen()
  end
end

local function setupBqf()
  -- Configuração para o bqf, com preview e opções de border
  require("bqf").setup({
    border = 'rounded',
    preview = {
      description = "Tornar BQF opaco",
      winblend = 0,
    },
  })
end

local function setupKeymaps()
  -- Configurações de teclas para navegar e abrir/fechar o quickfix
  local opts = { silent = true, desc = "Toggle Quickfix" }
  vim.keymap.set("n", "<leader>q", toggleQf, opts)
  vim.keymap.set("n", "]q", ":cnext<CR>", { desc = "Quickfix Next" })
  vim.keymap.set("n", "[q", ":cprev<CR>", { desc = "Quickfix Previous" })
end

local function setup()
  setupBqf()
  setupKeymaps()
end

-- Retorna a configuração do plugin com dependência e execução de FZF
return {
  "kevinhwang91/nvim-bqf",
  dependencies = {
    {
      'junegunn/fzf',
      run = function()
        if not pcall(vim.fn["fzf#install"]) then
          vim.api.nvim_err_writeln("FZF não pôde ser instalado!")
        end
      end
    },
  },
  config = setup,
}
