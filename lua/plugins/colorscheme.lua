local function colorMyPencils()
    -- Set color for comments
    vim.cmd("highlight Comment guifg='#FF69B4'") -- Hot Pink

    -- Set color for booleans
    vim.cmd("highlight Boolean guifg='#FF69B4'") -- Hot Pink

    -- Set color for numbers
    vim.cmd("highlight Number guifg='#FF69B4'") -- Hot Pink

    -- Set color for strings
    vim.cmd("highlight String guifg='#FF69B4'") -- Hot Pink

    -- Set colors for keywords
    vim.cmd("highlight Keyword guifg='#FF69B4'") -- Hot Pink

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
			preset = "oxide",
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
		vim.cmd("highlight @variable.member guifg=#b0b0b0") -- Ajuste para mais visibilidade

		vim.cmd("highlight @constant guifg=#b0b0b0") -- Melhor visibilidade para constantes

		vim.cmd("highlight @keyword guifg=#666666")
		vim.cmd("highlight @keyword.operator guifg=#777777") -- Ajuste para mais contraste
		vim.cmd("highlight @keyword.function guifg=#b0b0b0") -- Ajuste para mais visibilidade
		vim.cmd("highlight @keyword.return guifg=#b0b0b0")

		vim.cmd("highlight @punctuation.bracket guifg=#666666")

		vim.cmd("highlight @constructor guifg=#888888")

		vim.cmd("highlight @operator guifg=#666666")
		vim.cmd("highlight @comment guifg=#999999") -- Ajuste para comentários mais visíveis
		vim.cmd("highlight @string guifg=#444444")

		vim.cmd("highlight @keyword.coroutine guifg=#666666")

		vim.cmd("highlight @function.builtin guifg=#b0b0b0") -- Ajuste para melhor visibilidade
		vim.cmd("highlight @function.call guifg=#b0b0b0")
		vim.cmd("highlight @function.method.call guifg=#b0b0b0")

		vim.cmd("highlight @tag guifg=#888888")
		vim.cmd("highlight @tag.delimiter guifg=#888888")
		vim.cmd("highlight @tag.attribute guifg=#666666")

		vim.cmd("highlight @lsp.type.parameter guifg=#999999 gui=italic")

		vim.cmd("highlight @type guifg=#e2e2e2")
		vim.cmd("highlight @type.qualifier guifg=#666666")

		-- Vim command line error colors
		vim.cmd("highlight ErrorMsg guifg=#444444 guibg=#ff8989")

		-- NvimTree colors
		vim.cmd("highlight NvimTreeFolderIcon guifg=#666666") -- Ajuste para melhor contraste
		vim.cmd("highlight NvimTreeFolderName guifg=#b0b0b0")
		vim.cmd("highlight NvimTreeFileIcon guifg=#444444")
		vim.cmd("highlight NvimTreeFileName guifg=#444444")
		vim.cmd("highlight NvimTreeIndentMarker guifg=#999999") -- Melhor visibilidade
		vim.cmd("highlight NvimTreeNormal guibg=NONE guifg=#666666")
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
		vim.cmd("highlight FloatBorder guibg=NONE guifg=#222222")
		vim.cmd("highlight FloatShadow guibg=NONE guifg=NONE")
		vim.cmd("highlight FloatShadowThrough guibg=NONE guifg=NONE")

		-- Visual mode colors
		vim.cmd("highlight Visual guibg=#181818 guifg=NONE")

		-- Numbers Gutter
		vim.cmd("highlight LineNr guifg=#2b2b2b")

		vim.cmd("highlight Cursor guibg=NONE")
		vim.cmd("highlight CursorLine guibg=#181818 guifg=NONE")
		vim.cmd("highlight CursorLineNr guibg=NONE guifg=#666666 gui=bold")

		-- Split colors
		vim.cmd("highlight VertSplit guibg=NONE guifg=#101010")
		vim.cmd("highlight WinSeparator guibg=NONE guifg=#101010")

		-- Command line colors
		vim.cmd("highlight Pmenu guibg=#181818 guifg=#666666")
		vim.cmd("highlight PmenuSel guibg=#222222 guifg=#ffffff")
		vim.cmd("highlight PmenuSbar guibg=#181818 guifg=#0f0f0f")
		vim.cmd("highlight PmenuThumb guibg=#222222 guifg=#0f0f0f")

		-- Floating window colors
		vim.cmd("highlight NormalFloat guibg=NONE guifg=#f1f1f1")

		-- Fold colors
		vim.cmd("highlight Folded guibg=NONE guifg=#3b3b3b")

		-- Gitsigns colors
		vim.cmd("highlight GitSignsAdd guifg=#9bcea5")
		vim.cmd("highlight GitSignsChange guifg=#f0c674")
		vim.cmd("highlight GitSignsDelete guifg=#ff8989")

		-- Telescope colors
		vim.cmd("highlight TelescopeBorder guibg=NONE guifg=#333333")

		-- Noice colors
		vim.cmd("highlight NoiceCmdlineIcon guibg=NONE guifg=#ffffff")
		vim.cmd("highlight NoiceCmdlinePopup guibg=NONE guifg=#666666")
		vim.cmd("highlight NoiceCmdlinePopupBorderInput guibg=NONE guifg=#444444")
		vim.cmd("highlight NoiceCmdlinePopupBorder guibg=NONE guifg=#222222")

		-- Devicons colors
		vim.cmd("highlight DevIconDefault guifg=#999999")
		vim.cmd("highlight DevIconUnknown guifg=#999999")

		-- Notify colors
		vim.cmd("highlight NotifyERRORBorder guifg=#ff8989")
		vim.cmd("highlight NotifyINFOBorder guifg=#89B4FA")
		vim.cmd("highlight NotifyWARNBorder guifg=#f0c674")
		vim.cmd("highlight NotifyDEBUGBorder guifg=#888888")

		-- Indent-Blankline colors
		vim.cmd("highlight IndentBlanklineChar guifg=#666666")
		vim.cmd("highlight IndentBlanklineContextChar guifg=#444444")

		-- Which-key colors
		vim.cmd("highlight WhichKey guifg=#666666")
		vim.cmd("highlight WhichKeyDesc guifg=#666666")
	end,
}
,
}

