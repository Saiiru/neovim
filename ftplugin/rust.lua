vim.g.rustaceanvim = function()
  local bufmap = vim.api.nvim_buf_set_keymap
  local map = vim.api.nvim_set_keymap
  local opts = { noremap = true, silent = false }

  -- Update this path
  local codelldb_version = "1.11.1"
  local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-' .. codelldb_version .. '/'
  local codelldb_path = extension_path .. 'adapter/codelldb'
  local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'

  local cfg = require('rustaceanvim.config')
  return {
    tools = {

    },
    server = {
      on_attach = function(client, bufnr)
        bufmap(bufnr, "n", "<leader><leader>a", "<esc>lua vim.cmd.RustLsp('codeAction')                 <cr>", opts)
        bufmap(bufnr, "n", "<leader><leader>d", "<esc>lua vim.cmd.RustLsp('documentSymbol')             <cr>", opts)
        bufmap(bufnr, "n", "<leader><leader>f", "<esc>lua vim.cmd.RustLsp('formatting')                 <cr>", opts)
        bufmap(bufnr, "n", "<leader><leader>h", "<esc>lua vim.cmd.RustLsp('hover')                      <cr>", opts)
        bufmap(bufnr, "n", "<leader><leader>m", "<esc>lua vim.cmd.RustLsp('rename')                     <cr>", opts)
        bufmap(bufnr, "n", "<leader><leader>r", "<esc>lua vim.cmd.RustLsp('references')                 <cr>", opts)
        bufmap(bufnr, "n", "<leader><leader>s", "<esc>lua vim.cmd.RustLsp('signatureHelp')              <cr>", opts)
        bufmap(bufnr, "n", "<leader><leader>t", "<esc>lua vim.cmd.RustLsp('textDocument/hover')         <cr>", opts)
        bufmap(bufnr, "n", "<leader><leader>l", "<esc>lua vim.cmd.RustLsp('textDocument/definition')    <cr>", opts)
        bufmap(bufnr, "n", "<leader><leader>o", "<esc>lua vim.cmd.RustLsp('textDocument/documentSymbol')<cr>", opts)
        bufmap(bufnr, "n", "<leader><leader>u", "<esc>lua vim.cmd.RustLsp('textDocument/references')    <cr>", opts)
        bufmap(bufnr, "n", "<leader><leader>z", "<esc>lua vim.cmd.RustLsp('textDocument/signatureHelp') <cr>",opts)
        bufmap(bufnr, "n", "<leader><leader>?", "<esc>lua vim.cmd.RustLsp('workspace/executeCommand')   <cr>", opts)
        bufmap(bufnr, "n", "<leader><leader>;", "<esc>lua vim.cmd.RustLsp('workspace/applyEdit')        <cr>", opts)
        bufmap(bufnr, "n", "<leader><leader>:", "<esc>lua vim.cmd.RustLsp('workspace/symbol')           <cr>", opts)
      end,
      settings = function(project_root)
        local ra = require('rustaceanvim.config.server')
        return ra.load_rust_analyzer_settings(project_root, {
          settings_file_pattern = 'rust-analyzer.json'
        })
      end,
    },
    dap = {
      adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
    },
  }
end


-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
