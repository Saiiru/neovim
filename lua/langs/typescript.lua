-- lua/langs/typescript.lua
-- TypeScript/JavaScript DAP configuration
local M = {}

function M.setup()
  pcall(function()
    local dap = require("dap")
    local mason_registry = require("mason-registry")

    local pkg = mason_registry.get_package("js-debug-adapter")
    if not (pkg and pkg:is_installed()) then
      return
    end
    local adapter_path = pkg:get_install_path() .. "/js-debug/src/dapDebugServer.js"

    dap.adapters["pwa-node"] = {
      type = "server",
      host = "127.0.0.1",
      port = "${port}",
      executable = { command = "node", args = { adapter_path, "${port}" } },
    }

    dap.configurations.typescript = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch TS file",
        program = "${file}",
        cwd = "${workspaceFolder}",
        runtimeExecutable = "node",
        runtimeArgs = { "--loader=ts-node/esm" },
        sourceMaps = true,
        resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
      },
    }
    dap.configurations.javascript = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch JS file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
    }
    dap.configurations.typescriptreact = dap.configurations.typescript
    dap.configurations.javascriptreact = dap.configurations.javascript
  end)
end

return M