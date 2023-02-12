local sumneko_lua = {}
local settings = require("core.settings")
local rootmarks = settings.rootmarks


sumneko_lua.rootmarks = rootmarks
sumneko_lua.filetypes = {'lua'}
sumneko_lua.cmd = {settings.lua_path .. 'lua-language-server/bin/lua-language-server.exe'}
sumneko_lua.settings = {
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

return sumneko_lua
