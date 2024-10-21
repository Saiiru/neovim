local function setup()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
        defaults = {
            path_display = { "smart" },
            mappings = {
                i = {
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-j>"] = actions.move_selection_next,
                    ["<esc>"] = actions.close,
                    ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
                    ["<S-tab>"] = actions.toggle_selection + actions.move_selection_previous,
                },
                n = {
                    ["<esc>"] = actions.close,
                    ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
                    ["<S-tab>"] = actions.toggle_selection + actions.move_selection_previous,
                },
            },
            file_ignore_patterns = { "node_modules", "%.git/", "*.png", "*.jpg" },
            prompt_prefix = " ",
            sorting_strategy = "ascending",
            selection_caret = "  ",
            layout_strategy = "horizontal",
            layout_config = {
                horizontal = {
                    prompt_position = "top",
                    preview_width = 0.5,  -- Ajuste a largura do preview para telas menores
                    results_width = 0.75,  -- Largura dos resultados
                },
                vertical = {
                    mirror = false,
                },
                width = 0.85,  -- Ajuste a largura total do Telescope
                height = 0.85, -- Ajuste a altura total do Telescope
                preview_cutoff = 80, -- Reduz o ponto de corte para o preview
            },
            border = {},
            set_env = { ["COLORTERM"] = "truecolor" },
        },
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            },
            file_browser = {
                theme = "dropdown",
                hijack_netrw = true,
            },
            live_grep_args = {
                auto_quoting = false,
            },
            media_files = {
                filetypes = { "png", "jpg", "jpeg", "mp4", "webm", "pdf" },
                find_cmd = "rg",
            },
        },
        pickers = {
            git_files = {
                show_untracked = true,
            },
            live_grep = {
                additional_args = function(opts)
                    return { "--hidden" }
                end,
            },
            find_files = {
                hidden = true,
            },
        },
    })

    -- Carregando extensões
    telescope.load_extension("fzf")
    telescope.load_extension("luasnip")
    telescope.load_extension("file_browser")
    telescope.load_extension("live_grep_args")
    telescope.load_extension("media_files")
end

return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        { "benfowler/telescope-luasnip.nvim", module = "telescope._extensions.luasnip" },
        { "nvim-telescope/telescope-file-browser.nvim" },
        { "nvim-telescope/telescope-live-grep-args.nvim" },
        { "nvim-telescope/telescope-media-files.nvim" },
        "nvim-tree/nvim-web-devicons",
    },
    config = setup,
    keys = {
        { "<C-g><C-e>", "<cmd>Telescope git_files<CR>", desc = "Fuzzy find git files" },
        { "<C-g><C-s>", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
        { "<C-g><C-b>", "<cmd>Telescope buffers<CR>", desc = "List buffers" },
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Fuzzy find files in cwd" },
        { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Fuzzy find recent files" },
        { "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Find string in cwd" },
        { "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "Find string under cursor in cwd" },
        { "<leader>fb", "<cmd>Telescope file_browser<cr>", desc = "Open file browser" },
        { "<leader>fma", "<cmd>Telescope media_files<cr>", desc = "Browse media files" },
    },
    cmd = "Telescope",
}

