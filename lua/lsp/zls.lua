local zls = {}
local zig_path = vim.fn.fnamemodify(vim.fn.exepath('zig'), ':p:h')
local settings = require("core.settings")
local rootmarks = settings.get_rootmarks()
---@diagnostic disable-next-line: missing-parameter
vim.list_extend(rootmarks, {
    'zls.json',
    'build.zig',
})

zls.rootmarks = rootmarks
zls.filetypes = {'zig', 'zir'}
zls.cmd = {vim.fn.fnamemodify(zig_path, ':h') .. '/zls/zig-out/bin/zls.exe'}


return zls
