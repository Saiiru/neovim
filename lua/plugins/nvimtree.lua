--[[
    file tree
    plugin: https://github.com/nvim-tree/nvim-tree.lua
]]

return {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        local nvim_tree = require("nvim-tree")
        local icons = require("config.icons.icons")  -- Carregar os ícones personalizados

        -- Ícones específicos para linguagens
        local language_icons = {
            ["js"] = icons.kind.JavaScript,   -- Ícone para arquivos JavaScript
            ["ts"] = icons.kind.TypeScript,    -- Ícone para arquivos TypeScript
            ["py"] = icons.kind.Python,        -- Ícone para arquivos Python
            ["go"] = icons.kind.Go,            -- Ícone para arquivos Go
            ["java"] = icons.kind.Java,        -- Ícone para arquivos Java
            ["html"] = icons.kind.HTML,        -- Ícone para arquivos HTML
            ["css"] = icons.kind.CSS,          -- Ícone para arquivos CSS
            ["php"] = icons.kind.PHP,          -- Ícone para arquivos PHP
            ["rb"] = icons.kind.Ruby,          -- Ícone para arquivos Ruby
            ["rs"] = icons.kind.Rust,          -- Ícone para arquivos Rust
            ["md"] = icons.kind.Markdown,      -- Ícone para arquivos Markdown
            ["sh"] = icons.kind.Shell,         -- Ícone para arquivos Shell
            ["kt"] = icons.kind.Kotlin,        -- Ícone para arquivos Kotlin
            ["swift"] = icons.kind.Swift,      -- Ícone para arquivos Swift
            ["vue"] = icons.kind.Vue,          -- Ícone para arquivos Vue
            ["react"] = icons.kind.React,      -- Ícone para arquivos React
            ["angular"] = icons.kind.Angular,  -- Ícone para arquivos Angular
            ["graphql"] = icons.kind.GraphQL,  -- Ícone para arquivos GraphQL
            ["sql"] = icons.kind.SQL,          -- Ícone para arquivos SQL
            -- Adicione mais extensões conforme necessário
        }

        -- Desabilitar netrw
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        nvim_tree.setup({
            hijack_netrw = true,
            auto_reload_on_write = true,
            sync_root_with_cwd = true,
            filters = {
                dotfiles = true,
            },
            view = {
                side = "left",
                width = 30,
                relativenumber = true,
            },
            renderer = {
                highlight_git = true,
                root_folder_label = function(path)
                    local project = vim.fn.fnamemodify(path, ":t")
                    return string.lower(project)
                end,
                indent_width = 2,
                icons = {
                    webdev_colors = true,
                    glyphs = {
                        default = icons.ui.File,
                        symlink = icons.ui.FileSymlink,
                        bookmark = icons.ui.Bookmark,
                        folder = {
                            default = icons.ui.Folder,
                            open = icons.ui.FolderOpen,
                            symlink = icons.ui.FolderSymlink,
                            arrow_closed = icons.ui.ArrowCircleRight,
                            arrow_open = icons.ui.ArrowCircleDown,
                        },
                        git = {
                            unstaged = icons.git.LineUnstaged,
                            staged = icons.git.LineStaged,
                            unmerged = icons.git.LineUnmerged,
                            renamed = icons.git.FileRenamed,
                            deleted = icons.git.FileDeleted,
                            ignored = icons.git.FileIgnored,
                        },
                    },
                },
            },
 on_attach = function(bufnr)
    -- Configurações de mapeamento de teclas
    local api = require("nvim-tree.api")

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true }
    end

    -- Mapeamentos de teclas (personalize conforme necessário)
    if api.tree.change_root_to_node then
        vim.keymap.set("n", "<C-]>", api.tree.change_root_to_node, opts("CD"))
    end

    if api.node.open.replace_tree_buffer then
        vim.keymap.set("n", "<C-e>", api.node.open.replace_tree_buffer, opts("Open: In Place"))
    end

    if api.node.show_info_popup then
        vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts("Info"))
    end

    if api.fs.rename_sub then
        vim.keymap.set("n", "<C-r>", api.fs.rename_sub, opts("Rename: Omit Filename"))
    end

    if api.node.open.horizontal then
        vim.keymap.set("n", "<C-x>", api.node.open.horizontal, opts("Open: Horizontal Split"))
    end

    if api.node.open.vertical then
        vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts("Open: Vertical Split"))
    end

    if api.fs.remove then
        vim.keymap.set("n", "<C-d>", api.fs.remove, opts("Delete"))
    end

    if api.fs.copy.node then
        vim.keymap.set("n", "<C-c>", api.fs.copy.node, opts("Copy Name"))
    end

    if api.fs.paste then
        vim.keymap.set("n", "<C-p>", api.fs.paste, opts("Paste"))
    end

    -- Mapeamentos adicionais para navegação e manipulação de nós
    if api.node.open.edit then
        vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
    end

    if api.node.navigate.parent_close then
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close"))
    end

    if api.node.open.edit then
        vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open Enter"))
    end

    if api.node.open.vertical then
        vim.keymap.set("n", "v", api.node.open.vertical, opts("Open Vertical Split"))
    end

    if api.node.open.horizontal then
        vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open Horizontal Split"))
    end

    if api.node.refresh then
        vim.keymap.set("n", "r", api.node.refresh, opts("Refresh"))
    end

    if api.fs.create then
        vim.keymap.set("n", "a", api.fs.create, opts("Create"))
    end

    if api.fs.remove then
        vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
    end

    if api.fs.rename then
        vim.keymap.set("n", "R", api.fs.rename, opts("Rename"))
    end

    if api.fs.copy.node then
        vim.keymap.set("n", "y", api.fs.copy.node, opts("Copy"))
    end

    if api.fs.paste then
        vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
    end

    if api.fs.cut then
        vim.keymap.set("n", "c", api.fs.cut, opts("Cut"))
    end

    if api.tree.close then
        vim.keymap.set("n", "q", api.tree.close, opts("Close Tree"))
    end
end,
})
    end,
}

