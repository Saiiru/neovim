
-- OneSentencePerLine
local one_sentence_per_line = function()
  -- Check if the current mode is insert or replace
  if vim.fn.mode():match('^[iR]') then
    return
  end

  -- Get the start and end lines based on the current line and count
  local start = vim.v.lnum
  local count = vim.v.count > 0 and vim.v.count or 1
  local _end = start + count - 1

  -- Join lines from start to end
  vim.cmd(string.format('%d,%djoin', start, _end))

  -- Replace periods, exclamation marks, or question marks followed by one or more spaces
  -- with a newline, ensuring we only break after spaces following these punctuation marks
  vim.cmd(string.format([[%d,%ds/[.!?]\zs\s*\ze\S/\r/g]], start, _end))
end

-- Register the function as a command in Neovim
vim.api.nvim_create_user_command('OneSentencePerLine', one_sentence_per_line, {range = true})


