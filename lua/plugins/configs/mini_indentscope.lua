local settings = require("user.settings")
local exclude_fts = settings.exclude_filetypes

vim.list_extend(exclude_fts, settings.exclude_buftypes)
require("mini.indentscope").setup({
    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
        -- Textobjects
        object_scope = 'ii',
        object_scope_with_border = 'ai',

        -- Motions (jump to respective border line; if not present - body line)
        goto_top = '[i',
        goto_bottom = ']i',
    },

    -- Options which control scope computation
    options = {
        try_as_border = true,
    },
})

local group = vim.api.nvim_create_augroup("mini_indentscope", { clear = true })
vim.api.nvim_create_autocmd("BufNew", {
    group = group,
    callback = function(args)
        if vim.tbl_contains(settings.exclude_buftypes, vim.bo[args.buf].buftype)
        or vim.tbl_contains(settings.exclude_filetypes, vim.bo[args.buf].filetype)
        then
            vim.b[args.buf].miniindentscope_disable = true
        end
    end
})
vim.api.nvim_create_autocmd("TermOpen", {
    group = group,
    command = "let b:miniindentscope_disable = v:true",
})
