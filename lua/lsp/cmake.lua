local cmake_lsp = {}
local settings = require("core.settings")
local rootmarks = settings.rootmarks
rootmarks[#rootmarks+1] = 'cmake'
rootmarks[#rootmarks+1] = 'build'


cmake_lsp.rootmarks = rootmarks
cmake_lsp.filetypes = {'cmake'}
cmake_lsp.cmd = {settings.c_path .. 'cmake_lsp/Scripts/cmake-language-server.exe'}
cmake_lsp.init_options = {
    buildDirectory = 'build'
}

return cmake_lsp
