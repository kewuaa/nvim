local M = {}
local settings = require("core.settings")
local rootmarks = settings.get_rootmarks()
vim.list_extend(rootmarks, {
    'zls.json',
    'build.zig',
})

M.zls = {
    rootmarks = rootmarks,
}

return M
