-- ================================================================================================
-- TITLE : solidity
-- ABOUT : NomicFoundation Solidity Language Server.
-- ================================================================================================

return function(_ctx)
  return {
    single_file_support = true,
    cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
    filetypes = { "solidity" },
    settings = { rootMarkers = { ".git/" } },
  }
end
