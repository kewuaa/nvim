local M = {}
local settings = require("core.settings")
local rootmarks = settings.get_rootmarks()
---@diagnostic disable-next-line: missing-parameter
vim.list_extend(rootmarks, {
    'zls.json',
    'build.zig',
})

M.zls = {
    rootmarks = rootmarks,
    filetypes = {'zig', 'zir'},
    cmd = {'zls'}
}

return M
