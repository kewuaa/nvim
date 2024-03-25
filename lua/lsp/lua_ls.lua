local M = {}

M.lua_ls = {
    settings = {
        Lua = {
            diagnostics = {
                globals = {
                    'vim',
                }
            },
        }
    }
}

return M
