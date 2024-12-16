return {
  "mistricky/codesnap.nvim",
  build = "make",
  cmd = { "CodeSnap", "CodeSnapSave" },
  vscode = false,
  keys = {
    { "<leader>cs", mode = "v", "<cmd>'<,'>CodeSnap<CR>", desc = "Screenshot (Clipboard)" },
    { "<leader>cS", mode = "v", "<cmd>'<,'>CodeSnapSave<CR>", desc = "Screenshot (Save)" },
  },
  cond = vim.env.KITTY_SCROLLBACK_NVIM == nil, -- Ensure it doesn't run in Kitty scrollback mode
  opts = {
    -- Default save path for screenshots
    save_path = (os.getenv "HOME" .. "/pictures/screenshots/code"),

    -- Title of the screenshots (appears on hover and tooltips)
    title = "CodeSnap.nvim",

    -- Set the font for code, using FiraCode Nerd Font for better support
    code_font_family = "FiraCode Nerd Font",
    watermark_font_family = "FiraCode Nerd Font", -- Use the same font for watermark

    -- Set watermark text if you want (empty string by default)
    watermark = "",

    -- Background theme options for the screenshot
    bg_theme = "dark", -- You can change this to any available theme like 'light', 'dark', etc.
  },
}
