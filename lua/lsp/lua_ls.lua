local lua_ls = {}
local lua_path = vim.fn.fnamemodify(vim.fn.exepath('lua'), ':p:h')
local settings = require("core.settings")
local rootmarks = settings.get_rootmarks()

lua_ls.rootmarks = rootmarks
lua_ls.filetypes = {'lua'}
lua_ls.cmd = {vim.fn.fnamemodify(lua_path, ':h:h') .. '/lua-language-server/bin/lua-language-server.exe'}
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
