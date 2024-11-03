return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    lazy = true,
    config = function()
      local wk_present, wk = pcall(require, "which-key")
      if not wk_present then
        return
      end

      wk.setup({
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = true,
            suggestions = 20,
          },
          presets = {
            operators = false,
            motions = false,
            text_objects = false,
            windows = false,
            nav = false,
            z = false,
            g = false,
          },
        },
        icons = {
          breadcrumb = "»",
          separator = "➜",
          group = "+",
        },
        win = {
          border = "rounded",
          padding = { 2, 2, 2, 2 },
        },
        layout = {
          height = { min = 4, max = 25 },
          width = { min = 20, max = 50 },
          spacing = 4,
          align = "left",
        },
        show_help = true,
      })
      --
      -- -- Ignorar entradas
      -- wk.add({
      --   { "<leader><leader>", hidden = true },
      --   { "<leader>1", hidden = true },
      --   { "<leader>2", hidden = true },
      --   { "<leader>3", hidden = true },
      --   { "<leader>4", hidden = true },
      --   { "<leader>5", hidden = true },
      --   { "<leader>6", hidden = true },
      --   { "<leader>7", hidden = true },
      --   { "<leader>8", hidden = true },
      --   { "<leader>9", hidden = true },
      -- })
      --
      -- -- Mapeamentos de janela
      -- wk.add({
      --   { "<leader>=", "<cmd>vertical resize +5<CR>", desc = "Resize +5" },
      --   { "<leader>-", "<cmd>vertical resize -5<CR>", desc = "Resize -5" },
      --   { "<leader>v", "<C-W>v", desc = "Split Right" },
      --   { "<leader>V", "<C-W>s", desc = "Split Below" },
      --   { "<leader>q", desc = "Quicklist" },
      -- })
      --
      -- -- Mapeamentos do Telescope
      -- wk.add({
      --   { "<leader>f", group = "Find" },
      --   { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "[F]ind [F]iles" },
      --   { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "[F]ind by [G]rep" },
      --   { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "[F]ind [B]uffers" },
      --   { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "[F]ind [H]elp" },
      --   { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "[F]ind [R]ecent Files" },
      --   { "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "[F]ind [C]ursor String" },
      --   { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "[F]ind [T]odos" },
      --   { "<leader>fp", "<cmd>Telescope projects<cr>", desc = "[F]ind [P]rojects" },
      -- })
      --
      -- -- Mapeamentos de ações
      -- wk.add({
      --   { "<leader>a", group = "Actions", mode = { "n", "v" } },
      --   { "<leader>an", "<cmd>set nonumber!<CR>", desc = "Toggle Line Numbers" },
      --   { "<leader>ar", "<cmd>set norelativenumber!<CR>", desc = "Toggle Relative Number" },
      -- })
      --
      -- -- Mapeamentos de buffer
      -- wk.add({
      --   { "<leader>b", group = "Buffer" },
      --   { "<leader>bs", group = "Sort" },
      --   { "<leader>bc", '<cmd>lua require("utils").closeOtherBuffers()<CR>', desc = "Close Other Buffers" },
      --   { "<leader>bf", "<cmd>bfirst<CR>", desc = "First Buffer" },
      -- })
      --
      -- -- Mapeamentos LSP
      -- wk.add({
      --   { "<leader>c", group = "LSP", mode = { "n", "v" } },
      --   { "<leader>ca", desc = "Code Action", mode = { "n", "v" } },
      --   { "<leader>cd", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
      --   { "<leader>cD", "<cmd>Telescope diagnostics wrap_results=true<CR>", desc = "Workspace Diagnostics" },
      --   { "<leader>cf", desc = "Format", mode = { "n", "v" } },
      --   { "<leader>cl", desc = "Line Diagnostics" },
      --   { "<leader>cr", desc = "Rename" },
      --   { "<leader>cR", desc = "Structural Replace" },
      --   { "<leader>ct", '<cmd>LspToggleAutoFormat<CR>', desc = "Toggle Format on Save" },
      -- })
      --
      -- -- Mapeamentos de depuração
      -- wk.add({
      --   { "<leader>d", group = "Debug" },
      --   { "<leader>da", desc = "Attach" },
      --   { "<leader>db", desc = "Breakpoint" },
      --   { "<leader>dc", desc = "Continue" },
      --   { "<leader>dC", desc = "Close UI" },
      --   { "<leader>dd", desc = "Continue" },
      --   { "<leader>dh", desc = "Visual Hover" },
      --   { "<leader>di", desc = "Step Into" },
      --   { "<leader>do", desc = "Step Over" },
      --   { "<leader>dO", desc = "Step Out" },
      --   { "<leader>dr", desc = "REPL" },
      --   { "<leader>ds", desc = "Scopes" },
      --   { "<leader>dt", desc = "Terminate" },
      --   { "<leader>dU", desc = "Open UI" },
      --   { "<leader>dv", desc = "Log Variable" },
      --   { "<leader>dV", desc = "Log Variable Above" },
      --   { "<leader>dw", desc = "Watches" },
      -- })
      --
      -- -- Mapeamentos do Git
      -- wk.add({
      --   { "<leader>g", group = "Git", mode = { "n", "v" } },
      --   { "<leader>ga", "<cmd>!git add %:p<CR>", desc = 'Add Current File' },
      --   { "<leader>gA", "<cmd>!git add .<CR>", desc = 'Add All' },
      --   { "<leader>gb", "<cmd>BlameToggle window<CR>", desc = 'Blame' },
      --   { "<leader>gB", "<cmd>Telescope git_branches<CR>", desc = 'Branches' },
      --   { "<leader>gc", group = "Conflict" },
      --   { "<leader>gh", group = "Hunk" },
      --   { "<leader>ghr", desc = "Reset Hunk", mode = { "v" } },
      --   { "<leader>ghs", desc = "Stage Hunk", mode = { "v" } },
      --   { "<leader>gi", "<cmd>Octo issue list<CR>", desc = 'Issues List' },
      --   { "<leader>gl", group = "Log" },
      --   { "<leader>glA", "<cmd>lua require('plugins.telescope.pickers').my_git_commits()<CR>", desc = 'Commits (Telescope)' },
      --   { "<leader>gla", "<cmd>LazyGitFilter<CR>", desc = 'Commits' },
      --   { "<leader>glC", "<cmd>lua require('plugins.telescope.pickers').my_git_bcommits()<CR>", desc = 'Buffer Commits (Telescope)' },
      --   { "<leader>glc", "<cmd>LazyGitFilterCurrentFile<CR>", desc = 'Buffer Commits' },
      --   { "<leader>gm", desc = 'Blame Line' },
      --   { "<leader>gp", "<cmd>Octo pr list<CR>", desc = 'Pull Requests List' },
      --   { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = 'Telescope Status' },
      --   { "<leader>gw", group = "Worktree" },
      --   { "<leader>gww", desc = 'Worktrees' },
      --   { "<leader>gwc", desc = 'Create Worktree' },
      -- })
      --
      -- -- Mapeamentos de projetos
      -- wk.add({
      --   { "<leader>p", group = "Projects", mode = { "n", "v" } },
      --   { "<leader>pa", "<cmd>Telescope projects<CR>", desc = "Projects" },
      --   { "<leader>pR", "<cmd>Telescope repo list<CR>", desc = "Repositories" },
      --   { "<leader>pu", "<cmd>ProjectRoot<CR>", desc = "Root" },
      -- })
      --
      --    -- Mapeamentos do CopilotChat
      -- wk.add({
      --   { "<leader>cc", "<cmd>CopilotChat<CR>", desc = "Copilot Chat" },
      --   { "<leader>cO", "<cmd>CopilotChatOpen<CR>", desc = "Open Copilot Chat" },
      --   { "<leader>cC", "<cmd>CopilotChatClose<CR>", desc = "Close Copilot Chat" },
      --   { "<leader>ct", "<cmd>CopilotChatToggle<CR>", desc = "Toggle Copilot Chat" },
      --   { "<leader>cr", "<cmd>CopilotChatReset<CR>", desc = "Reset Copilot Chat" },
      --   { "<leader>cs", "<cmd>CopilotChatSave<CR>", desc = "Save Copilot Chat" },
      --   { "<leader>cl", "<cmd>CopilotChatLoad<CR>", desc = "Load Copilot Chat" },
      --   { "<leader>cd", "<cmd>CopilotChatDebugInfo<CR>", desc = "Debug Info" },
      --   { "<leader>ce", "<cmd>CopilotChatExplain<CR>", desc = "Explain Code" },
      --   { "<leader>crv", "<cmd>CopilotChatReview<CR>", desc = "Review Code" },
      --   { "<leader>cf", "<cmd>CopilotChatFix<CR>", desc = "Fix Code" },
      --   { "<leader>co", "<cmd>CopilotChatOptimize<CR>", desc = "Optimize Code" },
      --   { "<leader>cds", "<cmd>CopilotChatDocs<CR>", desc = "Show Docs" },
      --   { "<leader>ctt", "<cmd>CopilotChatTests<CR>", desc = "Generate Tests" },
      --   { "<leader>cfd", "<cmd>CopilotChatFixDiagnostic<CR>", desc = "Fix Diagnostic" },
      --   { "<leader>ccm", "<cmd>CopilotChatCommit<CR>", desc = "Commit Changes" },
      --   { "<leader>cst", "<cmd>CopilotChatCommitStaged<CR>", desc = "Commit Staged Changes" },
      -- })
    end,
  },
}
