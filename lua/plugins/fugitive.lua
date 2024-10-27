local u = require("config.functions.utils")

local toggle_status = function()
  local ft = vim.bo.filetype
  if ft == "fugitive" then
    vim.api.nvim_command("bd")
  else
    local fugitive_tab = u.get_tab_by_buf_name("fugitive", true)
    if fugitive_tab ~= -1 then
      vim.api.nvim_set_current_tabpage(fugitive_tab)
    end
    vim.api.nvim_command("silent! :Git")
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>T", false, true, true), "n", false)
  end
end

return {
  "tpope/vim-fugitive",
  config = function()
    -- Definindo opções de mapeamento
    local map_opts = { noremap = true, silent = true, nowait = true, buffer = false }

    -- Mapeamentos de teclas
    vim.keymap.set("n", "<leader>gs", toggle_status, map_opts)                                                         -- Alternar status do Fugitive
    vim.keymap.set("n", "<leader>p", function() vim.cmd.Git('push') end, { desc = "Push para origin" })                -- Push
    vim.keymap.set("n", "<leader>P", function() vim.cmd.Git({ 'pull', '--rebase' }) end, { desc = "Pull com rebase" }) -- Pull com rebase
    vim.keymap.set("n", "<leader>t", ":Git push -u origin ", { desc = "Configurar branch e push" })                    -- Configurar branch
    vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>", { desc = "Obter versão 2 do diff" })                             -- Obter versão 2 do diff
    vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>", { desc = "Obter versão 3 do diff" })                             -- Obter versão 3 do diff

    -- Grupo de autocmd para configurar keymaps específicos em buffer do fugitive
    local ThePrimeagen_Fugitive = vim.api.nvim_create_augroup("ThePrimeagen_Fugitive", {})

    -- Autocomando para definir keymaps quando entrar no buffer fugitive
    vim.api.nvim_create_autocmd("BufWinEnter", {
      group = ThePrimeagen_Fugitive,
      pattern = "*",
      callback = function()
        if vim.bo.filetype ~= "fugitive" then
          return
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local opts = { buffer = bufnr, remap = false }

        -- Rebind dos keymaps para o buffer fugitive
        --   vim.keymap.set("n", "<leader>p", function() vim.cmd.Git('push') end, opts)
        --   vim.keymap.set("n", "<leader>P", function() vim.cmd.Git({ 'pull', '--rebase' }) end, opts)
        --   vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts)
      end,
    })
  end,
}
