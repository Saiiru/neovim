return {
  "williamboman/mason.nvim",
  dependencies = {
    "zapling/mason-lock.nvim", -- Handle lockfiles for ensuring consistent tool versions
    cmd = { "MasonLock", "MasonLockRestore" }, -- Commands for locking and restoring tool versions
    opts = {
      -- Any future options can be added here for further customization
    },
  },
  opts = {
    -- Add your mason.nvim options here
    -- For instance, you could specify tool installations, or more setup customization
  },
}
