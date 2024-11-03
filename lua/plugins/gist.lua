return {
  {
    "Rawnly/gist.nvim", -- Gist management plugin for Neovim
    cmd = { "GistCreate", "GistCreateFromFile", "GistsList" }, -- Commands exposed by the plugin
    config = function() -- Configuration function
      -- Any additional configuration for gist.nvim can be placed here
    end,
  },
  {
    "samjwill/nvim-unception", -- Prevents Neovim buffer inception with remote RPC
    lazy = false, -- Ensure plugin is loaded immediately
    init = function()
      vim.g.unception_block_while_host_edits = true -- Prevent buffer inception while editing
    end,
    config = function() -- Configuration for nvim-unception
      -- Additional setup can be added here if needed
    end,
  },
}
