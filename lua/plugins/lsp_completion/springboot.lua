local function has_jdtls()
  return #vim.api.nvim_get_runtime_file("lua/jdtls.lua", false) > 0
end

return {
  "elmcgill/springboot-nvim",
  ft = "java",
  cond = has_jdtls,
  dependencies = {
    "mfussenegger/nvim-jdtls",
    "neovim/nvim-lspconfig",
  },
  config = function()
    local ok, springboot = pcall(require, "springboot-nvim")
    if not ok then
      return
    end

    vim.keymap.set("n", "<leader>Jr", springboot.boot_run, { desc = "[J]ava [R]un Spring Boot" })
    vim.keymap.set("n", "<leader>Jc", springboot.generate_class, { desc = "[J]ava Create [C]lass" })
    vim.keymap.set("n", "<leader>Ji", springboot.generate_interface, { desc = "[J]ava Create [I]nterface" })
    vim.keymap.set("n", "<leader>Je", springboot.generate_enum, { desc = "[J]ava Create [E]num" })
  end,
}
