return {
  "elmcgill/springboot-nvim",
  ft = "java",
  dependencies = {
    "mfussenegger/nvim-jdtls",
    "neovim/nvim-lspconfig",
  },
  config = function()
    local springboot = require "springboot-nvim"

    vim.keymap.set("n", "<leader>Jr", springboot.boot_run, { desc = "[J]ava [R]un Spring Boot" })
    vim.keymap.set("n", "<leader>Jc", springboot.generate_class, { desc = "[J]ava Create [C]lass" })
    vim.keymap.set("n", "<leader>Ji", springboot.generate_interface, { desc = "[J]ava Create [I]nterface" })
    vim.keymap.set("n", "<leader>Je", springboot.generate_enum, { desc = "[J]ava Create [E]num" })
  end,
}
