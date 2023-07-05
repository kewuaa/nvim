local M = {}
local settings = require("core.settings")
local rootmarks = settings.get_rootmarks()
vim.list_extend(rootmarks, {
    "makefile.fpc", "Makefile.fpc"
})

M.pasls = {
    rootmarks = rootmarks,
    filetypes = {'pascal'},
    cmd = {'pasls'},
}

return M
