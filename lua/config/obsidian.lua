-- Obsidian Integration
-- Full PDE note-taking with telekasten + obsidian.nvim
-- Syncs with ~/Documents/Obsidian vault

local M = {}

M.vault_path = vim.fn.expand("~/Documents/Obsidian")

-- Setup telekasten for Zettelkasten workflow
function M.setup_telekasten()
  local ok, telekasten = pcall(require, "telekasten")
  if not ok then return end

  telekasten.setup({
    home = M.vault_path,
    take_over_my_home = false,
    auto_set_filetype = "markdown",
    dailies = M.vault_path .. "/01-Journal/Daily",
    weeklies = M.vault_path .. "/01-Journal/Weekly",
    templates = M.vault_path .. "/99-Templates",
    image_subdir = "assets/img",
    extension = ".md",
    new_note_filename = "uuid-title",
    uuid_type = "%Y%m%d%H%M",
    uuid_sep = "-",
    follow_creates_nonexisting = true,
    dailies_create_nonexisting = true,
    weeklies_create_nonexisting = true,
    template_new_note = M.vault_path .. "/99-Templates/note.md",
    template_new_daily = M.vault_path .. "/99-Templates/daily.md",
    template_new_weekly = M.vault_path .. "/99-Templates/weekly.md",
    image_link_style = "wiki",
    sort = "filename",
    plug_into_calendar = true,
    calendar_opts = {
      weeknm = 1,
      calendar_monday = 1,
      calendar_mark = "left-fit",
    },
    close_after_yanking = false,
    after_yank_closes_buffer = false,
    after_linking = "confirm",
    show_tags = "#",
    tag_notation = "#tag",
    subdirs_in_links = true,
    template_handling = "smart",
    new_note_location = "smart",
    rename_update_links = true,
    media_previewer = "ueberzugpp",
  })
end

-- Setup obsidian.nvim for modern Obsidian features
function M.setup_obsidian()
  local ok, obsidian = pcall(require, "obsidian")
  if not ok then return end

  obsidian.setup({
    workspaces = {
      {
        name = "vault",
        path = M.vault_path,
      },
    },
    notes_subdir = "00-Inbox",
    new_notes_location = "notes_subdir",
    daily_notes = {
      folder = "01-Journal/Daily",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      default_tags = { "daily" },
      template = "daily.md",
    },
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    mappings = {
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      ["<leader>ch"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      ["<leader>oc"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },
    note_frontmatter_func = function(note)
      local out = { id = note.id, aliases = note.aliases, tags = note.tags, created = os.date("%Y-%m-%d %H:%M") }
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end
      return out
    end,
    note_id_func = function(title)
      local suffix = ""
      if title ~= nil then
        suffix = title:gsub(" ", "-"):gsub("[^%w-]", ""):lower()
      else
        suffix = tostring(os.time())
      end
      return string.format("%s-%s", os.date("%Y%m%d%H%M"), suffix)
    end,
    templates = {
      folder = "99-Templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      substitutions = {
        yesterday = function() return os.date("%Y-%m-%d", os.time() - 86400) end,
        tomorrow = function() return os.date("%Y-%m-%d", os.time() + 86400) end,
      },
    },
    ui = {
      enable = true,
      update_debounce = 200,
      max_file_length = 5000,
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        ["!"] = { char = "", hl_group = "ObsidianImportant" },
      },
      bullets = { char = "•", hl_group = "ObsidianBullet" },
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = "ObsidianRefText" },
      highlight_text = { hl_group = "ObsidianHighlightText" },
      tags = { hl_group = "ObsidianTag" },
      block_ids = { hl_group = "ObsidianBlockID" },
      hl_groups = {
        ObsidianTodo = { bold = true, fg = "#f78c6c" },
        ObsidianDone = { bold = true, fg = "#89ddff" },
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianImportant = { bold = true, fg = "#d73128" },
        ObsidianBullet = { bold = true, fg = "#89ddff" },
        ObsidianRefText = { underline = true, fg = "#c792ea" },
        ObsidianExtLinkIcon = { fg = "#c792ea" },
        ObsidianTag = { italic = true, fg = "#89ddff" },
        ObsidianBlockID = { italic = true, fg = "#89ddff" },
        ObsidianHighlightText = { bg = "#75662e" },
      },
    },
  })
end

-- Keymaps for Obsidian workflow
function M.setup_keymaps()
  local map = vim.keymap.set
  local opts = { silent = true, desc = "" }

  -- Telekasten keymaps
  map("n", "<leader>oz", "<cmd>Telekasten<cr>", { desc = "📂 Telekasten menu" })
  map("n", "<leader>on", "<cmd>Telekasten new_note<cr>", { desc = "📝 New note" })
  map("n", "<leader>od", "<cmd>Telekasten goto_today<cr>", { desc = "📅 Today's daily note" })
  map("n", "<leader>oD", "<cmd>Telekasten goto_yesterday<cr>", { desc = "📅 Yesterday's daily note" })
  map("n", "<leader>ow", "<cmd>Telekasten goto_thisweek<cr>", { desc = "📅 This week's note" })
  map("n", "<leader>of", "<cmd>Telekasten find_notes<cr>", { desc = "🔍 Find notes" })
  map("n", "<leader>og", "<cmd>Telekasten search_notes<cr>", { desc = "🔍 Grep notes" })
  map("n", "<leader>ot", "<cmd>Telekasten show_tags<cr>", { desc = "🏷️ Show tags" })
  map("n", "<leader>ol", "<cmd>Telekasten follow_link<cr>", { desc = "🔗 Follow link" })
  map("n", "<leader>ob", "<cmd>Telekasten show_backlinks<cr>", { desc = "🔙 Show backlinks" })
  map("n", "<leader>oi", "<cmd>Telekasten insert_img_link<cr>", { desc = "🖼️ Insert image" })
  map("n", "<leader>or", "<cmd>Telekasten rename_note<cr>", { desc = "✏️ Rename note" })
  map("n", "<leader>oc", "<cmd>Telekasten show_calendar<cr>", { desc = "📆 Calendar" })

  -- Obsidian.nvim keymaps
  map("n", "<leader>oo", "<cmd>ObsidianOpen<cr>", { desc = "🌐 Open in Obsidian app" })
  map("n", "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", { desc = "⚡ Quick switch" })
  map("n", "<leader>op", "<cmd>ObsidianPasteImg<cr>", { desc = "📋 Paste image" })
  map("n", "<leader>ox", "<cmd>ObsidianExtractNote<cr>", { desc = "✂️ Extract note" })
  map("n", "<leader>ol", "<cmd>ObsidianLink<cr>", { desc = "🔗 Link selection" })
  map("n", "<leader>oL", "<cmd>ObsidianLinkNew<cr>", { desc = "🔗 Link new note" })
  map("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", { desc = "🔙 Backlinks" })
  map("n", "<leader>ot", "<cmd>ObsidianTags<cr>", { desc = "🏷️ Tags" })
  map("n", "<leader>on", "<cmd>ObsidianNew<cr>", { desc = "📝 New note" })
  map("n", "<leader>od", "<cmd>ObsidianToday<cr>", { desc = "📅 Today" })
  map("n", "<leader>oy", "<cmd>ObsidianYesterday<cr>", { desc = "📅 Yesterday" })
  map("n", "<leader>ow", "<cmd>ObsidianTomorrow<cr>", { desc = "📅 Tomorrow" })
  map("n", "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", { desc = "⚡ Quick switch" })

  -- Template keymaps
  map("n", "<leader>oT", function()
    require("telekasten").panel_templates()
  end, { desc = "📋 Templates panel" })

  -- Wiki-style links
  map("n", "<CR>", function()
    if vim.bo.filetype == "markdown" then
      return "<cmd>Telekasten follow_link<cr>"
    end
    return "<CR>"
  end, { expr = true, desc = "Follow wiki link" })

  -- Checkbox toggle
  map("n", "<leader>ch", function()
    if vim.bo.filetype == "markdown" then
      require("obsidian").util.toggle_checkbox()
    end
  end, { desc = "☑️ Toggle checkbox" })

  -- Git integration for vault
  map("n", "<leader>ogc", function()
    local cmd = string.format("cd %s && git add . && git commit -m 'vault: auto-sync %s' && git push", M.vault_path, os.date("%Y-%m-%d %H:%M"))
    vim.fn.jobstart(cmd, { detach = true })
    vim.notify("🔄 Vault synced to git", vim.log.levels.INFO)
  end, { desc = "🔄 Sync vault to git" })
end

function M.setup()
  M.setup_telekasten()
  M.setup_obsidian()
  M.setup_keymaps()
end

return M