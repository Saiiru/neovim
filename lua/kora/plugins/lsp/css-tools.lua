-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║             KORA CSS/SCSS/TAILWIND SUITE - ENHANCED                    ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local M = {}

-- ═══════════════════════════════════════════════════════════════════════════
-- 🐛 CSS DEBUG & DIAGNOSTICS MODULE
-- ═══════════════════════════════════════════════════════════════════════════
function M.debug_colorizer()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo.filetype

  local msg = "🎨 Colorizer Debug Report:\n\n"
  msg = msg
    .. "📄 Buffer: "
    .. (vim.fn.bufname(buf) ~= "" and vim.fn.bufname(buf) or "[No Name]")
    .. "\n"
  msg = msg .. "📝 Filetype: " .. ft .. "\n"
  msg = msg .. "🔢 Buffer ID: " .. buf .. "\n"

  -- Check if colorizer is loaded
  local colorizer_loaded, colorizer = pcall(require, "colorizer")
  msg = msg .. "📦 Colorizer loaded: " .. (colorizer_loaded and "✅ Yes" or "❌ No") .. "\n"

  if colorizer_loaded then
    -- Check if attached
    local attached = colorizer.is_buffer_attached and colorizer.is_buffer_attached(buf) or false
    msg = msg .. "🔗 Buffer attached: " .. (attached and "✅ Yes" or "❌ No") .. "\n"

    -- Test color detection on current line
    local line = vim.api.nvim_get_current_line()
    local colors_found = {}

    local patterns = {
      "#%x%x%x%x%x%x",
      "#%x%x%x", -- Hex colors
      "rgb%([^)]+%)",
      "rgba%([^)]+%)", -- RGB/RGBA
      "hsl%([^)]+%)",
      "hsla%([^)]+%)", -- HSL/HSLA
    }

    for _, pattern in ipairs(patterns) do
      for match in line:gmatch(pattern) do
        table.insert(colors_found, match)
      end
    end

    if #colors_found > 0 then
      msg = msg .. "🎨 Colors in line: " .. table.concat(colors_found, ", ") .. "\n"
    else
      msg = msg .. "🎨 No colors detected in current line\n"
    end

    if not attached then
      msg = msg .. "\n💡 Try: :ColorizerAttachToBuffer or restart Neovim"
    end
  end

  print(msg) -- Use print instead of notify to avoid spam
end

function M.check_css_tools()
  local tools_status = {}
  local configs_status = {}

  -- Check executables
  local tools = {
    { name = "stylelint", cmd = "stylelint" },
    { name = "prettier", cmd = "prettier" },
    { name = "prettierd", cmd = "prettierd" },
    { name = "tailwindcss", cmd = "tailwindcss" },
  }

  for _, tool in ipairs(tools) do
    tools_status[tool.name] = vim.fn.executable(tool.cmd) == 1
  end

  -- Check config files
  local cwd = vim.fn.getcwd()
  local configs = {
    { name = "Stylelint", files = { ".stylelintrc.json", ".stylelintrc.js", ".stylelintrc.yaml" } },
    { name = "Prettier", files = { ".prettierrc.json", ".prettierrc.js", ".prettierrc.yaml" } },
    {
      name = "Tailwind",
      files = { "tailwind.config.js", "tailwind.config.ts", "tailwind.config.cjs" },
    },
    { name = "PostCSS", files = { "postcss.config.js", "postcss.config.cjs" } },
  }

  for _, config in ipairs(configs) do
    local found = false
    for _, file in ipairs(config.files) do
      if vim.fn.filereadable(cwd .. "/" .. file) == 1 then
        found = true
        break
      end
    end
    configs_status[config.name] = found
  end

  -- Build and display report
  local msg = "🛠️ CSS Tools Status:\n\n📦 Tools:\n"
  for name, status in pairs(tools_status) do
    msg = msg .. (status and "✅" or "❌") .. " " .. name .. "\n"
  end

  msg = msg .. "\n⚙️ Configs:\n"
  for name, status in pairs(configs_status) do
    msg = msg .. (status and "✅" or "❌") .. " " .. name .. "\n"
  end

  -- Colorizer status
  local colorizer_loaded = pcall(require, "colorizer")
  msg = msg .. "\n🎨 Visual:\n" .. (colorizer_loaded and "✅" or "❌") .. " Colorizer\n"

  print(msg)
end

return {
  -- ═══════════════════════════════════════════════════════════════════════════
  -- 🔧 TAILWIND CSS TOOLS
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    "luckasRanarison/tailwind-tools.nvim",
    ft = {
      "html",
      "css",
      "scss",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "vue",
      "svelte",
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      document_color = {
        enabled = true,
        kind = "inline",
        inline_symbol = "󰝤 ",
        debounce = 200,
      },
      conceal = {
        enabled = false,
        symbol = "󱏿",
        highlight = { fg = "#38BDF8" },
      },
      custom_filetypes = {
        "html",
        "css",
        "scss",
        "sass",
        "less",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "vue",
        "svelte",
        "astro",
        "php",
      },
    },
    config = function(_, opts)
      require("tailwind-tools").setup(opts)

      -- ═══════════════════════════════════════════════════════════════════════════
      -- 🎮 TAILWIND KEYMAPS
      -- ═══════════════════════════════════════════════════════════════════════════
      vim.keymap.set(
        "n",
        "<leader>ts",
        "<cmd>TailwindSort<cr>",
        { desc = "🎯 Sort Tailwind classes" }
      )
      vim.keymap.set(
        "n",
        "<leader>tt",
        "<cmd>TailwindConcealToggle<cr>",
        { desc = "👁️ Toggle conceal" }
      )
      vim.keymap.set(
        "n",
        "<leader>tn",
        "<cmd>TailwindNextClass<cr>",
        { desc = "➡️ Next class" }
      )
      vim.keymap.set(
        "n",
        "<leader>tp",
        "<cmd>TailwindPrevClass<cr>",
        { desc = "⬅️ Prev class" }
      )

      -- Auto-detect Tailwind projects
      local function detect_tailwind()
        local cwd = vim.fn.getcwd()
        local tailwind_files = {
          "tailwind.config.js",
          "tailwind.config.ts",
          "tailwind.config.cjs",
          "tailwind.config.mjs",
          "postcss.config.js",
          "postcss.config.cjs",
        }

        for _, file in ipairs(tailwind_files) do
          if vim.fn.filereadable(cwd .. "/" .. file) == 1 then
            vim.g.tailwind_project = true
            return
          end
        end
        vim.g.tailwind_project = false
      end

      vim.defer_fn(detect_tailwind, 1000)
    end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- 🎭 EMMET FOR FAST HTML/CSS
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    "mattn/emmet-vim",
    ft = {
      "html",
      "css",
      "scss",
      "sass",
      "less",
      "javascriptreact",
      "typescriptreact",
      "vue",
      "svelte",
    },
    config = function()
      vim.g.user_emmet_install_global = 0
      vim.g.user_emmet_leader_key = "<C-z>"
      vim.g.user_emmet_mode = "inv"

      vim.g.user_emmet_settings = {
        variables = { lang = "pt-br" },
        html = {
          default_attributes = {
            option = { value = nil },
            textarea = { id = nil, name = nil, cols = 10, rows = 10 },
          },
          snippets = {
            ["html:5"] = '<!DOCTYPE html>\n<html lang="pt-br">\n<head>\n\t<meta charset="UTF-8">\n\t<meta name="viewport" content="width=device-width, initial-scale=1.0">\n\t<title>${1:Título}</title>\n</head>\n<body>\n\t${child}|\n</body>\n</html>',
            ["!!"] = "<!DOCTYPE html>",
          },
        },
        css = {
          filters = "fc",
          snippets = {
            ["@media"] = "@media ${1:screen} {\n\t${2}\n}",
            ["@keyframes"] = "@keyframes ${1:name} {\n\t0% { ${2} }\n\t100% { ${3} }\n}",
            ["flex"] = "display: flex;\nalign-items: center;\njustify-content: center;",
            ["grid"] = "display: grid;\nplace-items: center;",
          },
        },
      }

      -- Auto-enable Emmet
      vim.api.nvim_create_augroup("kora_emmet", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = "kora_emmet",
        pattern = {
          "html",
          "css",
          "scss",
          "sass",
          "less",
          "javascriptreact",
          "typescriptreact",
          "vue",
          "svelte",
        },
        callback = function()
          vim.cmd("EmmetInstall")
        end,
      })

      -- Enhanced keymaps
      vim.keymap.set(
        { "i", "n" },
        "<C-z>,",
        "<plug>(emmet-expand-abbr)",
        { desc = "🎭 Expand Emmet" }
      )
      vim.keymap.set(
        { "i", "n" },
        "<C-z>;",
        "<plug>(emmet-expand-word)",
        { desc = "🎭 Expand word" }
      )
      vim.keymap.set("n", "<C-z>u", "<plug>(emmet-update-tag)", { desc = "🎭 Update tag" })
      vim.keymap.set(
        "n",
        "<C-z>d",
        "<plug>(emmet-balance-tag-inward)",
        { desc = "🎭 Balance inward" }
      )
      vim.keymap.set(
        "n",
        "<C-z>D",
        "<plug>(emmet-balance-tag-outward)",
        { desc = "🎭 Balance outward" }
      )
    end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- 📋 CSS PEEK & NAVIGATION
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    "rmagatti/goto-preview",
    event = "BufEnter",
    config = function()
      require("goto-preview").setup({
        width = 120,
        height = 25,
        default_mappings = false,
        focus_on_open = true,
        dismiss_on_move = false,
        force_close = true,
        bufhidden = "wipe",
        stack_floating_preview_windows = true,
        preview_window_title = { enable = true, position = "left" },
        references = {
          telescope = require("telescope.themes").get_dropdown({ hide_preview = false }),
        },
      })

      vim.keymap.set(
        "n",
        "gpd",
        "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
        { desc = "👁️ Preview definition" }
      )
      vim.keymap.set(
        "n",
        "gpr",
        "<cmd>lua require('goto-preview').goto_preview_references()<CR>",
        { desc = "👁️ Preview references" }
      )
      vim.keymap.set(
        "n",
        "gP",
        "<cmd>lua require('goto-preview').close_all_win()<CR>",
        { desc = "❌ Close preview" }
      )
    end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- 🎨 CSS WORKFLOW COMMANDS & DEBUG INTEGRATION
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    dir = vim.fn.stdpath("config"),
    name = "kora-css-debug",
    config = function()
      -- CSS workflow commands
      vim.api.nvim_create_user_command("CSSWorkflow", function()
        vim.opt_local.wrap = false
        vim.opt_local.number = true
        vim.opt_local.relativenumber = true
        vim.opt_local.foldmethod = "indent"
        vim.opt_local.foldlevel = 99

        -- Try to attach colorizer if available
        local ok = pcall(function()
          vim.cmd("ColorizerAttachToBuffer")
        end)
        if not ok then
          vim.cmd("ColorizerToggle")
        end
      end, { desc = "Activate CSS development workflow" })

      vim.api.nvim_create_user_command("TailwindWorkflow", function()
        vim.cmd("CSSWorkflow")
        if vim.g.tailwind_project then
          pcall(function()
            vim.cmd("TailwindSort")
          end)
        end
      end, { desc = "Activate Tailwind development workflow" })

      -- Debug commands integration
      vim.api.nvim_create_user_command(
        "ColorizerDebug",
        M.debug_colorizer,
        { desc = "Debug colorizer issues" }
      )
      vim.api.nvim_create_user_command(
        "CSSToolsStatus",
        M.check_css_tools,
        { desc = "Check CSS tools status" }
      )

      -- Auto-detect and setup CSS workflow
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "css", "scss", "sass", "less" },
        callback = function()
          vim.defer_fn(function()
            vim.cmd("CSSWorkflow")
          end, 500)
        end,
      })

      -- ═══════════════════════════════════════════════════════════════════════════
      -- 🗝️ ENHANCED KEYMAPS
      -- ═══════════════════════════════════════════════════════════════════════════
      vim.keymap.set("n", "<leader>cw", "<cmd>CSSWorkflow<cr>", { desc = "🎨 CSS Workflow" })
      vim.keymap.set(
        "n",
        "<leader>tw",
        "<cmd>TailwindWorkflow<cr>",
        { desc = "🎯 Tailwind Workflow" }
      )
      vim.keymap.set("n", "<leader>cd", M.debug_colorizer, { desc = "🐛 Debug colorizer" })
      vim.keymap.set("n", "<leader>cs", M.check_css_tools, { desc = "🔧 Check CSS tools" })
    end,
  },
}
