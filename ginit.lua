local o = vim.opt
local g = vim.g

o.guifont = "OperatorMono Nerd Font:h16"

if vim.g.neovide then
  g.neovide_padding_left = 0
  g.neovide_padding_right = 0
  g.neovide_padding_top = 0
  g.neovide_padding_bottom = 0

  g.neovide_transparency = 1.0
  g.transparency = 0.7

  g.neovide_window_blurred = true 
  g.neovide_floating_blur_amoount_x  = 2.0
  g.neovide_floating_blur_amoount_y  = 2.0

  g.neovide_show_border = true

  g.neovide_remember_window_size = true

  g.neovide_input_macos_alt_is_meta = true
end


