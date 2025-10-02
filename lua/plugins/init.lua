return {
	"nvim-lua/plenary.nvim", --lua functions that many plugins use
	"christoomey/vim-tmux-navigator", -- tmux & split window nav
    -- fixes the well know nvim bug
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                {
                    path = "${3rd}/plenary.nvim/lua",
                    words = { "plenary" }
                },
            },
        },
    },
-- Java LSP + Debug/Test
{ "mfussenegger/nvim-jdtls" },
{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
{ "jay-babu/mason-nvim-dap.nvim" },

-- Breadcrumbs estilo IDE
{ "SmiteshP/nvim-navic" },

-- Inline “lenses” (refs/impl) tipo JetBrains
{ "VidocqH/lsp-lens.nvim", config = true },

-- Diags inline fluindo (menos poluição que virtual_text fixo)
{ "dgagn/diagflow.nvim", opts = { toggle_event = { "InsertEnter","InsertLeave" } } },

-- Testes com UI/inline
{ "nvim-neotest/neotest",
  dependencies = {
    "rcasia/neotest-java",   -- adapter Java
    "nvim-neotest/nvim-nio"
  }
},
}
