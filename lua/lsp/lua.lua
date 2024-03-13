local M = {}

M.lua_ls = {
    settings = {
        Lua = {
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
