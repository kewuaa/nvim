local M = {}

function M.setup()
    -- Example config in lua
    vim.g.minimal_italic_functions = true
    vim.g.minimal_italic_comments = false
    vim.g.minimal_transparent_background = false
end

function M.config()
    -- Load the colorscheme
    vim.cmd [[colorscheme minimal]]
end

return M

