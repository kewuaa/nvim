local M = {}

function M.setup()
    vim.g.apc_enable_ft = {text = 1, vim = 1, lua = 1, pyrex = 1}
end

return M

