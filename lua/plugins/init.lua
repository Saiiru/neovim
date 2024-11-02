return {
   { "nvim-neotest/nvim-nio" },
    { "rcarriga/nvim-notify" },
  { "williamboman/mason.nvim" },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "davidosomething/format-ts-errors.nvim" },
    }
  },
  { "WhoIsSethDaniel/mason-tool-installer.nvim" },
  { "MunifTanjim/nui.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp-signature-help" },
  { "hrsh7th/cmp-nvim-lua",                     ft = { "lua" } },
  { "hrsh7th/cmp-nvim-lsp" },
  { "folke/neodev.nvim" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "nvim-lua/plenary.nvim" },
  { "lukas-reineke/lsp-format.nvim" },
  { "tpope/vim-repeat" },
  { "tpope/vim-surround" },
  { "tpope/vim-rhubarb" },
  { "tpope/vim-eunuch" },
  { "guns/vim-sexp",                            ft = { "clojure" } },
  { "romainl/vim-cool" },
  { "kyazdani42/nvim-web-devicons" },
  { "lambdalisue/glyph-palette.vim" },
  { "AndrewRadev/tagalong.vim" },
  { "tpope/vim-abolish" },
  { 'djoshea/vim-autoread' },
  { "jbyuki/one-small-step-for-vimkind" },
  {
    -- https://github.com/mfussenegger/nvim-jdtls
    'mfussenegger/nvim-jdtls',
    ft = 'java', -- Enable only on .java file extensions
  },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },
  {
    'yamatsum/nvim-nonicons',
    requires = { 'kyazdani42/nvim-web-devicons' }
  },
}
