local mini_git = require("mini.git")

mini_git.setup()

local map = vim.keymap.set
local opts = {silent = true, noremap = true}
map("n", "<leader>gs", mini_git.show_at_cursor, opts)
map("v", "<leader>gs", mini_git.show_range_history, opts)
local bufopts = {
    buffer = 0,
    silent = true,
    noremap = true
}
local mini_git_group = vim.api.nvim_create_augroup("mini_git", {
    clear = true
})
vim.api.nvim_create_autocmd("FileType", {
    group = mini_git_group,
    pattern = "git",
    callback = function()
        map("n", "gs", function()
            mini_git.show_diff_source()
        end, bufopts)
    end
})
