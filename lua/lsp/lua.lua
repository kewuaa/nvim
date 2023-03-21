local M = {}
local settings = require('core.settings')

M.lua_ls = {
    ---@diagnostic disable-next-line: missing-parameter
    rootmarks = vim.list_extend(settings.get_rootmarks(), {'xmake.lua'}),
    filetypes = {'lua'},
    cmd = {'lua-language-server.exe'},
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            diagnostics = {
                globals = {
                    'vim',
                }
            },
            workspace = {
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
            telemetry = { enable = false },
            -- Do not override treesitter lua highlighting with sumneko lua highlighting
            semantic = { enable = false },
        }
    }
}

return M
