local M = {}
local user_command = vim.api.nvim_create_user_command

M.init = function()
    user_command("BufOnly", function(opts)
        require("utils.buffer").bufonly(opts.bang)
    end, {bang = true})

    user_command("TypstPreview", function()
        local utils = require("utils")
        local file = utils.wrap_path(vim.fn.expand("%:p"))
        local cmd = ("tinymist preview %s"):format(file)
        utils.run_in_terminal(cmd)
    end, {bang = false})
end

return M
