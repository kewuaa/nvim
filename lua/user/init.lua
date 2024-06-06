local M = {}

M.init = function()
    require("user.options").init()
    require("user.autocmds").init()
    require("user.keymaps").init()
    -- require("user.commands").init()
end

return M
