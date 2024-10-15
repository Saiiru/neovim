-- Função para aplicar o esquema de cores
function ColorMyPencils(color)
  color = color or "carbonfox"  -- Esquema de cores padrão
    vim.cmd("colorscheme " .. color)  -- Carregar o esquema de cores
    vim.cmd([[autocmd VimEnter * lua vim.cmd('colorscheme carbonfox')]])

    -- Ajustes de fundo transparente
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

    -- Personalizações de destaque
    vim.api.nvim_set_hl(0, "Comment", { italic = true })
    vim.api.nvim_set_hl(0, "Keyword", { italic = true, bold = true })
    vim.api.nvim_set_hl(0, "Function", { italic = true })
    vim.api.nvim_set_hl(0, "Variable", { italic = true })
    vim.api.nvim_set_hl(0, "String", { italic = true })
  end

-- Retornando a configuração dos plugins
return {
    {
        "erikbackman/brightburn.vim",
    },

    {
        "folke/tokyonight.nvim",
        lazy = false,
        opts = {},
        config = function()
            ColorMyPencils()  -- Chame a função aqui
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
                overrides = {},
                dim_inactive = false,
                transparent_mode = false,
            })
            ColorMyPencils()  -- Chame a função aqui
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
            ColorMyPencils("carbonfox")  -- Chame a função aqui
        end,
    },

    {
        "EdenEast/nightfox.nvim",
        priority = 1000,
        config = function()
            require("nightfox").setup({
                options = {
                    transparent = true,
                    styles = {
                        comments = "italic",
                        keywords = "bold",
                    },
                },
            })

            -- Definindo a paleta de cores neon
            local palette = {
                bg = "#1a1a2e",
                fg = "#ffffff",
                black = "#0f0f10",
                red = "#ff2e63",
                green = "#00ff99",
                yellow = "#ffcc00",
                blue = "#00bfff",
                magenta = "#ff5e99",
                cyan = "#00e0ff",
                white = "#f1f1f1",
                gray = "#b0b0b0",
            }

            -- Definindo os grupos de destaque
            vim.cmd("highlight Normal guibg=" .. palette.bg .. " guifg=" .. palette.fg)
            vim.cmd("highlight Comment guifg=" .. palette.gray .. " gui=italic")
            vim.cmd("highlight Keyword guifg=" .. palette.magenta .. " gui=bold")
            vim.cmd("highlight String guifg=" .. palette.green)
            vim.cmd("highlight Function guifg=" .. palette.blue)
            vim.cmd("highlight Variable guifg=" .. palette.white)

            -- Erros e avisos
            vim.cmd("highlight DiagnosticError guifg=" .. palette.red .. " gui=bold")
            vim.cmd("highlight DiagnosticWarn guifg=" .. palette.yellow .. " gui=bold")
            vim.cmd("highlight DiagnosticInfo guifg=" .. palette.blue .. " gui=bold")
            vim.cmd("highlight DiagnosticHint guifg=" .. palette.green .. " gui=bold")

            -- Sublinhados para erros e avisos
            vim.cmd("highlight DiagnosticUnderlineError guisp=" .. palette.red .. " gui=undercurl")
            vim.cmd("highlight DiagnosticUnderlineWarn guisp=" .. palette.yellow .. " gui=undercurl")
            vim.cmd("highlight DiagnosticUnderlineInfo guisp=" .. palette.blue .. " gui=undercurl")
            vim.cmd("highlight DiagnosticUnderlineHint guisp=" .. palette.green .. " gui=undercurl")

            -- Outros tipos de token
            vim.cmd("highlight Identifier guifg=" .. palette.cyan)
            vim.cmd("highlight Type guifg=" .. palette.magenta)
            vim.cmd("highlight Operator guifg=" .. palette.yellow)
            vim.cmd("highlight Statement guifg=" .. palette.red)
            vim.cmd("highlight PreProc guifg=" .. palette.green)
            vim.cmd("highlight Special guifg=" .. palette.blue)

            -- Outras configurações de destaque
            vim.cmd("highlight CursorLine guibg=#2a2a3e")
            vim.cmd("highlight LineNr guifg=#3b3b55")

            ColorMyPencils("carbonfox")  -- Chame a função aqui
        end,
    },
}


