local M = {}

M.init = function()
    vim.api.nvim_create_user_command("BufOnly", function(opts)
        require("utils.buffer").bufonly(opts.bang)
    end, {bang = true})
end

return M
