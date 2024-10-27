return {
  'Wansmer/treesj',
  keys = { '<leader>jt', '<leader>jj', '<leader>je', '<leader>jc' }, -- Include all keys in the mapping
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    local status, treesj = pcall(require, 'treesj') -- Error handling for loading treesj
    if not status then
      vim.notify("Error loading Treesj: " .. tostring(treesj), vim.log.levels.ERROR)
      return
    end

    -- Setup Treesj with customized options
    treesj.setup({
      use_default_keymaps = false, -- Disable default keymaps for customization
      max_join_length = 1000,      -- Maximum length for joining
    })

    -- Define key mappings with descriptive comments
    vim.keymap.set('n', "<leader>jj", treesj.toggle, { desc = "Toggle join/split" })       -- Toggle between join and split
    vim.keymap.set('n', "<leader>je", treesj.split, { desc = "Expand selected nodes" })    -- Expand nodes
    vim.keymap.set('n', "<leader>jc", treesj.toggle, { desc = "Collapse selected nodes" }) -- Collapse nodes
  end,
}
