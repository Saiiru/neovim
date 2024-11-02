local augroup = vim.api.nvim_create_augroup
local cmd = vim.api.nvim_create_autocmd

local exist, user_config = pcall(require, "user.user_config")
local group = exist and type(user_config) == "table" and user_config.autocommands or {}
local plugin = exist and type(user_config) == "table" and user_config.enable_plugins or {}
local enabled = require("config.utils").enabled

-- disables code folding for the start screen
if enabled(group, "alpha_folding") then
	cmd({ "FileType" }, {
		desc = "Disable folding for alpha buffer",
		group = augroup("alpha", { clear = true }),
		pattern = "alpha",
		command = "setlocal nofoldenable",
	})
end

-- Fixes some bugs with how treesitter manages folds
if enabled(group, "treesitter_folds") then
	cmd({ "BufEnter", "BufAdd", "BufNew", "BufNewFile", "BufWinEnter" }, {
		desc = "fix tree sitter folds issue",
		group = augroup("treesitter folds", { clear = true }),
		pattern = { "*" },
		callback = function()
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
		end,
	})
end

-- Removes any trailing whitespace when saving a file
if enabled(group, "trailing_whitespace") then
	cmd({ "BufWritePre" }, {
		desc = "remove trailing whitespace on save",
		group = augroup("remove trailing whitespace", { clear = true }),
		pattern = { "*" },
		command = [[%s/\s\+$//e]],
	})
end

-- remembers file state, such as cursor position and any folds
if enabled(group, "remember_file_state") then
	augroup("remember file state", { clear = true })
	cmd({ "BufWinLeave" }, {
		desc = "remember file state",
		group = "remember file state",
		pattern = { "*.*" },
		command = "mkview",
	})
	cmd({ "BufWinEnter" }, {
		desc = "remember file state",
		group = "remember file state",
		pattern = { "*.*" },
		command = "silent! loadview",
	})
end

-- gives you a notification upon saving a session
if enabled(group, "session_saved_notification") then
	cmd({ "User" }, {
		desc = "notify session saved",
		group = augroup("session save", { clear = true }),
		pattern = "SessionSavePost",
		command = "lua vim.notify('Session Saved', 'info')",
	})
end

-- enables coloring hexcodes and color names in css, jsx, etc.
if enabled(group, "css_colorizer") and enabled(plugin, "colorizer") then
	cmd({ "Filetype" }, {
		desc = "activate colorizer",
		pattern = "css,scss,html,xml,svg,js,jsx,ts,tsx,php,vue",
		group = augroup("colorizer", { clear = true }),
		callback = function()
			require("colorizer").attach_to_buffer(0, {
				mode = "background",
				css = true,
			})
		end,
	})
end

-- disables autocomplete in some filetypes
if enabled(group, "cmp") and enabled(plugin, "cmp") then
	cmd({ "FileType" }, {
		desc = "disable cmp in certain filetypes",
		pattern = "gitcommit,gitrebase,text",
		group = augroup("cmp_disable", { clear = true }),
		command = "lua require('cmp').setup.buffer { enabled = false}",
	})
end

-- fixes Trouble not closing when last window in tab
cmd("BufEnter", {
	group = vim.api.nvim_create_augroup("TroubleClose", { clear = true }),
	callback = function()
		local layout = vim.api.nvim_call_function("winlayout", {})
		if
			layout[1] == "leaf"
			and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "Trouble"
			and layout[3] == nil
		then
			vim.cmd("confirm quit")
		end
	end,
})

-- Função para criação de diretório ao salvar arquivo, caso ele não exista
vim.cmd([[
  function! MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file !~# '\v^\w+\:\/'
      let dir = fnamemodify(a:file, ':h')
      if !isdirectory(dir)
        call mkdir(dir, 'p')
      endif
    endif
  endfunction

  augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * call MkNonExDir(expand('<afile>'), expand('<abuf>'))
  augroup END
]])

-- Variável global para armazenar a posição do cursor
local cursor_pos = {}

-- Grupo de autocmds otimizados
local yank_group = vim.api.nvim_create_augroup("YankPostGroup", { clear = true })

-- Callback para restaurar a posição do cursor após um yank
local function restore_cursor()
  if vim.v.event.operator == "y" then
    vim.fn.setpos(".", cursor_pos)
  end
end

-- Autocmd para salvar a posição do cursor e destacar o yank
vim.api.nvim_create_autocmd({ "VimEnter", "CursorMoved" }, {
  group = yank_group,
  pattern = "*",
  callback = function()
    cursor_pos = vim.fn.getpos(".")
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 400, on_visual = true })
    restore_cursor()
  end,
  desc = "Highlight yanked text and restore cursor position",
})

vim.api.nvim_create_autocmd("ColorScheme", {
   pattern = "*",
   callback = function()
      vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#b4befe" })
      vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#b4befe" })
      vim.api.nvim_set_hl(0, "IblScope", { fg = "#b4befe" })
   end,
})

-- only highlight when searching
vim.api.nvim_create_autocmd("CmdlineEnter", {
   callback = function()
      local cmd = vim.v.event.cmdtype
      if cmd == "/" or cmd == "?" then
         vim.opt.hlsearch = true
      end
   end,
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
   callback = function()
      local cmd = vim.v.event.cmdtype
      if cmd == "/" or cmd == "?" then
         vim.opt.hlsearch = false
      end
   end,
})

-- Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
   callback = function()
      vim.highlight.on_yank({ timeout = 200 })
   end,
})

-- Disable auto comment
vim.api.nvim_create_autocmd("BufEnter", {
   callback = function()
      vim.opt.formatoptions = { c = false, r = false, o = false }
   end,
})

-- turn on spell check for markdown and text file
vim.api.nvim_create_autocmd("BufEnter", {
   pattern = { "*.md" },
   callback = function()
      vim.opt_local.spell = true
   end,
})

-- keymap for .cpp file
vim.api.nvim_create_autocmd("BufEnter", {
   pattern = { "*.cpp", "*.cc" },
   callback = function()
      vim.keymap.set(
         "n",
         "<Leader>e",
         ":terminal ./a.out<CR>",
         { silent = true }
      )
      -- vim.keymap.set("n", "<Leader>e", ":!./sfml-app<CR>",
      --    { silent = true })
   end,
})

-- tab format for .lua file
vim.api.nvim_create_autocmd("BufEnter", {
   pattern = { "*.lua" },
   callback = function()
      vim.opt.shiftwidth = 3
      vim.opt.tabstop = 3
      vim.opt.softtabstop = 3
      -- vim.opt_local.colorcolumn = {70, 80}
   end,
})

-- keymap for .go file
vim.api.nvim_create_autocmd("BufEnter", {
   pattern = { "*.go" },
   callback = function()
      vim.keymap.set(
         "n",
         "<Leader>te",
         ":terminal go run %<CR>",
         { silent = true }
      )
   end,
})

-- keymap for .py file
vim.api.nvim_create_autocmd("BufEnter", {
   pattern = { "*.py" },
   callback = function()
      vim.keymap.set(
         "n",
         "<Leader>te",
         ":terminal python3 %<CR>",
         { silent = true }
      )
   end,
})

-- -- keymap for .ino file
-- vim.api.nvim_create_autocmd("BufEnter", {
--    pattern = { "*.ino" },
--    callback = function()
--       vim.keymap.set(
--          "n",
--          "<Leader>c",
--          ":terminal arduino-cli compile --fqbn arduino:avr:uno %<CR>",
--          { silent = true }
--       )
--       vim.keymap.set(
--          "n",
--          "<Leader>u",
--          ":terminal arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:avr:uno %<CR>",
--          { silent = true }
--       )
--       vim.keymap.set(
--          "n",
--          "<Leader>m",
--          ":terminal arduino-cli monitor -p /dev/ttyACM0<CR>",
--          { silent = true }
--       )
--    end,
-- })
