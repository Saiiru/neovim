Vim�UnDo� ^0���ۍ䀀���.OL`q��4#sH�   �                 .       .   .   .    gDml   $ _�                             ����                                                                                                                                                                                                                                                                                                                                                             gD+;    �                   �               5��                    .   :                   �      5�_�                            ����                                                                                                                                                                                                                                                                                                                                       /   :       v���    gDk�    �   N              jvim.keymap.set("n", "<leader>E", "<cmd>lua require'dap'.set_exception_breakpoints()<CR>", { desc = "Toggle�   O            �                   �               �               /   local keymap = vim.keymap.set   .local opts = { noremap = true, silent = true }        keymap("n", "<Space>", "", opts)   vim.g.mapleader = " "   vim.g.maplocalleader = " "       #keymap("n", "<C-i>", "<C-i>", opts)       -- Better window navigation   $keymap("n", "<m-h>", "<C-w>h", opts)   $keymap("n", "<m-j>", "<C-w>j", opts)   $keymap("n", "<m-k>", "<C-w>k", opts)   $keymap("n", "<m-l>", "<C-w>l", opts)   %keymap("n", "<m-tab>", "<c-6>", opts)       keymap("n", "n", "nzz", opts)   keymap("n", "N", "Nzz", opts)   keymap("n", "*", "*zz", opts)   keymap("n", "#", "#zz", opts)   keymap("n", "g*", "g*zz", opts)   keymap("n", "g#", "g#zz", opts)       -- Stay in indent mode   keymap("v", "<", "<gv", opts)   keymap("v", ">", ">gv", opts)       keymap("x", "p", [["_dP]])       Zvim.cmd [[:amenu 10.100 mousemenu.Goto\ Definition <cmd>lua vim.lsp.buf.definition()<CR>]]   Tvim.cmd [[:amenu 10.110 mousemenu.References <cmd>lua vim.lsp.buf.references()<CR>]]   .-- vim.cmd [[:amenu 10.120 mousemenu.-sep- *]]       @vim.keymap.set("n", "<RightMouse>", "<cmd>:popup mousemenu<CR>")   9vim.keymap.set("n", "<Tab>", "<cmd>:popup mousemenu<CR>")       -- more good   -keymap({ "n", "o", "x" }, "<s-h>", "^", opts)   .keymap({ "n", "o", "x" }, "<s-l>", "g_", opts)       !-- tailwind bearable to work with   %keymap({ "n", "x" }, "j", "gj", opts)   %keymap({ "n", "x" }, "k", "gk", opts)   Hkeymap("n", "<leader>w", ":lua vim.wo.wrap = not vim.wo.wrap<CR>", opts)           :vim.api.nvim_set_keymap('t', '<C-;>', '<C-\\><C-n>', opts)5��            .   :                   �              �                    N   j                   �      �    N   j           5   +   �              �      5�_�                            ����                                                                                                                                                                                                                                                                                                                                          :       v���    gDk�    �      !   �      -- Delete text to " register5��                         L                     5�_�                           ����                                                                                                                                                                                                                                                                                                                                       �           V        gDm     �         �       �         �    5��                                               �                                               5�_�                            ����                                                                                                                                                                                                                                                                                                                                       �           V        gDm     �         �       �         �    5��                      %                 �       5�_�                       %    ����                                                                                                                                                                                                                                                                                                                                       �           V        gDm     �         �      %keymap("n", "<m-tab>", "<c-6>", opts)5��       %                  �                     5�_�                           ����                                                                                                                                                                                                                                                                                                                                       �           V        gDm     �         �      o5��                          �                     5�_�         
                  ����                                                                                                                                                                                                                                                                                                                                                        gDm     �         �      $keymap("n", "<m-h>", "<C-w>h", opts)   $keymap("n", "<m-j>", "<C-w>j", opts)   $keymap("n", "<m-k>", "<C-w>k", opts)   $keymap("n", "<m-l>", "<C-w>l", opts)   %keymap("n", "<m-tab>", "<c-6>", opts)5��                                               �                          >                     �                          ]                     �                          |                     �                          �                     5�_�                            ����                                                                                                                                                                                                                                                                                                                                                        gDm2    �         �      ("n", "<m-h>", "<C-w>h", opts)5��                                               5�_�                            ����                                                                                                                                                                                                                                                                                                                                                        gDmI    �         �      ("n", "<m-j>", "<C-w>j", opts)5��                          L                     5�_�                            ����                                                                                                                                                                                                                                                                                                                                                        gDmI    �         �      ("n", "<m-k>", "<C-w>k", opts)5��                          y                     5�_�                            ����                                                                                                                                                                                                                                                                                                                                                        gDmI   	 �         �      ("n", "<m-l>", "<C-w>l", opts)5��                          �                     5�_�      &                      ����                                                                                                                                                                                                                                                                                                                                                        gDmI     �         �      ("n", "<m-tab>", "<c-6>", opts)5��                          �                     5�_�      '          &           ����                                                                                                                                                                                                                                                                                                                                                  v        gDmZ     �         �       �         �    5��                                        �       5�_�   &   (           '          ����                                                                                                                                                                                                                                                                                                                                                       gDm_     �         �      ,vim.keymap.set("n", "<m-h>", "<C-w>h", opts)   ,vim.keymap.set("n", "<m-j>", "<C-w>j", opts)   ,vim.keymap.set("n", "<m-k>", "<C-w>k", opts)   ,vim.keymap.set("n", "<m-l>", "<C-w>l", opts)   -vim.keymap.set("n", "<m-tab>", "<c-6>", opts)5��                                              �                         C                     �                         o                     �                         �                     �                         �                     5�_�   '   )           (          ����                                                                                                                                                                                                                                                                                                                                                       gDm`     �         �      +vim.keymap.set("n", "<-h>", "<C-w>h", opts)5��                                              5�_�   (   *           )          ����                                                                                                                                                                                                                                                                                                                                                       gDmb     �         �      +vim.keymap.set("n", "<-j>", "<C-w>j", opts)5��                         D                     �                        D                    5�_�   )   +           *          ����                                                                                                                                                                                                                                                                                                                                                       gDmd     �         �      +vim.keymap.set("n", "<-k>", "<C-w>k", opts)5��                         q                     5�_�   *   ,           +          ����                                                                                                                                                                                                                                                                                                                                                       gDme     �         �      +vim.keymap.set("n", "<-l>", "<C-w>l", opts)5��                         �                     5�_�   +   -           ,          ����                                                                                                                                                                                                                                                                                                                                                       gDmf   ! �         �      ,vim.keymap.set("n", "<-tab>", "<c-6>", opts)5��                         �                     5�_�   ,   .           -          ����                                                                                                                                                                                                                                                                                                                                                       gDmj   " �                -vim.keymap.set("n", "<C-tab>", "<c-6>", opts)5��                          �      .               5�_�   -               .           ����                                                                                                                                                                                                                                                                                                                                                       gDmk   $ �                 5��                          �                     5�_�             &              ����                                                                                                                                                                                                                                                                                                                                                        gDmI    �         �      vim.keymap.set5��                                               5�_�                            ����                                                                                                                                                                                                                                                                                                                                                        gDmJ    �         �      vim.keymap.set5��                                               5�_�                            ����                                                                                                                                                                                                                                                                                                                                                        gDmJ    �         �      8vim.keymap.set-- Keep window centered when going up/down5��                                               5�_�                            ����                                                                                                                                                                                                                                                                                                                                                        gDmJ    �         �      /vim.keymap.setvim.keymap.set("n", "J", "mzJ`z")5��                          X                     5�_�                            ����                                                                                                                                                                                                                                                                                                                                                        gDmJ    �         �      5vim.keymap.setvim.keymap.set("n", "<C-d>", "<C-d>zz")5��                          �                     5�_�                            ����                                                                                                                                                                                                                                                                                                                                                        gDmJ    �         �      5vim.keymap.setvim.keymap.set("n", "<C-u>", "<C-u>zz")5��                          �                     5�_�                            ����                                                                                                                                                                                                                                                                                                                                                        gDmJ    �         �      /vim.keymap.setvim.keymap.set("n", "n", "nzzzv")5��                          �                     5�_�                            ����                                                                                                                                                                                                                                                                                                                                                        gDmJ    �         �      /vim.keymap.setvim.keymap.set("n", "N", "Nzzzv")5��                          $                     5�_�                            ����                                                                                                                                                                                                                                                                                                                                                        gDmJ    �         �      vim.keymap.set5��                          T                     5�_�                            ����                                                                                                                                                                                                                                                                                                                                                        gDmJ    �          �      3vim.keymap.set-- Paste without overwriting register5��                          c                     5�_�                             ����                                                                                                                                                                                                                                                                                                                                                        gDmJ    �      !   �      .vim.keymap.setvim.keymap.set("v", "p", '"_dP')5��                          �                     5�_�                    !        ����                                                                                                                                                                                                                                                                                                                                                        gDmJ    �       "   �      vim.keymap.set5��                           �                     5�_�                    "        ����                                                                                                                                                                                                                                                                                                                                                        gDmJ    �   !   #   �      (vim.keymap.set-- Copy text to " register5��    !                      �                     5�_�                    #        ����                                                                                                                                                                                                                                                                                                                                                        gDmJ    �   "   $   �      Zvim.keymap.setvim.keymap.set("n", "<leader>y", "\"+y", { desc = "Yank into \" register" })5��    "                      �                     5�_�                     $        ����                                                                                                                                                                                                                                                                                                                                                        gDmJ    �   #   %   �      Zvim.keymap.setvim.keymap.set("v", "<leader>y", "\"+y", { desc = "Yank into \" register" })5��    #                      Y                     5�_�      !               %        ����                                                                                                                                                                                                                                                                                                                                                        gDmK    �   $   &   �      Zvim.keymap.setvim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "Yank into \" register" })5��    $                      �                     5�_�       "           !   &        ����                                                                                                                                                                                                                                                                                                                                                        gDmK    �   %   '   �      vim.keymap.set5��    %                                           5�_�   !   #           "   '        ����                                                                                                                                                                                                                                                                                                                                                        gDmK    �   &   (   �      )vim.keymap.set-- Delete text to " registe5��    &                                           5�_�   "   $           #   (        ����                                                                                                                                                                                                                                                                                                                                                        gDmK    �   '   )   �      \vim.keymap.setvim.keymap.set("n", "<leader>d", "\"_d", { desc = "Delete into \" register" })5��    '                      H                     5�_�   #   %           $   )        ����                                                                                                                                                                                                                                                                                                                                                        gDmK    �   (   *   �      \vim.keymap.setvim.keymap.set("v", "<leader>d", "\"_d", { desc = "Delete into \" register" })5��    (                      �                     5�_�   $               %   *        ����                                                                                                                                                                                                                                                                                                                                                        gDmK    �   )   +   �      vim.keymap.set5��    )                                           5�_�          	      
           ����                                                                                                                                                                                                                                                                                                                                                        gDm     �         �      ter window navigation   ("n", "<m-h>", "<C-w>h", opts)   ("n", "<m-j>", "<C-w>j", opts)   ("n", "<m-k>", "<C-w>k", opts)   ("n", "<m-l>", "<C-w>l", opts)   ("n", "<m-tab>", "<c-6>", opts)5��                                               �                                               �                          8                     �                          W                     �                          v                     �                          �                     5�_�              
   	           ����                                                                                                                                                                                                                                                                                                                                                        gDm     �         �      ("n", "<m-tab>", "<c-6>", opts)5��                          �                     5�_�                    5        ����                                                                                                                                                                                                                                                                                                                                          :       v���    gDl     �   4   6   �      0- Replace word under cursor across entire buffer5��    4                      �                     5��