-- vim: set foldmethod=marker foldlevel=0 foldmarker={{{,}}} : -
--
--

local aucmd   = vim.api.nvim_create_autocmd
local bufmap  = vim.api.nvim_buf_set_keymap
local opts    = { noremap = true, silent = true }

local augroup = function(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end


--[[
  Check if we need to reload the file after changes
]] --
aucmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})


--[[
Auto create parent directories when saving a file
]] --
aucmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})


--[[
 Highlight on yank
 ]] --
aucmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})


--[[
 Resize splits if window got resized
 ]] --
aucmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})


--[[
 Terminal escaping improvements
 ]] --
aucmd({ "TermOpen" }, {
  group = augroup("terminals"),
  callback = function()
    bufmap(0, "n", "<C-\\>", "ToggleTerm", opts)
    bufmap(0, "t", "<C-w>h", [[<C-\><C-n><C-W>h]], opts)
    bufmap(0, "t", "<C-w>j", [[<C-\><C-n><C-W>j]], opts)
    bufmap(0, "t", "<C-w>k", [[<C-\><C-n><C-W>k]], opts)
    bufmap(0, "t", "<C-w>l", [[<C-\><C-n><C-W>l]], opts)
    bufmap(0, "t", "<esc><esc>", [[<C-\><C-n>]], opts)
    bufmap(0, "t", "jk", [[<C-\><C-n>]], opts)
  end,
})


--[[
 User LSP Config (previously on_attach)
 ]] --
aucmd('LspAttach', {
  group = augroup('UserLspConfig'),
  callback = function(ev)
    local buf            = ev.buf

    -- Omnicompletion w/  <C-x><C-o>
    vim.bo[buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Hover
    bufmap(buf, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)

    -- Goto Definition
    bufmap(buf, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)

    -- Goto Type Definition
    bufmap(buf, "n", "gT", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)

    -- Go to Declaration
    bufmap(buf, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)

    -- Implementations
    bufmap(buf, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)

    -- References
    bufmap(buf, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)

    -- Refactoring
    bufmap(buf, "n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

    -- Call stack
    bufmap(buf, "n", "gI", "<cmd>lua vim.lsp.buf.incoming_calls<cr>", opts)
    bufmap(buf, "n", "gO", "<cmd>lua vim.lsp.buf.outgoing_calls<cr>", opts)

    -- Actions
    bufmap(buf, "n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)

    -- Location list
    bufmap(buf, "n", 'gq', "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

    -- Formatting
    bufmap(buf, "n", "gf", "<cmd>lua vim.lsp.buf.format()<cr>", opts)

    -- Diagnostics
    bufmap(buf, "n", 'gl', "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)

    -- Workspaces
    bufmap(buf, "n", 'gwa', "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    bufmap(buf, "n", 'gwr', "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    bufmap(buf, "n", 'gwl', "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  end,
})
