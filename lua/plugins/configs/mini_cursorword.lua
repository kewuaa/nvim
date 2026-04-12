local settings = require("user.settings")
local mini_cursorword_group = vim.api.nvim_create_augroup("mini_cursorword", {clear = true})

require("mini.cursorword").setup({
    delay = 100
})

local disable = function()
    local ft = vim.bo.filetype
    local buftype = vim.bo.buftype
    if vim.tbl_contains(settings.exclude_filetypes, ft)
        or vim.tbl_contains(settings.exclude_buftypes, buftype) then
        vim.b.minicursorword_disable = true
    end
end

vim.schedule(disable)
vim.api.nvim_create_autocmd("FileType", {
    desc = "disable MiniursorWord on some filetypes",
    group = mini_cursorword_group,
    callback = disable
})
