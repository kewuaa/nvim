local zls = {}
local settings = require("core.settings")
local rootmarks = settings.rootmarks
---@diagnostic disable-next-line: missing-parameter
vim.list_extend(rootmarks, {'zls.json', 'build.zig'})


zls.rootmarks = rootmarks
zls.filetypes = {'zig', 'zir'}
zls.cmd = {settings.zig_path .. 'zls/zig-out/bin/zls.exe'}


return zls
