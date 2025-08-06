-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                 KORA COLOR PREVIEW ENGINE - ENHANCED                    ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
  -- ═══════════════════════════════════════════════════════════════════════════
  -- 🎨 TAILWIND COLORIZER FOR CMP
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    opts = {
      color_square_width = 2,
      color_square_highlight = true,
    },
    config = function(_, opts)
      require("tailwindcss-colorizer-cmp").setup(opts)
    end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- 🌈 NVCHAD COLORIZER - MAIN COLOR ENGINE
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    cmd = {
      "ColorizerToggle",
      "ColorizerAttachToBuffer",
      "ColorizerDetachFromBuffer",
      "ColorizerReloadAllBuffers",
    },
    opts = {
      filetypes = {
        "*", -- Enable for all filetypes by default
        -- Specific configurations for certain filetypes
        css = { css = true, css_fn = true, tailwind = true },
        scss = { css = true, css_fn = true, tailwind = true },
        sass = { css = true, css_fn = true, tailwind = true },
        less = { css = true, css_fn = true, tailwind = true },
        html = { css = true, css_fn = true, tailwind = true },
        javascript = { css = true, tailwind = true },
        typescript = { css = true, tailwind = true },
        javascriptreact = { css = true, tailwind = true },
        typescriptreact = { css = true, tailwind = true },
        vue = { css = true, css_fn = true, tailwind = true },
        svelte = { css = true, css_fn = true, tailwind = true },
        astro = { css = true, css_fn = true, tailwind = true },
        lua = { names = false }, -- Disable color names for Lua
      },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = true, -- "Name" codes like Blue or blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = true, -- 0xAARRGGBB hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes for `mode`: foreground, background, virtualtext
        mode = "background", -- Set the display mode
        -- Available methods are false / true / "normal" / "lsp" / "both"
        tailwind = true, -- Enable tailwind colors
        -- parsers can contain values used in |user_default_options|
        sass = { enable = true, parsers = { "css" } }, -- Enable sass colors
        virtualtext = "■",
        -- update color values even if buffer is not focused
        always_update = false,
      },
      -- all the sub-options of filetypes apply to buftypes
      buftypes = {
        "*",
        -- exclude prompt and popup buffers
        "!prompt",
        "!popup",
      },
    },
    config = function(_, opts)
      require("colorizer").setup(opts)

      -- ═══════════════════════════════════════════════════════════════════════════
      -- 🔧 ENHANCED AUTO-ATTACH LOGIC
      -- ═══════════════════════════════════════════════════════════════════════════
      local colorizer_group = vim.api.nvim_create_augroup("kora_colorizer", { clear = true })

      -- Supported file patterns for auto-attach
      local supported_patterns = {
        "*.css",
        "*.scss",
        "*.sass",
        "*.less",
        "*.html",
        "*.htm",
        "*.xml",
        "*.js",
        "*.ts",
        "*.jsx",
        "*.tsx",
        "*.vue",
        "*.svelte",
        "*.astro",
        "*.conf",
        "*.config",
        "*.json",
        "*.lua",
        "*.vim",
      }

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        group = colorizer_group,
        pattern = supported_patterns,
        callback = function(args)
          -- Skip if buffer is too large (performance)
          local bufname = vim.api.nvim_buf_get_name(args.buf)
          local ok, stats = pcall(vim.loop.fs_stat, bufname)
          if ok and stats and stats.size > 500 * 1024 then -- 500KB limit
            return
          end

          -- Skip certain directories
          local skip_dirs = { "node_modules", ".git", "vendor", "build", "dist", "__pycache__" }
          for _, dir in ipairs(skip_dirs) do
            if bufname:match(dir) then
              return
            end
          end

          -- Delay attachment to ensure buffer is ready
          vim.defer_fn(function()
            if vim.api.nvim_buf_is_valid(args.buf) then
              require("colorizer").attach_to_buffer(args.buf)
            end
          end, 100)
        end,
      })

      -- Smart refresh on content changes (debounced)
      local refresh_timer = nil
      vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        group = colorizer_group,
        pattern = supported_patterns,
        callback = function(args)
          -- Cancel previous timer
          if refresh_timer then
            vim.fn.timer_stop(refresh_timer)
          end

          -- Debounced refresh
          refresh_timer = vim.fn.timer_start(300, function()
            if vim.api.nvim_buf_is_valid(args.buf) then
              require("colorizer").attach_to_buffer(args.buf)
            end
            refresh_timer = nil
          end)
        end,
      })

      -- Cleanup on buffer delete
      vim.api.nvim_create_autocmd("BufDelete", {
        group = colorizer_group,
        callback = function(args)
          if refresh_timer then
            vim.fn.timer_stop(refresh_timer)
            refresh_timer = nil
          end
          require("colorizer").detach_from_buffer(args.buf)
        end,
      })

      -- ═══════════════════════════════════════════════════════════════════════════
      -- 🎮 ENHANCED COMMANDS
      -- ═══════════════════════════════════════════════════════════════════════════
      vim.api.nvim_create_user_command("ColorizerStatus", function()
        local buf = vim.api.nvim_get_current_buf()
        local bufname = vim.fn.bufname(buf)
        local ft = vim.bo.filetype

        -- Check if colorizer is loaded
        local colorizer_loaded, colorizer = pcall(require, "colorizer")
        if not colorizer_loaded then
          print("❌ Colorizer not loaded")
          return
        end

        -- Check attachment status
        local attached = colorizer.is_buffer_attached and colorizer.is_buffer_attached(buf) or false

        -- Analyze current line for colors
        local line = vim.api.nvim_get_current_line()
        local colors_detected = {}

        local color_patterns = {
          { pattern = "#%x%x%x%x%x%x%x%x", name = "RRGGBBAA" },
          { pattern = "#%x%x%x%x%x%x", name = "RRGGBB" },
          { pattern = "#%x%x%x", name = "RGB" },
          { pattern = "rgb%([^)]+%)", name = "rgb()" },
          { pattern = "rgba%([^)]+%)", name = "rgba()" },
          { pattern = "hsl%([^)]+%)", name = "hsl()" },
          { pattern = "hsla%([^)]+%)", name = "hsla()" },
        }

        for _, color_info in ipairs(color_patterns) do
          for match in line:gmatch(color_info.pattern) do
            table.insert(colors_detected, string.format("%s (%s)", match, color_info.name))
          end
        end

        -- Build status report
        local status_lines = {
          "🎨 Colorizer Status Report:",
          "",
          "📄 Buffer: " .. (bufname ~= "" and bufname or "[No Name]"),
          "📝 Filetype: " .. ft,
          "🔢 Buffer ID: " .. buf,
          "📦 Loaded: " .. (colorizer_loaded and "✅ Yes" or "❌ No"),
          "🔗 Attached: " .. (attached and "✅ Yes" or "❌ No"),
          "",
        }

        if #colors_detected > 0 then
          table.insert(status_lines, "🎨 Colors in current line:")
          for _, color in ipairs(colors_detected) do
            table.insert(status_lines, "  • " .. color)
          end
        else
          table.insert(status_lines, "🎨 No colors detected in current line")
        end

        if not attached then
          table.insert(status_lines, "")
          table.insert(status_lines, "💡 Try: :ColorizerAttachToBuffer")
        end

        print(table.concat(status_lines, "\n"))
      end, { desc = "Show colorizer status and detected colors" })

      vim.api.nvim_create_user_command("ColorizerReload", function()
        require("colorizer").reload_all_buffers()
        print("🔄 Colorizer reloaded for all buffers")
      end, { desc = "Reload colorizer for all buffers" })

      vim.api.nvim_create_user_command("ColorizerAttach", function()
        local buf = vim.api.nvim_get_current_buf()
        require("colorizer").attach_to_buffer(buf)
        print("🎨 Colorizer attached to current buffer")
      end, { desc = "Force attach colorizer to current buffer" })

      vim.api.nvim_create_user_command("ColorizerDetach", function()
        local buf = vim.api.nvim_get_current_buf()
        require("colorizer").detach_from_buffer(buf)
        print("🚫 Colorizer detached from current buffer")
      end, { desc = "Detach colorizer from current buffer" })

      -- ═══════════════════════════════════════════════════════════════════════════
      -- 🗝️ ENHANCED KEYMAPS
      -- ═══════════════════════════════════════════════════════════════════════════
      vim.keymap.set(
        "n",
        "<leader>tc",
        "<cmd>ColorizerToggle<cr>",
        { desc = "🎨 Toggle colorizer" }
      )
      vim.keymap.set(
        "n",
        "<leader>tC",
        "<cmd>ColorizerStatus<cr>",
        { desc = "📊 Colorizer status" }
      )
      vim.keymap.set(
        "n",
        "<leader>tr",
        "<cmd>ColorizerReload<cr>",
        { desc = "🔄 Reload colorizer" }
      )
      vim.keymap.set(
        "n",
        "<leader>ta",
        "<cmd>ColorizerAttach<cr>",
        { desc = "🔗 Attach colorizer" }
      )
      vim.keymap.set(
        "n",
        "<leader>td",
        "<cmd>ColorizerDetach<cr>",
        { desc = "🚫 Detach colorizer" }
      )

      -- ═══════════════════════════════════════════════════════════════════════════
      -- 🚀 PROJECT-SPECIFIC AUTO-CONFIGURATION
      -- ═══════════════════════════════════════════════════════════════════════════
      vim.defer_fn(function()
        local cwd = vim.fn.getcwd()

        -- Detect project type and adjust settings
        local project_configs = {
          -- Tailwind projects
          {
            files = { "tailwind.config.js", "tailwind.config.ts", "tailwind.config.cjs" },
            setup = function()
              -- Enhanced Tailwind support
              require("colorizer").setup({
                user_default_options = {
                  tailwind = "both", -- Enable both normal and extended mode
                  css = true,
                  css_fn = true,
                },
              })
            end,
          },
          -- CSS/SCSS projects
          {
            files = { "package.json" },
            check = function()
              local package_file = cwd .. "/package.json"
              if vim.fn.filereadable(package_file) == 1 then
                local content = vim.fn.readfile(package_file)
                local package_str = table.concat(content, "\n")
                return package_str:match("sass")
                  or package_str:match("scss")
                  or package_str:match("postcss")
              end
              return false
            end,
            setup = function()
              -- Enhanced CSS preprocessing support
              require("colorizer").setup({
                user_default_options = {
                  css = true,
                  css_fn = true,
                  sass = { enable = true, parsers = { "css" } },
                },
              })
            end,
          },
        }

        for _, config in ipairs(project_configs) do
          local detected = false

          if config.check then
            detected = config.check()
          else
            for _, file in ipairs(config.files or {}) do
              if vim.fn.filereadable(cwd .. "/" .. file) == 1 then
                detected = true
                break
              end
            end
          end

          if detected and config.setup then
            config.setup()
            break
          end
        end
      end, 1000)
    end,
  },
}
