-- ================================================================================================
-- TITLE : qmlls
-- ABOUT : Qt/QML language server com fallback de binário para distribuições Arch/Qt6.
-- ================================================================================================

return function(_ctx)
  local qmlls_cmd = vim.fn.exepath "qmlls6"
  if qmlls_cmd == "" then
    local fallback = "/usr/lib/qt6/bin/qmlls"
    if vim.uv.fs_stat(fallback) then
      qmlls_cmd = fallback
    end
  end

  if qmlls_cmd == "" then
    return nil
  end

  local function publish_only_errors(err, result, ctx, config)
    if result and result.diagnostics then
      local diagnostics = {}
      for _, d in ipairs(result.diagnostics) do
        if d.severity == vim.diagnostic.severity.ERROR then
          table.insert(diagnostics, d)
        end
      end
      result = vim.deepcopy(result)
      result.diagnostics = diagnostics
    end
    return vim.lsp.handlers["textDocument/publishDiagnostics"](err, result, ctx, config)
  end

  return {
    cmd = { qmlls_cmd },
    filetypes = { "qml", "qmljs" },
    root_dir = function(bufnr, on_dir)
      local root = vim.fs.root(bufnr, { "qmldir", "shell.qml", ".git", "CMakeLists.txt", "flake.nix" })
        or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
      on_dir(root)
    end,
    handlers = {
      ["textDocument/publishDiagnostics"] = publish_only_errors,
    },
    settings = {
      qml = {
        format = {
          enable = true,
        },
      },
    },
  }
end
