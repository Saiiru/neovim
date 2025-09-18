-- lua/langs/cpp.lua
-- C/C++ DAP configuration
local M = {}

function M.setup()
  pcall(function()
    local dap = require("dap")
    local mason_registry = require("mason-registry")

    local pkg = mason_registry.get_package("codelldb")
    if not (pkg and pkg:is_installed()) then
      return
    end
    local install = pkg:get_install_path()
    local codelldb = install .. "/extension/adapter/codelldb"

    dap.adapters.codelldb = function(cb, _)
      local stdout = vim.loop.new_pipe(false)
      local handle, _ = require("dap.utils").spawn(codelldb, { stdio = { nil, stdout }, detached = true })
      stdout:read_start(function(err, chunk)
        assert(not err, err)
        if chunk then
          local port = chunk:match("Listening on port (%d+)")
          if port then
            cb({ type = "server", host = "127.0.0.1", port = port })
          end
        end
      end)
    end

    dap.configurations.cpp = {
      {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/dist/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
      },
    }
    dap.configurations.c = dap.configurations.cpp
  end)
end

return M