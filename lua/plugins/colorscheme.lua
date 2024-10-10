local function colorMyPencils()
    -- Set color for comments
    vim.cmd("highlight Comment guifg='#FF00FF' gui=italic") -- Neon Pink

    -- Set color for booleans
    vim.cmd("highlight Boolean guifg='#FF00FF'") -- Neon Pink

    -- Set color for numbers
    vim.cmd("highlight Number guifg='#FF00FF'") -- Neon Pink

    -- Set color for strings
    vim.cmd("highlight String guifg='#FF00FF'") -- Neon Pink

    -- Set colors for keywords
    vim.cmd("highlight Keyword guifg='#FF00FF' gui=bold") -- Neon Pink

    -- Set vibrant neon gray tones
    vim.cmd("highlight Normal guifg='#d5d5d5' guibg='#121212'")
    vim.cmd("highlight NonText guifg='#737373'")
    vim.cmd("highlight LineNr guifg='#737373'")
    vim.cmd("highlight CursorLineNr guifg='#FF00FF' gui=bold")
    vim.cmd("highlight Comment guifg='#FF00FF' gui=italic")
    vim.cmd("highlight Constant guifg='#FF00FF'")
    vim.cmd("highlight Special guifg='#d5d5d5'")

    -- Set font styles for specific languages
    vim.cmd("highlight! link javaType StorageType") -- Make Java types bold
    vim.cmd("highlight! link tsType StorageType") -- Make TypeScript types bold

    -- Set font styles for italic and bold
    local italicScopes = {
        "comment",
        "keyword.control.import.js", -- import
        "keyword.control.export.js", -- export
        "keyword.control.from.js", -- from
        "storage.modifier", -- static keyword
        "storage.type.class", -- class keyword
        "storage.type.php", -- typehints in methods keyword
        "keyword.other.new.php", -- new
        "entity.other.attribute-name", -- html attributes
        "fenced_code.block.language.markdown",
        "storage.type.java", -- Java types
        "storage.type.ts" -- TypeScript types
    }
    
    for _, scope in ipairs(italicScopes) do
        vim.cmd("highlight! link " .. scope .. " Italic") -- Set italic
    end

    -- Set bold for class names
    vim.cmd("highlight! link entity.name.type.class Bold") -- Class names

    -- Set bold and italic for markdown headings
    vim.cmd("highlight! link entity.name.section.markdown BoldItalic") -- Markdown headings

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
                primary = "#333333",
                secondary = "#ffffff",
                noir_0 = "#f1f1f1",
                noir_1 = "#e2e2e2",
                noir_2 = "#b0b0b0", -- Ajustado para melhor visibilidade
                noir_3 = "#a7a7a7",
                noir_4 = "#666666",
                noir_5 = "#555555",
                noir_6 = "#444444",
                noir_7 = "#444444",
                noir_8 = "#333333",
                noir_9 = "#111111",
            },
        })

        -- Tokens colors
        vim.cmd("highlight @variable guifg=#e2e2e2") -- Ajuste para mais contraste
        vim.cmd("highlight @variable.builtin guifg=#e2e2e2")
        vim.cmd("highlight @variable.member guifg=#FF00FF") -- Neon Pink

        vim.cmd("highlight @constant guifg=#FF00FF") -- Neon Pink

        vim.cmd("highlight @keyword guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight @keyword.operator guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight @keyword.function guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight @keyword.return guifg='#FF00FF'") -- Neon Pink

        vim.cmd("highlight @punctuation.bracket guifg='#FF00FF'") -- Neon Pink

        vim.cmd("highlight @constructor guifg='#FF00FF'") -- Neon Pink

        vim.cmd("highlight @operator guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight @comment guifg='#FF00FF' gui=italic") -- Neon Pink
        vim.cmd("highlight @string guifg='#FF00FF'") -- Neon Pink

        vim.cmd("highlight @keyword.coroutine guifg='#FF00FF'") -- Neon Pink

        vim.cmd("highlight @function.builtin guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight @function.call guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight @function.method.call guifg='#FF00FF'") -- Neon Pink

        vim.cmd("highlight @tag guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight @tag.delimiter guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight @tag.attribute guifg='#FF00FF'") -- Neon Pink

        vim.cmd("highlight @lsp.type.parameter guifg='#FF00FF' gui=italic") -- Neon Pink

        vim.cmd("highlight @type guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight @type.qualifier guifg='#FF00FF'") -- Neon Pink

        -- Vim command line error colors
        vim.cmd("highlight ErrorMsg guifg='#FF00FF' guibg='#ff8989'") -- Neon Pink

        -- NvimTree colors
        vim.cmd("highlight NvimTreeFolderIcon guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight NvimTreeFolderName guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight NvimTreeFileIcon guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight NvimTreeFileName guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight NvimTreeIndentMarker guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight NvimTreeNormal guibg=NONE guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight NvimTreeVertSplit guibg=NONE guifg=NONE")

        vim.cmd("highlight NvimTreeCursorLine guibg='#171717' guifg=NONE gui=bold")

        vim.cmd("highlight NvimTreeGitDirty guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight NvimTreeGitNew guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight NvimTreeGitStaged guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight NvimTreeGitUnstaged guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight NvimTreeGitUntracked guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight NvimTreeGitRenamed guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight NvimTreeGitIgnored guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight NvimTreeGitMerge guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight NvimTreeGitModified guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight NvimTreeGitDeleted guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight NvimTreeWinSeparator guibg=NONE guifg='#101010'")

        -- Diagnostic colors
        vim.cmd("highlight DiagnosticError guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight DiagnosticWarn guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight DiagnosticInfo guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight DiagnosticHint guifg='#FF00FF'") -- Neon Pink

        -- Diagnostic signs colors
        vim.cmd("highlight DiagnosticSignError guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight DiagnosticSignWarn guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight DiagnosticSignInfo guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight DiagnosticSignHint guifg='#FF00FF'") -- Neon Pink

        -- Editor transparent colors
        vim.cmd("highlight Normal guibg=none")
        vim.cmd("highlight NonText guibg=none")
        vim.cmd("highlight Normal ctermbg=none")
        vim.cmd("highlight NonText ctermbg=none")

        vim.cmd("highlight clear LineNr")
        vim.cmd("highlight clear SignColumn")

        -- LSP colors
        vim.cmd("highlight FloatBorder guibg=NONE guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight FloatShadow guibg=NONE guifg=NONE")
        vim.cmd("highlight FloatShadowThrough guibg=NONE guifg=NONE")

        -- Visual mode colors
        vim.cmd("highlight Visual guibg='#181818' guifg=NONE")

        -- Numbers Gutter
        vim.cmd("highlight LineNr guifg='#FF00FF'") -- Neon Pink

        vim.cmd("highlight Cursor guibg=NONE")
        vim.cmd("highlight CursorLine guibg='#181818' guifg=NONE")
        vim.cmd("highlight CursorLineNr guibg=NONE guifg='#FF00FF' gui=bold") -- Neon Pink

        -- Split colors
        vim.cmd("highlight VertSplit guibg=NONE guifg='#101010'")
        vim.cmd("highlight WinSeparator guibg=NONE guifg='#101010'")

        -- Command line colors
        vim.cmd("highlight Pmenu guibg='#181818' guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight PmenuSel guibg='#222222' guifg='#ffffff'")
        vim.cmd("highlight PmenuSbar guibg='#181818' guifg='#0f0f0f'")
        vim.cmd("highlight PmenuThumb guibg='#222222' guifg='#0f0f0f'")

        -- Floating window colors
        vim.cmd("highlight NormalFloat guibg=NONE guifg='#FF00FF'") -- Neon Pink

        -- Fold colors
        vim.cmd("highlight Folded guibg=NONE guifg='#FF00FF'") -- Neon Pink

        -- Gitsigns colors
        vim.cmd("highlight GitSignsAdd guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight GitSignsChange guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight GitSignsDelete guifg='#FF00FF'") -- Neon Pink

        -- Telescope colors
        vim.cmd("highlight TelescopeBorder guibg=NONE guifg='#FF00FF'") -- Neon Pink

        -- Noice colors
        vim.cmd("highlight NoiceCmdlineIcon guibg=NONE guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight NoiceCmdlinePopup guibg=NONE guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight NoiceCmdlinePopupBorderInput guibg=NONE guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight NoiceCmdlinePopupBorder guibg=NONE guifg='#FF00FF'") -- Neon Pink

        -- Devicons colors
        vim.cmd("highlight DevIconDefault guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight DevIconUnknown guifg='#FF00FF'") -- Neon Pink

        -- Notify colors
        vim.cmd("highlight NotifyERRORBorder guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight NotifyINFOBorder guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight NotifyWARNBorder guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight NotifyDEBUGBorder guifg='#FF00FF'") -- Neon Pink

        -- Indent-Blankline colors
        vim.cmd("highlight IndentBlanklineChar guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight IndentBlanklineContextChar guifg='#FF00FF'") -- Neon Pink

        -- Which-key colors
        vim.cmd("highlight WhichKey guifg='#FF00FF'") -- Neon Pink
        vim.cmd("highlight WhichKeyDesc guifg='#FF00FF'") -- Neon Pink
    end,
}
,
}
