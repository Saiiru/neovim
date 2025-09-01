-- lua/kora/plugins/nvim-tree.lua
-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║ KORA · NvimTree Neural Interface Configuration (Grimório Neo-Noir)      ║
-- ║             Advanced File System Navigation Protocol                    ║
-- ╚══════════════════════════════════════════════════════════════════════════╝
--
-- SYSTEM ARCHITECTURE OVERVIEW:
-- ═════════════════════════════════════════════════════════════════════════════
-- Enhanced file tree interface with VSCode/JetBrains-level functionality.
-- Implements dynamic positioning, comprehensive keybinds, and precision
-- icon mapping using official Nerd Font specifications.
--
-- OPERATIONAL FEATURES:
--   • Dynamic side switching (left/right toggle)
--   • Full VSCode/JetBrains keymap compatibility
--   • Official Nerd Font icon integration
--   • Advanced Git status visualization
--   • Context-aware file operations
--   • Performance-optimized rendering
--
-- CONTROL INTERFACE (prefix <leader>e):
--   • <leader>ee: Toggle tree visibility
--   • <leader>ef: Focus current file in tree
--   • <leader>ec: Collapse all directories
--   • <leader>er: Refresh tree structure
--   • <leader>el: Toggle position (left/right)
--   • <leader>es: Toggle tree size (compact/expanded)

-- ~/.config/nvim/lua/kora/plugins/nvim-tree.lua
return {
  "nvim-tree/nvim-tree.lua",
  enabled = true,
  dependencies = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim" },
  config = function()
    local ok, nvimtree = pcall(require, "nvim-tree")
    if not ok then return end
    local api = require("nvim-tree.api")
    local p = require("kora.themes.cybersynth").palette

    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    local state = { side = "left", width = 30 , compact = false }

    local glyphs = {
      default = "󰈙",
      symlink = "󰌹",
      bookmark = "",
      modified = "●",
      folder = {
        arrow_closed = "󰅂",
        arrow_open   = "󰅀",
        default      = "󰉋",
        open         = "󰝰",
        empty        = "󰉖",
        empty_open   = "󰷏",
        symlink      = "󰉒",
        symlink_open = "󰷏",
      },
      git = {
        unstaged  = "󰄱",
        staged    = "󰱒",
        unmerged  = "󰘬",
        renamed   = "󰑕",
        untracked = "󰐙",
        deleted   = "󰍶",
        ignored   = "󰀨",
      },
    }

    nvimtree.setup({
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = false,
      hijack_directories = { enable = false, auto_open = false },
      update_focused_file = { enable = true, update_root = false, ignore_list = {} },
      system_open = { cmd = nil, args = {} },
      diagnostics = {
        enable = true, show_on_dirs = true,
        icons = { hint="󰌵", info="󰋼", warning="󰀦", error="󰅙" },
      },
      view = {
        width = state.width,            -- número (sem função)
        side  = state.side,             -- string "left" | "right"
        number = false, relativenumber = false,
        signcolumn = "yes", adaptive_size = false, centralize_selection = false,
      },
      renderer = {
        add_trailing = false, group_empty = true, full_name = false,
        highlight_git = true, highlight_opened_files = "all", highlight_modified = "name",
        root_folder_label = ":~:s?$?/..?", indent_width = 2,
        indent_markers = {
          enable = true, inline_arrows = true,
          icons = { corner="└", edge="│", item="│", bottom="─", none=" " },
        },
        icons = {
          webdev_colors = true,
          git_placement = "before",
          modified_placement = "after",
          padding = " ",
          symlink_arrow = " ➛ ",
          show = { file=true, folder=true, folder_arrow=true, git=true, modified=true },
          glyphs = glyphs,
        },
        special_files = {
          "Cargo.toml","Makefile","README.md","readme.md","package.json",".env",
          ".gitignore","tsconfig.json","vite.config.js","tailwind.config.js",
          "docker-compose.yml","Dockerfile",
        },
      },
      actions = {
        use_system_clipboard = true,
        change_dir = { enable = true, global = false, restrict_above_cwd = false },
        expand_all = { max_folder_discovery = 300, exclude = {} },
        file_popup = {
          open_win_config = { col=1,row=1,relative="cursor",border="shadow",style="minimal" },
        },
        open_file = {
          quit_on_open = false, resize_window = true,
          window_picker = {
            enable = true, picker = "default", chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
            exclude = { filetype = { "notify","qf","diff","fugitive","fugitiveblame" },
                        buftype  = { "nofile","terminal","help" } },
          },
        },
        remove_file = { close_window = true },
      },
      trash = { cmd = "gio trash", require_confirm = true },
      live_filter = { prefix = "[FILTER]: ", always_show_folders = true },
      tab = { sync = { open = false, close = false, ignore = {} } },
      notify = { threshold = vim.log.levels.INFO },
      log = { enable = false },
      filters = {
        dotfiles = false, git_clean = false, no_buffer = false,
        custom = { "node_modules","\\.cache","\\.DS_Store","\\.git$","thumbs\\.db" }, exclude = {},
      },
      filesystem_watchers = { enable = true, debounce_delay = 50, ignore_dirs = {} },
      git = { enable = true, ignore = false, show_on_dirs = true, show_on_open_dirs = true, timeout = 400 },
      modified = { enable = true, show_on_dirs = true, show_on_open_dirs = true },

      on_attach = function(bufnr)
        local function opts(desc) return { desc="nvim-tree: "..desc, buffer=bufnr, noremap=true, silent=true, nowait=true } end
        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.set('n','<C-]>', api.tree.change_root_to_node,          opts('CD'))
        vim.keymap.set('n','<C-e>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
        vim.keymap.set('n','<C-k>', api.node.show_info_popup,              opts('Info'))
        vim.keymap.set('n','<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
        vim.keymap.set('n','<C-t>', api.node.open.tab,                     opts('Open: New Tab'))
        vim.keymap.set('n','<C-v>', api.node.open.vertical,                opts('Open: Vertical Split'))
        vim.keymap.set('n','<C-x>', api.node.open.horizontal,              opts('Open: Horizontal Split'))
        vim.keymap.set('n','<BS>',  api.node.navigate.parent_close,        opts('Close Directory'))
        vim.keymap.set('n','<CR>',  api.node.open.edit,                    opts('Open'))
        vim.keymap.set('n','<Tab>', api.node.open.preview,                 opts('Open Preview'))
        vim.keymap.set('n','>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
        vim.keymap.set('n','<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
        vim.keymap.set('n','.',     api.node.run.cmd,                      opts('Run Command'))
        vim.keymap.set('n','-',     api.tree.change_root_to_parent,        opts('Up'))
        vim.keymap.set('n','a',     api.fs.create,                         opts('Create'))
        vim.keymap.set('n','bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
        vim.keymap.set('n','B',     api.tree.toggle_no_buffer_filter,      opts('Toggle No Buffer'))
        vim.keymap.set('n','c',     api.fs.copy.node,                      opts('Copy'))
        vim.keymap.set('n','C',     api.tree.toggle_git_clean_filter,      opts('Toggle Git Clean'))
        vim.keymap.set('n','[c',    api.node.navigate.git.prev,            opts('Prev Git'))
        vim.keymap.set('n',']c',    api.node.navigate.git.next,            opts('Next Git'))
        vim.keymap.set('n','d',     api.fs.remove,                         opts('Delete'))
        vim.keymap.set('n','D',     api.fs.trash,                          opts('Trash'))
        vim.keymap.set('n','E',     api.tree.expand_all,                   opts('Expand All'))
        vim.keymap.set('n','e',     api.fs.rename_basename,                opts('Rename: Basename'))
        vim.keymap.set('n',']e',    api.node.navigate.diagnostics.next,    opts('Next Diagnostic'))
        vim.keymap.set('n','[e',    api.node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))
        vim.keymap.set('n','F',     api.live_filter.clear,                 opts('Clean Filter'))
        vim.keymap.set('n','f',     api.live_filter.start,                 opts('Filter'))
        vim.keymap.set('n','g?',    api.tree.toggle_help,                  opts('Help'))
        vim.keymap.set('n','gy',    api.fs.copy.absolute_path,             opts('Copy Absolute Path'))
        vim.keymap.set('n','H',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
        vim.keymap.set('n','I',     api.tree.toggle_gitignore_filter,      opts('Toggle Git Ignore'))
        vim.keymap.set('n','J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
        vim.keymap.set('n','K',     api.node.navigate.sibling.first,       opts('First Sibling'))
        vim.keymap.set('n','m',     api.marks.toggle,                      opts('Toggle Bookmark'))
        vim.keymap.set('n','o',     api.node.open.edit,                    opts('Open'))
        vim.keymap.set('n','O',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
        vim.keymap.set('n','p',     api.fs.paste,                          opts('Paste'))
        vim.keymap.set('n','P',     api.node.navigate.parent,              opts('Parent Directory'))
        vim.keymap.set('n','q',     api.tree.close,                        opts('Close'))
        vim.keymap.set('n','r',     api.fs.rename,                         opts('Rename'))
        vim.keymap.set('n','R',     api.tree.reload,                       opts('Refresh'))
        vim.keymap.set('n','s',     api.node.run.system,                   opts('Run System'))
        vim.keymap.set('n','S',     api.tree.search_node,                  opts('Search'))
        vim.keymap.set('n','U',     api.tree.toggle_custom_filter,         opts('Toggle Hidden'))
        vim.keymap.set('n','W',     api.tree.collapse_all,                 opts('Collapse'))
        vim.keymap.set('n','x',     api.fs.cut,                            opts('Cut'))
        vim.keymap.set('n','y',     api.fs.copy.filename,                  opts('Copy Name'))
        vim.keymap.set('n','Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))

        -- highlights
        local function hl()
          vim.api.nvim_set_hl(0,"NvimTreeNormal",        { fg=p.text,        bg=p.bg_darker or p.bg })
          vim.api.nvim_set_hl(0,"NvimTreeWinSeparator",  { fg=p.neon_purple,  bg=p.bg_darker or p.bg })
          vim.api.nvim_set_hl(0,"NvimTreeRootFolder",    { fg=p.neon_pink,    bold=true, italic=true })
          vim.api.nvim_set_hl(0,"NvimTreeFolderName",    { fg=p.neon_cyan })
          vim.api.nvim_set_hl(0,"NvimTreeFolderIcon",    { fg=p.neon_yellow,  bold=true })
          vim.api.nvim_set_hl(0,"NvimTreeOpenedFolderName",{ fg=p.neon_green, bold=true, italic=true })
          vim.api.nvim_set_hl(0,"NvimTreeEmptyFolderName",{ fg=p.dim,         italic=true })
          vim.api.nvim_set_hl(0,"NvimTreeSpecialFile",   { fg=p.neon_purple,  underline=true, bold=true })
          vim.api.nvim_set_hl(0,"NvimTreeExecFile",      { fg=p.neon_green,   bold=true })
          vim.api.nvim_set_hl(0,"NvimTreeImageFile",     { fg=p.neon_purple,  italic=true })
          vim.api.nvim_set_hl(0,"NvimTreeMarkdownFile",  { fg=p.neon_cyan,    bold=true })
          vim.api.nvim_set_hl(0,"NvimTreeIndentMarker",  { fg=p.neon_purple,  blend=70 })
          vim.api.nvim_set_hl(0,"NvimTreeSymlink",       { fg=p.neon_pink,    italic=true, underline=true })
          vim.api.nvim_set_hl(0,"NvimTreeCursorLine",    { bg=p.selection or p.bg_lighter, blend=20 })
          vim.api.nvim_set_hl(0,"NvimTreeGitDirty",      { fg=p.neon_yellow,  bold=true })
          vim.api.nvim_set_hl(0,"NvimTreeGitStaged",     { fg=p.neon_green,   bold=true })
          vim.api.nvim_set_hl(0,"NvimTreeGitMerge",      { fg=p.neon_pink,    bold=true })
          vim.api.nvim_set_hl(0,"NvimTreeGitRenamed",    { fg=p.neon_purple,  italic=true })
          vim.api.nvim_set_hl(0,"NvimTreeGitNew",        { fg=p.neon_cyan,    bold=true })
          vim.api.nvim_set_hl(0,"NvimTreeGitDeleted",    { fg=p.neon_pink,    strikethrough=true })
          vim.api.nvim_set_hl(0,"NvimTreeGitIgnored",    { fg=p.dim,          italic=true })
        end
        hl()
        vim.api.nvim_create_autocmd("ColorScheme", {
          group = vim.api.nvim_create_augroup("NvimTreeColors", { clear = true }),
          callback = hl,
        })

        vim.opt_local.buflisted = false
        vim.opt_local.bufhidden = "hide"
        vim.opt_local.swapfile = false
      end,
    })

    local function toggle_side()
      state.side = (state.side == "left") and "right" or "left"
      api.tree.close()
      vim.defer_fn(function()
        nvimtree.setup({ view = { side = state.side } })
        api.tree.open()
      end, 50)
    end

    local function toggle_width()
      state.compact = not state.compact
      local w = state.compact and 25 or state.width
      api.tree.close()
      vim.defer_fn(function()
        nvimtree.setup({ view = { width = w } })
        api.tree.open()
      end, 50)
    end

    local km, o = vim.keymap, { noremap=true, silent=true }
    km.set("n","<leader>ee", api.tree.toggle,       vim.tbl_extend("force",o,{desc="Toggle file explorer"}))
    km.set("n","<leader>ef", api.tree.find_file,    vim.tbl_extend("force",o,{desc="Focus current file"}))
    km.set("n","<leader>ec", api.tree.collapse_all, vim.tbl_extend("force",o,{desc="Collapse all"}))
    km.set("n","<leader>er", api.tree.reload,       vim.tbl_extend("force",o,{desc="Refresh"}))
    km.set("n","<leader>el", toggle_side,           vim.tbl_extend("force",o,{desc="Toggle side"}))
    km.set("n","<leader>es", toggle_width,          vim.tbl_extend("force",o,{desc="Toggle size"}))
    km.set("n","<leader>eh", api.tree.toggle_help,  vim.tbl_extend("force",o,{desc="Help"}))

    -- which-key group (compat v2/v3)
    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
      local spec = {
        e = {
          name = "NvimTree",
          e = "Toggle",
          f = "Focus file",
          c = "Collapse",
          r = "Refresh",
          l = "Toggle side",
          s = "Toggle size",
          h = "Help",
        },
      }
      if wk.add then wk.add({ ["<leader>"] = spec }) else wk.register(spec, { prefix = "<leader>" }) end
    end

    -- vim.notify("KORA NvimTree: ONLINE", vim.log.levels.INFO, { title = "File System" })
  end,
}

