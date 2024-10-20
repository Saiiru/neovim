return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = "MunifTanjim/nui.nvim",
  cmd = "Neotree",
  opts = function()
    vim.g.neo_tree_remove_legacy_commands = true
    local icons = require("core.icons.icons")

    return {
      auto_clean_after_session_restore = true,
      close_if_last_window = true,
      buffers = {
        show_unloaded = true,
      },
      sources = { "filesystem", "buffers", "git_status", "diagnostics" },
      source_selector = {
        winbar = true,
        content_layout = "center",
        sources = {
          { source = "filesystem", display_name = icons.file },
          { source = "buffers", display_name = icons.buf },
          { source = "git_status", display_name = icons.git },
          { source = "diagnostics", display_name = icons.diagnostic },
        },
      },
      default_component_configs = {
        indent = { padding = 2 },
        icon = {
          folder_closed = icons.folder_closed,  -- Ícone de pasta fechada
          folder_open = icons.folder_open,      -- Ícone de pasta aberta
          folder_empty = icons.folder_empty,    -- Ícone de pasta vazia
          folder_empty_open = icons.folder_empty_open, -- Ícone de pasta vazia aberta
          default = icons.default,               -- Ícone padrão
          python = icons.python,                 -- Ícone para arquivos Python
          javascript = icons.javascript,         -- Ícone para arquivos JavaScript
          typescript = icons.typescript,         -- Ícone para arquivos TypeScript
          go = icons.go,                         -- Ícone para arquivos Go
          java = icons.java,                     -- Ícone para arquivos Java
          php = icons.php,                       -- Ícone para arquivos PHP
          ruby = icons.ruby,                     -- Ícone para arquivos Ruby
          c = icons.c,                           -- Ícone para arquivos C
          cpp = icons.cpp,                       -- Ícone para arquivos C++
          markdown = icons.markdown,             -- Ícone para arquivos Markdown
          html = icons.html,                     -- Ícone para arquivos HTML
          css = icons.css,                       -- Ícone para arquivos CSS
          json = icons.json,                     -- Ícone para arquivos JSON
          hidden = icons.hidden,                 -- Ícone para arquivos ocultos
        },
        modified = { symbol = icons.modified },  -- Símbolo de arquivo modificado
        git_status = {
          symbols = {
            added = icons.added,                 -- Ícone para arquivos adicionados
            deleted = icons.deleted,             -- Ícone para arquivos deletados
            modified = icons.modified,           -- Ícone para arquivos modificados
            renamed = icons.renamed,             -- Ícone para arquivos renomeados
            untracked = icons.untracked,         -- Ícone para arquivos não rastreados
            ignored = icons.ignored,             -- Ícone para arquivos ignorados
            unstaged = icons.unstaged,           -- Ícone para arquivos não indexados
            staged = icons.staged,               -- Ícone para arquivos indexados
            conflict = icons.conflict,           -- Ícone para conflitos
          },
        },
      },
      commands = {
        system_open = function(state)
          vim.fn.jobstart({ "xdg-open", state.tree:get_node():get_id() })
        end,
        parent_or_close = function(state)
          local node = state.tree:get_node()
          if (node.type == "directory" or node:has_children()) and node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
        child_or_open = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" or node:has_children() then
            if not node:is_expanded() then
              state.commands.toggle_node(state)
            else
              require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
            end
          else
            state.commands.open(state)
          end
        end,
        copy_selector = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify

          local results = {
            e = { val = modify(filename, ":e"), msg = "Extension only" },
            f = { val = filename, msg = "Filename" },
            F = { val = modify(filename, ":r"), msg = "Filename w/o extension" },
            h = { val = modify(filepath, ":~"), msg = "Path relative to Home" },
            p = { val = modify(filepath, ":."), msg = "Path relative to CWD" },
            P = { val = filepath, msg = "Absolute path" },
          }

          local messages = {
            { "\nChoose to copy to clipboard:\n", "Normal" },
          }
          for i, result in pairs(results) do
            if result.val and result.val ~= "" then
              vim.list_extend(messages, {
                { ("%s."):format(i), "Identifier" },
                { (" %s: "):format(result.msg) },
                { result.val, "String" },
                { "\n" },
              })
            end
          end
          vim.api.nvim_echo(messages, false, {})
          local result = results[vim.fn.getcharstr()]
          if result and result.val and result.val ~= "" then
            vim.notify("Copied: " .. result.val)
            vim.fn.setreg("+", result.val)
          end
        end,
        find_in_dir = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          require("telescope.builtin").find_files {
            cwd = node.type == "directory" and path or vim.fn.fnamemodify(path, ":h"),
          }
        end,
      },
      window = {
        width = 30,
        mappings = {
          ["<space>"] = false,
          ["<S-CR>"] = "system_open",
          ["[b"] = "prev_source",
          ["]b"] = "next_source",
          F = "find_in_dir",
          O = "system_open",
          Y = "copy_selector",
          h = "parent_or_close",
          l = "child_or_open",
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = true,
        show_hidden = true,  -- Ative a opção para mostrar arquivos ocultos
      },
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function(_) vim.opt_local.signcolumn = "auto" end,
        },
      },
    }
  end,
}

