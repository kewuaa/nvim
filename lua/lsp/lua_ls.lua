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
            hint = {
                enable = true
            },
            codeLens = {
                enable = true
            }
        }
    }
}

return M
