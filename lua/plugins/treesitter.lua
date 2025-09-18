-- lua/plugins/treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "lua","vim","vimdoc","regex","bash","json","yaml","toml","markdown","markdown_inline",
        "javascript","typescript","tsx","css","html","svelte","vue","astro",
        "java","go","python","rust","cpp","c","php","graphql","dockerfile","query",
      },
      autotag = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}