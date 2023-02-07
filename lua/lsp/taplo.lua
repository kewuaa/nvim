local taplo = {}
local settings = require('core.settings')
local rootmarks = settings.rootmarks
rootmarks[#rootmarks+1] = '*.toml'


taplo.rootmarks = rootmarks
taplo.filetypes = {'toml'}
taplo.cmd = {settings.toml_path .. 'taplo.exe', 'lsp', 'stdio'}


return taplo
