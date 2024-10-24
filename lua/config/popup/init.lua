local u = require("config.functions.utils")
local M = {}

-- Check if Nui is available
local popup_ok, Popup = pcall(require, "nui.popup")
if not popup_ok then
  vim.api.nvim_err_writeln("Nui not installed, cannot configure popups!")
  return
end

-- Create a popup state configuration
M.create_popup_state = function(title)
  return {
    buf_options = {
      filetype = "markdown",
    },
    relative = "editor",
    enter = true,
    focusable = true,
    zindex = 50,
    border = {
      style = "rounded",
      text = {
        top = title,
      },
    },
    position = "50%",
    size = {
      width = "40%",
      height = "60%",
    },
    opacity = 1.0,
  }
end

-- Create a popup and define an action to perform when a key is pressed
M.create_popup_with_action = function(title, action)
  local popup = Popup(M.create_popup_state(title))
  popup:mount()

  -- Set key mapping to exit popup and perform action
  vim.keymap.set("n", "<leader>s", function()
    local text = u.get_buffer_text(0) -- Retrieve text from the current buffer
    popup:unmount() -- Close the popup
    if action then -- Check if action is defined
      action(text) -- Execute the action with the retrieved text
    end
  end, { buffer = popup.bufnr, desc = "Exit popup and do action" })
end

return M

