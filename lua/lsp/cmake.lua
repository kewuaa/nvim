local cmake_lsp = {}
local settings = require("core.settings")
local rootmarks = settings.rootmarks
---@diagnostic disable-next-line: missing-parameter
vim.list_extend(rootmarks, {'cmake', 'build'})


cmake_lsp.rootmarks = rootmarks
cmake_lsp.filetypes = {'cmake'}
cmake_lsp.cmd = {settings.c_path .. 'cmake_lsp/Scripts/cmake-language-server.exe'}
cmake_lsp.init_options = {
    buildDirectory = 'build'
}

return cmake_lsp
