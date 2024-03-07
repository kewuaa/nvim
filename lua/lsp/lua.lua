local M = {}

M.lua_ls = {
    filetypes = {'lua'},
    cmd = {'lua-language-server'},
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
