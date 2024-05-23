local M = {}

M.lua_ls = {
    settings = {
        Lua = {
            completion ={
                keywordSnippet = "Disable"
            },
            diagnostics = {
                globals = {
                    'vim',
                }
            },
        }
    }
}

return M
