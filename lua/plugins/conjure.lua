return {
  "Olical/conjure",
  ft = { "javascript", "typescript", "c", "cpp", "java" },
  config = function()
    local success, conjure = pcall(require, "conjure")
    if not success then
      vim.notify("Conjure not found! Please ensure it is installed.", vim.log.levels.ERROR)
      return
    end

    vim.g["conjure#mapping#doc_word"] = false
    vim.g["conjure#mapping#def_word"] = false
    vim.g["sexp_enable_insert_mode_mappings"] = 0
    vim.g["conjure#mapping#prefix"] = ",c"

    local keymap = vim.keymap.set
    keymap("n", "<localleader>er", ":ConjureEvalRootForm<CR>", { desc = "[E]val root form" })
    keymap("n", "<localleader>et", ":ConjureEvalBuf<CR> | :ConjureRunCurrentTest<CR>",
      { desc = "[E]val buffer and [T]est" })

    -- Setup para nvim-lspconfig
    require("lspconfig").tsserver.setup {}
    require("lspconfig").clangd.setup {}

    -- Configurações adicionais do Conjure
    conjure.setup({
      log = {
        wrap = true,
        hud = { enabled = false },
      },
      mapping = {
        eval_root = "<localleader>er",
        eval_buf = "<localleader>eb",
        test_run = "<localleader>et",
      },
    })
  end,
}
