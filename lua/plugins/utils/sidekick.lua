local function safe_require(module)
  local ok, mod = pcall(require, module)
  if not ok then
    vim.notify("Failed to load " .. module .. ": " .. tostring(mod), vim.log.levels.ERROR)
    return nil
  end
  return mod
end

local SIDEKICK_TOKENS = {
  THIS = "{this}",
  FILE = "{file}",
  SELECTION = "{selection}",
}

local PROJECT_ROOT_MARKERS = {
  ".git",
  "package.json",
  "pnpm-lock.yaml",
  "yarn.lock",
  "bun.lock",
  "bun.lockb",
  "pyproject.toml",
  "requirements.txt",
  "manage.py",
  "go.mod",
  "go.work",
  "Cargo.toml",
  "pom.xml",
  "mvnw",
  "build.gradle",
  "build.gradle.kts",
  "gradlew",
  "Makefile",
  "CMakeLists.txt",
  "meson.build",
  "platformio.ini",
  "arduino-cli.yaml",
  "sketch.yaml",
  "composer.json",
  "mix.exs",
  "deno.json",
  "deno.jsonc",
  "gleam.toml",
  "build.zig",
  "docker-compose.yml",
  "compose.yml",
}

local function project_root(buf)
  local name = buf and vim.api.nvim_buf_get_name(buf) or ""
  if name ~= "" then
    return vim.fs.root(name, PROJECT_ROOT_MARKERS) or vim.fn.fnamemodify(name, ":h")
  end
  return vim.fs.root(0, PROJECT_ROOT_MARKERS) or vim.fn.getcwd()
end

local function project_name(root)
  return vim.fn.fnamemodify(root, ":t")
end

local function read_text(path, max_lines)
  local fh = io.open(path, "r")
  if not fh then
    return nil
  end

  local lines = {}
  for line in fh:lines() do
    lines[#lines + 1] = line
    if max_lines and #lines >= max_lines then
      break
    end
  end
  fh:close()

  if #lines == 0 then
    return nil
  end

  return table.concat(lines, "\n")
end

local function first_existing_text(paths, max_lines)
  for _, path in ipairs(paths) do
    local text = read_text(path, max_lines)
    if text and text ~= "" then
      return path, text
    end
  end
end

local function project_context_text(ctx)
  local root = project_root(ctx.buf)
  local name = project_name(root)
  local file = vim.api.nvim_buf_get_name(ctx.buf)
  local lines = {
    ("Project: %s"):format(name),
    ("Root: %s"):format(root),
    "VEGA: shared Hermes-Neovim lattice",
    "Route: context, artifact, and risk before keywords",
  }

  if file ~= "" then
    table.insert(lines, ("Buffer: %s"):format(vim.fs.normalize(file)))
  end

  local ft = vim.bo[ctx.buf].filetype
  if ft ~= "" then
    table.insert(lines, ("Filetype: %s"):format(ft))
  end

  local candidates = {
    root .. "/.nvim-ai-context.md",
    root .. "/.nvim-session-notes.md",
    root .. "/AI_CONTEXT.md",
  }

  local vault = vim.env.OBSIDIAN_VAULT
  if vault and vault ~= "" then
    local base = vault .. "/03 - Projects/" .. name
    vim.list_extend(candidates, {
      base .. "/" .. name .. ".md",
      base .. "/" .. name .. " Tasks.md",
      base .. "/README.md",
    })
  end

  local context_path, context_text = first_existing_text(candidates, 160)
  if context_path then
    table.insert(lines, ("Context: %s"):format(context_path))
    table.insert(lines, "")
    vim.list_extend(lines, vim.split(context_text, "\n", { plain = true }))
  else
    table.insert(lines, "Context: (none)")
  end

  return table.concat(lines, "\n")
end

local COMMIT_PROMPT =
  "Write a conventional commit message for the current staged diff. Keep it concise, accurate, and scoped to the actual change. Add a body only when it adds information the subject cannot carry."

return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>a", group = "ai" },
      },
    },
  },
  {
    "echasnovski/mini.pick",
    lazy = false,
    opts = {},
    config = function(_, opts)
      local MiniPick = require "mini.pick"
      MiniPick.setup(opts)
      vim.ui.select = MiniPick.ui_select
    end,
  },
  {
    "folke/sidekick.nvim",
    opts = {
      context = {
        project = project_context_text,
      },
      nes = {
        enabled = false,
      },
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
        },
        tools = {
          glm = { cmd = { "ccs", "glm" } },
          amp = {
            cmd = { "amp" },
            format = function(text)
              local Text = require "sidekick.text"

              Text.transform(text, function(str)
                return str:find "[^%w/_%.%-]" and ('"' .. str .. '"') or str
              end, "SidekickLocFile")

              local ret = Text.to_string(text)
              ret = ret:gsub("@([^ ]+)%s*:L(%d+):C%d+%-L(%d+):C%d+", "@%1#L%2-%3")
              ret = ret:gsub("@([^ ]+)%s*:L(%d+):C%d+%-C%d+", "@%1#L%2")
              ret = ret:gsub("@([^ ]+)%s*:L(%d+)%-L(%d+)", "@%1#L%2-%3")
              ret = ret:gsub("@([^ ]+)%s*:L(%d+):C%d+", "@%1#L%2")
              ret = ret:gsub("@([^ ]+)%s*:L(%d+)", "@%1#L%2")
              return ret
            end,
          },
        },
        prompts = {
          explain = "{project}\n\nExplain this code precisely. Focus on intent, data flow, invariants, edge cases, and risks. Keep the answer grounded in the current project.\n\n{this}",
          optimize = "{project}\n\nFind the highest-value optimization opportunities in this code. Prefer concrete changes with clear tradeoffs and keep behavior stable.\n\n{this}",
          tests = "{project}\n\nDesign focused tests for this code. Cover the happy path, failure modes, and edge cases that matter for this project.\n\n{this}",
          diagnostics = {
            msg = "{project}\n\nInterpret the diagnostics in this file. Explain the likely root cause, the impact, and the smallest safe fix.\n\n{file}\n\n{diagnostics}",
            diagnostics = true,
          },
          fix = {
            msg = "{project}\n\nFix the concrete issue(s) in this code with the smallest safe patch. Do not rewrite unrelated code.\n\n{this}\n\n{diagnostics}",
            diagnostics = true,
          },
          review = {
            msg = "{project}\n\nReview this code for bugs, regressions, security issues, and missing tests. Return only concrete findings and actionable fixes.\n\n{file}\n\n{diagnostics}",
            diagnostics = true,
          },
          commit = {
            msg = "{project}\n\n" .. COMMIT_PROMPT,
          },
          refactor = "{project}\n\nRefactor this code to improve clarity, maintainability, and safety while preserving behavior. Mention tradeoffs only when they matter.\n\n{this}",
          document = "{project}\n\nAdd documentation comments that match the code's actual behavior and intended usage. Avoid generic prose.\n\n{this}",
          security = {
            msg = "{project}\n\nPerform a security review of this code. Focus on concrete vulnerabilities, trust boundaries, secrets handling, and misuse risks.\n\n{file}\n\n{diagnostics}",
            diagnostics = true,
          },
          understand = "{project}\n\nExplain the purpose and structure of this code, how the parts fit together, and which assumptions are critical.\n\n{this}",
          coverage = "{project}\n\nAssess test coverage for this code. Call out what is missing and which edge cases deserve direct coverage.\n\n{this}",
          debug = "{project}\n\nDebug this issue by identifying the most likely root cause, the smallest safe fix, and any follow-up verification steps.\n\n{diagnostics}\n\n{this}",
          feature = "{project}\n\nPlan the implementation of this feature, then break it into the smallest safe steps. Mention dependencies and risk only when relevant.\n\n{this}",
          dependency = "{project}\n\nReview dependency usage for security, compatibility, and unnecessary coupling. Point out concrete replacements or version risks.\n\n{this}",
          tdd = "{project}\n\nApply a test-driven approach: define the expected behavior first, write the smallest useful tests, then outline the implementation.\n\n{this}",
        },
      },
    },
    keys = {
      {
        "<leader>aa",
        function()
          local cli = safe_require "sidekick.cli"
          if cli then
            cli.toggle()
          end
        end,
        desc = "Toggle AI CLI",
      },
      {
        "<leader>as",
        function()
          local cli = safe_require "sidekick.cli"
          if cli then
            cli.select()
          end
        end,
        desc = "Select AI CLI",
      },
      {
        "<leader>ap",
        function()
          local cli = safe_require "sidekick.cli"
          if cli then
            cli.prompt()
          end
        end,
        mode = { "n", "x" },
        desc = "Prompt AI CLI",
      },
      {
        "<leader>af",
        function()
          local cli = safe_require "sidekick.cli"
          if cli then
            cli.send({ msg = "{project}\n\n{file}" })
          end
        end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function()
          local cli = safe_require "sidekick.cli"
          if cli then
            cli.send({ msg = "{project}\n\n{selection}" })
          end
        end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>at",
        function()
          local cli = safe_require "sidekick.cli"
          if cli then
            cli.send({ msg = "{project}\n\n{this}" })
          end
        end,
        mode = { "x", "n" },
        desc = "Send Current Context",
      },
      {
        "<leader>an",
        function()
          local sidekick = safe_require "sidekick"
          if sidekick then
            sidekick.nes_jump_or_apply()
          end
        end,
        desc = "Next Edit Suggestion",
      },
      {
        "<leader>aN",
        function()
          local nes = safe_require "sidekick.nes"
          if nes then
            nes.toggle()
          end
        end,
        desc = "Toggle NES",
      },
    },
  },
}
