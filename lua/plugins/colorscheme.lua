function ColorMyPencils(color)
	color = color or "tokyonight"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {

    {
        "erikbackman/brightburn.vim",
    },
{
    "tiagovla/tokyodark.nvim",
    opts = {
        transparent_background = true, -- fundo transparente
        gamma = 1.00,  -- ajuste de brilho
        styles = {
            comments = { italic = true }, -- comentários em itálico
            keywords = { italic = true, bold = true }, -- keywords em itálico e vibrantes
            identifiers = { italic = true }, -- identificadores em itálico
            functions = { bold = true },  -- funções em negrito
            variables = {}, -- variáveis sem estilo específico
        },
        terminal_colors = true, -- habilitar cores no terminal
        custom_palette = function(palette)
            -- Customizando a paleta de cores neon vibrante
            palette.magenta = "#FF00FF"  -- Hot Pink neon
            palette.blue = "#00FFFF"     -- Cyan neon
            palette.purple = "#FF00FF"   -- Magenta neon
            palette.orange = "#FFA500"   -- Laranja neon para strings
            palette.green = "#00FF00"    -- Verde neon
            palette.yellow = "#FFFF00"   -- Amarelo neon
            palette.red = "#FF4500"      -- Vermelho neon
            palette.bg = "#000000"       -- Fundo preto transparente

            return palette
        end,
        custom_highlights = function(highlights, palette)
            -- Personalizando os highlights com estilo synthwave neon
            highlights.Function = { fg = palette.magenta, bold = true }   -- Funções neon Hot Pink
            highlights.Keyword = { fg = palette.blue, italic = true, bold = true } -- Keywords neon cyan
            highlights.Type = { fg = palette.purple }                     -- Tipos neon magenta
            highlights.Variable = { fg = palette.yellow }                 -- Variáveis neon amarelo
            highlights.Identifier = { fg = palette.green, italic = true } -- Identificadores verde neon

            -- Arco-íris neon para aspas e caracteres especiais
            highlights.String = { fg = palette.orange, bold = true }      -- Strings neon laranja
            highlights.Character = { fg = palette.red, bold = true }      -- Caracteres especiais neon vermelho

            -- **Ajustes no Neo-tree para legibilidade**
            highlights.NeoTreeNormal = { bg = "NONE", fg = "#A9A9A9" }    -- Cinza claro legível para o conteúdo do Neo-tree
            highlights.NeoTreeNormalNC = { bg = "NONE", fg = "#A9A9A9" }  -- Mesmo cinza para modo NC (não focado)
            highlights.NeoTreeDirectoryName = { fg = palette.blue }       -- Nomes de diretórios em azul vibrante
            highlights.NeoTreeDirectoryIcon = { fg = palette.yellow }     -- Ícones de diretórios em amarelo neon
            highlights.NeoTreeIndentMarker = { fg = "#5c6370" }           -- Marcadores de indentação em cinza neutro
            highlights.NeoTreeGitAdded = { fg = palette.green }           -- Git adicionado em verde neon
            highlights.NeoTreeGitModified = { fg = palette.orange }       -- Git modificado em laranja neon
            highlights.NeoTreeGitDeleted = { fg = palette.red }           -- Git deletado em vermelho neon

            -- Transparência nas janelas flutuantes
            highlights.Normal = { bg = "NONE" }
            highlights.NormalFloat = { bg = "NONE" }

            -- Comentários em itálico e cinza
            highlights.Comment = { fg = "#5c6370", italic = true }

            -- Estilo arco-íris neon
            highlights.TSString = { fg = palette.orange, italic = true }
            highlights.TSKeyword = { fg = palette.blue, bold = true }
            highlights.TSFunction = { fg = palette.magenta, bold = true }
            highlights.TSType = { fg = palette.purple }

            return highlights
        end,
    },
    config = function(_, opts)
        require("tokyodark").setup(opts) -- setup opcional
        ColorMyPencils("tokyodark")
        vim.cmd([[colorscheme tokyodark]]) -- aplica o esquema de cores
    end,
},

    {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
        require("tokyonight").setup({
            style = "storm",  -- Escolha o estilo: "night", "storm", ou "day"
            transparent = true,  -- Fundo transparente
            terminal_colors = true,  -- Cores do terminal personalizadas
            styles = {
                comments = { italic = true },  -- Comentários em itálico
                keywords = { bold = true },  -- Palavras-chave em negrito
                functions = { italic = true, bold = true },  -- Funções em itálico e negrito
                variables = {},  -- Variáveis sem estilo adicional
                sidebars = "transparent",  -- Transparência nas sidebars (como NvimTree)
                floats = "transparent",    -- Transparência em janelas flutuantes
            },
            on_colors = function(colors)
                -- Personalizando as cores
                colors.magenta = "#FF00FF"  -- Hot Pink vibrante
                colors.blue = "#61afef"     -- Azul vibrante para contraste
                colors.bg_highlight = "#1a1b26"  -- Destaque para áreas selecionadas
                colors.bg = "#000000"  -- Fundo transparente

                -- Ajustes adicionais de cor
                colors.bg_float = "NONE"
                colors.bg_sidebar = "NONE"
            end,
            on_highlights = function(hl, c)
                -- Personalizando destaques (highlights)
                hl.Function = { fg = c.magenta, bold = true }  -- Funções em Hot Pink
                hl.Keyword = { fg = c.blue, bold = true }      -- Keywords em azul
                hl.Type = { fg = c.magenta }                   -- Tipos em Hot Pink
                hl.Variable = { fg = c.blue }                  -- Variáveis em azul

                -- Customizações do Telescope
                hl.TelescopeBorder = { fg = c.blue }
                hl.TelescopePromptBorder = { fg = c.blue }
                hl.TelescopeResultsBorder = { fg = c.blue }
                hl.TelescopePreviewBorder = { fg = c.blue }

                -- Fundo transparente
                hl.Normal = { bg = "NONE" }
                hl.NormalFloat = { bg = "NONE" }

                -- Numeração de linhas e linha do cursor
                hl.LineNr = { fg = "#5c6370" }
                hl.CursorLineNr = { fg = c.blue, bold = true }

                -- Comentários em itálico e cinza escuro
                hl.Comment = { fg = "#5c6370", italic = true }
            end,
        })

        -- Aplicando o esquema de cores Tokyonight
        -- vim.cmd([[colorscheme tokyonight]])
        ColorMyPencils("tokyonight")
    end,
},
    {
        "ellisonleao/gruvbox.nvim",
        name = "gruvbox",
        config = function()
            require("gruvbox").setup({
                terminal_colors = true, -- add neovim terminal colors
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
                inverse = true, -- invert background for search, diffs, statuslines and errors
                contrast = "", -- can be "hard", "soft" or empty string
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
                -- your configuration comes here
                -- or leave it empty to use the default settings
                style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
                transparent = true, -- Enable this to disable setting the background color
                terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
                styles = {
                    -- Style to be applied to different syntax groups
                    -- Value is any valid attr-list value for `:help nvim_set_hl`
                    comments = { italic = false },
                    keywords = { italic = false },
                    -- Background styles. Can be "dark", "transparent" or "normal"
                    sidebars = "dark", -- style for sidebars, see below
                    floats = "dark", -- style for floating windows
                },
            })
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
        end
    },
{
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
        require('rose-pine').setup({
            flavour = "macchiato", -- Escolha o sabor desejado: latte, frappe, macchiato, mocha
            background = {
                light = "latte",
                dark = "mocha",
            },
            transparent_background = false, -- Desativa a cor de fundo
            show_end_of_buffer = false, -- Não mostra os '~' após o final dos buffers
            term_colors = false, -- Define as cores do terminal
            dim_inactive = {
                enabled = false, -- Não atenua a cor de fundo da janela inativa
                shade = "dark",
                percentage = 0.15, -- Porcentagem de sombra a ser aplicada à janela inativa
            },
            no_italic = false, -- Não forçar itálico
            no_bold = false, -- Não forçar negrito
            no_underline = false, -- Não forçar sublinhado
            styles = {
                comments = { "italic" }, -- Estilo de comentários
                conditionals = { "italic" },
                loops = {},
                functions = {"bold"},
                keywords = {"bold"},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {},
            },
            color_overrides = {
                all = {
                    text = "#c6d0f5", -- Texto geral
                },
                mocha = { -- Cores específicas para o sabor mocha
                    base = "#181825", -- Fundo
                    mantle = "#242424", -- Camada
                    crust = "#11111b", -- Crosta
                },
            },
            custom_highlights = function(colors)
                return {
                    Comment = { fg = colors.flamingo, style = { "italic" } }, -- Comentários em flamingo
                    Function = { fg = colors.pink, style = { "italic" } }, -- Funções em hot pink
                    Keyword = { fg = colors.mauve, style = { "bold" } }, -- Palavras-chave em mauve
                    String = { fg = colors.rosewater }, -- Strings em rosewater
                    Variable = { fg = colors.text, style = { "italic" } }, -- Variáveis em texto
                    Type = { fg = colors.red, style = { "bold" } }, -- Tipos em vermelho
                    DiagnosticError = { fg = colors.red }, -- Erros de diagnóstico em vermelho
                    DiagnosticWarn = { fg = colors.flamingo }, -- Avisos de diagnóstico em flamingo
                    DiagnosticInfo = { fg = colors.blue }, -- Informações de diagnóstico em azul
                    DiagnosticHint = { fg = colors.teal }, -- Dicas de diagnóstico em verde-azulado
                }
            end,
            default_integrations = true, -- Integrações padrão ativadas
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                treesitter = true,
                notify = false,
                mini = {
                    enabled = true,
                    indentscope_color = "",
                },
            },
        })

        -- Define a função ColorMyPencils para usar o tema
        -- ColorMyPencils("rose-pine")  
    end
}
}
