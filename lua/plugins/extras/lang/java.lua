-- Função para obter o caminho dos arquivos do JDTLS
local function get_jdtls()
  local mason_registry = require("mason-registry")
  local jdtls = mason_registry.get_package("jdtls")
  local jdtls_path = jdtls:get_install_path()
  local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  local SYSTEM = "linux"
  local config = jdtls_path .. "/config_" .. SYSTEM
  local lombok = jdtls_path .. "/lombok.jar"
  return launcher, config, lombok
end

-- Função para obter o diretório de workspace
local function get_workspace()
  local home = os.getenv("HOME")
  local workspace_path = home .. "/code/workspace/"
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  if vim.fn.isdirectory(workspace_path) == 0 then
    vim.fn.mkdir(workspace_path, "p")
  end
  return workspace_path .. project_name
end

-- Define the on_attach function
local function on_attach(client, buffer)
  vim.keymap.set(
    "n",
    "<leader>di",
    "<Cmd>lua require'jdtls'.organize_imports()<CR>",
    { buffer = buffer, desc = "Organize Imports" }
  )
  vim.keymap.set(
    "n",
    "<leader>dt",
    "<Cmd>lua require'jdtls'.test_class()<CR>",
    { buffer = buffer, desc = "Test Class" }
  )
  vim.keymap.set(
    "n",
    "<leader>dn",
    "<Cmd>lua require'jdtls'.test_nearest_method()<CR>",
    { buffer = buffer, desc = "Test Nearest Method" }
  )
  vim.keymap.set(
    "v",
    "<leader>de",
    "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
    { buffer = buffer, desc = "Extract Variable" }
  )
  vim.keymap.set(
    "n",
    "<leader>de",
    "<Cmd>lua require('jdtls').extract_variable()<CR>",
    { buffer = buffer, desc = "Extract Variable" }
  )
  vim.keymap.set(
    "v",
    "<leader>dm",
    "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>",
    { buffer = buffer, desc = "Extract Method" }
  )
  vim.keymap.set("n", "<leader>cf", "<cmd>lua vim.lsp.buf.format()<CR>", { buffer = buffer, desc = "Format" })
end

return {
  { import = "lazyvim.plugins.extras.lang.java" },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = {
        "java",
      },
    },
  },
  {
    "elmcgill/springboot-nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-jdtls",
    },
    config = function()
      local springboot_nvim = require("springboot-nvim")
      vim.keymap.set("n", "<leader>Jr", springboot_nvim.boot_run, { desc = "[J]ava [R]un Spring Boot" })
      vim.keymap.set("n", "<leader>Jc", springboot_nvim.generate_class, { desc = "[J]ava Create [C]lass" })
      vim.keymap.set("n", "<leader>Ji", springboot_nvim.generate_interface, { desc = "[J]ava Create [I]nterface" })
      vim.keymap.set("n", "<leader>Je", springboot_nvim.generate_enum, { desc = "[J]ava Create [E]num" })
      springboot_nvim.setup({})
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mfussenegger/nvim-jdtls" },
    opts = {
      setup = {
        jdtls = function(_, opts)
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function()
              on_attach(_, opts.bufnr)

              local launcher, config, lombok = get_jdtls()
              local workspace_dir = get_workspace()

              local lsp_config = {
                cmd = {
                  "java",
                  "-javaagent:" .. lombok,
                  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                  "-Dosgi.bundles.defaultStartLevel=4",
                  "-Declipse.product=org.eclipse.jdt.ls.core.product",
                  "-Dlog.protocol=true",
                  "-Dlog.level=ALL",
                  "-Xms1g",
                  "--add-modules=ALL-SYSTEM",
                  "--add-opens",
                  "java.base/java.util=ALL-UNNAMED",
                  "--add-opens",
                  "java.base/java.lang=ALL-UNNAMED",
                  "-jar",
                  launcher,
                  "-configuration",
                  config,
                  "-data",
                  workspace_dir,
                },
                root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
                settings = { java = {} },
              }

              require("jdtls").start_or_attach(lsp_config)
            end,
          })
          return true
        end,
      },
    },
  },
  -- Configuração de linting com checkstyle
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        java = { "checkstyle" },
      }
      vim.api.nvim_create_autocmd("BufWritePost", {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  -- Configurações DAP para java-debug-adapter e java-test
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      dap.adapters.java = function(callback, config)
        callback({
          type = "server",
          host = "127.0.0.1",
          port = 5005,
        })
      end
      dap.configurations.java = {
        {
          type = "java",
          request = "attach",
          name = "Attach to the process",
          hostName = "127.0.0.1",
          port = 5005,
        },
        {
          type = "java",
          request = "launch",
          name = "Launch Java Program",
          mainClass = function()
            return vim.fn.input("Main class name: ", "", "file")
          end,
          projectName = function()
            return vim.fn.input("Project name: ", "", "file")
          end,
        },
      }
    end,
  },
}
