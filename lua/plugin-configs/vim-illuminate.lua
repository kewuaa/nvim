local M = {}

function M.setup()
    vim.api.nvim_create_augroup('setup_illuminate', {
        clear = true
    })
    vim.api.nvim_create_autocmd('FileType', {
        group = 'setup_illuminate',
        pattern = {'python', 'vim', 'lua'},
        command = 'IlluminateResumeBuf',
    })
end

function M.config()
    -- Use background for "Visual" as highlight for words. Change this behavior here!
    if vim.api.nvim_get_hl_by_name("Visual", true).background then
        local illuminate_bg = string.format("#%06x", vim.api.nvim_get_hl_by_name("Visual", true).background)

        vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = illuminate_bg })
        vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = illuminate_bg })
        vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = illuminate_bg })
    end

    require("illuminate").configure({
        providers = {
            "lsp",
            "treesitter",
            "regex",
        },
        delay = 100,
        filetypes_denylist = {
            "fugitive",
            "help",
            "netrw",
            "packer",
            "Outline",
            "NvimTree",
            "Quickfix List",
            "Trouble",
            "lspsagafinder",
            "lspsagaoutline",
        },
        under_cursor = false,
    })
end

return M

