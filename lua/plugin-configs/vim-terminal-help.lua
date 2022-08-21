local M = {}

function M.setup()
    vim.g.terminal_cwd = 0
    vim.g.terminal_height = 10
    vim.g.terminal_pos = 'rightbelow'
    vim.g.terminal_shell = 'python'
    vim.g.terminal_list = 0
    vim.g.terminal_close = 1
end

return M

