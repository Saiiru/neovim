local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

-- se existir algum map antigo em <leader>x, remove
pcall(vim.keymap.del, "n", "<leader>x")

local function exists(p)
  local uv = vim.uv or vim.loop
  return uv.fs_stat(p) ~= nil
end

local function detect_build_cmds()
  local cmds = {}
  if exists "gradlew" then
    table.insert(cmds, "./gradlew build")
  end
  if exists "mvnw" then
    table.insert(cmds, "./mvnw -q -DskipTests package")
  end
  if exists "pom.xml" and not exists "mvnw" then
    table.insert(cmds, "mvn -q -DskipTests package")
  end

  if exists "package.json" then
    if exists "pnpm-lock.yaml" then
      vim.list_extend(cmds, { "pnpm build", "pnpm dev", "pnpm test" })
    elseif exists "yarn.lock" then
      vim.list_extend(cmds, { "yarn build", "yarn dev", "yarn test" })
    else
      vim.list_extend(cmds, { "npm run build", "npm run dev", "npm test" })
    end
  end

  if exists "go.mod" then
    vim.list_extend(cmds, { "go build ./...", "go test ./..." })
  end
  if exists "Cargo.toml" then
    vim.list_extend(cmds, { "cargo build", "cargo test", "cargo run" })
  end
  if #cmds == 0 then
    table.insert(cmds, "echo 'Nenhum template detectado'")
  end
  return cmds
end

local function run_cmd_in_overseer(cmd)
  local ok = pcall(require, "overseer")
  if not ok then
    return vim.notify("overseer.nvim não instalado", vim.log.levels.ERROR)
  end
  vim.cmd("OverseerRunCmd " .. vim.fn.shellescape(cmd))
end

-- chmod
map("n", "<leader>r+", function()
  vim.cmd "silent! write | !chmod +x %"
  vim.notify("chmod +x " .. vim.fn.expand "%:t")
end, "chmod +x arquivo atual")

map("n", "<leader>r-", function()
  vim.cmd "silent! write | !chmod -x %"
  vim.notify("chmod -x " .. vim.fn.expand "%:t")
end, "chmod -x arquivo atual")

-- run arquivo (shebang / intérprete)
map("n", "<leader>rr", function()
  vim.cmd "silent! write"
  local first = (vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or "")
  local file = vim.fn.expand "%:p"
  if first:match "^#!" then
    run_cmd_in_overseer(file)
  else
    local choices = { "bash", "sh", "python3", "node", "deno run", "ruby" }
    vim.ui.select(choices, { prompt = "Executar com:" }, function(choice)
      if choice then
        run_cmd_in_overseer(choice .. " " .. vim.fn.shellescape(file))
      end
    end)
  end
end, "Run arquivo atual")

-- build/run autodetect
map("n", "<leader>rb", function()
  local cmds = detect_build_cmds()
  vim.ui.select(cmds, { prompt = "Build/Run detected:" }, function(choice)
    if choice then
      run_cmd_in_overseer(choice)
    end
  end)
end, "Build/Run (auto)")

-- atalhos Overseer/Compiler
map("n", "<leader>ro", "<cmd>OverseerToggle<cr>", "Overseer Toggle")
map("n", "<leader>rO", "<cmd>OverseerOpen<cr>", "Overseer Open")
map("n", "<leader>rq", "<cmd>OverseerQuickAction<cr>", "Overseer Quick Action")
map("n", "<leader>rc", "<cmd>CompilerOpen<cr>", "Compiler Open")
map("n", "<leader>rR", function()
  vim.cmd "CompilerStop | CompilerRedo"
end, "Compiler Redo")
map("n", "<leader>rt", "<cmd>CompilerToggleResults<cr>", "Compiler Results")
