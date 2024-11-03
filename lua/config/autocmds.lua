-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- Criação de um namespace para a ocultação de classes no HTML
local namespace = vim.api.nvim_create_namespace("class_conceal")

-- Criação de um grupo de autocmds para gerenciar os eventos de ocultação
local group = vim.api.nvim_create_augroup("class_conceal", { clear = true })

-- Função para ocultar valores da classe em arquivos HTML
local function conceal_html_class(bufnr)
  -- Obtém a árvore de sintaxe do parser Treesitter para o buffer atual
  local language_tree = vim.treesitter.get_parser(bufnr, "html")
  local syntax_tree = language_tree:parse()
  local root = syntax_tree[1]:root()

  -- Define a consulta Treesitter para capturar atributos "class"
  local query = vim.treesitter.parse_query(
    "html",
    [[
    ((attribute
        (attribute_name) @att_name (#eq? @att_name "class")
        (quoted_attribute_value (attribute_value) @class_value) (#set! @class_value conceal "…")))
    ]]
  )

  -- Itera sobre os matches encontrados na árvore de sintaxe
  for _, captures, metadata in query:iter_matches(root, bufnr, root:start(), root:end_()) do
    local start_row, start_col, end_row, end_col = captures[2]:range()
    -- Define um extmark no buffer para ocultar o valor da classe
    vim.api.nvim_buf_set_extmark(bufnr, namespace, start_row, start_col, {
      end_line = end_row,
      end_col = end_col,
      conceal = metadata[2].conceal,
    })
  end
end

-- Cria um autocmd que chama a função conceal_html_class em eventos específicos
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "InsertLeave" }, {
  group = group,
  pattern = { "*.html" }, -- O autocmd é acionado para arquivos HTML
  callback = function(match)
    -- Chama a função para ocultar classes no buffer atual
    conceal_html_class(vim.api.nvim_get_current_buf())
  end,
})

-- Criação de um grupo de autocmds para alternar a exibição de números relativos e listas
local set_toggle = vim.api.nvim_create_augroup("set_toggle", { clear = true })

-- Autocmd para desativar números relativos e ativar listas ao entrar no modo de inserção
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    if vim.bo.filetype ~= "alpha" and vim.bo.filetype ~= "NvimTree" and vim.bo.filetype ~= "SidebarNvim" then
      vim.opt.relativenumber = false -- Desativa números relativos
      vim.opt.list = true -- Ativa a exibição de caracteres especiais
    end
  end,
  group = set_toggle,
})

-- Autocmd para ativar números relativos e desativar listas ao sair do modo de inserção
vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter", "InsertLeave" }, {
  callback = function()
    if vim.bo.filetype ~= "alpha" and vim.bo.filetype ~= "NvimTree" and vim.bo.filetype ~= "SidebarNvim" then
      vim.opt.relativenumber = true -- Ativa números relativos
      vim.opt.list = false -- Desativa a exibição de caracteres especiais
    end
  end,
  group = set_toggle,
})

-- Autocmd para ajustar a altura do comando durante a gravação
vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
  callback = function(match)
    -- Define a altura do comando com base no estado de gravação
    vim.o.cmdheight = match.event == "RecordingEnter" and 1 or 0
  end,
})
