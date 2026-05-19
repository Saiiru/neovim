-- ================================================================================================
-- TITLE : arduino_language_server
-- ABOUT : LSP para Arduino/ESP32 (ino/c/cpp) com seleção de FQBN por variável de ambiente.
-- ================================================================================================

return function(ctx)
  local util = ctx.util
  local arduino = require "config.arduino"
  local cmd = arduino.lsp_cmd()
  if not cmd then
    return nil
  end

  local function has_sketch_file(dir)
    return #vim.fn.globpath(dir, "*.ino", false, true) > 0 or #vim.fn.globpath(dir, "*.pde", false, true) > 0
  end

  local function sketch_ancestor(fname)
    local dir = vim.fn.fnamemodify(fname, ":p:h")

    while dir and dir ~= "" do
      if has_sketch_file(dir) then
        return dir
      end

      local parent = vim.fn.fnamemodify(dir, ":h")
      if parent == dir then
        break
      end
      dir = parent
    end
  end

  return {
    cmd = cmd,
    filetypes = { "arduino", "c", "cpp" },
    root_dir = function(arg)
      local fname = type(arg) == "number" and vim.api.nvim_buf_get_name(arg) or arg
      if fname:match("%.ino$") or fname:match("%.pde$") then
        return vim.fn.fnamemodify(fname, ":p:h")
      end

      local root = util.root_pattern("arduino-cli.yaml", "sketch.yaml", "platformio.ini")(fname)
      if root then
        return root
      end

      local sketch_root = sketch_ancestor(fname)
      if sketch_root then
        return sketch_root
      end

      local git_root = util.find_git_ancestor(fname)
      if git_root and has_sketch_file(git_root) then
        return git_root
      end

      return nil
    end,
    single_file_support = true,
  }
end
