local M = {}
local settings = require("core.settings")
local rootmarks = settings.get_rootmarks()
vim.list_extend(rootmarks, {
    '*.lpi', '*.lps'
})

M.pasls = {
    rootmarks = rootmarks,
    filetypes = {'pascal'},
    cmd = {'pasls'},
}

return M
