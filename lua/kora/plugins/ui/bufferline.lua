 -- ═════════════════════════════════════════════════════════════════════════
  --  BUFFER LINE - TAB ENHANCEMENT PROTOCOL
  -- ═════════════════════════════════════════════════════════════════════════
 --
-- BUFFERLINE (ABAS DE ARQUIVOS):
-- <S-h>/<S-l>                  -- Navegar entre buffers
-- <leader>bp                   -- Pin/fixar buffer atual
-- <leader>bo                   -- Fechar outros buffers
-- <leader>br                   -- Fechar buffers à direita
-- <leader>bl                   -- Fechar buffers à esquerda
-- BUFFER MANAGEMENT:
-- <leader>bd                   -- Deletar buffer (com confirmação)
-- <leader>bD                   -- Deletar buffer (forçado)
--
-- SESSION MANAGEMENT:
-- <leader>qs                   -- Restaurar sessão
-- <leader>ql                   -- Restaurar última sessão
-- <leader>qd                   -- Não salvar sessão atual
--
-- TODO COMMENTS:
-- ]t/[t                        -- Próximo/anterior TODO
-- <leader>xt                   -- Todos os TODOs (Trouble)
-- <leader>xT                   -- Apenas TODO/FIX/FIXME
-- <leader>st                   -- TODOs (Telescope)
--
-- PALAVRAS-CHAVE RECONHECIDAS:
-- TODO: fazer algo            -- Azul (informação)
-- FIXME: corrigir bug         -- Vermelho (erro)
-- HACK: solução temporária    -- Amarelo (aviso)
-- NOTE: observação            -- Verde (dica)
-- PERF: otimização            -- Roxo (performance)
-- TEST: teste necessário      -- Rosa (teste)
--
-- COMANDOS ÚTEIS:
-- :checkhealth treesitter     -- Verificar parsers instalados
-- :TSInstallInfo              -- Info sobre instalação
-- :Gitsigns toggle_signs      -- Toggle sinais git
-- :DapInstall                 -- Instalar adapters de debug
 return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = " Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = " Delete Non-Pinned" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = " Delete Others" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = " Delete Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = " Delete Left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    },
    opts = {
      options = {
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        indicator = { icon = "▎", style = "icon" },
        buffer_close_icon = "",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 30,
        tab_size = 21,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icons = {
            error = " ",
            warning = " ",
            info = " ",
            hint = " ",
          }
          local ret = (diagnostics_dict.error and icons.error .. diagnostics_dict.error .. " " or "")
            .. (diagnostics_dict.warning and icons.warning .. diagnostics_dict.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "NvimTree",
            text = " Neural Explorer", 
            text_align = "center",
            separator = true,
          },
        },
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        separator_style = "slant",
        always_show_bufferline = true,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
        sort_by = "insert_after_current",
      },
    },
  }
