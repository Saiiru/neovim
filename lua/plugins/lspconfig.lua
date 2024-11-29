local M = {}

local diagnostics = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}

local setup_keymaps = function(client, bufnr)
  local keymaps = require("utils.lsp").get_default_keymaps()

  local has_fzf = not vim.g.vscode and package.loaded["fzf-lua"]

  if has_fzf then
    vim.list_extend(keymaps, {
      {
        keys = "gd",
        func = "<cmd>FzfLua lsp_definitions jump_to_single_result=true ignore_current_line=true<cr>",
        desc = "Goto Definition",
        has = "definitionProvider",
      },
      {
        keys = "gr",
        func = "<cmd>FzfLua lsp_references jump_to_single_result=true ignore_current_line=true<cr>",
        desc = "Goto References",
        has = "referencesProvider",
        nowait = true,
      },
      {
        keys = "gi",
        func = "<cmd>FzfLua lsp_implementations jump_to_single_result=true ignore_current_line=true<cr>",
        desc = "Goto Implementation",
        has = "implementationProvider",
      },
      {
        keys = "gy",
        func = "<cmd>FzfLua lsp_typedefs jump_to_single_result=true ignore_current_line=true<cr>",
        desc = "Goto Type Definition",
        has = "typeDefinitionProvider",
      },
    })
  end

  if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
    table.insert(keymaps, {
      keys = "<leader>th",
      func = function()
        vim.lsp.inlay_hint(bufnr, true)
      end,
      desc = "Toggle Inlay Hints",
    })
  end

  for _, keymap in ipairs(keymaps) do
    if not keymap.has or client.server_capabilities[keymap.has] then
      vim.keymap.set(
        "n",
        keymap.keys,
        keymap.func,
        { buffer = bufnr, desc = "LSP: " .. keymap.desc, nowait = keymap.nowait }
      )
    end
  end
end

M.setup = function()
  require("lazy").setup {
    {
      "neovim/nvim-lspconfig",
      event = "VeryLazy",
      dependencies = { "mason.nvim", "williamboman/mason-lspconfig.nvim" },
      opts = function()
        return {
          diagnostics = {
            underline = true,
            update_in_insert = false,
            virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
            severity_sort = true,
            signs = { text = diagnostics },
          },
          inlay_hints = { enabled = true, exclude = { "vue" } },
          capabilities = vim.lsp.protocol.make_client_capabilities(),
          servers = {},
          setup = {},
        }
      end,
      config = function(_, opts)
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
        vim.lsp.handlers["textDocument/signatureHelp"] =
          vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })

        vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

        local capabilities = vim.tbl_deep_extend(
          "force",
          {},
          opts.capabilities,
          require("cmp_nvim_lsp").default_capabilities(),
          opts.capabilities or {}
        )

        local function setup(server)
          local server_opts =
            vim.tbl_deep_extend("force", { capabilities = vim.deepcopy(capabilities) }, opts.servers[server] or {})
          if opts.setup[server] and opts.setup[server](server, server_opts) then
            return
          end
          require("lspconfig")[server].setup(server_opts)
        end

        local all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
        local ensure_installed = {}

        for server, server_opts in pairs(opts.servers) do
          if server_opts and server_opts ~= false then
            if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
              setup(server)
            else
              table.insert(ensure_installed, server)
            end
          end
        end

        require("mason-lspconfig").setup { ensure_installed = ensure_installed, handlers = { setup } }
      end,
    },
    {
      "williamboman/mason.nvim",
      cmd = "Mason",
      keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
      build = ":MasonUpdate",
      opts = { ensure_installed = { "stylua" } },
      config = function(_, opts)
        require("mason").setup(opts)
        local mr = require "mason-registry"
        mr:on("package:install:success", function()
          vim.defer_fn(function()
            require("lazy.core.handler.event").trigger { event = "FileType", buf = vim.api.nvim_get_current_buf() }
          end, 100)
        end)
        mr.refresh(function()
          for _, tool in ipairs(opts.ensure_installed) do
            if not mr.get_package(tool):is_installed() then
              mr.get_package(tool):install()
            end
          end
        end)
      end,
    },
  }
end

return M
