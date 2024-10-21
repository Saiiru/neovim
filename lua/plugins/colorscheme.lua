-- Define the ColorMyPencils function
local function ColorMyPencils(color)
    color = color or "sakura"
    vim.cmd.colorscheme(color)

    -- Set transparent backgrounds for certain highlights
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2c2c2c", bold = true })  -- Highlight for cursor line for visibility
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#39FF14", bold = true })  -- Bright green for cursor line number
end

return {
    {
        "erikbackman/brightburn.vim",
    },

    {
        "folke/tokyonight.nvim",
        lazy = false,
        opts = {},
        config = function()
            ColorMyPencils()  -- Set specific color scheme if desired
        end
    },

    {
        "ellisonleao/gruvbox.nvim",
        name = "gruvbox",
        config = function()
            require("gruvbox").setup({
                terminal_colors = true, -- Add Neovim terminal colors
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
                inverse = true, -- Invert background for search, diffs, statuslines, and errors
                contrast = "", -- Can be "hard", "soft", or empty string
                palette_overrides = {},
                overrides = {},
                dim_inactive = false,
                transparent_mode = false,
            })
            ColorMyPencils()  -- Use ColorMyPencils function here as well
        end,
    },

    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                style = "storm", -- The theme comes in three styles
                transparent = true, -- Enable this to disable setting the background color
                terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
                styles = {
                    comments = { italic = false },
                    keywords = { italic = false },
                    sidebars = "dark", -- Style for sidebars
                    floats = "dark",   -- Style for floating windows
                },
            })
            ColorMyPencils()  -- Ensure ColorMyPencils is called
        end
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
            ColorMyPencils()  -- Use ColorMyPencils for this theme as well
        end
    },

    {
        "anAcc22/sakura.nvim",
        name = "sakura",
        dependencies = { "rktjmp/lush.nvim", "nvim-web-devicons" },
        priority = 1000, -- load asap
        config = function()
            vim.cmd.colorscheme("sakura")

            -- Define a vibrant neon color palette
            local colors = {
                vibrant_pink = "#FF39B1",     -- Hot pink for a vibrant touch
                bright_green = "#39FF14",      -- Neon green for emphasis
                bright_blue = "#00BFFF",       -- Vivid blue for a modern touch
                dark_gray = "#222222",         -- Darker gray for depth
                faded_gray = "#4B4B4B",        -- Softened gray for softer contrast
                almost_black = "#121212",      -- Near-black for backgrounds
                white = "#FFFFFF",             -- Pure white
                neon_orange = "#FF6A00",      -- Neon orange for extra flair
                neon_yellow = "#FFFF00",       -- Neon yellow for highlights
            }

            local highlights = {
                -- General UI
                Normal = { bg = colors.almost_black, fg = colors.white },
                NormalFloat = { bg = colors.almost_black, fg = colors.white },
                Visual = { bg = colors.dark_gray, fg = colors.bright_green },
                ModeMsg = { fg = colors.bright_green, bold = true },
                CursorLineNr = { fg = colors.vibrant_pink, bold = true },
                CursorLine = { bg = colors.dark_gray },
                MatchParen = { bg = colors.faded_gray, fg = colors.bright_blue },

                -- Git signs
                GitSignsAdd = { fg = colors.bright_green },
                GitSignsChange = { fg = colors.bright_blue },
                GitSignsDelete = { fg = colors.vibrant_pink },

                -- BufferLine
                BufferLineFill = { bg = colors.almost_black },
                BufferLineBackground = { bg = colors.almost_black, fg = colors.faded_gray },
                BufferLineSeparator = { bg = colors.almost_black, fg = colors.dark_gray },
                BufferLineModified = { fg = colors.bright_green },
                BufferLineIndicatorVisible = { fg = colors.bright_green },

                -- Keymaps highlights for vibrant contrast
                ["@constant"] = { fg = colors.bright_green }, -- Constants
                ["@variable"] = { fg = colors.bright_blue },  -- Variables
                ["@function"] = { fg = colors.vibrant_pink },  -- Functions
                ["@keyword"] = { fg = colors.neon_orange, bold = true }, -- Keywords
                ["@conditional"] = { fg = colors.neon_yellow, bold = true }, -- Conditionals
                ["@repeat"] = { fg = colors.neon_yellow, bold = true }, -- Repeat
                ["@operator"] = { fg = colors.neon_orange, bold = true }, -- Operators
            }

            -- Set highlight colors
            for group, opts in pairs(highlights) do
                vim.api.nvim_set_hl(0, group, opts)
            end
            
            ColorMyPencils("sakura")  -- Set specific color scheme
        end,
    },
}
