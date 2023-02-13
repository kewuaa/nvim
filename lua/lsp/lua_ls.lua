local lua_ls = {}
local settings = require("core.settings")
local rootmarks = settings.rootmarks


lua_ls.rootmarks = rootmarks
lua_ls.filetypes = {'lua'}
lua_ls.cmd = {settings.lua_path .. 'lua-language-server/bin/lua-language-server.exe'}
lua_ls.settings = {
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

return lua_ls
