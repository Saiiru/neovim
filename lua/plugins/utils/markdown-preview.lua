-- lua/plugins/utils/markdown-preview.lua

return {
  "iamcco/markdown-preview.nvim",
  ft = { "markdown", "mdx" },
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && yarn install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown", "mdx" }
    vim.g.mkdp_auto_start = 0
    vim.g.mkdp_auto_close = 1
  end,
  config = function()
    vim.keymap.set("n", "<leader>om", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown Preview" })
  end,
}
