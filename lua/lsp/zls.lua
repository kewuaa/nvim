local zls = {}
local settings = require("core.settings")
local rootmarks = settings.rootmarks
rootmarks[#rootmarks+1] = 'zls.json'
rootmarks[#rootmarks+1] = 'build.zig'


zls.rootmarks = rootmarks
zls.filetypes = {'zig', 'zir'}
zls.cmd = {settings.zig_path .. 'zls/bin/zls.exe'}


return zls
