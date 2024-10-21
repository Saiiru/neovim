return {
    "nvim-tree/nvim-web-devicons",
    config = function()
        local devicons = require("nvim-web-devicons")

        -- Define a table for custom icons and their settings
        local custom_icons = {
            folder_closed = {
                icon = "",
                color = "#ff69b4",  -- Hex code for pink
                cterm_color = "205",
                name = "Folder",
            },
            folder_open = {
                icon = "",
                color = "#ff69b4",
                cterm_color = "205",
                name = "FolderOpen",
            },
            -- Additional file types with icons
            python = {
                icon = "🐍",
                color = "#3572A5",
                cterm_color = "67",
                name = "Python",
            },
            javascript = {
                icon = "📜",
                color = "#F7DF1E",
                cterm_color = "220",
                name = "JavaScript",
            },
            typescript = {
                icon = "📄",
                color = "#007ACC",
                cterm_color = "24",
                name = "TypeScript",
            },
            go = {
                icon = "🐹",
                color = "#00ADD8",
                cterm_color = "38",
                name = "Go",
            },
            html = {
                icon = "🌐",
                color = "#E44D26",
                cterm_color = "202",
                name = "HTML",
            },
            markdown = {
                icon = "📄",
                color = "#000000",
                cterm_color = "0",
                name = "Markdown",
            },
            -- Add other file types as needed
        }

        -- Setup the icons with overrides
        devicons.setup({
            -- color_icons = false, -- Uncomment if you want to use monochrome icons
            override = custom_icons,
            default = true,  -- Enables default icons for unsupported file types
        })
    end,
    priority = 1000,
}

