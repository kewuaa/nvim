local taplo = {}
local settings = require('core.settings')
local rootmarks = settings.get_rootmarks()
rootmarks[#rootmarks+1] = '*.toml'


taplo.rootmarks = rootmarks
taplo.filetypes = {'toml'}
taplo.cmd = {'taplo.exe', 'lsp', 'stdio'}


return taplo
