vim.filetype.add({
  pattern = {
    ['.*%.tf$'] = 'terraform',
    ['.*%.json%.j2$'] = 'json',
    ['Dockerfile%-.*'] = 'Dockerfile',
    ['.*%.template$'] = 'json',
    ['~/.config/git/.*'] = 'gitconfig',
    ['~/.gitconf%.d/.*'] = 'gitconfig',
    ['%.gitignore$'] = 'gitignore',
    ['.*%.snippets$'] = 'snippets',
    ['.*%.keymap$'] = 'devicetree',
    ['.*%.dtsi$'] = 'devicetree',
    ['~/.config/tmux/.*'] = 'tmux',
    ['~/.tmux%.conf%.d/.*'] = 'tmux',
  }
})

