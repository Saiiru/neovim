local ol = vim.opt_local
local og = vim.opt_global

ol.colorcolumn = "120"
ol.iskeyword = og.iskeyword + ":,#"
ol.autoindent = true
ol.expandtab = true
ol.conceallevel = 0
ol.foldmethod = "indent"
ol.formatoptions = "tcq2l"
ol.shiftwidth = 2
ol.softtabstop = 2
ol.tabstop = 4
