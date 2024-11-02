return {
  {
    "goolord/alpha-nvim",
    lazy = false,
    config = function()
      local present, alpha = pcall(require, "alpha")
      if not present then
        return
      end

      -- Define custom quotes from various sources
      local quotes = {
        "When you have eliminated the impossible, whatever remains, however improbable, must be the truth. – Sherlock Holmes",
        "Time is a funny thing. It's not linear. – Doctor Who",
        "Sometimes, the best way to get things done is to do them yourself. – John Constantine, Hellblazer",
        "You can't just sit back and let it happen. You have to make things happen. – Doctor Who",
        "There is no greater mystery than the human heart. – Sherlock Holmes",
      }

      -- Function to get a random quote
      local function random_quote()
        return quotes[math.random(#quotes)]
      end

      local dashboard = require("alpha.themes.dashboard")
      local icons = require("utils.icons")
      local if_nil = vim.F.if_nil
      local fn = vim.fn

      -- ╭──────────────────────────────────────────────────────────╮
      -- │ Header                                                   │
      -- ╰──────────────────────────────────────────────────────────╯

      dashboard.section.header.val = {
        " ██████╗██╗   ██╗██████╗ ███████╗██████╗ ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
        "██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗████╗  ██║██║   ██║██║████╗ ████║",
        "██║      ╚████╔╝ ██████╔╝█████╗  ██████╔╝██╔██╗ ██║██║   ██║██║██╔████╔██║",
        "██║       ╚██╔╝  ██╔══██╗██╔══╝  ██╔══██╗██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "╚██████╗   ██║   ██████╔╝███████╗██║  ██║██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
        " ╚═════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
      }

      -- ╭──────────────────────────────────────────────────────────╮
      -- │ Buttons                                                  │
      -- ╰──────────────────────────────────────────────────────────╯

      local leader = "SPC"

      --- @param sc string
      --- @param txt string
      --- @param keybind string optional
      --- @param keybind_opts table optional
      local function button(sc, txt, keybind, keybind_opts)
        local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

        local opts = {
          position = "center",
          shortcut = sc,
          cursor = 5,
          width = 50,
          align_shortcut = "right",
          hl_shortcut = "EcovimPrimary",
        }
        if keybind then
          keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
          opts.keymap = { "n", sc_, keybind, keybind_opts }
        end

        local function on_press()
          local key = vim.api.nvim_replace_termcodes(sc_ .. "<Ignore>", true, false, true)
          vim.api.nvim_feedkeys(key, "t", false)
        end

        return {
          type = "button",
          val = txt,
          on_press = on_press,
          opts = opts,
        }
      end

      dashboard.section.buttons.val = {
        button("e", "  > New file", ":lua require('config.utils').create_new_file()<CR>"),
        button("f", "  > Find file in git repo", ":Telescope git_files <CR>"),
        button("r", "  > Recent", ":Telescope oldfiles<CR>"),
        button("l", "🗘  > Open last session", ":SessionManager load_last_session<CR>"),
        button("o", "  > Open session", ":SessionManager load_session<CR>"),
        button("p", "  > Open project", ":Telescope projects<CR>"),
      }

      -- ╭──────────────────────────────────────────────────────────╮
      -- │ Footer                                                   │
      -- ╰──────────────────────────────────────────────────────────╯

      dashboard.section.footer.val = {
        random_quote()
      }
      dashboard.section.footer.opts = {
        position = "center",
        hl = "EcovimFooter",
      }

      local opts = {
        layout = {
          { type = "padding", val = 3 },
          dashboard.section.header,
          { type = "padding", val = 2 },
          dashboard.section.buttons,
          { type = "padding", val = 3 },
          dashboard.section.footer,
        },
        opts = {
          margin = 5
        },
      }

      alpha.setup(opts)

      -- ╭──────────────────────────────────────────────────────────╮
      -- │ Hide tabline and statusline on startup screen            │
      -- ╰──────────────────────────────────────────────────────────╯
      -- vim.api.nvim_create_augroup("alpha_tabline", { clear = true })

  --     vim.api.nvim_create_autocmd("FileType", {
  --       group = "alpha_tabline",
  --       pattern = "alpha",
  --       command = "set showtabline=0 laststatus=0 noruler",
  --     })
  --
  --     vim.api.nvim_create_autocmd("FileType", {
  --       group = "alpha_tabline",
  --       pattern = "alpha",
  --       callback = function()
  --         vim.api.nvim_create_autocmd("BufUnload", {
  --           group = "alpha_tabline",
  --           buffer = 0,
  --           command = "set showtabline=2 ruler laststatus=3",
  --         })
  --       end,
  --     })
     end,
   }
}

