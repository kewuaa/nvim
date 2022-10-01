local sumneko_lua = {}
local settings = require("settings")
local runtime_path = vim.split(package.path, ';')
local rootmarks = settings.rootmarks()
runtime_path[#runtime_path + 1] = "lua/?.lua"
runtime_path[#runtime_path + 1] = "lua/?/init.lua"


sumneko_lua.rootmarks = rootmarks
sumneko_lua.filetypes = {'lua'}
sumneko_lua.cmd = {settings.lua_path .. 'sumneko_lua/bin/lua-language-server.exe'}
sumneko_lua.settings = {
    Lua = {
        runtime = {
            version = 'LuaJIT',
            path = runtime_path,
        },
        diagnostics = {
            globals = {
                'vim',
                'packer_plugins',
            }
        },
        workspace = {
            library = {
                vim.fn.fnamemodify(vim.fn.expand('$MYVIMRC'), ':h'),
            },
            maxPreload = 100000,
            preloadFileSize = 10000,
        },
        telemetry = { enable = false },
    }
}

return sumneko_lua
