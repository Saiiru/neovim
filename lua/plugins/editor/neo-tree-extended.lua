return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    close_if_last_window = true,
    window = {
      mappings = {
        ["e"] = "open",
        ["E"] = function()
          vim.cmd("Neotree focus filesystem left")
        end,
        ["b"] = function()
          vim.cmd("Neotree focus buffers left")
        end,
        ["g"] = function()
          vim.cmd("Neotree focus git_status left")
        end,
        ["<c-/>"] = "fuzzy_finder_directory",
        ["D"] = function(state)
          local neo_tree_utils = require("neo-tree.utils")
          local log = require("neo-tree.log")

          -- Função auxiliar para alternar o estado de diff entre dois arquivos
          local function toggle_diff(node, state)
            if not node then
              return
            end

            local current_node_id = tostring(node.id)

            -- Se já existe um arquivo para diff, realiza o diff e limpa o estado
            if state.clipboard.diff_node and state.clipboard.diff_node ~= current_node_id then
              local previous_diff_node = state.clipboard.diff_node
              neo_tree_utils.open_file(state, previous_diff_node, "open")
              vim.cmd("vert diffs " .. current_node_id)
              log.info("Diffing " .. state.clipboard.diff_name .. " against " .. node.name)

              -- Limpa estado de diff
              state.clipboard = {}
              require("neo-tree.ui.renderer").redraw(state)
            else
              -- Configura o node atual como fonte de diff
              state.clipboard = {
                diff_node = current_node_id,
                diff_name = node.name,
                action = "diff",
              }
              log.info("Diff source file " .. node.name)
              require("neo-tree.ui.renderer").redraw(state)
            end
          end

          -- Executa a função de diff, passando o nó atual
          local node = state.tree:get_node()
          toggle_diff(node, state)
        end,
      },
    },
    filesystem = {
      hijack_netrw_behavior = "open_default",
    },
  },
}
