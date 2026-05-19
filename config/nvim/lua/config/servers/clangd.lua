-- ================================================================================================
-- TITLE : clangd
-- ABOUT : LSP para C/C++ com proteção contra conflito em projetos Arduino/PlatformIO.
-- ================================================================================================

return function(ctx)
  local util = ctx.util

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
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--completion-style=detailed",
      "--header-insertion=iwyu",
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    root_dir = function(arg)
      local fname = type(arg) == "number" and vim.api.nvim_buf_get_name(arg) or arg
      if fname:match("%.ino$") or fname:match("%.pde$") then
        return nil
      end
      if sketch_ancestor(fname) then
        return nil
      end

      local root = util.root_pattern(
        "compile_commands.json",
        "compile_flags.txt",
        ".clangd",
        ".git",
        "CMakeLists.txt",
        "Makefile"
      )(fname)
      if not root then
        return nil
      end
      if vim.uv.fs_stat(root .. "/arduino-cli.yaml")
        or vim.uv.fs_stat(root .. "/sketch.yaml")
        or vim.uv.fs_stat(root .. "/platformio.ini")
        or has_sketch_file(root)
      then
        return nil
      end
      return root
    end,
  }
end
