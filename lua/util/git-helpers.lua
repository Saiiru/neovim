-- git-helpers.lua
local u = require("config.functions.utils")
local M = {}
local plenary_ok, job = pcall(require, "plenary.job")

if not plenary_ok then
  vim.api.nvim_err_writeln("Plenary not installed, cannot use Git helpers")
  return
end

local function getWords()
  if vim.bo.filetype == "md" or vim.bo.filetype == "txt" or vim.bo.filetype == "markdown" then
    local word_count = vim.fn.wordcount()
    if word_count.visual_words and word_count.visual_words == 1 then
      return "1 word"
    elseif word_count.visual_words and word_count.visual_words > 1 then
      return word_count.visual_words .. " words"
    else
      return word_count.words .. " words"
    end
  end
  return ""
end

local function place()
  return string.format("C:%s L:%s/%s", "%c", "%l", "%L")
end

local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
  return function(str)
    local win_width = vim.fn.winwidth(0)
    if hide_width and win_width < hide_width then
      return ""
    elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
      return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
    end
    return str
  end
end

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local function window()
  return vim.api.nvim_win_get_number(0)
end

local function show_macro_recording()
  local recording_register = vim.fn.reg_recording()
  return recording_register == "" and "" or "󰑋 " .. recording_register
end

local function get_git_head()
  local head = vim.fn.trim(vim.fn.system({ "git", "branch", "--show-current" }))
  if vim.v.shell_error ~= 0 or head == "" then
    return "DETACHED "
  end
  return string.len(head) > 20 and " " .. head:sub(1, 20) .. "..." or " " .. head
end

M.getWords = getWords
M.place = place
M.trunc = trunc
M.diff_source = diff_source
M.window = window
M.show_macro_recording = show_macro_recording
M.get_git_head = get_git_head

return M
