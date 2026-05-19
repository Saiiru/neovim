local avante_prompts = require("config.prompts").avante
local utils = require "config.utils"

local function ensure_avante_signs()
  -- Workaround para evitar: E155 Unknown sign: AvanteInputPromptSign
  -- em alguns boots/ordens de carregamento de tema + plugin.
  vim.fn.sign_define("AvanteInputPromptSign", {
    text = "",
    texthl = "Special",
    linehl = "",
    numhl = "",
  })
end

local function ensure_avante_native_modules()
  local avante_root = vim.fn.stdpath "data" .. "/lazy/avante.nvim"
  local build_cpath = avante_root .. "/build/?.so"
  if not package.cpath:find(vim.pesc(build_cpath), 1, true) then
    package.cpath = package.cpath .. ";" .. build_cpath
  end
end

local function avante_native_ok()
  ensure_avante_native_modules()
  local ok = pcall(require, "avante_templates")
  return ok
end

local function guard_avante_native()
  if avante_native_ok() then
    return true
  end
  vim.notify(
    "Avante: módulo nativo ausente (avante_templates). Rode :Lazy build avante.nvim e reinicie o Neovim.",
    vim.log.levels.ERROR,
    { title = "Avante" }
  )
  return false
end

local function create_avante_call(prompt, use_context)
  if use_context then
    return function()
      ensure_avante_native_modules()
      ensure_avante_signs()
      if not guard_avante_native() then
        return
      end
      local filetype = vim.bo.filetype ~= "" and vim.bo.filetype or "unknown"
      local filename = vim.fn.expand "%:t"
      filename = filename ~= "" and filename or "unnamed buffer"
      local context = string.format("This is %s code from file '%s'. ", filetype, filename)
      require("avante.api").ask { question = context .. prompt }
    end
  end

  return function()
    ensure_avante_native_modules()
    ensure_avante_signs()
    if not guard_avante_native() then
      return
    end
    require("avante.api").ask { question = prompt }
  end
end

return {
  "yetone/avante.nvim",
  version = false,
  enabled = utils.is_online(),
  build = "make",
  init = function()
    ensure_avante_native_modules()
    ensure_avante_signs()
    vim.api.nvim_create_user_command("AvanteDoctor", function()
      ensure_avante_native_modules()
      ensure_avante_signs()
      local ok = pcall(require, "avante_templates")
      if ok then
        vim.notify("Avante OK: signs + avante_templates carregados.", vim.log.levels.INFO, { title = "Avante" })
      else
        vim.notify(
          "Avante NOK: avante_templates não carregou. Rode :Lazy build avante.nvim",
          vim.log.levels.ERROR,
          { title = "Avante" }
        )
      end
    end, {})
  end,
  opts = function()
    local opts = {
      provider = "copilot",
      rag_service = { enabled = false },
      cursor_applying_provider = "copilot",
      providers = {
        copilot = {
          endpoint = "https://api.githubcopilot.com",
          model = "claude-sonnet-4.5",
          timeout = 60000,
          extra_request_body = {
            temperature = 0,
            max_tokens = 128000,
          },
          disable_tools = true,
          telemetry = false,
        },
      },
      suggestion = {
        debounce = 900,
        throttle = 600,
      },
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        minimize_diff = true,
        enable_token_counting = true,
        enable_cursor_planning_mode = true,
      },
      mappings = {
        diff = {
          ours = "co",
          theirs = "ct",
          all_theirs = "ca",
          both = "cb",
          cursor = "cc",
          next = "]x",
          prev = "[x",
        },
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        sidebar = {
          apply_all = "A",
          apply_cursor = "a",
          switch_windows = "<Tab>",
          reverse_switch_windows = "<S-Tab>",
        },
      },
    }

    if utils.is_mcp_present() then
      opts.system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        return hub:get_active_servers_prompt()
      end
      opts.custom_tools = function()
        return {
          require("mcphub.extensions.avante").mcp_tool(),
        }
      end
    end

    return opts
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "zbirenbaum/copilot.lua",
  },
  keys = {
    {
      "<leader>aa",
      function()
        ensure_avante_native_modules()
        ensure_avante_signs()
        if not guard_avante_native() then
          return
        end
        require("avante.api").ask()
      end,
      desc = "Ask",
      mode = { "n", "v" },
    },
    {
      "<leader>ae",
      function()
        ensure_avante_native_modules()
        ensure_avante_signs()
        if not guard_avante_native() then
          return
        end
        require("avante.api").edit()
      end,
      desc = "Edit",
      mode = { "n", "v" },
    },
    { "<leader>af", "<cmd>AvanteClear<cr>", desc = "Clear", mode = { "n", "v" } },
    {
      "<leader>a?",
      function() require("avante.api").select_model() end,
      desc = "Select model",
    },
    { "<leader>ar", create_avante_call(avante_prompts.refactor), desc = "Refactor Code", mode = { "n", "v" } },
    { "<leader>av", create_avante_call(avante_prompts.code_review), desc = "Code Review", mode = { "n", "v" } },
    {
      "<leader>aA",
      create_avante_call(avante_prompts.architecture_suggestion),
      desc = "Architecture Suggestions",
      mode = { "n", "v" },
    },
    {
      "<leader>al",
      create_avante_call(avante_prompts.readability_analysis),
      desc = "Code Readability Analysis",
      mode = { "n", "v" },
    },
    { "<leader>ao", create_avante_call(avante_prompts.optimize_code), desc = "Optimize Code", mode = { "n", "v" } },
    { "<leader>ax", create_avante_call(avante_prompts.explain_code, true), desc = "Explain Code", mode = { "n", "v" } },
    { "<leader>ab", create_avante_call(avante_prompts.fix_bugs, true), desc = "Fix Bugs", mode = { "n", "v" } },
    { "<leader>au", create_avante_call(avante_prompts.add_tests), desc = "Add Tests", mode = { "n", "v" } },
    { "<leader>az", create_avante_call(avante_prompts.security_review), desc = "Security Analysis", mode = { "n", "v" } },
    { "<leader>am", create_avante_call(avante_prompts.summarize), desc = "Summarize text", mode = { "n", "v" } },
  },
}
