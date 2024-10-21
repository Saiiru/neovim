-- Desabilitar o módulo obsoleto
vim.g.skip_ts_context_commentstring_module = true

-- Configurar o novo módulo
-- require('ts_context_commentstring').setup {}

-- Função de configuração do Treesitter
local function treesitter_setup()
    local status, ts = pcall(require, 'nvim-treesitter.configs')
    if not status then return end

    ts.setup {
        ensure_installed = {
            "lua", "markdown", "html", "css", "javascript", "typescript", "tsx",
            "prisma", "json", "svelte", "scss", "c", "python", "pug", "php",
            "java", "astro", "vue", "dockerfile", "graphql", "yaml", "toml",
            "cpp", "vim", "rust", "make"
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = { "markdown" },
            disable = function(lang, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    vim.api.nvim_out_write("Warning: File size exceeds 100KB. Disabling Treesitter highlighting.\n")
                    return true
                end
            end,
        },
        indent = { enable = true, disable = { 'python' } },
        rainbow = {
            enable = true,
            extended_mode = true,
        },
        autotag = {
            enable = true,
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                },
                selection_modes = {
                    ["@parameter.outer"] = "v",
                    ["@function.outer"] = "V",
                    ["@class.outer"] = "<c-v>",
                },
                include_surrounding_whitespace = true,
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>a"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<leader>A"] = "@parameter.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]]"] = "@class.outer",
                },
                goto_next_end = {
                    ["]M"] = "@function.outer",
                    ["]["] = "@class.outer",
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["["] = "@class.outer",
                },
                goto_previous_end = {
                    ["[M"] = "@function.outer",
                    ["[]"] = "@class.outer",
                },
            },
        },
    }

    local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
    parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
end

return {
    {
        'nvim-treesitter/nvim-treesitter',
        event = { 'BufNewFile', 'BufRead' },
        build = { ':TSInstall! vim', ':TSUpdate' },
        config = treesitter_setup,
    },
    {
    'JoosepAlviste/nvim-ts-context-commentstring',
    lazy = true, -- Carregar somente quando necessário
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require('ts_context_commentstring').setup {}
    end
},

    {
        'yioneko/nvim-yati',
        event = { 'BufNewFile', 'BufRead' },
        dependencies = 'nvim-treesitter/nvim-treesitter',
        config = function()
            local status, yati = pcall(require, 'yati')
            if not status then return end

            yati.setup {
                enable = true,
                default = {
                    enable = true,
                    disable = { 'yaml', 'json' },
                },
                rules = {
                    lua = { indent = 2 },
                    javascript = { indent = 2 },
                    typescript = { indent = 2 },
                    python = { indent = 4 },
                },
            }
        end,
    },
    { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
}

