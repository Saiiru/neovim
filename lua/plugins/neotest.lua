local u = require("config.functions.utils")

-- local u = require("config.functions.utils")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "neotest-summary",
  callback = function()
    vim.wo.wrap = false
  end,
})

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "marilari88/neotest-vitest",
    "nvim-neotest/neotest-go",
    -- "rouge8/neotest-junit",
    "andy-bell101/neotest-java",
  },
  config = function()
    local neotest = require("neotest")
    local map_opts = { noremap = true, silent = true, nowait = true }

    -- Namespace personalizado para Neotest
    local neotest_ns = vim.api.nvim_create_namespace("neotest")
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          return diagnostic.message:gsub("%s+", " "):gsub("^%s+", "")
        end,
      },
    }, neotest_ns)

    -- Configuração principal do Neotest
    neotest.setup({
      quickfix = { open = false, enabled = false },
      status = { enabled = true, signs = true, virtual_text = false },
      icons = {
        child_indent = "│",
        child_prefix = "├",
        collapsed = "─",
        expanded = "╮",
        failed = "✘",
        final_child_indent = " ",
        final_child_prefix = "╰",
        non_collapsible = "─",
        passed = "✓",
        running = "",
        running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
        skipped = "↓",
        unknown = ""
      },
      floating = {
        border = "rounded",
        max_height = 0.9,
        max_width = 0.9,
      },
      summary = {
        open = "botright vsplit | vertical resize 60",
        mappings = {
          attach = "a",
          clear_marked = "M",
          clear_target = "T",
          debug = "d",
          debug_marked = "D",
          expand = { "<CR>", "<2-LeftMouse>" },
          expand_all = "e",
          jumpto = "i",
          mark = "m",
          next_failed = "J",
          output = "o",
          prev_failed = "K",
          run = "r",
          run_marked = "R",
          short = "O",
          stop = "u",
          target = "t",
          watch = "w"
        },
      },
      highlights = {
        adapter_name = "NeotestAdapterName",
        border = "NeotestBorder",
        dir = "NeotestDir",
        expand_marker = "NeotestExpandMarker",
        failed = "NeotestFailed",
        file = "NeotestFile",
        focused = "NeotestFocused",
        indent = "NeotestIndent",
        marked = "NeotestMarked",
        namespace = "NeotestNamespace",
        passed = "NeotestPassed",
        running = "NeotestRunning",
        select_win = "NeotestWinSelect",
        skipped = "NeotestSkipped",
        target = "NeotestTarget",
        test = "NeotestTest",
        unknown = "NeotestUnknown"
      },
      adapters = {
        require("neotest-vitest"),
        require("neotest-go"),
        -- require("neotest-junit")({
        --   command = "java -jar junit-platform-console-standalone.jar",
        -- })
      }
    })

    -- Cores customizadas (conforme especificado)
    local custom_colors = {
      NeotestBorder = "#4B5263",       -- Cinza escuro para bordas
      NeotestIndent = "#4B5263",       -- Cinza escuro para indentação
      NeotestExpandMarker = "#4B5263", -- Cinza escuro para marcadores de expansão
      NeotestDir = "#4B5263",          -- Cinza escuro para diretórios
      NeotestFile = "#ABB2BF",         -- Branco suave para nomes de arquivos
      NeotestFailed = "#E06C75",       -- Vermelho para testes falhados
      NeotestPassed = "#98C379",       -- Verde para testes aprovados
      NeotestSkipped = "#4B5263",      -- Cinza escuro para testes pulados
      NeotestRunning = "#E5C07B",      -- Amarelo para testes em execução
      NeotestNamespace = "#61AFEF",    -- Azul para namespaces
      NeotestAdapterName = "#C678DD",  -- Violeta para adaptadores
    }

    for group, color in pairs(custom_colors) do
      vim.api.nvim_set_hl(0, group, { fg = color })
    end

    -- Keymaps personalizados
    vim.keymap.set("n", "<localleader>tfr", function() neotest.run.run(vim.fn.expand("%")) end, map_opts)
    vim.keymap.set("n", "<localleader>tr", function()
      neotest.run.run(); neotest.summary.open()
    end, map_opts)
    vim.keymap.set("n", "<localleader>to", function() neotest.output.open({ last_run = true, enter = true }) end)
    vim.keymap.set("n", "<localleader>tt", function()
      neotest.summary.toggle(); u.resize_vertical_splits()
    end, map_opts)
    vim.keymap.set("n", "<localleader>tl",
      function()
        neotest.run.run_last({ enter = true }); neotest.output.open({ last_run = true, enter = true })
      end, map_opts)
  end,
}
