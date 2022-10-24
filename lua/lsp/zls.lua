local zls = {}
local settings = require("core.settings")
local rootmarks = settings.rootmarks
rootmarks[#rootmarks+1] = 'zls.json'


zls.rootmarks = rootmarks
zls.filetypes = {'zig', 'zir'}
zls.cmd = {settings.zig_path .. 'zls/zig-out/bin/zls.exe'}


return zls
