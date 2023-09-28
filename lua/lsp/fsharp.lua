local M = {}
local settings = require("core.settings")
local rootmarks = settings.get_rootmarks()
vim.list_extend(rootmarks, {"*.fsproj"})

M.fsautocomplete = {
    rootmarks = rootmarks,
    filetypes = {"fsharp"},
    cmd = {"fsautocomplete", "--adaptive-lsp-server-enabled"}
}

return M
