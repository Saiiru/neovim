-- ================================================================================================
-- TITLE : arduino_language_server
-- ABOUT : LSP para Arduino/ESP32 (ino/c/cpp) com seleção de FQBN por variável de ambiente.
-- ================================================================================================

return function(ctx)
  local arduino = require "config.arduino"
  local cmd = arduino.lsp_cmd()
  if not cmd then
    return nil
  end

  return {
    cmd = cmd,
    filetypes = { "arduino", "c", "cpp" },
    root_dir = function(arg)
      local fname = type(arg) == "number" and vim.api.nvim_buf_get_name(arg) or arg
      return arduino.root_dir(fname)
    end,
    single_file_support = true,
  }
end
