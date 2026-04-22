require("tokyonight").setup({
    style = "moon",
    styles = {
        functions = { bold = true },
        comments = { italic = true },
        keywords = { italic = true },
    },
    dim_inactive = true,
    plugins = {
        all = false,
        auto = false,
        dap = true,
        indentmini = true,
        ["grug-far"] = true,
        mini_cursorword = true,
        mini_deps = true,
        mini_diff = true,
        mini_files = true,
        mini_icons = true,
        mini_notify = true,
        mini_pick = true,
        mini_statusline = true,
        mini_surround = true,
        rainbow = true,
        treesitter = true,
        vimwiki = true
    }
})

vim.cmd.colorscheme("tokyonight")
