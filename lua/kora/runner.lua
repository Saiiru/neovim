# ~/.config/nvim/lua/kora/runner.lua
-- Lógica para detectar tipo de projeto e resolver comandos.

local M = {}

-- Detecta o tipo de projeto baseado em arquivos sentinela.
function M.detect_project_type()
  if vim.fn.filereadable("build.gradle.kts") or vim.fn.filereadable("pom.xml") then
    if vim.fn.filereadable("build.gradle.kts") and string.match(vim.fn.readfile("build.gradle.kts")[1], "spring") then
      return "spring"
    end
    return "java"
  elseif vim.fn.filereadable("Cargo.toml") then
    return "rust"
  elseif vim.fn.filereadable("go.mod") then
    return "go"
  elseif vim.fn.filereadable("package.json") then
    return "node"
  elseif vim.fn.filereadable("pyproject.toml") then
    return "python"
  elseif vim.fn.filereadable("arduino-cli.yaml") then
    return "arduino"
  else
    return nil
  end
end

-- Resolve o comando para um modo (run, build, test)
function M.cmd(mode)
  local project_type = M.detect_project_type()
  if not project_type then return nil end

  -- Mapeia o modo para a task do mise
  local task_map = {
    run = "run",
    build = "build",
    test = "test",
  }
  local task = task_map[mode]
  if not task then return nil end

  -- Para Arduino, os nomes das tasks são diferentes
  if project_type == "arduino" then
    task = "arduino." .. task
  end

  -- Retorna o comando mise se a task existir
  -- REVIEW: `mise tasks` não tem uma forma fácil de verificar a existência de uma task via script.
  -- Esta implementação assume que a task existe se o tipo de projeto for detectado.
  return "mise run " .. task
end

-- Executa um comando no terminal externo
function M.external(mode)
  local command = M.cmd(mode)
  if command then
    local runner_script = vim.fn.expand("~/.local/bin/run-in-terminal.sh")
    vim.fn.system(string.format("%s \"%s\"", runner_script, command))
  else
    vim.api.nvim_err_writeln("Nenhum comando '" .. mode .. "' encontrado para este tipo de projeto.")
  end
end

-- Executa uma task do mise via Overseer
function M.run_task(mode)
  local command = M.cmd(mode)
  if command then
    require("overseer").run_template({ name = command })
  else
    vim.api.nvim_err_writeln("Nenhuma task '" .. mode .. "' encontrada para este tipo de projeto.")
  end
end

return M
