local function colorMyPencils()
    -- Define colors
    local hot_pink = "#FF69B4"
    local gray_800 = "#333333"
    local gray_900 = "#111111"
    local white = "#FFFFFF"
    
    -- Apply specified colors
    vim.cmd("highlight Comment guifg="..hot_pink)
    vim.cmd("highlight Boolean guifg="..hot_pink)
    vim.cmd("highlight Number guifg="..hot_pink)
    vim.cmd("highlight String guifg="..hot_pink)
    vim.cmd("highlight Keyword guifg="..hot_pink)
    
    -- Exclude certain elements from italic
    local nonItalicScopes = {
        "invalid",
        "keyword.operator",
        "constant.numeric.css",
        "keyword.other.unit.px.css",
        "constant.numeric.decimal.js",
        "constant.numeric.json",
        "comment.block",
        "entity.other.attribute-name.class.css"
    }
    for _, scope in ipairs(nonItalicScopes) do
        vim.cmd("highlight! link " .. scope .. " None") -- Remove italic
    end
end

colorMyPencils() -- Call the function to apply colors

return {
    {
        "erikbackman/brightburn.vim",
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        opts = {},
        config = function()
            -- Additional configuration can be added here
        end,
    },
    {
        "ellisonleao/gruvbox.nvim",
        name = "gruvbox",
        config = function()
            require("gruvbox").setup({
                terminal_colors = true,
                undercurl = true,
                underline = false,
                bold = true,
                italic = {
                    strings = false,
                    emphasis = false,
                    comments = false,
                    operators = false,
                    folds = false,
                },
                strikethrough = true,
                invert_selection = false,
                invert_signs = false,
                invert_tabline = false,
                invert_intend_guides = false,
                inverse = true, 
                contrast = "", 
                palette_overrides = {},
                overrides = {},
                dim_inactive = false,
                transparent_mode = false,
            })
        end,
    },
    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                style = "storm",
                transparent = true,
                terminal_colors = true,
                styles = {
                    comments = { italic = false },
                    keywords = { italic = false },
                    sidebars = "dark",
                    floats = "dark",
                },
            })
        end,
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
                disable_background = true,
                styles = {
                    italic = false,
                },
            })
        end,
    },
    {
    "jesseleite/nvim-noirbuddy",
    dependencies = {
        "tjdevries/colorbuddy.nvim",
    },
    priority = 1000,
    config = function()
        require("noirbuddy").setup({
            preset = "minimal",
            styles = {
                italic = true,
                bold = true,
                underline = true,
                undercurl = true,
            },
            colors = {
                background = "#101010",
                primary = "#4d4d4d", -- Adjusted for more vibrant gray
                secondary = "#ffffff",
                noir_0 = "#f1f1f1",
                noir_1 = "#e2e2e2",
                noir_2 = "#b0b0b0", -- Adjusted for more vibrant gray
                noir_3 = "#a7a7a7",
                noir_4 = "#888888", -- Adjusted for more vibrant gray
                noir_5 = "#777777", -- Adjusted for more vibrant gray
                noir_6 = "#666666", -- Adjusted for more vibrant gray
                noir_7 = "#555555", -- Adjusted for more vibrant gray
                noir_8 = "#444444", -- Adjusted for more vibrant gray
                noir_9 = "#333333", -- Adjusted for more vibrant gray
            },
        })

        -- Tokens colors
        vim.cmd("highlight @variable guifg=#e2e2e2") -- Adjusted for more contrast
        vim.cmd("highlight @variable.builtin guifg=#e2e2e2")
        vim.cmd("highlight @variable.member guifg=#b0b0b0") -- Adjusted for more vibrant gray

        vim.cmd("highlight @constant guifg=#b0b0b0") -- Adjusted for more vibrant gray

        vim.cmd("highlight @keyword guifg=#888888") -- Adjusted for more vibrant gray
        vim.cmd("highlight @keyword.operator guifg=#888888") -- Adjusted for more vibrant gray
        vim.cmd("highlight @keyword.function guifg=#888888") -- Adjusted for more vibrant gray
        vim.cmd("highlight @keyword.return guifg=#888888") -- Adjusted for more vibrant gray

        vim.cmd("highlight @punctuation.bracket guifg=#888888") -- Adjusted for more vibrant gray

        vim.cmd("highlight @constructor guifg=#888888") -- Adjusted for more vibrant gray

        vim.cmd("highlight @operator guifg=#888888") -- Adjusted for more vibrant gray
        vim.cmd("highlight @comment guifg=#888888") -- Adjusted for more vibrant gray
        vim.cmd("highlight @string guifg=#888888") -- Adjusted for more vibrant gray

        vim.cmd("highlight @keyword.coroutine guifg=#888888") -- Adjusted for more vibrant gray

        vim.cmd("highlight @function.builtin guifg=#999999") -- Adjusted for more vibrant gray
        vim.cmd("highlight @function.call guifg=#999999") -- Adjusted for more vibrant gray
        vim.cmd("highlight @function.method.call guifg=#999999") -- Adjusted for more vibrant gray

        vim.cmd("highlight @tag guifg=#888888") -- Adjusted for more vibrant gray
        vim.cmd("highlight @tag.delimiter guifg=#888888") -- Adjusted for more vibrant gray
        vim.cmd("highlight @tag.attribute guifg=#888888") -- Adjusted for more vibrant gray

        vim.cmd("highlight @lsp.type.parameter guifg=#999999 gui=italic") -- Adjusted for more vibrant gray

        vim.cmd("highlight @type guifg=#e2e2e2")
        vim.cmd("highlight @type.qualifier guifg=#888888") -- Adjusted for more vibrant gray

        -- Vim command line error colors
        vim.cmd("highlight ErrorMsg guifg=#888888 guibg=#ff8989") -- Adjusted for more vibrant gray

        -- NvimTree colors
        vim.cmd("highlight NvimTreeFolderIcon guifg=#888888") -- Adjusted for more vibrant gray
        vim.cmd("highlight NvimTreeFolderName guifg=#999999")
        vim.cmd("highlight NvimTreeFileIcon guifg=#888888") -- Adjusted for more vibrant gray
        vim.cmd("highlight NvimTreeFileName guifg=#888888") -- Adjusted for more vibrant gray
        vim.cmd("highlight NvimTreeIndentMarker guifg=#888888") -- Adjusted for more vibrant gray
        vim.cmd("highlight NvimTreeNormal guibg=NONE guifg=#888888") -- Adjusted for more vibrant gray
        vim.cmd("highlight NvimTreeVertSplit guibg=NONE guifg=NONE")

        vim.cmd("highlight NvimTreeCursorLine guibg=#171717 guifg=NONE gui=bold")

        vim.cmd("highlight NvimTreeGitDirty guifg=#f0c674")
        vim.cmd("highlight NvimTreeGitNew guifg=#9bcea5")
        vim.cmd("highlight NvimTreeGitStaged guifg=#89B4FA")
        vim.cmd("highlight NvimTreeGitUnstaged guifg=#addef8")
        vim.cmd("highlight NvimTreeGitUntracked guifg=#f0c674")
        vim.cmd("highlight NvimTreeGitRenamed guifg=#f2ff8a")
        vim.cmd("highlight NvimTreeGitIgnored guifg=#333333")
        vim.cmd("highlight NvimTreeGitMerge guifg=#A978F6")
        vim.cmd("highlight NvimTreeGitModified guifg=#addef8")
        vim.cmd("highlight NvimTreeGitDeleted guifg=#ff8989")
        vim.cmd("highlight NvimTreeWinSeparator guibg=NONE guifg=#101010")

        -- Diagnostic colors
        vim.cmd("highlight DiagnosticError guifg=#ff8989")
        vim.cmd("highlight DiagnosticWarn guifg=#f0c674")
        vim.cmd("highlight DiagnosticInfo guifg=#89B4FA")
        vim.cmd("highlight DiagnosticHint guifg=#9bcea5")

        -- Diagnostic signs colors
        vim.cmd("highlight DiagnosticSignError guifg=#ff8989")
        vim.cmd("highlight DiagnosticSignWarn guifg=#f0c674")
        vim.cmd("highlight DiagnosticSignInfo guifg=#89B4FA")
        vim.cmd("highlight DiagnosticSignHint guifg=#9bcea5")

        -- Editor transparent colors
        vim.cmd("highlight Normal guibg=none")
        vim.cmd("highlight NonText guibg=none")
        vim.cmd("highlight Normal ctermbg=none")
        vim.cmd("highlight NonText ctermbg=none")

        vim.cmd("highlight clear LineNr")
        vim.cmd("highlight clear SignColumn")

        -- LSP colors
        vim.cmd("highlight FloatBorder guibg=NONE guifg=#888888") -- Adjusted for more vibrant gray
        vim.cmd("highlight FloatShadow guibg=NONE guifg=NONE")
        vim.cmd("highlight FloatShadowThrough guibg=NONE guifg=NONE")

        -- Visual mode colors
        vim.cmd("highlight Visual guibg=#181818 guifg=NONE")

        -- Numbers Gutter
        vim.cmd("highlight LineNr guifg=#888888") -- Adjusted for more vibrant gray

        vim.cmd("highlight Cursor guibg=NONE")
        vim.cmd("highlight CursorLine guibg=#181818 guifg=NONE")
        vim.cmd("highlight CursorLineNr guibg=NONE guifg=#888888 gui=bold") -- Adjusted for more vibrant gray

        -- Split colors
        vim.cmd("highlight VertSplit guibg=NONE guifg=#101010")
        vim.cmd("highlight WinSeparator guibg=NONE guifg=#101010")

        -- Command line colors
        vim.cmd("highlight Pmenu guibg=#181818 guifg=#888888") -- Adjusted for more vibrant gray
        vim.cmd("highlight PmenuSel guibg=#222222 guifg=#ffffff")
        vim.cmd("highlight PmenuSbar guibg=#181818 guifg=#0f0f0f")
        vim.cmd("highlight PmenuThumb guibg=#222222 guifg=#0f0f0f")

        -- Floating window colors
        vim.cmd("highlight NormalFloat guibg=NONE guifg=#888888") -- Adjusted for more vibrant gray

        -- Fold colors
        vim.cmd("highlight Folded guibg=NONE guifg=#888888") -- Adjusted for more vibrant gray

        -- Gitsigns colors
        vim.cmd("highlight GitSignsAdd guifg=#9bcea5")
        vim.cmd("highlight GitSignsChange guifg=#f0c674")
        vim.cmd("highlight GitSignsDelete guifg=#ff8989")

        -- Telescope colors
        vim.cmd("highlight TelescopeBorder guibg=NONE guifg=#888888") -- Adjusted for more vibrant gray

        -- Noice colors
        vim.cmd("highlight NoiceCmdlineIcon guibg=NONE guifg=#ffffff")
        vim.cmd("highlight NoiceCmdlinePopup guibg=NONE guifg=#888888") -- Adjusted for more vibrant gray
        vim.cmd("highlight NoiceCmdlinePopupBorderInput guibg=NONE guifg=#888888") -- Adjusted for more vibrant gray
        vim.cmd("highlight NoiceCmdlinePopupBorder guibg=NONE guifg=#888888") -- Adjusted for more vibrant gray

        -- Devicons colors
        vim.cmd("highlight DevIconDefault guifg=#999999")
        vim.cmd("highlight DevIconUnknown guifg=#999999")
    end,
},
}
