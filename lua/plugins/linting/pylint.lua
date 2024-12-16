return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "pylint", -- Ensures pylint is installed for Python linting
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- Ensure the linters_by_ft table exists for Python, then add pylint to it
      opts.linters_by_ft.python = opts.linters_by_ft.python or {}

      -- Only insert pylint if it's not already in the list to avoid duplicates
      if not vim.tbl_contains(opts.linters_by_ft.python, "pylint") then
        table.insert(opts.linters_by_ft.python, "pylint")
      end

      return opts
    end,
  },
}
