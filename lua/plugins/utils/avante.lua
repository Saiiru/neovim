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


return {
  "yetone/avante.nvim",
  version = false,
  enabled = false, -- Surface consolidada em sidekick.lua; manter desativado por enquanto.
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
        auto_set_keymaps = false,
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
  -- No direct keymaps here. Sidekick owns the AI surface keyspace.

}
