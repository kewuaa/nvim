local M = {}
local settings = require("core.settings")
local rootmarks = settings.get_rootmarks()
vim.list_extend(rootmarks, {
    '.marksman.toml'
})

M.marksman = {
    rootmarks = rootmarks,
    filetypes = {'markdown'},
    cmd = {'marksman', 'server'}
}

return M
